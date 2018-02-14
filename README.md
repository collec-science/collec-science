COLLEC
============
Collec est un logiciel destiné à gérer les collections d'échantillons prélevés sur le terrain.

Écrit en PHP, il fonctionne avec une base de données Postgresql. Il est bâti autour de la notion d'objets, qui sont identifiés par un numéro unique. Un objet peut être de deux types : soit un container (aussi bien un site, un bâtiment, une pièce, un congélateur, une caisse...) qu'un échantillon. 
Un type d'échantillon peut être rattaché à un type de container, quand les deux notions se superposent (le flacon contenant le résultat d'une pêche est à la fois un container et l'échantillon lui-même).
Un objet peut se voir attacher plusieurs identifiants métiers différents, des événements, ou des réservations.
Un échantillon peut être subdivisé en d'autres échantillons (du même type ou non). Il peut contenir plusieurs éléments identiques (notion de sous-échantillonnage), comme des écailles de poisson indifférenciées.
Un échantillon est obligatoirement rattaché à un projet. Les droits de modification sont attribués au niveau du projet.

Fonctionnalités principales
---------------------------
- Entrée/sortie du stock de tout objet (un container peut être placé dans un autre container, comme une boite dans une armoire, une armoire dans une pièce, etc)
- possibilité de générer des étiquettes avec ou sans QRCODE
- gestion d'événements pour tout objet
- réservation de tout objet
- lecture par scanner (douchette) des QRCODE, soit objet par objet, soit en mode batch (lecture multiple, puis intégration des mouvements en une seule opération)
- lecture individuelle des QRCODES par tablette ou smartphone (testé, mais pas très pratique pour des raisons de performance)
- ajout de photos ou de pièces jointes à tout objet

Sécurité
--------
- logiciel homologué à Irstea, résistance à des attaques opportunistes selon la nomenclature de l'OWASP (projet ASVS), mais probablement capable de répondre aux besoins du niveau standard
- identification possible selon plusieurs modalités : base de comptes interne, annuaire ldap, ldap - base de données (identification mixte), via serveur CAS, ou par délégation à un serveur proxy d'identification, comme LemonLDAP, par exemple
- gestion des droits pouvant s'appuyer sur les groupes d'un annuaire LDAP

Déploiement
--------
- collec peut être installé sur plusieurs serveurs et sites (https://github.com/Irstea/collec/blob/master/install/Installation%20de%20COLLEC.md), il gère les identifiants multiples lors d'échanges d'échantillons
- collec peut-être déployé comme un service Docker, en suivant les instructions suivantes : https://github.com/jancelin/docker-collec
- collec fonctionne par exemple en mode autonome sur une tablette Windows 10 Pro ou un raspberry (OS raspbian), exécutant Docker. Ce qui peut faciliter son usage en mobilité hors connexion. 

Licence
-------
Logiciel diffusé sous licence AGPL

Copyright
---------
La version 1.0 a été déposée auprès de l'Agence de Protection des Programmes sous le numéro IDDN.FR.001.470013.000.S.C.2016.000.31500
