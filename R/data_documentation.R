#' Variable table
#'
#' Variable names, labels, the role they play in the analyses and comments.
#' For RITA-items comments this includes the full wording of the item translated
#' from english by the study authors.
#'
#' @format A data frame with 53940 rows and 10 variables:
#' \describe{
#'   \item{Variable}{Variable name as used in R scripts}
#'   \item{Label}{Short descriptive label}
#'   \item{Role}{The role the variable plays in the analyses.
#'   Can be outcome, predictor_static, predictor_dynamic, predictor_term, or descriptive}
#'   \item{Comment}{Additional comments.}
#'   ...
#' }
#' @source variable_table.csv compiled by Benny Salo
"variable_table"

#' Discrimination of models in training set.y
#'
#' .
#' The 'values' element contains a data frame with 100 rows of the results in
#' the 10 by 10 fold cross-validation. For each model the ROC(AUC),
#' is recorded along with sensitivity and specificity for decision cutoff of 0.5.
#' That gives us 24 model x 3 measures = 72 columns. With the resample numbers
#' that is 73 columns.
#'
#' @format A list with 6 elements of class 'resamples' created by
#' 'caret::resamples'
#' @seealso caret::resamples
#'
#' @source Scripts for how the results were created are stored in /data-raw
"model_AUCs_training_set"

