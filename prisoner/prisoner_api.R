library(plumber)
library(ggplot2)
library(jsonlite)

#* @apiTitle Prisoner's Dilemma API

#* Enable CORS and error handling
#* @filter cors
function(req, res) {
    tryCatch({
        res$setHeader("Access-Control-Allow-Origin", "*")
        res$setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
        res$setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization")
        
        if (req$REQUEST_METHOD == "OPTIONS") {
            res$status <- 200
            return(list())
        }
        
        plumber::forward()
    }, error = function(e) {
        res$setHeader("Access-Control-Allow-Origin", "*")
        res$status <- 400
        list(error = unbox(as.character(e)))
    })
}

# Define payoff matrix
payoffs <- list(
    C = list(C = c(3, 3), D = c(0, 5)),
    D = list(C = c(5, 0), D = c(1, 1))
)

#* Play a single round of Prisoner's Dilemma
#* @param choice Player's choice (C or D)
#* @serializer json
#* @get /single_round
function(choice) {
    tryCatch({
        # Validate input
        if (is.null(choice) || !choice %in% c("C", "D")) {
            stop("Invalid choice! Please enter 'C' for Cooperate or 'D' for Defect.")
        }
        
        # Computer makes a random choice
        computer_choice <- sample(c("C", "D"), 1)[[1]]
        
        # Get the result from the payoff matrix
        result <- payoffs[[choice]][[computer_choice]]
        
        list(
            playerChoice = unbox(choice),
            computerChoice = unbox(computer_choice),
            playerScore = unbox(result[1]),
            computerScore = unbox(result[2])
        )
    }, error = function(e) {
        stop(as.character(e))
    })
}

#* Play multiple rounds of Prisoner's Dilemma
#* @param choices Array of player choices
#* @serializer json
#* @get /multiple_rounds
function(choices) {
    tryCatch({
        if (is.null(choices)) {
            stop("No choices provided!")
        }
        
        choices <- strsplit(choices, ",")[[1]]
        
        # Validate input
        if (!all(choices %in% c("C", "D"))) {
            stop("Invalid choices! Please use only 'C' for Cooperate or 'D' for Defect.")
        }
        
        if (length(choices) != 5) {
            stop("Please provide exactly 5 choices!")
        }
        
        rounds <- length(choices)
        computer_choices <- sample(c("C", "D"), rounds, replace = TRUE)
        
        player_scores <- numeric(rounds)
        computer_scores <- numeric(rounds)
        
        for (i in 1:rounds) {
            result <- payoffs[[choices[i]]][[computer_choices[i]]]
            player_scores[i] <- result[1]
            computer_scores[i] <- result[2]
        }
        
        list(
            playerChoices = choices,
            computerChoices = computer_choices,
            playerScores = player_scores,
            computerScores = computer_scores,
            totalPlayerScore = unbox(sum(player_scores)),
            totalComputerScore = unbox(sum(computer_scores))
        )
    }, error = function(e) {
        stop(as.character(e))
    })
}

#* Generate choice distribution plot
#* @param choices Array of player choices
#* @serializer png
#* @get /choice_distribution_plot
function(choices) {
    tryCatch({
        if (is.null(choices)) {
            stop("No choices provided!")
        }
        
        choices <- strsplit(choices, ",")[[1]]
        
        if (!all(choices %in% c("C", "D"))) {
            stop("Invalid choices! Please use only 'C' for Cooperate or 'D' for Defect.")
        }
        
        rounds <- length(choices)
        computer_choices <- sample(c("C", "D"), rounds, replace = TRUE)
        
        # Create a data frame for visualization
        df <- data.frame(
            Player = rep(c("You", "Computer"), each = rounds),
            Choice = c(choices, computer_choices)
        )
        
        # Plot choices and save in the same directory as this script
        p <- ggplot(df, aes(x = Player, fill = Choice)) +
            geom_bar(position = "dodge") +
            theme_minimal() +
            labs(title = "Distribution of Choices", x = "Player", y = "Count") +
            scale_fill_manual(values = c("C" = "#4CAF50", "D" = "#f44336")) +
            theme(
                plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
                axis.title = element_text(size = 12),
                axis.text = element_text(size = 10),
                legend.title = element_text(size = 12),
                legend.text = element_text(size = 10)
            )
        
        # Save plot in the same directory as this script
        ggsave("plot.png", p, width = 8, height = 6)
        
        print(p)
    }, error = function(e) {
        stop(as.character(e))
    })
}
