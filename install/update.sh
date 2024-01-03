#!/bin/bash
cd collec-science
git restore .
git pull origin master
install/upgradedb.sh
cd ..
