---

title: Mettre à jour Collec-Science à partir de la version 24.0.0  
date: 02/01/2024  
lang: fr  
authors:  
\- Éric Quinton

---

# Mettre à jour Collec-Science à partir de la version 24.0.0

## Principe général

Jusqu'à la version 24.0.0, les mises à jour de Collec-Science étaient bâties sur ce principe :

- récupération du code sous forme zippée
- décompression du fichier et renommage du dossier généré
- recopie des paramètres à partir de la version précédente
- repositionnement des droits d'accès sur les fichiers
- lancement des scripts de modification de la base de données

À partir de la version 24.0.0, la mise à niveau est préconisée en utilisant _git_, ce qui permet des mises à jour intermédiaires beaucoup plus simples et plus rapides.

## Pour aller vite…

Le script `install/upgrade_to_git.sh` peut réaliser automatiquement l'ensemble des opérations décrites dans ce document. Pour le lancer :

```
ln -s /var/www/html/collec-science /var/www/collecApp
cd /var/www/collecApp
wget https://github.com/collec-science/collec-science/raw/develop/install/upgrade_to_git.sh
chmod +x upgrade_to_git.sh
./upgrade_to_git.sh
```

## Description détaillées des opérations

### Code de migration du mode de mise à jour

Avant d'exécuter le code, vérifiez les chemins indiqués.

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
cd ..
rm collec
ln -s collec-science collec
```

### Pour initialiser la mise à jour la base de données

Lancez les commandes suivantes pour initialiser le script générique de mise à jour :

```
cd /var/www/collecApp
cp collec-science/install/upgradedb.sh.dist ./upgradedb.sh
chmod +x upgradedb.sh
```

Éditez ensuite le fichier _upgradedb.sh_ qui vient d'être créé dans `/var/www/collecApp`, et vérifiez les paramètres de connexion à la base de données ainsi que le dossier où est installée l'application.

Lancez le script suivant :

```
/var/www/collecApp/upgradedb.sh
```

Le script va réaliser les opérations suivantes :

- récupération de la version actuelle de la base de données en interrogeant la table _dbversion_ ;
- exécution du script permettant la montée de version.

Si la base de données est déjà à jour, le script l'indiquera.

### Mettre en place l'envoi automatique de messages

À partir de la version 24.0.0, le logiciel peut envoyer des notifications aux utilisateurs pour les informer des échantillons en cours d'expiration ou des événements à traiter. En pré-requis, il faut que le serveur dispose d'un moteur d'envoi de mails, comme Postfix ou MSMTP. L'installation d'un moteur n'est pas réalisée par le script d'installation de Collec-Science, en raison des paramétrages spécifiques à chaque organisation (serveurs de connexion, comptes utilisés, technologie, ports, droits à positionner, etc.). En général, l'utilisation de Postfix donne de bons résultats, mais d'autres configurations sont également possibles.

Pour activer l'envoi des messages, une fois le logiciel d'envoi de mails paramétré, réalisez les opérations suivantes :

```
cp collec-science/collectionsGenerateMail.sh .
echo "0 8 * * * /var/www/collecApp/collectionsGenerateMail.sh" | crontab -u www-data -
chmod +x /var/www/collecApp/collectionsGenerateMail.sh
```

Éditez également le fichier `/var/www/collecApp/collec-science/param/param.inc.php`, et vérifiez que la ligne :

```
$MAIL_enabled = 1;
```

ne soit pas commentée.

Le script permettant de rechercher les échantillons à signaler sera lancé tous les jours à 8 heures.

Pour activer la génération des messages, vous devrez également paramétrer le logiciel. Pour cela, consultez le document [https://github.com/collec-science/collec-science/blob/master/documentation/collection/automaticsendmail_fr.md](https://github.com/collec-science/collec-science/blob/master/documentation/collection/automaticsendmail_fr.md).

## Pour les mises à jour suivantes

```
cd /var/www/collecApp/collec-science
git pull origin master
cd ..
./upgradedb.sh
```
