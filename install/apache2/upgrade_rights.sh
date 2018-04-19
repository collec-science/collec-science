#!/bin/bash
# program setting rights in collec-science
# must be run as upgrade_rights.sh folder
if [ -d $1 ]
then
echo "Setting rights into "$1
chmod -R 750 $1
mkdir $1/display/templates_c
chgrp -R www-data $1
chmod -R 770 $1/display/templates_c
chmod -R 770 $1/temp
else 
echo "folder "$1 "don't exists"
fi
