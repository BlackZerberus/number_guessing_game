#! /bin/bash

# psql string connection:
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# generate a random number up to 1000:
NUMBER=$(($RANDOM % 1000))
# Prompt the user for a username:
# If it's been registered before: (Welcome back, <username>! You have played <games_played> games, and your best game took <best_game> guesses.)
# If it's the user's first time:
# Guess the secret number between 1 and 1000:
# if is not the correct answer:
# if the correct number is guessed: