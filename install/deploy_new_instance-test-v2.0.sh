#!/bin/bash
# install a new instance into a server
# must be executed with login root

echo "this script will install apache server and php, postgresql and deploy the current version of Collec-Science"
read -p "Do you want to continue [y/n]?" response
if [ "$response" = "y" ] 
then
# installing packages
apt-get install unzip apache2 libapache2-mod-php7.0 php7.0 php7.0-ldap php7.0-pgsql php7.0-mbstring php7.0-xml php7.0-zip php7.0-imagick php7.0-gd fop postgresql postgresql-client
a2enmod ssl
a2enmod headers
a2enmod rewrite
chmod -R g+r /etc/ssl/private
usermod www-data -a -G ssl-cert
a2ensite default-ssl
a2ensite 000-default

# creation of directory
cd /var/www/html
mkdir collec-science
cd collec-science
# download software
echo "download software"
wget https://github.com/Irstea/collec/archive/release-2.0.zip
unzip release-2.0.zip
mv collec-release-2.0 collec-2.0
ln -s collec-2.0 collec
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

# creation of virtual host
cp collec/install/apache2/collec-science.conf /etc/apache2/sites-available/
a2ensite collec-science
echo "creation of virtual site"
echo "you must modify the file /etc/apache2/sites-available/collec-science.conf,"
echo "then run this command:"
echo "service apache2 reload"
read -p "Enter to terminate" answer


fi