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

TRIES=0
GUESS_NUMBER() {
  if [[ -z $1 ]]
  then
    # Guess the secret number between 1 and 1000:
    echo -e "Guess the secret number between 1 and 1000:\n"
  else
    echo -e "$1\n"
  fi
  read ANSWER
  # if is not the correct answer:
  if [[ ! $ANSWER =~ [0-9]+ ]]
  then
    TRIES=$((TRIES+1))
    GUESS_NUMBER "That is not an integer, guess again:" 
  elif [[ $ANSWER -gt $NUMBER ]]
  then
    TRIES=$((TRIES+1))
    GUESS_NUMBER "It's lower than that, guess again:" 
  elif [[ $ANSWER -lt $NUMBER ]]
  then
    TRIES=$((TRIES+1))
    GUESS_NUMBER "It's higher than that, guess again:" 
  # if the correct number is guessed:
  else
    TRIES=$((TRIES+1))
    echo -e "You guessed it in $TRIES tries. The secret number was $NUMBER. Nice job!\n"
    GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username = '$USERNAME'")
    BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username = '$USERNAME'")
    # if the actual tries number is less than our last best game, then update it
    if [[ $TRIES -lt $BEST_GAME ]]
    then
      BEST_GAME=$TRIES
    fi
    # and add 1 to our games played record:
    GAMES_PLAYED=$((GAMES_PLAYED+1))
    UPDATE_GAMES_USER=$($PSQL "UPDATE users SET games_played = $GAMES_PLAYED, best_game = $BEST_GAME WHERE username = '$USERNAME'")
  fi
}

GUESS_NUMBER