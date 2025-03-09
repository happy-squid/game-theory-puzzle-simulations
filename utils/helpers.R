# Common utility functions for simulations

# Validate numeric input
validate_numeric <- function(value, min_val, max_val, param_name) {
  if (!is.numeric(value) || value < min_val || value > max_val) {
    stop(sprintf("%s must be between %d and %d", param_name, min_val, max_val))
  }
}

# Format probability output
format_probability <- function(prob) {
  return(round(prob, 3))
}

# Generate random data with seed
generate_random_data <- function(n, seed = NULL) {
  if (!is.null(seed)) {
    set.seed(seed)
  }
  return(runif(n))
}

# Error response formatter
format_error_response <- function(error_msg) {
  list(
    error = TRUE,
    message = error_msg,
    timestamp = format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  )
}

# Success response formatter
format_success_response <- function(data) {
  list(
    error = FALSE,
    data = data,
    timestamp = format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  )
}

# Logger function
log_event <- function(event_type, message, data = NULL) {
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  log_entry <- sprintf("[%s] %s: %s", timestamp, event_type, message)
  if (!is.null(data)) {
    log_entry <- paste0(log_entry, "\nData: ", jsonlite::toJSON(data))
  }
  cat(log_entry, "\n", file = "logs/app.log", append = TRUE)
}
