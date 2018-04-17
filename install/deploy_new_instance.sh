#!/bin/bash
# install a new instance into a server
# must be executed from login root

echo "this script will install apache server and php, postgresql and deploy the current version of Collec-Science"
read -p "Do you want to continue [ y/n]?" response
if [ "$response" = "y" ] then

# installing packages
apt-get install unzip apache2 libapache2-mod-php7.0 php7.0 php7.0-ldap php7.0-pgsql php7.0-xml php7.0-zip postgresql postgresql-client
a2enmod ssl
a2enmod headers
a2enmod rewrite
chmod -R g+r /etc/ssl/private
usermod www-data -a -G ssl-cert
a2ensite default-ssl
a2ensite 000-default

# installation software
cd /var/www/html
mkdir collec-science
cd collec-science

# download software
echo "download software"
wget https://github.com/Irstea/collec/archive/master.zip
unzip collec-master.zip
mv collec-master collec-2.0
ln -s collec-2.0 collec

# update rights on files
chmod -R 750 .
chgrp -R www-data .

# update rights to specific software folders
chmod -R 770 collec/display/templates_c
chmod -R 770 collec/temp

# create param.inc.php file
mv collec/param/param.inc.php.dist collec/param/param.inc.php

# creation of database
echo "creation of the database"
su postgres -c "psql -f init_by_psql.sql"
read -p "Enter to continue" answer

# creation of virtual host
cp collec/install/apache2/collec_science.conf /etc/apache2/sites-available/
echo "you must modify the file /etc/apache2/sites-available/collec-science.conf,"
echo "then run theses commands:"
echo "a2ensite collec-science"
echo "service apache2 reload"
read -p "Enter to continue" answer
echo "you must configure access rights to postgresql:"
echo "- edit the file /etc/postgresql/version/main/pg_hba.conf"
echo "- insert theses lines (connection only with login collec into localhost):"
echo "host    collec             collec             127.0.0.1/32            md5"
echo "host    all            collec                  0.0.0.0/0               reject"
echo "- and reload postgresql configuration with:"
echo "service postgresql reload"

fi