-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2
-- Diff date: 2020-11-16 17:50:50
-- Source model: collec
-- Database: collec24
-- PostgreSQL version: 9.6

-- [ Diff summary ]
-- Dropped objects: 0
-- Created objects: 61
-- Changed objects: 12
-- Truncated tables: 0

SET search_path=public,pg_catalog,col,gacl;
-- ddl-end --


-- [ Created objects ] --
-- object: uuid | type: COLUMN --
-- ALTER TABLE col.document DROP COLUMN IF EXISTS uuid CASCADE;
ALTER TABLE col.document ADD COLUMN uuid uuid NOT NULL DEFAULT gen_random_uuid();
-- ddl-end --


-- object: collection_keywords | type: COLUMN --
-- ALTER TABLE col.collection DROP COLUMN IF EXISTS collection_keywords CASCADE;
ALTER TABLE col.collection ADD COLUMN collection_keywords varchar;
-- ddl-end --

COMMENT ON COLUMN col.collection.collection_keywords IS E'List of keywords, separed by a comma';
-- ddl-end --


-- object: collection_displayname | type: COLUMN --
-- ALTER TABLE col.collection DROP COLUMN IF EXISTS collection_displayname CASCADE;
ALTER TABLE col.collection ADD COLUMN collection_displayname varchar;
-- ddl-end --

COMMENT ON COLUMN col.collection.collection_displayname IS E'Name used to communicate from the collection, in export module by example';
-- ddl-end --


-- object: referent_firstname | type: COLUMN --
-- ALTER TABLE col.referent DROP COLUMN IF EXISTS referent_firstname CASCADE;
ALTER TABLE col.referent ADD COLUMN referent_firstname varchar;
-- ddl-end --

COMMENT ON COLUMN col.referent.referent_firstname IS E'Firstname of the referent';
-- ddl-end --


-- object: academical_directory | type: COLUMN --
-- ALTER TABLE col.referent DROP COLUMN IF EXISTS academical_directory CASCADE;
ALTER TABLE col.referent ADD COLUMN academical_directory varchar;
-- ddl-end --

COMMENT ON COLUMN col.referent.academical_directory IS E'Academical directory used to identifier the referent, as https://orcid.org or https://www.researchgate.net';
-- ddl-end --


-- object: academical_link | type: COLUMN --
-- ALTER TABLE col.referent DROP COLUMN IF EXISTS academical_link CASCADE;
ALTER TABLE col.referent ADD COLUMN academical_link varchar;
-- ddl-end --

COMMENT ON COLUMN col.referent.academical_link IS E'Link used to identify the referent, as https://orcid.org/0000-0003-4207-4107';
-- ddl-end --


-- object: object_comment | type: COLUMN --
-- ALTER TABLE col.object DROP COLUMN IF EXISTS object_comment CASCADE;
ALTER TABLE col.object ADD COLUMN object_comment varchar;
-- ddl-end --

COMMENT ON COLUMN col.object.object_comment IS E'Comment on the object (sample or container)';
-- ddl-end --


-- object: campaign_regulation_id | type: COLUMN --
-- ALTER TABLE col.campaign_regulation DROP COLUMN IF EXISTS campaign_regulation_id CASCADE;
ALTER TABLE col.campaign_regulation ADD COLUMN campaign_regulation_id serial NOT NULL;
-- ddl-end --


-- object: authorization_number | type: COLUMN --
-- ALTER TABLE col.campaign_regulation DROP COLUMN IF EXISTS authorization_number CASCADE;
ALTER TABLE col.campaign_regulation ADD COLUMN authorization_number varchar;
-- ddl-end --

COMMENT ON COLUMN col.campaign_regulation.authorization_number IS E'Number of the authorization';
-- ddl-end --


-- object: authorization_date | type: COLUMN --
-- ALTER TABLE col.campaign_regulation DROP COLUMN IF EXISTS authorization_date CASCADE;
ALTER TABLE col.campaign_regulation ADD COLUMN authorization_date timestamp;
-- ddl-end --

COMMENT ON COLUMN col.campaign_regulation.authorization_date IS E'Date of the authorization';
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

-- object: col.dataset_template | type: TABLE --
-- DROP TABLE IF EXISTS col.dataset_template CASCADE;
CREATE TABLE col.dataset_template (
	dataset_template_id serial NOT NULL,
	dataset_template_name varchar NOT NULL,
	export_format_id integer NOT NULL,
	dataset_type_id integer NOT NULL,
	only_last_document boolean DEFAULT false,
	separator varchar,
	filename varchar NOT NULL DEFAULT 'cs-export.csv',
	xmlroot varchar,
	xmlnodename varchar DEFAULT 'sample',
	xslcontent varchar,
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
	column_order smallint DEFAULT 1,
	mandatory boolean DEFAULT 'f',
	default_value varchar,
	date_format varchar,
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

INSERT INTO col.dataset_type (dataset_type_id, dataset_type_name, fields) VALUES (E'1', E'sample', E'["uid","uuid","identifier","wgs84_x","wgs84_y","location_accuracy","object_status_name","referent_name","referent_email","address_name","address_line2","address_line3","address_city","address_country","referent_phone","referent_firstname","academic_directory","academic_link","object_comment","identifiers","sample_creation_date","sampling_date","multiple_value","sampling_place_name","expiration_date","sample_type_name","storage_product","clp_classification","multiple_type_name","collection_name","metadata","parent_uid","parent_uuid","parent_identifiers","web_address","content_type","container_uid","container_identifier","container_uuid","storage_type_name","fixed_value"]');
-- ddl-end --
INSERT INTO col.dataset_type (dataset_type_id, dataset_type_name, fields) VALUES (E'2', E'collection', E'["collection_name","collection_displayname","collection_keywords","referent_name","referent_firstname","academical_directory","academical_link","referent_email","address_name","address_line2","address_line3","address_city","address_country","referent_phone","fixed_value"]');
-- ddl-end --
INSERT INTO col.dataset_type (dataset_type_id, dataset_type_name, fields) VALUES (E'3', E'document', E'["document_name","document_uuid","uid","sample_uuid","identifier","content_type","extension","size","document_creation_date","fixed_value", "web_address"]');
-- ddl-end --
INSERT INTO col.dataset_type (dataset_type_id, dataset_type_name, fields) VALUES (E'4', E'arbitrary content', E'["content"]');
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


-- object: country_id | type: COLUMN --
-- ALTER TABLE col.sample DROP COLUMN IF EXISTS country_id CASCADE;
ALTER TABLE col.sample ADD COLUMN country_id integer;
-- ddl-end --


-- object: country_code2_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.country_code2_idx CASCADE;
CREATE INDEX country_code2_idx ON col.country
	USING btree
	(
	  country_code2
	);
-- ddl-end --

-- object: country_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.country_id_idx CASCADE;
CREATE INDEX country_id_idx ON col.sample
	USING btree
	(
	  country_id
	);
-- ddl-end --

-- object: authorization_number_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.authorization_number_idx CASCADE;
CREATE INDEX authorization_number_idx ON col.campaign_regulation
	USING gin
	(
	  authorization_number
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

-- object: license_id | type: COLUMN --
-- ALTER TABLE col.collection DROP COLUMN IF EXISTS license_id CASCADE;
ALTER TABLE col.collection ADD COLUMN license_id integer;
-- ddl-end --

-- object: country_id | type: COLUMN --
-- ALTER TABLE col.sampling_place DROP COLUMN IF EXISTS country_id CASCADE;
ALTER TABLE col.sampling_place ADD COLUMN country_id integer;
-- ddl-end --




-- [ Changed objects ] --

ALTER TABLE col.identifier_type ALTER COLUMN identifier_type_code DROP NOT NULL;
-- ddl-end --
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

-- object: collection_fk | type: CONSTRAINT --
-- ALTER TABLE col.samplesearch DROP CONSTRAINT IF EXISTS collection_fk CASCADE;
ALTER TABLE col.samplesearch ADD CONSTRAINT collection_fk FOREIGN KEY (collection_id)
REFERENCES col.collection (collection_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: license_fk | type: CONSTRAINT --
-- ALTER TABLE col.collection DROP CONSTRAINT IF EXISTS license_fk CASCADE;
ALTER TABLE col.collection ADD CONSTRAINT license_fk FOREIGN KEY (license_id)
REFERENCES col.license (license_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
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

INSERT INTO col.dbversion (dbversion_number, dbversion_date) VALUES (E'2.5', E'2020-11-16');
