#!/usr/bin/env Rscript

# Function to start a server
start_server <- function(api_file, port, name) {
    cat(sprintf("Starting %s API server...\n", name))
    system(sprintf(
        "R -e \"library(plumber); pr <- plumb('%s'); pr\\$run(port=%d)\" &",
        api_file, port
    ))
}

# Start all servers
start_server("cointoss/cointoss_api.R", 8000, "Coin Toss")
start_server("birthday/birthday_api.R", 8001, "Birthday Paradox")
start_server("prisoner/prisoner_api.R", 8003, "Prisoner's Dilemma")

cat("\nServers started successfully:")
cat("\n- Coin Toss API running on port 8000")
cat("\n- Birthday Paradox API running on port 8001")
cat("\n- Prisoner's Dilemma API running on port 8003")
cat("\n\nPress Ctrl+C to stop the servers\n")