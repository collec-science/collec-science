#!/bin/bash 
REPO=https://github.com/collec-science/collec-science
PHPVER=`php -version|grep "cli"| cut -f 2 -d " "|cut -f 1-2 -d "."`
OLDINSTALL=/var/www/collecApp/collec-science
echo "This script is used to migrate your instance of Collec-Science from versions before v25.0.0 to the current version of the application"
echo "Your version of PHP is $PHPVER. It must be greater or equal to 8.3. If not, you must upgrade your version of PHP with this script before:"
echo "https://github.com/collec-science/collec-science/raw/main/install/php_upgrade.sh"
echo ""
echo "Your previous install is normally here: $OLDINSTALL"
echo "If not, edit this script before run it"

read -p "Do you want to continue [Y/n]?" response
if [ "$response" = "y" ] || ["$response" = "Y"] || ["$response" = ""]
then
echo "Add new packages"
apt-get -y install $PHPVER-intl git

echo "Create the /var/www/collec2App directory"
mkdir /var/www/collec2App

echo "clone the repository"
cd /var/www/collec2App
git clone https://github.com/collec-science/collec-science.git -b main
# update rights on files
chmod -R 755 collec-science/
cd collec-science
# create .env file
cp env .env
chgrp www-data .env

echo "copy the cryptographic keys from the previous install"
cp $OLDINSTALL/param/id_collec* .

echo "upgrade rights on files and folders"
chgrp -R www-data .
find . -type d -exec chmod 750 {} \;
find . -type f -exec chmod 640 {} \;
chmod -R g+w writable
chmod +x *.sh

echo "Adjust locale support - add English language in Linux"
sed -i "s/# en_GB.UTF-8/en_GB.UTF-8/" /etc/locale.gen
/usr/sbin/locale-gen

echo "Replace the virtual host apache"
cp install/apache2/collec2.conf /etc/apache2/sites-available/
/usr/sbin/a2ensite collec2
/usr/sbin/a2dissite collec

echo "Activation of automatic emails"
line="0 8 * * * /var/www/collec2App/collec-science/collectionsGenerateMail.sh"
echo "$line" | crontab -u www-data -

echo "-----"
echo "End of the scriptable operations"
echo "-----"
echo "You must:"
echo "#1 Verify the content of /var/www/collec2App/collec-science/.env file"
echo "and in particular the database connection and the identification mode"
echo "you can show the previous values with:"
echo "cat /var/www/collecApp/collec-science/param/param.inc.php"
echo ""
echo "#2 edit the file /etc/apache2/sites-available/collec2.conf"
echo "and replace collec.mysociety.com by your fqdn, and verify the used certificate (SSLCertificateFile and SSLCertificateKeyFile)"
echo ""
echo "#3 upgrade the database, by running this script"
echo "cd /var/www/collec2App/collec-science"
echo "./upgradedb.sh"
echo ""
echo "#4 restart the apache server:"
echo "systemctl restart apache2"
echo ""
echo "In case of problem, you can open a ticket here:"
echo "https://github.com/collec-science/collec-science/issues/new/choose"
echo ""
echo "That's all, folks! Enjoy!"

fi
# End of script