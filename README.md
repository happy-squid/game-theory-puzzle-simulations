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

3. Open `homepage/index.html` in your web browser

## 📁 Project Structure

```
.
├── homepage/              # Landing page and assets
│   ├── index.html        # Main landing page
│   ├── style.css         # Homepage styles
│   └── images/           # Simulation card images
│
├── cointoss/             # Coin toss simulation
│   ├── cointoss.html     # Interface
│   ├── cointoss.css      # Styles
│   ├── cointoss.R        # Core logic
│   ├── cointoss_api.R    # API endpoints
│   └── start_cointoss_api.R  # Server startup
│
├── birthday/             # Birthday paradox simulation
│   ├── birthday.html     # Interface
│   ├── birthday.css      # Styles
│   ├── birthday.R        # Core logic
│   ├── birthday_api.R    # API endpoints
│   └── start_birthday_api.R  # Server startup
│
├── prisoner/             # Prisoner's dilemma simulation
│   ├── prisoner.html     # Interface
│   ├── prisoner.css      # Styles
│   ├── prisoner.R        # Core logic
│   ├── prisoner_api.R    # API endpoints
│   └── start_prisoner_api.R  # Server startup
│
├── montyhall/            # Monty Hall problem simulation
│   ├── index.html        # Interface
│   ├── style.css         # Styles
│   ├── script.js         # Game logic
│   └── images/           # Game images
│
├── config/               # Configuration files
│   └── api_config.R      # API settings
│
├── docs/                 # Documentation
│   └── api.md           # API documentation
│
├── scripts/             # Utility scripts
│   └── setup.R         # Development setup
│
├── tests/              # Test files
│   └── test_simulations.R  # Simulation tests
│
├── utils/              # Helper functions
│   └── helpers.R      # Common utilities
│
├── start_servers.R    # Main server startup script
├── CODE_OF_CONDUCT.md # Project code of conduct
├── CONTRIBUTING.md    # Contribution guidelines
├── LICENSE           # Project license
└── README.md        # This file
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

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.