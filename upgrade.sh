#!/bin/bash
cd /var/www/collec2App/collec-science
git restore .
git pull origin main
./upgradedb.sh
systemctl restart apache2
