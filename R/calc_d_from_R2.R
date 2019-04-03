#' Calculate Cohen's d from R-Squared
#'
#' This function transforms R-squared values into Cohen's d assuming
#' equal group sizes. The formula used is from Table 1 in Ruscio (2008).
#' R-square is treated as the square of r.
#'
#' @param R2 R-squared value(s)
#'
#' @return Cohen's d
#' @export
#'
#' @examples
#' calc_d_from_R2(c(0, 0.1, 0.2))
calc_d_from_R2 <- function(R2) {
  sign <- ifelse(R2 >= 0, 1,-1)
  R2 <- abs(R2)
  r  <- sqrt(R2)
  d  <- (2 * r) / sqrt(1 - r ^ 2)
  d  <- d * sign
  return(d)
}



