#!/bin/bash
echo "have you a backup of your database and a copy of param/param.inc.php?"
echo "Is your actual version of Collec-Science is 1.2?"
read -p "Do you want to continue [y/n]?" answer
if [ $answer = "y" ] 
then
echo "update database..."
# command for upgrade when the database is in the same server than software
su postgres -c "psql -f upgrade-1.2-1.2.3.sql"
# command for upgrade when the database is hosted in another server than software
# psql -U userlogin -h servername -f upgrade-1.2-1.2.3.sql
fi