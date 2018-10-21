context("Calculate d from R-Squared")

library(recidivismsl)

test_that("function gives correct result", {
  expect_equal(calc_d_from_R2(0.2425356250363329^2), 0.5)
  expect_equal(calc_d_from_R2(0.5), 2)
})

test_that("negative R2 are calculated as negative of equal positive R2", {
  expect_equal(calc_d_from_R2(-1), -calc_d_from_R2(1))
})


test_that("function works with a vector", {
  expect_equal(calc_d_from_R2(c(0.5, -0.5, 0)), c(2, -2, 0))
})
