#Puzzles 2
# Varad & Hardik

#Birthday Paradox

# source("start_servers.R")

#================================================


library(lubridate)  # For date handling
library(dplyr)  # For data manipulation

# Load ggplot2 for visualization
library(ggplot2)

set.seed(42)  # Ensures reproducibility

# Get user's birthday
day <- as.numeric(readline("Enter your birth day (1-31): "))
month <- as.numeric(readline("Enter your birth month (1-12): "))

# Convert to day of the year
days_in_month <- c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
day_of_year <- sum(days_in_month[1:(month-1)]) + day

cat("\nYour birthday is day", day_of_year, "of the year.\n")

# Get user input for number of people & simulations
n <- as.numeric(readline("Enter number of people in the room (n): "))
s <- as.numeric(readline("Enter number of simulations (s): "))

# Simulate the experiment s times
results <- replicate(s, sample(1:365, n, replace = TRUE))

# Count occurrences of each birthday
birthday_counts <- sort(table(sample(1:365, n, replace = TRUE)), decreasing = TRUE)

# Compute theoretical probability of at least two people sharing a birthday
probability_birthday_match <- 1 - prod((365:(365-n+1)) / 365)

cat("\nThe probability that at least two people in a room of", n, "share a birthday is:",
    round(probability_birthday_match * 100, 2), "%\n")


# Convert birthday_counts to a data frame and filter out zero occurrences
df_birthdays <- data.frame(
  Birthday = as.numeric(names(birthday_counts)),
  Count = as.numeric(birthday_counts)
) %>% subset(Count > 0)  # Keep only birthdays with at least one occurrence

# Plot the filtered birthday frequency distribution
ggplot(df_birthdays, aes(x = Birthday, y = Count)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme_minimal() +
  labs(
    title = "Birthday Frequency Distribution ",
    x = "Day of the Year (1-365)",
    y = "Count of Occurrences"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# Find the most common birthday
most_common_birthday <- as.numeric(names(birthday_counts[1]))

# Convert back to day/month format
month_days <- cumsum(days_in_month)
common_month <- which(most_common_birthday <= month_days)[1]
common_day <- most_common_birthday - (ifelse(common_month > 1, month_days[common_month - 1], 0))

cat("\nThe most common birthday in the sampled data is:", sprintf("%02d%02d", common_day, common_month), "(DDMM format)\n")


#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^