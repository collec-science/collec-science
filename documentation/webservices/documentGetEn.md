# Web service to retrieve a file attached to an object

## Call method

~~~
	index.php?module=documentGetSW&uuid=xxx&token=yyyy&mode=inline
~~~

Parameters :


| Parameter | Content                                                                                                 |
| ----------- | --------------------------------------------------------------------------------------------------------- |
| uuid      | UUID of the concerned document (mandatory)                                                              |
| token     | identification token. Information required if the collection is not public                              |
| locale    | Language code used for error messages or date formatting. Default: fr, otherwise 'en' or 'us'.          |
| login     | login associated to the token. Both information must be provided for the identification to be performed |
| mode      | inline/attached : defines the way the document is sent. By default,*inline*                             |

{.table .table-bordered .table-hover}

## Returned data

The document in binary format, with the corresponding MIME type.

## Error codes


| Error code | Meaning               |
| ------------ | ----------------------- |
| 500        | Internal Server Error |
| 401        | Unauthorized          |
| 520        | Unknown error         |
| 404        | Not Found             |

{.table .table-bordered .table-hover}
