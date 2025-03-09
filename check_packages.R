required_packages <- c("plumber", "processx", "ggplot2", "jsonlite")

# Function to check and install packages
check_and_install <- function(pkg) {
    if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
        cat(sprintf("Installing package: %s\n", pkg))
        install.packages(pkg, repos = "https://cloud.r-project.org")
    } else {
        cat(sprintf("Package %s is already installed\n", pkg))
    }
}

# Check and install all required packages
for (pkg in required_packages) {
    check_and_install(pkg)
}

cat("\nAll required packages are now installed.\n")
