dbinom <- function(x, n, p) {
    choose(n, x) * p^x * (1-p)^(n-x)
}

library(plumber)
library(ggplot2)
library(jsonlite)

#* @filter cors
function(req, res) {
    res$setHeader("Access-Control-Allow-Origin", "*")
    plumber::forward()
}

#* @apiTitle Coin Toss Simulation API

#* Get simulation results
#* @param n Number of tosses per simulation
#* @get /results
#* @serializer json
function(n) {
    n <- as.numeric(n)
    if (is.na(n) || n < 1) {
        stop("Invalid number of tosses")
    }
    
    set.seed(42)
    s <- 100  # Number of simulations
    expected_value <- n / 2
    
    # Simulate tosses
    heads_count <- rbinom(s, n, 0.5)
    tails_count <- n - heads_count
    
    # Compute deviations
    heads_deviation <- expected_value - heads_count
    tails_deviation <- expected_value - tails_count
    
    # Calculate probability of equal heads/tails
    prob_equal <- if(n %% 2 == 0) dbinom(n/2, n, 0.5) * 100 else 0
    
    # Create frequency distributions
    heads_dist <- as.list(table(heads_count))
    tails_dist <- as.list(table(tails_count))
    
    # Create proportions
    heads_prop <- as.list(prop.table(table(heads_count)))
    tails_prop <- as.list(prop.table(table(tails_count)))
    
    # Create deviation table
    deviation_table <- as.list(table(abs(heads_deviation - tails_deviation)))
    
    # Create results data
    simulations <- data.frame(
        simulation = 1:s,
        heads = heads_count,
        tails = tails_count,
        headsDeviation = heads_deviation,
        tailsDeviation = tails_deviation
    )
    
    # Return JSON response
    list(
        equalProbability = round(prob_equal, 4),
        simulations = simulations,
        headsDistribution = heads_dist,
        tailsDistribution = tails_dist,
        headsProportions = heads_prop,
        tailsProportions = tails_prop,
        deviationTable = deviation_table
    )
}

#* Simulate coin tosses and return deviation plot
#* @param n Number of tosses per simulation
#* @get /toss
#* @serializer png
function(n) {
    # Convert n to numeric and validate
    n <- as.numeric(n)
    if (is.na(n) || n < 1) {
        stop("Invalid number of tosses")
    }
    
    set.seed(42)
    s <- 100  # Number of simulations
    expected_value <- n / 2
    
    # Simulate tosses
    heads_count <- rbinom(s, n, 0.5)
    tails_count <- n - heads_count
    
    # Compute deviations
    heads_deviation <- expected_value - heads_count
    tails_deviation <- expected_value - tails_count
    
    # Create data frame for plotting
    df_deviation <- data.frame(
        Simulation = 1:s,
        Heads_Deviation = heads_deviation,
        Tails_Deviation = tails_deviation
    )
    
    # Create the deviation plot
    p <- ggplot(df_deviation, aes(x = factor(Simulation))) +
        geom_col(aes(y = Heads_Deviation), fill = "blue", alpha = 0.7) +
        geom_col(aes(y = Tails_Deviation), fill = "red", alpha = 0.7) +
        theme_minimal() +
        labs(
            title = "Deviation from Expected Heads/Tails Count",
            x = "Simulation Number",
            y = "Deviation from Expected Value"
        ) +
        theme(
            axis.text.x = element_blank(),
            panel.grid.major.x = element_blank()
        ) +
        geom_hline(yintercept = 0, linetype = "dashed", color = "black")
    
    print(p)
}

#* Return probability plot
#* @param n Number of tosses
#* @get /probability
#* @serializer png
function(n) {
    n <- as.numeric(n)
    if (is.na(n) || n < 1) {
        stop("Invalid number of tosses")
    }
    
    # Plot probability of 50% heads over different tosses
    # Start from 2 (as we need even numbers) and use smaller steps for better resolution
    n_values <- seq(2, 1000, by = 2)  # Only using even numbers up to 1000 for better visibility
    
    # Calculate probability for each n
    # For each n, we want exactly n/2 heads (50%)
    p_values <- sapply(n_values, function(n) dbinom(n/2, n, 0.5))
    
    df_prob <- data.frame(
        Flips = n_values,
        Probability = p_values * 100  # Convert to percentage
    )
    
    p <- ggplot(df_prob, aes(x = Flips, y = Probability)) +
        geom_line(color = "red", size = 1) +
        scale_y_log10(
            breaks = c(0.001, 0.01, 0.1, 1, 10, 50),
            labels = function(x) sprintf("%.3f%%", x)
        ) +
        scale_x_continuous(breaks = seq(0, 1000, by = 200)) +
        theme_minimal() +
        theme(
            axis.text = element_text(size = 12),
            axis.title = element_text(size = 14),
            plot.title = element_text(size = 13, face = "bold"),
            plot.margin = margin(t = 20, r = 20, b = 20, l = 20, unit = "pt")
        ) +
        labs(
            title = "Probability of Getting Exactly 50% Heads vs. Number of Flips",
            x = "Number of Coin Flips",
            y = "Probability % (Log Scale)"
        )
    
    print(p)
}