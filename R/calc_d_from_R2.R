calc_d_from_R2 <- function(R2) {
  sign <- ifelse(R2 >= 0, 1,-1)
  R2 <- abs(R2)
  r  <- sqrt(R2)
  d  <- (2 * r) / sqrt(1 - r ^ 2)
  d  <- d * sign
  return(d)
}



