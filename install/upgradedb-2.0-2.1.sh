#!/bin/bash
echo "have you a backup of your database and a copy of param/param.inc.php?"
echo "Is your actual version of Collec-Science is 2.0?"
read -p "Do you want to continue [Y/n]?" answer
if [[  $answer = "y"  ||  $answer = "Y"  ||   -z $answer ]];
then
echo "update database..."
# command for upgrade when the database is in the same server than software
su postgres -c "psql -f pgsql/col_alter_2.0-2.1.sql"
# command for upgrade when the database is hosted in another server than software (collec is the name of database)
# psql -U userlogin -h servername -d collec -f pgsql/col_alter_2.0-2.1.sql
fi