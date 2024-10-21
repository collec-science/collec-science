#!/bin/bash
export envPath="/var/www/collec2App/collec-science"
cd $envPath/public
php index.php collectionsGenerateMail
