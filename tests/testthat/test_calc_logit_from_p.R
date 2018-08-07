context("Calculate logit from probability")

library(recidivismsl)

test_that("logits are calculated for simple cases", {
  expect_equal(calc_logit_from_p(0.3), log(0.3 / 0.7))
  expect_equal(calc_logit_from_p(0.5), log(0.5 / 0.5))
  expect_equal(calc_logit_from_p(0.99), log(0.99 / 0.01))
})

test_that("offset is added correctly to 0 and 1", {
  expect_equal(calc_logit_from_p(0, 0.001), log(0.001 / 0.999))
  expect_equal(calc_logit_from_p(1, 0.0001), log(0.9999 / 0.0001))
})

test_that("offset is not added when probability is not 0 or 1", {
  expect_equal(calc_logit_from_p(0.5, 0.001), log(0.5 / 0.5))
  expect_equal(calc_logit_from_p(0.3, 0.1), log(0.3 / 0.7))
})

test_that("logit of 0 and 1 fails with no offset", {
  expect_error(calc_logit_from_p(0),
               "Probability is 0 or 1, for which logit cannot be calculated")
  expect_error(calc_logit_from_p(1),
               "Probability is 0 or 1, for which logit cannot be calculated")
})

