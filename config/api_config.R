# API Configuration
API_PORTS <- list(
  cointoss = 8000,
  birthday = 8001,
  prisoner = 8003
)

# Server settings
SERVER_HOST <- "127.0.0.1"
DEBUG_MODE <- TRUE

# CORS settings
ALLOWED_ORIGINS <- c("*")  # For development
# ALLOWED_ORIGINS <- c("https://yourdomain.com")  # For production

# Rate limiting
RATE_LIMIT <- list(
  window_seconds = 60,
  max_requests = 100
)
