# API for deleting a sample

## Principle

This API allows you to delete a sample from a third-party application.

## Identification

Consult this document to create the API user, generate a token and give it the appropriate rights: [Identification for web services](index.php?module=swidentification_en)

## Default call

> URL: index.php?module=apiv1sampleDelete

The API must be called in http **POST** mode.

### Variables to provide

| Variable name | Description | mandatory |
| --- | --- | :---: |
| login | Login of the account used to call the API | X |
| token | token associated with the login | X |
| locale | Language code used for error messages or date formatting. Default: fr, otherwise 'en' or 'us' | |
| uid | UID of the sample to delete | X |

{.table .table-bordered .table-hover .datatable-nopaging-nosort }