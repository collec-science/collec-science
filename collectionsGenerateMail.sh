#!/bin/bash
export envPath="/var/www/collec2App/collec-science"
cd $envPath/public
log="$envPath/writable/logs/log-collectionsGenerateMail.log"
php index.php collectionsGenerateMail > $log 2>&1
