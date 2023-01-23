# Associating external documents to a sample

## Principle

The Collec-Science application allows to store documents in the database. If this approach is relevant for small files (a few MB), storing much larger files (a few hundred MB or more), such as photos taken with modern microscopes, makes their management more complicated:

- the maximum downloadable volume *via* the application is limited to 50 or 100 MB
- the backup mechanisms are penalized as soon as the volume of these documents explodes.

To overcome these drawbacks, version 2.7 introduces the possibility of associating files stored in a server tree structure with samples.

## Security - limitations

As soon as you give access to files that are stored in a server tree, a certain number of precautions are taken to limit the risks that a user can obtain information other than that to which he is entitled:

- for an instance of Collec-Science, all the trees must be located in the same base folder;
- a tree is described for each collection. Two collections can share the same tree, but a collection cannot access two different trees;
- from a collection tree, links to other trees are forbidden;
- only users who have access rights to the collection can download files from the server.

## Setup

### Server setup

The whole tree must be accessible by the account used by the web server (*www-data* for an *Apache2* implementation). It is not necessary for the account to have write access - in fact it is strongly discouraged.

A base folder must be created in the server, which will serve as the root for all the tree structures described for the collections. The full path must be described in the *param/param.inc.php* file:

$APPLI_external_document_path = "/mnt/collec-science";
By default, the variable is set to */dev/null* to prevent its use without prior agreement from the server administrator.

The trees corresponding to each collection must start from this path. These may be mounts to other data servers, depending on the protocols appropriate to the local situation.

### Setting up collections

To activate the support of external files for a collection, you have to modify the corresponding form (*Settings > Collections*, then edit the collection). Here is the information to indicate:

- "Is the storage of documents attached to samples possible outside the database?" check the box *yes*.
- "Access path to external files" : indicate the relative path to the storage root (variable *$APPLI_external_document_path*).

From then on, it will be possible to browse the tree from a sample to reference a document.

## To reference one or more documents

From the sample view screen, tab *Associated documents* :

- under the table, in the *External files to associate with the sample* section, click on the root of the tree:
  - the list of files and sub-folders present is displayed
  - you can click on a sub-folder to browse this branch of the tree
- select the file or files you want to associate
- fill in the *Description* and *Date of creation of the documents* fields if you wish. Warning : this information will be valid for all the selected documents together
- at the bottom of the tree, click on the *Associate selected files* button.

If you want to change a description or a date for a document, just do the same operation again, the pre-existing record will be updated.

## What if the tree structure of a collection is moved?

You just have to recreate the montages and modify the parameters of the collection in the application, if necessary.

*Editor: Éric Quinton - 2022-03-30*

*Translated with www.DeepL.com/Translator (free version)*
