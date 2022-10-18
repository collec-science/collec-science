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

insert into col.dbversion (dbversion_number, dbversion_date) values ('2.8.1', '2022-11-01');

