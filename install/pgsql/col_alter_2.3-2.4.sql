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
 and change the line SET search_path=(...) (line 30 or arround)
 and replace 'col. by 'yourschemaname.
 */

-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2
-- Diff date: 2020-03-16 16:44:26
-- Source model: collec
-- Database: collecdemo
-- PostgreSQL version: 9.5

-- [ Diff summary ]
-- Dropped objects: 3
-- Created objects: 38
-- Changed objects: 196
-- Truncated tables: 0

SET search_path=public,pg_catalog,gacl,col;
-- ddl-end --


-- [ Dropped objects ] --
ALTER TABLE col.collection_group DROP CONSTRAINT IF EXISTS aclgroup_projet_group_fk CASCADE;
-- ddl-end --
ALTER TABLE col.collection_group DROP CONSTRAINT IF EXISTS project_group_pk CASCADE;
-- ddl-end --
DROP VIEW IF EXISTS col.aclgroup CASCADE;
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
	regulation_id integer NOT NULL,
	CONSTRAINT campaign_regulation_pk PRIMARY KEY (campaign_id,regulation_id)

);
-- ddl-end --
COMMENT ON TABLE col.campaign_regulation IS E'List of regulations attached to a campaign';
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
--ALTER SEQUENCE col.booking_booking_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.booking OWNER TO collec;
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
--ALTER SEQUENCE col.project_project_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.collection_group OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE col.collection_group IS E'Table of project approvals';
-- ddl-end --
--ALTER SEQUENCE col.container_container_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.container OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE col.container IS E'Liste of containers';
-- ddl-end --
--ALTER SEQUENCE col.container_family_container_family_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.container_family OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE col.container_family IS E'General family of containers';
-- ddl-end --
--ALTER SEQUENCE col.container_type_container_type_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.container_type OWNER TO collec;
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
ALTER TABLE col.dbparam OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE col.dbparam IS E'Table of parameters intrinsically associated to the instance';
-- ddl-end --
COMMENT ON COLUMN col.dbparam.dbparam_name IS E'Name of the parameter';
-- ddl-end --
COMMENT ON COLUMN col.dbparam.dbparam_value IS E'Value of the parameter';
-- ddl-end --
--ALTER SEQUENCE col.dbversion_dbversion_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.dbversion OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE col.dbversion IS E'Table of the database versions';
-- ddl-end --
COMMENT ON COLUMN col.dbversion.dbversion_number IS E'Number of the version';
-- ddl-end --
COMMENT ON COLUMN col.dbversion.dbversion_date IS E'Date of the version';
-- ddl-end --
--ALTER SEQUENCE col.document_document_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.document OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE col.document IS E'Numeric docs associated to an objet or a campaign';
-- ddl-end --
ALTER TABLE col.document ALTER COLUMN uid DROP NOT NULL;
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
--ALTER SEQUENCE col.event_event_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.event OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE col.event IS E'Table of events';
-- ddl-end --
COMMENT ON COLUMN col.event.event_date IS E'Date-time of the event';
-- ddl-end --
COMMENT ON COLUMN col.event.still_available IS E'still available content in the object, after the event';
-- ddl-end --
COMMENT ON COLUMN col.event.event_comment IS E'Comment';
-- ddl-end --
--ALTER SEQUENCE col.event_type_event_type_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.event_type OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE col.event_type IS E'Event types table';
-- ddl-end --
COMMENT ON COLUMN col.event_type.event_type_name IS E'Name of the type of event';
-- ddl-end --
COMMENT ON COLUMN col.event_type.is_sample IS E'The event is applicable to the samples';
-- ddl-end --
COMMENT ON COLUMN col.event_type.is_container IS E'The event is applicable to the containers';
-- ddl-end --
--ALTER SEQUENCE col.identifier_type_identifier_type_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.identifier_type OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE col.identifier_type IS E'Table of identifier types';
-- ddl-end --
COMMENT ON COLUMN col.identifier_type.identifier_type_name IS E'Textual name of the identifier';
-- ddl-end --
COMMENT ON COLUMN col.identifier_type.identifier_type_code IS E'Identifier code, used in the labels';
-- ddl-end --
COMMENT ON COLUMN col.identifier_type.used_for_search IS E'Is the identifier usable for barcode searches?';
-- ddl-end --
--ALTER SEQUENCE col.label_label_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.label OWNER TO collec;
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
--ALTER SEQUENCE col.storage_storage_id_seq OWNER TO collec;
-- ddl-end --
ALTER VIEW col.last_photo OWNER TO collec;
-- ddl-end --
--ALTER SEQUENCE col.metadata_metadata_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.metadata OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE col.metadata IS E'Table of metadata usable with types of samples';
-- ddl-end --
COMMENT ON COLUMN col.metadata.metadata_name IS E'Name of the metadata set';
-- ddl-end --
COMMENT ON COLUMN col.metadata.metadata_schema IS E'JSON schema of the metadata form';
-- ddl-end --
--ALTER SEQUENCE col.mime_type_mime_type_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.mime_type OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE col.mime_type IS E'Mime types of imported files';
-- ddl-end --
COMMENT ON COLUMN col.mime_type.extension IS E'File extension';
-- ddl-end --
COMMENT ON COLUMN col.mime_type.content_type IS E'Official mime type';
-- ddl-end --
--ALTER SEQUENCE col.storage_reason_storage_reason_id_seq OWNER TO collec;
-- ddl-end --
--ALTER SEQUENCE col.movement_type_movement_type_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.movement_type OWNER TO collec;
-- ddl-end --
--ALTER SEQUENCE col.multiple_type_multiple_type_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.multiple_type OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE col.multiple_type IS E'Table of categories of potential sub-sampling (unit, quantity, percentage, etc.)';
-- ddl-end --
--ALTER SEQUENCE col.object_uid_seq OWNER TO collec;
-- ddl-end --
--ALTER SEQUENCE col.object_identifier_object_identifier_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.object_identifier OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE col.object_identifier IS E'Table of complementary identifiers';
-- ddl-end --
COMMENT ON COLUMN col.object_identifier.object_identifier_value IS E'Identifier value';
-- ddl-end --
--ALTER SEQUENCE col.object_status_object_status_id_seq OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE col.object_status_object_status_id_seq
	START WITH 7
;
-- ddl-end --
ALTER TABLE col.object_status OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE col.object_status IS E'Table of types of status';
-- ddl-end --
--ALTER SEQUENCE col.operation_operation_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.operation OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE col.operation IS E'List of operations attached to a protocol';
-- ddl-end --
COMMENT ON COLUMN col.operation.operation_order IS E'Order to perform the operation in the protocol';
-- ddl-end --
COMMENT ON COLUMN col.operation.operation_version IS E'Version of the operation';
-- ddl-end --
COMMENT ON COLUMN col.operation.last_edit_date IS E'Last edit date of the operation';
-- ddl-end --
--ALTER SEQUENCE col.printer_printer_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.printer OWNER TO collec;
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
ALTER TABLE col.collection OWNER TO collec;
-- ddl-end --
--ALTER SEQUENCE col.protocol_protocol_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.protocol OWNER TO collec;
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
--ALTER SEQUENCE col.referent_referent_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.referent OWNER TO collec;
-- ddl-end --
--ALTER SEQUENCE col.sample_sample_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.sample OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE col.sample IS E'Table of samples';
-- ddl-end --
COMMENT ON COLUMN col.sample.sample_creation_date IS E'Creation date of the record in the database';
-- ddl-end --
COMMENT ON COLUMN col.sample.sampling_date IS E'Creation date of the physical sample or date of sampling';
-- ddl-end --
COMMENT ON COLUMN col.sample.multiple_value IS '';
-- ddl-end --
COMMENT ON COLUMN col.sample.dbuid_origin IS E'Reference used in the original database, under the form db:uid. Used for read the labels created in others instances';
-- ddl-end --
COMMENT ON COLUMN col.sample.metadata IS E'Metadata associated with the sample, in JSON format';
-- ddl-end --
COMMENT ON COLUMN col.sample.expiration_date IS E'Date of expiration of the sample. After this date, the sample is not usable';
-- ddl-end --
--ALTER SEQUENCE col.sample_type_sample_type_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.sample_type OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE col.sample_type IS E'Table of the types of samples';
-- ddl-end --
COMMENT ON COLUMN col.sample_type.sample_type_name IS E'Name of the type';
-- ddl-end --
COMMENT ON COLUMN col.sample_type.multiple_unit IS E'Name of the unit used  to qualify the number of sub-samples (ml, number, g, etc.)';
-- ddl-end --
COMMENT ON COLUMN col.sample_type.identifier_generator_js IS E'Javascript function code used to automaticaly generate a working identifier from the intered information';
-- ddl-end --
--ALTER SEQUENCE col.sampling_place_sampling_place_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.sampling_place OWNER TO collec;
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
--ALTER SEQUENCE col.storage_condition_storage_condition_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.storage_condition OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE col.storage_condition IS E'Table of the conditions of storage';
-- ddl-end --
ALTER TABLE col.movement_reason OWNER TO collec;
-- ddl-end --
ALTER TABLE col.movement OWNER TO collec;
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
--ALTER SEQUENCE col.subsample_subsample_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE col.subsample OWNER TO collec;
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
ALTER VIEW col.v_object_identifier OWNER TO collec;
-- ddl-end --
--ALTER SEQUENCE gacl.aclgroup_aclgroup_id_seq OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE gacl.aclgroup_aclgroup_id_seq
	START WITH 7
;
-- ddl-end --
ALTER TABLE gacl.aclacl OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE gacl.aclacl IS E'Table of rights granted';
-- ddl-end --
--ALTER SEQUENCE gacl.aclaco_aclaco_id_seq OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE gacl.aclaco_aclaco_id_seq
	START WITH 7
;
-- ddl-end --
ALTER TABLE gacl.aclaco OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE gacl.aclaco IS E'Table of managed rights';
-- ddl-end --
COMMENT ON COLUMN gacl.aclaco.aco IS E'Name of the right in the application';
-- ddl-end --
--ALTER SEQUENCE gacl.aclappli_aclappli_id_seq OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE gacl.aclappli_aclappli_id_seq
	START WITH 2
;
-- ddl-end --
ALTER TABLE gacl.aclappli OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE gacl.aclappli IS E'Table of managed applications';
-- ddl-end --
COMMENT ON COLUMN gacl.aclappli.appli IS E'Code of the application used to manage the rights';
-- ddl-end --
COMMENT ON COLUMN gacl.aclappli.applidetail IS E'Description of the application';
-- ddl-end --
ALTER TABLE gacl.aclgroup OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE gacl.aclgroup IS E'Groups of logins';
-- ddl-end --
COMMENT ON COLUMN gacl.aclgroup.groupe IS E'Name of the group';
-- ddl-end --
COMMENT ON COLUMN gacl.aclgroup.aclgroup_id_parent IS E'Parent group who inherits of the rights attributed to this group';
-- ddl-end --
--ALTER SEQUENCE gacl.acllogin_acllogin_id_seq OWNER TO collec;
-- ddl-end --
ALTER SEQUENCE gacl.acllogin_acllogin_id_seq
	START WITH 2
;
-- ddl-end --
ALTER TABLE gacl.acllogin OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE gacl.acllogin IS E'List of logins granted to access to the modules of the application';
-- ddl-end --
COMMENT ON COLUMN gacl.acllogin.login IS E'Login. It must be the same as the table logingestion';
-- ddl-end --
COMMENT ON COLUMN gacl.acllogin.logindetail IS E'Displayed name';
-- ddl-end --
ALTER TABLE gacl.acllogingroup OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE gacl.acllogingroup IS E'List of logins in the groups';
-- ddl-end --
--ALTER SEQUENCE gacl.log_log_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE gacl.log OWNER TO collec;
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
--ALTER SEQUENCE gacl.seq_logingestion_id OWNER TO postgres;
-- ddl-end --
ALTER SEQUENCE gacl.seq_logingestion_id
	START WITH 2
;
-- ddl-end --
ALTER TABLE gacl.logingestion OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE gacl.logingestion IS E'List of logins used to connect to the application, when the account is managed by the application itself. This table also contains the accounts authorized to use the web services.';
-- ddl-end --
ALTER TABLE gacl.logingestion ALTER COLUMN login TYPE varchar;
-- ddl-end --
COMMENT ON COLUMN gacl.logingestion.login IS E'Login used by the user';
-- ddl-end --
ALTER TABLE gacl.logingestion ALTER COLUMN password TYPE varchar;
-- ddl-end --
ALTER TABLE gacl.logingestion ALTER COLUMN nom TYPE varchar;
-- ddl-end --
COMMENT ON COLUMN gacl.logingestion.nom IS E'Name of the user';
-- ddl-end --
ALTER TABLE gacl.logingestion ALTER COLUMN prenom TYPE varchar;
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
--ALTER SEQUENCE gacl.passwordlost_passwordlost_id_seq OWNER TO collec;
-- ddl-end --
ALTER TABLE gacl.passwordlost OWNER TO collec;
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
COMMENT ON TABLE col.borrowing IS E'List of borrowings';
-- ddl-end --
ALTER VIEW col.last_borrowing OWNER TO collec;
-- ddl-end --
ALTER TABLE col.object OWNER TO collec;
-- ddl-end --
COMMENT ON TABLE col.object IS E'Table of objects';
-- ddl-end --
ALTER TABLE col.object ALTER COLUMN uid SET DEFAULT nextval('col.object_uid_seq'::regclass);
-- ddl-end --
COMMENT ON COLUMN col.object.uid IS E'Unique identifier in the database of all objects';
-- ddl-end --
COMMENT ON COLUMN col.object.identifier IS E'Main working identifier';
-- ddl-end --
COMMENT ON COLUMN col.object.wgs84_x IS E'GPS longitude, in decimal form';
-- ddl-end --
COMMENT ON COLUMN col.object.wgs84_y IS E'GPS latitude, in decimal form';
-- ddl-end --


-- [ Created constraints ] --
-- object: projet_group_pk | type: CONSTRAINT --
-- ALTER TABLE col.collection_group DROP CONSTRAINT IF EXISTS projet_group_pk CASCADE;
--ALTER TABLE col.collection_group ADD CONSTRAINT projet_group_pk PRIMARY KEY (collection_id,aclgroup_id);
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

INSERT INTO col.dbversion (dbversion_number, dbversion_date) 
VALUES (E'2.4', E'2020-03-01');

