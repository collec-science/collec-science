# API de création d'un mouvement

## Principe

L'API permet de générer des mouvements d'entrée ou de sortie, à partir soit de l'UID, soit de l'UUID, soit de l'identifiant métier (qui doit alors être unique dans la base de données).

## Identification

Consultez ce document pour créer l'utilisateur de l'API, générer un token et lui donner les droits adéquats : [Identification pour les services web](swidentification_fr)

## Appel par défaut

> URL : apiv1movementWrite

L'API doit être appelée en mode http **POST**.

### Variables à fournir


| Nom de la variable   | Description                                                                                                                                              | obligatoire |
| -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------: |
| login                | Login du compte utilisé pour appeler l'API                                                                                                               |      X      |
| token                | Jeton d'identification associé au login                                                                                                                  |      X      |
| locale               | Code de la langue utilisée pour les messages d'erreur ou le formatage des dates. Par défaut : fr, sinon 'en' ou 'us'                                     |             |
| uid                  | UID de l'objet sur lequel porte le mouvement                                                                                                             |    X(*)     |
| uuid                 | UUID de l'objet sur lequel porte le mouvement                                                                                                            |    X(*)     |
| identifier           | Identifiant métier de l'objet sur lequel porte le mouvement                                                                                              |    X(*)     |
| movement_type        | 1 : entrée dans le stock / 2 : sortie du stock                                                                                                           |      X      |
| container_uid        | UID du container (entrée dans le stock)                                                                                                                  |    X(**)    |
| container_uuid       | UUID du container (entrée dans le stock)                                                                                                                 |    X(**)    |
| container_identifier | Identifiant métier du contenant                                                                                                                          |    X(**)    |
| movement_reason      | Motif de déstockage. Valeur numérique, correspondant à la clé de l'enregistrement de la table[Motifs de déstockage](movementReasonList) |             |
| column               | N° de la colonne où est stocké l'objet dans le contenant                                                                                                 |             |
| line                 | N° de la ligne où est stocké l'objet dans le contenant                                                                                                   |             |
| storage_location     | Texte libre permettant de préciser l'emplacement de stockage                                                                                             |             |
| movement_comment     | Texte libre                                                                                                                                              |             |

{.table .table-bordered .table-hover .datatable-nopaging-nosort }

(*) : soit l'UID, soit l'UUID, soit l'identifiant métier de l'objet doit être fourni

(**) : soit l'UID, soit l'UUID, soit l'identifiant métier du contenant doit être fourni, dès lors qu'il s'agit d'un mouvement d'entrée
