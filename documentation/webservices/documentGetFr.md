# Service web de récupération d'un fichier attaché à un objet

## Méthode d'appel

	index.php?module=documentGetSW&uuid=xxx&token=yyyy&mode=inline
	
Paramètres : 

| Paramètre | Contenu |
|--|--|
| uuid | UUID du document concerné (obligatoire) |
| token | jeton d'identification. Information obligatoire si la collection n'est pas publique |
| mode | inline/attached : définit le mode d'envoi du document. Par défaut, *inline* |


## Données retournées

Le document au format binaire, avec le type MIME correspondant.

## Codes d'erreur

| Code d'erreur | Signification |
|--|--|
| 500  | Internal Server Error |
| 401 | Unauthorized |
| 520 | Unknown error |
| 404 | Not Found |

