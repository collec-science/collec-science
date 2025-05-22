# Récupération de la liste des fichiers attachés à un objet

## Méthode d'appel

~~~
	apiv1documents?uid=xxx&token=yyyy&login=zzz
~~~

Paramètres :


| Paramètre  | Contenu                                                                                                                 |
| ------------- | ------------------------------------------------------------------------------------------------------------------------- |
| uid ou uuid | UID ou UUID de l'objet considéré (obligatoire)                                                                        |
| token       | jeton d'identification. Information obligatoire si la collection n'est pas publique                                     |
| login       | login associé au jeton (token). Les deux informations doivent être fournies pour que l'identification soit réalisée |

{.table .table-bordered .table-hover}

## Données retournées

La liste des documents, au format JSON :


| Colonne                | Description                                        |
| ------------------------ | :--------------------------------------------------- |
| uuid                   | UUID du document                                   |
| document_name          | Nom du document (nom du fichier)                   |
| document_import_date   | Date d'import du document dans la base de données |
| document_creation_date | Date de création du document                      |
| document_description   | Description du document                            |
| size                   | Taille en octets du document                       |
| content_type           | Type Mime du document                              |
| extension              | Extension du document                              |

{.table .table-bordered .table-hover}

## Codes d'erreur


| Code d'erreur | Signification         |
| --------------- | ----------------------- |
| 400           | Bad request           |
| 500           | Internal Server Error |
| 401           | Unauthorized          |
| 403           | Forbidden             |
| 520           | Unknown error         |
| 404           | Not Found             |

{.table .table-bordered .table-hover}
