# Create or modify a label template

Labels are composed of two parts: a code readable with an optical reader, and text.

The optical code can be of two types:

- either a QRCODE: this can contain:
  - multiple pieces of information, stored in JSON format: it must then include at least the object's UID and the database code;
  - a single piece of information. In this case, the UUID identifier is preferred, which guarantees the object's global uniqueness, unless the generated QRCODE is too large. In this case, only the sample's UID must be stored;
- or a 1D barcode in EAN 128 format. This format is used for round containers (tubes), which make 2D optical reading difficult. In this case, the code must contain only the sample's UID.

Labels are created using FOP software, written in Java.

Here are the operations performed by the application to generate the labels:

- for each object concerned (containers or samples associated with a container type, and if the container type is linked to a label template), a QR code image is generated in a temporary folder;
- in this temporary folder, an XML file is generated, containing the information to be printed on the label;
- an XSL file, containing the label creation instructions, is also created in the same folder. The contents of this file are taken from a record in the *label* table;
- the PHP program uses FOP to generate a PDF file from the XML file and using the XSL file. One page of the file corresponds to one label (a mechanism used by label printers to separate them).

Configuring the label template involves defining both the content of the information that will be inserted into the barcode or QRCODE and the label's format, i.e., the information that will be printed, the format, etc. This format uses the XSL syntax understood by FOP.

## Defining the QRcode Content

The QRcode is a standardized two-dimensional barcode format that can store up to 2,000 8-bit characters.

The principle adopted in the application is to store information in JSON format. To limit the size of the barcode, tag names must be as small as possible. Here are the mandatory tags that must always be included in a label:

| Name | Description |
| ----- | :------------------------------------------------------------------------------ |
| uid | Unique identifier of the object in the database |
| db | Database identifier. This is the value of the APPLI_code parameter |

{.table .table-bordered .table-hover .datatable-nopaging-nosort }

Other information can also be inserted:

### Fields that can be used in the QRCODE (in JSON format) or verbatim, in the label

| Name | Description |
| ---------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| id | general business identifier |
| col | collection code |
| pid | parent sample identifier |
| clp | risk code |
| pn | protocol name |
| x | wgs84_x coordinate of the object (sampling or storage location, depending on the case) |
| y | wgs84_y coordinate of the object |
| loc | sampling location (table of sampling locations)|
| ctry | collection country code |
| prod | product used for preservation |
| cd | sample creation date in the database |
| sd | sampling date |
| ed | sample expiration date |
| uuid | Universal User Identifier (UUID) |
| ref | object referent |
| other codes | all secondary identification codes defined in the Identifier Types parameter table |
| fields used in the metadata | field codes used in the metadata description. A label template can only be associated with one metadata type |

{.table .table-bordered .table-hover .datatable-nopaging-nosort }

### Fields usable in the single-content QRCODE

| Name | Description |
| -------------- | :------------------------------------------------------------------------------------------------------------------------------ |
| id | general business identifier |
| uid | Unique identifier of the object in the database |
| uuid | Universal User Identifier (UUID) |
| other | any non-numeric secondary identifier - see Settings > Identifier Types |
| dbuid_origin | identifier of the original database. For a sample created in the current database, the value will be of type db:uid |

{.table .table-bordered .table-hover .datatable-nopaging-nosort }

In this case, it is recommended to use the UUID code, which guarantees the uniqueness of the sample or object number worldwide.

### Field usable in the EAN 128 barcode

For optical reading reasons, it is strongly recommended to insert only the *uid* number of the sample.

## XSL File Configuration

The specific syntax of the XSL file should only be modified while retaining the initial version (e.g., copying into a notepad) to avoid losing an operational configuration due to incorrect settings.

Here is a description of the file contents and the editable areas.

### File Header

This allows you to modify the label size (maximum width and height). You should only change the page-height and page-width attributes. For margins (margin- attributes), be careful and check that the QR codes are not cropped due to insufficient margins.

~~~
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fo="http://www.w3.org/1999/XSL/Format">
<xsl:output method="xml" indent="yes"/>
<xsl:template match="objects">
<fo:root>
<fo:layout-master-set>
<fo:simple-page-master master-name="label"
page-height="5cm" page-width="10cm"
margin-left="0.5cm"
margin-top="0.5cm"
margin-bottom="0cm"
margin-right="0.5cm">
<fo:region-body/>
</fo:simple-page-master>
</fo:layout-master-set>
<fo:page-sequence master-reference="label">
<fo:flow flow-name="xsl-region-body">
<fo:block>
<xsl:apply-templates select="object" />
</fo:block>
</fo:flow>
</fo:page-sequence>
</fo:root>
</xsl:template>
<xsl:template match="object">
~~~

### Label Format

The label content is described as a table (*fo:table* tags). The first column contains the QR code, the second the associated text. Here, two columns of identical size (4 cm each) are defined.

~~~
<fo:table table-layout="fixed" border-collapse="collapse"
border-style="none" width="8 cm"
keep-together.within-page="always">
<fo:table-column column-width="4 cm"/>
<fo:table-column column-width="4 cm" />
<fo:table-body border-style="none" >
~~~

The cells (*table-cell*) are inserted into a row (*table-row*):

~~~
<fo:table-row>
~~~

### Inserting the QR code

The QR code is inserted into a block. The only editable information is the height (height attribute) and the width (content-width attribute). Make sure the height and width are the same, and do not change the other information.

~~~
<fo:table-cell>
<fo:block>
<fo:external-graphic>
<xsl:attribute name="src">
<xsl:value-of select="concat(uid,’.png’)" />
</xsl:attribute>
<xsl:attribute name="content-height">
scale-to-fit
</xsl:attribute>
<xsl:attribute name="height">4cm</xsl:attribute>
<xsl:attribute name="content-width">4cm</xsl:attribute>
<xsl:attribute name="scaling">uniform</xsl:attribute>
</fo:external-graphic>
</fo:block>
</fo:table-cell>
~~~

### Text content

Other information is displayed in blocks, with one line per category of information.
The label here begins by indicating the institution (here, INRAE), written in bold.

~~~
<fo:table-cell>
<fo:block>
<fo:inline font-weight="bold">
INRAE
</fo:inline>
</fo:block>
~~~

Each piece of information is displayed in a block, including a title (e.g., uid), associated with one or more values. Thus, the first line displays, on the same line, and in bold (font-weight="bold" attribute), the database code (*<xsl:value-of select="db"/>*) and the object's UID (*<xsl:value-of select="uid"/>*).

~~~
<fo:block>uid:
<fo:inline font-weight="bold">
<xsl:value-of select="db"/>:
<xsl:value-of select="uid"/></fo:inline>
</fo:block>
<fo:block>id:
<fo:inline font-weight="bold">
<xsl:value-of select="id"/></fo:inline>
</fo:block>
<fo:block>col:
<fo:inline font-weight="bold">
<xsl:value-of select="col"/></fo:inline>
</fo:block>
<fo:block>clp:
<fo:inline font-weight="bold">
<xsl:value-of select="clp"/></fo:inline>
</fo:block>
~~~

If you want to change the character size, use the tag:

~~~
<fo:inline font-size="8pt">text</fo:inline>
<fo:inline font-size="8pt" font-weight="bold">bold text</fo:inline>
~~~

### End of the label

Once all the information is displayed, the table is closed, and a page break is systematically generated:

~~~
</fo:table-cell>
</fo:table-row>
</fo:table-body>
</fo:table>
<fo:block page-break-after="always"/>
~~~

Finally, the XSL file is correctly closed:

~~~
</xsl:template>
</xsl:stylesheet>
~~~

It is possible to create labels with different formats, for example by creating multiple lines. Remember to close your tags and ensure they are properly nested to avoid any issues.

For more information on layout, you can consult the [FOP project documentation](https://xmlgraphics.apache.org/fop/fo.html), and for text formatting, [the one concerning XSL](https://www.w3.org/TR/xsl11).