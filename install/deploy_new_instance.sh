#!/bin/bash
# install a new instance into a server
# must be executed with login root
# creation : Eric Quinton - 2017-05-04
REPO=https://github.com/collec-science/collec-science
PHPVER=8.3
PHPINIFILE="/etc/php/$PHPVER/apache2/php.ini"
echo "Installation of Collec-Science app "
echo "This script is available for Debian or Ubuntu server"
echo "this script will install apache server and php, postgresql and deploy the current version of Collec-Science"
read -p "Do you want to continue [y/n]?" response
if [ "$response" = "y" ]
then
# installing php repository
apt -y install lsb-release apt-transport-https ca-certificates
DISTRIBCODE=`lsb_release -sc`
DISTRIBNAME=`lsb_release -si`
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
if [ $DISTRIBNAME == 'Ubuntu' ]
then
apt-get install software-properties-common
add-apt-repository -y ppa:ondrej/php
add-apt-repository -y ppa:ondrej/apache2
elif [ $DISTRIBNAME == 'Debian' ]
then
wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -
echo "deb https://packages.sury.org/php/ $DISTRIBCODE main" | tee /etc/apt/sources.list.d/php.list
fi
apt-get update
# installing packages
apt-get -y install unzip apache2 libapache2-mod-evasive libapache2-mod-php$PHPVER php$PHPVER php$PHPVER-ldap php$PHPVER-pgsql php$PHPVER-mbstring php$PHPVER-xml php$PHPVER-zip php$PHPVER-imagick php$PHPVER-gd php$PHPVER-curl php$PHPVER-intl postgresql postgresql-client postgis git
/usr/sbin/a2enmod ssl
/usr/sbin/a2enmod headers
/usr/sbin/a2enmod rewrite
/usr/sbin/a2ensite default-ssl
/usr/sbin/a2ensite 000-default

# creation of directory
cd /var/www
mkdir collec2App
cd collec2App

# download software
echo "download software"
git clone https://github.com/collec-science/collec-science.git -b main

# update rights on files
chmod -R 755 collec-science/
cd collec-science
# create .env file
cp env .env
chgrp www-data .env
# creation of database
echo "creation of the database"
cd install
su postgres -c "psql -f init_by_psql.sql"
cd ..
echo "you may verify the configuration of access to postgresql"
echo "look at /etc/postgresql/13/main/pg_hba.conf (verify your version). Only theses lines must be activate:"
echo '# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
# IPv6 local connections:
host    all             all             ::1/128                 md5'

read -p "Enter to continue" answer

# install backup program
echo "backup configuration - dump at 20:00 into /var/lib/postgresql/backup"
echo "please, set up a data transfert mechanism to deport them to another medium"
cp install/pgsql/backup.sh /var/lib/postgresql/
chown postgres /var/lib/postgresql/backup.sh
line="0 20 * * * /var/lib/postgresql/backup.sh"
#(crontab -u postgres -l; echo "$line" ) | crontab -u postgres -
echo "$line" | crontab -u postgres -

# generate rsa key for encrypted tokens
echo "generate encryption keys for identification tokens"
openssl genpkey -algorithm rsa -out id_collec -pkeyopt rsa_keygen_bits:2048
openssl rsa -in id_collec -pubout -out id_collec.pub
chown www-data id_collec

# update rights to specific software folders
chgrp -R www-data .
find . -type d -exec chmod 750 {} \;
find . -type f -exec chmod 640 {} \;
chmod -R g+w writable

# adjust php.ini values
PHPINIFILE="/etc/php/$PHPVER/apache2/php.ini"
upload_max_filesize="=100M"
post_max_size="=50M"
max_execution_time="=120"
max_input_time="=240"
memory_limit="=1024M"
max_input_vars="10000"
short_open_tag="Off"
expose_php="Off"
display_errors="Off"
display_startup_errors="Off"
log_errors="On"
for key in upload_max_filesize post_max_size max_execution_time max_input_time memory_limit
do
sed -i "s/^\($key\).*/\1 $(eval echo \${$key})/" $PHPINIFILE
done
sed -i "s/; max_input_vars = .*/max_input_vars=$max_input_vars/" $PHPINIFILE
sed -i "s/; short_open_tag = .*/short_open_tag=$short_open_tag/" $PHPINIFILE
sed -i "s/; expose_php = .*/expose_php=$expose_php/" $PHPINIFILE
sed -i "s/; display_errors = .*/display_errors=$display_errors/" $PHPINIFILE
sed -i "s/; display_startup_errors = .*/display_startup_errors=$display_startup_errors/" $PHPINIFILE
sed -i "s/; log_errors = .*/log_errors=$log_errors/" $PHPINIFILE
# adjust imagick policy
sed -e "s/  <policy domain=\"coder\" rights=\"none\" pattern=\"PDF\" \/>/  <policy domain=\"coder\" rights=\"read|write\" pattern=\"PDF\" \/>/" /etc/ImageMagick-6/policy.xml > /tmp/policy.xml
cp /tmp/policy.xml /etc/ImageMagick-6/

# adjust locale support
sed -i "s/# en_GB.UTF-8/en_GB.UTF-8/" /etc/locale.gen
/usr/sbin/locale-gen

# Activation of automatic emails
line="0 8 * * * /var/www/collec2App/collec-science/collectionsGenerateMail.sh"
echo "$line" | crontab -u www-data -

# Adjust Apache2 security
A2SECFILE="/etc/apache2/conf-available/security.conf"
sed -i "s/#ServerTokens Full/ServerTokens Prod/" $A2SECFILE
sed -i "s/#TraceEnable On/TraceEnable Off/" $A2SECFILE
sed -i "s/#ServerSignature On/ServerSignature Off/" $A2SECFILE

# creation of virtual host
echo "creation of virtual site"
cp install/apache2/collec2.conf /etc/apache2/sites-available/
/usr/sbin/a2ensite collec2
echo "you must modify the file /etc/apache2/sites-available/collec2.conf"
echo "as address of your instance, ssl parameters,"
echo "then run this command:"
echo "systemctl restart apache2"

echo ""
echo "To activate the sending of e-mails, you must install an application as Postfix or msmtp and configure it"
echo "The configuration is specific of each organization: this script cannot do it, sorry..."

read -p "Enter to terminate" answer

fi
# end of script
