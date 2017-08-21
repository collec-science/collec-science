set search_path = col;

drop table metadata_form cascade;
drop table sample_metadata cascade;

alter table sample add column metadata json;
alter table operation add column metadata_schema json;
comment on column operation.metadata_schema is 'Schema Json du formulaire des metadonnees';
comment on column sample.metadata is 'Metadonnees associees de l''echantillon';
