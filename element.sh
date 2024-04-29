#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

MAIN() {
  # Main body of code
  # echo $1

  if [[ ! $1 =~ ^[0-9]+$ ]] #Input is not a number
  then
    ELEMENT_BY_SYMBOL=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1'")
    if [[ -z $ELEMENT_BY_SYMBOL ]]
    then
      ELEMENT_BY_NAME=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$1'")
      if [[ -z $ELEMENT_BY_NAME ]]
      then 
        EXIT
      else
        PRINT $(echo $ELEMENT_BY_NAME | sed 's/ |//g')
      fi
    else
      PRINT $(echo $ELEMENT_BY_SYMBOL | sed 's/ |//g')
    fi
    #echo $ELEMENT_BY_SYMBOL
    #echo $ELEMENT_BY_NAME

  else
    ELEMENT_BY_AN=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")
    #echo $(echo $ELEMENT_BY_AN | sed 's/ |//g')
    if [[ -z $ELEMENT_BY_AN ]] # does not exist
    then
      EXIT
    else
      PRINT $(echo $ELEMENT_BY_AN | sed 's/ |//g')
    fi
  fi
  
}

PRINT() {
  echo -e "The element with atomic number $1 is $2 ($3). It's a $4, with a mass of $5 amu. $2 has a melting point of $6 celsius and a boiling point of $7 celsius."
}

EXIT() {
  echo -e "I could not find that element in the database."
}

if [[ $1 ]]
then
  #Main body of code
  MAIN $1
else
  echo -e "Please provide an element as an argument."
fi

