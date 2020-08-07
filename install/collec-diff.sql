-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2
-- Diff date: 2020-03-16 13:45:16
-- Source model: collec
-- Database: collec
-- PostgreSQL version: 11.0

-- [ Diff summary ]
-- Dropped objects: 0
-- Created objects: 0
-- Changed objects: 14
-- Truncated tables: 0

SET search_path=public,pg_catalog,col,gacl;
-- ddl-end --



-- ddl-end --
COMMENT ON COLUMN col.event_type.event_type_name IS E'Name of the type of event';
-- ddl-end --
COMMENT ON COLUMN col.label.label_fields IS E'List of fields incorporated in the QRCODE';
-- ddl-end --
COMMENT ON COLUMN col.label.metadata_id IS E'Model of the metadata template associated with this label';
-- ddl-end --
COMMENT ON TABLE col.multiple_type IS E'Table of categories of potential sub-sampling (unit, quantity, percentage, etc.)';
-- ddl-end --
COMMENT ON COLUMN col.printer.printer_user IS E'User used to print, if necessary';
-- ddl-end --

-- ddl-end --
COMMENT ON TABLE gacl.aclgroup IS E'Groups of logins';
-- ddl-end --

