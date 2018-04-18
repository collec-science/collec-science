/*
 * Mise a jour du schema de la base de donnees
 * version 1.2.3
 */
 /*
  * Ajout du droit import
  */
set search_path=gacl;
insert into aclaco (aclaco_id, aclappli_id, aco) values (6, 1, 'import');
insert into aclgroup (aclgroup_id, groupe, aclgroup_id_parent) values (6, 'import', 3);
insert into aclacl (aclaco_id, aclgroup_id) values (6, 6);
select setval('aclaco_aclaco_id_seq', (select max(aclaco_id) from aclaco));
select setval('aclgroup_aclgroup_id_seq', (select max(aclgroup_id) from aclgroup));

/*
 * Script d'amelioration des performances en recherche d'echantillons
 */
 SET search_path = col;
 create extension if not exists pg_trgm with schema pg_catalog;

drop index if exists object_identifier_idx;
create index object_identifier_idx on object using gin (identifier gin_trgm_ops);
create index if not exists object_identifier_value_idx on object_identifier using gin (object_identifier_value gin_trgm_ops);
create index if not exists sample_dbuid_origin_idx on sample using gin (dbuid_origin gin_trgm_ops);

/*
 * amelioration de la recherche pour les metadonnees
 * creez un index pour chaque item utilise dans les recherches
 * exemple : 
 * create index sample_metadata_taxon_idx on sample using gin ((metadata->>'taxon') gin_trgm_ops);
 */
 /*
 * Fin d'execution du script
 * Mise a jour de dbversion
 */
insert into dbversion ("dbversion_number", "dbversion_date")
values 
('1.2.3','2017-11-22');
