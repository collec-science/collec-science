#!/bin/bash
# read .env parameters
SQL="select dbversion_number from sturwild.dbversion order by dbversion_id desc limit 1"
DBENV=.envdb
echo "" > .envdb
sed 's/ = /=/g' .env |grep -v '^#' |grep -v '\\' |
   while read -r line; do
        if [ ! -z "$line" ]; then
            var=`echo $line| cut -d '=' -f1`
            content=`echo $line | cut -d '=' -f2`
            if [ $var = "database.default.hostname" ]; then
                echo "DBHOST=$content" >> $DBENV
            fi
            if [ $var = "database.default.database" ]; then
                echo "DATABASE=$content" >> $DBENV
            fi
            if [ $var = "database.default.username" ]; then
            echo "LOGIN=$content" >> $DBENV
            fi
            if [ $var = "database.default.password" ]; then
            echo "PASSWORD=$content" >> $DBENV
            fi
            if [ $var = "BASE_DIR" ]; then
            echo "FOLDERINSTALL=$content" >> $DBENV
            fi
        fi
    done
    source $DBENV
    ADDRESS=postgresql://"$LOGIN":"$PASSWORD"@"$DBHOST"/"$DATABASE"
VERSION=`psql $ADDRESS -c "$SQL" -t|xargs`
SCRIPT="$FOLDERINSTALL/install/upgradedb-from-$VERSION.sh"
source $SCRIPT
rm $DBENV
