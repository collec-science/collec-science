COLLEC-SCIENCE
© INRAE, 2016-2022 - All rights reserved
Published under AGPL license

**WARNING**: Collec-Science is now hosted here: [https://github.com/collec-science/collec-science](https://github.com/collec-science/collec-science)

For install a new instance in Ubuntu or Debian server:
~~~
wget https://github.com/collec-science/collec-science/raw/master/install/deploy_new_instance.sh
sudo -s
./deploy_new_instance.sh
~~~

GENERAL INSTALLATION AND CONFIGURATION DOCUMENTATION (in french):
[https://github.com/collec-science/collec-science/raw/master/documentation/technical/installation_fr/collec_installation_configuration.pdf](https://github.com/collec-science/collec-science/raw/master/documentation/technical/installation_fr/collec_installation_configuration.pdf)



COLLEC-SCIENCE
============
Collec-science est un logiciel destiné à gérer les collections d'échantillons prélevés sur le terrain.

Écrit en PHP, il fonctionne avec une base de données Postgresql. Il est bâti autour de la notion d'objets, qui sont identifiés par un numéro unique. Un objet peut être de deux types : soit un container (aussi bien un site, un bâtiment, une pièce, un congélateur, une caisse...) qu'un échantillon.
Un type d'échantillon peut être rattaché à un type de container, quand les deux notions se superposent (le flacon contenant le résultat d'une pêche est à la fois un container et l'échantillon lui-même).
Un objet peut se voir attacher plusieurs identifiants métiers différents, des événements, ou des réservations.
Un échantillon peut être subdivisé en d'autres échantillons (du même type ou non). Il peut contenir plusieurs éléments identiques (notion de sous-échantillonnage), comme des écailles de poisson indifférenciées.
Un échantillon est obligatoirement rattaché à une collection. Les droits de modification sont attribués au niveau de la collection.


Collec-science is a software designed to manage collections of samples collected in the field.

Written in PHP, it works with a Postgresql database. It is built around the concept of objects, which are identified by a unique number. An object can be of two types: a container (both a site, a building, a room, a freezer, a cashier ...) than a sample.
A type of sample can be attached to a type of container, when the two notions are superimposed (the bottle containing the result of a fishing is both a container and the sample itself).
An object can be attached to several different business identifiers, events, or reservations.
A sample can be subdivided into other samples (of the same type or not). It can contain several identical elements (notion of subsampling), like undifferentiated fish scales.
A sample is necessarily attached to a collection. Modification rights are assigned at the collection.

Fonctionnalités principales
---------------------------
- Entrée/sortie du stock de tout objet (un container peut être placé dans un autre container, comme une boite dans une armoire, une armoire dans une pièce, etc)
- possibilité de générer des étiquettes avec ou sans QRCODE
- gestion d'événements pour tout objet
- réservation de tout objet
- lecture par scanner (douchette) des QRCODE, soit objet par objet, soit en mode batch (lecture multiple, puis intégration des mouvements en une seule opération)
- lecture individuelle des QRCODES par tablette ou smartphone (testé, mais pas très pratique pour des raisons de performance)
- ajout de photos ou de pièces jointes à tout objet

Main features
-------------

- Entry / exit of the stock of any object (a container can be placed in another container, such as a box in a cupboard, a cupboard in a room, etc.)
- possibility to generate labels with or without QRCODE
- event management for any object
- reservation of any object
- scanner reading (handheld) QRCODE, object by object, or in batch mode (multiple reading, then integration of movements in a single operation)
- individual reading of QRCODES by tablet or smartphone (tested, but not very practical for performance reasons)
- adding photos or attachments to any object

Sécurité
--------
- logiciel homologué à Irstea, résistance à des attaques opportunistes selon la nomenclature de l'OWASP (projet ASVS), mais probablement capable de répondre aux besoins du niveau standard
- identification possible selon plusieurs modalités : base de comptes interne, annuaire ldap, ldap - base de données (identification mixte), via serveur CAS, ou par délégation à un serveur proxy d'identification, comme LemonLDAP, par exemple
- gestion des droits pouvant s'appuyer sur les groupes d'un annuaire LDAP

Security
--------
- software approved by Irstea, resistant to opportunistic attacks according to the nomenclature of OWASP (ASVS project), but probably capable of meeting the needs of the standard level
- possible identification according to several modalities: internal account database, ldap directory, ldap - database (mixed identification), via CAS server, or by delegation to an identification proxy server, such as LemonLDAP, for example
- rights management that can rely on groups in an LDAP directory

Licence /license
-------
Logiciel diffusé sous licence AGPL
Software diffused under AGPL License

Copyright
---------
La version 1.0 a été déposée auprès de l'Agence de Protection des Programmes sous le numéro IDDN.FR.001.470013.000.S.C.2016.000.31500
