#! /bin/bash

# psql string connection:
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# generate a random number up to 1000:
NUMBER=$(($RANDOM % 1000))
# Prompt the user for a username:
echo -e "Enter your username:\n"
read USERNAME
QUERY=$($PSQL "SELECT games_played, best_game FROM users WHERE username = '$USERNAME'" | sed 's/|/ /g') 
# If it's been registered before: (Welcome back, <username>! You have played <games_played> games, and your best game took <best_game> guesses.)
if [[ ! -z $QUERY ]]
then
  echo $QUERY | (read GAMES_PLAYED BEST_GAME; echo -e "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.\n")
# If it's the user's first time:
else
  echo -e "Welcome, $USERNAME! It looks like this is your first time here."
  INSERT_NEW_USER="$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")"
fi
# Guess the secret number between 1 and 1000:
# if is not the correct answer:
# if the correct number is guessed: