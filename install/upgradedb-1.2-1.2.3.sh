#!/bin/bash
echo "have you a backup of your database and a copy of param/param.inc.php?"
echo "Is your actual version of Collec-Science is 1.2?"
read -p "Do you want to continue [y/n]?" answer
if [ $answer = "y" ] then
echo "update database"
su postgres -c "psql -f upgrade-1.2-1.2.3.sql"
fi