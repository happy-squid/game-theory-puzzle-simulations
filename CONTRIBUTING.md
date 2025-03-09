# Contributing to Game Theory and Probability Simulations

Thank you for your interest in contributing to our project! We welcome contributions from everyone.

## Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/your-username/game-theory-puzzle-simulations.git
   ```
3. Create a new branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Setup

1. Install R (version 4.0 or higher)
2. Install required packages:
   ```R
   install.packages(c("plumber", "ggplot2", "jsonlite"))
   ```
3. Start the servers:
   ```R
   Rscript start_servers.R
   ```

## Making Changes

1. Follow the existing code style and conventions
2. Add comments to explain complex logic
3. Update documentation if needed
4. Test your changes thoroughly

## Pull Request Process

1. Update the README.md with details of changes if needed
2. Update documentation in the relevant simulation directory
3. Ensure all tests pass
4. Create a Pull Request with a clear title and description

## Code Style Guidelines

### R Code
- Use meaningful variable names
- Comment complex algorithms
- Follow tidyverse style guide
- Use consistent indentation

### HTML/CSS
- Use semantic HTML5 elements
- Follow BEM naming convention
- Keep styles modular
- Ensure responsive design

## Adding New Simulations

1. Create a new directory for your simulation
2. Include HTML interface and R API files
3. Add appropriate tests
4. Update README.md
5. Add card image in card_images/

## Reporting Issues

- Use the issue tracker
- Include reproduction steps
- Specify your environment
- Attach relevant screenshots

## Community

- Be respectful and inclusive
- Help others when possible
- Share knowledge
- Give constructive feedback

## Questions?

Feel free to open an issue or contact the maintainers.
