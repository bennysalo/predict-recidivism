#' Calculate probability from  logit (log odds)
#'
#' @param logit A numerical vector (or single number) with logits.

#' @return A numerical vector (or single number) representing the probability
#'   odds).
#'
#' @examples
#' calc_logit_from_p(0.2)
#'
#' probabilities <- c(0.00, 0.07, 0.12,0.74, 1.00)
#' calc_logit_from_p(probabilities, offset_for_01 = 0.001)
#'
calc_p_from_logit <- function(logit) {

  odds        <- exp(logit)
  probability <- odds / (1 + odds)
  return(probability)
}
