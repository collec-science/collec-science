News
===========
Version 2.1
--------------
- Update to version 2.5 of ObjetBdd (secure features)
- update to version 3.1.24 of Smarty
- improvement of security : new .htaccess, cookies of session are secure better, etc.

Version 2.0
--------------
- Integration of version 2.4.2 of ObjetBDD : function getList($order int) contains a new parameter, to sort the list by the number of the column
- Integration of release tcpdf_0_6_062
- adding class jquery.cookie.js, to write a cookie directly from navigator
- adding class jquery.magnific-popup.min.js, to display thumbnails or picture
- Greats changes for login process :
	* it's now possible to connect first with LDAP connexion, and if lost, with database connexion
	* automatic generation of a random password into the user form
	* addition of an icon, at right of menu, which indicate if user is connected (green icon) or no (red icon)
- changes into stylesheet blue.css :
	* new class to display date fields (with icon in background)
	* new method to create forms, with <dl><dt><dd>. 2 sizes of form : 800px (default), or 400px. Example into display/templates/example/exampleChange.tpl
	
Version 1.9
--------------
- Integration of version 2.4 of ObjetBDD, which fixes a bug in the management of geographic fields PostGIS
- Added in the "Administration" menu, an item which displays the phpinfo ()
- Added a function for debugging "online": printr ($variable, $mode_dump = 0) shows the variable, whether it be a simple variable or an array. Dump mode can be activated via the second parameter to 1.
- Improved modules / example / script example.php
- The session cookie is now regenerated at each page call to prevent accidental disconnection of the session in regular use of the application
- Added the class modules/gestion/search.class.php, which allows you to easily manage settings search windows (see examples into the file modules/example/example.php and others)

Version 1.8
--------------
- Integration of new ObjetBDD release ( 2.2.5 ), which includes many new features to manage postgresql database (adding double -quotes if the field name contains uppercase , addition of type 4 for managing geographic fields postgis , etc . )
- Change language management
	* By default, the program allows you to select English or French from the title bar. The information is stored in a cookie ;
	* Main language, defined in the application , is overloaded by translations in the target language . Thus , if a translation does not exist, it is the value of the original language that is displayed
- Correction of the style used for displaying buttons javascript list management : the buttons are shorter and do not bother posting more
- Fixed a security bug : session ID was not regenerated after logging
- Correction controller : when a page is called into mode 'ajax', it is no longer stored in the module_before variable, which could cause some problems in the entry sheets that used ajax requests and when this parameter was set
- Added the ability to only display a menu item if it is not identified (for example, to display the choice "connection" ) . The value in use is actions.xml onlynoconnect = "1"
- The javascript function setDataTables was completed to manage other settings (see the description of the function)
- Creation of a script generation of tables used by phpgacl for postgresql install ( two scripts: one for the public schema, one for the GaCl schema). Correction of names used in phpgacl ( ACO particular).
	* It is also possible to download phpgacl and run the install.php to create database script phpgacl
- Added variable $ APPLI_cookie_ttl = 2592000 , in param.default.inc.php to indicate a value of conservation cookies different from the duration of the session

Version 1.7
--------------
- Renaming the folder smarty as display
- Creation of 3 new functions available for the management of records:
	* DataRead ($DataClass $id, $smartyPage $ParentID = null): reads a record in database and prepare the display in Smarty
	* Datawrite ($DataClass , $data) : writes a record in database
	* DataDelete ($DataClass $id): deletes a record in database
- Integration of version 2.2.4 of ObjetBDD
- It is now possible to check if a module is executed after another (writing or deleting after viewing the record , for example). To do this:
	* Add the attribute " modulebefore " in the descriptor of the module ( actions.xml ) , p. e . : Modulebefore = " fichedetail,fichemodif " ( separate different modules authorized by comma)
- Addition of phpExcelReader to read an Excel file directly
- Addition of a class to manage the import external files ( CSV ​​or XLS) in framework / import / import.class.php
- Creation of a model management record (modules / example / example.php ) to facilitate learning
- Added the JQuery Javascript library DataTables
