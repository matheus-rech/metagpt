library(testthat)
source("R/tests/setup.R")

test_that("perform_network_meta_analysis works correctly", {
  result <- perform_network_meta_analysis(test_data_network)
  expect_type(result, "list")
  expect_false("error" %in% names(result))
  expect_true("model" %in% names(result))
  expect_true("treatments" %in% names(result))
  expect_true("net_graph" %in% names(result))
  expect_true("net_structure" %in% names(result))
  expect_true("forest_plot" %in% names(result))
})

test_that("check_consistency works correctly", {
  net <- perform_network_meta_analysis(test_data_network)$model
  consistency <- check_consistency(net)
  expect_s3_class(consistency, "netsplit")
})

test_that("rank_treatments works correctly", {
  net <- perform_network_meta_analysis(test_data_network)$model
  ranking <- rank_treatments(net)
  expect_type(ranking, "list")
  expect_true("ranking.fixed" %in% names(ranking))
  expect_true("ranking.random" %in% names(ranking))
})

# Add more specific tests for network meta-analysis here