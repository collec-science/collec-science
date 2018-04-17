#!/bin/bash
# upgrade an instance 2.0 to 2.1
# not for use, release 2.1 don't exist the may, 4th 2018 !
echo "have you a backup of your database and a copy of param/param.inc.php?"
echo "Is your actual version of Collec-Science is 2.0?"
read -p "Do you want to continue [ y/n]?" answer
if [ $answer = "y" ] then
cd /var/www/html/collec-science
rm -f *zip
# download last code
echo "download software"
wget https://github.com/Irstea/collec/archive/master.zip
unzip collec-master.zip
mv collec-master collec-2.1

# assign rights to new folder
chmod -R 750 collec-2.1
chgrp -R www-data collec-2.1

# update rights to specific software folders
chmod -R 770 collec/display/templates_c
chmod -R 770 collec/temp

# copy of last param into the new code
cp collec/param/param.inc.php collec-2.1/param/

# change virtual folder destination
rm -f collec
ln -s collec-2.1 collec

# upgrade database (if available)
echo "update database"
su postgres -c "psql -f upgrade_by_psql.sql"
fi