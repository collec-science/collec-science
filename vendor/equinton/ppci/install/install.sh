#!/bin/bash
PPCI=vendor/equinton/ppci/install
cp -f $PPCI/env .
cp -f env .env
cp -Rf $PPCI/app/Config/* app/Config/
cp -Rf $PPCI/app/Libraries/* app/Libraries/
cp -Rf $PPCI/app/Language/* app/Language/
cp -Rf $PPCI/public/* public/
cp -Rf $PPCI/install .
cp -f $PPCI/.gitignore .
cp -f $PPCI/upgradedb.sh .
mkdir app/Views/templates
cp -Rf $PPCI/app/Views/templates/* app/Views/templates/
echo "add javascript components"
cd public/display
npm update
cd ../..
mkdir -p writable/templates_c
mkdir writable/temp
touch writable/templates_c/.gitkeep
touch writable/temp/.gitkeep
chmod -R g+w writable
chgrp -R www-data writable
echo "generate encryption keys"
openssl genpkey -algorithm rsa -out id_app -pkeyopt rsa_keygen_bits:2048
openssl rsa -in id_app -pubout -out id_app.pub
chown www-data id_app

# Treatment of locales
echo ""
echo "Activation of locales"
echo "You must edit the file /etc/locale.gen, and uncomment the line:"
echo "en_GB.UTF-8"
echo "and after, run these commands:"
echo "locale-gen"
echo "systemctl restart apache2"
