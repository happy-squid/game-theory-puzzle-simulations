# Setup script for development environment

# Required packages
required_packages <- c(
  "plumber",
  "ggplot2",
  "jsonlite",
  "testthat",
  "devtools",
  "roxygen2",
  "knitr"
)

# Install missing packages
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) {
  install.packages(new_packages)
}

# Create necessary directories
dirs <- c(
  "logs",
  "data/cache",
  "data/temp"
)

for(dir in dirs) {
  if(!dir.exists(dir)) {
    dir.create(dir, recursive = TRUE)
  }
}
