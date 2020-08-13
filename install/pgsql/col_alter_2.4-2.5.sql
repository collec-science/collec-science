-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2
-- Diff date: 2020-06-16 17:16:38
-- Source model: collec
-- Database: collec
-- PostgreSQL version: 11.0

-- [ Diff summary ]
-- Dropped objects: 10
-- Created objects: 21
-- Changed objects: 8
-- Truncated tables: 0

SET search_path=public,pg_catalog,col,gacl;
-- ddl-end --





-- [ Created objects ] --
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

-- object: col.export | type: TABLE --
-- DROP TABLE IF EXISTS col.export CASCADE;
CREATE TABLE col.export (
	export_id serial NOT NULL,
	lot_id integer NOT NULL,
	export_date timestamp NOT NULL DEFAULT current_timestamp,
	export_template_id integer NOT NULL,
	CONSTRAINT export_pk PRIMARY KEY (export_id)

);
-- ddl-end --
COMMENT ON TABLE col.export IS E'List of exports processed';
-- ddl-end --
COMMENT ON COLUMN col.export.export_date IS E'Date of creation of the export';
-- ddl-end --
ALTER TABLE col.export OWNER TO collec;
-- ddl-end --

-- object: col.export_template | type: TABLE --
-- DROP TABLE IF EXISTS col.export_template CASCADE;
CREATE TABLE col.export_template (
	export_template_id serial NOT NULL,
	export_template_name varchar NOT NULL,
	export_template_description varchar,
	export_template_version varchar,
	is_zipped boolean DEFAULT false,
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
ALTER TABLE col.export_template OWNER TO collec;
-- ddl-end --

-- object: col.dataset_template | type: TABLE --
-- DROP TABLE IF EXISTS col.dataset_template CASCADE;
CREATE TABLE col.dataset_template (
	dataset_template_id serial NOT NULL,
	dataset_template_name varchar NOT NULL,
	export_format_id integer NOT NULL,
	dataset_type_id integer NOT NULL,
	only_last_document boolean DEFAULT false,
	separator varchar,
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

-- object: col.dataset_column | type: TABLE --
-- DROP TABLE IF EXISTS col.dataset_column CASCADE;
CREATE TABLE col.dataset_column (
	dataset_column_id serial NOT NULL,
	dataset_template_id integer NOT NULL,
	column_name varchar NOT NULL,
	export_name varchar NOT NULL,
	subfield_name varchar,
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
COMMENT ON COLUMN col.dataset_column.subfield_name IS E'Name of the field if it into the metadata description of the sample';
-- ddl-end --
ALTER TABLE col.dataset_column OWNER TO collec;
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


-- [ Changed objects ] --

ALTER TABLE col.collection ALTER COLUMN allowed_import_flow SET DEFAULT 'f';
-- ddl-end --
ALTER TABLE col.collection ALTER COLUMN allowed_export_flow SET DEFAULT 'f';
-- ddl-end --
ALTER TABLE col.collection ALTER COLUMN public_collection SET DEFAULT 'f';
-- ddl-end --
ALTER TABLE col.object ALTER COLUMN change_date SET DEFAULT 'now';
-- ddl-end --
ALTER TABLE col.object ALTER COLUMN location_accuracy TYPE float;
-- ddl-end --
ALTER TABLE col.object ALTER COLUMN geom TYPE geography(POINT, 4326);
-- ddl-end --


-- [ Created foreign keys ] --
-- object: collection_fk | type: CONSTRAINT --
-- ALTER TABLE col.lot DROP CONSTRAINT IF EXISTS collection_fk CASCADE;
ALTER TABLE col.lot ADD CONSTRAINT collection_fk FOREIGN KEY (collection_id)
REFERENCES col.collection (collection_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
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

-- object: lot_fk | type: CONSTRAINT --
-- ALTER TABLE col.export DROP CONSTRAINT IF EXISTS lot_fk CASCADE;
ALTER TABLE col.export ADD CONSTRAINT lot_fk FOREIGN KEY (lot_id)
REFERENCES col.lot (lot_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: export_template_fk | type: CONSTRAINT --
-- ALTER TABLE col.export DROP CONSTRAINT IF EXISTS export_template_fk CASCADE;
ALTER TABLE col.export ADD CONSTRAINT export_template_fk FOREIGN KEY (export_template_id)
REFERENCES col.export_template (export_template_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: export_format_fk | type: CONSTRAINT --
-- ALTER TABLE col.dataset_template DROP CONSTRAINT IF EXISTS export_format_fk CASCADE;
ALTER TABLE col.dataset_template ADD CONSTRAINT export_format_fk FOREIGN KEY (export_format_id)
REFERENCES col.export_format (export_format_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
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

-- object: dataset_template_fk | type: CONSTRAINT --
-- ALTER TABLE col.dataset_column DROP CONSTRAINT IF EXISTS dataset_template_fk CASCADE;
ALTER TABLE col.dataset_column ADD CONSTRAINT dataset_template_fk FOREIGN KEY (dataset_template_id)
REFERENCES col.dataset_template (dataset_template_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: translator_fk | type: CONSTRAINT --
-- ALTER TABLE col.dataset_column DROP CONSTRAINT IF EXISTS translator_fk CASCADE;
ALTER TABLE col.dataset_column ADD CONSTRAINT translator_fk FOREIGN KEY (translator_id)
REFERENCES col.translator (translator_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: dataset_type_fk | type: CONSTRAINT --
-- ALTER TABLE col.dataset_template DROP CONSTRAINT IF EXISTS dataset_type_fk CASCADE;
ALTER TABLE col.dataset_template ADD CONSTRAINT dataset_type_fk FOREIGN KEY (dataset_type_id)
REFERENCES col.dataset_type (dataset_type_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

;
alter table col.dataset_column add column mandatory boolean default 'f';
COMMENT ON COLUMN col.dataset_column.mandatory IS E'Is the content of the column is mandatory to export data?';

alter table col.dataset_column add column default_value varchar;
COMMENT ON COLUMN col.dataset_column.default_value IS E'Default value, if the value is not filled in';

alter table col.export alter column export_date drop not null, alter column export_date drop default;
COMMENT ON COLUMN col.export.export_date IS E'Date of last execution of the export';

alter table col.dataset_template add column filename varchar NOT NULL DEFAULT 'cs-export.csv';
COMMENT ON COLUMN col.dataset_template.filename IS E'File name generated, with extension';

alter table col.export_template add column filename varchar NOT NULL DEFAULT 'cs-export.csv';
COMMENT ON COLUMN col.export_template.filename IS E'Name of the file generated';


alter table col.dataset_template add column xmlroot varchar,
add column xmlnodename varchar DEFAULT 'sample';

COMMENT ON COLUMN col.dataset_template.xmlroot IS E'xml root to generate';
-- ddl-end --
COMMENT ON COLUMN col.dataset_template.xmlnodename IS E'Name of a node in a xml file, for list of samples by example';

alter table col.dataset_column add column date_format varchar;
COMMENT ON COLUMN col.dataset_column.date_format IS E'Export date format, in php notation. Example: d/m/Y H:i:s for 25/12/2020 17:15:00';

select setval('col.mime_type_mime_type_id_seq', (select max(mime_type_id) from col.mime_type));
INSERT INTO col.mime_type (extension, content_type) VALUES (E'xml', E'application/xml');

INSERT INTO col.dataset_type (dataset_type_id, dataset_type_name, fields) VALUES (E'1', E'sample', E'["uid","uuid","identifier","wgs84_x","wgs84_y","object_status_name","referent_name","referent_email","address_name","address_line2","address_line3","address_city","address_country","referent_phone","object_comment","identifiers","sample_creation_date","sampling_date","multiple_value","sampling_place_name","expiration_date","sample_type_name","storage_product","clp_classification","multiple_type_name","collection_name","metadata","fixed_value"]');
-- ddl-end --
INSERT INTO col.dataset_type (dataset_type_id, dataset_type_name, fields) VALUES (E'2', E'collection', E'["collection_name","referent_name","referent_email","address_name","address_line2","address_line3","address_city","address_country","referent_phone","fixed_value"]');
-- ddl-end --
INSERT INTO col.dataset_type (dataset_type_id, dataset_type_name, fields) VALUES (E'3', E'document', E'["document_name","uid","uuid","identifier","content_type","extension","size","document_creation_date","fixed_value","web_address"]');
-- ddl-end --
INSERT INTO col.dataset_type (dataset_type_id, dataset_type_name, fields) VALUES (E'4', E'arbitrary content', E'["content"]');
alter table col.document add column 	uuid uuid NOT NULL DEFAULT gen_random_uuid();
INSERT INTO col.export_model (export_model_name,pattern,target) 
VALUES
  ('export_template',cast('[{"tableName":"export_template","technicalKey":"export_template_id","isEmpty":false,"businessKey":"export_template_name","istable11":false,"booleanFields":["is_zipped"],"children":[{"aliasName":"export_dataset","isStrict":true}],"parameters":[],"istablenn":false},{"tableName":"export_dataset","isEmpty":false,"parentKey":"export_template_id","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"dataset_template","fieldName":"dataset_template_id"}],"istablenn":true,"tablenn":{"secondaryParentKey":"dataset_template_id","tableAlias":"dataset_template"}},{"tableName":"dataset_template","technicalKey":"dataset_template_id","isEmpty":true,"businessKey":"dataset_template_name","istable11":false,"booleanFields":[],"children":[{"aliasName":"dataset_column","isStrict":true}],"parameters":[],"istablenn":false},{"tableName":"dataset_column","technicalKey":"dataset_column_id","isEmpty":false,"parentKey":"dataset_template_id","istable11":false,"booleanFields":["mandatory"],"children":[],"parameters":[{"aliasName":"translator","fieldName":"translator_id"}],"istablenn":false},{"tableName":"translator","technicalKey":"translator_id","isEmpty":true,"businessKey":"translator_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false}]' as json),NULL);

-- ddl-end --


INSERT INTO col.dbversion (dbversion_number, dbversion_date) VALUES (E'2.5', E'2020-08-14');
