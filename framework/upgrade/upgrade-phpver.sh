#!/bin/bash
# Upgrade php version to 7.3
sudo apt install ca-certificates apt-transport-https
wget -q https://packages.sury.org/php/apt.gpg -O- | sudo apt-key add -
echo "deb https://packages.sury.org/php/ stretch main" | sudo tee /etc/apt/sources.list.d/php.list
sudo apt update
PHPVER=7.3
phpinifile="/etc/php/$PHPVER/apache2/php.ini"
sudo apt-get install libapache2-mod-php$PHPVER php$PHPVER php$PHPVER-ldap php$PHPVER-pgsql php$PHPVER-mbstring php$PHPVER-xml php$PHPVER-zip php$PHPVER-imagick php$PHPVER-gd php$PHPVER-curl
sudo a2dismod php7.0
sudo a2enmod php$PHPVER
upload_max_filesize="=100M"
post_max_size="=50M"
max_execution_time="=120"
max_input_time="=240"
memory_limit="=1024M"
for key in upload_max_filesize post_max_size max_execution_time max_input_time memory_limit
do
 sed -i "s/^\($key\).*/\1 $(eval echo \${$key})/" $phpinifile
done
sudo service apache2 restart
