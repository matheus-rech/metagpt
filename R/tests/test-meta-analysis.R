library(testthat)
source("R/tests/setup.R")

test_that("perform_meta_analysis works correctly", {
  result <- perform_meta_analysis(test_data)
  expect_type(result, "list")
  expect_false("error" %in% names(result))
  expect_true("model" %in% names(result))
  expect_true("estimate" %in% names(result))
  expect_true("forest_plot" %in% names(result))
  expect_true("funnel_plot" %in% names(result))
  expect_true("summary_table" %in% names(result))
})

test_that("perform_meta_analysis handles different effect sizes", {
  for (effect_size in c("SMD", "MD", "OR", "RR", "RD")) {
    result <- perform_meta_analysis(test_data, effect_size = effect_size)
    expect_equal(result$measure, effect_size)
  }
})

test_that("perform_meta_analysis handles invalid input correctly", {
  invalid_data <- data.frame(x = c(1, 2, 3), y = c(4, 5, 6))
  expect_error(perform_meta_analysis(invalid_data), "Data must contain required columns")
})

# Add more specific tests for meta-analysis here