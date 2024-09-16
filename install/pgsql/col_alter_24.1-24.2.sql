set search_path = col,gacl,public;
create unique index if not exists dbparamname_idx on dbparam (dbparam_name);
insert into dbparam (dbparam_name, dbparam_value, dbparam_description, dbparam_description_en)
values (
'APPLI_code', 
'APP_code',
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