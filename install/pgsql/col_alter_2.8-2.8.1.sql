DROP FUNCTION IF EXISTS col.geteventtypesfromcollection(integer) CASCADE;
CREATE FUNCTION col.geteventtypesfromcollection (IN collection_id integer)
	RETURNS varchar
	LANGUAGE sql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	PARALLEL UNSAFE
	COST 1
	AS $$
select array_to_string(array_agg(event_type_name order by event_type_name), ', ') as eventtypes
from col.collection_eventtype
join col.event_type using (event_type_id)
where collection_id = $1
$$;
-- ddl-end --
ALTER FUNCTION col.geteventtypesfromcollection(integer) OWNER TO collec;
-- ddl-end --


DROP FUNCTION IF EXISTS col.getsampletypesfromcollection(integer) CASCADE;
CREATE FUNCTION col.getsampletypesfromcollection (IN collection_id integer)
	RETURNS varchar
	LANGUAGE sql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	PARALLEL UNSAFE
	COST 1
	AS $$
select array_to_string(array_agg(sample_type_name order by sample_type_name), ', ') as sampletypes
from col.collection_sampletype
join col.sample_type using (sample_type_id)
where collection_id = $1
$$;
-- ddl-end --
ALTER FUNCTION col.getsampletypesfromcollection(integer) OWNER TO collec;
-- ddl-end --

drop index if exists col.object_identifier_idx;
create index object_identifier_idx on col.object using gist (lower(identifier) gist_trgm_ops);

CREATE INDEX object_uuid_idx if not exists ON col.object
USING btree
(
	uuid
);

/*
 * Recreate the metadata index with the gist operande
 */
create or replace function col.regenerate_metadata_indexes() returns int as 
$$
	declare indexrec record;
	declare columnname varchar;
	declare commande varchar;
BEGIN
 FOR indexrec IN 
 select indexname from pg_indexes where schemaname = 'col' and indexname like 'sample_metadata_lower_%' 
 loop
	 columnname := substring(indexrec.indexname, 23, length(indexrec.indexname) -26);
	raise notice 'Régénération des index des métadonnées - Traitement de %  - Métadonnée concernée : %', indexrec.indexname, columnname;
	 execute format('drop index col.%I',indexrec.indexname) ;
	execute format( 'create index %I ON col.sample using gist((lower(metadata->>%L)) gist_trgm_ops)', indexrec.indexname, columnname);
 END LOOP;
return 1; 
END;
$$
language 'plpgsql';

select col.regenerate_metadata_indexes();

insert into col.dbversion (dbversion_number, dbversion_date) values ('2.8.1', '2022-12-01');

