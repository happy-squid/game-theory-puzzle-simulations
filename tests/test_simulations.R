library(testthat)

# Test Coin Toss Simulation
test_that("coin_toss simulation works correctly", {
  source("../cointoss/cointoss.R")
  
  # Test with small numbers
  result <- simulate_tosses(10, 100)
  expect_type(result$probability, "double")
  expect_true(result$probability >= 0 && result$probability <= 1)
  
  # Test edge cases
  expect_error(simulate_tosses(-1, 100))
  expect_error(simulate_tosses(10, -1))
})

# Test Birthday Paradox Simulation
test_that("birthday_paradox simulation works correctly", {
  source("../birthday/bday.R")
  
  # Test with classic case (23 people)
  result <- simulate_birthdays(23, 10000)
  expect_type(result$probability, "double")
  expect_true(result$probability >= 0.5) # Should be around 50%
  
  # Test edge cases
  expect_error(simulate_birthdays(0, 100))
  expect_error(simulate_birthdays(367, 100))
})

# Test Prisoner's Dilemma Simulation
test_that("prisoner_dilemma simulation works correctly", {
  source("../prisoner/prisoner.R")
  
  # Test basic strategies
  result <- simulate_game("cooperate", "defect", 10)
  expect_type(result$prisoner1_score, "integer")
  expect_type(result$prisoner2_score, "integer")
  
  # Test invalid inputs
  expect_error(simulate_game("invalid", "cooperate", 10))
  expect_error(simulate_game("cooperate", "defect", -1))
})
