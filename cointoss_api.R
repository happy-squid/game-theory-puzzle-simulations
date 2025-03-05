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
    prob_equal <- dbinom(n/2, n, 0.5) * 100
    
    # Create results data
    simulations <- data.frame(
        simulation = 1:s,
        heads = heads_count,
        tails = tails_count,
        headsDeviation = heads_deviation,
        tailsDeviation = tails_deviation
    )
    
    # Calculate frequency distributions
    heads_dist <- prop.table(table(heads_count))
    tails_dist <- prop.table(table(tails_count))
    
    # Return JSON response
    list(
        equalProbability = round(prob_equal, 2),
        simulations = simulations
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
    
    # Set seed for reproducibility
    set.seed(42)
    
    s <- 100  # Number of simulations
    expected_value <- n / 2  # Expected heads & tails
    
    # Simulate tosses
    heads_count <- rbinom(s, n, 0.5)  # Simulate 's' times
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
    n_values <- seq(2, 10000, by = 100)
    p_values <- dbinom(n_values / 2, n_values, 0.5)
    
    df_prob <- data.frame(
        Flips = n_values,
        Probability = p_values * 100
    )
    
    p <- ggplot(df_prob, aes(x = Flips, y = Probability)) +
        geom_line(color = "red", size = 1) +
        scale_y_log10() +
        theme_minimal() +
        labs(
            title = "Probability of Getting Exactly 50% Heads vs. Number of Flips",
            x = "Number of Coin Flips",
            y = "Probability % (Log Scale)"
        )
    
    print(p)
} 