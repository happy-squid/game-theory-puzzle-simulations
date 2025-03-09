library(lubridate)  # For date handling
library(dplyr)  # For data manipulation
library(ggplot2)  # For visualization

set.seed(42)  # Ensures reproducibility

# 📌 Step 1: Introduce the Experiment
cat("🧩 BIRTHDAY PARADOX EXPERIMENT\n")
cat("How many people should there be in a room so that the probability of any 2 people sharing a birthday is over 90%?\n")
cat("Let's explore by running some simulations!\n")

# 📌 Step 2: Take user input for 'n'
n <- as.numeric(readline("Enter number of people in the room (n): "))

if (is.na(n) || n <= 1 || n > 365) {
  stop("Please enter a valid number between 2 and 365.")
}

# 📌 Step 3: Run one simulation
cat("\n🔄 Running one simulation...\n")
single_simulation <- sample(1:365, n, replace = TRUE)

# 📌 Step 4: Compute probability of a shared birthday
probability_birthday_match <- 1 - prod((365:(365 - n + 1)) / 365)

cat("\n📊 The probability that at least two people in a room of", n, "share a birthday is:",
    round(probability_birthday_match * 100, 2), "%\n")

# 📌 Step 5: Count occurrences of each birthday in this single simulation
single_birthday_counts <- sort(table(single_simulation), decreasing = TRUE)

# Convert to ddmm format
convert_to_ddmm <- function(day_of_year) {
  as.Date(as.numeric(day_of_year) - 1, origin = "2023-01-01") |> format("%d%m")
}

# Convert all birthdays to ddmm format
single_birthdays_ddmm <- sapply(names(single_birthday_counts), convert_to_ddmm)

# Create a table for the single simulation
single_birthday_table <- data.frame(
  Birthday_DDMM = single_birthdays_ddmm,
  Occurrences = as.numeric(single_birthday_counts)
)

# Print the table
cat("\n📊 Birthday Occurrences Table for Single Simulation (DDMM Format):\n")
print(single_birthday_table, row.names = FALSE)


cat("\n🎂 Most common birthday(s) in this run (ddmm format):\n", paste(most_common_birthdays_ddmm, collapse = ", "), "\n")

# 📌 Step 6: Plot single simulation birthday frequency
df_single <- data.frame(
  Birthday = as.numeric(names(single_birthday_counts)),
  Count = as.numeric(single_birthday_counts)
)

ggplot(df_single, aes(x = Birthday, y = Count)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme_minimal() +
  labs(
    title = "Birthday Frequency in a Single Run",
    x = "Day of the Year (1-365)",
    y = "Count"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 📌 Step 7: Allow multiple simulations
s <- as.numeric(readline("\nEnter number of simulations (s): "))

if (is.na(s) || s <= 0) {
  stop("Please enter a valid positive number.")
}

cat("\n🔄 Running", s, "simulations of", n, "people each...\n")

# Simulate 's' times
results <- replicate(s, sample(1:365, n, replace = TRUE))

# Flatten all birthdays into one vector
all_birthdays <- unlist(results)

# Count occurrences across all simulations
birthday_counts <- sort(table(all_birthdays), decreasing = TRUE)

# Convert most common birthdays to ddmm format
most_common_birthdays_ddmm <- sapply(names(birthday_counts), convert_to_ddmm)

# Convert all birthdays in single_birthday_counts to ddmm format
all_birthdays_ddmm <- sapply(as.numeric(names(single_birthday_counts)), convert_to_ddmm)

# Create a properly aligned data frame
birthday_table <- data.frame(
  Birthday_DDMM = all_birthdays_ddmm,
  Occurrences = as.numeric(single_birthday_counts)
)

# Print the table
cat("\n📊 Birthday Occurrences Table (DDMM Format):\n")
print(head(birthday_table, row.names = FALSE))



# 📌 Step 8: Plot birthday frequency across multiple simulations
df_birthdays <- data.frame(
  Birthday = as.numeric(names(birthday_counts)),
  Count = as.numeric(birthday_counts)
)

ggplot(df_birthdays, aes(x = Birthday, y = Count)) +
  geom_bar(stat = "identity", fill = "darkred") +
  theme_minimal() +
  labs(
    title = paste("Birthday Frequency Across", s, "Simulations"),
    x = "Day of the Year (1-365)",
    y = "Count"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 📌 Step 9: Probability Curve for Increasing 'n'
n_values <- 2:60  # Varying number of people
p_values <- sapply(n_values, function(n) 1 - prod((365:(365 - n + 1)) / 365))  # Compute probability

df_prob <- data.frame(
  People = n_values,
  Probability = p_values * 100  # Convert to percentage
)

ggplot(df_prob, aes(x = People, y = Probability)) +
  geom_line(color = "blue", size = 1) +
  geom_point(color = "red") +
  theme_minimal() +
  labs(
    title = "Probability of Shared Birthday vs. Number of People",
    x = "Number of People",
    y = "Probability (%)"
  )

cat("\n📈 The graph above shows how the probability of two people sharing a birthday increases as more people enter the room.\n")


# 📌 Step 1: Get user's birthday
day <- as.numeric(readline("Enter your birth day (1-31): "))
month <- as.numeric(readline("Enter your birth month (1-12): "))

# Validate input
if (is.na(day) || is.na(month) || day < 1 || day > 31 || month < 1 || month > 12) {
  stop("Invalid input. Please enter a valid day (1-31) and month (1-12).")
}

# Define days in each month (not considering leap years)
days_in_month <- c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)

# Convert to day of the year
day_of_year <- sum(days_in_month[1:(month-1)]) + day

cat("\n🎉 Your birthday is on day", day_of_year, "of the year!\n")

# 📌 Step 2: Count birthdays in 'n' that share the same birth month
same_month_count <- sum(floor((single_simulation - 1) / 30.5) + 1 == month)

cat("\n📊 Out of", n, "people, there are", same_month_count, "birthdays in the same month as yours!\n")