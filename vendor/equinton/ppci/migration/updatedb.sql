set search_path = app,gacl,public;
create unique index if not exists dbparamname_idx on dbparam (dbparam_name);
insert into dbparam (dbparam_name, dbparam_value, dbparam_description, dbparam_description_en)
values (
'APPLI_code', 
'code_of_instance',
'Code de l''instance, pour les exportations',
'Code of the instance, to export data'
) 
on conflict do nothing;
alter table gacl.acllogin add column email varchar;
alter table gacl.logingestion add column if not exists is_expired boolean;
alter table gacl.logingestion add column if not exists nbattempts integer;
alter table gacl.logingestion add column if not exists lastattempt datetime;

update gacl.aclgroup set groupe = 'manage' where groupe = 'gestion';
update gacl.aclaco set aco = 'manage' where aco = 'gestion';
