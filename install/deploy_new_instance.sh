#!/bin/bash
# install a new instance into a server
# must be executed with login root
# creation : Eric Quinton - 2017-05-04
VERSION=2.3.1
PHPVER=7.3
PHPINIFILE="/etc/php/$PHPVER/apache2/php.ini"
echo "Installation of Collec-Science version " $VERSION
echo "this script will install apache server and php, postgresql and deploy the current version of Collec-Science"
read -p "Do you want to continue [y/n]?" response
if [ "$response" = "y" ]
then
# installing php repository
apt -y install lsb-release apt-transport-https ca-certificates
DISTRIBCODE=`lsb_release -sc`
DISTRIBNAME=`lsb_release -si`
if [ $DISTRIBNAME == 'Ubuntu' ]
then
apt-get install software-properties-common
add-apt-repository -y ppa:ondrej/php
add-apt-repository -y ppa:ondrej/apache2
elif [ $DISTRIBNAME == 'Debian' ]
then
wget -qO https://packages.sury.org/php/apt.gpg | apt-key add -
echo "deb https://packages.sury.org/php/ $DISTRIBCODE main" | tee /etc/apt/sources.list.d/php.list
fi
apt-get update
# installing packages
apt-get -y install unzip apache2 libapache2-mod-evasive libapache2-mod-php$PHPVER php$PHPVER php$PHPVER-ldap php$PHPVER-pgsql php$PHPVER-mbstring php$PHPVER-xml php$PHPVER-zip php$PHPVER-imagick php$PHPVER-gd fop postgresql postgresql-client
a2enmod ssl
a2enmod headers
a2enmod rewrite
# chmod -R g+r /etc/ssl/private
# usermod www-data -a -G ssl-cert
a2ensite default-ssl
a2ensite 000-default

# creation of directory
cd /var/www/html
mkdir collec-science
cd collec-science

# download software
echo "download software"
wget https://github.com/Irstea/collec/archive/master.zip
unzip master.zip
mv collec-master collec-$VERSION
ln -s collec-$VERSION collec

# update rights on files
chmod -R 755 .

# create param.inc.php file
mv collec/param/param.inc.php.dist collec/param/param.inc.php
# creation of database
echo "creation of the database"
cd collec/install
su postgres -c "psql -f init_by_psql.sql"
cd ../..
echo "you may verify the configuration of access to postgresql"
echo "look at /etc/postgresql/9.6/main/pg_hba.conf (verify your version). Only theses lines must be activate:"
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
cp collec/install/pgsql/backup.sh /var/lib/postgresql/
chown postgres /var/lib/postgresql/backup.sh
line="0 20 * * * /var/lib/postgresql/backup.sh"
#(crontab -u postgres -l; echo "$line" ) | crontab -u postgres -
echo "$line" | crontab -u postgres -

# update rights to specific software folders
chmod -R 750 .
mkdir collec/display/templates_c
chgrp -R www-data .
chmod -R 770 collec/display/templates_c
chmod -R 770 collec/temp

# generate rsa key for encrypted tokens
echo "generate encryption keys for identification tokens"
openssl genpkey -algorithm rsa -out collec/param/id_collec -pkeyopt rsa_keygen_bits:2048
openssl rsa -in collec/param/id_collec -pubout -out collec/param/id_collec.pub
chown www-data collec/param/id_collec

# adjust php.ini values
upload_max_filesize="=100M"
post_max_size="=50M"
max_execution_time="=120"
max_input_time="=240"
memory_limit="=1024M"
max_input_vars="10000"
for key in upload_max_filesize post_max_size max_execution_time max_input_time memory_limit
do
 sed -i "s/^\($key\).*/\1 $(eval echo \${$key})/" $PHPINIFILE
done
sed -i "s/; max_input_vars = .*/max_input_vars=$max_input_vars/" $PHPINIFILE

# adjust imagick policy
sed -e "s/  <policy domain=\"coder\" rights=\"none\" pattern=\"PDF\" \/>/  <policy domain=\"coder\" rights=\"read|write\" pattern=\"PDF\" \/>/" /etc/ImageMagick-6/policy.xml > /tmp/policy.xml
cp /tmp/policy.xml /etc/ImageMagick-6/

# creation of virtual host
echo "creation of virtual site"
cp collec/install/apache2/collec-science.conf /etc/apache2/sites-available/
a2ensite collec-science
echo "you must modify the file /etc/apache2/sites-available/collec-science.conf"
echo "address of your instance, ssl parameters),"
echo "then run this command:"
echo "service apache2 reload"
read -p "Enter to terminate" answer

fi
# end of script
