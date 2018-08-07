
#' Caclulate logit (log odds) from probability
#'
#' @param probability A number between 0 and 1.
#'
#' @return Logit (log odds)
#'
#' @examples
#' calc_logit_from_p(0.2)
calc_logit_from_p <- function(probability) {
  if(probability %in% c(0,1)) {
    stop("Probability is 0 or 1, for which logit cannot be calculated",
         .call = FALSE)
  } else if (probability > 1 | probability < 0) {
    stop("Probability is not between 0 and 1",
         .call = FALSE)
  }
  logit <- probability / (1-probability)
  return(logit)
}
