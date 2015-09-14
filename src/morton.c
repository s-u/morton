#include <stdint.h>

#include <Rinternals.h>

static uint64_t split(const uint32_t a){
    uint64_t x = a;
    x = (x | x << 32) & 0x00000000FFFFFFFF;
    x = (x | x << 16) & 0x0000FFFF0000FFFF;
    x = (x | x << 8)  & 0x00FF00FF00FF00FF;
    x = (x | x << 4)  & 0x0F0F0F0F0F0F0F0F;
    x = (x | x << 2)  & 0x3333333333333333;
    x = (x | x << 1)  & 0x5555555555555555;
    return x;
}

static uint32_t combine(uint64_t x)
{
    x = x & 0x5555555555555555;
    x = (x | (x >> 1)) & 0x3333333333333333;
    x = (x | (x >> 2)) & 0x0F0F0F0F0F0F0F0F;
    x = (x | (x >> 4)) & 0x00FF00FF00FF00FF;
    x = (x | (x >> 8)) & 0x0000FFFF0000FFFF;
    x = (x | (x >> 16)) & 0xFFFFFFFFFFFFFFFF;
    return (uint32_t) x;
}

SEXP to_morton(SEXP sX, SEXP sY) {
    R_xlen_t n = XLENGTH(sX), i;
    if (XLENGTH(sY) != n) Rf_error("the lengths of X and Y must match");
    SEXP res = allocVector(REALSXP, XLENGTH(sX));
    double *d = REAL(res);
    int *x = INTEGER(sX), *y = INTEGER(sY);
    for (i = 0; i < n; i++)
	d[i] = (double) (split(x[i]) | (split(y[i]) << 1));
    return res;
}

SEXP from_morton(SEXP sWhat) {
    R_xlen_t n = XLENGTH(sWhat), i;
    SEXP res = PROTECT(mkNamed(VECSXP, (const char*[]) { "x", "y", "" }));
    int *x = INTEGER(SET_VECTOR_ELT(res, 0, allocVector(INTSXP, n)));
    int *y = INTEGER(SET_VECTOR_ELT(res, 1, allocVector(INTSXP, n)));
    double *d = REAL(sWhat);
    for (i =0; i < n; i++) {
	uint64_t v = (uint64_t) d[i];
	x[i] = (int) combine(v);
	y[i] = (int) combine(v >> 1);
    }
    UNPROTECT(1);
    return res;
}
