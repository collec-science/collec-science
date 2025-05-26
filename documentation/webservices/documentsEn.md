# Retrieving the list of files attached to an object

## Call method

~~~
apiv1documents?uid=xxx&token=yyyy&login=zzz
~~~

Parameters:

| Parameter | Content |
| ------------- | ------------------------------------------------------------------------------------------------------------------------- |
| uid or uuid | UID or UUID of the object in question (required) |
| token | Identification token. Mandatory information if the collection is not public |
| login | Login associated with the token. Both pieces of information must be provided for identification to be performed |

{.table .table-bordered .table-hover}

## Returned data

The list of documents, in JSON format:

| Column | Description |
| ------------------------ | :--------------------------------------------------- |
| uuid | UUID of the document |
| document_name | Document name (file name) |
| document_import_date | Date the document was imported into the database |
| document_creation_date | Date the document was created |
| document_description | Document description |
| size | Document size in bytes |
| content_type | Document Mime type |
| extension | Document extension |

{.table .table-bordered .table-hover}

## Error Codes

| Error Code | Meaning |
| --------------- | ----------------------- |
| 400 | Bad request |
| 500 | Internal Server Error |
| 401 | Unauthorized |
| 403 | Forbidden |
| 520 | Unknown error |
| 404 | Not Found |

{.table .table-bordered .table-hover}