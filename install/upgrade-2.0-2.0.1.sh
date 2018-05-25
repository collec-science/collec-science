#!/bin/bash
# upgrade an instance 2.0 to 2.0.1
OLDVERSION=collec-2.0
VERSION=collec-2.0.1
echo "have you a backup of your database and a copy of param/param.inc.php?"
echo "Is your actual version of Collec-Science is $VERSION ?"
echo "Is your actual version is in the folder /var/www/collec-science/$OLDVERSION, and the symbolic link collec point to $OLDVERSION?" 
read -p "Do you want to continue [y/n]?" answer
if [ $answer = "y" ]
then
cd /var/www/html/collec-science
rm -f *zip
# download last code
echo "download software"
wget https://github.com/Irstea/collec/archive/master.zip
read -p "Ok for install this release [y/n]?" answer
if [  -z $answer ]
then
answer=y
fi

if [  $answer = "y" ]
then

unzip master.zip
mv collec-master/ $VERSION


# assign rights to new folder
mkdir $VERSION/display/templates_c
chmod -R 750 $VERSION
chgrp -R www-data $VERSION

# update rights to specific software folders
chmod -R 770 collec/display/templates_c
chmod -R 770 collec/temp

# copy of last param into the new code
cp collec/param/param.inc.php $VERSION/param/
# keys for tokens
if [ -e collec/param/id_collec ]
then
cp collec/param/id_collec* $VERSION/param/
chown www-data $VERSION/param/id_collec
fi

#replacement of symbolic link
rm -f collec
ln -s $VERSION collec

# upgrade database
# echo "update database"
# su postgres -c "psql -f upgrade_1.2.3-2.0.sql"
fi
fi
