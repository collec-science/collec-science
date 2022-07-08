CREATE TABLE col.collection_sampletype (
	collection_id integer NOT NULL,
	sample_type_id integer NOT NULL,
	CONSTRAINT collection_sampletype_1 PRIMARY KEY (collection_id,sample_type_id) DEFERRABLE INITIALLY IMMEDIATE
);
-- ddl-end --
ALTER TABLE col.collection_sampletype OWNER TO collec;
-- ddl-end --

-- object: collection | type: CONSTRAINT --
-- ALTER TABLE col.collection_sampletype DROP CONSTRAINT IF EXISTS collection CASCADE;
ALTER TABLE col.collection_sampletype ADD CONSTRAINT collection FOREIGN KEY (collection_id)
REFERENCES col.collection (collection_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: sample_type | type: CONSTRAINT --
-- ALTER TABLE col.collection_sampletype DROP CONSTRAINT IF EXISTS sample_type CASCADE;
ALTER TABLE col.collection_sampletype ADD CONSTRAINT sample_type FOREIGN KEY (sample_type_id)
REFERENCES col.sample_type (sample_type_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
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
select array_to_string(array_agg(sample_type_name), ', ') as sampletypes
from col.collection_sampletype
join col.sample_type using (sample_type_id)
where collection_id = $1
$$;
-- ddl-end --
ALTER FUNCTION col.getsampletypesfromcollection(integer) OWNER TO collec;
-- ddl-end --
DROP FUNCTION IF EXISTS col.getgroupsfromcollection(integer) CASCADE;
CREATE FUNCTION col.getgroupsfromcollection (collection_id integer)
	RETURNS varchar
	LANGUAGE sql
	VOLATILE
	CALLED ON NULL INPUT
	SECURITY INVOKER
	PARALLEL UNSAFE
	COST 1
	AS $$
select array_to_string(array_agg(groupe),', ') as groupes
from col.collection_group
join gacl.aclgroup using (aclgroup_id)
where collection_id = $1
$$;
-- ddl-end --
ALTER FUNCTION col.getgroupsfromcollection(integer) OWNER TO postgres;
-- ddl-end --
