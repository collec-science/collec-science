# Les différents types de droits

Collec-Science gère 6 droits différents :

- admin
- param
- collection
- import
- gestion
- consult

## Le droit *admin*

Il permet de créer les utilisateurs, d'attribuer les droits, de paramétrer les données générales du logiciel, de consulter les traces, de réaliser une sauvegarde ponctuelle de la base de données.

Il est indépendant des autres droits. Il est en général détenu par les administrateurs du système.

## Le droit *param*

C'est le super-utilisateur de l'application. Il peut tout faire dans le logiciel, sauf ce qui est dévolu au droit *admin*, et en particulier :

- la modification de l'ensemble des tables de paramètres
- la création des collections.

En général, le détenteur du droit *param* devrait également posséder le droit *admin* (l'inverse n'est pas forcément vrai).

## Le droit *collection*

C'est un droit attribué aux administrateurs des collections. Ils peuvent modifier la plupart des paramètres comme créer des types d'échantillons, des modèles de métadonnées, etc., et réaliser des importations pour les collections auxquelles ils appartiennent.

## Le droit *import*

Il permet d'importer des échantillons pour les collections auxquelles appartient l'utilisateur concerné.

## Le droit *gestion*

C'est le droit de base pour les utilisateurs actifs dans le logiciel. Il permet de :

- créer/modifier des échantillons pour les collections auxquelles appartient l'utilisateur concerné
- enregistrer des mouvements d'entrée/sortie pour tous les échantillons, y compris ceux qui ne font pas partie de ses collections

Dès lors qu'un utilisateur est rattaché à une collection, il hérite automatiquement de ce droit.

## Le droit *consult*

Tout utilisateur disposant de ce droit peut visualiser les échantillons existants, mais ne peut pas consulter les métadonnées rattachées.

*Rédaction : Éric Quinton - 20/05/2022*

