-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.9.2
-- PostgreSQL version: 9.6
-- Project Site: pgmodeler.io
-- Model Author: ---

-- Database creation must be done outside a multicommand file.
-- These commands were put in this file only as a convenience.
-- -- object: collec | type: DATABASE --
-- -- DROP DATABASE IF EXISTS collec;
-- CREATE DATABASE collec
-- 	ENCODING = 'UTF8'
-- 	LC_COLLATE = 'fr_FR.UTF-8'
-- 	LC_CTYPE = 'fr_FR.UTF-8'
-- 	TABLESPACE = pg_default
-- 	OWNER = collec;
-- -- ddl-end --
--

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
	dbparam_id integer NOT NULL,
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

INSERT INTO col.dbparam (dbparam_id, dbparam_name, dbparam_value) VALUES (E'1', E'APPLI_code', E'cs_code');
-- ddl-end --
INSERT INTO col.dbparam (dbparam_id, dbparam_name, dbparam_value) VALUES (E'2', E'APPLI_title', E'Collec-Science - instance for ');
-- ddl-end --
INSERT INTO col.dbparam (dbparam_id, dbparam_name, dbparam_value) VALUES (E'3', E'mapDefaultX', E'-0.70');
-- ddl-end --
INSERT INTO col.dbparam (dbparam_id, dbparam_name, dbparam_value) VALUES (E'4', E'mapDefaultY', E'44.77');
-- ddl-end --
INSERT INTO col.dbparam (dbparam_id, dbparam_name, dbparam_value) VALUES (E'5', E'mapDefaultZoom', E'7');
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

INSERT INTO col.dbversion (dbversion_number, dbversion_date) VALUES (E'2.4', E'2020-03-01');
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
	identifier_type_code character varying NOT NULL,
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

INSERT INTO col.label (label_name, label_xsl, label_fields) VALUES (E'Example - Don''t use', E'<?xml version="1.0" encoding="utf-8"?>\n<xsl:stylesheet version="1.0"\n      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"\n      xmlns:fo="http://www.w3.org/1999/XSL/Format">\n  <xsl:output method="xml" indent="yes"/>\n  <xsl:template match="objects">\n    <fo:root>\n      <fo:layout-master-set>\n        <fo:simple-page-master master-name="label"\n              page-height="5cm" page-width="10cm" margin-left="0.5cm" margin-top="0.5cm" margin-bottom="0cm" margin-right="0.5cm">  \n              <fo:region-body/>\n        </fo:simple-page-master>\n      </fo:layout-master-set>\n      \n      <fo:page-sequence master-reference="label">\n         <fo:flow flow-name="xsl-region-body">        \n          <fo:block>\n          <xsl:apply-templates select="object" />\n          </fo:block>\n\n        </fo:flow>\n      </fo:page-sequence>\n    </fo:root>\n   </xsl:template>\n  <xsl:template match="object">\n\n  <fo:table table-layout="fixed" border-collapse="collapse"  border-style="none" width="8cm&quot; keep-together.within-page=&quot;always">\n  <fo:table-column column-width="4cm"/>\n  <fo:table-column column-width="4cm" />\n <fo:table-body  border-style="none" >\n 	<fo:table-row>\n  		<fo:table-cell> \n  		<fo:block>\n  		<fo:external-graphic>\n      <xsl:attribute name="src">\n             <xsl:value-of select="concat(uid,''.png'')" />\n       </xsl:attribute>\n       <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>\n       <xsl:attribute name="height">4cm</xsl:attribute>\n        <xsl:attribute name="content-width">4cm</xsl:attribute>\n        <xsl:attribute name="scaling">uniform</xsl:attribute>\n      \n       </fo:external-graphic>\n 		</fo:block>\n   		</fo:table-cell>\n  		<fo:table-cell>\n<fo:block><fo:inline font-weight="bold">IRSTEA</fo:inline></fo:block>\n  			<fo:block>uid:<fo:inline font-weight="bold&quot;&gt;&lt;xsl:value-of select=&quot;db&quot;/&gt;:&lt;xsl:value-of select=&quot;uid"/></fo:inline></fo:block>\n  			<fo:block>id:<fo:inline font-weight="bold&quot;&gt;&lt;xsl:value-of select=&quot;id"/></fo:inline></fo:block>\n  			<fo:block>prj:<fo:inline font-weight="bold&quot;&gt;&lt;xsl:value-of select=&quot;prj"/></fo:inline></fo:block>\n  			<fo:block>clp:<fo:inline font-weight="bold&quot;&gt;&lt;xsl:value-of select=&quot;clp"/></fo:inline></fo:block>\n  		</fo:table-cell>\n  	  	</fo:table-row>\n  </fo:table-body>\n  </fo:table>\n   <fo:block page-break-after="always"/>\n\n  </xsl:template>\n</xsl:stylesheet>', E'uid,id,clp,db,col');
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
    array_to_string(array_agg((((identifier_type.identifier_type_code)::text || ':'::text) || (object_identifier.object_identifier_value)::text) ORDER BY identifier_type.identifier_type_code, object_identifier.object_identifier_value), ','::text) AS identifiers
   FROM (col.object_identifier
     JOIN col.identifier_type USING (identifier_type_id))
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
	CONSTRAINT acllogin_pk PRIMARY KEY (acllogin_id)

);
-- ddl-end --
COMMENT ON TABLE gacl.acllogin IS E'List of logins granted to access to the modules of the application';
-- ddl-end --
COMMENT ON COLUMN gacl.acllogin.login IS E'Login. It must be the same as the table logingestion';
-- ddl-end --
COMMENT ON COLUMN gacl.acllogin.logindetail IS E'Displayed name';
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
-- ALTER SEQUENCE gacl.seq_logingestion_id OWNER TO postgres;
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

-- object: object_identifier_value_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.object_identifier_value_idx CASCADE;
CREATE INDEX object_identifier_value_idx ON col.object_identifier
	USING gin
	(
	  (object_identifier_value)
	);
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

-- object: sample_dbuid_origin_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.sample_dbuid_origin_idx CASCADE;
CREATE INDEX sample_dbuid_origin_idx ON col.sample
	USING gin
	(
	  (dbuid_origin)
	);
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
ALTER TABLE col.object OWNER TO collec;
-- ddl-end --

-- object: object_identifier_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.object_identifier_idx CASCADE;
CREATE INDEX object_identifier_idx ON col.object
	USING gin
	(
	  (identifier)
	);
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
	referent_id integer,
	campaign_name varchar NOT NULL,
	campaign_from timestamp,
	campaign_to timestamp,
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
	campaign_id integer NOT NULL,
	regulation_id integer NOT NULL,
	CONSTRAINT campaign_regulation_pk PRIMARY KEY (campaign_id,regulation_id)

);
-- ddl-end --
COMMENT ON TABLE col.campaign_regulation IS E'List of regulations attached to a campaign';
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
