custom_error <- function(type, message) {
  structure(list(type = type, message = message), class = "custom_error")
}

handle_error <- function(e) {
  if (inherits(e, "custom_error")) {
    return(list(error = e$message, type = e$type))
  } else {
    return(list(error = "An unexpected error occurred", type = "unknown"))
  }
}