\name{iencode64}
\alias{iencode64}
\alias{idecode64}
\title{
  Encode/decode 64-bit integer numbers as short strings
}
\description{
  \code{iencode64} encodes up to 64-bit intgers numbers into a concise
  ASCII string representation. It uses the same table as base64
  encoding, but encodes only as many characters as are necessary to
  include the most significant bit set to 1.
}
\usage{
iencode64(x, min.length = 1L)
idecode64(x)
}
\arguments{
  \item{x}{\code{iencode64}: numeric vector of values to encode. Reals
  are truncated to 64-bit unsigned integer values.

  \code{idecode64}: character vector fo encoded values.}
  \item{min.length}{integer, minimal length of the encoded strings.}
}
\details{
  Although the encoding is closely related to base64 encoding, it is
  not the same, because it encodes only as many 6-bit groups as are
  needed. They are identical for 24-bit and 48-bit encoded integers
  (i.e., 4 and 8 character iencoding) if the integer was stored as
  big-endian.

  Numeric values are truncated to 64-bit unsigned integers before
  encoding.
}
\value{
\code{iencode64}: character vector of encoded values

\code{idecode64}: numeric vector of decoded values (integers)
}
\author{
Simon Urbanek
}
\note{
  Missing values (\code{NA}) are preserved.
}
\examples{
  iencode64(1234)

  idecode64("ABC")

  if (isTRUE(require(base64enc, quietly=TRUE))) {
    print(a <- iencode64(0x123456))
    print(base64decode(a))
    ## it has to be 4 or 8 character representation
    print(b <- iencode64(0x1234, 4))
    print(base64decode(b))
  }
}
\keyword{manip}
