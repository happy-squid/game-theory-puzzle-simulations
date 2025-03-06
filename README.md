# Coin Toss Simulation Web Interface

A web interface for simulating coin tosses with statistical analysis and visualization.

## Project Structure
- `homepage.html` - The main landing page with simulation options
- `cointoss.html` - The web interface for coin toss simulation
- `birthday.html` - The web interface for birthday paradox simulation
- `cointoss_api.R` - R API server for coin toss simulation
- `birthday_api.R` - R API server for birthday paradox simulation
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

1. Start the R servers:
```R
source("start_servers.R")
```

2. Open `homepage.html` in your web browser

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