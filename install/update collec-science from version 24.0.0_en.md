---
title: Update Collec-Science from version 24.0.0  
date: 02/01/2024  
lang: en  
authors:  
\- Éric Quinton

---

# Update Collec-Science from version 24.0.0

## General principle

Until version 24.0.0, Collec-Science updates were based on the following principle :

- retrieve the code in zipped form
- decompressing the file and renaming the generated folder
- copying parameters from the previous version
- repositioning of file access rights
- launch database modification scripts

From version 24.0.0 onwards, upgrading is recommended using _git_, which makes intermediate updates much simpler and faster.

## To be quick...

The `install/upgrade_to_git.sh` script can automatically perform all the operations described in this document. To run it :

```
ln -s /var/www/html/collec-science /var/www/collecApp
cd /var/www/collecApp
wget https://github.com/collec-science/collec-science/raw/develop/install/upgrade_to_git.sh
chmod +x upgrade_to_git.sh
./upgrade_to_git.sh
```

## Detailed description of operations

### Upgrade mode migration code

Before executing the code, check the paths indicated.

```
ln -s /var/www/html/collec-science /var/www/collecApp
cd /var/www/collecApp
git clone https://github.com/collec-science/collec-science -b master
cd collec-science
cp ../collec/param/param.inc.php param/
cp ../collec/param/id_collec* param/
mkdir display/templates_c
mkdir temp
find . -type d -exec chmod 750 {} \;
find . -type f -exec chmod 640 {} \;
chmod -R g+w display/templates_c
chmod -R g+w temp
chgrp -R www-data .
rm -Rf test
cd .
rm collec
ln -s collec-science collec
```

### To initialise the database update

Run the following commands to initialise the generic update script:

```
cd /var/www/collecApp
cp collec-science/install/upgradedb.sh.dist ./upgradedb.sh
chmod +x upgradedb.sh
```

Next, edit the _upgradedb.sh_ file that has just been created in `/var/www/collecApp`, and check the database connection parameters and the folder where the application is installed.

Run the following script:

```
/var/www/collecApp/upgradedb.sh
```

The script will perform the following operations:

- retrieve the current version of the database by querying the _dbversion_ table;
- run the script to upgrade the version.

If the database is already up to date, the script will indicate this.

### Set up automatic message sending

From version 24.0.0, the software can send notifications to users to inform them of samples that are about to expire or events that need to be processed. As a pre-requisite, the server must have a mail-sending engine, such as Postfix or MSMTP. An engine is not installed by the Collec-Science installation script, because of the specific settings for each organisation (connection servers, accounts used, technology, ports, rights to be set, etc.). In general, using Postfix gives good results, but other configurations are also possible.

To activate the sending of messages, once the email software has been configured, carry out the following operations:

```
cp collec-science/collectionsGenerateMail.sh .
echo "0 8 * * * /var/www/collecApp/collectionsGenerateMail.sh" | crontab -u www-data -
chmod +x /var/www/collecApp/collectionsGenerateMail.sh
```

Also edit the file `/var/www/collecApp/collec-science/param/param.inc.php`, and check that the line :

```
$MAIL_enabled = 1;
```

is not commented out.

The script used to search for samples to report will be run every day at 8am.

To activate message generation, you will also need to configure the software. To do this, please refer to the document [https://github.com/collec-science/collec-science/blob/master/documentation/collection/automaticsendmail_fr.md](https://github.com/collec-science/collec-science/blob/master/documentation/collection/automaticsendmail_fr.md).

## For the following updates

```
cd /var/www/collecApp/collec-science
git pull origin master
cd .
./upgradedb.sh
```