#include <stdint.h>

#include <Rinternals.h>

static const char *b64tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

static char buf[64];

static const char *encode_num(uint64_t n, int min_len) {
    char *c = buf + sizeof(buf) - 1;
    *(c--) = 0;
    while (n) {
	*(c--) = b64tab[n & 63];
	n >>= 6;
	min_len--;
    }
    while ((min_len--) > 0) *(c--) = 'A';
    return c + 1;
}

static uint64_t decode_num(const char *c) {
    uint64_t a = 0;
    while (*c) {
        if (*c >= 'A' && *c <= 'Z') {
	    a <<= 6; 
	    a |= (unsigned char) (*c - 'A');
	} else if (*c >= 'a' && *c <= 'z') {
	    a <<= 6; 
	    a |= (unsigned char) (*c - 'a' + 26);
	} else if (*c >= '0' && *c <= '9') {
	    a <<= 6; 
	    a |= (unsigned char) (*c - '0' + 52);
	} else if (*c == '+') {
	    a <<= 6; 
	    a |= 62;
	} else if (*c == '/') {
	    a <<= 6; 
	    a |= 63;
	} else break;
	c++;
    }
    return a;
}

SEXP encode_(SEXP sWhat, SEXP sMinLen) {
    int np = 1, min_len = asInteger(sMinLen);
    R_xlen_t i, n = XLENGTH(sWhat);
    if (min_len > 22) Rf_error("invalid min.length, cannot exceed 22");
    SEXP res = PROTECT(allocVector(STRSXP, n));
    if (TYPEOF(sWhat) == INTSXP) {
	int *d = INTEGER(sWhat);
	for (i = 0; i < n; i++)
	    if (d[i] != NA_INTEGER)
		SET_STRING_ELT(res, i, mkChar(encode_num((uint64_t)d[i], min_len)));
    } else {
	if (TYPEOF(sWhat) != REALSXP) {
	    sWhat = PROTECT(coerceVector(sWhat, REALSXP));
	    np++;
	}
	if (n != XLENGTH(sWhat))
	    Rf_error("coresion to numeric has changed the length");
	double *d = REAL(sWhat);
	for (i = 0; i < n; i++)
	    if (!R_IsNA(d[i]))
		SET_STRING_ELT(res, i, mkChar(encode_num((uint64_t)d[i], min_len)));
    }
    UNPROTECT(np);
    return res;
}

SEXP decode_(SEXP sWhat) {
    if (TYPEOF(sWhat) != STRSXP)
	Rf_error("input must be a character vector");
    R_xlen_t i, n = XLENGTH(sWhat);
    SEXP res = allocVector(REALSXP, n);
    double *d = REAL(res);
    for (i = 0; i < n; i++) {
	SEXP el = STRING_ELT(sWhat, i);
	d[i] = (el == R_NaString) ? NA_REAL : ((double) decode_num(CHAR(el)));
    }
    return res;
}
