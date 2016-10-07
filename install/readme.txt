News
===========
Version 0.6 du 7 octobre 2016
-------------------------------
Nouvelles fonctionnalités :
- ajout d'un spinner d'attente lors de la génération des étiquettes
- des documents (photos, pdf...) peuvent être associés à un objet
- lecture par douchette
- génération des mouvements par scan de lots (traitement batch)
- le qrcode est maintenant généré dynamiquement : auparavant, son contenu était statique et immuable
- il est possible de rajouter des identifiants complémentaires typés. Ils peuvent être importés automatiquement
- le motif de sortie du stock peut être maintenant associé au mouvement (à partir d'une liste paramétrable)

Corrections de bogues :
- les qrcodes sont supprimés systématiquement du dossier temporaire après génération : si le contenu de l'objet est modifié, le nouveau qrcode réflète maintenant les modifications apportées sans attendre le délai de nettoyage automatique

Version 0.5 du 16 septembre 2016
-------------------------------
Nouvelles fonctionnalités :
- ajout de la génération des étiquettes avec QRCODE, et modification de la lecture optique pour prendre en compte le format JSON
- lors de la lecture d'un QRCODE, vérification que l'UID est bien rattaché à la base de données courante 
- ajout de la saisie des protocoles et des opérations associées. Un type d'échantillon peut être rattaché à une opération
- il est maintenant possible de définir qu'un type d'échantillon accepte le sous-échantillonnage (multiples écailles indifférenciées dans un sachet, p. e., ou volume, longueur...). Il est possible d'indiquer les sorties et entrées des sous-échantillons
- modifications diverses du framework (génération des enregistrements Syslog, simplification des codes de retour des modules, gestion correcte du stockage et de la lecture des fichiers binaires...)

Corrections de bogues :
- reformatage du menu pour mieux gérer les terminaux de petite taille
- corrections multiples dans l'import de masse
- la sélection par fourchette d'uid ne fonctionnait pas
- l'affichage des listes de containers et échantillons n'intégrait pas correctement le statut
- les zones UID sont maintenant obligatoires pour valider les formulaires d'entrée ou sortie rapide

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
