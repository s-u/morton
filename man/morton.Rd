\name{morton}
\alias{morton}
\alias{toMorton}
\alias{fromMorton}
\title{
  Convert to/from 2D Morton code
}
\description{
  \code{toMorton} converts 2D coordinates x, y to Morton code

  \code{fromMorton} converts from Morton code to 2D x, y coordinates
}
\usage{
toMorton(x, y)
fromMorton(m)
}
\arguments{
  \item{x}{numeric, non-negative, x coordinate}
  \item{y}{numeric, non-negative, y coordinate}
  \item{m}{morton-encoded integer}
}
\details{
  Two-dimensional Morton code maps 2D coordinates to a one dimension
  while preserving some locatily of the points. This implementation
  uses 32-bit integer x, y coordinates and coverts them to 64-bit
  integer interleaving the bits (with x having the LSB). In R the
  result is stored in a real vector which is only guaranteed to
  preserve 52 bits and thus results with more than 26 bits will have
  small errors in the lower bits when decoded.
}
\value{
  \code{toMorton} returns a real vector

  \code{fromMorton} returns a list with components
  \item{x}{x coordinate}
  \item{y}{y coordinate}
}
%\references{
%}
\author{
Simon Urbanek
}
\examples{
toMorton(c(0,1,0,1), c(0,0,1,1))

m <- toMorton(123, 456)
fromMorton(m)

## typically, it is used to encode coordinates
## as a short geohash
d <- iencode64(m)
(d)
fromMorton(idecode64(d))

## it is reliable in 26-bit range
x <- floor(runif(1000,, 2^26))
y <- floor(runif(1000,, 2^26))
m <- toMorton(x, y)
r <- fromMorton(m)
stopifnot(x == r$x && y == r$y)

}
\keyword{manip}
