#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\n~~ Welcome to Number Guessing Game ~~\n"

echo -e "Enter your username:\n"
read USERNAME

USER_AVAILABLE=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
GAME_PLAYED=$($PSQL "SELECT COUNT(username) FROM users INNER JOIN games USING (user_id) WHERE username='$USERNAME'")
BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM users INNER JOIN games USING (user_id) WHERE username='$USERNAME'")

if [[ -z $USER_AVAILABLE ]]
then
INSERT_USER=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
echo -e "Welcome, $USERNAME! It looks like this is your first time here.\n"
else
echo "Welcome back, $USERNAME! You have played $GAME_PLAYED games, and your best game took $BEST_GAME guesses."
fi

RANDOM_NUMBER=$(( RANDOM % 1000 + 1 ))
GUESS=1

echo "Guess the secret number between 1 and 1000:"
while read G_NUMBER
do
if [[ ! $G_NUMBER =~ ^[0-9]+$ ]]
  then
  echo "That is not an integer, guess again:"
  else
    if [[ $G_NUMBER -eq $RANDOM_NUMBER ]]
    then
    break;
    else
      if [[ $G_NUMBER -gt $RANDOM_NUMBER ]]
      then
      echo "It's lower than that, guess again:"
      elif [[ $G_NUMBER -lt $RANDOM_NUMBER ]]
      then
      echo "It's higher than that, guess again:"
    fi
  fi
fi
GUESS=$(( $GUESS + 1 ))
done

if [[ $GUESS == 1 ]]
then
echo "You guessed it in $GUESS tries. The secret number was $RANDOM_NUMBER. Nice job!"
else
echo "You guessed it in $GUESS tries. The secret number was $RANDOM_NUMBER. Nice job!"
fi


USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
INSERT_GUESS_NO=$($PSQL "INSERT INTO games (number_of_guesses, user_id) VALUES ($GUESS, $USER_ID)")
