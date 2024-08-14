#!/bin/bash
# FOLDERINSTALL is the root path of the app
# ADDRESS is the db connection address
# show upgradedb.sh for more information
ROOT=$FOLDERINSTALL/install/pgsql
# SQL scripts to execute. Must be in $ROOT folder
psql $ADDRESS -f "$ROOT/alter_0.0-0.1.sql"
# For the last version:
#echo "nothing to do"