# API for creating / modifying a sample

## Principle

This API allows, from a third party application, to create or modify a sample in a collection.

Two modes are available: either the third-party application provides columns that are in accordance with what is expected by Collec-Science, or it calls (in the variables provided) a *dataset* model that will rename the columns, or even the contents of the reference tables.

Before any creation, the samples are searched according to several possible criteria. If no sample is found, it is created. If not, it is modified.

The API also creates referents, stations or campaigns if they do not exist beforehand.

If the UID or main identifier of the container is specified, the entry transaction will also be created.

## Identification

Consult this document to create the API user, generate a token and give him the appropriate rights: [Identification for web services](index.php?module=swidentification_en)

## Default call

> URL : index.php?module=apiv1sampleWrite

The API must be called in http **POST** mode.

### Variables to provide


| Variable name             | Description                                                                                                                                                                    |                              required                              |
| --------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------: |
| login                     | Login of the account used to call the API                                                                                                                                      |                                 X                                 |
| token                     | token of identification associated with the login                                                                                                                              |                                 X                                 |
| locale                    | Language code used for error messages or date formatting. Default: fr, otherwise 'en' or 'us'                                                                                  |                                                                   |
| template_name             | Name of the dataset template to format the data beforehand. In this case, the following columns may be different (they will be translated by the dataset template application) |                                                                   |
| uid                       | UID of the sample (if known)                                                                                                                                                   |                                                                   |
| identifier                | business identifier of the sample                                                                                                                                              |                                 X                                 |
| uuid                      | Universal Identifier : universal identifier of the sample                                                                                                                      |                                                                   |
| sample_type_name          | Name of the sample type. It must correspond to an existing sample type.                                                                                                        |                                                                   |
| collection_name           | Name of the collection                                                                                                                                                         | Mandatory if the login is associated with more than one collection |
| sampling_date             | Sampling date, in Y-m-d H:i:s format                                                                                                                                           |                                                                   |
| sampling_place_name       | Sampling station. If it does not exist, it will be created automatically.                                                                                                      |                                                                   |
| multiple_value            | Initial quantity in the sample (sub-sampling)                                                                                                                                  |                                                                   |
| metadata                  | List of associated metadata, in JSON format                                                                                                                                    |                                                                   |
| md_item                   | columns starting with md_ will be included in the sample metadata                                                                                                              |                                                                   |
| expiration_date           | Sample expiration date, in Y-m-d H:i:s format                                                                                                                                  |                                                                   |
| campaign_name             | Name of the sampling campaign. It will be created if it does not already exist.                                                                                                |                                                                   |
| country_code              | Official two-digit code of the country of collection                                                                                                                           |                                                                   |
| country_origin_code       | Official two-digit code of the country that provided the sample                                                                                                                |                                                                   |
| wgs84_x                   | sampling longitude, decimal (WGS 84)                                                                                                                                           |                                                                   |
| wgs84_y                   | sampling latitude, decimal format (WGS 84)                                                                                                                                     |                                                                   |
| referent_name             | Name of the referent. Will be created (with his first name, if provided) if it does not exist beforehand.                                                                      |                                                                   |
| referent_firstname        | First name of referent                                                                                                                                                         |                                                                   |
| location_accuracy         | Accuracy of the location of the sampling site                                                                                                                                  |                                                                   |
| object_comment            | free comment                                                                                                                                                                   |                                                                   |
| secondary identifier code | If secondary identifiers can be used, specify the code for them and the associated value (e.g., IGSN:125)                                                                      |                                                                   |
| parent_uid                | uid of parent sample, if known                                                                                                                                                 |                                                                   |
| parent_uuid               | uuid of parent sample, if known                                                                                                                                                |                                                                   |
| parent_identifier         | business identifier of parent sample, if known                                                                                                                                 |                                                                   |
| parent_code               | secondary identifier code of parent, if known                                                                                                                                  |       
| container_uid | UID of the container into which the sample is to be inserted |
| column_number, line_number | number of the column and line into which the sample is inserted |                                                            |

{ .table .table-bordered .table-hover .datatable-nopaging-nosort }

### Sample search order

By default, unless a dataset template is used, samples are searched in the following order:

1. uid: internal identifier in Collec-Science
2. uuid: universal identifier
3. identifier: business identifier. It is searched only in the considered collection.
