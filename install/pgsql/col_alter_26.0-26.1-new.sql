-- ** Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- ** pgModeler version: 1.2.3
-- ** Diff date: 2026-02-17 19:36:43
-- ** Source model: collec
-- ** Database: test
-- ** PostgreSQL version: 18.0

-- ** [ Diff summary ]
-- ** Dropped objects: 0
-- ** Created objects: 11
-- ** Changed objects: 13

SET check_function_bodies = false;
-- ddl-end --

SET search_path=public,pg_catalog,col,gacl;
-- ddl-end --


-- ** [ Created objects ]

-- object: collection_description | type: COLUMN --
ALTER TABLE col.collection ADD COLUMN collection_description varchar;
-- ddl-end --

COMMENT ON COLUMN col.collection.collection_description IS E'Description of the collection';
-- ddl-end --


-- object: object_login | type: COLUMN --
ALTER TABLE col.object ADD COLUMN object_login varchar;
-- ddl-end --

COMMENT ON COLUMN col.object.object_login IS E'Login that created the object';
-- ddl-end --


-- object: campaign_description | type: COLUMN --
ALTER TABLE col.campaign ADD COLUMN campaign_description varchar;
-- ddl-end --

COMMENT ON COLUMN col.campaign.campaign_description IS E'Description of the campaign';
-- ddl-end --


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



-- ** [ Changed objects ]

-- object: col.last_borrowing | type: VIEW --
-- DROP VIEW IF EXISTS col.last_borrowing CASCADE;
CREATE OR REPLACE VIEW col.last_borrowing
AS 
SELECT b1.borrowing_id,
    	b1.uid,
    	b1.borrowing_date,
    	b1.expected_return_date,
    	b1.borrower_id
	FROM col.borrowing b1
	WHERE (b1.borrowing_id = ( SELECT b2.borrowing_id
           FROM col.borrowing b2
          WHERE ((b1.uid = b2.uid) AND (b2.return_date IS NULL))
          ORDER BY b2.borrowing_date DESC
         LIMIT 1)
		);
-- ddl-end --
ALTER VIEW col.last_borrowing OWNER TO collec;
-- ddl-end --


-- ** [ Created foreign keys ]

-- object: sample_fk | type: CONSTRAINT --
-- ALTER TABLE col.samplehisto DROP CONSTRAINT IF EXISTS sample_fk CASCADE;
ALTER TABLE col.samplehisto ADD CONSTRAINT sample_fk FOREIGN KEY (sample_id)
REFERENCES col.sample (sample_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: collection_fk | type: CONSTRAINT --
-- ALTER TABLE col.document DROP CONSTRAINT IF EXISTS collection_fk CASCADE;
ALTER TABLE col.document ADD CONSTRAINT collection_fk FOREIGN KEY (collection_id)
REFERENCES col.collection (collection_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

INSERT INTO col.dbversion (dbversion_number, dbversion_date) VALUES (E'26.1', E'2026-02-01');

