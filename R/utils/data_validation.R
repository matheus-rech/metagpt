source("R/utils/error_handling.R")

validate_meta_analysis_data <- function(data) {
  if (!is.data.frame(data)) {
    stop("Input must be a data frame")
  }
  required_cols <- c("yi", "vi")
  if (!all(required_cols %in% names(data))) {
    stop(paste("Data must contain columns:", paste(required_cols, collapse = ", ")))
  }
  if (!is.numeric(data$yi) || !is.numeric(data$vi)) {
    stop("yi and vi must be numeric")
  }
  if (any(data$vi <= 0, na.rm = TRUE)) {
    stop("vi must be positive")
  }
}

validate_network_meta_analysis_data <- function(data) {
  if (!is.data.frame(data)) {
    stop("Input must be a data frame")
  }
  required_cols <- c("TE", "seTE", "treat1", "treat2", "studlab")
  if (!all(required_cols %in% names(data))) {
    stop(paste("Data must contain columns:", paste(required_cols, collapse = ", ")))
  }
  if (!is.numeric(data$TE) || !is.numeric(data$seTE)) {
    stop("TE and seTE must be numeric")
  }
  if (any(data$seTE <= 0, na.rm = TRUE)) {
    stop("seTE must be positive")
  }
}

validate_meta_regression_data <- function(data, moderators) {
  validate_meta_analysis_data(data)
  if (!is.character(moderators) || length(moderators) == 0) {
    stop("moderators must be a non-empty character vector")
  }
  if (!all(moderators %in% names(data))) {
    missing_mods <- setdiff(moderators, names(data))
    stop(paste("The following moderators are not present in the data:", paste(missing_mods, collapse = ", ")))
  }
}

# Cumulative meta-analysis validation function removed as it's no longer used