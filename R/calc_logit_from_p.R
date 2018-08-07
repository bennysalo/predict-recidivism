
#' Caclulate logit (log odds) from probability
#'
#' @param probability A number between 0 and 1.
#' @param offset_for_01 A number to add to 0 or subtract from 1 to make
#'   calculation of logit possible.
#'
#' @return Logit (log odds)
#'
#' @examples
#' calc_logit_from_p(0.2)
calc_logit_from_p <- function(probability, offset_for_01 = NULL) {

# Use offset if provided
  if(!is.null(offset_for_01) & probability == 0) {
    probability <- offset_for_01
  }

  if(!is.null(offset_for_01) & probability == 1) {
    probability <- 1 - offset_for_01
  }

# Inform that logits cannot be caluclated when p = 0 or 1
  if(probability %in% c(0,1)) {
    stop("Probability is 0 or 1, for which logit cannot be calculated",
         .call = FALSE)
  } else if (probability > 1 | probability < 0) {
    stop("Probability is not between 0 and 1",
         .call = FALSE)
  }
  logit <- log(probability / (1-probability))
  return(logit)
}
