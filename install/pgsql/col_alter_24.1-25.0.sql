set search_path = col,gacl,public;
create unique index if not exists dbparamname_idx on dbparam (dbparam_name);
insert into dbparam (dbparam_name, dbparam_value, dbparam_description, dbparam_description_en)
values (
'APPLI_code', 
'code',
'Code de l''application, pour les exportations',
'Code of the application, to export data'
) 
on conflict do nothing;
alter table gacl.acllogin add column email varchar;
alter table gacl.logingestion add column if not exists is_expired boolean;
alter table gacl.logingestion add column if not exists nbattempts integer;
alter table gacl.logingestion add column if not exists lastattempt timestamp;

update aclgroup set groupe = 'manage' where groupe = 'gestion';
update aclaco set aco = 'manage' where aco = 'gestion';

select setval('mime_type_mime_type_id_seq', (select max(mime_type_id) from mime_type));
select setval('dataset_type_dataset_type_id_seq', (select max(dataset_type_id) from dataset_type));

alter table subsample add column createdsample_id integer;
ALTER TABLE subsample ADD CONSTRAINT sample_id FOREIGN KEY (createdsample_id)
REFERENCES sample (sample_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
CREATE INDEX subsample_createdsample_id_idx ON subsample
USING btree
(
	createdsample_id
);
create view v_sample_parents as 
(select ss.createdsample_id as sample_id,
array_to_string (array_agg((p.uid::text || ' '|| po.identifier::text) order by p.uid), ', ') as sample_parents
from subsample ss
join sample p on (ss.sample_id = p.sample_id)
join object po on (p.uid = po.uid)
group by ss.createdsample_id
);

create or replace view v_derivated_number as (
	SELECT s.uid,
	count(*) AS nb_derivated_sample
	FROM col.sample s
	JOIN col.sample d ON d.parent_sample_id = s.sample_id
	GROUP BY s.uid
);

alter table borrowing add column borrowing_comment varchar;

alter table container_type add column nbobject_by_slot integer DEFAULT 0;

create or replace view slots_used as (
with req as (
select container_id, line_number, column_number, count(*) as qty_by_slot
from last_movement
where movement_type_id = 1
group by container_id, line_number, column_number)
select container_id, sum (qty_by_slot)::bigint as nb_slots_used
from req
group by container_id
);
update dbparam set dbparam_name = 'APP_title' where dbparam_name = 'APPLI_title';

alter table sample_type add column sample_type_code varchar;
comment on column sample_type.sample_type_code is 'Code used to exchange information with others providers without use the name of the sample type';

update dbparam set dbparam_name = 'APPLI_title' where dbparam_name = 'APP_title';

alter table log alter column login type varchar;

insert into dbversion (dbversion_date, dbversion_number) values ('2024-09-18','25.0');

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
   col.last_movement
WHERE
   movement_type_id = 1
   group by container_id;
-- ddl-end --
ALTER VIEW col.slots_used OWNER TO collec;
-- ddl-end --