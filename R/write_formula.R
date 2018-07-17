write_formula <- function(lhs, rhs) {
  as.formula(paste(lhs, "~",  paste(rhs, collapse = " + ")))
}
