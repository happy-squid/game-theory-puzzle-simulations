#Puzzles 3
#Varad & Hardik

#Prisoner's Dilemma


#==========================================================================


# Load necessary library
library(ggplot2)

# Define payoff matrix
payoffs <- list(
  C = list(C = c(3, 3), D = c(0, 5)),  # (Cooperate, Cooperate) & (Cooperate, Defect)
  D = list(C = c(5, 0), D = c(1, 1))   # (Defect, Cooperate) & (Defect, Defect)
)

# 📌 Function to explain game context with a table
explain_game <- function() {
  cat("\n🎭 Welcome to the Prisoner's Dilemma! 🎭\n")
  cat("\n🔎 Context: You and an opponent (the computer) have been caught for a crime. 
Each of you must decide to either 'Cooperate (C)' (stay silent) or 'Defect (D)' (betray the other).")
  
  cat("\n💰 Rewards:")
  
  # Create a reward matrix as a data frame
  rewards <- data.frame(
    "Your Choice" = c("Cooperate (C)", "Cooperate (C)", "Defect (D)", "Defect (D)"),
    "Opponent's Choice" = c("Cooperate (C)", "Defect (D)", "Cooperate (C)", "Defect (D)"),
    "Your Reward" = c(3, 0, 5, 1),
    "Opponent's Reward" = c(3, 5, 0, 1)
  )
  
  # Print the table
  print(rewards, row.names = FALSE)
  
  cat("\n🤔 Think carefully before making your choice!\n")
}

# Run the function to see the explanation
explain_game()


# 📌 Function to play a single round
play_round <- function(player_choice, computer_strategy = "random") {
  # Validate input
  if (!player_choice %in% c("C", "D")) {
    stop("Invalid choice! Please enter 'C' for Cooperate or 'D' for Defect.")
  }
  
  # Computer decision logic
  if (computer_strategy == "random") {
    computer_choice <- sample(c("C", "D"), 1)  # Random choice
  } else {
    computer_choice <- "D"  # Always defect strategy for rational play
  }
  
  # Get the result from the payoff matrix
  result <- payoffs[[player_choice]][[computer_choice]]
  
  # Show the result
  cat("\n🎭 You chose:", player_choice, "\n🤖 Computer chose:", computer_choice,
      "\n💰 Payoff → You:", result[1], ", Computer:", result[2], "\n")
  
}

# 📌 Explain dominant strategy for single round
explain_single_dominance <- function() {
  cat("\n📌 The Dominant Strategy for a Single Round:")
  cat("\n🔹 Since defecting ('D') always results in at least as much reward as cooperating, 
the rational choice is always to defect.\n")
}

# 📌 Multi-round game (5 rounds)
play_multiple_rounds <- function(rounds = 5) {
  cat("\n🎲 Now let's play", rounds, "rounds!\n")
  
  player_scores <- c()
  computer_scores <- c()
  player_choices <- c()
  computer_choices <- c()
  
  for (i in 1:rounds) {
    cat("\n⚡ Round", i, "⚡")
    
    # Get player input
    player_choice <- readline("Enter 'C' for Cooperate or 'D' for Defect: ")
    
    # Play round and record results
    result <- play_round(player_choice)
    
    # Store results
    player_scores <- c(player_scores, result[1])
    computer_scores <- c(computer_scores, result[2])
    player_choices <- c(player_choices, result[3])
    computer_choices <- c(computer_choices, result[4])
  }
  
  # Convert scores to numeric before summing
  player_scores <- as.numeric(player_scores)
  computer_scores <- as.numeric(computer_scores)
  
  # Show final rewards
  cat("\n🏆 Game Over! Here are the total scores:")
  cat("\n💰 Your total score:", sum(player_scores))
  cat("\n🤖 Computer's total score:", sum(computer_scores), "\n")
  
  # Explain finite game strategy
  explain_finite_dominance()
  
  # 📊 Graph choice distribution
  show_choice_distribution(player_choices, computer_choices)
}

# 📌 Explain dominant strategy for finite rounds
explain_finite_dominance <- function() {
  cat("\n📌 The Dominant Strategy for a Finite Game:")
  cat("\n🔹 Since the game has a known endpoint, players tend to defect in the final rounds.
This results in a 'backward induction' where players start defecting earlier.\n")
}

# 📊 Graph showing player choice distribution
show_choice_distribution <- function(player_choices, computer_choices) {
  # Create a data frame for visualization
  df <- data.frame(
    Player = rep(c("You", "Computer"), each = length(player_choices)),
    Choice = c(player_choices, computer_choices)
  )
  
  # Plot choices
  ggplot(df, aes(x = Player, fill = Choice)) +
    geom_bar(position = "dodge") +
    theme_minimal() +
    labs(title = "Distribution of Choices", x = "Player", y = "Count") +
    scale_fill_manual(values = c("C" = "blue", "D" = "red"))
}

# 📌 Explain infinite game strategy
explain_infinite_dominance <- function() {
  cat("\n📌 The Dominant Strategy for an Infinite Game:")
  cat("\n🔹 In infinite or unknown-length games, cooperation can emerge as the best strategy. 
Strategies like 'Tit-for-Tat' (copying the opponent's last move) encourage mutual trust.\n")
}

# 🚀 Run the game
explain_game()
player_choice <- readline("Enter 'C' for Cooperate or 'D' for Defect: ")
play_round(player_choice)
explain_single_dominance()
play_multiple_rounds(5)
explain_infinite_dominance()


#===========================================================