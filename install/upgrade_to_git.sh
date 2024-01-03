#!/bin/bash
cd /var/www/html/collec-science
git clone https://github.com/collec-science/collec-science -b master
cd collec-science
cp ../collec/param/param.inc.php param/
cp ../collec/param/id_collec* param/
mkdir display/templates_c
mkdir temp
find . -type d -exec chmod 750 {} \;
find . -type f -exec chmod 640 {} \;
chmod -R g+w display/templates_c
chmod -R g+w temp
chgrp -R www-data .
rm -Rf test
cd ..
rm collec
ln -s collec-science collec

# PHP version
PHPOLDVERSION=`php -v|grep ^PHP|cut -d " " -f 2|cut -d "." -f 1-2`
echo "Your php version is $PHPOLDVERSION"
echo "Collec-Science must run with PHP 8.1 or above."
echo "You can upgrade your PHP version with this command:"
echo "install/php_upgrade.sh"
read -p "[Enter] to continue, or [ctrl C] to stop the script" answer

echo "Upgrade the database"
read -p "[Enter] to continue" answer
# Database
cp collec-science/install/upgradedb.sh.dist ./upgradedb.sh
chmod 750 upgradedb.sh
./upgradedb.sh

# add mail sender
ln -s /var/www/html/collec-science /var/www/collecApp
cp collec-science/collectionsGenerateMail.sh .
echo "0 8 * * * /var/www/collecApp/collectionsGenerateMail.sh" | crontab -u www-data -
chmod +x /var/www/collecApp/collectionsGenerateMail.sh

