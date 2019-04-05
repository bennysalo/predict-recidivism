#' Calculate Cohen's d from AUC
#'
#' This function transforms AUC values into Cohen's d assuming
#' equal group sizes. The formula used is from Table 1 in Ruscio (2008).
#'
#' @param AUC AUC-value(s)
#'
#' @return Cohen's d value(s)
#' @export
#'
#' @examples
#' calc_d_from_AUC(c(0.5, 0.7, 0.9))
calc_d_from_AUC <- function(AUC) {
  sqrt(2) * qnorm(AUC)
}
