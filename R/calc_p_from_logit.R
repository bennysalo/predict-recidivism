#' Calculate probability from  logit (log odds)
#'
#' @param logit A numerical vector (or single number) with logits.

#' @return A numerical vector (or single number) representing the probability
#'   odds).
#'
#' @examples
#' log_odds <- c(log(0.01/0.99), log(0.25/0.75), log(1/1), log(99/1))
#' calc_p_from_logit(logit = log_odds)
#'
#' @export
calc_p_from_logit <- function(logit) {

  odds        <- exp(logit)
  probability <- odds / (1 + odds)
  return(probability)
}
