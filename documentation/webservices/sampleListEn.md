# Web service for retrieving a list of samples

## Presentation

Two services are available: the first allows you to retrieve only the list of UIDs concerned, the second allows you to retrieve all the information.
The search engine is identical to that used in the web interface, except that the search is only performed within a single collection. This last point is linked to the security measures put in place for querying via the APIs.

## Call method

~~~
index.php?module=apiv1sampleList : complete list
index.php?module=apiv1sampleUids : list of UIDs
~~~

## Parameters

Parameters suffixed with *_id* must be searched for in the application parameters (web interface). The programme does not search for values corresponding to labels, as is done elsewhere in the import procedures.

Parameters are cumulative, except for metadata, which is multi-valued.

### Mandatory parameters

{: .datatable}


| Parameter | Content |
| --------------- | --------------------------------------- |
| token | identification token |
| login | login associated with token |
| collection_id | Computer number of the collection |

{.table .table-bordered .table-hover}


### Optional parameters


{: .datatable}


| Parameter | Description |
| --- | --- |
| Language code used for error messages or date formatting. Default: fr, otherwise 'en' or 'us' |
| name | Name searched for, either in the main identifier of the sample or in the secondary identifiers used for the search |
| uidsearch | UID of the sample to be searched for |
| sample_type_id | Identifier of the sample type |
| object_status_id | Sample status code |
| uid_min | Minimum UID to search for |
| uid_max | maximum UID to search for |
| sampling_place_id | Identifier of the sampling place |
| metadata_field | Metadata field to search. The field is multi-valued, the criteria being of the "or" type. Only three fields can be used |
| metadata_value | Search value . Multi-valued field (idem) |
| cd: creation date, sd: sampling date, ed: expiry date, ch: date of change of information in the database. |
| date_from | Search start date, in the locale form |
| date_to | End date of search, in the locale form |
| movement_reason_id | Reason for movement |
| trashed | If set to 1, searches for samples that have been trashed |
| SouthWestlon, SouthWestlat, NorthEastlon, NorthEastlat | longitudes and latitudes of the search rectangle by geographical area of the samples |
| campaign_id | sampling/collection campaign identifier |
| country_id | country of collection |
| country_origin_id | country of origin of the sample (may be different from the country of collection) | 
| event_type_id | Search by type of event |
| subsample_quantity_min, subsample_quantity_max | search for samples containing the available subsampling quantities (minimum and maximum bounds) |
| booking_type | Type of booking |
| without_container | if set to 1, finds samples that are not stored in containers |

{.table .table-bordered .table-hover}

## Data returned

### Format

Data is returned in JSON format


### Content


Searching for UIDs returns a list of UIDs matching the search criteria.


The complete search returns the following information:


{: .datatable}


| Column | Description |
| --- | ---|
| sample_id | internal sample identifier |
| uid | sample UID |
| uuid | universal identifier of the sample |
| identifier | primary business identifier for the sample |
| identifiers | secondary identifiers, separated by a comma |
| collection_id, collection_name | collection de l'échantillon |
| no_localization | collection without sample localization enabled |
| sample_type_id, sample_type_name | sample type |
| dbuid_origin | original uid of the sample, when it was created outside the current instance of Collec-Science |
| sample_creation_date | sample creation date |
| sampling_date | sampling date |
| expiration_date | sample expiration_date |
| change_date | date sample was modified in database | 
| metadata | list of metadata | 
| object_comment | general comment on sample |
| movement_date, movement_type_id, movement_type_name | information about the sample's last movement |
| container_uid, container_uuid, container_identifier, storage_type_name | description of the sample container |
| line_number, column_number | location within the container | 
| clp_classification | sample risk | 
| campaign_id, campaign_name, campaign_uuid | campaign data |
| parent_sample_id | internal identifier of the sample's parent (the one from which it is derived) | 
| parent_uid, parent_identifier, parent_uuid, parent_identifiers | information on the sample parent |
| operation_id, operation_name, operation_order, operation_verion, protocol_name, protocol_year, protocol_version | information on the operation and protocol that led to the creation of the sample | 
| multiple_type_id, multiple_type_name, multiple_unit, multiple_value, subsample_quantity | type of sub-sampling and unit, initial quantity and remaining quantity (subsample_quantity) | 
| wgs84_x, wgs84_y | geographical position of the sample, either entered or calculated from the sampling location | 
| location_accuracy | precision of location | 
| country_id, country_name , country_code2| country of sample collection (name and international code in 2 positions) |
| country_origin_id, country_origin_name , country_origin_code2| country of origin of sample (name and 2-digit international code) |
| object_status_id, object_status_name | sample status |
| referent_id, referent_name, referent_email, address_name, address_line2, address_line3, address_city, address_country, referent_phone, referent_firstname, academic_directory, academic_link, referent_organization | data on the sample referent |
| borrower_id, borrower_name, borrowing_date, expected_return_date | sample borrower, borrowing date and expected return date | 
| nb_derivated_sample | number of derived samples attached |


{.table .table-bordered .table-hover}


## Error codes




| Error code | Meaning |
| --------------- | ----------------------- |
| 500 Internal Server Error
| 401 | Unauthorized |
| 520 Unknown error
| 404 | Not Found |


{.table .table-bordered .table-hover}