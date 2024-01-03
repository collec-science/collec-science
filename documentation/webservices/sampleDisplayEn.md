# Web service to retrieve data from a sample

## Call method

~~~
index.php?module=apiv1sampleDisplay&uid=xxx&uuid=yyy&token=zzz&template_name=aaa
index.php?module=sampleDetail&uid=xxx&uuid=yyy&token=zzz&template_name=aaa
~~~

## Parameters
{: .datatable}


| Parameter     | Content                                                                                                                                     |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| uid           | Sample UID (required if UUID not filled in)                                                                                                 |
| uuid          | UUID of the sample (required if UID not filled in)                                                                                          |
| token         | identification token. Information required if the collection is not public                                                                  |
| login         | login associated to the token. Both information must be provided for the identification to be performed                                     |
| template_name | Name of the*template* used to format the information. This information must be provided if the *token* is not filled in (public collection) |
| locale        | Language code used for error messages or date formatting. Default: fr, otherwise 'en' or 'us'                                               |

{.table .table-bordered .table-hover}

## Returned data

### Format

The data is returned in JSON format

### Content

#### Collection not public or with token provided

By default, i.e. if no *template_name* is defined, the following information is embedded in the JSON record:


| Field                | Description                                                      |
| ---------------------- | ------------------------------------------------------------------ |
| uid                  | sample uid                                                       |
| dbuid_origin         | initial sample identifier, if entered in another database        |
| collection_name      | collection name                                                  |
| sample_type_name     | sample_type_name                                                 |
| sample_creation_date | sample creation date                                             |
| sampling_date        | sampling date                                                    |
| metadata_list        | associated metadata list                                         |
| expiration_date      | sample expiration date                                           |
| campaign_name        | name of sampling campaign                                        |
| multiple_value       | initial quantity (sub-sampling)                                  |
| multiple_unit        | sub-sampling unit                                                |
| multiple_value       | initial quantity (sub-sampling)                                  |
| wgs84_x              | longitude of sampling point                                      |
| wgs84_y              | latitude of sampling point                                       |
| country_name         | name of sampling country                                         |
| country_code2        | country code, two digits long                                    |
| object_status_name   | sample status                                                    |
| change_date          | date sample was last changed                                     |
| uuid                 | uuid of the sample                                               |
| trashed              | is 1 if the sample has been trashed (waiting to be deleted)      |
| location_accuracy    | precision of the location of the collection place                |
| object_comment       | comment on the sample                                            |
| parent_uid           | parent's uid                                                     |
| parent_identifier    | business identifier of parent                                    |
| parent_uuid          | parent uuid                                                      |
| parent_identifiers   | list of other identifiers of the parent                          |
| container_type_name  | name of the container type associated with the sample type       |
| clp_classification   | CLP risk associated with the container                           |
| protocol_name        | collection protocol name                                         |
| protocol_year        | protocol year                                                    |
| protocol_version     | protocol version                                                 |
| operation_name       | name of the operation associated with the protocol               |
| operation_version    | operation version                                                |
| identifiers          | list of secondary identifiers of the sample                      |
| movement_date        | date of last recorded movement                                   |
| movement_type_name   | type of last recorded movement                                   |
| sampling_place_name  | sampling station                                                 |
| sampling_place_name  | sampling station                                                 |
| column_number        | number of the column where the sample is stored in the container |
| container_uid        | uid of the container                                             |
| container_identifier | business identifier of the container                             |
| container_uuid       | container uuid                                                   |
| container_type_name  | container type                                                   |
| referent_name        | referent name                                                    |
| referent_email       | referent's email                                                 |
| address_name         | first line of the referent's address                             |
| address_line2        | second line of the referent's address                            |
| address_line3        | third line of the referent's address                             |
| address_city         | city of referrer                                                 |
| address_country      | country of referrer                                              |
| referent_phone       | referent's phone number                                          |
| referent_firstname   | referent's first name                                            |
| academical_directory | name of referent's academic structure (e.g., ORCID)              |
| academical_link      | referent's academic access link                                  |
| borrowing_date       | sample borrowing date                                            |
| expected_return_date | expected return date of sample                                   |
| borrower_name        | name of borrower                                                 |
| subsample_quantity   | quantity remaining in sample (subsampling)                       |
| events               | list of events recorded for the sample                           |
| container            | list of container hierarchy                                      |

{.table .table-bordered .table-hover}

#### Public collection or template name provided

The content depends exclusively on the settings made in the template.

## Error codes


| Error code | Meaning               |
| ------------ | ----------------------- |
| 500        | Internal Server Error |
| 401        | Unauthorized          |
| 520        | Unknown error         |
| 404        | Not Found             |

{.table .table-bordered .table-hover}

Translated with www.DeepL.com/Translator (free version)
