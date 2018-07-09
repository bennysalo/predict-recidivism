calc_d_from_AUC <- function(AUC) {
  sqrt(2) * qnorm(AUC)
}
