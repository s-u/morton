toMorton <- function(x, y) .Call(to_morton, as.integer(x), as.integer(y))

fromMorton <- function(m) .Call(from_morton, as.double(m))

