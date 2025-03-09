library(plumber)
library(ggplot2)
library(lubridate)
library(dplyr)
library(jsonlite)

#* @filter cors
function(req, res) {
    res$setHeader("Access-Control-Allow-Origin", "*")
    plumber::forward()
}

# Helper function to convert day of year to DDMM format
convert_to_ddmm <- function(day_of_year) {
    as.Date(as.numeric(day_of_year) - 1, origin = "2023-01-01") |> format("%d%m")
}

#* Run single simulation and get results
#* @param n Number of people
#* @get /single_simulation
#* @serializer json
function(n) {
    n <- as.numeric(n)
    if (is.na(n) || n < 2 || n > 365) {
        stop("Please enter a valid number between 2 and 365.")
    }
    
    # Run one simulation
    single_simulation <- sample(1:365, n, replace = TRUE)
    
    # Compute probability
    probability_birthday_match <- 1 - prod((365:(365 - n + 1)) / 365)
    
    # Count occurrences
    single_birthday_counts <- sort(table(single_simulation), decreasing = TRUE)
    single_birthdays_ddmm <- sapply(names(single_birthday_counts), convert_to_ddmm)
    
    # Create birthday table
    single_birthday_table <- data.frame(
        Birthday_DDMM = single_birthdays_ddmm,
        Occurrences = as.numeric(single_birthday_counts)
    )
    
    # Create frequency data
    df_single <- data.frame(
        Birthday = as.numeric(names(single_birthday_counts)),
        Count = as.numeric(single_birthday_counts)
    )
    
    list(
        probability = round(probability_birthday_match * 100, 2),
        birthdayTable = single_birthday_table,
        mostCommonBirthdays = single_birthdays_ddmm[single_birthday_counts == max(single_birthday_counts)],
        frequencyData = df_single
    )
}

#* Run multiple simulations
#* @param n Number of people
#* @param s Number of simulations
#* @get /multiple_simulations
#* @serializer json
function(n, s) {
    n <- as.numeric(n)
    s <- as.numeric(s)
    
    if (is.na(s) || s <= 0) {
        stop("Please enter a valid positive number for simulations.")
    }
    
    # Run simulations
    results <- replicate(s, sample(1:365, n, replace = TRUE))
    all_birthdays <- unlist(results)
    
    # Count occurrences
    birthday_counts <- sort(table(all_birthdays), decreasing = TRUE)
    birthdays_ddmm <- sapply(names(birthday_counts), convert_to_ddmm)
    
    # Create birthday table
    birthday_table <- data.frame(
        Birthday_DDMM = birthdays_ddmm,
        Occurrences = as.numeric(birthday_counts)
    )
    
    # Create frequency data
    df_birthdays <- data.frame(
        Birthday = as.numeric(names(birthday_counts)),
        Count = as.numeric(birthday_counts)
    )
    
    list(
        birthdayTable = head(birthday_table),
        frequencyData = df_birthdays
    )
}

#* Get probability plot data
#* @serializer json
#* @get /probability_plot
function() {
    n_values <- 2:60
    p_values <- sapply(n_values, function(n) 1 - prod((365:(365 - n + 1)) / 365))
    
    list(
        people = n_values,
        probability = p_values * 100
    )
}

#* Check birthday in group
#* @param day Birth day
#* @param month Birth month
#* @param n Number of people
#* @serializer json
#* @get /check_birthday
function(day, month, n) {
    day <- as.numeric(day)
    month <- as.numeric(month)
    n <- as.numeric(n)
    
    if (is.na(day) || is.na(month) || day < 1 || day > 31 || month < 1 || month > 12) {
        stop("Invalid input. Please enter a valid day (1-31) and month (1-12).")
    }
    
    # Define days in each month (not considering leap years)
    days_in_month <- c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
    
    # Convert to day of the year
    if (month == 1) {
        day_of_year <- day
    } else {
        day_of_year <- sum(days_in_month[1:(month-1)]) + day
    }
    
    # Generate random birthdays for n people
    birthdays <- sample(1:365, n, replace = TRUE)
    
    # Count birthdays in same month
    same_month_count <- sum(floor((birthdays - 1) / 30.5) + 1 == month)
    
    list(
        dayOfYear = day_of_year,
        sameMonthCount = same_month_count
    )
}

#* Get single simulation plot
#* @param n Number of people
#* @get /single_plot
#* @serializer png
function(n) {
    n <- as.numeric(n)
    single_simulation <- sample(1:365, n, replace = TRUE)
    single_birthday_counts <- sort(table(single_simulation), decreasing = TRUE)
    
    df_single <- data.frame(
        Birthday = as.numeric(names(single_birthday_counts)),
        Count = as.numeric(single_birthday_counts)
    )
    
    p <- ggplot(df_single, aes(x = Birthday, y = Count)) +
        geom_bar(stat = "identity", fill = "steelblue") +
        theme_minimal() +
        labs(
            title = "Birthday Frequency in a Single Run",
            x = "Day of the Year (1-365)",
            y = "Count"
        ) +
        theme(
            axis.text.x = element_text(angle = 45, hjust = 1),
            plot.title = element_text(size = 13, face = "bold"),
            plot.margin = margin(t = 20, r = 20, b = 20, l = 20, unit = "pt")
        )
    
    print(p)
}

#* Get multiple simulations plot
#* @param n Number of people
#* @param s Number of simulations
#* @get /multiple_plot
#* @serializer png
function(n, s) {
    n <- as.numeric(n)
    s <- as.numeric(s)
    
    results <- replicate(s, sample(1:365, n, replace = TRUE))
    all_birthdays <- unlist(results)
    birthday_counts <- sort(table(all_birthdays), decreasing = TRUE)
    
    df_birthdays <- data.frame(
        Birthday = as.numeric(names(birthday_counts)),
        Count = as.numeric(birthday_counts)
    )
    
    p <- ggplot(df_birthdays, aes(x = Birthday, y = Count)) +
        geom_bar(stat = "identity", fill = "darkred") +
        theme_minimal() +
        labs(
            title = paste("Birthday Frequency Across", s, "Simulations"),
            x = "Day of the Year (1-365)",
            y = "Count"
        ) +
        theme(
            axis.text.x = element_text(angle = 45, hjust = 1),
            plot.title = element_text(size = 13, face = "bold"),
            plot.margin = margin(t = 20, r = 20, b = 20, l = 20, unit = "pt")
        )
    
    print(p)
}

#* Get probability vs people plot
#* @get /probability_vs_people_plot
#* @serializer png
function() {
    n_values <- 2:60
    p_values <- sapply(n_values, function(n) 1 - prod((365:(365 - n + 1)) / 365))
    
    df_prob <- data.frame(
        People = n_values,
        Probability = p_values * 100
    )
    
    p <- ggplot(df_prob, aes(x = People, y = Probability)) +
        geom_line(color = "blue", size = 1) +
        geom_point(color = "red") +
        theme_minimal() +
        labs(
            title = "Probability of Shared Birthday vs. Number of People",
            x = "Number of People",
            y = "Probability (%)"
        ) +
        theme(
            plot.title = element_text(size = 13, face = "bold"),
            plot.margin = margin(t = 20, r = 20, b = 20, l = 20, unit = "pt")
        )
    
    print(p)
}