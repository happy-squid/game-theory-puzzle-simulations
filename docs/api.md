# API Documentation

## Overview
This document describes the API endpoints for each probability simulation.

## Base URLs
- Coin Toss: `http://localhost:8000`
- Birthday Paradox: `http://localhost:8001`
- Prisoner's Dilemma: `http://localhost:8003`

## Coin Toss API

### GET /simulate
Simulates a series of coin tosses.

**Parameters:**
- `n` (integer): Number of tosses
- `trials` (integer): Number of trials

**Response:**
```json
{
  "probability": 0.234,
  "trials": 1000,
  "tosses": 100
}
```

## Birthday Paradox API

### GET /simulate
Calculates probability of shared birthdays.

**Parameters:**
- `people` (integer): Number of people in the group
- `trials` (integer): Number of simulations

**Response:**
```json
{
  "probability": 0.507,
  "people": 23,
  "trials": 10000
}
```

## Prisoner's Dilemma API

### GET /simulate
Simulates prisoner's dilemma game.

**Parameters:**
- `strategy1` (string): First prisoner's strategy
- `strategy2` (string): Second prisoner's strategy
- `rounds` (integer): Number of rounds

**Response:**
```json
{
  "prisoner1_score": 15,
  "prisoner2_score": 12,
  "rounds": 10,
  "decisions": [...]
}
```
