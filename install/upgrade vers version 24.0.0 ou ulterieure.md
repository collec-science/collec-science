---
title: Mettre à jour Collec-Science à partir de la version 24.0.0  
date: 21/10/2024  
lang: fr  
authors:  
    - Éric Quinton
---

# Mettre à jour Collec-Science

La mise à jour de Collec-Science est basée sur GIT.

## Récupérer la nouvelle version

```
cd /var/www/collec2App/collec-science
git restore .
git pull origin main
```

## Mettre à jour la base de données

La base de données est à mettre à jour chaque fois que le second numéro de version change, par exemple pour passer de la version _v25.0.0_ à la version _v25.1.0_.

Pour réaliser la mise à jour :

```
cd /var/www/collec2App/collec-science
./upgradedb.sh
```

Le script va :

*   lire les paramètres de connexion de la base de données dans le fichier _.env_
*   exécuter une requête dans la table _dbversion_ pour connaître la version courante
*   exécuter le script de mise à jour (`install/upgradedb-from-24.1.sh` par exemple).