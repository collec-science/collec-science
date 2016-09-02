News
===========
Version 0.4 du 2 septembre 2016
-------------------------------
Nouvelles fonctionnalités :
- ajout de la possibilité de réserver un échantillon ou un container
- le statut du container a été remonté à l'objet, ce qui permet d'indiquer également un statut pour un échantillon
- il est maintenant possible de définir un type de container pour un échantillon : dans certains cas, l'échantillon et le container sont confondus

Corrections de bogues :
- la gestion des droits a été revue. Les groupes auquel appartient le login dans l'annuaire ldap sont récupérés, et associés le cas échéant aux groupes définis localement
- la hiérarchie des groupes est maintenant identique, que l'on traite un compte local ou ldap
- diverses corrections du framework : optimisation, correction de bogues, etc.

Version 0.3 du 26 août 2016
---------------------------
- correction de bugs liés au framework
- ajout de la saisie des coordonnées gps de l'objet, et affichage dans le détail

Version 0.2 du 23 août 2016
---------------------------
- ajout de la fonction scan en entrée ou sortie rapide
- ajout de la génération d'un fichier csv pour les impressions d'étiquettes
- correction d'un bug : il n'est plus possible de rentrer un échantillon en lui-même
- restructuration interne de l'application

Version 0.1 du 18 août 2016
---------------------------
Première version de test, incluant :
- la saisie des containers
- la saisie des échantillons
- la création des mouvements
- l'import de masse
