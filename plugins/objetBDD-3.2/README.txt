News
====
Version 2.5.1 - 03/06/2015
	* new function : getListFromParent($parentId, $order = 0) : similar to getList($order = 0), but with a where clause to found only rows from parent_id.

Version 2.5 - 02/06/2015
	* New security controls
	* utf8 encode now separate from htmlentities

Version 2.4.2.1 - 30/03/2015
	* New parameter : transformComma = 1. If 1, all commas in numeric field are transformed to a decimal point (for french keyboards).

Version 2.4.2 - 17/03/2014
	* New parameter to getListe function : getListe($order = 0). If $order > 0, the list is sorted by $order.

Version 2.3 - 24/10/2013 2013-10-24
	* Optimisations to postgresql/postgis :
		* New type for geographic field. You can describe a field with type = 4 : "liste" function return "asText(column)", and "ecrire" function run with geomFromText( '$data',$this->srid). The srid must be specified in the __construct function, like param["srid"] = 4326. Otherwise, the srid is set to -1. $data must be a geographic/geometric object, like LINESTRING( X Y, X1 Y1) or POINT(X,Y)
		* If a field name contain a capital letter, the field is surrounded by a "quote identifier" (only in select or where clause, when they are automatically generated). This character is ` for mysql, and " for postgresql.
		* fixed a bug to UTF8

Version 2.2.4 of 25/01/2013
	* Improve a new function : getDefaultValue($parentId). This function return the defaults values 
	* describe into the constructor function. Defaults can be values or functions of the class.
	* function lire() can be used to retrieve defaults values
	* Fixed bugs when the datas are verified before database writing.

Version 2.2.2 of 06/09/2012

    * Fixed a bug when a record is writing in a table postgresql containing a quote: writing is done by using, in this case, the function pg_escape_string.

Version 2.2.1 of 24/08/2012

    * Various modifications to make the class compatible with PostgreSQL
    * Cleaning of the class, correcting various problems.

Version 2.1.0 of 10/08/11

    * Setting up multiple key management: it is now possible to declare multiple keys, but all must be numeric (as before, for that matter).
    * If the table is fully described in the inherited class, the write function builds the SQL query from the table "raw" parameter provided (eg, $_REQUEST), checking variables passed. To do this in the constructor of the inherited class, set the variable $fullDescription true.
    * Addition, in the array $columns, of a field to specify whether or not a key ("key" = 1)
    * Addition of the class variable $ this->keys=array (), including the list of keys of the table
    * Modifying the pivotal year for entering the two-digit year: it goes from 29 to 49 (49 => 2049 50 => 1950)
    * If the date is entered without year (dd/mm), the current year is automatically added.
    * When reading of a record (function read($id), the class checks the data type $id, which can be an array. If the type is not correct, the query is not executed . Ditto for the function delete($id).
    * In  function supprimerChamp($id, $field), the numeric type (mandatory) of $field is checked before executing the query
    * Before a modification database (save or delete), the validity of the key is checked (type mainly)

Version 2.0.1 of 27/08/09

Fixed bugs introduced in version 2.0:

    * call a wrong function for executing SQL queries.
If INSERT fails, the class no longer trying to get the last key when the table is managed by automatic fields.

Addition of functions translated into English (read ($id) for lire($id), pe).

Version 2.0 15/08/09

    * Integration of a debug mode;
    * Addition of functions to verify the consistency of data (numeric fields, mask based on regular expressions, maximum length of text fields;
    * addition of encoding and decoding special characters html (htmlspecialchars and htmlspecialchars_decode);
    * amendment to the declaration of the columns, which can now be done in a table;
    * ability to pass parameters through a table in the constructor function (strongly recommended);
    * addition of a function to manage NN tables ;
    * SQL queries now run in a dedicated function;
    * removal of obsolete assignments (var) and replacement assignments PHP5 (public $var).
