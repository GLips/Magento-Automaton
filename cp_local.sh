#!/bin/bash
clear

echo "###########################################################"
echo "###########################################################"
echo "######                     #####                     ######"
echo "######                     #####                     ######"
echo "######     #####################     ############    ######"
echo "######     #####################     ############    ######"
echo "######     #####################     ############    ######"
echo "######     #####################     ############    ######"
echo "######     #####################                     ######"
echo "######     #####################                     ######"
echo "######     #####################     ######################"
echo "######     #####################     ######################"
echo "######     #####################     ######################"
echo "######                     #####     ######################"
echo "######                     #####     ######################"
echo "###########################################################"
echo "###########################################################"
echo "#                                                         #"
echo "#         Welcome to the CP Devsite setup script!         #"
echo "#  We're going to need some information before we begin.  #"
echo "#                                                         #"
echo "###########################################################"
echo ""
echo ""

NOW=$(date +"%m-%d-%Y")
FILES="cpdev.$NOW.tgz"
DB="cpdev.$NOW.sql"
TABLES="tables.$NOW.txt"
USERNAME=$(whoami)

overwrite_function() {
  read -p "This table already exists. Would you like to overwrite it? (y/n) " OVERWRITE
  if [ $OVERWRITE == "y" ]
  then
    echo "Overwriting $DB_NAME..."
    import_mysql
  elif [ $OVERWRITE == "n" ]
  then
    echo "Keeping the old database data..."
  else
    echo "Input not recognized. Use 'y' or 'n'"
    overwrite_function
  fi
}

import_mysql() {
  echo "Importing database information into $DB_NAME..."
  mysql -u dev -puSF5k4RN72L8dhc $DB_NAME < $DB
  echo "Information imported into $DB_NAME..."
}

# Get new DIR_NAME name
read -p "New repository name: " DIR_NAME
# Get DB_NAME to import to
read -p "New DB table: " DB_NAME

# Create empty git repo using DIR_NAME
echo "Creating a new repository in /home/repos/$DIR_NAME.git..."
git init --bare /home/repos/$DIR_NAME.git

# Clone git repo
echo "Cloning the new repository from /home/repos/$DIR_NAME.git..."
git clone /home/repos/$DIR_NAME.git

# Add default ignored files to .gitignore
echo "Making sure the .gitignore file exists..."
touch $DIR_NAME/.gitignore
echo "Adding some files to the .gitignore"
echo "var/*" >> $DIR_NAME/.gitignore
echo "*.tgz" >> $DIR_NAME/.gitignore
echo "*.sql" >> $DIR_NAME/.gitignore

# Extract tarball to new git repo
echo "Extracting files into $DIR_NAME..."
tar -zxf $FILES -C ./$DIR_NAME

# Create new db table using $DB_NAME
mysql -u dev -puSF5k4RN72L8dhc -Bse 'SHOW DATABASES' > $TABLES;
if grep --quiet -c $DB_NAME $TABLES; then
  # DB exists, ask user if they'd like to overwrite it
  overwrite_function
else
  echo "Database doesn't already exist, building '$DB_NAME' now..."
  mysql -u dev -puSF5k4RN72L8dhc -Bse "CREATE SCHEMA $DB_NAME"
  echo "Database '$DB_NAME' created..."
  import_mysql
fi
rm $TABLES;

# Set permissions on index.php
echo "Moving into '$DIR_NAME'..."
cd $DIR_NAME
echo "Setting permissions on index.php..."
chmod 755 index.php

# Purge cache
echo "Removing all cached files..."
rm -rf var/cache/*

# Run devsite.sh
echo "Running devsite.sh with your credentials..."
/home/repos/shell/devsite.sh "~$USERNAME/$DIR_NAME/"



echo ""
echo ""
echo "###########################################################"
echo "###       ####        ###   ###  ###        ###   ###   ###"
echo "###  ####  ###  ####  ###    ##  ###  #########   ###   ###"
echo "###  ##### ###  ####  ###  #  #  ###  #########   ###   ###"
echo "###  ##### ###  ####  ###  ##    ###        ###   ###   ###"
echo "###  ####  ###  ####  ###  ###   ###  #####################"
echo "###       ####        ###  ####  ###        ###   ###   ###"
echo "###########################################################"
echo "###                                                     ###"
echo "###      Don't forget to modify app/etc/local.xml!      ###"
echo "###                                                     ###"
echo "###########################################################"