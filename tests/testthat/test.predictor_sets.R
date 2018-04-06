context("Included predictors")

FinPrisonMales <-
  readRDS("C:/Users/benny_000/Dropbox/AAAKTUELLT/FinPrisonData/FinPrisonMales.rds")

o_vars       <- stringr::str_subset(names(FinPrisonMales), "^o_")
all_mr       <- stringr::str_subset(names(FinPrisonMales), "_mr$")
missing_info <- stringr::str_subset(names(FinPrisonMales), "_missing$")
other        <- c("ageAtRelease", "ps_escapeHistory")

test_that("static_preds matches variables expected through name patterns", {
  expect_identical(sort(static_preds),
                   sort(c(o_vars, all_mr, missing_info, other))
                   )
})


