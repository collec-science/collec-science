/*
 * Script d'amelioration des performances en recherche d'echantillons
 */
 SET search_path = col;
 create extension pg_trgm;

drop index object_identifier_idx;
create index object_identifier_idx on object using gin (identifier gin_trgm_ops);
create index object_identifier_value_idx on object_identifier using gin (object_identifier_value gin_trgm_ops);
create index sample_dbuid_origin_idx on sample using gin (dbuid_origin gin_trgm_ops);

/*
 * amelioration de la recherche pour les metadonnees
 * creez un index pour chaque item utilise dans les recherches
 * exemple : 
 * create index sample_metadata_taxon_idx on sample using gin (upper(metadata->>'taxon') gin_trgm_ops);
 */
 
