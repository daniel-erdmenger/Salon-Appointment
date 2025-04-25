#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

SERVICES_MENU(){
AVAILABLE_SERVICES=$($PSQL "SELECT * FROM services")
echo -e "\nHere are the bikes we have available:"
echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME 
    do
      echo "$SERVICE_ID) $SERVICE_NAME"
    done
echo -e "\nWhich one would you like to get?"
    read SERVICE_ID_SELECTED
    if [[ ! $SERVICE_ID_SELECTED =~ ^[0-4]+$ ]]
    then
      SERVICES_MENU "That is not a valid service number."
    else
       echo -e "\nWhat's your phone number?"
        read CUSTOMER_PHONE
        
        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
         if [[ -z $CUSTOMER_NAME ]]
        then
        echo -e "\nWhat's your name?"
          read CUSTOMER_NAME
          INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
        fi
        echo -e "\nAt what time?"
        read SERVICE_TIME

        CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
        INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
        SERVICE_NAME_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
        echo "I have put you down for a $SERVICE_NAME_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."
    fi
}
SERVICES_MENU