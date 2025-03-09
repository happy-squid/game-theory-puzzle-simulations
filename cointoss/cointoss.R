# 🪙 COIN FLIP EXPERIMENT - Understanding Probability & Deviation

# library(plumber)
# plumber::plumb("cointoss_api.R")$run(port=8000)

library(ggplot2)
library(plumber)

# 📌 Step 1: Take user input
set.seed(42)  # Reproducibility
num_tosses <- as.numeric(readline(prompt = "Enter the number of coin tosses per simulation: "))

# ✅ Handle invalid input
if (is.na(num_tosses) || num_tosses <= 0) {
  stop("Please enter a valid positive number.")
}

expected_value <- num_tosses / 2  # Expected heads & tails

s=100 #Number of simulations


cat("\nRunning", s, "simulations of", num_tosses, "coin flips each...\n")

# 📌 Step 2: Simulate Tosses
heads_count <- rbinom(s, num_tosses, 0.5)  # Simulate 's' times
tails_count <- num_tosses - heads_count  

# 📌 Step 3: Compute Deviations
heads_deviation <- expected_value - heads_count
tails_deviation <- expected_value - tails_count

# 📌 Step 4: Plot Deviation from Expected Value
df_deviation <- data.frame(
  Simulation = 1:s,
  Heads_Deviation = heads_deviation,
  Tails_Deviation = tails_deviation
)

ggplot(df_deviation, aes(x = factor(Simulation))) +
  geom_col(aes(y = Heads_Deviation), fill = "blue", alpha = 0.7) +
  geom_col(aes(y = Tails_Deviation), fill = "red", alpha = 0.7) +
  theme_minimal() +
  labs(
    title = "Deviation from Expected Heads/Tails Count",
    x = "Simulation Number",
    y = "Deviation from Expected Value"
  ) +
  theme(
    axis.text.x = element_blank(),  # Hide x-axis labels for clarity
    panel.grid.major.x = element_blank()
  ) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black")

# 📌 Step 5: Print Results for Understanding
cat("\nSummary of Simulations:\n")
print(data.frame(
  Simulation = 1:s,
  Heads = heads_count,
  Tails = tails_count,
  Heads_Deviation = heads_deviation,
  Tails_Deviation = tails_deviation
))

# 📌 Step 6: How Often Does Heads == Tails?
equal_count <- sum(heads_deviation == 0)  # Count simulations where deviation is 0
equal_percentage <- (equal_count / s) * 100  # Convert to percentage

cat("\n✅ Probability that heads and tails are exactly equal across", s, "simulations:", round(equal_percentage, 2), "%\n")

# 📌 Step 7: Plot Probability of 50% Heads Over Different Tosses
n_values <- seq(2, 10000, by = 100)  # Varying coin flips
p_values <- dbinom(n_values / 2, n_values, 0.5)  # Compute probability

df_prob <- data.frame(
  Flips = n_values,
  Probability = p_values * 100  # Convert to percentage
)

ggplot(df_prob, aes(x = Flips, y = Probability)) +
  geom_line(color = "red", size = 1) +
  scale_y_log10() +  # Log scale for better visibility
  theme_minimal() +
  labs(
    title = "Probability of Getting Exactly 50% Heads vs. Number of Flips",
    x = "Number of Coin Flips",
    y = "Probability % (Log Scale)"
  )

# 📌 Step 8: Tabulate Proportions of Outcomes
cat("\n📊 Frequency Distribution of Heads Count Across Simulations:\n")
print(prop.table(table(heads_count)))

cat("\n📊 Frequency Distribution of Tails Count Across Simulations:\n")
print(prop.table(table(tails_count)))


#Explaining probability of heads & tails being equal

p <- 0.5  # Probability of heads
x <- num_tosses / 2  # We want exactly half heads

prob_equal <- dbinom(x, num_tosses, p)  # Compute probability

cat("Hence, for", num_tosses, "tosses, the probability of equal H&T is", 
    round(prob_equal * 100, 2), "%, as you can approximately see in the tables above.\n")

# 📌 Step 9: Compute & Display Distribution of Deviation from Expected Value
deviation_table <- table(abs(heads_deviation - tails_deviation))
cat("\n🔍 How often did heads & tails deviate by certain amounts?\n")
print(deviation_table)



cat("You can see that the approx. proportion for", round(prob_equal * 100, 2), 
    "% is given under 0 deviation.\n")

#* @apiTitle Coin Toss Simulation API

#* Simulate coin tosses and return a plot
#* @param n Number of tosses
#* @get /toss
#* @serializer png
function(n) {
    # Convert n to numeric and validate
    n <- as.numeric(n)
    if (is.na(n) || n < 1) {
        stop("Invalid number of tosses")
    }
    
    # Simulate coin tosses
    tosses <- sample(c("Heads", "Tails"), size = n, replace = TRUE)
    
    # Calculate cumulative probabilities
    cumulative_heads <- cumsum(tosses == "Heads") / 1:n
    
    # Create data frame for plotting
    df <- data.frame(
        toss_number = 1:n,
        probability = cumulative_heads
    )
    
    # Create the plot
    p <- ggplot(df, aes(x = toss_number, y = probability)) +
        geom_line(color = "blue") +
        geom_hline(yintercept = 0.5, linetype = "dashed", color = "red") +
        labs(
            title = "Probability of Heads Over Number of Tosses",
            x = "Number of Tosses",
            y = "Probability of Heads"
        ) +
        theme_minimal() +
        ylim(0, 1)
    
    # Return the plot
    print(p)
}

# Create API
pr <- plumber::plumb("cointoss.R")
pr$run(port=8000)

