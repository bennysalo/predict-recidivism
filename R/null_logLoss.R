null_logLoss <- function(observed) {
  n_1 <- sum(observed == 1)
  n_0 <- sum(observed == 0)

  rate <- mean(observed == 1)

  null_logLoss <- -1 * (n_1 * log(rate) + n_0 * log(1 - rate)) / (n_1 + n_0)
  return(null_logLoss)
}


