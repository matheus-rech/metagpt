library(testthat)
library(here)

# Set the working directory to the project root
setwd(here::here())

# Print current working directory
print(getwd())

# Check if files exist
print(file.exists("R/utils/data_validation.R"))
print(file.exists("R/utils/error_handling.R"))
print(file.exists("R/analysis/meta_analysis.R"))
print(file.exists("R/analysis/network_meta_analysis.R"))
print(file.exists("R/analysis/sensitivity_analysis.R"))
print(file.exists("R/analysis/meta_regression.R"))
print(file.exists("R/plotting/plotting.R"))
print(file.exists("R/utils/utils.R"))

# Source all necessary R files
source("R/utils/data_validation.R")
source("R/utils/error_handling.R")
source("R/analysis/meta_analysis.R")
source("R/analysis/network_meta_analysis.R")
source("R/analysis/sensitivity_analysis.R")
source("R/analysis/meta_regression.R")
# source("R/analysis/cumulative_meta_analysis.R")  # Commented out
source("R/plotting/plotting.R")
source("R/utils/utils.R")

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

# Add any other common setup code or helper functions here