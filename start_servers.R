library(processx)

# Function to start a server
start_server <- function(api_file, port) {
    process$new(
        "R",
        c("-e", sprintf("library(plumber); pr <- plumb('%s'); pr$run(port=%d)", api_file, port)),
        echo = TRUE,
        stderr = "|"
    )
}

# Start servers
tryCatch({
    cat("Starting Coin Toss API server...\n")
    cointoss_server <- start_server("cointoss_api.R", 8000)
    
    cat("Starting Birthday Paradox API server...\n")
    birthday_server <- start_server("birthday_api.R", 8001)
    
    cat("\nServers started successfully:\n")
    cat("- Coin Toss API running on port 8000\n")
    cat("- Birthday Paradox API running on port 8001\n")
    cat("\nPress Ctrl+C to stop the servers\n")
    
    # Monitor servers
    while(TRUE) {
        Sys.sleep(1)
        
        # Check if servers are still running
        if (!cointoss_server$is_alive()) {
            cat("\nCoin Toss server stopped unexpectedly. Restarting...\n")
            cointoss_server <- start_server("cointoss_api.R", 8000)
        }
        if (!birthday_server$is_alive()) {
            cat("\nBirthday Paradox server stopped unexpectedly. Restarting...\n")
            birthday_server <- start_server("birthday_api.R", 8001)
        }
    }
}, error = function(e) {
    cat("\nError:", e$message, "\n")
}, finally = {
    # Cleanup when script is interrupted
    if (exists("cointoss_server") && cointoss_server$is_alive()) {
        cointoss_server$kill()
    }
    if (exists("birthday_server") && birthday_server$is_alive()) {
        birthday_server$kill()
    }
    cat("\nServers stopped.\n")
}) 