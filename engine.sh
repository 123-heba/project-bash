#!/bin/bash

db_dir="databases"

# Create a database
create_database() {
  read -p "Enter database name: " dbname
  if [ -d "$db_dir/$dbname" ]; then
    echo "⚠ Database already exists."
  else
    mkdir "$db_dir/$dbname"
    echo "✔ Database created: $dbname"
  fi
}

# Create a table
create_table() {
  read -p "Enter database name: " dbname
  if [ ! -d "$db_dir/$dbname" ]; then
    echo "⚠ Database does not exist."
    return
  fi

  read -p "Enter table name: " tablename
  read -p "Enter number of columns: " col_num

  header=""
  for (( i=1; i<=col_num; i++ ))
  do
    read -p "Enter name of column $i: " colname
    if [[ $i -eq $col_num ]]; then
      header+="$colname"
    else
      header+="$colname:"
    fi
  done

  echo "$header" > "$db_dir/$dbname/$tablename"
  echo "✔ Table created: $tablename in database: $dbname"
}

# Insert data into a table
insert_into_table() {
  read -p "Enter database name: " dbname
  read -p "Enter table name: " tablename
  table_file="$db_dir/$dbname/$tablename"

  if [ ! -f "$table_file" ]; then
    echo "⚠ Table does not exist."
    return
  fi

  IFS=':' read -ra columns <<< "$(head -n 1 "$table_file")"
  row=""

  for (( i=0; i<${#columns[@]}; i++ ))
  do
    read -p "${columns[$i]}: " value
    if [[ $i -eq $((${#columns[@]} - 1)) ]]; then
      row+="$value"
    else
      row+="$value:"
    fi
  done

  echo "$row" >> "$table_file"
  echo "✔ Data inserted into table: $tablename"
}

# Display table content
display_table() {
  read -p "Enter database name: " dbname
  read -p "Enter table name: " tablename
  table_file="$db_dir/$dbname/$tablename"

  if [ ! -f "$table_file" ]; then
    echo "Table does not exist."
    return
  fi

  echo "Table content: $tablename"
  column -s: -t < "$table_file"
}

# Main menu
while true; do
  echo -e "\n========= Bash DB Engine ========="
  echo "1) Create Database"
  echo "2) Create Table"
  echo "3) Insert Data into Table"
  echo "4) Display Table"
  echo "5) Exit"
  read -p "Select an option: " choice

  case $choice in
    1) create_database ;;
    2) create_table ;;
    3) insert_into_table ;;
    4) display_table ;;
    5) echo "Goodbye "; exit ;;
    *) echo "Invalid option." ;;
  esac
done
