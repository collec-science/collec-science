#!/bin/bash
# upgrade an instance 2.0 to 2.1
# not for use, release 2.1 don't exist the may, 4th 2018 !
echo "this script is a proof of concept, please, don't run it"
echo "have you a backup of your database and a copy of param/param.inc.php?"
echo "Is your actual version of Collec-Science is 1.2.3?"
echo "Is your actual version is in the folder /var/www/collec-science/collec-1.2.3, and the symbolic link collec point to collec-1.2.3?" 
read -p "Do you want to continue [y/n]?" answer
if [ $answer = "y" ] then
cd /var/www/html/collec-science
rm -f *zip
# download last code
echo "download software"
wget https://github.com/Irstea/collec/archive/master.zip
unzip collec-master.zip
mv collec-master collec-2.0


# assign rights to new folder
mkdir collec-2.1/display/templates_c
chmod -R 750 collec-2.0
chgrp -R www-data collec-2.0

# update rights to specific software folders
chmod -R 770 collec/display/templates_c
chmod -R 770 collec/temp

# copy of last param into the new code
cp collec/param/param.inc.php collec-2.0/param/

#replacement of symbolic link
rm -f collec
ln -s collec-2.0 collec

# upgrade database
echo "update database"
su postgres -c "psql -f upgrade_1.2.3-2.0.sql"
fi