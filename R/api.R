library(plumber)
library(jsonlite)
library(memoise)
library(future)
library(promises)
library(validator)

# Source individual analysis files
source("R/analysis/meta_analysis.R")
source("R/analysis/network_meta_analysis.R")
source("R/analysis/sensitivity_analysis.R")
source("R/analysis/meta_regression.R")
source("R/utils/data_validation.R")
source("R/utils/error_handling.R")

# Caching mechanism with expiration
mem_perform_meta_analysis <- memoise(perform_meta_analysis, ~memoise::timeout(3600))
mem_perform_network_meta_analysis <- memoise(perform_network_meta_analysis, ~memoise::timeout(3600))
mem_perform_sensitivity_analysis <- memoise(perform_sensitivity_analysis, ~memoise::timeout(3600))
mem_perform_meta_regression <- memoise(perform_meta_regression, ~memoise::timeout(3600))

# Data validation rules
meta_analysis_rules <- validator(
  yi = field_present("yi"),
  vi = field_present("vi"),
  yi_numeric = is.numeric(yi),
  vi_numeric = is.numeric(vi),
  vi_positive = vi > 0
)

network_meta_analysis_rules <- validator(
  TE = field_present("TE"),
  seTE = field_present("seTE"),
  treat1 = field_present("treat1"),
  treat2 = field_present("treat2"),
  studlab = field_present("studlab"),
  TE_numeric = is.numeric(TE),
  seTE_numeric = is.numeric(seTE),
  seTE_positive = seTE > 0
)

#* Perform Standard Meta-Analysis
#* @post /perform_meta_analysis
function(req, res) {
  future_promise({
    params <- jsonlite::fromJSON(req$postBody)
    data <- as.data.frame(params$data)
    effect_size <- params$effect_size
    method <- params$method
    reference <- params$reference

    result <- mem_perform_meta_analysis(data, effect_size, method, reference)
    list(result = result, status = 200)
  }) %...>% 
    (function(result) {
      res$setHeader("Content-Type", "application/json")
      res$status <- result$status
      res$body <- jsonlite::toJSON(result$result, auto_unbox = TRUE, null = "null")
    }) %...!% 
    (function(e) {
      res$status <- 400
      res$setHeader("Content-Type", "application/json")
      res$body <- jsonlite::toJSON(list(error = paste("Error in meta-analysis:", e$message)), auto_unbox = TRUE)
    })
}

#* Perform Network Meta-Analysis
#* @post /perform_network_meta_analysis
function(req, res) {
  future_promise({
    params <- jsonlite::fromJSON(req$postBody)
    data <- as.data.frame(params$data)

    # Data validation
    validation_result <- confront(data, network_meta_analysis_rules)
    if (!all(validation_result)) {
      stop(paste("Data validation failed:", summary(validation_result)))
    }

    result <- mem_perform_network_meta_analysis(data)
    list(result = result, status = 200)
  }) %...>% 
    (function(result) {
      res$setHeader("Content-Type", "application/json")
      res$status <- result$status
      res$body <- jsonlite::toJSON(result$result, auto_unbox = TRUE, null = "null")
    }) %...!% 
    (function(e) {
      res$status <- 400
      res$setHeader("Content-Type", "application/json")
      res$body <- jsonlite::toJSON(list(error = paste("Error in network meta-analysis:", e$message)), auto_unbox = TRUE)
    })
}

#* Perform Sensitivity Analysis
#* @post /perform_sensitivity_analysis
function(req, res) {
  future_promise({
    params <- jsonlite::fromJSON(req$postBody)
    data <- as.data.frame(params$data)
    effect_size <- params$effect_size
    method <- params$method

    # Data validation
    validation_result <- confront(data, meta_analysis_rules)
    if (!all(validation_result)) {
      stop(paste("Data validation failed:", summary(validation_result)))
    }

    result <- mem_perform_sensitivity_analysis(data, effect_size, method)
    list(result = result, status = 200)
  }) %...>% 
    (function(result) {
      res$setHeader("Content-Type", "application/json")
      res$status <- result$status
      res$body <- jsonlite::toJSON(result$result, auto_unbox = TRUE, null = "null")
    }) %...!% 
    (function(e) {
      res$status <- 400
      res$setHeader("Content-Type", "application/json")
      res$body <- jsonlite::toJSON(list(error = paste("Error in sensitivity analysis:", e$message)), auto_unbox = TRUE)
    })
}

#* Perform Meta-Regression
#* @post /perform_meta_regression
function(req, res) {
  future_promise({
    params <- jsonlite::fromJSON(req$postBody)
    data <- as.data.frame(params$data)
    moderators <- params$moderators
    effect_size <- params$effect_size
    method <- params$method

    # Data validation
    validation_result <- confront(data, meta_analysis_rules)
    if (!all(validation_result)) {
      stop(paste("Data validation failed:", summary(validation_result)))
    }

    result <- mem_perform_meta_regression(data, moderators, effect_size, method)
    list(result = result, status = 200)
  }) %...>% 
    (function(result) {
      res$setHeader("Content-Type", "application/json")
      res$status <- result$status
      res$body <- jsonlite::toJSON(result$result, auto_unbox = TRUE, null = "null")
    }) %...!% 
    (function(e) {
      res$status <- 400
      res$setHeader("Content-Type", "application/json")
      res$body <- jsonlite::toJSON(list(error = paste("Error in meta-regression:", e$message)), auto_unbox = TRUE)
    })
}

# Commenting out the cumulative meta-analysis endpoint
# #* Perform Cumulative Meta-Analysis
# #* @post /perform_cumulative_meta_analysis
# function(req, res) {
#   # Endpoint body commented out
# }

#* @post /meta-analysis
function(req) {
  query <- req$body$query
  # Process the query and return results
  # This should match the structure expected by your frontend
}