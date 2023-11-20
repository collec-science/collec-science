# Service web de récupération des données d'un échantillon

## Méthode d'appel

~~~
index.php?module=apiv1sampleDisplay&uid=xxx&uuid=yyy&token=zzz&template_name=aaa
index.php?module=sampleDetail&uid=xxx&uuid=yyy&token=zzz&template_name=aaa
~~~

## Paramètres

{: .datatable}


| Paramètre    | Contenu                                                                                                                                                 |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| uid           | UID de l'échantillon (obligatoire si UUID non renseigné)                                                                                              |
| uuid          | UUID de l'échantillon (obligatoire si UID non renseigné)                                                                                              |
| token         | jeton d'identification. Information obligatoire si la collection n'est pas publique                                                                     |
| login         | login associé au jeton (token). Les deux informations doivent être fournies pour que l'identification soit réalisée                                 |
| template_name | Nom du*template* utilisé pour formater les informations. Cette information doit être fournie si le *token* n'est pas renseigné (collection publique) |
| locale        | Code de la langue utilisée pour les messages d'erreur ou le formatage des dates. Par défaut : fr, sinon 'en' ou 'us'                                  |

{.table .table-bordered .table-hover}

## Données retournées

### Format

Les données sont retournées au format JSON

### Contenu

#### Collection non publique ou avec token fourni

Par défaut, c'est à dire si aucun *template_name* n'est défini, les informations suivantes sont intégrées dans l'enregistrement JSON :


| Champ                | Description                                                                     |
| ---------------------- | --------------------------------------------------------------------------------- |
| uid                  | uid de l'échantillon                                                           |
| dbuid_origin         | identifiant initial de l'échantillon, si saisi dans une autre base de données |
| collection_name      | nom de la collection                                                            |
| sample_type_name     | nom du type d'échantillon                                                      |
| sample_creation_date | date de création de l'échantillon                                             |
| sampling_date        | date d'échantillonnage                                                         |
| metadata             | liste des métadonnées associées                                              |
| expiration_date      | date d'expiration de l'échantillon                                             |
| campaign_name        | nom de la campagne de prélèvement                                             |
| multiple_value       | quantité initiale (sous-échantillonnage)                                      |
| multiple_unit        | unité de sous-échantillonnage                                                 |
| identifier           | identifiant métier de l'échantillon                                           |
| wgs84_x              | longitude du point de prélèvement                                             |
| wgs84_y              | latitude du point de prélèvement                                              |
| country_name         | nom du pays de prélèvement                                                    |
| country_code2        | code du pays, sur deux positions                                                |
| object_status_name   | statut de l'échantillon                                                        |
| change_date          | date de dernière modification de l'échantillon                                |
| uuid                 | uuid de l'échantillon                                                          |
| trashed              | vaut 1 si l'échantillon a été mis à la poubelle (en attente de suppression) |
| location_accuracy    | précision de la localisation du lieu de collecte                               |
| object_comment       | commentaire sur l'échantillon                                                  |
| parent_uid           | uid du parent                                                                   |
| parent_identifier    | identifiant métier du parent                                                   |
| parent_uuid          | uuid du parent                                                                  |
| parent_identifiers   | liste des autres identifiants du parent                                         |
| container_type_name  | nom du type de contenant associé au type d'échantillon                        |
| clp_classification   | risque CLP associé au contenant                                                |
| protocol_name        | nom du protocole de collecte                                                    |
| protocol_year        | année du protocole                                                             |
| protocol_version     | version du protocole                                                            |
| operation_name       | nom de l'opération associée au protocole                                      |
| operation_version    | version de l'opération                                                         |
| identifiers          | liste des identifiants secondaires de l'échantillon                            |
| movement_date        | date du dernier mouvement enregistré                                           |
| movement_type_name   | type du dernier mouvement enregistré                                           |
| sampling_place_name  | station de prélèvement                                                        |
| line_number          | numéro de la rangée où est stocké l'échantillon dans le contenant          |
| column_number        | numéro de la colonne où est stocké l'échantillon dans le contenant          |
| container_uid        | uid du contenant                                                                |
| container_identifier | identifiant métier du contenant                                                |
| container_uuid       | uuid du contenant                                                               |
| container_type_name  | type du contenant                                                               |
| referent_name        | nom du référent                                                               |
| referent_email       | mail du référent                                                              |
| address_name         | première ligne de l'adresse du référent                                      |
| address_line2        | seconde ligne de l'adresse du référent                                        |
| address_line3        | troisième ligne de l'adresse du référent                                     |
| address_city         | ville du référent                                                             |
| address_country      | pays du référent                                                              |
| referent_phone       | numéro de téléphone du référent                                            |
| referent_firstname   | prénom du référent                                                           |
| academical_directory | nom de la structure académique du référent (p. e., ORCID)                    |
| academical_link      | lien d'accès académique du référent                                         |
| borrowing_date       | date d'emprunt de l'échantillon                                                |
| expected_return_date | date prévue de retour de l'échantillon                                        |
| borrower_name        | nom de l'emprunteur                                                             |
| subsample_quantity   | quantité restante dans l'échantillon (sous-échantillonnage)                  |
| events               | liste des événements enregistrés pour l'échantillon                         |
| container            | liste de la hiérarchie des contenants                                          |

{.table .table-bordered .table-hover}

#### Collection publique ou nom du template fourni

Le contenu dépend exclusivement du paramétrage réalisé dans le template.

## Codes d'erreur


| Code d'erreur | Signification         |
| --------------- | ----------------------- |
| 500           | Internal Server Error |
| 401           | Unauthorized          |
| 520           | Unknown error         |
| 404           | Not Found             |

{.table .table-bordered .table-hover}
