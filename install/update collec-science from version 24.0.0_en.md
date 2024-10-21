---
title: Update Collec-Science from version 24.0.0  
date: 21/10/2024  
lang: en  
authors:  
    - Éric Quinton
---

# Update Collec-Science

The update of Collec-Science is based on GIT.

## Get the new version

```
cd /var/www/collec2App/collec-science
git restore .
git pull origin main
```

## Update the database

The database must be updated each time the second version number changes, for example to go from version _v25.0.0_ to version _v25.1.0_.

To perform the update:

```
cd /var/www/collec2App/collec-science
./upgradedb.sh
```

The script will:

* read the database connection parameters in the _.env_ file
* execute a query in the _dbversion_ table to know the current version
* execute the update script (`install/upgradedb-from-24.1.sh` for example).