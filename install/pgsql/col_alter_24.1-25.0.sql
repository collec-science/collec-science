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
alter table gacl.logingestion add column if not exists lastattempt datetime;

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

insert into dbversion (dbversion_date, dbversion_number) values ('2024-09-18','25.0');