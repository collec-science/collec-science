## Batch export

### Introduction

In order to do a batch export, you will need to configure :

  * A batch of objects: list of objects that will be exported
  * A dataset model : list of data of an object to export
  * An export model : export options (file name, dataset model to use)

### Creation of a batch for export

Go to "Objects" -> "Samples" :
 
  * Select the collection (mandatory to create the batch)
  * Define the filters you are interested in (example: type of sample, status, ...)
  * Perform the search by clicking on "Search"
  * Select the objects and then, for the selected elements: "Create an export batch".

The list of samples once created is not changeable.

### Creation of a dataset model

Go to "Imports/Exports", "Dataset models" then "New"...

  * Name : this name will be displayed in the export model
  * Type : sample, collection... (define the exportable fields)
  * Export format : CSV, JSON, XML (preferably JSON ;)
  * Name of the file that will be in the zip if there are several files or if you want it to be compressed
  * The rest is used to customize the XML or CSV

When you have finished, click on "Validate".

Once created you can specify the columns with "New column":

  * Select the field you want to add
  * Define the name of the field in the export
  * You can specify if this field is mandatory for the export and if you want a default value if it is not filled
  * You can also specify the date formatting

In the case of metadata, you must also specify the name of the metadata. You can't export all the metadata at once.

### Creating an export template

Go to "Imports/Exports", "Dataset templates" then "New"...

  * Name
  * Description
  * Version
  * Compressed file
  * Name of the generated file
  * Select dataset model

### Launch an export

Go to "Imports/Exports" then "Export batches":

  * Select a batch
  * New export
  * Select the export mode
  * Click on "Generate export".

Translated with www.DeepL.com/Translator (free version)