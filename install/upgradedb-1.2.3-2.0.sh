#!/bin/bash
echo "have you a backup of your database and a copy of param/param.inc.php?"
echo "Is your actual version of Collec-Science is 1.2.3?"
read -p "Do you want to continue [y/n]?" answer
if [ $answer = "y" ]
then
echo "update database..."
# command for upgrade when the database is in the same server than software
su postgres -c "psql -f pgsql/col_alter_1.2.3-2.0.sql"
# command for upgrade when the database is hosted in another server than software (collec is the name of database)
# psql -U userlogin -h servername -d collec -f pgsql/col_alter_1.2.3-2.0.sql
fi