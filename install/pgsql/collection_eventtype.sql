CREATE TABLE col.collection_eventtype (
	collection_id integer NOT NULL,
	event_type_id integer NOT NULL,
	CONSTRAINT collection_eventtype_1 PRIMARY KEY (collection_id,event_type_id) DEFERRABLE INITIALLY IMMEDIATE
);
-- ddl-end --
COMMENT ON TABLE col.collection_eventtype IS E'List of event types attached to a collection';
-- ddl-end --
ALTER TABLE col.collection_eventtype OWNER TO collec;
-- ddl-end --


-- object: collection | type: CONSTRAINT --
-- ALTER TABLE col.collection_eventtype DROP CONSTRAINT IF EXISTS collection CASCADE;
ALTER TABLE col.collection_eventtype ADD CONSTRAINT collection FOREIGN KEY (collection_id)
REFERENCES col.collection (collection_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: event_type | type: CONSTRAINT --
-- ALTER TABLE col.collection_eventtype DROP CONSTRAINT IF EXISTS event_type CASCADE;
ALTER TABLE col.collection_eventtype ADD CONSTRAINT event_type FOREIGN KEY (event_type_id)
REFERENCES col.event_type (event_type_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- DROP FUNCTION IF EXISTS col.geteventtypesfromcollection(integer) CASCADE;
CREATE FUNCTION col.geteventtypesfromcollection (IN collection_id integer)
	RETURNS varchar
	LANGUAGE sql
	VOLATILE
	CALLED ON NULL INPUT
	SECURITY INVOKER
	PARALLEL UNSAFE
	COST 1
	AS $$
select array_to_string(array_agg(event_type_name), ', ') as eventtypes
from col.collection_eventtype
join col.event_type using (event_type_id)
where collection_id = $1
$$;
-- ddl-end --
ALTER FUNCTION col.geteventtypesfromcollection(integer) OWNER TO collec;
-- ddl-end --
