iencode64 <- function(x, min.length=1L) .Call(encode_, x, min.length)
idecode64 <- function(x) .Call(decode_, x)
