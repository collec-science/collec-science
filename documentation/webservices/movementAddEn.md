# API for creating a movement

## Principle

The API allows to generate input or output movements, from either the UID or the business identifier (which must then be unique in the database).

## Identification

Consult this document to create the API user, generate a token and give him the appropriate rights: [Identification for web services](index.php?module=swidentification_en)

## Default call

> URL: index.php?module=apiv1movementWrite

The API must be called in http **POST** mode.

### Variables to provide


| Variable name        | Description                                                                                                                                                  | mandatory |
| ---------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------: |
| login                | Login of the account used to call the API                                                                                                                    |     X     |
| token                | token of identification associated with the login                                                                                                            |     X     |
| locale               | Language code used for error messages or date formatting. Default: fr, otherwise 'en' or 'us'                                                                |           |
| uid                  | UID of the object on which the movement is generate                                                                                                          |   X(*)   |
| uuid                 | UUID of the object on which the movement is generate                                                                                                         |   X(*)   |
| identifier           | Business identifier of the object on which the movement is generate                                                                                          |   X(*)   |
| movement_type        | 1 : entry into stock / 2 : exit from stock                                                                                                                   |     X     |
| container_uid        | UID of the container (entry in the stock)                                                                                                                    |   X(**)   |
| container_uuid       | UUID of the container (entry in the stock)                                                                                                                   |   X(**)   |
| container_identifier | Business identifier of the container                                                                                                                         |   X(**)   |
| movement_reason      | Reason for removal from storage. Numerical value, corresponding to the key of the record in the[Reasons for Destocking](index.php?module=movementReasonList) |           |
| column               | N° of the column where the object is stored in the container                                                                                                |           |
| line                 | N° of the line where is stored the object in the container                                                                                                  |           |
| storage_location     | Free text to specify the storage location                                                                                                                    |           |
| movement_comment     | Free text                                                                                                                                                    |           |

{ .table .table-bordered .table-hover .datatable-nopaging-nosort }

(*): either the UID, or the UUID, or the business identifier of the object must be provided

(**) : either the UID, or the UUID, or the business identifier of the container must be provided, as long as it is an input transaction

Translated with www.DeepL.com/Translator (free version)
