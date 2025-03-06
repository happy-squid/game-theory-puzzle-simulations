library(plumber)
library(ggplot2)
library(lubridate)
library(dplyr)

#* @filter cors
function(req, res) {
    res$setHeader("Access-Control-Allow-Origin", "*")
    plumber::forward()
}

#* Convert day of the year to date format (dd/mm)
convert_to_ddmm <- function(day_of_year) {
    # Convert to date and format with leading zeros
    date <- as.Date(day_of_year - 1, origin = "2023-01-01")
    sprintf("%02d/%02d", 
            as.numeric(format(date, "%d")), 
            as.numeric(format(date, "%m")))
}

#* @apiTitle Birthday Paradox Simulation API

#* Get birthday simulation results
#* @param month Birth month
#* @param day Birth day
#* @param people Number of people in room
#* @param simulations Number of simulations
#* @get /birthday
#* @serializer json
function(month, day, people, simulations) {
    # Convert parameters to numeric
    month <- as.numeric(month)
    day <- as.numeric(day)
    people <- as.numeric(people)
    simulations <- as.numeric(simulations)
    
    # Validate inputs
    if (any(is.na(c(month, day, people, simulations)))) {
        stop("Invalid input parameters")
    }
    
    # Convert to day of the year
    days_in_month <- c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
    day_of_year <- sum(days_in_month[1:(month-1)]) + day
    
    # Calculate probability of shared birthday
    probability_birthday_match <- 1 - prod((365:(365-people+1)) / 365)
    
    # Simulate the experiment s times
    set.seed(42)
    all_birthdays <- unlist(replicate(simulations, sample(1:365, people, replace = TRUE)))
    birthday_counts <- sort(table(all_birthdays), decreasing = TRUE)
    
    # Find most common birthday
    max_count <- max(birthday_counts)
    most_common_birthdays <- as.numeric(names(birthday_counts)[birthday_counts == max_count])
    most_common_birthdays_ddmm <- sapply(most_common_birthdays, convert_to_ddmm)[1]
    
    list(
        probability = round(probability_birthday_match * 100, 2),
        dayOfYear = day_of_year,
        mostCommonBirthday = most_common_birthdays_ddmm
    )
}

#* Get birthday frequency plot
#* @param month Birth month
#* @param day Birth day
#* @param people Number of people in room
#* @param simulations Number of simulations
#* @get /birthday_plot
#* @serializer png
function(month, day, people, simulations) {
    # Convert parameters to numeric and validate
    month <- as.numeric(month)
    day <- as.numeric(day)
    people <- as.numeric(people)
    simulations <- as.numeric(simulations)
    
    if (any(is.na(c(month, day, people, simulations)))) {
        stop("Invalid input parameters")
    }
    
    # Run simulation
    set.seed(42)
    # Generate birthdays for all simulations
    all_birthdays <- numeric(people * simulations)
    for(i in 1:simulations) {
        start_idx <- (i-1) * people + 1
        end_idx <- i * people
        all_birthdays[start_idx:end_idx] <- sample(1:365, people, replace = TRUE)
    }
    
    # Create data frame with all possible days
    df_birthdays <- data.frame(
        Birthday = 1:365,
        Count = 0
    )
    
    # Update counts from simulation
    birthday_counts <- table(all_birthdays)
    df_birthdays$Count[as.numeric(names(birthday_counts))] <- as.numeric(birthday_counts)
    
    # Create plot
    p <- ggplot(df_birthdays, aes(x = Birthday, y = Count)) +
        geom_bar(stat = "identity", fill = "steelblue") +
        theme_minimal() +
        labs(
            title = "Birthday Frequency Distribution",
            x = "Day of the Year (1-365)",
            y = "Count of Occurrences"
        ) +
        theme(
            axis.text.x = element_text(angle = 45, hjust = 1),
            plot.title = element_text(hjust = 0.5),
            plot.margin = margin(10, 10, 10, 10)
        )
    
    # Ensure the plot is rendered
    print(p)
} 