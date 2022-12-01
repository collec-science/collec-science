#!/bin/bash
OLDVERSION=collec-2.7.0
VERSION=collec-2.8.1
REPO=https://github.com/collec-science/collec-science
echo "Content of /var/www/html/collec-science"
ls -l /var/www/html/collec-science
echo "This script will install the release $VERSION"
echo "have you a backup of your database and a copy of param/param.inc.php?"
echo "Is your actual version of Collec-Science is $OLDVERSION ?"
echo "Is your actual version is in the folder /var/www/collec-science/$OLDVERSION, and the symbolic link collec point to $OLDVERSION?"
read -p "Do you want to continue [Y/n]?" answer
if [[ $answer = "y"  ||  $answer = "Y"  ||   -z $answer ]];
then
PHPOLDVERSION=`php -v|grep ^PHP|cut -d " " -f 2|cut -d "." -f 1-2`
echo "Your php version is $PHPOLDVERSION"
echo "Collec-Science must run with PHP 7.4 or above."
echo "You can upgrade your PHP version with these commands:"
echo "wget $REPO/raw/master/install/php_upgrade.sh"
echo "chmod +x php_upgrade.sh"
echo "./php_upgrade.sh"
cd /var/www/html/collec-science
rm -f *zip
# download last code
echo "download software"
wget $REPO/archive/refs/heads/master.zip
read -p "Ok to install this release [Y/n]?" answer

if [[  $answer = "y"  ||  $answer = "Y"  ||   -z $answer ]];
then

unzip master.zip
mv collec-science-master/ $VERSION


# copy of last param into the new code
cp collec/param/param.inc.php $VERSION/param/
chgrp www-data $VERSION/param/param.inc.php

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
echo "update database"
chmod -R 755 /var/www/html/collec-science
cd collec/install
su postgres -c "psql -f upgrade-2.7-2.8.sql"
su postgres -c "psql -f upgrade-2.8-2.8.1.sql"
cd ../..
chmod 750 -R /var/www/html/collec-science

# assign rights to new folder
mkdir $VERSION/display/templates_c
chmod -R 750 $VERSION
chgrp -R www-data $VERSION

# update rights to specific software folders
chmod -R 770 $VERSION/display/templates_c
chmod -R 770 $VERSION/temp

systemctl restart apache2

echo "Upgrade completed. Check, in the messages, if unexpected behavior occurred during the process"
fi
fi
