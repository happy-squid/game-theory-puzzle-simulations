# Coin Toss Simulation Web Interface

A web interface for simulating coin tosses with statistical analysis and visualization.

## Project Structure
- `index.html` - The web interface for inputting simulation parameters and displaying results
- `cointoss_api.R` - R API server using Plumber to handle simulation requests
- `cointoss.R` - Original coin toss simulation script

## Prerequisites
- R installed on your system
- Required R packages:
  - plumber
  - ggplot2
  - jsonlite

## Installation

1. Clone this repository:
bash
git clone https://github.com/your-username/coin-toss-simulation.git
cd coin-toss-simulation

2. Install required R packages:
install.packages(c("plumber", "ggplot2", "jsonlite"))

## Usage

1. Start the R server:
library(plumber)
pr <- plumber::plumb("cointoss_api.R")
pr$run(port=8000)

2. Open `index.html` in your web browser

## Features

- Input the number of coin tosses per simulation
- Run 100 simulations for the given number of tosses
- View detailed results including:
  - Number of heads and tails for each simulation
  - Deviation from expected values
  - Probability of getting equal heads and tails
- Visualize results with two interactive plots:
  - Deviation from expected heads/tails count
  - Probability distribution over different numbers of flips

## Usage

1. Enter the desired number of coin tosses in the input field
2. Click "Run Simulation" or press Enter
3. View the simulation results and graphs in the results section

## API Endpoints

- `/results` - Get statistical results for the simulation
- `/toss` - Get the deviation plot
- `/probability` - Get the probability distribution plot