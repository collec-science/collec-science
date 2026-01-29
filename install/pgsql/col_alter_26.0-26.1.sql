-- ** Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- ** pgModeler version: 1.2.2
-- ** Diff date: 2026-01-03 19:13:15
-- ** Source model: collec
-- ** Database: collec
-- ** PostgreSQL version: 18.0

-- ** [ Diff summary ]
-- ** Dropped objects: 1
-- ** Created objects: 10
-- ** Changed objects: 20

SET check_function_bodies = false;
-- ddl-end --

SET search_path=public,pg_catalog,col,gacl;
-- ddl-end --

-- ** [ Created objects ]

-- object: col.samplehisto | type: TABLE --
-- DROP TABLE IF EXISTS col.samplehisto CASCADE;
CREATE TABLE col.samplehisto (
	samplehisto_id serial NOT NULL,
	samplehisto_login varchar,
	samplehisto_date timestamp NOT NULL DEFAULT now(),
	oldvalues json,
	sample_id integer,
	CONSTRAINT samplehisto_pk PRIMARY KEY (samplehisto_id)
);
-- ddl-end --
COMMENT ON COLUMN col.samplehisto.samplehisto_login IS E'Login of the user that made the change';
-- ddl-end --
COMMENT ON COLUMN col.samplehisto.oldvalues IS E'Old values changed at this date, in a multiple field in json format. The value "new" says that the value is created';
-- ddl-end --
ALTER TABLE col.samplehisto OWNER TO collec;
-- ddl-end --

-- object: campaign_description | type: COLUMN --
ALTER TABLE col.campaign ADD COLUMN campaign_description varchar;
-- ddl-end --

COMMENT ON COLUMN col.campaign.campaign_description IS E'Description of the campaign';
-- ddl-end --


-- object: collection_id | type: COLUMN --
ALTER TABLE col.document ADD COLUMN collection_id integer;
-- ddl-end --


-- object: collection_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.collection_id_idx CASCADE;
CREATE INDEX collection_id_idx ON col.document
USING btree
(
	collection_id
);
-- ddl-end --

-- object: campaign_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.campaign_id_idx CASCADE;
CREATE INDEX campaign_id_idx ON col.document
USING btree
(
	campaign_id
);
-- ddl-end --

-- object: event_id_dx | type: INDEX --
-- DROP INDEX IF EXISTS col.event_id_dx CASCADE;
CREATE INDEX event_id_dx ON col.document
USING btree
(
	event_id
);
-- ddl-end --

-- object: sample_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.sample_id_idx CASCADE;
CREATE INDEX sample_id_idx ON col.samplehisto
USING btree
(
	sample_id
);
-- ddl-end --

-- object: collection_description | type: COLUMN --
ALTER TABLE col.collection ADD COLUMN collection_description varchar;
-- ddl-end --

COMMENT ON COLUMN col.collection.collection_description IS E'Description of the collection';
-- ddl-end --

alter table col.object add column object_login varchar;
comment on column col.object.object_login is E'Login that created the object';
CREATE INDEX object_login_idx ON col.object
USING btree
(
	object_login
);
INSERT INTO col.dbversion (dbversion_number, dbversion_date) VALUES (E'26.1', E'2026-02-01');
