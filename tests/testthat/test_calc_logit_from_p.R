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

test_that("offset is used with all 0's and 1's in a vector", {
  expect_equal(calc_logit_from_p(c(0, 0.5, 1), offset_for_01 = 0.01),
                                 c(log(0.01 / 0.99), log(0.5 / 0.5), log(0.99 /0.01)))

})

test_that("offset is not added when probability is not 0 or 1", {
  expect_equal(calc_logit_from_p(0.5, 0.001), log(0.5 / 0.5))
  expect_equal(calc_logit_from_p(0.3, 0.1), log(0.3 / 0.7))
})

test_that("logit of 0 and 1 fails when there is no offset", {
  expect_error(calc_logit_from_p(0),
               "Probability is 0 or 1, for which logit cannot be calculated")
  expect_error(calc_logit_from_p(1),
               "Probability is 0 or 1, for which logit cannot be calculated")
})

test_that("calc_p_form_logit and calc_logit_from_p are inverse functions", {
  expect_equal(c(0.1, 0.5, 0.7),
               calc_p_from_logit(calc_logit_from_p(c(0.1, 0.5, 0.7))))
  expect_equal(c(-2, 0, 1),
               calc_logit_from_p(calc_p_from_logit(c(-2, 0, 1))))

})

