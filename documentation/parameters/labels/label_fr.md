# Créer ou modifier un modèle d’étiquettes

Les étiquettes sont composées de deux parties : un code lisible avec un lecteur optique, et du texte.

Le code optique peut être de deux types :

- soit un QRCODE: celui-ci peut contenir  :
  - plusieurs informations, stockées au format JSON : il devra alors comprendre au minimum l'UID de l'objet et le code de la base de données ;
  - une seule information. Dans ce cas, on privilégiera l'identifiant de type UUID, qui garantit l'unicité de l'objet au niveau mondial, sauf si le QRCODE généré est trop grand. Il faudra alors stocker uniquement l'UID de l'échantillon ;
- soit un code-barre 1D au format EAN 128. Ce format est utilisé pour les supports ronds (tubes), qui rendent la lecture optique 2D difficile. Dans ce cas, le code ne devra contenir que l'UID de l'échantillon.

Les étiquettes sont créées en recourant au logiciel FOP, écrit en Java.

Voici les opérations réalisées par l’application pour générer les étiquettes :

- pour chaque objet concerné (des contenants ou des échantillons associés à un type de contenant, et si le type de contenant est rattaché à un modèle d’étiquettes), une image du QRcode est générée dans un dossier temporaire ;
- dans ce dossier temporaire, un fichier au format XML est généré, contenant les informations à imprimer sur l’étiquette ;
- un fichier au format XSL, qui contient les ordres de création de l’étiquette, est également créé dans le même dossier. Le contenu de ce fichier est issu d’un enregistrement provenant de la table *label* ;
- le programme PHP fait appel à FOP pour générer, à partir du fichier XML et en utilisant le fichier XSL, un fichier PDF. Une page du fichier correspond à une étiquette (mécanisme utilisé par les imprimantes à étiquettes pour les séparer).

La configuration du modèle d’étiquettes revient à définir à la fois le contenu des informations qui seront insérées dans le code-barre ou le QRCODE et la forme que prendra l’étiquette, c’est à dire les informations qui seront imprimées, le format, etc. Cette forme reprend la syntaxe XSL comprise par FOP.

## Définir le contenu du QRcode

Le QRcode est un format de code barre normalisé en deux dimensions, qui permet de stocker jusqu’à 2000 caractères en 8 bits.

Le principe retenu dans l’application est de stocker l’information au format JSON. Pour limiter la taille du code barre, les noms des balises doivent être les plus petites possibles. Voici les balises obligatoires à insérer systématiquement dans une étiquette :


| Nom | Description                                                                   |
| ----- | :------------------------------------------------------------------------------ |
| uid | Identifiant unique de l’objet dans la base de données                       |
| db  | Identifiant de la base de données. C’est la valeur du paramètre APPLI_code |

{.table .table-bordered .table-hover .datatable-nopaging-nosort }

D’autres informations peuvent être également insérées :

### Champs utilisables dans le QRCODE (au format JSON) ou textuellement, dans l'étiquette


| Nom                                          | Description                                                                                                                                           |
| ---------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------ |
| id                                           | identifiant  métier général                                                                                                                        |
| col                                          | code de la collection                                                                                                                                 |
| pid                                          | identifiant de l'échantillon parent                                                                                                                  |
| clp                                          | code de risque                                                                                                                                        |
| pn                                           | nom du protocole                                                                                                                                      |
| x                                            | coordonnée wgs84_x de l'objet (lieu de prélèvement ou de stockage suivant le cas)                                                                  |
| y                                            | coordonnée wgs84_y de l'objet                                                                                                                        |
| loc                                          | localisation du prélèvement (table des lieux de prélèvement)                                                                                      |
| ctry                                         | code du pays de collecte                                                                                                                              |
| prod                                         | produit utilisé pour la conservation                                                                                                                 |
| cd                                           | date de création de l'échantillon dans la base de données                                                                                          |
| sd                                           | date d'échantillonnage                                                                                                                               |
| ed                                           | date d'expiration de l'échantillon                                                                                                                   |
| uuid                                         | UID Universel (UUID)                                                                                                                                  |
| ref                                          | référent de l'objet                                                                                                                                 |
| autre codes                                  | tous les codes d’identification secondaires définis dans la table de paramètres Types d’identifiants                                              |
| les champs utilisés dans les métadonnnées | les codes des champs utilisés dans la description des métadonnées. Un modèle d’étiquette ne peut être associé qu’à un type de métadonnées |

{.table .table-bordered .table-hover .datatable-nopaging-nosort }

### Champs utilisables dans le QRCODE à contenu unique


| Nom          | Description                                                                                                                    |
| -------------- | :------------------------------------------------------------------------------------------------------------------------------- |
| id           | identifiant  métier général                                                                                                 |
| uid          | Identifiant unique de l’objet dans la base de données                                                                        |
| uuid         | UID Universel (UUID)                                                                                                           |
| autre        | tout identifiant secondaire non numérique - cf. paramètres > Types d'identifiants                                            |
| dbuid_origin | identifiant de la base de données d'origine. Pour un échantillon créé dans la base courante, la valeur sera de type db:uid |

{.table .table-bordered .table-hover .datatable-nopaging-nosort }

Il est conseillé d'utiliser dans ce cas de figure de préférence le code UUID, qui garantit l'unicité du numéro de l'échantillon ou de l'objet au niveau mondial.

### Champ utilisable dans le code-barre EAN 128

Pour des raisons de lecture optique, il est fortement conseillé de n'insérer que le numéro *uid* de l'échantillon.

## Configuration du fichier XSL

La syntaxe particulière du fichier XSL ne doit être modifiée qu’en conservant la version initiale (recopie dans un bloc-notes, par exemple), pour éviter de perdre une configuration opérationnelle suite à un mauvais paramétrage.

Voici la description du contenu du fichier et les zones modifiables.

### Entête du fichier

Elle permet de modifier la taille de l’étiquette (largeur et hauteur maximale). Vous ne devriez changer que les attributs page-height et page-width. Pour les marges (attributs margin-), soyez prudents et vérifiez notamment que les QRcodes ne soient pas rognés à cause de marges insuffisantes.

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

### Format de l’étiquette

Le contenu de l’étiquette est décrit sous la forme d’un tableau (balises *fo:table*). La première colonne contient le QRCode, la seconde le texte associé.
Ici, deux colonnes de taille identique (4 cm chacune) sont définies.

~~~
<fo:table table-layout="fixed" border-collapse="collapse"
border-style="none" width="8cm"
keep-together.within-page="always">
<fo:table-column column-width="4cm"/>
<fo:table-column column-width="4cm" />
<fo:table-body border-style="none" >
~~~

Les cellules (*table-cell*) sont insérées dans une ligne (*table-row*) :

~~~
<fo:table-row>
~~~

### Insertion du QRcode

Le QRcode est inséré dans un bloc. Les seules informations modifiables sont celles concernant la
hauteur (attribut height et la largeur (attribut content-width)). Veillez à ce que la hauteur et la largeur
soient identiques, et ne modifiez pas les autres informations.

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

### Contenu textuel

Les autres informations sont affichées dans des blocs, avec une ligne par catégorie d’information.
L’étiquette commence ici par indiquer l’établissement (ici, INRAE), écrit en gras.

~~~
<fo:table-cell>
<fo:block>
<fo:inline font-weight="bold">
INRAE
</fo:inline>
</fo:block>
~~~

Chaque information est affichée dans un bloc, comprenant un titre (par exemple, uid), associé à une ou plusieurs valeurs. Ainsi, la première ligne affiche sur la même ligne, et en gras (attribut font-weight= "bold"), le code de la base de données (*<xsl :value-of select="db"/>*) et l’UID de l’objet (*<xsl :value-of select="uid"/>*).

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

Si vous souhaitez modifier la taille des caractères, utilisez la balise :

~~~
<fo:inline font-size="8pt">texte</fo:inline>
<fo:inline font-size="8pt" font-weight="bold">texte en gras</fo:inline>
~~~

### Fin de l’étiquette

Une fois toutes les informations affichées, le tableau est fermé, et un saut de page est généré systématiquement :

~~~
</fo:table-cell>
</fo:table-row>
</fo:table-body>
</fo:table>
<fo:block page-break-after="always"/>
~~~

Enfin, le fichier XSL est correctement fermé :

~~~
</xsl:template>
</xsl:stylesheet>
~~~

Il est possible de créer des étiquettes avec des formats différents, par exemple en créant plusieurs
lignes. Pensez à fermer vos balises, et qu’elles soient correctement imbriquées, pour éviter tout souci.

Pour aller plus loin dans la mise en page, vous pouvez consulter la [documentation du projet FOP](https://xmlgraphics.apache.org/fop/fo.html), et pour le formatage du texte, [celle concernant XSL](https://www.w3.org/TR/xsl11).
