#!/bin/bash
OLDVERSION=collec-2.6.0
VERSION=collec-2.6.1
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
echo "wget https://github.com/Irstea/collec/raw/master/install/php_upgrade.sh"
echo "chmod +x php_upgrade.sh"
echo "./php_upgrade.sh"
cd /var/www/html/collec-science
rm -f *zip
# download last code
echo "download software"
wget https://github.com/Irstea/collec/archive/master.zip
read -p "Ok to install this release [Y/n]?" answer

if [[  $answer = "y"  ||  $answer = "Y"  ||   -z $answer ]];
then

unzip master.zip
mv collec-master/ $VERSION

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
