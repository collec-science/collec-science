# API de création / modification d'un échantillon

## Principe

Cette API permet, depuis une application tierce, de créer ou modifier un échantillon dans une collection.

Deux modes sont disponibles : soit l'application tierce fournit des colonnes conformes à ce qui est attendu par Collec-Science, soit elle fait appel (dans les variables fournies) à un modèle de _dataset_ qui renommera les colonnes, voire les contenus des tables de référence.

Avant toute création, les échantillons sont recherchés selon plusieurs critères possibles. Si aucun échantillon n'est trouvé, il est alors créé. Dans le cas contraire, il est modifié.

L'API crée également les référents, les stations ou les campagnes s'ils n'existent pas préalablement.

Si l'UID ou l'identifiant principal du contenant est indiqué, le mouvement d'entrée sera également créé.

## Identification

Consultez ce document pour créer l'utilisateur de l'API, générer un token et lui donner les droits adéquats : [Identification pour les services web](swidentification_fr)

## Appel par défaut

> URL : apiv1sampleWrite

L'API doit être appelée en mode http **POST**.

### Variables à fournir

| Nom de la variable | Description | obligatoire |
| --- | --- | --- |
| login | Login du compte utilisé pour appeler l'API | X |
| token | Jeton d'identification associé au login | X |
| locale | Code de la langue utilisée pour les messages d'erreur ou le formatage des dates. Par défaut : fr, sinon 'en' ou 'us' |   |
| template\_name | Nom du modèle de dataset pour formater les données au préalable. Dans ce cas, les colonnes suivantes peuvent être différentes (elles seront traduites par l'application du modèle de dataset) |   |
| uid | UID de l'échantillon (si connu) |   |
| identifier | identifiant métier de l'échantillon | X |
| uuid | Universal Identifier : identifiant universel de l'échantillon |   |
| search\_order | Ordre d'utilisation des identifiants pour rechercher les échantillons. Par défaut : uid,uuid,identifier |   |
| sample\_type\_name | Nom du type d'échantillon. Il doit correspondre à un type d'échantillon déjà existant | X si sample\_type\_code n'est pas renseigné |
| sample\_type\_code | Code du type d'échantillon, quand celui-ci est normalisé pour les échanges | X si sample\_type\_name n'est pas renseigné |
| collection\_name | Nom de la collection | Obligatoire si le login est associé à plus d'une collection |
| sampling\_date | Date d'échantillonnage, au format Y-m-d H:i:s |   |
| sampling\_place\_name | Station d'échantillonnage. Si elle n'existe pas, elle sera créée automatiquement |   |
| multiple\_value | Quantité initiale dans l'échantillon (sous-échantillonnage) |   |
| metadata | Liste des métadonnées associées, au format JSON |   |
| md\_item | les colonnes commençant par md\_ seront intégrées dans les métadonnées de l'échantillon |   |
| expiration\_date | Date d'expiration de l'échantillon, au format Y-m-d H:i:s |   |
| campaign\_name | Nom de la campagne de prélèvement. Elle sera créée si elle n'existe pas au préalable |   |
| country\_code | Code officiel sur deux positions du pays de collecte |   |
| country\_origin\_code | Code officiel sur deux positions du pays ayant fourni l'échantillon |   |
| wgs84\_x | longitude de collecte, au format décimal (WGS 84) |   |
| wgs84\_y | latitude de collecte, au format décimal (WGS 84) |   |
| referent\_name | Nom du référent. Sera créé (avec son prénom, si fourni) s'il n'existe pas au préalable |   |
| referent\_firstname | Prénom du référent |   |
| location\_accuracy | Précision de la localisation du lieu de collecte de l'échantillon |   |
| object\_comment | Commentaire libre |   |
| identifiers | Identifiants secondaires, formatés ainsi : "code1:val1,code2:val2" |   |
| parent\_uid | uid de l'échantillon parent, si connu |   |
| parent\_uuid | uuid de l'échantillon parent, si connu |   |
| parent\_identifier | identifiant métier de l'échantillon parent, si connu |   |
| parent\_code | code de l'identifiant secondaire du parent, si connu |   |
| container\_uid | UID du contenant dans lequel l'échantillon doit être inséré |   |
| container\_name | à défaut, nom du contenant |   |
| column\_number, line\_number | numéro de colonne et de ligne où lequel l'échantillon est inséré |   |

{.table .table-bordered .table-hover .datatable-nopaging-nosort }

### Ordre de recherche des échantillons

Par défaut, sauf si _search\_order_ est renseigné ou si un modèle de dataset est utilisé, la recherche des échantillons s'effectue dans l'ordre suivant :

1.  uid : identifiant interne dans Collec-Science
2.  uuid : identifiant universel
3.  identifier : identifiant métier. Il est recherché uniquement dans la collection considérée.