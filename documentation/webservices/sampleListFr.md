# Service web de récupération d'une liste d'échantillons

## Présentation

Deux services sont disponibles : le premier permet de ne récupérer que la liste des UID concernés, le second l'ensemble des informations.
Le moteur de recherche est identique à celui utilisé dans l'interface web, à ceci près que la recherche ne s'effectue qu'à l'intérieur d'une seule collection. Ce dernier point est lié aux sécurités mises en place pour l'interrogation via les API.

## Méthode d'appel

~~~
index.php?module=apiv1sampleList : liste complète
index.php?module=apiv1sampleUids : liste des UID
~~~

## Paramètres

Les paramètres suffixés par *_id* doivent être recherchés dans les paramètres de l'application (interface web). Le programme ne recherche pas les valeurs correspondant aux libellés, comme cela se fait par ailleurs dans les procédures d'importations.

Les paramètres sont cumulatifs entre eux, sauf pour les métadonnées, où celles-ci ont un fonctionnement multivalué.

### Paramètres obligatoires

{: .datatable}


| Paramètre    | Contenu                               |
| --------------- | --------------------------------------- |
| token         | jeton d'identification                |
| login         | login associé au jeton (token)       |
| collection_id | Numéro informatique de la collection |

{.table .table-bordered .table-hover}


### Paramètres facultatifs


{: .datatable}


| Paramètre | Description |
| --- | --- |
| locale     | Code de la langue utilisée pour les messages d'erreur ou le formatage des dates. Par défaut : fr, sinon 'en' ou 'us' |
| name       | Nom recherché, soit dans l'identifiant principal de l'échantillon, soit dans les identifiants secondaires utilisables pour la recherche |   |
| uidsearch  | UID de l'échantillon à rechercher |
| sample_type_id | Identifiant du type d'échantillon |
| object_status_id | Code du statut de l'échantillon |
| uid_min | UID minimum à rechercher |
| uid_max | UID maximum à rechercher |
| sampling_place_id | Identifiant du lieu de prélèvement |
| metadata_field | Champ de métadonnées dans lequel la recherche s'effectuera. Le champ est multivalué, les critères étant de type "ou". Seuls trois champs peuvent être utilisés |
| metadata_value | Valeur recherchée . Champ multivalué (idem) |
| select_date | Sélection du type de recherche par date. cd  : date de création, sd : date d'échantillonnage (de prélèvement), ed : date d'expiration, ch : date de changement de l'information dans la base de données |
| date_from | Date de début de recherche, sous la forme jj/mm/aaaa |
| date_to | Date de fin de recherche, sous la forme jj/mm/aaaa |
| movement_reason_id | Motif du mouvement |
| trashed | Si positionné à 1, recherche les échantillons qui ont été déplacés dans la corbeille |
| SouthWestlon, SouthWestlat, NorthEastlon, NorthEastlat | longitudes et latitudes du rectangle de recherche par zone géographique des échantillons |
| campaign_id | identifiant de la campagne de prélèvement/collecte |
| country_id | pays de collecte |
| country_origin_id | pays d'origine de l'échantillon (peut être différent du pays de collecte) |
| authorization_number | Numéro de l'autorisation de collecte |
| event_type_id | Recherche par type d'événement survenu |
| subsample_quantity_min, subsample_quantity_max | recherche des échantillons qui contiennent les quantités de sous-échantillonnage disponibles (bornes mini et maxi) |
| booking_type | Type de réservation |
| without_container | si positionné à 1, recherche les échantillons qui ne sont pas rangés dans des contenants |

{.table .table-bordered .table-hover}

## Données retournées

### Format

Les données sont retournées au format JSON

### Contenu

La recherche des UID retourne une liste des UID correspondant aux critères de recherche.

La recherche complète retourne les informations suivantes :

{: .datatable}

| Colonne | Description |
| --- | ---|
| sample_id | identifiant interne de l'échantillon |
| uid | UID de l'échantillon |
| uuid | Identifiant universel de l'échantillon |
| identifier | identifiant métier principal de l'échantillon |
| identifiers | identifiants secondaires, séparés par une virgule |
| collection_id, collection_name | collection de l'échantillon |
| no_localization | collection sans localisation des échantillons activée |
| sample_type_id, sample_type_name | type d'échantillon |
| dbuid_origin | uid d'origine de l'échantillon, quand il a été créé en dehors de l'instance courante de Collec-Science |
| sample_creation_date | date de création de l'échantillon |
| sampling_date | date d'échantillonnage / collecte |
| expiration_date | date d'expiration de l'échantillon |
| change_date | date de modification de l'échantillon dans la base de données |
| metadata | liste des métadonnées |
| object_comment | commentaire général sur l'échantillon |
| movement_date, movement_type_id, movement_type_name | informations sur le dernier mouvement de l'échantillon |
| container_uid, container_uuid, container_identifier, storage_type_name | description du contenant de l'échantillon |
| line_number, column_number | emplacement dans le contenant |
| clp_classification | risque lié à l'échantillon |
| campaign_id, campaign_name, campaign_uuid | données sur la campagne de prélèvement |
| parent_sample_id | identifiant interne du parent de l'échantillon (celui dont il dérive) |
| parent_uid, parent_identifier, parent_uuid, parent_identifiers | informations sur le parent de l'échantillon |
| operation_id, operation_name, operation_order, operation_verion, protocol_name, protocol_year, protocol_version | informations sur l'opération et le protocole qui a conduit à la création de l'échantillon |
| multiple_type_id, multiple_type_name, multiple_unit, multiple_value, subsample_quantity | type de sous-échantillonnage et unité, quantité initiale et quantité restante (subsample_quantity) |
| wgs84_x, wgs84_y | positionnement géographique de l'échantillon, soit saisi, soit calculé à partir du lieu de prélèvement |
| location_accuracy | précision de la localisation |
| country_id, country_name , country_code2| pays de prélèvement de l'échantillon (nom et code international sur 2 positions) |
| country_origin_id, country_origin_name , country_origin_code2| pays de provenance de l'échantillon (nom et code international sur 2 positions) |
| object_status_id, object_status_name | statut de l'échantillon |
| referent_id, referent_name, referent_email, address_name, address_line2, address_line3, address_city, address_country, referent_phone, referent_firstname, academic_directory, academical_link, referent_organization | données sur le référent de l'échantillon |
| borrower_id, borrower_name, borrowing_date, expected_return_date | emprunteur de l'échantillon, date d'emprunt et date de retour prévue |
| nb_derivated_sample | nombre d'échantillons dérivés rattachés |

{.table .table-bordered .table-hover}

## Codes d'erreur


| Code d'erreur | Signification         |
| --------------- | ----------------------- |
| 500           | Internal Server Error |
| 401           | Unauthorized          |
| 520           | Unknown error         |
| 404           | Not Found             |

{.table .table-bordered .table-hover}