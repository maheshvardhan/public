#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[  $1 ]]
  then
  if [[ ! $1 =~ ^[0-9]+$ ]]
    then
    PROPERTIES_ELEMENTS=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties JOIN elements USING (atomic_number) JOIN types USING (type_id) WHERE name LIKE '$1%' ORDER BY atomic_number LIMIT 1")
    else
    PROPERTIES_ELEMENTS=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties JOIN elements USING (atomic_number) JOIN types USING (type_id) WHERE atomic_number=$1 LIMIT 1")
  fi
    if [[ -z $PROPERTIES_ELEMENTS ]]
      then
    echo "I could not find that element in the database."
    else
    echo "$PROPERTIES_ELEMENTS" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS
    do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius." 
    done
    fi
  else
  echo "Please provide an element as an argument."
fi


