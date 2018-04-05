#' Static predictors
#'
#' The static predictors used in the study
#'
#' @format A vector of 24 variable names:
#' \describe{
#'   \item{ageFirstSentence_mr}{Age at first sentence}
#'   \item{ageFirst_missing}{Was the information about 'ageFirstSentence' missing?}
#'   ...
#' }
#' @source Database
"static_preds"


#' Predictions on test set
#'
#' Estimated probabilities of recidivism for the 374 individuals in the test set.
#' Variables starting with 'G_' refer to probabilities of general recidivism and
#' Variables starting with 'V_' refer to probabilities of violent recidivism
#'
#' @format A data frame with 374 observation of 24 variables
#' \describe{
#'   \item{}{}
#'   \item{}{}
#'   ...
#' }
#' @source Database
"predictions"
