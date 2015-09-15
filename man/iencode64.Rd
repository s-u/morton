\name{iencode64}
\alias{iencode64}
\alias{idecode64}
\title{
  Encode/decode 64-bit integer numbers as short strings
}
\description{
  \code{iencode64} encodes up to 64-bit intgers numbers into a concise
  ASCII string representation. It uses the same characters as base64
  encoding, but in strictly lexicographically ascending order and
  encodes only as many characters as are necessary to include the most
  significant bit set to 1.
}
\usage{
iencode64(x, min.length = 1L)
idecode64(x)
}
\arguments{
  \item{x}{\code{iencode64}: numeric vector of values to encode. Reals
  are truncated to 64-bit unsigned integer values.

  \code{idecode64}: character vector of encoded values.}
  \item{min.length}{integer, minimal length of the encoded strings.}
}
\details{
  Although the encoding is closely related to base64 encoding, it is
  not the same, because it encodes only as many 6-bit groups as are
  needed and the order of the characters is different. However, due to
  the design that characters in the encoding table are in
  lexicographically ascending order, the lexicographical order of the
  strings (as long as they are all left-padded to the same length) is
  equal to the order of the encoded values.

  Numeric values are truncated to 64-bit unsigned integers before
  encoding.

  Decoding of a value stops if a character outside of the b64 alphabet
  (alphanumeric, plus and slash) is encountered. If the value
  overflows (more than 64 bits are encoded) the behavior is undefined
  (currently the code discards MSB that are beyond 64-bit).
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

  x = floor(runif(100, 0, 2^32))
  iencode64(x[1:10])
  stopifnot(x == idecode64(iencode64(x)))
}
\keyword{manip}
