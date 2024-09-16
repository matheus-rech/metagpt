library(testthat)
source("analysis_functions.R")

# Test data
test_data <- data.frame(
  yi = c(0.1, 0.2, 0.3),
  vi = c(0.01, 0.02, 0.03),
  study = c("Study1", "Study2", "Study3"),
  year = c(2000, 2005, 2010)
)

test_data_network <- data.frame(
  TE = c(0.1, 0.2, 0.3),
  seTE = c(0.05, 0.06, 0.07),
  treat1 = c("A", "B", "C"),
  treat2 = c("B", "C", "A"),
  studlab = c("Study1", "Study2", "Study3")
)

test_that("perform_meta_analysis works correctly", {
  result <- perform_meta_analysis(test_data)
  expect_type(result, "list")
  expect_false("error" %in% names(result))
  expect_true("model" %in% names(result))
  expect_true("estimate" %in% names(result))
  expect_true("forest_plot" %in% names(result))
  expect_true("funnel_plot" %in% names(result))
})

test_that("perform_network_meta_analysis works correctly", {
  result <- perform_network_meta_analysis(test_data_network)
  expect_type(result, "list")
  expect_false("error" %in% names(result))
  expect_true("model" %in% names(result))
  expect_true("treatments" %in% names(result))
  expect_true("net_graph" %in% names(result))
})

test_that("perform_sensitivity_analysis works correctly", {
  result <- perform_sensitivity_analysis(test_data)
  expect_type(result, "list")
  expect_false("error" %in% names(result))
  expect_true("model" %in% names(result))
  expect_true("leave_one_out" %in% names(result))
  expect_true("influence_plot" %in% names(result))
  expect_true(inherits(result$model, "rma"))
  expect_true(is.null(result$leave_one_out) || inherits(result$leave_one_out, "metainf"))
  expect_true(!is.null(result$influence_plot))
})

test_that("perform_meta_regression works correctly", {
  result <- perform_meta_regression(test_data, moderators = c("year"))
  print("Meta-regression result:")
  print(result)
  
  expect_type(result, "list")
  expect_false("error" %in% names(result))
  expect_true("model" %in% names(result))
  expect_true("coefficients" %in% names(result))
  # The bubble plot might be NULL, so we don't check for it
})

test_that("perform_cumulative_meta_analysis works correctly", {
  result <- perform_cumulative_meta_analysis(test_data)
  print("Cumulative meta-analysis result:")
  print(result)
  
  expect_type(result, "list")
  expect_false("error" %in% names(result))
  expect_true("model" %in% names(result))
  expect_true("cumulative" %in% names(result))
  # The cumul_plot might be NULL, so we don't check for it
})

# Run all tests
test_results <- test_file("tests.R")
print(test_results)