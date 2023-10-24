---
title: Update Collec-Science from version 23.0.0
date: 24/10/2023
lang: fr
authors:
 - Éric Quinton
---

# Update Collec-Science from version 23.0.0

## General principle

Until version 23.0.0, Collec-Science updates were based on this principle :

- retrieve the code in zipped form

- decompressing the file and renaming the generated folder

- copying parameters from the previous version

- repositioning of file access rights

- launch database modification scripts

From version 23.0.0 onwards, upgrading is recommended using *git*, which makes intermediate updates much simpler and faster.

## Upgrade mode migration code

Before executing the code, check the paths indicated.

```
cd /var/www/html/collec-science
git clone https://github.com/collec-science/collec-science -b master
cd collec-science
cp ../collec/param/param.inc.php param/
cp ../collec/param/id_collec* param/
mkdir display/templates_c
mkdir tmp
find . -type d -exec chmod 750 {} \;
find . -type f -exec chmod 640 {} \;
chmod -R g+w display/templates_c
chmod -R g+w tmp
chgrp -R www-data .
rm -Rf test
cd ..
rm collec
ln -s collec-science collec
```

## For the following updates

```bash
cd /var/www/html/collec-science/collec-science
git pull
```

## To update the database

Under consideration...
