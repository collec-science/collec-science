#!/bin/bash
# install a new instance into a server
# must be executed with login root
# creation of directory
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
echo "creation of database"
su postgres -c "psql -f init_by_psql.sql"
read -p "Enter to continue" answer

# creation of virtual host
cp collec/install/apache2/collec_science.conf /etc/apache2/sites-available/
echo "you must modify the file /etc/apache2/sites-available/collec-science.conf,"
echo "then run theses commands:"
echo "a2ensite collec-science"
echo "service apache2 reload"

