# Game Theory and Probability Simulations

An interactive web application featuring classic probability puzzles and game theory simulations. Each simulation provides hands-on experience with mathematical concepts through engaging visualizations and real-time analysis.

## 🎲 Featured Simulations

1. **COIN TOSS**
   - Explore the probability of getting exactly 50% heads in multiple coin tosses
   - Visualize deviations from expected outcomes
   - Analyze probability distributions

2. **BIRTHDAY PARADOX**
   - Discover the surprisingly high probability of shared birthdays in a group
   - Interactive simulation with adjustable group sizes
   - Real-time probability calculations

3. **PRISONER'S DILEMMA**
   - Experience the classic game theory scenario
   - Explore cooperation vs. defection strategies
   - Analyze Nash equilibrium in practice

4. **MONTY HALL PROBLEM**
   - Test the counter-intuitive solution to this famous probability puzzle
   - Interactive door selection and reveals
   - Track success rates with different strategies

## 🚀 Getting Started

### Prerequisites
- R (version 4.0 or higher)
- Web browser (Chrome, Firefox, Safari)

### Required R Packages
```R
install.packages(c("plumber", "ggplot2", "jsonlite"))
```

### Installation & Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/game-theory-puzzle-simulations.git
   cd game-theory-puzzle-simulations
   ```

2. Start the R servers:
   ```R
   Rscript start_servers.R
   ```

3. Open `homepage.html` in your web browser

## 📁 Project Structure

```
.
├── homepage.html          # Main landing page
├── homepage.css          # Global styles
├── card_images/          # Simulation card images
├── start_servers.R       # Server startup script
│
├── cointoss/
│   ├── cointoss.html    # Coin toss simulation interface
│   └── cointoss_api.R   # Coin toss API endpoints
│
├── birthday/
│   ├── birthday.html    # Birthday paradox interface
│   └── birthday_api.R   # Birthday paradox API endpoints
│
├── prisoner/
│   ├── prisoner.html    # Prisoner's dilemma interface
│   └── prisoner_api.R   # Prisoner's dilemma API endpoints
│
└── montyhall/
    ├── index.html       # Monty Hall problem interface
    └── style.css        # Monty Hall specific styles
```

## 🔧 API Endpoints

Each simulation runs on its own port:
- Coin Toss: Port 8000
- Birthday Paradox: Port 8001
- Prisoner's Dilemma: Port 8003

## 🎨 Features

- Modern, responsive design
- Interactive visualizations
- Real-time statistical analysis
- Intuitive user interface
- Cross-browser compatibility

## 📚 Educational Value

Each simulation is designed to provide:
- Hands-on experience with probability concepts
- Visual understanding of statistical principles
- Practical application of game theory
- Interactive learning environment

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.