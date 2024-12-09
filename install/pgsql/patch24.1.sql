/*
patch when the database was created with the script of version v24.1
*/

ALTER FUNCTION col.getgroupsfromcollection(integer) OWNER TO collec;
INSERT INTO col.dataset_type (dataset_type_id, dataset_type_name, fields) VALUES (E'1', E'sample', E'["uid","uuid","identifier","wgs84_x","wgs84_y","location_accuracy","object_status_name","referent_name","referent_email","address_name","address_line2","address_line3","address_city","address_country","referent_phone","referent_firstname","academic_directory","academic_link","object_comment","identifiers","sample_creation_date","sampling_date","multiple_value","sampling_place_name","expiration_date","sample_type_name","storage_product","clp_classification","multiple_type_name","collection_name","metadata","metadata_unit","parent_uid","parent_uuid","parent_identifiers","web_address","content_type","container_uid","container_identifier","container_uuid","storage_type_name","fixed_value","country_code","country_origin_code","trashed,campaign_id","campaign_name","campaign_uuid"]')
on conflict do nothing;
-- ddl-end --
INSERT INTO col.dataset_type (dataset_type_id, dataset_type_name, fields) VALUES (E'2', E'collection', '["collection_name","collection_displayname","collection_keywords","referent_name","referent_firstname","academical_directory","academical_link","referent_email","address_name","address_line2","address_line3","address_city","address_country","referent_phone","fixed_value"]')
on conflict do nothing;
-- ddl-end --
INSERT INTO col.dataset_type (dataset_type_id, dataset_type_name, fields) VALUES (E'3', E'document', '["document_name","document_uuid","uid","sample_uuid","identifier","content_type","extension","size","document_creation_date","fixed_value","web_address"]')
on conflict do nothing;
-- ddl-end --
INSERT INTO col.dataset_type (dataset_type_id, dataset_type_name, fields) VALUES (E'4', E'arbitrary content', '["content"]')
on conflict do nothing;
-- ddl-end --
INSERT INTO col.export_model (export_model_id, export_model_name, pattern) VALUES (1, E'export_model', '[{"tableName":"export_model","businessKey":"export_model_name","istable11":false,"children":[],"booleanFields":[],"istablenn":false}]')
on conflict do nothing;
-- ddl-end --
INSERT INTO col.export_model (export_model_id,export_model_name, pattern) VALUES (2, E'export_template', '[{"tableName":"export_template","technicalKey":"export_template_id","isEmpty":false,"businessKey":"export_template_name","istable11":false,"children":[{"aliasName":"export_dataset","isStrict":true}],"parents":[],"istablenn":false},{"tableName":"export_dataset","isEmpty":false,"parentKey":"export_template_id","istable11":false,"children":[],"parents":[{"aliasName":"dataset_template","fieldName":"dataset_template_id"}],"istablenn":true,"tablenn":{"secondaryParentKey":"dataset_template_id","tableAlias":"dataset_template"}},{"tableName":"dataset_template","technicalKey":"dataset_template_id","isEmpty":true,"businessKey":"dataset_template_name","istable11":false,"children":[{"aliasName":"dataset_column","isStrict":true}],"parents":[],"istablenn":false},{"tableName":"dataset_column","technicalKey":"dataset_column_id","isEmpty":false,"parentKey":"dataset_template_id","istable11":false,"children":[],"parents":[{"aliasName":"translator","fieldName":"translator_id"}],"istablenn":false},{"tableName":"translator","technicalKey":"translator_id","isEmpty":true,"businessKey":"translator_name","istable11":false,"children":[],"parents":[],"istablenn":false}]')
on conflict do nothing;

-- object: col.last_movement | type: VIEW --
-- DROP VIEW IF EXISTS col.last_movement CASCADE;
CREATE or replace VIEW col.last_movement
AS 

SELECT m.uid,
    m.movement_id,
    m.movement_date,
    m.movement_type_id,
    m.container_id,
    c.uid AS container_uid,
    o2.identifier AS container_identifier,
    m.line_number,
    m.column_number,
    m.movement_reason_id
   FROM col.movement m
     JOIN col.object o ON m.movement_id = o.last_movement_id
     LEFT JOIN col.container c USING (container_id)
     left join col.object o2 on (c.uid = o2.uid);
-- ddl-end --

-- object: col.slots_used | type: VIEW --
-- DROP VIEW IF EXISTS col.slots_used CASCADE;
CREATE or replace VIEW col.slots_used
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