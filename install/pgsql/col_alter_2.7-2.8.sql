alter table col.event add column due_date timestamp,
alter column event_date drop not null
;
COMMENT ON COLUMN col.event.due_date IS E'Due date of the event';

-- object: event_date_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.event_date_idx CASCADE;
CREATE INDEX event_date_idx ON col.event
USING btree
(
	event_date
);
-- ddl-end --

-- object: due_date_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.due_date_idx CASCADE;
CREATE INDEX due_date_idx ON col.event
USING btree
(
	due_date
);

CREATE TABLE col.collection_eventtype (
	collection_id integer NOT NULL,
	event_type_id integer NOT NULL,
	CONSTRAINT collection_eventtype_1 PRIMARY KEY (collection_id,event_type_id) DEFERRABLE INITIALLY IMMEDIATE
);
-- ddl-end --
COMMENT ON TABLE col.collection_eventtype IS E'List of event types attached to a collection';
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

CREATE TABLE col.collection_sampletype (
	collection_id integer NOT NULL,
	sample_type_id integer NOT NULL,
	CONSTRAINT collection_sampletype_1 PRIMARY KEY (collection_id,sample_type_id) DEFERRABLE INITIALLY IMMEDIATE
);
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

alter table gacl.logingestion add column nbattempts smallint DEFAULT 0,
	add column lastattempt timestamp;
COMMENT ON COLUMN gacl.logingestion.nbattempts IS E'Number of connection attemps';
-- ddl-end --
COMMENT ON COLUMN gacl.logingestion.lastattempt IS E'last attemp of connection';
-- ddl-end --

insert into col.dbversion (dbversion_number, dbversion_date) values ('2.8', '2022-09-26');
