/*
 If the connection login is not collec, you must replace:
 OWNER TO collec;
 by:
 OWNER TO yourlogin;

 and:
ALTER SCHEMA col OWNER TO collec; (line 400 or arround)

 If the schema name is not col, you must replace:
  col. (space before col.)
 by:
  yourschemaname. (space before)
 and change the line SET search_path=(...) (line 14 or arround)
 */

-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2
-- Diff date: 2020-03-03 10:19:01
-- Source model: collec
-- Database: collecdemo
-- PostgreSQL version: 11.0

-- [ Diff summary ]
-- Dropped objects: 3
-- Created objects: 39
-- Changed objects: 103
-- Truncated tables: 0

-- object: postgis | type: EXTENSION --
-- DROP EXTENSION IF EXISTS postgis CASCADE;
-- CREATE EXTENSION postgis
-- WITH SCHEMA public;
-- ddl-end --
-- object: btree_gin | type: EXTENSION --
-- DROP EXTENSION IF EXISTS btree_gin CASCADE;
-- CREATE EXTENSION btree_gin
-- WITH SCHEMA pg_catalog;
-- ddl-end --

-- object: pgcrypto | type: EXTENSION --
-- DROP EXTENSION IF EXISTS pgcrypto CASCADE;
-- CREATE EXTENSION pgcrypto
-- WITH SCHEMA public;
-- ddl-end --

-- object: grant_95c2183ced | type: PERMISSION --
-- GRANT CREATE,CONNECT,TEMPORARY
--   ON DATABASE collec
--   TO collec;
-- ddl-end --

SET search_path=public,pg_catalog,gacl,col;
-- ddl-end --


-- [ Created objects ] --
-- object: nb_slots_max | type: COLUMN --
-- ALTER TABLE col.container_type DROP COLUMN IF EXISTS nb_slots_max CASCADE;
ALTER TABLE col.container_type ADD COLUMN nb_slots_max integer DEFAULT 0;
-- ddl-end --

COMMENT ON COLUMN col.container_type.nb_slots_max IS E'Number maximum of slots in the container';
-- ddl-end --


-- object: first_column | type: COLUMN --
-- ALTER TABLE col.container_type DROP COLUMN IF EXISTS first_column CASCADE;
ALTER TABLE col.container_type ADD COLUMN first_column varchar DEFAULT 'L';
-- ddl-end --

COMMENT ON COLUMN col.container_type.first_column IS E'Place of the first column: \nL: left\nR: Right';
-- ddl-end --

-- object: metadata_form_id | type: COLUMN --
-- ALTER TABLE col.operation DROP COLUMN IF EXISTS metadata_form_id CASCADE;
ALTER TABLE col.operation ADD COLUMN metadata_form_id integer;
-- ddl-end --


-- object: allowed_import_flow | type: COLUMN --
-- ALTER TABLE col.collection DROP COLUMN IF EXISTS allowed_import_flow CASCADE;
ALTER TABLE col.collection ADD COLUMN allowed_import_flow boolean DEFAULT 'f';
-- ddl-end --

COMMENT ON COLUMN col.collection.allowed_import_flow IS E'Allow an external source to update a collection';
-- ddl-end --


-- object: allowed_export_flow | type: COLUMN --
-- ALTER TABLE col.collection DROP COLUMN IF EXISTS allowed_export_flow CASCADE;
ALTER TABLE col.collection ADD COLUMN allowed_export_flow boolean DEFAULT 'f';
-- ddl-end --

COMMENT ON COLUMN col.collection.allowed_export_flow IS E'Allow interrogation requests from external sources';
-- ddl-end --


-- object: public_collection | type: COLUMN --
-- ALTER TABLE col.collection DROP COLUMN IF EXISTS public_collection CASCADE;
ALTER TABLE col.collection ADD COLUMN public_collection boolean DEFAULT 'f';
-- ddl-end --

COMMENT ON COLUMN col.collection.public_collection IS E'Set if a collection can be requested without authentication';
-- ddl-end --


-- object: sample_type_description | type: COLUMN --
-- ALTER TABLE col.sample_type DROP COLUMN IF EXISTS sample_type_description CASCADE;
ALTER TABLE col.sample_type ADD COLUMN sample_type_description varchar;
-- ddl-end --

COMMENT ON COLUMN col.sample_type.sample_type_description IS E'Description of the type of sample';
-- ddl-end --


-- object: laboratory_code | type: COLUMN --
-- ALTER TABLE col.borrower DROP COLUMN IF EXISTS laboratory_code CASCADE;
ALTER TABLE col.borrower ADD COLUMN laboratory_code varchar;
-- ddl-end --

COMMENT ON COLUMN col.borrower.laboratory_code IS E'Laboratory code of the borrower';
-- ddl-end --


-- object: borrower_mail | type: COLUMN --
-- ALTER TABLE col.borrower DROP COLUMN IF EXISTS borrower_mail CASCADE;
ALTER TABLE col.borrower ADD COLUMN borrower_mail varchar;
-- ddl-end --

COMMENT ON COLUMN col.borrower.borrower_mail IS E'Mail of the borrower';
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

-- object: change_date | type: COLUMN --
-- ALTER TABLE col.object DROP COLUMN IF EXISTS change_date CASCADE;
ALTER TABLE col.object ADD COLUMN change_date timestamp NOT NULL DEFAULT 'now';
-- ddl-end --

COMMENT ON COLUMN col.object.change_date IS E'Technical date of changement of the object';
-- ddl-end --


-- object: uuid | type: COLUMN --
-- ALTER TABLE col.object DROP COLUMN IF EXISTS uuid CASCADE;
ALTER TABLE col.object ADD COLUMN uuid uuid NOT NULL DEFAULT gen_random_uuid();
-- ddl-end --

COMMENT ON COLUMN col.object.uuid IS E'UUID of the object';
-- ddl-end --


-- object: trashed | type: COLUMN --
-- ALTER TABLE col.object DROP COLUMN IF EXISTS trashed CASCADE;
ALTER TABLE col.object ADD COLUMN trashed bool DEFAULT false;
-- ddl-end --

COMMENT ON COLUMN col.object.trashed IS E'If the object is trashed before completly destroyed ?';
-- ddl-end --


-- object: location_accuracy | type: COLUMN --
-- ALTER TABLE col.object DROP COLUMN IF EXISTS location_accuracy CASCADE;
ALTER TABLE col.object ADD COLUMN location_accuracy float;
-- ddl-end --

COMMENT ON COLUMN col.object.location_accuracy IS E'Location accuracy of the object, in meters';
-- ddl-end --


-- object: geom | type: COLUMN --
-- ALTER TABLE col.object DROP COLUMN IF EXISTS geom CASCADE;
ALTER TABLE col.object ADD COLUMN geom geography(POINT, 4326);
-- ddl-end --

COMMENT ON COLUMN col.object.geom IS E'Geographic point generate from wgs84_x and wgs84_y';
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
	regulation_id integer NOT NULL
);
-- ddl-end --
ALTER TABLE col.campaign_regulation OWNER TO collec;
-- ddl-end --

-- object: campaign_id | type: COLUMN --
-- ALTER TABLE col.sample DROP COLUMN IF EXISTS campaign_id CASCADE;
ALTER TABLE col.sample ADD COLUMN campaign_id integer;
-- ddl-end --


-- object: campaign_id | type: COLUMN --
-- ALTER TABLE col.document DROP COLUMN IF EXISTS campaign_id CASCADE;
ALTER TABLE col.document ADD COLUMN campaign_id integer;
-- ddl-end --




-- [ Changed objects ] --

ALTER SCHEMA col OWNER TO collec;
-- ddl-end --
ALTER SCHEMA gacl OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.booking_booking_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.booking OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.project_project_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.collection_group OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.container_container_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.container OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.container_family_container_family_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.container_family OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.container_type_container_type_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.container_type OWNER TO collec;
-- ddl-end --
ALTER TABLE col.dbparam OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE col.dbparam IS E'Table of parameters intrinsically associated to the instance';
-- ddl-end --
COMMENT ON COLUMN col.dbparam.dbparam_name IS E'Name of the parameter';
-- ddl-end --
COMMENT ON COLUMN col.dbparam.dbparam_value IS E'Value of the parameter';
-- ddl-end --
ALTER SEQUENCE col.dbversion_dbversion_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.dbversion OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.document_document_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.document OWNER TO collec;
-- ddl-end --
ALTER TABLE col.document ALTER COLUMN uid DROP NOT NULL;
-- ddl-end --
ALTER SEQUENCE col.event_event_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.event OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.event_type_event_type_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.event_type OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.identifier_type_identifier_type_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.identifier_type OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.label_label_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.label OWNER TO collec;
-- ddl-end --
COMMENT ON COLUMN col.label.label_fields IS '';
-- ddl-end --
ALTER SEQUENCE col.storage_storage_id_seq OWNER TO collec;
-- ddl-end --
ALTER VIEW col.last_photo OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.metadata_metadata_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.metadata OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.mime_type_mime_type_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.mime_type OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.storage_reason_storage_reason_id_seq OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.movement_type_movement_type_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.movement_type OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.multiple_type_multiple_type_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.multiple_type OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.object_uid_seq OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.object_identifier_object_identifier_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.object_identifier OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.object_status_object_status_id_seq OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.object_status_object_status_id_seq
	START WITH 7
;
-- ddl-end --
ALTER TABLE col.object_status OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.operation_operation_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.operation OWNER TO collec;
-- ddl-end --
COMMENT ON COLUMN col.operation.last_edit_date IS E'Last edit date of the operation';
-- ddl-end --
ALTER SEQUENCE col.printer_printer_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.printer OWNER TO collec;
-- ddl-end --
ALTER TABLE col.collection OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.protocol_protocol_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.protocol OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.referent_referent_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.referent OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.sample_sample_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.sample OWNER TO collec;
-- ddl-end --
COMMENT ON COLUMN col.sample.multiple_value IS '';
-- ddl-end --
COMMENT ON COLUMN col.sample.metadata IS E'Metadonnees associees de l''echantillon';
-- ddl-end --
ALTER SEQUENCE col.sample_type_sample_type_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.sample_type OWNER TO collec;
-- ddl-end --
COMMENT ON COLUMN col.sample_type.multiple_unit IS '';
-- ddl-end --
ALTER SEQUENCE col.sampling_place_sampling_place_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.sampling_place OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.storage_condition_storage_condition_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.storage_condition OWNER TO collec;
-- ddl-end --
ALTER TABLE col.movement_reason OWNER TO collec;
-- ddl-end --
ALTER TABLE col.movement OWNER TO collec;
-- ddl-end --
COMMENT ON COLUMN col.movement.column_number IS E'No de la colonne de stockage dans le container';
-- ddl-end --
COMMENT ON COLUMN col.movement.line_number IS E'No de la ligne de stockage dans le container';
-- ddl-end --
ALTER SEQUENCE col.subsample_subsample_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.subsample OWNER TO collec;
-- ddl-end --
ALTER VIEW col.v_object_identifier OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE gacl.aclgroup_aclgroup_id_seq OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE gacl.aclgroup_aclgroup_id_seq
	START WITH 7
;
-- ddl-end --
ALTER TABLE gacl.aclacl OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE gacl.aclaco_aclaco_id_seq OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE gacl.aclaco_aclaco_id_seq
	START WITH 7
;
-- ddl-end --
ALTER TABLE gacl.aclaco OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE gacl.aclappli_aclappli_id_seq OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE gacl.aclappli_aclappli_id_seq
	START WITH 2
;
-- ddl-end --
ALTER TABLE gacl.aclappli OWNER TO collec;
-- ddl-end --
ALTER TABLE gacl.aclgroup OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE gacl.acllogin_acllogin_id_seq OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE gacl.acllogin_acllogin_id_seq
	START WITH 2
;
-- ddl-end --
ALTER TABLE gacl.acllogin OWNER TO collec;
-- ddl-end --
ALTER TABLE gacl.acllogingroup OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE gacl.log_log_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE gacl.log OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE gacl.seq_logingestion_id OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE gacl.seq_logingestion_id
	START WITH 2
;
-- ddl-end --
ALTER TABLE gacl.logingestion OWNER TO collec;
-- ddl-end --
ALTER TABLE gacl.logingestion ALTER COLUMN login TYPE varchar;
-- ddl-end --
ALTER TABLE gacl.logingestion ALTER COLUMN password TYPE varchar;
-- ddl-end --
ALTER TABLE gacl.logingestion ALTER COLUMN nom TYPE varchar;
-- ddl-end --
ALTER TABLE gacl.logingestion ALTER COLUMN prenom TYPE varchar;
-- ddl-end --
ALTER SEQUENCE gacl.passwordlost_passwordlost_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE gacl.passwordlost OWNER TO collec;
-- ddl-end --
ALTER VIEW col.last_movement OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.borrower_borrower_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.borrower OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.borrowing_borrowing_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.borrowing OWNER TO collec;
-- ddl-end --
ALTER VIEW col.last_borrowing OWNER TO collec;
-- ddl-end --
ALTER TABLE col.object OWNER TO collec;
-- ddl-end --
COMMENT ON COLUMN col.object.wgs84_y IS E'Latitude GPS, en valeur décimale';
-- ddl-end --


-- [ Created constraints ] --
-- object: projet_group_pk | type: CONSTRAINT --
-- ALTER TABLE col.collection_group DROP CONSTRAINT IF EXISTS projet_group_pk CASCADE;
ALTER TABLE col.collection_group ADD CONSTRAINT projet_group_pk PRIMARY KEY (collection_id,aclgroup_id);
-- ddl-end --



-- [ Created foreign keys ] --
-- object: group_projet_aclgroup_fk | type: CONSTRAINT --
-- ALTER TABLE col.collection_group DROP CONSTRAINT IF EXISTS group_projet_aclgroup_fk CASCADE;
ALTER TABLE col.collection_group ADD CONSTRAINT group_projet_aclgroup_fk FOREIGN KEY (aclgroup_id)
REFERENCES gacl.aclgroup (aclgroup_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
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



