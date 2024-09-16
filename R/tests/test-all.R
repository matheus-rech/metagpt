library(testthat)
library(here)

# Set the working directory to the project root
setwd(here::here())

# Run all test files
test_dir("R/tests", reporter = "summary")