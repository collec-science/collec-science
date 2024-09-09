#!/bin/bash
export envPath="/var/www/collecApp/collec2"
cd $envPath/public
php index.php collectionsGenerateMail
