
#' Calculate logit (log odds) from probability
#'
#' @param probability A numerical vector (or single number) with probabilities
#'   between 0 and 1.
#' @param offset_for_01 A decimal number to add to probability 0 or subtract from 1 to make
#'   calculation of logit possible.
#'
#' @return A numerical vector (or single number) representing the logit (log
#'   odds).
#'
#' @examples
#' calc_logit_from_p(0.2)
#'
#' probabilities <- c(0.00, 0.07, 0.12,0.74, 1.00)
#' calc_logit_from_p(probabilities, offset_for_01 = 0.001)
#'
#' @export
calc_logit_from_p <- function(probability, offset_for_01 = NULL) {

# Use offset if provided
  if(!is.null(offset_for_01)) {
    probability[probability == 0] <- 0 + offset_for_01
    probability[probability == 1] <- 1 - offset_for_01
  }

# Inform that logits cannot be caluclated when p = 0 or 1
  if(any(probability %in% c(0,1))) {
    stop("Probability is 0 or 1, for which logit cannot be calculated",
         .call = FALSE)
  } else if (any(probability > 1 | probability < 0)) {
    stop("One or more probabilities are not between 0 and 1",
         .call = FALSE)
  }
  logit <- log(probability / (1-probability))
  return(logit)
}
