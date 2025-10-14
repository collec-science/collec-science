set search_path = col,gacl,public;
update col.metadata
set metadata_schema = regexp_replace(metadata_schema::varchar, 'N/A', '','ig')::json;
update col.metadata
set metadata_schema = regexp_replace(metadata_schema::varchar, 'N\\/A', '','ig')::json;
/*
 * create the label_optical content from label 
 */
 CREATE TABLE col.label_optical (
	label_optical_id serial NOT NULL,
	label_id integer NOT NULL,
	barcode_id integer NOT NULL,
	content_type smallint NOT NULL DEFAULT 1,
	radical varchar,
	optical_content varchar NOT NULL,
	CONSTRAINT label_optical_pk PRIMARY KEY (label_optical_id)
);
COMMENT ON COLUMN col.label_optical.content_type IS E'1: json\n2: identifier with or without radical';
COMMENT ON COLUMN col.label_optical.radical IS E'Radical in the optical code, as base of uri';
COMMENT ON COLUMN col.label_optical.optical_content IS E'Content of the optical code, as list of fields if type 1, used identifier if type 2 or 3';
ALTER TABLE col.label_optical OWNER TO collec;
ALTER TABLE col.label_optical ADD CONSTRAINT label_fk FOREIGN KEY (label_id)
REFERENCES col.label (label_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE col.label_optical ADD CONSTRAINT barcode_fk FOREIGN KEY (barcode_id)
REFERENCES col.barcode (barcode_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
insert into col.label_optical (label_id, barcode_id, content_type, optical_content)
select label_id, 
barcode_id, 
case when identifier_only is true then 2 else 1 end,
label_fields
from col.label
order by label_id;
ALTER TABLE col.label DROP CONSTRAINT IF EXISTS barcode_fk CASCADE;
alter table col.label drop column barcode_id;
alter table col.label drop column identifier_only;
alter table col.label drop column label_fields;
alter table col.label add column logo bytea;
comment on column col.label.logo is 'Logo added to the label';
insert into col.dbparam(dbparam_name, dbparam_value, dbparam_description, dbparam_description_en) 
values
('labelDebugMode', '0', 'Si à 1, les fichiers générés lors de la création des étiquettes ne sont pas supprimés'
, 'If set to 1, files generated when creating labels are not deleted'
);
INSERT INTO col.label (label_name, label_xsl, metadata_id) VALUES (E'Example', E'<?xml version="1.0" encoding="utf-8"?>\n<xsl:stylesheet version="1.0"\n	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"\n	xmlns:fo="http://www.w3.org/1999/XSL/Format">\n	<xsl:output method="xml" indent="yes"/>\n	<xsl:template match="objects">\n		<fo:root>\n			<fo:layout-master-set>\n				<fo:simple-page-master master-name="label"\n					  page-height="5cm" page-width="10cm" margin-left="0.5cm" margin-top="0.5cm" margin-bottom="0cm" margin-right="0.5cm">  \n					  <fo:region-body/>\n				</fo:simple-page-master>\n			</fo:layout-master-set>\n			<fo:page-sequence master-reference="label">\n				<fo:flow flow-name="xsl-region-body">        \n					<fo:block>\n						<xsl:apply-templates select="object" />\n					</fo:block>\n				</fo:flow>\n			</fo:page-sequence>\n		</fo:root>\n	</xsl:template>\n	<xsl:template match="object">\n		<fo:table table-layout="fixed" border-collapse="collapse"  border-style="none" width="9cm" keep-together.within-page="always">\n			<fo:table-column column-width="6cm"/>\n			<fo:table-column column-width="3cm" />\n			<fo:table-body border-style="none" >\n				<fo:table-row>\n					<fo:table-cell>\n						<fo:block>\n							<fo:external-graphic>\n								<xsl:attribute name="src">\n									<xsl:value-of select="concat(label_id,''-logo.png'')"/>\n								</xsl:attribute>\n								<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>\n									<xsl:attribute name="height">1cm</xsl:attribute>\n									<xsl:attribute name="content-width">1cm</xsl:attribute>\n									<xsl:attribute name="scaling">uniform</xsl:attribute>\n								</fo:external-graphic>\n								<fo:inline> Labo Collec-Science</fo:inline>\n						</fo:block>\n						<fo:block><fo:inline font-weight="bold"><xsl:value-of select="db"/>:<xsl:value-of select="uid"/></fo:inline></fo:block>\n						<fo:block>id:<fo:inline font-weight="bold"><xsl:value-of select="id"/></fo:inline></fo:block>\n					</fo:table-cell>\n					<fo:table-cell> \n						<fo:block>\n							<fo:external-graphic>\n								 <xsl:attribute name="src">\n										<xsl:value-of select="concat(uid,''.png'')" />\n								 </xsl:attribute>\n								<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>\n								<xsl:attribute name="height">2.5cm</xsl:attribute>\n								<xsl:attribute name="content-width">2.5cm</xsl:attribute>\n								<xsl:attribute name="scaling">uniform</xsl:attribute>     \n							</fo:external-graphic>\n						</fo:block>\n					</fo:table-cell>\n				</fo:table-row>\n		</fo:table-body>\n	</fo:table>\n	<fo:block text-align="center">\n		<fo:external-graphic>\n				 <xsl:attribute name="src">\n						<xsl:value-of select="concat(uid,''-2.png'')" />\n				 </xsl:attribute>\n				<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>\n				<xsl:attribute name="content-width">9cm</xsl:attribute>\n				<xsl:attribute name="height">1cm</xsl:attribute>\n				<xsl:attribute name="scaling">uniform</xsl:attribute>     \n			</fo:external-graphic>\n	</fo:block>\n	<fo:block text-align="center">\n		Risque:<fo:inline font-weight="bold"><xsl:value-of select="clp"/></fo:inline>\n	</fo:block>\n	   <fo:block page-break-after="always"/>\n	  </xsl:template>\n</xsl:stylesheet>\n', DEFAULT);
INSERT INTO col.label_optical (label_id, content_type, radical, optical_content, barcode_id) VALUES ((select max(label_id) from label), E'2', DEFAULT, E'uuid', E'1');
INSERT INTO col.label_optical (label_id, content_type, radical, optical_content, barcode_id) VALUES ((select max(label_id) from label), E'2', DEFAULT, E'uid', E'2');

INSERT INTO col.dbversion (dbversion_number, dbversion_date) VALUES (E'25.1', E'2025-11-1');
