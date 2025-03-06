library(plumber)
pr <- plumber::plumb("birthday_api.R")
pr$run(port=8001) 