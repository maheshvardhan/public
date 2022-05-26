#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"




echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU() {
if [[ $1 ]]
then 
echo -e "\n$1\n"
fi
AVAILABLE_SERVICE=$($PSQL "SELECT * FROM services")
echo "$AVAILABLE_SERVICE" | while read SERVICE_ID BAR NAME
do
echo "$SERVICE_ID) $NAME"
done
read SERVICE_ID_SELECTED 
}

MAIN_MENU

SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")

if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
then
MAIN_MENU "Please enter a valid option."
else
  if [[ -z $SERVICE_ID ]]
  then
  MAIN_MENU "I could not find that service. What would you like today?"
  else
  echo "What's your phone number?"
  read CUSTOMER_PHONE

  
  
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
    if [[ -z $CUSTOMER_NAME ]]
    then
    echo "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    
    

    CUSTOMERS_INSERT_RESULT=$($PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    
    echo "What time would you like your$SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

    INSERT_APPOINTMENTS_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID,$SERVICE_ID,'$SERVICE_TIME')")
    
    if [[ $INSERT_APPOINTMENTS_RESULT == "INSERT 0 1" ]]
    then
    echo "I have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    fi
    else
    echo "What time would you like your$SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME
    
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

    INSERT_APPOINTMENTS_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID,$SERVICE_ID,'$SERVICE_TIME')")
    
    if [[ $INSERT_APPOINTMENTS_RESULT == "INSERT 0 1" ]]
    then
    echo "I have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    fi    
    fi
  fi
fi