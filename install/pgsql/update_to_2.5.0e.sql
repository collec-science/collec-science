-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2
-- Diff date: 2020-09-28 12:18:56
-- Source model: collec
-- Database: collec
-- PostgreSQL version: 11.0

-- [ Diff summary ]
-- Dropped objects: 11
-- Created objects: 15
-- Changed objects: 12
-- Truncated tables: 0

SET search_path=public,pg_catalog,col,gacl;
-- ddl-end --





-- [ Created objects ] --
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




-- ddl-end --
ALTER TABLE col.collection ALTER COLUMN allowed_import_flow SET DEFAULT 'f';
-- ddl-end --
ALTER TABLE col.collection ALTER COLUMN allowed_export_flow SET DEFAULT 'f';
-- ddl-end --
ALTER TABLE col.collection ALTER COLUMN public_collection SET DEFAULT 'f';
-- ddl-end --
COMMENT ON EXTENSION btree_gin IS '';
-- ddl-end --
ALTER TABLE col.object ALTER COLUMN change_date SET DEFAULT 'now';
-- ddl-end --
ALTER TABLE col.object ALTER COLUMN location_accuracy TYPE float;
-- ddl-end --
ALTER TABLE col.object ALTER COLUMN geom TYPE geography(POINT, 4326);
-- ddl-end --
ALTER TABLE col.lot ALTER COLUMN lot_date SET DEFAULT current_timestamp;
-- ddl-end --
COMMENT ON COLUMN col.dataset_column.subfield_name IS E'Name of the field if it into the metadata description of the sample or secondary identifier, etc.';
-- ddl-end --
COMMENT ON COLUMN col.dataset_column.column_order IS E'order of displaying in the exported file';
-- ddl-end --
ALTER TABLE col.dataset_column ALTER COLUMN mandatory SET DEFAULT 'f';
-- ddl-end --
