#**Manuel pratique de COLLEC**

Voir la documentation complète sur le GIT 
https://github.com/Irstea/collec/blob/master/database/documentation/collec_installation_configuration.pdf

Ce manuel est écrit pour une Ubuntu 14.04.4 LTS

# 1. Installation de COLLEC

Documentation de l'installation sur l'OS Linux Ubuntu
Aptitude : pour la gestion des packages
`apt-get install aptitude`
`aptitude search php`
Anti-virus
`apt-get install clamav`

## 1.1 Installer PostgreSQL et pgAdmin3
D'abord le SGBD
`sudo apt-get install postgresql`
Puis le client graphique PgAdmin
`sudo apt-get install pgadmin3`

![warning](./warning30x30.png) Attention, il faut installer la version Postgres 9.5 au minimum
Comment faire ? Explications [ici](https://medium.com/@tk512/upgrading-postgresql-from-9-4-to-9-5-on-ubuntu-14-04-lts-dfd93773d4a5#.rjvujw3qi)

`sudo pg_ctlcluster 9.3 main stop`

Rajouter la source du package postgres 9.5 dans apt
 `vi /etc/apt/sources.list.d/pgdg.list`
 `deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main` 

Vérifier apt-get
 `wget -q -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -`

Installer
`sudo apt-get install postgresql-9.5`

`sudo pg_lsclusters`

```
Ver Cluster Port Status Owner    Data directory               Log file
9.3 main    5432 online postgres /var/lib/postgresql/9.3/main /var/log/postgresql/postgresql-9.3-main.log
9.5 main    5433 online postgres /var/lib/postgresql/9.5/main /var/log/postgresql/postgresql-9.5-main.log
```

`sudo pg_dropcluster --stop 9.5 main`
`sudo pg_upgradecluster 9.3 main`
`pg_dropcluster 9.3 main`
`sudo pg_lsclusters`

```
Ver Cluster Port Status Owner    Data directory               Log file
9.5 main    5432 online postgres /var/lib/postgresql/9.5/main /var/log/postgresql/postgresql-9.5-main.log
```


Vérifier
`psql --version`
```  psql (PostgreSQL) 9.5.6```

## 1.2 Installer Apache et php7.0
Le serveur Web apache (v2) et l'interpréteur PHP version 7

Si vous êtes sur une Debian, faites ceci.
```
deb http://packages.dotdeb.org jessie all
deb-src http://packages.dotdeb.org jessie all
```

Sinon, sur Ubuntu il est nécessaire de rajouter ce dépôt pour PHP7
`sudo add-apt-repository ppa:ondrej/php`

`apt-get install apache2 php7.0`
Le module pour apache
`apt-get install libapache2-mod-php7.0`

Les librairies annexes utilisées par COLLEC
`apt-get install php7.0-mbstring php7.0-pgsql php7.0-xml php-xdebug php7.0-curl php7.0-gd fop php-imagick`
<!-- Je pense qu’il manque un 7.0 a xdebug et imagick -->

![warning](./warning30x30.png) Rajout du **PDO postgres** (driver base de données postgres pour PHP7)
`sudo apt-get install php7.0-pgsql`

``` 
Creating config file /etc/php/7.0/mods-available/pdo_pgsql.ini with new version
Processing triggers for libapache2-mod-php7.0 (7.0.16-2+deb.sury.org~trusty+1)
```

ROOT:siza:/home/collec/collec > locate pdo_pgsql.so
/usr/lib/php/20160303/pdo_pgsql.so

le script suivant permet de vérifier que PHP accède au driver : 
```
<?php
foreach(get_loaded_extensions() as $extension)
{
    if(strpos(strtolower($extension), 'pdo') !== FALSE)
    {
        echo $extension.'<br/>';
    }
}
?>
```

Redémarrer Apache ensuite **si l'installation a été faite *après* la configuration d'Apache.**
La page [**PHP Info**](https://siza.univ-lr.fr/collec/index.php?module=phpinfo) dans le menu **Administration** de collec permet de vérifier les modules installés pour PHP : https://localhost/collec/index.php?module=phpinfo

## 1.3 Configurer apache2

`cd /etc/apache2/` 
Activer SSL et le mode redirection
`a2enmod ssl`
`a2enmod headers`
`a2enmod rewrite`

`cd sites-available/`

Rediriger les requêtes entrantes HTTP vers HTTPS : rajouter sur la config par défaut ces instructions

* rewriteEngine on
* RewriteRule ^ https://localhost%{REQUEST_URI} [R]


`vim 000-default.conf`

```
<VirtualHost *:80>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        #ServerName www.example.com
rewriteEngine on
RewriteRule ^ https://localhost%{REQUEST_URI} [R]
<Directory /var/www/html>
        Options Indexes FollowSymLinks Multiviews
        AllowOverride all
        RewriteEngine on
        Order allow,deny
        allow from all
</directory>

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>

```

Puis éditer le site d'accueil des requêtes HTTPS
`vim default-ssl.conf`

```
<IfModule mod_ssl.c>
        <VirtualHost _default_:443>
                ServerAdmin webmaster@localhost

                DocumentRoot /var/www/html
<Directory /var/www/html>
        Options Indexes FollowSymLinks Multiviews
        AllowOverride all
        RewriteEngine on
        Order allow,deny
        allow from all
</directory>

                # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
                # error, crit, alert, emerg.
                # It is also possible to configure the loglevel for particular
                # modules, e.g.
                #LogLevel info ssl:warn

                ErrorLog ${APACHE_LOG_DIR}/error.log
                CustomLog ${APACHE_LOG_DIR}/access.log combined

                # For most configuration files from conf-available/, which are
                # enabled or disabled at a global level, it is possible to
                # include a line for only one particular virtual host. For example the
                # following line enables the CGI configuration for this host only
                # after it has been globally disabled with "a2disconf".
                #Include conf-available/serve-cgi-bin.conf

                #   SSL Engine Switch:
                #   Enable/Disable SSL for this virtual host.
                SSLEngine on

# HSTS (mod_headers is required) (15768000 seconds = 6 months)
Header always set Strict-Transport-Security "max-age=15768000"

                #   A self-signed (snakeoil) certificate can be created by installing
                #   the ssl-cert package. See
                #   /usr/share/doc/apache2/README.Debian.gz for more info.
                #   If both key and certificate are stored in the same file, only the
                #   SSLCertificateFile directive is needed.
                SSLCertificateFile      /etc/ssl/certs/ssl-cert-snakeoil.pem
                SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key
...

### from https://mozilla.github.io/server-side-tls/ssl-config-generator/
## using 2.4.7 apache version and "Modern" and openSSL version 1.0.1e

# modern configuration, tweak to your needs
SSLProtocol             all -SSLv3 -TLSv1 -TLSv1.1
SSLCipherSuite          ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256
SSLHonorCipherOrder     on
SSLCompression          off


# OCSP Stapling, only in httpd 2.3.3 and later
SSLUseStapling          on
SSLStaplingResponderTimeout 5
SSLStaplingReturnResponderErrors off
SSLStaplingCache        shmcb:/var/run/ocsp(128000)
```

Activer les 2 sites (HTTP et HTTPS)
`a2ensite 000-default.conf`
`a2ensite default-ssl.conf`

Donner les droits à apache2 (www-data user) de lire les certificats placés dans /etc/ssl/ssl-cert

`cd /etc/ssl`
`chmod -R g+r  private`
`usermod www-data -a -G ssl-cert`


Logs d'Apache
`tail /var/log/apache2/error.log` 

Vérifier que Apache tourne
`ps -ef|grep apache`



## 1.4 Utilisation du [git](https://github.com/Irstea/collec.git)

Voici des indications pour ceux qui n'ont pas l'habitude du GIT.
D'abord se placer dans le repertoire du serveur qui va accueillir les sources du logiciel. 
`cd /home/adminuser/Dev/COLLEC/`

Configurer l'environnement GIT avec le nom et mail de la personne qui récupère les sources.
GIT init pour l'utilisateur cplumejeaud
`git init`
`git config --global user.email "cplumejeaud@gmail.com"`
`git config --global user.name "cplumejeaud"`

Spécifier l'adresse du GITHUB de collec
`git remote add origin https://github.com/Irstea/collec.git`
Vérifier la config
`git config --global --list`
Récupérer les sources de collec (branche master)
`git clone https://github.com/Irstea/collec.git`

Branche réservée à Christine pour ses développements : feature_metadata

L'interface graphique GIT
- Installer
`sudo apt-get install git-gui gitk meld menulibre`
- Utiliser
`git gui`

## 1.5 Créer la BDD pour collec

### 1.5.1 Créer un utilisateur avec les droits d'admin
user : collec
mot de passe : collec

sudo -u postgres psql 
createuser collec superuser password 'collec';
<!-- va changer -->

CREATE ROLE collec LOGIN
  ENCRYPTED PASSWORD 'md51a8deeacb23038be992e5c2a2c15826c'
  SUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;

### 1.5.2 Création d'une BDD collec
`psql -U collec -d postgres -c "create database collec"`

Notez que hstore, postgis et postgis_topology ne sont pas nécessaires pour l'instant. 
psql -d collec -U collec -c "create extension postgis, postgis_topology, hstore"

D'abord la BDD de droits GACL (qui peut être mutualisée avec d'autres applications)
`psql -d collec -U collec -f /home/adminuser/Dev/COLLEC/collec/install/gacl_create-1.0.sql`
Ensuite la BDD d'objets (échantillons et containers) 
`psql -d collec -U collec -f /home/adminuser/Dev/COLLEC/collec/install/col_create-1.0.sql`

![warning](./warning30x30.png) Surveiller le GIT et **les mises à jour du schema de BDD** dans install
`psql -d collec -U collec -f /home/adminuser/Dev/COLLEC/collec/install/col_alter_1.0-1.0.4.sql`
`psql -d collec -U collec -f /home/adminuser/Dev/COLLEC/collec/install/col_alter_1.0.4-1.0.5.sql`
`psql -d collec -U collec -f /home/adminuser/Dev/COLLEC/collec/install/col_alter-1.0.5-1.0.6.sql`

Initialiser les droits de l'utilisateur admin (qui a le mot de passe 'password' par défaut, à changer)
Cet utilisateur "admin" est un utilisateur application (stocké dans gacl) et non un rôle postgres. Il a été créé lors de l'exécution du script gacl_create-1.0.sql. Il se trouve provisoirement dans la branche https://github.com/Irstea/collec/tree/feature_metadata/install/gacl_init_droits_groupes.sql
`psql -d collec -U collec -f /home/adminuser/Dev/COLLEC/collec/install/gacl_init_droits_groupes.sql`

Donner le droit à l'utilisateur collec d'accéder à la base en local : 
- `sudo vi /etc/postgresql/9.5/main/pg_hba.conf`
ajouter la ligne :  `local   collec             collec                                md5`

Valider la config et redémarrer postgres
- `sudo /etc/init.d/postgresql restart -n 9.5`


Reporter dans le fichier de config de collec les infos sur la BDD
- `vi /home/adminuser/Dev/COLLEC/collec/param/param.inc.php`


## 1.6 Configuration de collec

Se placer dans votre répertoire d'installation de collec : /home/adminuser/Dev/COLLEC/collec par exemple
`cd /home/adminuser/Dev/COLLEC/collec/`

## 1.6.1 Ne pas oublier
`mkdir display/templates_c`
`chmod 777 display/templates_c`
Ce dossier est rempli régulièrement lors de la génération d'étiquettes : fop --> XML --> image --> PDF. 
Il est programmé pour un effacement rotatif des fichiers à chaque connexion d'utilisateur
`chmod 777 temp`

Vérifier que fop trouve java : 
`java -version`
```
java version "1.7.0_121"
OpenJDK Runtime Environment (IcedTea 2.6.8) (7u121-2.6.8-1ubuntu0.14.04.3)
OpenJDK 64-Bit Server VM (build 24.121-b00, mixed mode)
```

Et que fop fonctionne : 
 `fop`
``` FOP Version 1.1 ...```

### 1.6.2 Configuration par défaut

Copier le fichier qui vient avec la distribution puis l'éditer.
`cp param/param.inc.php.dist param/param.inc.php`
`vi param/param.default.inc.php`

Durée d'archivage des logs de l'application, rotatifs
`$LOG_duree = 365;`

### 1.6.3 Configuration de l'application 
Plusieurs applications peuvent être déployées sur le même site Web, 
chaque application gère ses collections d'échantillons et containers indépendamment des autres. 
Le paramètre **APPLI_code** est essentiel. 


`vi /home/adminuser/Dev/COLLEC/collec/param/param.inc.php`
```
/*
 * Code de l'application - impression sur les etiquettes
 * Rempli le champ db dans les étiquettes
 */
$APPLI_code = 'proto';
/*
 * Mode d'identification
 * BDD : uniquement a partir des comptes internes
 * LDAP : uniquement a partir des comptes de l'annuaires LDAP
 * LDAP-BDD : essai avec le compte LDAP, sinon avec le compte interne
 * CAS : identification auprès d'un serveur CAS
 */
$ident_type = "BDD";

/*
 * Parametres concernant la base de donnees
 */
$BDD_login = "collec";
$BDD_passwd = "collec";
$BDD_dsn = "pgsql:host=localhost;dbname=collec";
$BDD_schema = "col,gacl,public";

/*
 * Rights management, logins and logs records database
 */
$GACL_dblogin = "collec";
$GACL_dbpasswd = "collec";
$GACL_aco = "col";
$GACL_dsn = "pgsql:host=localhost;dbname=collec";
$GACL_schema = "gacl";

```

### 1.6.4 Spécifier collec comme nouveau site servi par Apache 
`cd /var/www/html`
`ln -s /home/adminuser/Dev/COLLEC/collec/ collec`

![warning](./warning30x30.png) 
Donner les droits à l'utilisateur Apache (www-data) de lire (r:4) et exécuter le (x:1) le répertoire DocumentRoot
chown -hR www-data:users /home/adminuser/Dev/COLLEC/collec
sudo chmod -R 755 /home/adminuser/Dev/COLLEC/collec
sudo chmod -R 777 /home/adminuser/Dev/COLLEC/collec/temp
sudo chmod -R 777 /home/adminuser/Dev/COLLEC/collec/display/templates_c

`service apache2 start`

## 1.7 Test de collec
https://localhost/collec/
User : admin
Password : password

#### Debug : voir les logs
Logs d'Apache
`tail /var/log/apache2/error.log` 
Debug : Vérifier que Apache tourne
`ps -ef|grep apache`

`netstat -na | grep 80`
tcp6       0      0 :::80                   :::*                    LISTEN

`netstat -na | grep 443`

Logs de postgres
vi /var/log/postgresql/postgresql-9.5-main.log



### 1.7.1 Créer les droits puis les groupes dans l'interface


Le droit admin permet de configuer les droits. L'utilisateur admin créé par défaut lors de l'installation a les droits admin par défaut.
Voici la hiérarchie des droits : le droit param > projet > gestion > consult
Ces droits peuvent être créés puis accordés via l'interface, mais il faut respecter la syntaxe du nom du droit. 
- admin
- consult
- gestion
- projet
- param 
C'est pourquoi nous proposons d'appeler la procédure installée via gacl_init_droits_groupes.sql pour créer des droits et les groupes associés : il suffit de l'appeler avec l'id de l'utilisateur admin.
'gacl' correspond au nom du schema des droits ($GACL_schema)
'col' correspond au nom du schema de l'application ($GACL_aco)
`psql -d collec -U collec -f select create_rights_for_user('gacl', 'col', 1);`


Il faut aussi associer les utilisateurs aux groupes, puis les groupes à leurs droits respectifs. 



### 1.7.2 Créer des sites, des familles de containers

Ne pas oublier de rattacher un modèle d'étiquette à des containers, sinon, l'impression d'étiquette ne marche pas. 

### 1.7.3 Créer des types d'échantillon

Le type d'échantillon est attaché à un type de container qui définit le type d'étiquette. 

### 1.7.4 Impression en laboratoire


# 2. Futur de collec

## 2.1 Gestion de données associées aux échantillons

### 2.1.1 Specifier des formulaires dynamiques


### 2.1.2 Specifier la recherche sur données des échantillons


## 2.2 Impression en mode embarqué


## 2.3 Gestion de la réservation de matériel

Avoir une vue sur le calendrier des réservation par famille de containers (le matériel sera considéré comme un container)

--> enregistrement des entrées et sorties
--> inventaire facilité par l'entrée rapide



