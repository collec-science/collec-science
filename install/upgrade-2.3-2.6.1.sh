#!/bin/bash
# upgrade an instance 2.1 to 2.2
OLDVERSION=collec-2.3
VERSION=collec-2.6.1
echo "Content of /var/www/html/collec-science"
ls -l /var/www/html/collec-science
echo "This script will install the release $VERSION"
echo "have you a backup of your database and a copy of param/param.inc.php?"
echo "Is your actual version of Collec-Science is $OLDVERSION ?"
echo "Is your actual version is in the folder /var/www/html/collec-science/$OLDVERSION, and the symbolic link collec point to $OLDVERSION?"
read -p "Do you want to continue [Y/n]?" answer
if [[ $answer = "y"  ||  $answer = "Y"  ||   -z $answer ]];
then
cd /var/www/html/collec-science
rm -f *zip
# download last code
echo "install postgis"
apt-get -y install postgis
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
echo "update database"
chmod -R 755 /var/www/html/collec-science
cd collec/install
su postgres -c "psql -f upgrade-2.3-2.4.sql"
su postgres -c "psql -f upgrade-2.4-2.5.sql"
su postgres -c "psql -f upgrade-2.5-2.6.sql"
chmod -R 750 /var/www/html/collec-science
cd ../..

# assign rights to new folder
mkdir $VERSION/display/templates_c
chmod -R 750 $VERSION
chgrp -R www-data $VERSION

# update rights to specific software folders
chmod -R 770 $VERSION/display/templates_c
chmod -R 770 $VERSION/temp



# update php.ini file
PHPVER=`php -v|head -n 1|cut -c 5-7`
PHPINIFILE="/etc/php/$PHPVER/apache2/php.ini"
sed -i "s/; max_input_vars = .*/max_input_vars=$max_input_vars/" $PHPINIFILE
systemctl restart apache2
echo "Upgrade completed. Check, in the messages, if unexpected behavior occurred during the process"
fi
fi
