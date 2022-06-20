-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler version: 0.9.4
-- PostgreSQL version: 9.6
-- Project Site: pgmodeler.io
-- Model Author: ---

-- object: col | type: SCHEMA --
-- DROP SCHEMA IF EXISTS col CASCADE;
CREATE SCHEMA col;
-- ddl-end --
ALTER SCHEMA col OWNER TO collec;
-- ddl-end --

-- object: gacl | type: SCHEMA --
-- DROP SCHEMA IF EXISTS gacl CASCADE;
CREATE SCHEMA gacl;
-- ddl-end --
ALTER SCHEMA gacl OWNER TO collec;
-- ddl-end --

SET search_path TO pg_catalog,public,col,gacl;
-- ddl-end --

-- object: col.booking_booking_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.booking_booking_id_seq CASCADE;
CREATE SEQUENCE col.booking_booking_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.booking_booking_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.booking | type: TABLE --
-- DROP TABLE IF EXISTS col.booking CASCADE;
CREATE TABLE col.booking (
	booking_id integer NOT NULL DEFAULT nextval('col.booking_booking_id_seq'::regclass),
	uid integer NOT NULL,
	booking_date timestamp NOT NULL,
	date_from timestamp NOT NULL,
	date_to timestamp NOT NULL,
	booking_comment character varying,
	booking_login character varying NOT NULL,
	CONSTRAINT booking_pk PRIMARY KEY (booking_id)
);
-- ddl-end --
COMMENT ON TABLE col.booking IS E'Table of object''s bookings';
-- ddl-end --
COMMENT ON COLUMN col.booking.booking_date IS E'Date of booking';
-- ddl-end --
COMMENT ON COLUMN col.booking.date_from IS E'Date-time of booking start';
-- ddl-end --
COMMENT ON COLUMN col.booking.date_to IS E'Date-time of booking end';
-- ddl-end --
COMMENT ON COLUMN col.booking.booking_comment IS E'Comment';
-- ddl-end --
COMMENT ON COLUMN col.booking.booking_login IS E'Login used to perform the reservation';
-- ddl-end --
ALTER TABLE col.booking OWNER TO collec;
-- ddl-end --

-- object: col.project_project_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.project_project_id_seq CASCADE;
CREATE SEQUENCE col.project_project_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.project_project_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.collection_group | type: TABLE --
-- DROP TABLE IF EXISTS col.collection_group CASCADE;
CREATE TABLE col.collection_group (
	collection_id integer NOT NULL,
	aclgroup_id integer NOT NULL,
	CONSTRAINT projet_group_pk PRIMARY KEY (collection_id,aclgroup_id)
);
-- ddl-end --
COMMENT ON TABLE col.collection_group IS E'Table of project approvals';
-- ddl-end --
ALTER TABLE col.collection_group OWNER TO collec;
-- ddl-end --

-- object: col.container_container_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.container_container_id_seq CASCADE;
CREATE SEQUENCE col.container_container_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.container_container_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.container | type: TABLE --
-- DROP TABLE IF EXISTS col.container CASCADE;
CREATE TABLE col.container (
	container_id integer NOT NULL DEFAULT nextval('col.container_container_id_seq'::regclass),
	uid integer NOT NULL,
	container_type_id integer NOT NULL,
	CONSTRAINT container_pk PRIMARY KEY (container_id)
);
-- ddl-end --
COMMENT ON TABLE col.container IS E'Liste of containers';
-- ddl-end --
ALTER TABLE col.container OWNER TO collec;
-- ddl-end --

-- object: col.container_family_container_family_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.container_family_container_family_id_seq CASCADE;
CREATE SEQUENCE col.container_family_container_family_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.container_family_container_family_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.container_family | type: TABLE --
-- DROP TABLE IF EXISTS col.container_family CASCADE;
CREATE TABLE col.container_family (
	container_family_id integer NOT NULL DEFAULT nextval('col.container_family_container_family_id_seq'::regclass),
	container_family_name character varying NOT NULL,
	CONSTRAINT container_family_pk PRIMARY KEY (container_family_id)
);
-- ddl-end --
COMMENT ON TABLE col.container_family IS E'General family of containers';
-- ddl-end --
ALTER TABLE col.container_family OWNER TO collec;
-- ddl-end --

INSERT INTO col.container_family (container_family_name) VALUES (E'Immobilier');
-- ddl-end --
INSERT INTO col.container_family (container_family_name) VALUES (E'Mobilier');
-- ddl-end --

-- object: col.container_type_container_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.container_type_container_type_id_seq CASCADE;
CREATE SEQUENCE col.container_type_container_type_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.container_type_container_type_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.container_type | type: TABLE --
-- DROP TABLE IF EXISTS col.container_type CASCADE;
CREATE TABLE col.container_type (
	container_type_id integer NOT NULL DEFAULT nextval('col.container_type_container_type_id_seq'::regclass),
	container_type_name character varying NOT NULL,
	container_family_id integer NOT NULL,
	clp_classification character varying,
	container_type_description character varying,
	storage_condition_id integer,
	storage_product character varying,
	label_id integer,
	columns integer NOT NULL DEFAULT 1,
	lines integer NOT NULL DEFAULT 1,
	first_line character varying NOT NULL DEFAULT 'T',
	nb_slots_max integer DEFAULT 0,
	first_column varchar DEFAULT 'L',
	line_in_char boolean NOT NULL DEFAULT false,
	column_in_char boolean NOT NULL DEFAULT false,
	CONSTRAINT container_type_pk PRIMARY KEY (container_type_id)
);
-- ddl-end --
COMMENT ON TABLE col.container_type IS E'Table of types of containers';
-- ddl-end --
COMMENT ON COLUMN col.container_type.clp_classification IS E'Risk classification according to the European CLP directive';
-- ddl-end --
COMMENT ON COLUMN col.container_type.container_type_description IS E'Long description';
-- ddl-end --
COMMENT ON COLUMN col.container_type.storage_product IS E'Product used for storage (formol, alcohol...)';
-- ddl-end --
COMMENT ON COLUMN col.container_type.columns IS E'Number of storage columns in the container';
-- ddl-end --
COMMENT ON COLUMN col.container_type.lines IS E'Number of storage lines in the container';
-- ddl-end --
COMMENT ON COLUMN col.container_type.first_line IS E'Place of the first line:\nT: top\nB: bottom';
-- ddl-end --
COMMENT ON COLUMN col.container_type.nb_slots_max IS E'Number maximum of slots in the container';
-- ddl-end --
COMMENT ON COLUMN col.container_type.first_column IS E'Place of the first column: \nL: left\nR: Right';
-- ddl-end --
COMMENT ON COLUMN col.container_type.line_in_char IS E'Is the number of the line is displayed in character?';
-- ddl-end --
COMMENT ON COLUMN col.container_type.column_in_char IS E'Is the number of the column is displayed in character?';
-- ddl-end --
ALTER TABLE col.container_type OWNER TO collec;
-- ddl-end --

INSERT INTO col.container_type (container_type_name, container_family_id) VALUES (E'Site', E'1');
-- ddl-end --
INSERT INTO col.container_type (container_type_name, container_family_id) VALUES (E'Batiment', E'1');
-- ddl-end --
INSERT INTO col.container_type (container_type_name, container_family_id) VALUES (E'Pièce', E'1');
-- ddl-end --
INSERT INTO col.container_type (container_type_name, container_family_id) VALUES (E'Armoire', E'2');
-- ddl-end --
INSERT INTO col.container_type (container_type_name, container_family_id) VALUES (E'Congélateur', E'2');
-- ddl-end --

-- object: col.dbparam | type: TABLE --
-- DROP TABLE IF EXISTS col.dbparam CASCADE;
CREATE TABLE col.dbparam (
	dbparam_id serial NOT NULL,
	dbparam_name character varying NOT NULL,
	dbparam_value character varying,
	CONSTRAINT dbparam_pk PRIMARY KEY (dbparam_id)
);
-- ddl-end --
COMMENT ON TABLE col.dbparam IS E'Table of parameters intrinsically associated to the instance';
-- ddl-end --
COMMENT ON COLUMN col.dbparam.dbparam_name IS E'Name of the parameter';
-- ddl-end --
COMMENT ON COLUMN col.dbparam.dbparam_value IS E'Value of the parameter';
-- ddl-end --
ALTER TABLE col.dbparam OWNER TO collec;
-- ddl-end --

INSERT INTO col.dbparam (dbparam_name, dbparam_value) VALUES (E'APPLI_code', E'cs_code');
-- ddl-end --
INSERT INTO col.dbparam (dbparam_name, dbparam_value) VALUES (E'APPLI_title', E'Collec-Science - instance for ');
-- ddl-end --
INSERT INTO col.dbparam (dbparam_name, dbparam_value) VALUES (E'mapDefaultX', E'-0.70');
-- ddl-end --
INSERT INTO col.dbparam (dbparam_name, dbparam_value) VALUES (E'mapDefaultY', E'44.77');
-- ddl-end --
INSERT INTO col.dbparam (dbparam_name, dbparam_value) VALUES (E'mapDefaultZoom', E'7');
-- ddl-end --
INSERT INTO col.dbparam (dbparam_name, dbparam_value) VALUES (E'otp_issuer', E'collec-science');
-- ddl-end --

-- object: col.dbversion_dbversion_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.dbversion_dbversion_id_seq CASCADE;
CREATE SEQUENCE col.dbversion_dbversion_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.dbversion_dbversion_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.dbversion | type: TABLE --
-- DROP TABLE IF EXISTS col.dbversion CASCADE;
CREATE TABLE col.dbversion (
	dbversion_id integer NOT NULL DEFAULT nextval('col.dbversion_dbversion_id_seq'::regclass),
	dbversion_number character varying NOT NULL,
	dbversion_date timestamp NOT NULL,
	CONSTRAINT dbversion_pk PRIMARY KEY (dbversion_id)
);
-- ddl-end --
COMMENT ON TABLE col.dbversion IS E'Table of the database versions';
-- ddl-end --
COMMENT ON COLUMN col.dbversion.dbversion_number IS E'Number of the version';
-- ddl-end --
COMMENT ON COLUMN col.dbversion.dbversion_date IS E'Date of the version';
-- ddl-end --
ALTER TABLE col.dbversion OWNER TO collec;
-- ddl-end --

INSERT INTO col.dbversion (dbversion_number, dbversion_date) VALUES (E'2.6', E'2021-04-16');
-- ddl-end --

-- object: col.document_document_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.document_document_id_seq CASCADE;
CREATE SEQUENCE col.document_document_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.document_document_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.document | type: TABLE --
-- DROP TABLE IF EXISTS col.document CASCADE;
CREATE TABLE col.document (
	document_id integer NOT NULL DEFAULT nextval('col.document_document_id_seq'::regclass),
	uid integer,
	mime_type_id integer NOT NULL,
	document_import_date timestamp NOT NULL,
	document_name character varying NOT NULL,
	document_description character varying,
	data bytea,
	thumbnail bytea,
	size integer,
	document_creation_date timestamp,
	uuid uuid NOT NULL DEFAULT gen_random_uuid(),
	external_storage boolean NOT NULL DEFAULT false,
	external_storage_path varchar,
	campaign_id integer,
	CONSTRAINT document_pk PRIMARY KEY (document_id)
);
-- ddl-end --
COMMENT ON TABLE col.document IS E'Numeric docs associated to an objet or a campaign';
-- ddl-end --
COMMENT ON COLUMN col.document.document_import_date IS E'Import date into the database';
-- ddl-end --
COMMENT ON COLUMN col.document.document_name IS E'Original name';
-- ddl-end --
COMMENT ON COLUMN col.document.document_description IS E'Description';
-- ddl-end --
COMMENT ON COLUMN col.document.data IS E'Binary content (object imported)';
-- ddl-end --
COMMENT ON COLUMN col.document.thumbnail IS E'Thumbnail in PNG format ( only for pdf, jpg or png docs)';
-- ddl-end --
COMMENT ON COLUMN col.document.size IS E'Size of downloaded file';
-- ddl-end --
COMMENT ON COLUMN col.document.document_creation_date IS E'Create date of the document (date of photo shooting, for example)';
-- ddl-end --
COMMENT ON COLUMN col.document.external_storage IS E'Is the document stored in the external storage?';
-- ddl-end --
COMMENT ON COLUMN col.document.external_storage_path IS E'Path to the file, relative to the root of the external storage';
-- ddl-end --
ALTER TABLE col.document OWNER TO collec;
-- ddl-end --

-- object: col.event_event_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.event_event_id_seq CASCADE;
CREATE SEQUENCE col.event_event_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.event_event_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.event | type: TABLE --
-- DROP TABLE IF EXISTS col.event CASCADE;
CREATE TABLE col.event (
	event_id integer NOT NULL DEFAULT nextval('col.event_event_id_seq'::regclass),
	uid integer NOT NULL,
	event_date timestamp NOT NULL,
	event_type_id integer NOT NULL,
	still_available character varying,
	event_comment character varying,
	CONSTRAINT event_pk PRIMARY KEY (event_id)
);
-- ddl-end --
COMMENT ON TABLE col.event IS E'Table of events';
-- ddl-end --
COMMENT ON COLUMN col.event.event_date IS E'Date-time of the event';
-- ddl-end --
COMMENT ON COLUMN col.event.still_available IS E'still available content in the object, after the event';
-- ddl-end --
COMMENT ON COLUMN col.event.event_comment IS E'Comment';
-- ddl-end --
ALTER TABLE col.event OWNER TO collec;
-- ddl-end --

-- object: col.event_type_event_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.event_type_event_type_id_seq CASCADE;
CREATE SEQUENCE col.event_type_event_type_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.event_type_event_type_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.event_type | type: TABLE --
-- DROP TABLE IF EXISTS col.event_type CASCADE;
CREATE TABLE col.event_type (
	event_type_id integer NOT NULL DEFAULT nextval('col.event_type_event_type_id_seq'::regclass),
	event_type_name character varying NOT NULL,
	is_sample boolean NOT NULL DEFAULT false,
	is_container boolean NOT NULL DEFAULT false,
	CONSTRAINT event_type_pk PRIMARY KEY (event_type_id)
);
-- ddl-end --
COMMENT ON TABLE col.event_type IS E'Event types table';
-- ddl-end --
COMMENT ON COLUMN col.event_type.event_type_name IS E'Name of the type of event';
-- ddl-end --
COMMENT ON COLUMN col.event_type.is_sample IS E'The event is applicable to the samples';
-- ddl-end --
COMMENT ON COLUMN col.event_type.is_container IS E'The event is applicable to the containers';
-- ddl-end --
ALTER TABLE col.event_type OWNER TO collec;
-- ddl-end --

INSERT INTO col.event_type (event_type_name, is_sample, is_container) VALUES (E'Autre', E'true', E'true');
-- ddl-end --
INSERT INTO col.event_type (event_type_name, is_sample, is_container) VALUES (E'Conteneur cassé', E'false', E'true');
-- ddl-end --
INSERT INTO col.event_type (event_type_name, is_sample, is_container) VALUES (E'Échantillon détruit', E'true', E'false');
-- ddl-end --
INSERT INTO col.event_type (event_type_name, is_sample, is_container) VALUES (E'Prélèvement pour analyse', E'true', E'false');
-- ddl-end --
INSERT INTO col.event_type (event_type_name, is_sample, is_container) VALUES (E'Échantillon totalement analysé, détruit', E'true', E'false');
-- ddl-end --

-- object: col.identifier_type_identifier_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.identifier_type_identifier_type_id_seq CASCADE;
CREATE SEQUENCE col.identifier_type_identifier_type_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.identifier_type_identifier_type_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.identifier_type | type: TABLE --
-- DROP TABLE IF EXISTS col.identifier_type CASCADE;
CREATE TABLE col.identifier_type (
	identifier_type_id integer NOT NULL DEFAULT nextval('col.identifier_type_identifier_type_id_seq'::regclass),
	identifier_type_name character varying NOT NULL,
	identifier_type_code character varying,
	used_for_search boolean NOT NULL DEFAULT false,
	CONSTRAINT identifier_type_pk PRIMARY KEY (identifier_type_id)
);
-- ddl-end --
COMMENT ON TABLE col.identifier_type IS E'Table of identifier types';
-- ddl-end --
COMMENT ON COLUMN col.identifier_type.identifier_type_name IS E'Textual name of the identifier';
-- ddl-end --
COMMENT ON COLUMN col.identifier_type.identifier_type_code IS E'Identifier code, used in the labels';
-- ddl-end --
COMMENT ON COLUMN col.identifier_type.used_for_search IS E'Is the identifier usable for barcode searches?';
-- ddl-end --
ALTER TABLE col.identifier_type OWNER TO collec;
-- ddl-end --

-- object: col.label_label_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.label_label_id_seq CASCADE;
CREATE SEQUENCE col.label_label_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.label_label_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.label | type: TABLE --
-- DROP TABLE IF EXISTS col.label CASCADE;
CREATE TABLE col.label (
	label_id integer NOT NULL DEFAULT nextval('col.label_label_id_seq'::regclass),
	label_name character varying NOT NULL,
	label_xsl character varying NOT NULL,
	label_fields character varying NOT NULL DEFAULT 'uid,id,clp,db',
	metadata_id integer,
	identifier_only boolean NOT NULL DEFAULT false,
	barcode_id integer NOT NULL,
	CONSTRAINT label_pk PRIMARY KEY (label_id)
);
-- ddl-end --
COMMENT ON TABLE col.label IS E'Table of label models';
-- ddl-end --
COMMENT ON COLUMN col.label.label_name IS E'Name of the model';
-- ddl-end --
COMMENT ON COLUMN col.label.label_xsl IS E'XSL content used by FOP transformation (https://xmlgraphics.apache.org/fop/)';
-- ddl-end --
COMMENT ON COLUMN col.label.label_fields IS E'List of fields incorporated in the QRCODE';
-- ddl-end --
COMMENT ON COLUMN col.label.metadata_id IS E'Model of the metadata template associated with this label';
-- ddl-end --
COMMENT ON COLUMN col.label.identifier_only IS E'true: the qrcode contains only a business identifier';
-- ddl-end --
ALTER TABLE col.label OWNER TO collec;
-- ddl-end --

INSERT INTO col.label (label_name, barcode_id, label_xsl, label_fields) VALUES (E'Example - Don''t use', E'1', E'<xsl:stylesheet version="1.0"\n      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"\n      xmlns:fo="http://www.w3.org/1999/XSL/Format">\n  <xsl:output method="xml" indent="yes"/>\n  <xsl:template match="objects">\n    <fo:root>\n      <fo:layout-master-set>\n        <fo:simple-page-master master-name="label"\n              page-height="5cm" page-width="10cm" margin-left="0.5cm" margin-top="0.5cm" margin-bottom="0cm" margin-right="0.5cm">  \n              <fo:region-body/>\n        </fo:simple-page-master>\n      </fo:layout-master-set>\n      \n      <fo:page-sequence master-reference="label">\n         <fo:flow flow-name="xsl-region-body">        \n          <fo:block>\n          <xsl:apply-templates select="object" />\n          </fo:block>\n\n        </fo:flow>\n      </fo:page-sequence>\n    </fo:root>\n   </xsl:template>\n  <xsl:template match="object">\n\n  <fo:table table-layout="fixed" border-collapse="collapse"  border-style="none" width="8cm&quot; keep-together.within-page=&quot;always">\n  <fo:table-column column-width="4cm"/>\n  <fo:table-column column-width="4cm" />\n <fo:table-body  border-style="none" >\n 	<fo:table-row>\n  		<fo:table-cell> \n  		<fo:block>\n  		<fo:external-graphic>\n      <xsl:attribute name="src">\n             <xsl:value-of select="concat(uid,''.png'')" />\n       </xsl:attribute>\n       <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>\n       <xsl:attribute name="height">4cm</xsl:attribute>\n        <xsl:attribute name="content-width">4cm</xsl:attribute>\n        <xsl:attribute name="scaling">uniform</xsl:attribute>\n      \n       </fo:external-graphic>\n 		</fo:block>\n   		</fo:table-cell>\n  		<fo:table-cell>\n<fo:block><fo:inline font-weight="bold">IRSTEA</fo:inline></fo:block>\n  			<fo:block>uid:<fo:inline font-weight="bold&quot;&gt;&lt;xsl:value-of select=&quot;db&quot;/&gt;:&lt;xsl:value-of select=&quot;uid"/></fo:inline></fo:block>\n  			<fo:block>id:<fo:inline font-weight="bold&quot;&gt;&lt;xsl:value-of select=&quot;id"/></fo:inline></fo:block>\n  			<fo:block>prj:<fo:inline font-weight="bold&quot;&gt;&lt;xsl:value-of select=&quot;prj"/></fo:inline></fo:block>\n  			<fo:block>clp:<fo:inline font-weight="bold&quot;&gt;&lt;xsl:value-of select=&quot;clp"/></fo:inline></fo:block>\n  		</fo:table-cell>\n  	  	</fo:table-row>\n  </fo:table-body>\n  </fo:table>\n   <fo:block page-break-after="always"/>\n\n  </xsl:template>\n</xsl:stylesheet>', E'uid,id,clp,db,col');
-- ddl-end --

-- object: col.storage_storage_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.storage_storage_id_seq CASCADE;
CREATE SEQUENCE col.storage_storage_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.storage_storage_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.last_photo | type: VIEW --
-- DROP VIEW IF EXISTS col.last_photo CASCADE;
CREATE VIEW col.last_photo
AS

SELECT d.document_id,
    d.uid
   FROM col.document d
  WHERE (d.document_id = ( SELECT d1.document_id
           FROM col.document d1
          WHERE ((d1.mime_type_id = ANY (ARRAY[4, 5, 6])) AND (d.uid = d1.uid))
          ORDER BY d1.document_creation_date DESC, d1.document_import_date DESC, d1.document_id DESC
         LIMIT 1));
-- ddl-end --
ALTER VIEW col.last_photo OWNER TO collec;
-- ddl-end --

-- object: col.metadata_metadata_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.metadata_metadata_id_seq CASCADE;
CREATE SEQUENCE col.metadata_metadata_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.metadata_metadata_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.metadata | type: TABLE --
-- DROP TABLE IF EXISTS col.metadata CASCADE;
CREATE TABLE col.metadata (
	metadata_id integer NOT NULL DEFAULT nextval('col.metadata_metadata_id_seq'::regclass),
	metadata_name character varying NOT NULL,
	metadata_schema json,
	CONSTRAINT metadata_pk PRIMARY KEY (metadata_id)
);
-- ddl-end --
COMMENT ON TABLE col.metadata IS E'Table of metadata usable with types of samples';
-- ddl-end --
COMMENT ON COLUMN col.metadata.metadata_name IS E'Name of the metadata set';
-- ddl-end --
COMMENT ON COLUMN col.metadata.metadata_schema IS E'JSON schema of the metadata form';
-- ddl-end --
ALTER TABLE col.metadata OWNER TO collec;
-- ddl-end --

-- object: col.mime_type_mime_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.mime_type_mime_type_id_seq CASCADE;
CREATE SEQUENCE col.mime_type_mime_type_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.mime_type_mime_type_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.mime_type | type: TABLE --
-- DROP TABLE IF EXISTS col.mime_type CASCADE;
CREATE TABLE col.mime_type (
	mime_type_id integer NOT NULL DEFAULT nextval('col.mime_type_mime_type_id_seq'::regclass),
	extension character varying NOT NULL,
	content_type character varying NOT NULL,
	CONSTRAINT mime_type_pk PRIMARY KEY (mime_type_id)
);
-- ddl-end --
COMMENT ON TABLE col.mime_type IS E'Mime types of imported files';
-- ddl-end --
COMMENT ON COLUMN col.mime_type.extension IS E'File extension';
-- ddl-end --
COMMENT ON COLUMN col.mime_type.content_type IS E'Official mime type';
-- ddl-end --
ALTER TABLE col.mime_type OWNER TO collec;
-- ddl-end --

INSERT INTO col.mime_type (extension, content_type) VALUES (E'pdf', E'application/pdf');
-- ddl-end --
INSERT INTO col.mime_type (extension, content_type) VALUES (E'zip', E'application/zip');
-- ddl-end --
INSERT INTO col.mime_type (extension, content_type) VALUES (E'mp3', E'audio/mpeg');
-- ddl-end --
INSERT INTO col.mime_type (extension, content_type) VALUES (E'jpg', E'image/jpeg');
-- ddl-end --
INSERT INTO col.mime_type (extension, content_type) VALUES (E'jpeg', E'image/jpeg');
-- ddl-end --
INSERT INTO col.mime_type (extension, content_type) VALUES (E'png', E'image/png');
-- ddl-end --
INSERT INTO col.mime_type (extension, content_type) VALUES (E'tiff', E'image/tiff');
-- ddl-end --
INSERT INTO col.mime_type (extension, content_type) VALUES (E'csv', E'text/csv');
-- ddl-end --
INSERT INTO col.mime_type (extension, content_type) VALUES (E'odt', E'application/vnd.oasis.opendocument.text');
-- ddl-end --
INSERT INTO col.mime_type (extension, content_type) VALUES (E'ods', E'application/vnd.oasis.opendocument.spreadsheet');
-- ddl-end --
INSERT INTO col.mime_type (extension, content_type) VALUES (E'xls', E'application/vnd.ms-excel');
-- ddl-end --
INSERT INTO col.mime_type (extension, content_type) VALUES (E'xlsx', E'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
-- ddl-end --
INSERT INTO col.mime_type (extension, content_type) VALUES (E'doc', E'application/msword');
-- ddl-end --
INSERT INTO col.mime_type (extension, content_type) VALUES (E'docx', E'application/vnd.openxmlformats-officedocument.wordprocessingml.document');
-- ddl-end --
INSERT INTO col.mime_type (extension, content_type) VALUES (E'ab1', E'application/octet-stream');
-- ddl-end --
INSERT INTO col.mime_type (extension, content_type) VALUES (E'seq', E'application/octet-stream');
-- ddl-end --
INSERT INTO col.mime_type (extension, content_type) VALUES (E'fa', E'application/octet-stream');
-- ddl-end --
INSERT INTO col.mime_type (extension, content_type) VALUES (E'fsa', E'application/octet-stream');
-- ddl-end --
INSERT INTO col.mime_type (extension, content_type) VALUES (E'xml', E'application/xml');
-- ddl-end --

-- object: col.storage_reason_storage_reason_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.storage_reason_storage_reason_id_seq CASCADE;
CREATE SEQUENCE col.storage_reason_storage_reason_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.storage_reason_storage_reason_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.movement_type_movement_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.movement_type_movement_type_id_seq CASCADE;
CREATE SEQUENCE col.movement_type_movement_type_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.movement_type_movement_type_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.movement_type | type: TABLE --
-- DROP TABLE IF EXISTS col.movement_type CASCADE;
CREATE TABLE col.movement_type (
	movement_type_id integer NOT NULL DEFAULT nextval('col.movement_type_movement_type_id_seq'::regclass),
	movement_type_name character varying NOT NULL,
	CONSTRAINT movement_type_pk PRIMARY KEY (movement_type_id)
);
-- ddl-end --
COMMENT ON TABLE col.movement_type IS E'Type de mouvement';
-- ddl-end --
ALTER TABLE col.movement_type OWNER TO collec;
-- ddl-end --

INSERT INTO col.movement_type (movement_type_id, movement_type_name) VALUES (E'1', E'Entrée/Entry');
-- ddl-end --
INSERT INTO col.movement_type (movement_type_id, movement_type_name) VALUES (E'2', E'Sortie/Exit');
-- ddl-end --

-- object: col.multiple_type_multiple_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.multiple_type_multiple_type_id_seq CASCADE;
CREATE SEQUENCE col.multiple_type_multiple_type_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.multiple_type_multiple_type_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.multiple_type | type: TABLE --
-- DROP TABLE IF EXISTS col.multiple_type CASCADE;
CREATE TABLE col.multiple_type (
	multiple_type_id integer NOT NULL DEFAULT nextval('col.multiple_type_multiple_type_id_seq'::regclass),
	multiple_type_name character varying NOT NULL,
	CONSTRAINT multiple_type_pk PRIMARY KEY (multiple_type_id)
);
-- ddl-end --
COMMENT ON TABLE col.multiple_type IS E'Table of categories of potential sub-sampling (unit, quantity, percentage, etc.)';
-- ddl-end --
ALTER TABLE col.multiple_type OWNER TO collec;
-- ddl-end --

INSERT INTO col.multiple_type (multiple_type_name) VALUES (E'Unité');
-- ddl-end --
INSERT INTO col.multiple_type (multiple_type_name) VALUES (E'Pourcentage');
-- ddl-end --
INSERT INTO col.multiple_type (multiple_type_name) VALUES (E'Quantité ou volume');
-- ddl-end --
INSERT INTO col.multiple_type (multiple_type_name) VALUES (E'Autre');
-- ddl-end --

-- object: col.object_uid_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.object_uid_seq CASCADE;
CREATE SEQUENCE col.object_uid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.object_uid_seq OWNER TO collec;
-- ddl-end --

-- object: col.object_identifier_object_identifier_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.object_identifier_object_identifier_id_seq CASCADE;
CREATE SEQUENCE col.object_identifier_object_identifier_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.object_identifier_object_identifier_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.object_identifier | type: TABLE --
-- DROP TABLE IF EXISTS col.object_identifier CASCADE;
CREATE TABLE col.object_identifier (
	object_identifier_id integer NOT NULL DEFAULT nextval('col.object_identifier_object_identifier_id_seq'::regclass),
	uid integer NOT NULL,
	identifier_type_id integer NOT NULL,
	object_identifier_value character varying NOT NULL,
	CONSTRAINT object_identifier_pk PRIMARY KEY (object_identifier_id)
);
-- ddl-end --
COMMENT ON TABLE col.object_identifier IS E'Table of complementary identifiers';
-- ddl-end --
COMMENT ON COLUMN col.object_identifier.object_identifier_value IS E'Identifier value';
-- ddl-end --
ALTER TABLE col.object_identifier OWNER TO collec;
-- ddl-end --

-- object: col.object_status_object_status_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.object_status_object_status_id_seq CASCADE;
CREATE SEQUENCE col.object_status_object_status_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 7
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.object_status_object_status_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.object_status | type: TABLE --
-- DROP TABLE IF EXISTS col.object_status CASCADE;
CREATE TABLE col.object_status (
	object_status_id integer NOT NULL DEFAULT nextval('col.object_status_object_status_id_seq'::regclass),
	object_status_name character varying NOT NULL,
	CONSTRAINT object_status_pk PRIMARY KEY (object_status_id)
);
-- ddl-end --
COMMENT ON TABLE col.object_status IS E'Table of types of status';
-- ddl-end --
ALTER TABLE col.object_status OWNER TO collec;
-- ddl-end --

INSERT INTO col.object_status (object_status_id, object_status_name) VALUES (E'1', E'État normal');
-- ddl-end --
INSERT INTO col.object_status (object_status_id, object_status_name) VALUES (E'2', E'Objet pré-réservé pour usage ultérieur');
-- ddl-end --
INSERT INTO col.object_status (object_status_id, object_status_name) VALUES (E'4', E'Echantillon vidé de tout contenu');
-- ddl-end --
INSERT INTO col.object_status (object_status_id, object_status_name) VALUES (E'5', E'Container plein');
-- ddl-end --
INSERT INTO col.object_status (object_status_id, object_status_name) VALUES (E'3', E'Objet détruit');
-- ddl-end --
INSERT INTO col.object_status (object_status_id, object_status_name) VALUES (E'6', E'Objet prêté');
-- ddl-end --

-- object: col.operation_operation_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.operation_operation_id_seq CASCADE;
CREATE SEQUENCE col.operation_operation_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.operation_operation_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.operation | type: TABLE --
-- DROP TABLE IF EXISTS col.operation CASCADE;
CREATE TABLE col.operation (
	operation_id integer NOT NULL DEFAULT nextval('col.operation_operation_id_seq'::regclass),
	protocol_id integer NOT NULL,
	operation_name character varying NOT NULL,
	operation_order integer,
	operation_version character varying,
	last_edit_date timestamp,
	CONSTRAINT operation_name_version_unique UNIQUE (operation_name,operation_version),
	CONSTRAINT operation_pk PRIMARY KEY (operation_id)
);
-- ddl-end --
COMMENT ON TABLE col.operation IS E'List of operations attached to a protocol';
-- ddl-end --
COMMENT ON COLUMN col.operation.operation_order IS E'Order to perform the operation in the protocol';
-- ddl-end --
COMMENT ON COLUMN col.operation.operation_version IS E'Version of the operation';
-- ddl-end --
COMMENT ON COLUMN col.operation.last_edit_date IS E'Last edit date of the operation';
-- ddl-end --
ALTER TABLE col.operation OWNER TO collec;
-- ddl-end --

-- object: col.printer_printer_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.printer_printer_id_seq CASCADE;
CREATE SEQUENCE col.printer_printer_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.printer_printer_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.printer | type: TABLE --
-- DROP TABLE IF EXISTS col.printer CASCADE;
CREATE TABLE col.printer (
	printer_id integer NOT NULL DEFAULT nextval('col.printer_printer_id_seq'::regclass),
	printer_name character varying NOT NULL,
	printer_queue character varying NOT NULL,
	printer_server character varying,
	printer_user character varying,
	printer_comment character varying,
	CONSTRAINT printer_pk PRIMARY KEY (printer_id)
);
-- ddl-end --
COMMENT ON TABLE col.printer IS E'Table of printers directly managed by the server';
-- ddl-end --
COMMENT ON COLUMN col.printer.printer_name IS E'Usual name of the printer, displayed in the forms';
-- ddl-end --
COMMENT ON COLUMN col.printer.printer_queue IS E'Name of the printer known by the operating system of the server';
-- ddl-end --
COMMENT ON COLUMN col.printer.printer_server IS E'Server address, if the printer is not connected at the localhost';
-- ddl-end --
COMMENT ON COLUMN col.printer.printer_user IS E'User used to print, if necessary';
-- ddl-end --
COMMENT ON COLUMN col.printer.printer_comment IS E'Comment';
-- ddl-end --
ALTER TABLE col.printer OWNER TO collec;
-- ddl-end --

-- object: col.collection | type: TABLE --
-- DROP TABLE IF EXISTS col.collection CASCADE;
CREATE TABLE col.collection (
	collection_id integer NOT NULL DEFAULT nextval('col.project_project_id_seq'::regclass),
	collection_name character varying NOT NULL,
	referent_id integer,
	allowed_import_flow boolean DEFAULT 'f',
	allowed_export_flow boolean DEFAULT 'f',
	public_collection boolean DEFAULT 'f',
	collection_keywords varchar,
	collection_displayname varchar,
	no_localization boolean NOT NULL DEFAULT false,
	external_storage_enabled boolean NOT NULL DEFAULT false,
	external_storage_root varchar,
	license_id integer,
	CONSTRAINT project_pk PRIMARY KEY (collection_id)
);
-- ddl-end --
COMMENT ON TABLE col.collection IS E'List of all collections into the database';
-- ddl-end --
COMMENT ON COLUMN col.collection.allowed_import_flow IS E'Allow an external source to update a collection';
-- ddl-end --
COMMENT ON COLUMN col.collection.allowed_export_flow IS E'Allow interrogation requests from external sources';
-- ddl-end --
COMMENT ON COLUMN col.collection.public_collection IS E'Set if a collection can be requested without authentication';
-- ddl-end --
COMMENT ON COLUMN col.collection.collection_keywords IS E'List of keywords, separed by a comma';
-- ddl-end --
COMMENT ON COLUMN col.collection.collection_displayname IS E'Name used to communicate from the collection, in export module by example';
-- ddl-end --
COMMENT ON COLUMN col.collection.no_localization IS E'True if the localization of samples is not used';
-- ddl-end --
COMMENT ON COLUMN col.collection.external_storage_enabled IS E'Enable the storage of sample''s documents out of the database';
-- ddl-end --
COMMENT ON COLUMN col.collection.external_storage_root IS E'Root path of the documents stored out of the database';
-- ddl-end --
ALTER TABLE col.collection OWNER TO collec;
-- ddl-end --

-- object: col.protocol_protocol_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.protocol_protocol_id_seq CASCADE;
CREATE SEQUENCE col.protocol_protocol_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.protocol_protocol_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.protocol | type: TABLE --
-- DROP TABLE IF EXISTS col.protocol CASCADE;
CREATE TABLE col.protocol (
	protocol_id integer NOT NULL DEFAULT nextval('col.protocol_protocol_id_seq'::regclass),
	protocol_name character varying NOT NULL,
	protocol_file bytea,
	protocol_year smallint,
	protocol_version character varying NOT NULL DEFAULT 'v1.0',
	collection_id integer,
	authorization_number character varying,
	authorization_date timestamp,
	CONSTRAINT protocol_pk PRIMARY KEY (protocol_id)
);
-- ddl-end --
COMMENT ON TABLE col.protocol IS E'List of protocols';
-- ddl-end --
COMMENT ON COLUMN col.protocol.protocol_name IS E'Name of the protocol';
-- ddl-end --
COMMENT ON COLUMN col.protocol.protocol_file IS E'PDF description of the protocol';
-- ddl-end --
COMMENT ON COLUMN col.protocol.protocol_year IS E'Year of the protocol';
-- ddl-end --
COMMENT ON COLUMN col.protocol.protocol_version IS E'Version of the protocol';
-- ddl-end --
COMMENT ON COLUMN col.protocol.authorization_number IS E'Number of the prelevement authorization';
-- ddl-end --
COMMENT ON COLUMN col.protocol.authorization_date IS E'Date of the prelevement authorization';
-- ddl-end --
ALTER TABLE col.protocol OWNER TO collec;
-- ddl-end --

-- object: col.referent_referent_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.referent_referent_id_seq CASCADE;
CREATE SEQUENCE col.referent_referent_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.referent_referent_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.referent | type: TABLE --
-- DROP TABLE IF EXISTS col.referent CASCADE;
CREATE TABLE col.referent (
	referent_id integer NOT NULL DEFAULT nextval('col.referent_referent_id_seq'::regclass),
	referent_name character varying NOT NULL,
	referent_email character varying,
	address_name character varying,
	address_line2 character varying,
	address_line3 character varying,
	address_city character varying,
	address_country character varying,
	referent_phone character varying,
	referent_firstname varchar,
	academical_directory varchar,
	academical_link varchar,
	referent_organization varchar,
	CONSTRAINT referent_pk PRIMARY KEY (referent_id)
);
-- ddl-end --
COMMENT ON TABLE col.referent IS E'Table of sample referents';
-- ddl-end --
COMMENT ON COLUMN col.referent.referent_name IS E'Name, firstname-lastname or department name';
-- ddl-end --
COMMENT ON COLUMN col.referent.referent_email IS E'Email for contact';
-- ddl-end --
COMMENT ON COLUMN col.referent.address_name IS E'Name for postal address';
-- ddl-end --
COMMENT ON COLUMN col.referent.address_line2 IS E'second line in postal address';
-- ddl-end --
COMMENT ON COLUMN col.referent.address_line3 IS E'third line in postal address';
-- ddl-end --
COMMENT ON COLUMN col.referent.address_city IS E'ZIPCode and City in postal address';
-- ddl-end --
COMMENT ON COLUMN col.referent.address_country IS E'Country in postal address';
-- ddl-end --
COMMENT ON COLUMN col.referent.referent_phone IS E'Contact phone';
-- ddl-end --
COMMENT ON COLUMN col.referent.referent_firstname IS E'Firstname of the referent';
-- ddl-end --
COMMENT ON COLUMN col.referent.academical_directory IS E'Academical directory used to identifier the referent, as https://orcid.org or https://www.researchgate.net';
-- ddl-end --
COMMENT ON COLUMN col.referent.academical_link IS E'Link used to identify the referent, as https://orcid.org/0000-0003-4207-4107';
-- ddl-end --
COMMENT ON COLUMN col.referent.referent_organization IS E'Referent''s organization';
-- ddl-end --
ALTER TABLE col.referent OWNER TO collec;
-- ddl-end --

-- object: col.sample_sample_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.sample_sample_id_seq CASCADE;
CREATE SEQUENCE col.sample_sample_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.sample_sample_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.sample | type: TABLE --
-- DROP TABLE IF EXISTS col.sample CASCADE;
CREATE TABLE col.sample (
	sample_id integer NOT NULL DEFAULT nextval('col.sample_sample_id_seq'::regclass),
	uid integer NOT NULL,
	collection_id integer NOT NULL,
	sample_type_id integer NOT NULL,
	sample_creation_date timestamp NOT NULL,
	sampling_date timestamp,
	parent_sample_id integer,
	multiple_value double precision,
	sampling_place_id integer,
	dbuid_origin character varying,
	metadata json,
	expiration_date timestamp,
	campaign_id integer,
	country_id integer,
	country_origin_id integer,
	CONSTRAINT sample_pk PRIMARY KEY (sample_id)
);
-- ddl-end --
COMMENT ON TABLE col.sample IS E'Table of samples';
-- ddl-end --
COMMENT ON COLUMN col.sample.sample_creation_date IS E'Creation date of the record in the database';
-- ddl-end --
COMMENT ON COLUMN col.sample.sampling_date IS E'Creation date of the physical sample or date of sampling';
-- ddl-end --
COMMENT ON COLUMN col.sample.dbuid_origin IS E'Reference used in the original database, under the form db:uid. Used for read the labels created in others instances';
-- ddl-end --
COMMENT ON COLUMN col.sample.metadata IS E'Metadata associated with the sample, in JSON format';
-- ddl-end --
COMMENT ON COLUMN col.sample.expiration_date IS E'Date of expiration of the sample. After this date, the sample is not usable';
-- ddl-end --
ALTER TABLE col.sample OWNER TO collec;
-- ddl-end --

-- object: col.sample_type_sample_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.sample_type_sample_type_id_seq CASCADE;
CREATE SEQUENCE col.sample_type_sample_type_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.sample_type_sample_type_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.sample_type | type: TABLE --
-- DROP TABLE IF EXISTS col.sample_type CASCADE;
CREATE TABLE col.sample_type (
	sample_type_id integer NOT NULL DEFAULT nextval('col.sample_type_sample_type_id_seq'::regclass),
	sample_type_name character varying NOT NULL,
	container_type_id integer,
	multiple_type_id integer,
	multiple_unit character varying,
	metadata_id integer,
	operation_id integer,
	identifier_generator_js character varying,
	sample_type_description varchar,
	CONSTRAINT sample_type_pk PRIMARY KEY (sample_type_id)
);
-- ddl-end --
COMMENT ON TABLE col.sample_type IS E'Table of the types of samples';
-- ddl-end --
COMMENT ON COLUMN col.sample_type.sample_type_name IS E'Name of the type';
-- ddl-end --
COMMENT ON COLUMN col.sample_type.multiple_unit IS E'Name of the unit used  to qualify the number of sub-samples (ml, number, g, etc.)';
-- ddl-end --
COMMENT ON COLUMN col.sample_type.identifier_generator_js IS E'Javascript function code used to automaticaly generate a working identifier from the intered information';
-- ddl-end --
COMMENT ON COLUMN col.sample_type.sample_type_description IS E'Description of the type of sample';
-- ddl-end --
ALTER TABLE col.sample_type OWNER TO collec;
-- ddl-end --

-- object: col.sampling_place_sampling_place_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.sampling_place_sampling_place_id_seq CASCADE;
CREATE SEQUENCE col.sampling_place_sampling_place_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.sampling_place_sampling_place_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.sampling_place | type: TABLE --
-- DROP TABLE IF EXISTS col.sampling_place CASCADE;
CREATE TABLE col.sampling_place (
	sampling_place_id integer NOT NULL DEFAULT nextval('col.sampling_place_sampling_place_id_seq'::regclass),
	sampling_place_name character varying NOT NULL,
	collection_id integer,
	sampling_place_code character varying,
	sampling_place_x double precision,
	sampling_place_y double precision,
	country_id integer,
	CONSTRAINT sampling_place_pk PRIMARY KEY (sampling_place_id)
);
-- ddl-end --
COMMENT ON TABLE col.sampling_place IS E'Table of sampling places';
-- ddl-end --
COMMENT ON COLUMN col.sampling_place.sampling_place_name IS E'Name of the sampling place';
-- ddl-end --
COMMENT ON COLUMN col.sampling_place.collection_id IS E'Collection of rattachment';
-- ddl-end --
COMMENT ON COLUMN col.sampling_place.sampling_place_code IS E'Working code of the station';
-- ddl-end --
COMMENT ON COLUMN col.sampling_place.sampling_place_x IS E'Longitude of the station, in WGS84';
-- ddl-end --
COMMENT ON COLUMN col.sampling_place.sampling_place_y IS E'Latitude of the station, in WGS84';
-- ddl-end --
ALTER TABLE col.sampling_place OWNER TO collec;
-- ddl-end --

-- object: col.storage_condition_storage_condition_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.storage_condition_storage_condition_id_seq CASCADE;
CREATE SEQUENCE col.storage_condition_storage_condition_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.storage_condition_storage_condition_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.storage_condition | type: TABLE --
-- DROP TABLE IF EXISTS col.storage_condition CASCADE;
CREATE TABLE col.storage_condition (
	storage_condition_id integer NOT NULL DEFAULT nextval('col.storage_condition_storage_condition_id_seq'::regclass),
	storage_condition_name character varying NOT NULL,
	CONSTRAINT storage_condition_pk PRIMARY KEY (storage_condition_id)
);
-- ddl-end --
COMMENT ON TABLE col.storage_condition IS E'Table of the conditions of storage';
-- ddl-end --
ALTER TABLE col.storage_condition OWNER TO collec;
-- ddl-end --

-- object: col.movement_reason | type: TABLE --
-- DROP TABLE IF EXISTS col.movement_reason CASCADE;
CREATE TABLE col.movement_reason (
	movement_reason_id integer NOT NULL DEFAULT nextval('col.storage_reason_storage_reason_id_seq'::regclass),
	movement_reason_name character varying NOT NULL,
	CONSTRAINT storage_reason_pk PRIMARY KEY (movement_reason_id)
);
-- ddl-end --
COMMENT ON TABLE col.movement_reason IS E'List of the reasons of the movement';
-- ddl-end --
ALTER TABLE col.movement_reason OWNER TO collec;
-- ddl-end --

-- object: col.movement | type: TABLE --
-- DROP TABLE IF EXISTS col.movement CASCADE;
CREATE TABLE col.movement (
	movement_id integer NOT NULL DEFAULT nextval('col.storage_storage_id_seq'::regclass),
	uid integer NOT NULL,
	container_id integer,
	movement_type_id integer NOT NULL,
	movement_date timestamp NOT NULL,
	storage_location character varying,
	login character varying NOT NULL,
	movement_comment character varying,
	movement_reason_id integer,
	column_number integer NOT NULL DEFAULT 1,
	line_number integer NOT NULL DEFAULT 1,
	CONSTRAINT storage_pk PRIMARY KEY (movement_id)
);
-- ddl-end --
COMMENT ON TABLE col.movement IS E'Records of objects movements';
-- ddl-end --
COMMENT ON COLUMN col.movement.movement_date IS E'Date-time of the movement';
-- ddl-end --
COMMENT ON COLUMN col.movement.storage_location IS E'Place of the object in the container, in textual form';
-- ddl-end --
COMMENT ON COLUMN col.movement.login IS E'Name of the operator who performed the operation';
-- ddl-end --
COMMENT ON COLUMN col.movement.movement_comment IS E'Comment';
-- ddl-end --
COMMENT ON COLUMN col.movement.column_number IS E'Number of the storage column in the container';
-- ddl-end --
COMMENT ON COLUMN col.movement.line_number IS E'Number of the storage line in the container';
-- ddl-end --
ALTER TABLE col.movement OWNER TO collec;
-- ddl-end --

-- object: col.subsample_subsample_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.subsample_subsample_id_seq CASCADE;
CREATE SEQUENCE col.subsample_subsample_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.subsample_subsample_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.subsample | type: TABLE --
-- DROP TABLE IF EXISTS col.subsample CASCADE;
CREATE TABLE col.subsample (
	subsample_id integer NOT NULL DEFAULT nextval('col.subsample_subsample_id_seq'::regclass),
	sample_id integer NOT NULL,
	subsample_date timestamp NOT NULL,
	movement_type_id integer NOT NULL,
	subsample_quantity double precision,
	subsample_comment character varying,
	subsample_login character varying NOT NULL,
	borrower_id integer,
	CONSTRAINT subsample_pk PRIMARY KEY (subsample_id)
);
-- ddl-end --
COMMENT ON TABLE col.subsample IS E'Table of sub-sample takes and returns';
-- ddl-end --
COMMENT ON COLUMN col.subsample.subsample_date IS E'Date-time of the operation';
-- ddl-end --
COMMENT ON COLUMN col.subsample.subsample_quantity IS E'Quantity taken or returned';
-- ddl-end --
COMMENT ON COLUMN col.subsample.subsample_comment IS E'Comment on this operation';
-- ddl-end --
COMMENT ON COLUMN col.subsample.subsample_login IS E'Login of the user who perform this operation';
-- ddl-end --
ALTER TABLE col.subsample OWNER TO collec;
-- ddl-end --

-- object: col.v_object_identifier | type: VIEW --
-- DROP VIEW IF EXISTS col.v_object_identifier CASCADE;
CREATE VIEW col.v_object_identifier
AS

SELECT object_identifier.uid,
    array_to_string(array_agg((
    case when identifier_type_code is not null then identifier_type.identifier_type_code else identifier_type_name end ::text || ':'::text) || object_identifier.object_identifier_value::text
    ORDER BY identifier_type.identifier_type_code, object_identifier.object_identifier_value), ','::text) AS identifiers
   FROM col.object_identifier
     JOIN col.identifier_type USING (identifier_type_id)
  GROUP BY object_identifier.uid
  ORDER BY object_identifier.uid;
-- ddl-end --
ALTER VIEW col.v_object_identifier OWNER TO collec;
-- ddl-end --

-- object: gacl.aclgroup_aclgroup_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS gacl.aclgroup_aclgroup_id_seq CASCADE;
CREATE SEQUENCE gacl.aclgroup_aclgroup_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 7
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE gacl.aclgroup_aclgroup_id_seq OWNER TO collec;
-- ddl-end --

-- object: gacl.aclacl | type: TABLE --
-- DROP TABLE IF EXISTS gacl.aclacl CASCADE;
CREATE TABLE gacl.aclacl (
	aclaco_id integer NOT NULL,
	aclgroup_id integer NOT NULL,
	CONSTRAINT aclacl_pk PRIMARY KEY (aclaco_id,aclgroup_id)
);
-- ddl-end --
COMMENT ON TABLE gacl.aclacl IS E'Table of rights granted';
-- ddl-end --
ALTER TABLE gacl.aclacl OWNER TO collec;
-- ddl-end --

INSERT INTO gacl.aclacl (aclaco_id, aclgroup_id) VALUES (E'1', E'1');
-- ddl-end --
INSERT INTO gacl.aclacl (aclaco_id, aclgroup_id) VALUES (E'2', E'5');
-- ddl-end --
INSERT INTO gacl.aclacl (aclaco_id, aclgroup_id) VALUES (E'3', E'4');
-- ddl-end --
INSERT INTO gacl.aclacl (aclaco_id, aclgroup_id) VALUES (E'4', E'3');
-- ddl-end --
INSERT INTO gacl.aclacl (aclaco_id, aclgroup_id) VALUES (E'5', E'2');
-- ddl-end --
INSERT INTO gacl.aclacl (aclaco_id, aclgroup_id) VALUES (E'6', E'6');
-- ddl-end --

-- object: gacl.aclaco_aclaco_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS gacl.aclaco_aclaco_id_seq CASCADE;
CREATE SEQUENCE gacl.aclaco_aclaco_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 7
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE gacl.aclaco_aclaco_id_seq OWNER TO collec;
-- ddl-end --

-- object: gacl.aclaco | type: TABLE --
-- DROP TABLE IF EXISTS gacl.aclaco CASCADE;
CREATE TABLE gacl.aclaco (
	aclaco_id integer NOT NULL DEFAULT nextval('gacl.aclaco_aclaco_id_seq'::regclass),
	aclappli_id integer NOT NULL,
	aco character varying NOT NULL,
	CONSTRAINT aclaco_pk PRIMARY KEY (aclaco_id)
);
-- ddl-end --
COMMENT ON TABLE gacl.aclaco IS E'Table of managed rights';
-- ddl-end --
COMMENT ON COLUMN gacl.aclaco.aco IS E'Name of the right in the application';
-- ddl-end --
ALTER TABLE gacl.aclaco OWNER TO collec;
-- ddl-end --

INSERT INTO gacl.aclaco (aclaco_id, aclappli_id, aco) VALUES (E'1', E'1', E'admin');
-- ddl-end --
INSERT INTO gacl.aclaco (aclaco_id, aclappli_id, aco) VALUES (E'5', E'1', E'consult');
-- ddl-end --
INSERT INTO gacl.aclaco (aclaco_id, aclappli_id, aco) VALUES (E'2', E'1', E'param');
-- ddl-end --
INSERT INTO gacl.aclaco (aclaco_id, aclappli_id, aco) VALUES (E'6', E'1', E'import');
-- ddl-end --
INSERT INTO gacl.aclaco (aclaco_id, aclappli_id, aco) VALUES (E'3', E'1', E'collection');
-- ddl-end --
INSERT INTO gacl.aclaco (aclaco_id, aclappli_id, aco) VALUES (E'4', E'1', E'gestion');
-- ddl-end --

-- object: gacl.aclappli_aclappli_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS gacl.aclappli_aclappli_id_seq CASCADE;
CREATE SEQUENCE gacl.aclappli_aclappli_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 2
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE gacl.aclappli_aclappli_id_seq OWNER TO collec;
-- ddl-end --

-- object: gacl.aclappli | type: TABLE --
-- DROP TABLE IF EXISTS gacl.aclappli CASCADE;
CREATE TABLE gacl.aclappli (
	aclappli_id integer NOT NULL DEFAULT nextval('gacl.aclappli_aclappli_id_seq'::regclass),
	appli character varying NOT NULL,
	applidetail character varying,
	CONSTRAINT aclappli_pk PRIMARY KEY (aclappli_id)
);
-- ddl-end --
COMMENT ON TABLE gacl.aclappli IS E'Table of managed applications';
-- ddl-end --
COMMENT ON COLUMN gacl.aclappli.appli IS E'Code of the application used to manage the rights';
-- ddl-end --
COMMENT ON COLUMN gacl.aclappli.applidetail IS E'Description of the application';
-- ddl-end --
ALTER TABLE gacl.aclappli OWNER TO collec;
-- ddl-end --

INSERT INTO gacl.aclappli (aclappli_id, appli, applidetail) VALUES (E'1', E'col', E'Collec-Science');
-- ddl-end --

-- object: gacl.aclgroup | type: TABLE --
-- DROP TABLE IF EXISTS gacl.aclgroup CASCADE;
CREATE TABLE gacl.aclgroup (
	aclgroup_id integer NOT NULL DEFAULT nextval('gacl.aclgroup_aclgroup_id_seq'::regclass),
	groupe character varying NOT NULL,
	aclgroup_id_parent integer,
	CONSTRAINT aclgroup_pk PRIMARY KEY (aclgroup_id)
);
-- ddl-end --
COMMENT ON TABLE gacl.aclgroup IS E'Groups of logins';
-- ddl-end --
COMMENT ON COLUMN gacl.aclgroup.groupe IS E'Name of the group';
-- ddl-end --
COMMENT ON COLUMN gacl.aclgroup.aclgroup_id_parent IS E'Parent group who inherits of the rights attributed to this group';
-- ddl-end --
ALTER TABLE gacl.aclgroup OWNER TO collec;
-- ddl-end --

INSERT INTO gacl.aclgroup (aclgroup_id, groupe, aclgroup_id_parent) VALUES (E'1', E'admin', DEFAULT);
-- ddl-end --
INSERT INTO gacl.aclgroup (aclgroup_id, groupe, aclgroup_id_parent) VALUES (E'2', E'consult', DEFAULT);
-- ddl-end --
INSERT INTO gacl.aclgroup (aclgroup_id, groupe, aclgroup_id_parent) VALUES (E'3', E'gestion', E'2');
-- ddl-end --
INSERT INTO gacl.aclgroup (aclgroup_id, groupe, aclgroup_id_parent) VALUES (E'4', E'collection', E'3');
-- ddl-end --
INSERT INTO gacl.aclgroup (aclgroup_id, groupe, aclgroup_id_parent) VALUES (E'5', E'param', E'4');
-- ddl-end --
INSERT INTO gacl.aclgroup (aclgroup_id, groupe, aclgroup_id_parent) VALUES (E'6', E'import', E'3');
-- ddl-end --

-- object: gacl.acllogin_acllogin_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS gacl.acllogin_acllogin_id_seq CASCADE;
CREATE SEQUENCE gacl.acllogin_acllogin_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 2
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE gacl.acllogin_acllogin_id_seq OWNER TO collec;
-- ddl-end --

-- object: gacl.acllogin | type: TABLE --
-- DROP TABLE IF EXISTS gacl.acllogin CASCADE;
CREATE TABLE gacl.acllogin (
	acllogin_id integer NOT NULL DEFAULT nextval('gacl.acllogin_acllogin_id_seq'::regclass),
	login character varying NOT NULL,
	logindetail character varying NOT NULL,
	totp_key varchar,
	CONSTRAINT acllogin_pk PRIMARY KEY (acllogin_id)
);
-- ddl-end --
COMMENT ON TABLE gacl.acllogin IS E'List of logins granted to access to the modules of the application';
-- ddl-end --
COMMENT ON COLUMN gacl.acllogin.login IS E'Login. It must be the same as the table logingestion';
-- ddl-end --
COMMENT ON COLUMN gacl.acllogin.logindetail IS E'Displayed name';
-- ddl-end --
COMMENT ON COLUMN gacl.acllogin.totp_key IS E'TOTP secret key for the user';
-- ddl-end --
ALTER TABLE gacl.acllogin OWNER TO collec;
-- ddl-end --

INSERT INTO gacl.acllogin (acllogin_id, login, logindetail) VALUES (E'1', E'admin', E'admin');
-- ddl-end --

-- object: gacl.acllogingroup | type: TABLE --
-- DROP TABLE IF EXISTS gacl.acllogingroup CASCADE;
CREATE TABLE gacl.acllogingroup (
	acllogin_id integer NOT NULL,
	aclgroup_id integer NOT NULL,
	CONSTRAINT acllogingroup_pk PRIMARY KEY (acllogin_id,aclgroup_id)
);
-- ddl-end --
COMMENT ON TABLE gacl.acllogingroup IS E'List of logins in the groups';
-- ddl-end --
ALTER TABLE gacl.acllogingroup OWNER TO collec;
-- ddl-end --

INSERT INTO gacl.acllogingroup (acllogin_id, aclgroup_id) VALUES (E'1', E'1');
-- ddl-end --
INSERT INTO gacl.acllogingroup (acllogin_id, aclgroup_id) VALUES (E'1', E'5');
-- ddl-end --

-- object: gacl.log_log_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS gacl.log_log_id_seq CASCADE;
CREATE SEQUENCE gacl.log_log_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE gacl.log_log_id_seq OWNER TO collec;
-- ddl-end --

-- object: gacl.log | type: TABLE --
-- DROP TABLE IF EXISTS gacl.log CASCADE;
CREATE TABLE gacl.log (
	log_id integer NOT NULL DEFAULT nextval('gacl.log_log_id_seq'::regclass),
	login character varying(32) NOT NULL,
	nom_module character varying,
	log_date timestamp NOT NULL,
	commentaire character varying,
	ipaddress character varying,
	CONSTRAINT log_pk PRIMARY KEY (log_id)
);
-- ddl-end --
COMMENT ON TABLE gacl.log IS E'List of all recorded operations (logins, calls of modules, etc.)';
-- ddl-end --
COMMENT ON COLUMN gacl.log.login IS E'Code of the login who performs the operation';
-- ddl-end --
COMMENT ON COLUMN gacl.log.nom_module IS E'Name of the performed module';
-- ddl-end --
COMMENT ON COLUMN gacl.log.log_date IS E'Date-time of the operation';
-- ddl-end --
COMMENT ON COLUMN gacl.log.commentaire IS E'Complementary data recorded';
-- ddl-end --
COMMENT ON COLUMN gacl.log.ipaddress IS E'IP address of the client';
-- ddl-end --
ALTER TABLE gacl.log OWNER TO collec;
-- ddl-end --

-- object: gacl.seq_logingestion_id | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS gacl.seq_logingestion_id CASCADE;
CREATE SEQUENCE gacl.seq_logingestion_id
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 999999
	START WITH 2
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE gacl.seq_logingestion_id OWNER TO collec;
-- ddl-end --

-- object: gacl.logingestion | type: TABLE --
-- DROP TABLE IF EXISTS gacl.logingestion CASCADE;
CREATE TABLE gacl.logingestion (
	id integer NOT NULL DEFAULT nextval('gacl.seq_logingestion_id'::regclass),
	login varchar NOT NULL,
	password varchar,
	nom varchar,
	prenom varchar,
	mail character varying(255),
	datemodif timestamp,
	actif smallint DEFAULT 1,
	is_clientws boolean DEFAULT false,
	tokenws character varying,
	is_expired boolean DEFAULT false,
	CONSTRAINT pk_logingestion PRIMARY KEY (id)
);
-- ddl-end --
COMMENT ON TABLE gacl.logingestion IS E'List of logins used to connect to the application, when the account is managed by the application itself. This table also contains the accounts authorized to use the web services.';
-- ddl-end --
COMMENT ON COLUMN gacl.logingestion.login IS E'Login used by the user';
-- ddl-end --
COMMENT ON COLUMN gacl.logingestion.nom IS E'Name of the user';
-- ddl-end --
COMMENT ON COLUMN gacl.logingestion.prenom IS E'Surname';
-- ddl-end --
COMMENT ON COLUMN gacl.logingestion.mail IS E'email. Used to send password loss messages';
-- ddl-end --
COMMENT ON COLUMN gacl.logingestion.datemodif IS E'Last date of change of the record';
-- ddl-end --
COMMENT ON COLUMN gacl.logingestion.actif IS E'If 1, the account is active and can be logging to the application';
-- ddl-end --
COMMENT ON COLUMN gacl.logingestion.is_clientws IS E'True if the login is used by a third-party application to call a web-service';
-- ddl-end --
COMMENT ON COLUMN gacl.logingestion.tokenws IS E'Identification token used for the third-parties applications';
-- ddl-end --
COMMENT ON COLUMN gacl.logingestion.is_expired IS E'If true, the account is expired (password older)';
-- ddl-end --
ALTER TABLE gacl.logingestion OWNER TO collec;
-- ddl-end --

INSERT INTO gacl.logingestion (id, login, password, nom, prenom, mail, datemodif, actif, is_clientws, tokenws, is_expired) VALUES (E'1', E'admin', E'cd916028a2d8a1b901e831246dd5b9b4d3832786ddc63bbf5af4b50d9fc98f50', E'Administrator', DEFAULT, E'admin@mysociety.com', E'2017-08-24 00:00:00', E'1', E'false', DEFAULT, E'false');
-- ddl-end --

-- object: gacl.passwordlost_passwordlost_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS gacl.passwordlost_passwordlost_id_seq CASCADE;
CREATE SEQUENCE gacl.passwordlost_passwordlost_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE gacl.passwordlost_passwordlost_id_seq OWNER TO collec;
-- ddl-end --

-- object: gacl.passwordlost | type: TABLE --
-- DROP TABLE IF EXISTS gacl.passwordlost CASCADE;
CREATE TABLE gacl.passwordlost (
	passwordlost_id integer NOT NULL DEFAULT nextval('gacl.passwordlost_passwordlost_id_seq'::regclass),
	id integer NOT NULL,
	token character varying NOT NULL,
	expiration timestamp NOT NULL,
	usedate timestamp,
	CONSTRAINT passwordlost_pk PRIMARY KEY (passwordlost_id)
);
-- ddl-end --
COMMENT ON TABLE gacl.passwordlost IS E'Password loss tracking table';
-- ddl-end --
COMMENT ON COLUMN gacl.passwordlost.id IS E'Logingestion id key';
-- ddl-end --
COMMENT ON COLUMN gacl.passwordlost.token IS E'Token used to renewal';
-- ddl-end --
COMMENT ON COLUMN gacl.passwordlost.expiration IS E'Expiration date-time of the token';
-- ddl-end --
COMMENT ON COLUMN gacl.passwordlost.usedate IS E'Used date-time of the token';
-- ddl-end --
ALTER TABLE gacl.passwordlost OWNER TO collec;
-- ddl-end --

-- object: referent_referent_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.referent_referent_name_idx CASCADE;
CREATE UNIQUE INDEX referent_referent_name_idx ON col.referent
USING btree
(
	referent_name
)
WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sample_expiration_date_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.sample_expiration_date_idx CASCADE;
CREATE INDEX sample_expiration_date_idx ON col.sample
USING btree
(
	expiration_date
)
WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sample_sample_creation_date_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.sample_sample_creation_date_idx CASCADE;
CREATE INDEX sample_sample_creation_date_idx ON col.sample
USING btree
(
	sample_creation_date
)
WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: sample_sampling_date_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.sample_sampling_date_idx CASCADE;
CREATE INDEX sample_sampling_date_idx ON col.sample
USING btree
(
	sampling_date
)
WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: log_date_idx | type: INDEX --
-- DROP INDEX IF EXISTS gacl.log_date_idx CASCADE;
CREATE INDEX log_date_idx ON gacl.log
USING btree
(
	log_date
)
WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: log_login_idx | type: INDEX --
-- DROP INDEX IF EXISTS gacl.log_login_idx CASCADE;
CREATE INDEX log_login_idx ON gacl.log
USING btree
(
	login
)
WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: log_commentaire_idx | type: INDEX --
-- DROP INDEX IF EXISTS gacl.log_commentaire_idx CASCADE;
CREATE INDEX log_commentaire_idx ON gacl.log
USING btree
(
	commentaire
)
WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: logingestion_login_idx | type: INDEX --
-- DROP INDEX IF EXISTS gacl.logingestion_login_idx CASCADE;
CREATE UNIQUE INDEX logingestion_login_idx ON gacl.logingestion
USING btree
(
	login
)
WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: log_ip_idx | type: INDEX --
-- DROP INDEX IF EXISTS gacl.log_ip_idx CASCADE;
CREATE INDEX log_ip_idx ON gacl.log
USING btree
(
	ipaddress
)
WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: col.last_movement | type: VIEW --
-- DROP VIEW IF EXISTS col.last_movement CASCADE;
CREATE VIEW col.last_movement
AS

SELECT s.uid,
    s.movement_id,
    s.movement_date,
    s.movement_type_id,
    s.container_id,
    c.uid AS container_uid,
    s.line_number,
    s.column_number,
    s.movement_reason_id
   FROM (col.movement s
     LEFT JOIN col.container c USING (container_id))
  WHERE (s.movement_id = ( SELECT st.movement_id
           FROM col.movement st
          WHERE (s.uid = st.uid)
          ORDER BY st.movement_date DESC
         LIMIT 1));
-- ddl-end --
ALTER VIEW col.last_movement OWNER TO collec;
-- ddl-end --

-- object: col.borrower_borrower_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.borrower_borrower_id_seq CASCADE;
CREATE SEQUENCE col.borrower_borrower_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.borrower_borrower_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.borrower | type: TABLE --
-- DROP TABLE IF EXISTS col.borrower CASCADE;
CREATE TABLE col.borrower (
	borrower_id integer NOT NULL DEFAULT nextval('col.borrower_borrower_id_seq'::regclass),
	borrower_name character varying NOT NULL,
	borrower_address character varying,
	borrower_phone character varying,
	laboratory_code varchar,
	borrower_mail varchar,
	CONSTRAINT borrower_pk PRIMARY KEY (borrower_id)
);
-- ddl-end --
COMMENT ON TABLE col.borrower IS E'List of borrowers';
-- ddl-end --
COMMENT ON COLUMN col.borrower.borrower_address IS E'Address of the borrower';
-- ddl-end --
COMMENT ON COLUMN col.borrower.borrower_phone IS E'Phone of the contact of the borrower';
-- ddl-end --
COMMENT ON COLUMN col.borrower.laboratory_code IS E'Laboratory code of the borrower';
-- ddl-end --
COMMENT ON COLUMN col.borrower.borrower_mail IS E'Mail of the borrower';
-- ddl-end --
ALTER TABLE col.borrower OWNER TO collec;
-- ddl-end --

-- object: col.borrowing_borrowing_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.borrowing_borrowing_id_seq CASCADE;
CREATE SEQUENCE col.borrowing_borrowing_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.borrowing_borrowing_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.borrowing | type: TABLE --
-- DROP TABLE IF EXISTS col.borrowing CASCADE;
CREATE TABLE col.borrowing (
	borrowing_id integer NOT NULL DEFAULT nextval('col.borrowing_borrowing_id_seq'::regclass),
	borrowing_date timestamp NOT NULL,
	expected_return_date timestamp,
	uid integer NOT NULL,
	borrower_id integer NOT NULL,
	return_date timestamp,
	CONSTRAINT borrowing_pk PRIMARY KEY (borrowing_id)
);
-- ddl-end --
COMMENT ON TABLE col.borrowing IS E'List of borrowings';
-- ddl-end --
COMMENT ON COLUMN col.borrowing.borrowing_date IS E'Date of the borrowing';
-- ddl-end --
COMMENT ON COLUMN col.borrowing.expected_return_date IS E'Expected return date of the object';
-- ddl-end --
COMMENT ON COLUMN col.borrowing.return_date IS E'Date of return of the object';
-- ddl-end --
ALTER TABLE col.borrowing OWNER TO collec;
-- ddl-end --

-- object: borrowing_uid_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.borrowing_uid_idx CASCADE;
CREATE INDEX borrowing_uid_idx ON col.borrowing
USING btree
(
	uid
)
WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: borrowing_borrower_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.borrowing_borrower_id_idx CASCADE;
CREATE INDEX borrowing_borrower_id_idx ON col.borrowing
USING btree
(
	borrower_id
)
WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: col.last_borrowing | type: VIEW --
-- DROP VIEW IF EXISTS col.last_borrowing CASCADE;
CREATE VIEW col.last_borrowing
AS

SELECT b1.borrowing_id,
    b1.uid,
    b1.borrowing_date,
    b1.expected_return_date,
    b1.borrower_id
   FROM col.borrowing b1
  WHERE (b1.borrowing_id = ( SELECT b2.borrowing_id
           FROM col.borrowing b2
          WHERE ((b1.uid = b2.uid) AND (b2.return_date IS NULL))
          ORDER BY b2.borrowing_date DESC
         LIMIT 1));
-- ddl-end --
ALTER VIEW col.last_borrowing OWNER TO collec;
-- ddl-end --

-- object: col.slots_used | type: VIEW --
-- DROP VIEW IF EXISTS col.slots_used CASCADE;
CREATE VIEW col.slots_used
AS

SELECT
   container_id, count(*) as nb_slots_used
FROM
   last_movement
WHERE
   movement_type_id = 1
   group by container_id;
-- ddl-end --
ALTER VIEW col.slots_used OWNER TO collec;
-- ddl-end --

-- object: log_module_idx | type: INDEX --
-- DROP INDEX IF EXISTS gacl.log_module_idx CASCADE;
CREATE INDEX log_module_idx ON gacl.log
USING btree
(
	nom_module
);
-- ddl-end --

-- object: col.request_request_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.request_request_id_seq CASCADE;
CREATE SEQUENCE col.request_request_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.request_request_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.request | type: TABLE --
-- DROP TABLE IF EXISTS col.request CASCADE;
CREATE TABLE col.request (
	request_id integer NOT NULL DEFAULT nextval('col.request_request_id_seq'::regclass),
	create_date timestamp NOT NULL,
	last_exec timestamp,
	title character varying NOT NULL,
	body character varying NOT NULL,
	login character varying NOT NULL,
	datefields character varying,
	collection_id integer,
	CONSTRAINT request_pk PRIMARY KEY (request_id)
);
-- ddl-end --
COMMENT ON TABLE col.request IS E'Request table in database';
-- ddl-end --
COMMENT ON COLUMN col.request.create_date IS E'Date of create of the request';
-- ddl-end --
COMMENT ON COLUMN col.request.last_exec IS E'Date of the last execution';
-- ddl-end --
COMMENT ON COLUMN col.request.title IS E'Title of the request';
-- ddl-end --
COMMENT ON COLUMN col.request.body IS E'Body of the request. Don''t begin it by SELECT, which will be added automatically';
-- ddl-end --
COMMENT ON COLUMN col.request.login IS E'Login of the creator of the request';
-- ddl-end --
COMMENT ON COLUMN col.request.datefields IS E'List of the date fields used in the request, separated by a comma, for format it';
-- ddl-end --
ALTER TABLE col.request OWNER TO collec;
-- ddl-end --

INSERT INTO col.request (create_date, last_exec, title, body, login, datefields) VALUES (now(), DEFAULT, E'Number of samples by collection', E'collection_name, count(*) as "number of samples"\nfrom sample\njoin collection using (collection_id)\ngroup by collection_name', E'admin', DEFAULT);
-- ddl-end --

-- object: col.export_model_export_model_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.export_model_export_model_id_seq CASCADE;
CREATE SEQUENCE col.export_model_export_model_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.export_model_export_model_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.export_model | type: TABLE --
-- DROP TABLE IF EXISTS col.export_model CASCADE;
CREATE TABLE col.export_model (
	export_model_id integer NOT NULL DEFAULT nextval('col.export_model_export_model_id_seq'::regclass),
	export_model_name varchar NOT NULL,
	pattern json,
	target varchar,
	CONSTRAINT export_model_pk PRIMARY KEY (export_model_id)
);
-- ddl-end --
COMMENT ON TABLE col.export_model IS E'Structure of an export/import of table data';
-- ddl-end --
COMMENT ON COLUMN col.export_model.export_model_name IS E'Name of the structure of export';
-- ddl-end --
COMMENT ON COLUMN col.export_model.pattern IS E'Pattern of the export/import.\nStructure:\n[{technicalKey:string,businessKey:string,tableName:string,tableAlias:string,children[table1,table2],parentKey:string,secondaryParentKey:string}]';
-- ddl-end --
COMMENT ON COLUMN col.export_model.target IS E'Main table targetted';
-- ddl-end --
ALTER TABLE col.export_model OWNER TO collec;
-- ddl-end --

INSERT INTO col.export_model (export_model_name, pattern) VALUES (E'export_model', E'[{"tableName":"export_model","businessKey":"export_model_name","istable11":false,"children":[],"booleanFields":[],"istablenn":false}]');
-- ddl-end --
INSERT INTO col.export_model (export_model_name, pattern) VALUES (E'export_template', E'[{"tableName":"export_template","technicalKey":"export_template_id","isEmpty":false,"businessKey":"export_template_name","istable11":false,"children":[{"aliasName":"export_dataset","isStrict":true}],"parents":[],"istablenn":false},{"tableName":"export_dataset","isEmpty":false,"parentKey":"export_template_id","istable11":false,"children":[],"parents":[{"aliasName":"dataset_template","fieldName":"dataset_template_id"}],"istablenn":true,"tablenn":{"secondaryParentKey":"dataset_template_id","tableAlias":"dataset_template"}},{"tableName":"dataset_template","technicalKey":"dataset_template_id","isEmpty":true,"businessKey":"dataset_template_name","istable11":false,"children":[{"aliasName":"dataset_column","isStrict":true}],"parents":[],"istablenn":false},{"tableName":"dataset_column","technicalKey":"dataset_column_id","isEmpty":false,"parentKey":"dataset_template_id","istable11":false,"children":[],"parents":[{"aliasName":"translator","fieldName":"translator_id"}],"istablenn":false},{"tableName":"translator","technicalKey":"translator_id","isEmpty":true,"businessKey":"translator_name","istable11":false,"children":[],"parents":[],"istablenn":false}]');
-- ddl-end --

-- object: movement_uid_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.movement_uid_idx CASCADE;
CREATE INDEX movement_uid_idx ON col.movement
USING btree
(
	uid
);
-- ddl-end --

-- object: movement_container_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.movement_container_id_idx CASCADE;
CREATE INDEX movement_container_id_idx ON col.movement
USING btree
(
	container_id
);
-- ddl-end --

-- object: movement_movement_date_desc_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.movement_movement_date_desc_idx CASCADE;
CREATE INDEX movement_movement_date_desc_idx ON col.movement
USING btree
(
	movement_date DESC NULLS LAST
);
-- ddl-end --

-- object: movement_login_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.movement_login_idx CASCADE;
CREATE INDEX movement_login_idx ON col.movement
USING btree
(
	login
);
-- ddl-end --

-- object: container_uid_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.container_uid_idx CASCADE;
CREATE INDEX container_uid_idx ON col.container
USING btree
(
	uid
);
-- ddl-end --

-- object: object_identifier_uid_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.object_identifier_uid_idx CASCADE;
CREATE INDEX object_identifier_uid_idx ON col.object_identifier
USING btree
(
	uid
);
-- ddl-end --

-- object: sample_uid_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.sample_uid_idx CASCADE;
CREATE INDEX sample_uid_idx ON col.sample
USING btree
(
	uid
);
-- ddl-end --

-- object: col.object | type: TABLE --
-- DROP TABLE IF EXISTS col.object CASCADE;
CREATE TABLE col.object (
	uid integer NOT NULL DEFAULT nextval('col.object_uid_seq'::regclass),
	identifier character varying,
	wgs84_x double precision,
	wgs84_y double precision,
	object_status_id integer,
	referent_id integer,
	change_date timestamp NOT NULL DEFAULT 'now',
	uuid uuid NOT NULL DEFAULT gen_random_uuid(),
	trashed bool DEFAULT false,
	location_accuracy float,
	geom geography(POINT, 4326),
	object_comment varchar,
	CONSTRAINT object_pk PRIMARY KEY (uid)
);
-- ddl-end --
COMMENT ON TABLE col.object IS E'Table of objects';
-- ddl-end --
COMMENT ON COLUMN col.object.uid IS E'Unique identifier in the database of all objects';
-- ddl-end --
COMMENT ON COLUMN col.object.identifier IS E'Main working identifier';
-- ddl-end --
COMMENT ON COLUMN col.object.wgs84_x IS E'GPS longitude, in decimal form';
-- ddl-end --
COMMENT ON COLUMN col.object.wgs84_y IS E'GPS latitude, in decimal form';
-- ddl-end --
COMMENT ON COLUMN col.object.change_date IS E'Technical date of changement of the object';
-- ddl-end --
COMMENT ON COLUMN col.object.uuid IS E'UUID of the object';
-- ddl-end --
COMMENT ON COLUMN col.object.trashed IS E'If the object is trashed before completly destroyed ?';
-- ddl-end --
COMMENT ON COLUMN col.object.location_accuracy IS E'Location accuracy of the object, in meters';
-- ddl-end --
COMMENT ON COLUMN col.object.geom IS E'Geographic point generate from wgs84_x and wgs84_y';
-- ddl-end --
COMMENT ON COLUMN col.object.object_comment IS E'Comment on the object (sample or container)';
-- ddl-end --
ALTER TABLE col.object OWNER TO collec;
-- ddl-end --

-- object: object_trashed | type: INDEX --
-- DROP INDEX IF EXISTS col.object_trashed CASCADE;
CREATE INDEX object_trashed ON col.object
USING btree
(
	trashed
)
WHERE (trashed = true);
-- ddl-end --
COMMENT ON INDEX col.object_trashed IS E'Index used when trashed is true';
-- ddl-end --

-- object: col_object_geom_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.col_object_geom_idx CASCADE;
CREATE INDEX col_object_geom_idx ON col.object
USING gist
(
	geom
);
-- ddl-end --

-- object: col.campaign_campaign_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.campaign_campaign_id_seq CASCADE;
CREATE SEQUENCE col.campaign_campaign_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.campaign_campaign_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.campaign | type: TABLE --
-- DROP TABLE IF EXISTS col.campaign CASCADE;
CREATE TABLE col.campaign (
	campaign_id integer NOT NULL DEFAULT nextval('col.campaign_campaign_id_seq'::regclass),
	campaign_name varchar NOT NULL,
	campaign_from timestamp,
	campaign_to timestamp,
	uuid uuid NOT NULL DEFAULT gen_random_uuid(),
	referent_id integer,
	CONSTRAINT campaign_pk PRIMARY KEY (campaign_id)
);
-- ddl-end --
COMMENT ON TABLE col.campaign IS E'List of sampling campaigns';
-- ddl-end --
COMMENT ON COLUMN col.campaign.campaign_name IS E'Name of the campaign';
-- ddl-end --
COMMENT ON COLUMN col.campaign.campaign_from IS E'Date of start of the campaign';
-- ddl-end --
COMMENT ON COLUMN col.campaign.campaign_to IS E'date of end of the campaign';
-- ddl-end --
COMMENT ON COLUMN col.campaign.uuid IS E'UUID of the campaign';
-- ddl-end --
ALTER TABLE col.campaign OWNER TO collec;
-- ddl-end --

-- object: col.regulation_regulation_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS col.regulation_regulation_id_seq CASCADE;
CREATE SEQUENCE col.regulation_regulation_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

-- ddl-end --
ALTER SEQUENCE col.regulation_regulation_id_seq OWNER TO collec;
-- ddl-end --

-- object: col.regulation | type: TABLE --
-- DROP TABLE IF EXISTS col.regulation CASCADE;
CREATE TABLE col.regulation (
	regulation_id integer NOT NULL DEFAULT nextval('col.regulation_regulation_id_seq'::regclass),
	regulation_name varchar NOT NULL,
	regulation_comment varchar,
	CONSTRAINT regulation_pk PRIMARY KEY (regulation_id)
);
-- ddl-end --
COMMENT ON TABLE col.regulation IS E'Table of regulations';
-- ddl-end --
COMMENT ON COLUMN col.regulation.regulation_name IS E'Name of the regulation';
-- ddl-end --
COMMENT ON COLUMN col.regulation.regulation_comment IS E'regulatory clarity';
-- ddl-end --
ALTER TABLE col.regulation OWNER TO collec;
-- ddl-end --

-- object: col.campaign_regulation | type: TABLE --
-- DROP TABLE IF EXISTS col.campaign_regulation CASCADE;
CREATE TABLE col.campaign_regulation (
	campaign_regulation_id serial NOT NULL,
	campaign_id integer NOT NULL,
	authorization_number varchar,
	authorization_date timestamp,
	regulation_id integer NOT NULL,
	CONSTRAINT campaign_regulation_pk PRIMARY KEY (campaign_regulation_id)
);
-- ddl-end --
COMMENT ON TABLE col.campaign_regulation IS E'List of regulations attached to a campaign';
-- ddl-end --
COMMENT ON COLUMN col.campaign_regulation.authorization_number IS E'Number of the authorization';
-- ddl-end --
COMMENT ON COLUMN col.campaign_regulation.authorization_date IS E'Date of the authorization';
-- ddl-end --
ALTER TABLE col.campaign_regulation OWNER TO collec;
-- ddl-end --

-- object: campaign_fk | type: CONSTRAINT --
-- ALTER TABLE col.campaign_regulation DROP CONSTRAINT IF EXISTS campaign_fk CASCADE;
ALTER TABLE col.campaign_regulation ADD CONSTRAINT campaign_fk FOREIGN KEY (campaign_id)
REFERENCES col.campaign (campaign_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: regulation_fk | type: CONSTRAINT --
-- ALTER TABLE col.campaign_regulation DROP CONSTRAINT IF EXISTS regulation_fk CASCADE;
ALTER TABLE col.campaign_regulation ADD CONSTRAINT regulation_fk FOREIGN KEY (regulation_id)
REFERENCES col.regulation (regulation_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: campaign_fk | type: CONSTRAINT --
-- ALTER TABLE col.sample DROP CONSTRAINT IF EXISTS campaign_fk CASCADE;
ALTER TABLE col.sample ADD CONSTRAINT campaign_fk FOREIGN KEY (campaign_id)
REFERENCES col.campaign (campaign_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: referent_fk | type: CONSTRAINT --
-- ALTER TABLE col.campaign DROP CONSTRAINT IF EXISTS referent_fk CASCADE;
ALTER TABLE col.campaign ADD CONSTRAINT referent_fk FOREIGN KEY (referent_id)
REFERENCES col.referent (referent_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: campaign_fk | type: CONSTRAINT --
-- ALTER TABLE col.document DROP CONSTRAINT IF EXISTS campaign_fk CASCADE;
ALTER TABLE col.document ADD CONSTRAINT campaign_fk FOREIGN KEY (campaign_id)
REFERENCES col.campaign (campaign_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: col.lot | type: TABLE --
-- DROP TABLE IF EXISTS col.lot CASCADE;
CREATE TABLE col.lot (
	lot_id serial NOT NULL,
	collection_id integer,
	lot_date timestamp NOT NULL DEFAULT current_timestamp,
	CONSTRAINT lot_pk PRIMARY KEY (lot_id)
);
-- ddl-end --
COMMENT ON TABLE col.lot IS E'List of lots of export';
-- ddl-end --
COMMENT ON COLUMN col.lot.lot_date IS E'Date of creation of the lot';
-- ddl-end --
ALTER TABLE col.lot OWNER TO collec;
-- ddl-end --

-- object: collection_fk | type: CONSTRAINT --
-- ALTER TABLE col.lot DROP CONSTRAINT IF EXISTS collection_fk CASCADE;
ALTER TABLE col.lot ADD CONSTRAINT collection_fk FOREIGN KEY (collection_id)
REFERENCES col.collection (collection_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: col.lot_sample | type: TABLE --
-- DROP TABLE IF EXISTS col.lot_sample CASCADE;
CREATE TABLE col.lot_sample (
	lot_id integer NOT NULL,
	sample_id integer NOT NULL,
	CONSTRAINT lot_sample_pk PRIMARY KEY (lot_id,sample_id) DEFERRABLE INITIALLY IMMEDIATE
);
-- ddl-end --
COMMENT ON TABLE col.lot_sample IS E'List of samples associated into a lot';
-- ddl-end --
ALTER TABLE col.lot_sample OWNER TO collec;
-- ddl-end --

-- object: lot_fk | type: CONSTRAINT --
-- ALTER TABLE col.lot_sample DROP CONSTRAINT IF EXISTS lot_fk CASCADE;
ALTER TABLE col.lot_sample ADD CONSTRAINT lot_fk FOREIGN KEY (lot_id)
REFERENCES col.lot (lot_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: sample_fk | type: CONSTRAINT --
-- ALTER TABLE col.lot_sample DROP CONSTRAINT IF EXISTS sample_fk CASCADE;
ALTER TABLE col.lot_sample ADD CONSTRAINT sample_fk FOREIGN KEY (sample_id)
REFERENCES col.sample (sample_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: col.export | type: TABLE --
-- DROP TABLE IF EXISTS col.export CASCADE;
CREATE TABLE col.export (
	export_id serial NOT NULL,
	lot_id integer NOT NULL,
	export_date timestamp,
	export_template_id integer NOT NULL,
	CONSTRAINT export_pk PRIMARY KEY (export_id)
);
-- ddl-end --
COMMENT ON TABLE col.export IS E'List of exports processed';
-- ddl-end --
COMMENT ON COLUMN col.export.export_date IS E'Date of last execution of the export';
-- ddl-end --
ALTER TABLE col.export OWNER TO collec;
-- ddl-end --

-- object: lot_fk | type: CONSTRAINT --
-- ALTER TABLE col.export DROP CONSTRAINT IF EXISTS lot_fk CASCADE;
ALTER TABLE col.export ADD CONSTRAINT lot_fk FOREIGN KEY (lot_id)
REFERENCES col.lot (lot_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: col.export_template | type: TABLE --
-- DROP TABLE IF EXISTS col.export_template CASCADE;
CREATE TABLE col.export_template (
	export_template_id serial NOT NULL,
	export_template_name varchar NOT NULL,
	export_template_description varchar,
	export_template_version varchar,
	is_zipped boolean DEFAULT false,
	filename varchar NOT NULL DEFAULT 'cs-export.csv',
	CONSTRAINT export_model1_pk PRIMARY KEY (export_template_id)
);
-- ddl-end --
COMMENT ON TABLE col.export_template IS E'List of models of export';
-- ddl-end --
COMMENT ON COLUMN col.export_template.export_template_name IS E'Name of the model';
-- ddl-end --
COMMENT ON COLUMN col.export_template.export_template_description IS E'Description of the model';
-- ddl-end --
COMMENT ON COLUMN col.export_template.export_template_version IS E'Version of the model, if necessary';
-- ddl-end --
COMMENT ON COLUMN col.export_template.is_zipped IS E'Specify if the generated files must be zipped';
-- ddl-end --
COMMENT ON COLUMN col.export_template.filename IS E'Name of the file generated';
-- ddl-end --
ALTER TABLE col.export_template OWNER TO collec;
-- ddl-end --

-- object: export_template_fk | type: CONSTRAINT --
-- ALTER TABLE col.export DROP CONSTRAINT IF EXISTS export_template_fk CASCADE;
ALTER TABLE col.export ADD CONSTRAINT export_template_fk FOREIGN KEY (export_template_id)
REFERENCES col.export_template (export_template_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: col.dataset_template | type: TABLE --
-- DROP TABLE IF EXISTS col.dataset_template CASCADE;
CREATE TABLE col.dataset_template (
	dataset_template_id serial NOT NULL,
	dataset_template_name varchar NOT NULL,
	export_format_id integer NOT NULL,
	only_last_document boolean DEFAULT false,
	separator varchar,
	filename varchar NOT NULL DEFAULT 'cs-export.csv',
	xmlroot varchar,
	xmlnodename varchar DEFAULT 'sample',
	xslcontent varchar,
	dataset_type_id integer NOT NULL,
	CONSTRAINT dataset_template_pk PRIMARY KEY (dataset_template_id)
);
-- ddl-end --
COMMENT ON TABLE col.dataset_template IS E'List of templates of dataset';
-- ddl-end --
COMMENT ON COLUMN col.dataset_template.dataset_template_name IS E'Name of the template';
-- ddl-end --
COMMENT ON COLUMN col.dataset_template.only_last_document IS E'If type document, specify if only the last document attached to a sample is exported';
-- ddl-end --
COMMENT ON COLUMN col.dataset_template.separator IS E'Separator used in csv files (tab , ;)';
-- ddl-end --
COMMENT ON COLUMN col.dataset_template.filename IS E'File name generated, with extension';
-- ddl-end --
COMMENT ON COLUMN col.dataset_template.xmlroot IS E'xml root to generate';
-- ddl-end --
COMMENT ON COLUMN col.dataset_template.xmlnodename IS E'Name of a node in a xml file, for list of samples by example';
-- ddl-end --
COMMENT ON COLUMN col.dataset_template.xslcontent IS E'Transformation of the generated xml to create a specific xml file';
-- ddl-end --
ALTER TABLE col.dataset_template OWNER TO collec;
-- ddl-end --

-- object: col.export_format | type: TABLE --
-- DROP TABLE IF EXISTS col.export_format CASCADE;
CREATE TABLE col.export_format (
	export_format_id serial NOT NULL,
	export_format_name varchar NOT NULL,
	CONSTRAINT export_format_pk PRIMARY KEY (export_format_id)
);
-- ddl-end --
COMMENT ON TABLE col.export_format IS E'List of formats of export';
-- ddl-end --
ALTER TABLE col.export_format OWNER TO collec;
-- ddl-end --

INSERT INTO col.export_format (export_format_id, export_format_name) VALUES (E'1', E'CSV');
-- ddl-end --
INSERT INTO col.export_format (export_format_id, export_format_name) VALUES (E'2', E'JSON');
-- ddl-end --
INSERT INTO col.export_format (export_format_id, export_format_name) VALUES (E'3', E'XML');
-- ddl-end --

-- object: export_format_fk | type: CONSTRAINT --
-- ALTER TABLE col.dataset_template DROP CONSTRAINT IF EXISTS export_format_fk CASCADE;
ALTER TABLE col.dataset_template ADD CONSTRAINT export_format_fk FOREIGN KEY (export_format_id)
REFERENCES col.export_format (export_format_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: col.export_dataset | type: TABLE --
-- DROP TABLE IF EXISTS col.export_dataset CASCADE;
CREATE TABLE col.export_dataset (
	export_template_id integer NOT NULL,
	dataset_template_id integer NOT NULL,
	CONSTRAINT export_dataset_pk PRIMARY KEY (export_template_id,dataset_template_id) DEFERRABLE INITIALLY IMMEDIATE
);
-- ddl-end --
COMMENT ON TABLE col.export_dataset IS E'List of datasets embedded into the template of export';
-- ddl-end --
ALTER TABLE col.export_dataset OWNER TO collec;
-- ddl-end --

-- object: export_template_fk | type: CONSTRAINT --
-- ALTER TABLE col.export_dataset DROP CONSTRAINT IF EXISTS export_template_fk CASCADE;
ALTER TABLE col.export_dataset ADD CONSTRAINT export_template_fk FOREIGN KEY (export_template_id)
REFERENCES col.export_template (export_template_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: dataset_template_fk | type: CONSTRAINT --
-- ALTER TABLE col.export_dataset DROP CONSTRAINT IF EXISTS dataset_template_fk CASCADE;
ALTER TABLE col.export_dataset ADD CONSTRAINT dataset_template_fk FOREIGN KEY (dataset_template_id)
REFERENCES col.dataset_template (dataset_template_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: col.dataset_column | type: TABLE --
-- DROP TABLE IF EXISTS col.dataset_column CASCADE;
CREATE TABLE col.dataset_column (
	dataset_column_id serial NOT NULL,
	dataset_template_id integer NOT NULL,
	column_name varchar NOT NULL,
	export_name varchar NOT NULL,
	subfield_name varchar,
	column_order smallint DEFAULT 1,
	mandatory boolean DEFAULT 'f',
	default_value varchar,
	date_format varchar,
	search_order smallint,
	translator_id integer,
	CONSTRAINT dataset_column_pk PRIMARY KEY (dataset_column_id)
);
-- ddl-end --
COMMENT ON TABLE col.dataset_column IS E'List of columns included into the dataset';
-- ddl-end --
COMMENT ON COLUMN col.dataset_column.column_name IS E'Name of the column into the database';
-- ddl-end --
COMMENT ON COLUMN col.dataset_column.export_name IS E'Name of the column into the export file';
-- ddl-end --
COMMENT ON COLUMN col.dataset_column.subfield_name IS E'Name of the field if it into the metadata description of the sample or secondary identifier, etc.';
-- ddl-end --
COMMENT ON COLUMN col.dataset_column.column_order IS E'order of displaying in the exported file';
-- ddl-end --
COMMENT ON COLUMN col.dataset_column.mandatory IS E'Is the content of the column is mandatory to export data?';
-- ddl-end --
COMMENT ON COLUMN col.dataset_column.default_value IS E'Default value, if the value is not filled in';
-- ddl-end --
COMMENT ON COLUMN col.dataset_column.date_format IS E'Export date format, in php notation. Example: d/m/Y H:i:s for 25/12/2020 17:15:00';
-- ddl-end --
COMMENT ON COLUMN col.dataset_column.search_order IS E'To search a sample, order of the current field to trigger the search';
-- ddl-end --
ALTER TABLE col.dataset_column OWNER TO collec;
-- ddl-end --

-- object: dataset_template_fk | type: CONSTRAINT --
-- ALTER TABLE col.dataset_column DROP CONSTRAINT IF EXISTS dataset_template_fk CASCADE;
ALTER TABLE col.dataset_column ADD CONSTRAINT dataset_template_fk FOREIGN KEY (dataset_template_id)
REFERENCES col.dataset_template (dataset_template_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: col.translator | type: TABLE --
-- DROP TABLE IF EXISTS col.translator CASCADE;
CREATE TABLE col.translator (
	translator_id serial NOT NULL,
	translator_name varchar NOT NULL,
	translator_data json,
	CONSTRAINT translator_pk PRIMARY KEY (translator_id)
);
-- ddl-end --
COMMENT ON TABLE col.translator IS E'Table of translator of values';
-- ddl-end --
COMMENT ON COLUMN col.translator.translator_data IS E'List of translations under the form term_in_database:term_in_the_export_file';
-- ddl-end --
ALTER TABLE col.translator OWNER TO collec;
-- ddl-end --

-- object: translator_fk | type: CONSTRAINT --
-- ALTER TABLE col.dataset_column DROP CONSTRAINT IF EXISTS translator_fk CASCADE;
ALTER TABLE col.dataset_column ADD CONSTRAINT translator_fk FOREIGN KEY (translator_id)
REFERENCES col.translator (translator_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: col.dataset_type | type: TABLE --
-- DROP TABLE IF EXISTS col.dataset_type CASCADE;
CREATE TABLE col.dataset_type (
	dataset_type_id serial NOT NULL,
	dataset_type_name varchar NOT NULL,
	fields json,
	CONSTRAINT dataset_type_pk PRIMARY KEY (dataset_type_id)
);
-- ddl-end --
COMMENT ON TABLE col.dataset_type IS E'Origine of the dataset: sample, collection, document';
-- ddl-end --
COMMENT ON COLUMN col.dataset_type.fields IS E'List of allowed fields of the database (json array)';
-- ddl-end --
ALTER TABLE col.dataset_type OWNER TO collec;
-- ddl-end --

INSERT INTO col.dataset_type (dataset_type_id, dataset_type_name, fields) VALUES (E'1', E'sample', E'["uid","uuid","identifier","wgs84_x","wgs84_y","location_accuracy","object_status_name","referent_name","referent_email","address_name","address_line2","address_line3","address_city","address_country","referent_phone","referent_firstname","academic_directory","academic_link","object_comment","identifiers","sample_creation_date","sampling_date","multiple_value","sampling_place_name","expiration_date","sample_type_name","storage_product","clp_classification","multiple_type_name","collection_name","metadata","metadata_unit","parent_uid","parent_uuid","parent_identifiers","web_address","content_type","container_uid","container_identifier","container_uuid","storage_type_name","fixed_value","country_code","country_origin_code","trashed","campaign_id","campaign_name","campaign_uuid"]');
-- ddl-end --
INSERT INTO col.dataset_type (dataset_type_id, dataset_type_name, fields) VALUES (E'2', E'collection', E'["collection_name","collection_displayname","collection_keywords","referent_name","referent_firstname","academical_directory","academical_link","referent_email","address_name","address_line2","address_line3","address_city","address_country","referent_phone","fixed_value"]');
-- ddl-end --
INSERT INTO col.dataset_type (dataset_type_id, dataset_type_name, fields) VALUES (E'3', E'document', E'["document_name","document_uuid","uid","sample_uuid","identifier","content_type","extension","size","document_creation_date","fixed_value", "web_address"]');
-- ddl-end --
INSERT INTO col.dataset_type (dataset_type_id, dataset_type_name, fields) VALUES (E'4', E'arbitrary content', E'["content"]');
-- ddl-end --

-- object: dataset_type_fk | type: CONSTRAINT --
-- ALTER TABLE col.dataset_template DROP CONSTRAINT IF EXISTS dataset_type_fk CASCADE;
ALTER TABLE col.dataset_template ADD CONSTRAINT dataset_type_fk FOREIGN KEY (dataset_type_id)
REFERENCES col.dataset_type (dataset_type_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: col.samplesearch | type: TABLE --
-- DROP TABLE IF EXISTS col.samplesearch CASCADE;
CREATE TABLE col.samplesearch (
	samplesearch_id serial NOT NULL,
	samplesearch_name varchar NOT NULL,
	samplesearch_data json,
	samplesearch_login varchar,
	collection_id integer

);
-- ddl-end --
COMMENT ON TABLE col.samplesearch IS E'List of sample saved search';
-- ddl-end --
COMMENT ON COLUMN col.samplesearch.samplesearch_name IS E'Name of the search parameters';
-- ddl-end --
COMMENT ON COLUMN col.samplesearch.samplesearch_data IS E'List of all research parameters';
-- ddl-end --
COMMENT ON COLUMN col.samplesearch.samplesearch_login IS E'Login of the creator';
-- ddl-end --
ALTER TABLE col.samplesearch OWNER TO collec;
-- ddl-end --

-- object: collection_fk | type: CONSTRAINT --
-- ALTER TABLE col.samplesearch DROP CONSTRAINT IF EXISTS collection_fk CASCADE;
ALTER TABLE col.samplesearch ADD CONSTRAINT collection_fk FOREIGN KEY (collection_id)
REFERENCES col.collection (collection_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: col.license | type: TABLE --
-- DROP TABLE IF EXISTS col.license CASCADE;
CREATE TABLE col.license (
	license_id serial NOT NULL,
	license_name varchar NOT NULL,
	license_url varchar,
	CONSTRAINT license_pk PRIMARY KEY (license_id)
);
-- ddl-end --
COMMENT ON TABLE col.license IS E'List of licenses usable to communicate informations on the collections';
-- ddl-end --
COMMENT ON COLUMN col.license.license_name IS E'Name of the license';
-- ddl-end --
COMMENT ON COLUMN col.license.license_url IS E'Link of download of the text of the license';
-- ddl-end --
ALTER TABLE col.license OWNER TO collec;
-- ddl-end --

INSERT INTO col.license (license_name, license_url) VALUES (E'CC0', E'https://creativecommons.org/publicdomain/zero/1.0/');
-- ddl-end --
INSERT INTO col.license (license_name, license_url) VALUES (E'CCBY', E'https://creativecommons.org/licenses/by/4.0/');
-- ddl-end --

-- object: license_fk | type: CONSTRAINT --
-- ALTER TABLE col.collection DROP CONSTRAINT IF EXISTS license_fk CASCADE;
ALTER TABLE col.collection ADD CONSTRAINT license_fk FOREIGN KEY (license_id)
REFERENCES col.license (license_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: export_template_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.export_template_name_idx CASCADE;
CREATE UNIQUE INDEX export_template_name_idx ON col.export_template
USING btree
(
	export_template_name
);
-- ddl-end --

-- object: dataset_template_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.dataset_template_name_idx CASCADE;
CREATE UNIQUE INDEX dataset_template_name_idx ON col.dataset_template
USING btree
(
	dataset_template_name
);
-- ddl-end --

-- object: collection_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.collection_name_idx CASCADE;
CREATE UNIQUE INDEX collection_name_idx ON col.collection
USING btree
(
	collection_name
);
-- ddl-end --

-- object: license_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.license_name_idx CASCADE;
CREATE UNIQUE INDEX license_name_idx ON col.license
USING btree
(
	license_name
);
-- ddl-end --

-- object: sample_type_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.sample_type_name_idx CASCADE;
CREATE UNIQUE INDEX sample_type_name_idx ON col.sample_type
USING btree
(
	sample_type_name
);
-- ddl-end --

-- object: multiple_type_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.multiple_type_name_idx CASCADE;
CREATE UNIQUE INDEX multiple_type_name_idx ON col.multiple_type
USING btree
(
	multiple_type_name
);
-- ddl-end --

-- object: campaign_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.campaign_name_idx CASCADE;
CREATE UNIQUE INDEX campaign_name_idx ON col.campaign
USING btree
(
	campaign_name
);
-- ddl-end --

-- object: regulation_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.regulation_name_idx CASCADE;
CREATE UNIQUE INDEX regulation_name_idx ON col.regulation
USING btree
(
	regulation_name
);
-- ddl-end --

-- object: mime_type_extension_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.mime_type_extension_idx CASCADE;
CREATE UNIQUE INDEX mime_type_extension_idx ON col.mime_type
USING btree
(
	extension
);
-- ddl-end --

-- object: event_type_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.event_type_name_idx CASCADE;
CREATE UNIQUE INDEX event_type_name_idx ON col.event_type
USING btree
(
	event_type_name
);
-- ddl-end --

-- object: identifier_type_code_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.identifier_type_code_idx CASCADE;
CREATE UNIQUE INDEX identifier_type_code_idx ON col.identifier_type
USING btree
(
	identifier_type_code
);
-- ddl-end --

-- object: object_status_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.object_status_name_idx CASCADE;
CREATE UNIQUE INDEX object_status_name_idx ON col.object_status
USING btree
(
	object_status_name
);
-- ddl-end --

-- object: borrower_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.borrower_name_idx CASCADE;
CREATE UNIQUE INDEX borrower_name_idx ON col.borrower
USING btree
(
	borrower_name
);
-- ddl-end --

-- object: container_family_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.container_family_name_idx CASCADE;
CREATE UNIQUE INDEX container_family_name_idx ON col.container_family
USING btree
(
	container_family_name
);
-- ddl-end --

-- object: storage_condition_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.storage_condition_name_idx CASCADE;
CREATE UNIQUE INDEX storage_condition_name_idx ON col.storage_condition
USING btree
(
	storage_condition_name
);
-- ddl-end --

-- object: col.country | type: TABLE --
-- DROP TABLE IF EXISTS col.country CASCADE;
CREATE TABLE col.country (
	country_id integer NOT NULL,
	country_name varchar NOT NULL,
	country_code2 varchar(2) NOT NULL,
	country_code3 varchar(3),
	CONSTRAINT country_pk PRIMARY KEY (country_id)
);
-- ddl-end --
COMMENT ON TABLE col.country IS E'List of the countries';
-- ddl-end --
COMMENT ON COLUMN col.country.country_id IS E'Numeric ISO code of the country';
-- ddl-end --
COMMENT ON COLUMN col.country.country_name IS E'Name of the country';
-- ddl-end --
COMMENT ON COLUMN col.country.country_code2 IS E'Code of the country, on 2 positions';
-- ddl-end --
COMMENT ON COLUMN col.country.country_code3 IS E'Code of the country, on 3 positions';
-- ddl-end --
ALTER TABLE col.country OWNER TO collec;
-- ddl-end --

INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'4', E'Afghanistan', E'AF', E'AFG');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'248', E'Îles Åland', E'AX', E'ALA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'8', E'Albanie', E'AL', E'ALB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'12', E'Algérie', E'DZ', E'DZA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'16', E'Samoa américaines', E'AS', E'ASM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'20', E'Andorre', E'AD', E'AND');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'24', E'Angola', E'AO', E'AGO');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'660', E'Anguilla', E'AI', E'AIA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'10', E'Antarctique', E'AQ', E'ATA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'28', E'Antigua-et-Barbuda', E'AG', E'ATG');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'32', E'Argentine', E'AR', E'ARG');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'51', E'Arménie', E'AM', E'ARM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'533', E'Aruba', E'AW', E'ABW');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'36', E'Australie', E'AU', E'AUS');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'40', E'Autriche', E'AT', E'AUT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'31', E'Azerbaïdjan', E'AZ', E'AZE');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'44', E'Bahamas', E'BS', E'BHS');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'48', E'Bahreïn', E'BH', E'BHR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'50', E'Bangladesh', E'BD', E'BGD');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'52', E'Barbade', E'BB', E'BRB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'112', E'Biélorussie', E'BY', E'BLR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'56', E'Belgique', E'BE', E'BEL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'84', E'Belize', E'BZ', E'BLZ');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'204', E'Bénin', E'BJ', E'BEN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'60', E'Bermudes', E'BM', E'BMU');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'64', E'Bhoutan', E'BT', E'BTN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'68', E'Bolivie', E'BO', E'BOL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'70', E'Bosnie-Herzégovine', E'BA', E'BIH');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'72', E'Botswana', E'BW', E'BWA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'74', E'Île Bouvet', E'BV', E'BVT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'76', E'Brésil', E'BR', E'BRA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'92', E'British Virgin Islands', E'VG', E'VGB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'86', E'Territoire britannique de l’Océan Indien', E'IO', E'IOT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'96', E'Brunei Darussalam', E'BN', E'BRN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'100', E'Bulgarie', E'BG', E'BGR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'854', E'Burkina Faso', E'BF', E'BFA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'108', E'Burundi', E'BI', E'BDI');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'116', E'Cambodge', E'KH', E'KHM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'120', E'Cameroun', E'CM', E'CMR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'124', E'Canada', E'CA', E'CAN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'132', E'Cap-Vert', E'CV', E'CPV');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'136', E'Iles Cayman', E'KY', E'CYM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'140', E'République centrafricaine', E'CF', E'CAF');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'148', E'Tchad', E'TD', E'TCD');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'152', E'Chili', E'CL', E'CHL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'156', E'Chine', E'CN', E'CHN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'344', E'Hong Kong', E'HK', E'HKG');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'446', E'Macao', E'MO', E'MAC');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'162', E'Île Christmas', E'CX', E'CXR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'166', E'Îles Cocos', E'CC', E'CCK');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'170', E'Colombie', E'CO', E'COL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'174', E'Comores', E'KM', E'COM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'178', E'République du Congo', E'CG', E'COG');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'180', E'République démocratique du Congo', E'CD', E'COD');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'184', E'Îles Cook', E'CK', E'COK');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'188', E'Costa Rica', E'CR', E'CRI');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'384', E'Côte d’Ivoire', E'CI', E'CIV');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'191', E'Croatie', E'HR', E'HRV');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'192', E'Cuba', E'CU', E'CUB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'196', E'Chypre', E'CY', E'CYP');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'203', E'République tchèque', E'CZ', E'CZE');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'208', E'Danemark', E'DK', E'DNK');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'262', E'Djibouti', E'DJ', E'DJI');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'212', E'Dominique', E'DM', E'DMA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'214', E'République dominicaine', E'DO', E'DOM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'218', E'Équateur', E'EC', E'ECU');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'818', E'Égypte', E'EG', E'EGY');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'222', E'Salvador', E'SV', E'SLV');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'226', E'Guinée équatoriale', E'GQ', E'GNQ');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'232', E'Érythrée', E'ER', E'ERI');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'233', E'Estonie', E'EE', E'EST');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'231', E'Éthiopie', E'ET', E'ETH');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'238', E'Îles Falkland', E'FK', E'FLK');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'234', E'Îles Féroé', E'FO', E'FRO');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'242', E'Fidji', E'FJ', E'FJI');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'246', E'Finlande', E'FI', E'FIN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'250', E'France', E'FR', E'FRA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'254', E'Guyane française', E'GF', E'GUF');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'258', E'Polynésie française', E'PF', E'PYF');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'260', E'Terres australes et antarctiques françaises', E'TF', E'ATF');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'266', E'Gabon', E'GA', E'GAB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'270', E'Gambie', E'GM', E'GMB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'268', E'Géorgie', E'GE', E'GEO');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'276', E'Allemagne', E'DE', E'DEU');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'288', E'Ghana', E'GH', E'GHA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'292', E'Gibraltar', E'GI', E'GIB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'300', E'Grèce', E'GR', E'GRC');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'304', E'Groenland', E'GL', E'GRL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'308', E'Grenade', E'GD', E'GRD');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'312', E'Guadeloupe', E'GP', E'GLP');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'316', E'Guam', E'GU', E'GUM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'320', E'Guatemala', E'GT', E'GTM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'831', E'Guernesey', E'GG', E'GGY');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'324', E'Guinée', E'GN', E'GIN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'624', E'Guinée-Bissau', E'GW', E'GNB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'328', E'Guyane', E'GY', E'GUY');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'332', E'Haïti', E'HT', E'HTI');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'334', E'Îles Heard-et-MacDonald', E'HM', E'HMD');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'336', E'Saint-Siège (Vatican)', E'VA', E'VAT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'340', E'Honduras', E'HN', E'HND');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'348', E'Hongrie', E'HU', E'HUN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'352', E'Islande', E'IS', E'ISL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'356', E'Inde', E'IN', E'IND');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'360', E'Indonésie', E'ID', E'IDN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'364', E'Iran', E'IR', E'IRN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'368', E'Irak', E'IQ', E'IRQ');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'372', E'Irlande', E'IE', E'IRL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'833', E'Ile de Man', E'IM', E'IMN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'376', E'Israël', E'IL', E'ISR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'380', E'Italie', E'IT', E'ITA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'388', E'Jamaïque', E'JM', E'JAM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'392', E'Japon', E'JP', E'JPN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'832', E'Jersey', E'JE', E'JEY');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'400', E'Jordanie', E'JO', E'JOR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'398', E'Kazakhstan', E'KZ', E'KAZ');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'404', E'Kenya', E'KE', E'KEN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'296', E'Kiribati', E'KI', E'KIR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'408', E'Corée du Nord', E'KP', E'PRK');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'410', E'Corée du Sud', E'KR', E'KOR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'414', E'Koweït', E'KW', E'KWT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'417', E'Kirghizistan', E'KG', E'KGZ');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'418', E'Laos', E'LA', E'LAO');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'428', E'Lettonie', E'LV', E'LVA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'422', E'Liban', E'LB', E'LBN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'426', E'Lesotho', E'LS', E'LSO');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'430', E'Libéria', E'LR', E'LBR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'434', E'Libye', E'LY', E'LBY');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'438', E'Liechtenstein', E'LI', E'LIE');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'440', E'Lituanie', E'LT', E'LTU');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'442', E'Luxembourg', E'LU', E'LUX');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'807', E'Macédoine', E'MK', E'MKD');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'450', E'Madagascar', E'MG', E'MDG');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'454', E'Malawi', E'MW', E'MWI');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'458', E'Malaisie', E'MY', E'MYS');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'462', E'Maldives', E'MV', E'MDV');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'466', E'Mali', E'ML', E'MLI');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'470', E'Malte', E'MT', E'MLT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'584', E'Îles Marshall', E'MH', E'MHL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'474', E'Martinique', E'MQ', E'MTQ');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'478', E'Mauritanie', E'MR', E'MRT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'480', E'Maurice', E'MU', E'MUS');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'175', E'Mayotte', E'YT', E'MYT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'484', E'Mexique', E'MX', E'MEX');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'583', E'Micronésie', E'FM', E'FSM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'498', E'Moldavie', E'MD', E'MDA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'492', E'Monaco', E'MC', E'MCO');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'496', E'Mongolie', E'MN', E'MNG');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'499', E'Monténégro', E'ME', E'MNE');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'500', E'Montserrat', E'MS', E'MSR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'504', E'Maroc', E'MA', E'MAR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'508', E'Mozambique', E'MZ', E'MOZ');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'104', E'Myanmar', E'MM', E'MMR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'516', E'Namibie', E'NA', E'NAM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'520', E'Nauru', E'NR', E'NRU');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'524', E'Népal', E'NP', E'NPL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'528', E'Pays-Bas', E'NL', E'NLD');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'540', E'Nouvelle-Calédonie', E'NC', E'NCL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'554', E'Nouvelle-Zélande', E'NZ', E'NZL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'558', E'Nicaragua', E'NI', E'NIC');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'562', E'Niger', E'NE', E'NER');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'566', E'Nigeria', E'NG', E'NGA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'570', E'Niue', E'NU', E'NIU');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'574', E'Île Norfolk', E'NF', E'NFK');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'580', E'Îles Mariannes du Nord', E'MP', E'MNP');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'578', E'Norvège', E'NO', E'NOR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'512', E'Oman', E'OM', E'OMN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'586', E'Pakistan', E'PK', E'PAK');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'585', E'Palau', E'PW', E'PLW');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'275', E'Palestine', E'PS', E'PSE');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'591', E'Panama', E'PA', E'PAN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'598', E'Papouasie-Nouvelle-Guinée', E'PG', E'PNG');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'600', E'Paraguay', E'PY', E'PRY');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'604', E'Pérou', E'PE', E'PER');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'608', E'Philippines', E'PH', E'PHL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'612', E'Pitcairn', E'PN', E'PCN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'616', E'Pologne', E'PL', E'POL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'620', E'Portugal', E'PT', E'PRT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'630', E'Puerto Rico', E'PR', E'PRI');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'634', E'Qatar', E'QA', E'QAT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'638', E'Réunion', E'RE', E'REU');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'642', E'Roumanie', E'RO', E'ROU');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'643', E'Russie', E'RU', E'RUS');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'646', E'Rwanda', E'RW', E'RWA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'652', E'Saint-Barthélemy', E'BL', E'BLM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'654', E'Sainte-Hélène', E'SH', E'SHN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'659', E'Saint-Kitts-et-Nevis', E'KN', E'KNA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'662', E'Sainte-Lucie', E'LC', E'LCA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'663', E'Saint-Martin (partie française)', E'MF', E'MAF');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'534', E'Saint-Martin (partie néerlandaise)', E'SX', E'SXM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'666', E'Saint-Pierre-et-Miquelon', E'PM', E'SPM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'670', E'Saint-Vincent-et-les Grenadines', E'VC', E'VCT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'882', E'Samoa', E'WS', E'WSM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'674', E'Saint-Marin', E'SM', E'SMR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'678', E'Sao Tomé-et-Principe', E'ST', E'STP');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'682', E'Arabie Saoudite', E'SA', E'SAU');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'686', E'Sénégal', E'SN', E'SEN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'688', E'Serbie', E'RS', E'SRB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'690', E'Seychelles', E'SC', E'SYC');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'694', E'Sierra Leone', E'SL', E'SLE');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'702', E'Singapour', E'SG', E'SGP');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'703', E'Slovaquie', E'SK', E'SVK');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'705', E'Slovénie', E'SI', E'SVN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'90', E'Îles Salomon', E'SB', E'SLB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'706', E'Somalie', E'SO', E'SOM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'710', E'Afrique du Sud', E'ZA', E'ZAF');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'239', E'Géorgie du Sud et les îles Sandwich du Sud', E'GS', E'SGS');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'728', E'Sud-Soudan', E'SS', E'SSD');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'724', E'Espagne', E'ES', E'ESP');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'144', E'Sri Lanka', E'LK', E'LKA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'736', E'Soudan', E'SD', E'SDN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'740', E'Suriname', E'SR', E'SUR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'744', E'Svalbard et Jan Mayen', E'SJ', E'SJM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'748', E'Eswatini', E'SZ', E'SWZ');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'752', E'Suède', E'SE', E'SWE');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'756', E'Suisse', E'CH', E'CHE');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'760', E'Syrie', E'SY', E'SYR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'158', E'Taiwan', E'TW', E'TWN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'762', E'Tadjikistan', E'TJ', E'TJK');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'834', E'Tanzanie', E'TZ', E'TZA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'764', E'Thaïlande', E'TH', E'THA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'626', E'Timor-Leste', E'TL', E'TLS');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'768', E'Togo', E'TG', E'TGO');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'772', E'Tokelau', E'TK', E'TKL');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'776', E'Tonga', E'TO', E'TON');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'780', E'Trinité-et-Tobago', E'TT', E'TTO');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'788', E'Tunisie', E'TN', E'TUN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'792', E'Turquie', E'TR', E'TUR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'795', E'Turkménistan', E'TM', E'TKM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'796', E'Îles Turques-et-Caïques', E'TC', E'TCA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'798', E'Tuvalu', E'TV', E'TUV');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'800', E'Ouganda', E'UG', E'UGA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'804', E'Ukraine', E'UA', E'UKR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'784', E'Émirats Arabes Unis', E'AE', E'ARE');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'826', E'Royaume-Uni', E'GB', E'GBR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'840', E'États-Unis', E'US', E'USA');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'581', E'Îles mineures éloignées des États-Unis', E'UM', E'UMI');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'858', E'Uruguay', E'UY', E'URY');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'860', E'Ouzbékistan', E'UZ', E'UZB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'548', E'Vanuatu', E'VU', E'VUT');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'862', E'Venezuela', E'VE', E'VEN');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'704', E'Viêt Nam', E'VN', E'VNM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'850', E'Îles Vierges américaines', E'VI', E'VIR');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'876', E'Wallis-et-Futuna', E'WF', E'WLF');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'732', E'Sahara occidental', E'EH', E'ESH');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'887', E'Yémen', E'YE', E'YEM');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'894', E'Zambie', E'ZM', E'ZMB');
-- ddl-end --
INSERT INTO col.country (country_id, country_name, country_code2, country_code3) VALUES (E'716', E'Zimbabwe', E'ZW', E'ZWE');
-- ddl-end --

-- object: country_code2_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.country_code2_idx CASCADE;
CREATE INDEX country_code2_idx ON col.country
USING btree
(
	country_code2
);
-- ddl-end --

-- object: country_fk | type: CONSTRAINT --
-- ALTER TABLE col.sample DROP CONSTRAINT IF EXISTS country_fk CASCADE;
ALTER TABLE col.sample ADD CONSTRAINT country_fk FOREIGN KEY (country_id)
REFERENCES col.country (country_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: country_fk | type: CONSTRAINT --
-- ALTER TABLE col.sampling_place DROP CONSTRAINT IF EXISTS country_fk CASCADE;
ALTER TABLE col.sampling_place ADD CONSTRAINT country_fk FOREIGN KEY (country_id)
REFERENCES col.country (country_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: country_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.country_id_idx CASCADE;
CREATE INDEX country_id_idx ON col.sample
USING btree
(
	country_id
);
-- ddl-end --

-- object: campaign_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.campaign_id_idx CASCADE;
CREATE INDEX campaign_id_idx ON col.campaign_regulation
USING btree
(
	campaign_id
);
-- ddl-end --

-- object: sample_campaign_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.sample_campaign_id_idx CASCADE;
CREATE INDEX sample_campaign_id_idx ON col.sample
USING btree
(
	campaign_id
);
-- ddl-end --

-- object: col.v_subsample_quantity | type: VIEW --
-- DROP VIEW IF EXISTS col.v_subsample_quantity CASCADE;
CREATE VIEW col.v_subsample_quantity
AS

select sample_id, uid, multiple_value,
coalesce ((select sum(subsample_quantity) from col.subsample smore where smore.movement_type_id = 1 and smore.sample_id = s.sample_id),0) as subsample_more,
coalesce ((select sum(subsample_quantity) from col.subsample sless where sless.movement_type_id  = 2 and sless.sample_id = s.sample_id),0) as subsample_less
from col.sample s;
-- ddl-end --
ALTER VIEW col.v_subsample_quantity OWNER TO collec;
-- ddl-end --

-- object: country_fk1 | type: CONSTRAINT --
-- ALTER TABLE col.sample DROP CONSTRAINT IF EXISTS country_fk1 CASCADE;
ALTER TABLE col.sample ADD CONSTRAINT country_fk1 FOREIGN KEY (country_origin_id)
REFERENCES col.country (country_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: acllogin_login_idx | type: INDEX --
-- DROP INDEX IF EXISTS gacl.acllogin_login_idx CASCADE;
CREATE UNIQUE INDEX acllogin_login_idx ON gacl.acllogin
USING btree
(
	login
);
-- ddl-end --

-- object: col.barcode | type: TABLE --
-- DROP TABLE IF EXISTS col.barcode CASCADE;
CREATE TABLE col.barcode (
	barcode_id serial NOT NULL,
	barcode_name varchar NOT NULL,
	barcode_code varchar NOT NULL DEFAULT 'QR',
	CONSTRAINT barcode_type_pk PRIMARY KEY (barcode_id)
);
-- ddl-end --
COMMENT ON TABLE col.barcode IS E'Models of barcodes usable';
-- ddl-end --
COMMENT ON COLUMN col.barcode.barcode_name IS E'Name of the model';
-- ddl-end --
COMMENT ON COLUMN col.barcode.barcode_code IS E'Value of the barcode used by the generating application, if occures. Default value: QR for QRcode';
-- ddl-end --
ALTER TABLE col.barcode OWNER TO collec;
-- ddl-end --

INSERT INTO col.barcode (barcode_name, barcode_code) VALUES (E'QRCode', E'QR');
-- ddl-end --
INSERT INTO col.barcode (barcode_name, barcode_code) VALUES (E'EAN 128', E'C128');
-- ddl-end --

-- object: barcode_fk | type: CONSTRAINT --
-- ALTER TABLE col.label DROP CONSTRAINT IF EXISTS barcode_fk CASCADE;
ALTER TABLE col.label ADD CONSTRAINT barcode_fk FOREIGN KEY (barcode_id)
REFERENCES col.barcode (barcode_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: borrower | type: CONSTRAINT --
-- ALTER TABLE col.subsample DROP CONSTRAINT IF EXISTS borrower CASCADE;
ALTER TABLE col.subsample ADD CONSTRAINT borrower FOREIGN KEY (borrower_id)
REFERENCES col.borrower (borrower_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: collection | type: CONSTRAINT --
-- ALTER TABLE col.request DROP CONSTRAINT IF EXISTS collection CASCADE;
ALTER TABLE col.request ADD CONSTRAINT collection FOREIGN KEY (collection_id)
REFERENCES col.collection (collection_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: external_storage_path_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.external_storage_path_idx CASCADE;
CREATE INDEX external_storage_path_idx ON col.document
USING btree
(
	external_storage_path
);
-- ddl-end --

-- object: uid_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.uid_idx CASCADE;
CREATE INDEX uid_idx ON col.document
USING btree
(
	uid
);
-- ddl-end --

-- object: object_booking_fk | type: CONSTRAINT --
-- ALTER TABLE col.booking DROP CONSTRAINT IF EXISTS object_booking_fk CASCADE;
ALTER TABLE col.booking ADD CONSTRAINT object_booking_fk FOREIGN KEY (uid)
REFERENCES col.object (uid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: group_projet_aclgroup_fk | type: CONSTRAINT --
-- ALTER TABLE col.collection_group DROP CONSTRAINT IF EXISTS group_projet_aclgroup_fk CASCADE;
ALTER TABLE col.collection_group ADD CONSTRAINT group_projet_aclgroup_fk FOREIGN KEY (aclgroup_id)
REFERENCES gacl.aclgroup (aclgroup_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: project_projet_group_fk | type: CONSTRAINT --
-- ALTER TABLE col.collection_group DROP CONSTRAINT IF EXISTS project_projet_group_fk CASCADE;
ALTER TABLE col.collection_group ADD CONSTRAINT project_projet_group_fk FOREIGN KEY (collection_id)
REFERENCES col.collection (collection_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: container_type_container_fk | type: CONSTRAINT --
-- ALTER TABLE col.container DROP CONSTRAINT IF EXISTS container_type_container_fk CASCADE;
ALTER TABLE col.container ADD CONSTRAINT container_type_container_fk FOREIGN KEY (container_type_id)
REFERENCES col.container_type (container_type_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: object_container_fk | type: CONSTRAINT --
-- ALTER TABLE col.container DROP CONSTRAINT IF EXISTS object_container_fk CASCADE;
ALTER TABLE col.container ADD CONSTRAINT object_container_fk FOREIGN KEY (uid)
REFERENCES col.object (uid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: container_family_container_type_fk | type: CONSTRAINT --
-- ALTER TABLE col.container_type DROP CONSTRAINT IF EXISTS container_family_container_type_fk CASCADE;
ALTER TABLE col.container_type ADD CONSTRAINT container_family_container_type_fk FOREIGN KEY (container_family_id)
REFERENCES col.container_family (container_family_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: label_container_type_fk | type: CONSTRAINT --
-- ALTER TABLE col.container_type DROP CONSTRAINT IF EXISTS label_container_type_fk CASCADE;
ALTER TABLE col.container_type ADD CONSTRAINT label_container_type_fk FOREIGN KEY (label_id)
REFERENCES col.label (label_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: storage_condition_container_type_fk | type: CONSTRAINT --
-- ALTER TABLE col.container_type DROP CONSTRAINT IF EXISTS storage_condition_container_type_fk CASCADE;
ALTER TABLE col.container_type ADD CONSTRAINT storage_condition_container_type_fk FOREIGN KEY (storage_condition_id)
REFERENCES col.storage_condition (storage_condition_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: mime_type_document_fk | type: CONSTRAINT --
-- ALTER TABLE col.document DROP CONSTRAINT IF EXISTS mime_type_document_fk CASCADE;
ALTER TABLE col.document ADD CONSTRAINT mime_type_document_fk FOREIGN KEY (mime_type_id)
REFERENCES col.mime_type (mime_type_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: object_document_fk | type: CONSTRAINT --
-- ALTER TABLE col.document DROP CONSTRAINT IF EXISTS object_document_fk CASCADE;
ALTER TABLE col.document ADD CONSTRAINT object_document_fk FOREIGN KEY (uid)
REFERENCES col.object (uid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: event_type_event_fk | type: CONSTRAINT --
-- ALTER TABLE col.event DROP CONSTRAINT IF EXISTS event_type_event_fk CASCADE;
ALTER TABLE col.event ADD CONSTRAINT event_type_event_fk FOREIGN KEY (event_type_id)
REFERENCES col.event_type (event_type_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: object_event_fk | type: CONSTRAINT --
-- ALTER TABLE col.event DROP CONSTRAINT IF EXISTS object_event_fk CASCADE;
ALTER TABLE col.event ADD CONSTRAINT object_event_fk FOREIGN KEY (uid)
REFERENCES col.object (uid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: metadata_label_fk | type: CONSTRAINT --
-- ALTER TABLE col.label DROP CONSTRAINT IF EXISTS metadata_label_fk CASCADE;
ALTER TABLE col.label ADD CONSTRAINT metadata_label_fk FOREIGN KEY (metadata_id)
REFERENCES col.metadata (metadata_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: identifier_type_object_identifier_fk | type: CONSTRAINT --
-- ALTER TABLE col.object_identifier DROP CONSTRAINT IF EXISTS identifier_type_object_identifier_fk CASCADE;
ALTER TABLE col.object_identifier ADD CONSTRAINT identifier_type_object_identifier_fk FOREIGN KEY (identifier_type_id)
REFERENCES col.identifier_type (identifier_type_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: object_object_identifier_fk | type: CONSTRAINT --
-- ALTER TABLE col.object_identifier DROP CONSTRAINT IF EXISTS object_object_identifier_fk CASCADE;
ALTER TABLE col.object_identifier ADD CONSTRAINT object_object_identifier_fk FOREIGN KEY (uid)
REFERENCES col.object (uid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: protocol_operation_fk | type: CONSTRAINT --
-- ALTER TABLE col.operation DROP CONSTRAINT IF EXISTS protocol_operation_fk CASCADE;
ALTER TABLE col.operation ADD CONSTRAINT protocol_operation_fk FOREIGN KEY (protocol_id)
REFERENCES col.protocol (protocol_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: referent_collection_fk | type: CONSTRAINT --
-- ALTER TABLE col.collection DROP CONSTRAINT IF EXISTS referent_collection_fk CASCADE;
ALTER TABLE col.collection ADD CONSTRAINT referent_collection_fk FOREIGN KEY (referent_id)
REFERENCES col.referent (referent_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: project_protocol_fk | type: CONSTRAINT --
-- ALTER TABLE col.protocol DROP CONSTRAINT IF EXISTS project_protocol_fk CASCADE;
ALTER TABLE col.protocol ADD CONSTRAINT project_protocol_fk FOREIGN KEY (collection_id)
REFERENCES col.collection (collection_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: object_sample_fk | type: CONSTRAINT --
-- ALTER TABLE col.sample DROP CONSTRAINT IF EXISTS object_sample_fk CASCADE;
ALTER TABLE col.sample ADD CONSTRAINT object_sample_fk FOREIGN KEY (uid)
REFERENCES col.object (uid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: project_sample_fk | type: CONSTRAINT --
-- ALTER TABLE col.sample DROP CONSTRAINT IF EXISTS project_sample_fk CASCADE;
ALTER TABLE col.sample ADD CONSTRAINT project_sample_fk FOREIGN KEY (collection_id)
REFERENCES col.collection (collection_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: sample_sample_fk | type: CONSTRAINT --
-- ALTER TABLE col.sample DROP CONSTRAINT IF EXISTS sample_sample_fk CASCADE;
ALTER TABLE col.sample ADD CONSTRAINT sample_sample_fk FOREIGN KEY (parent_sample_id)
REFERENCES col.sample (sample_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: sample_type_sample_fk | type: CONSTRAINT --
-- ALTER TABLE col.sample DROP CONSTRAINT IF EXISTS sample_type_sample_fk CASCADE;
ALTER TABLE col.sample ADD CONSTRAINT sample_type_sample_fk FOREIGN KEY (sample_type_id)
REFERENCES col.sample_type (sample_type_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: sampling_place_sample_fk | type: CONSTRAINT --
-- ALTER TABLE col.sample DROP CONSTRAINT IF EXISTS sampling_place_sample_fk CASCADE;
ALTER TABLE col.sample ADD CONSTRAINT sampling_place_sample_fk FOREIGN KEY (sampling_place_id)
REFERENCES col.sampling_place (sampling_place_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: container_type_sample_type_fk | type: CONSTRAINT --
-- ALTER TABLE col.sample_type DROP CONSTRAINT IF EXISTS container_type_sample_type_fk CASCADE;
ALTER TABLE col.sample_type ADD CONSTRAINT container_type_sample_type_fk FOREIGN KEY (container_type_id)
REFERENCES col.container_type (container_type_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: metadata_sample_type_fk | type: CONSTRAINT --
-- ALTER TABLE col.sample_type DROP CONSTRAINT IF EXISTS metadata_sample_type_fk CASCADE;
ALTER TABLE col.sample_type ADD CONSTRAINT metadata_sample_type_fk FOREIGN KEY (metadata_id)
REFERENCES col.metadata (metadata_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: multiple_type_sample_type_fk | type: CONSTRAINT --
-- ALTER TABLE col.sample_type DROP CONSTRAINT IF EXISTS multiple_type_sample_type_fk CASCADE;
ALTER TABLE col.sample_type ADD CONSTRAINT multiple_type_sample_type_fk FOREIGN KEY (multiple_type_id)
REFERENCES col.multiple_type (multiple_type_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: operation_sample_type_fk | type: CONSTRAINT --
-- ALTER TABLE col.sample_type DROP CONSTRAINT IF EXISTS operation_sample_type_fk CASCADE;
ALTER TABLE col.sample_type ADD CONSTRAINT operation_sample_type_fk FOREIGN KEY (operation_id)
REFERENCES col.operation (operation_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: collection_sampling_place_fk | type: CONSTRAINT --
-- ALTER TABLE col.sampling_place DROP CONSTRAINT IF EXISTS collection_sampling_place_fk CASCADE;
ALTER TABLE col.sampling_place ADD CONSTRAINT collection_sampling_place_fk FOREIGN KEY (collection_id)
REFERENCES col.collection (collection_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: container_storage_fk | type: CONSTRAINT --
-- ALTER TABLE col.movement DROP CONSTRAINT IF EXISTS container_storage_fk CASCADE;
ALTER TABLE col.movement ADD CONSTRAINT container_storage_fk FOREIGN KEY (container_id)
REFERENCES col.container (container_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: movement_type_storage_fk | type: CONSTRAINT --
-- ALTER TABLE col.movement DROP CONSTRAINT IF EXISTS movement_type_storage_fk CASCADE;
ALTER TABLE col.movement ADD CONSTRAINT movement_type_storage_fk FOREIGN KEY (movement_type_id)
REFERENCES col.movement_type (movement_type_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: object_storage_fk | type: CONSTRAINT --
-- ALTER TABLE col.movement DROP CONSTRAINT IF EXISTS object_storage_fk CASCADE;
ALTER TABLE col.movement ADD CONSTRAINT object_storage_fk FOREIGN KEY (uid)
REFERENCES col.object (uid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: storage_reason_storage_fk | type: CONSTRAINT --
-- ALTER TABLE col.movement DROP CONSTRAINT IF EXISTS storage_reason_storage_fk CASCADE;
ALTER TABLE col.movement ADD CONSTRAINT storage_reason_storage_fk FOREIGN KEY (movement_reason_id)
REFERENCES col.movement_reason (movement_reason_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: movement_type_subsample_fk | type: CONSTRAINT --
-- ALTER TABLE col.subsample DROP CONSTRAINT IF EXISTS movement_type_subsample_fk CASCADE;
ALTER TABLE col.subsample ADD CONSTRAINT movement_type_subsample_fk FOREIGN KEY (movement_type_id)
REFERENCES col.movement_type (movement_type_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: sample_subsample_fk | type: CONSTRAINT --
-- ALTER TABLE col.subsample DROP CONSTRAINT IF EXISTS sample_subsample_fk CASCADE;
ALTER TABLE col.subsample ADD CONSTRAINT sample_subsample_fk FOREIGN KEY (sample_id)
REFERENCES col.sample (sample_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: aclaco_aclacl_fk | type: CONSTRAINT --
-- ALTER TABLE gacl.aclacl DROP CONSTRAINT IF EXISTS aclaco_aclacl_fk CASCADE;
ALTER TABLE gacl.aclacl ADD CONSTRAINT aclaco_aclacl_fk FOREIGN KEY (aclaco_id)
REFERENCES gacl.aclaco (aclaco_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: aclgroup_aclacl_fk | type: CONSTRAINT --
-- ALTER TABLE gacl.aclacl DROP CONSTRAINT IF EXISTS aclgroup_aclacl_fk CASCADE;
ALTER TABLE gacl.aclacl ADD CONSTRAINT aclgroup_aclacl_fk FOREIGN KEY (aclgroup_id)
REFERENCES gacl.aclgroup (aclgroup_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: aclappli_aclaco_fk | type: CONSTRAINT --
-- ALTER TABLE gacl.aclaco DROP CONSTRAINT IF EXISTS aclappli_aclaco_fk CASCADE;
ALTER TABLE gacl.aclaco ADD CONSTRAINT aclappli_aclaco_fk FOREIGN KEY (aclappli_id)
REFERENCES gacl.aclappli (aclappli_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: aclgroup_aclgroup_fk | type: CONSTRAINT --
-- ALTER TABLE gacl.aclgroup DROP CONSTRAINT IF EXISTS aclgroup_aclgroup_fk CASCADE;
ALTER TABLE gacl.aclgroup ADD CONSTRAINT aclgroup_aclgroup_fk FOREIGN KEY (aclgroup_id_parent)
REFERENCES gacl.aclgroup (aclgroup_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: aclgroup_acllogingroup_fk | type: CONSTRAINT --
-- ALTER TABLE gacl.acllogingroup DROP CONSTRAINT IF EXISTS aclgroup_acllogingroup_fk CASCADE;
ALTER TABLE gacl.acllogingroup ADD CONSTRAINT aclgroup_acllogingroup_fk FOREIGN KEY (aclgroup_id)
REFERENCES gacl.aclgroup (aclgroup_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: acllogin_acllogingroup_fk | type: CONSTRAINT --
-- ALTER TABLE gacl.acllogingroup DROP CONSTRAINT IF EXISTS acllogin_acllogingroup_fk CASCADE;
ALTER TABLE gacl.acllogingroup ADD CONSTRAINT acllogin_acllogingroup_fk FOREIGN KEY (acllogin_id)
REFERENCES gacl.acllogin (acllogin_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: logingestion_passwordlost_fk | type: CONSTRAINT --
-- ALTER TABLE gacl.passwordlost DROP CONSTRAINT IF EXISTS logingestion_passwordlost_fk CASCADE;
ALTER TABLE gacl.passwordlost ADD CONSTRAINT logingestion_passwordlost_fk FOREIGN KEY (id)
REFERENCES gacl.logingestion (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: object_fk | type: CONSTRAINT --
-- ALTER TABLE col.borrowing DROP CONSTRAINT IF EXISTS object_fk CASCADE;
ALTER TABLE col.borrowing ADD CONSTRAINT object_fk FOREIGN KEY (uid)
REFERENCES col.object (uid) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: borrower_fk | type: CONSTRAINT --
-- ALTER TABLE col.borrowing DROP CONSTRAINT IF EXISTS borrower_fk CASCADE;
ALTER TABLE col.borrowing ADD CONSTRAINT borrower_fk FOREIGN KEY (borrower_id)
REFERENCES col.borrower (borrower_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: object_status_object_fk | type: CONSTRAINT --
-- ALTER TABLE col.object DROP CONSTRAINT IF EXISTS object_status_object_fk CASCADE;
ALTER TABLE col.object ADD CONSTRAINT object_status_object_fk FOREIGN KEY (object_status_id)
REFERENCES col.object_status (object_status_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: referent_object_fk | type: CONSTRAINT --
-- ALTER TABLE col.object DROP CONSTRAINT IF EXISTS referent_object_fk CASCADE;
ALTER TABLE col.object ADD CONSTRAINT referent_object_fk FOREIGN KEY (referent_id)
REFERENCES col.referent (referent_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: "grant_CcT_1a8deeacb2" | type: PERMISSION --
GRANT CREATE,CONNECT,TEMPORARY
   ON DATABASE collec
   TO collec;
-- ddl-end --
