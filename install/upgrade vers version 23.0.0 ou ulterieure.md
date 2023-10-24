---
title: Mettre à jour Collec-Science à partir de la version 23.0.0
date: 24/10/2023
lang: fr
authors:
    - Éric Quinton
---

# Mettre à jour Collec-Science à partir de la version 23.0.0

## Principe général

Jusqu'à la version 23.0.0, les mises à jour de Collec-Science étaient bâties sur ce principe :

- récupération du code sous forme zippée

- décompression du fichier et renommage du dossier généré

- recopie des paramètres à partir de la version précédente

- repositionnement des droits d'accès sur les fichiers

- lancement des scripts de modification de la base de données

À partir de la version 23.0.0, la mise à niveau est préconisée en utilisant *git*, ce qui permet des mises à jour intermédiaires beaucoup plus simples et plus rapides.

## Code de migration du mode de mise à jour

Avant d'exécuter le code, vérifiez les chemins indiqués.

```bash
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

## Pour les mises à jour suivantes

```bash
cd /var/www/html/collec-science/collec-science
git pull
```

## Pour mettre à jour la base de données

En cours de réflexion...
