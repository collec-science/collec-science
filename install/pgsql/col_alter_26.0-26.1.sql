-- ** Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- ** pgModeler version: 1.2.3
-- ** Diff date: 2026-02-18 12:14:31
-- ** Source model: collec
-- ** Database: test
-- ** PostgreSQL version: 15.0

-- ** [ Diff summary ]
-- ** Dropped objects: 6
-- ** Created objects: 17
-- ** Changed objects: 13

SET check_function_bodies = false;
-- ddl-end --

SET search_path=public,pg_catalog,col,gacl;
-- ddl-end --


-- ** [ Dropped objects ]

ALTER TABLE col.collection_eventtype DROP CONSTRAINT IF EXISTS event_type CASCADE;
-- ddl-end --
ALTER TABLE col.collection_eventtype DROP CONSTRAINT IF EXISTS collection CASCADE;
-- ddl-end --
ALTER TABLE col.collection_eventtype DROP CONSTRAINT IF EXISTS collection_eventtype_1 CASCADE;
-- ddl-end --
ALTER TABLE col.collection_sampletype DROP CONSTRAINT IF EXISTS sample_type CASCADE;
-- ddl-end --
ALTER TABLE col.collection_sampletype DROP CONSTRAINT IF EXISTS collection CASCADE;
-- ddl-end --
ALTER TABLE col.collection_sampletype DROP CONSTRAINT IF EXISTS collection_sampletype_1 CASCADE;
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

-- object: col.last_photo | type: VIEW --
-- DROP VIEW IF EXISTS col.last_photo CASCADE;
CREATE OR REPLACE VIEW col.last_photo
AS 
SELECT d.document_id,
    d.uid
   FROM col.document d
  WHERE (d.document_id = (
		SELECT d1.document_id
  		FROM col.document d1
		WHERE (d1.mime_type_id = ANY (ARRAY[4, 5, 6]) AND (d.uid = d1.uid))
        ORDER BY d1.document_creation_date DESC, 
				d1.document_import_date DESC, 
				d1.document_id DESC
         LIMIT 1));
-- ddl-end --
ALTER VIEW col.last_photo OWNER TO collec;
-- ddl-end --

-- object: col.v_object_identifier | type: VIEW --
-- DROP VIEW IF EXISTS col.v_object_identifier CASCADE;
CREATE OR REPLACE VIEW col.v_object_identifier
AS 
SELECT object_identifier.uid,
    array_to_string(
		array_agg(
        CASE
            WHEN identifier_type.identifier_type_code IS NOT NULL THEN identifier_type.identifier_type_code
            ELSE identifier_type.identifier_type_name
        END::text 
		|| ':'::text || object_identifier.object_identifier_value::text ORDER BY identifier_type.identifier_type_code, object_identifier.object_identifier_value
		), ','::text
	) AS identifiers
   FROM col.object_identifier
     JOIN col.identifier_type USING (identifier_type_id)
  GROUP BY object_identifier.uid
  ORDER BY object_identifier.uid;
-- ddl-end --
ALTER VIEW col.v_object_identifier OWNER TO collec;
-- ddl-end --

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

-- object: col.last_movement | type: VIEW --
-- DROP VIEW IF EXISTS col.last_movement CASCADE;
CREATE OR REPLACE VIEW col.last_movement
AS 
SELECT m.uid,
    m.movement_id,
    m.movement_date,
    m.movement_type_id,
    m.container_id,
    c.uid AS container_uid,
    o2.identifier AS container_identifier,
    m.line_number,
    m.column_number,
    m.movement_reason_id
   FROM col.movement m
     JOIN col.object o ON m.movement_id = o.last_movement_id
     LEFT JOIN col.container c USING (container_id)
     LEFT JOIN col.object o2 ON c.uid = o2.uid;
-- ddl-end --
ALTER VIEW col.last_movement OWNER TO collec;
-- ddl-end --

-- object: col.slots_used | type: VIEW --
-- DROP VIEW IF EXISTS col.slots_used CASCADE;
CREATE OR REPLACE VIEW col.slots_used
AS 
SELECT container_id,
    count(*) AS nb_slots_used
   FROM col.last_movement
  WHERE movement_type_id = 1
  GROUP BY container_id;
-- ddl-end --
ALTER VIEW col.slots_used OWNER TO collec;
-- ddl-end --

ALTER TABLE col.object ALTER COLUMN location_accuracy TYPE float8;
-- ddl-end --
ALTER TABLE col.object ALTER COLUMN geom TYPE geography(POINT, 4326);
-- ddl-end --
-- object: col.v_subsample_quantity | type: VIEW --
-- DROP VIEW IF EXISTS col.v_subsample_quantity CASCADE;
CREATE OR REPLACE VIEW col.v_subsample_quantity
AS 
SELECT sample_id,
    uid,
    multiple_value,
    COALESCE(( SELECT sum(smore.subsample_quantity) AS sum
           FROM col.subsample smore
          WHERE smore.movement_type_id = 1 AND smore.sample_id = s.sample_id), 0::double precision) AS subsample_more,
    COALESCE(( SELECT sum(sless.subsample_quantity) AS sum
           FROM col.subsample sless
          WHERE sless.movement_type_id = 2 AND sless.sample_id = s.sample_id), 0::double precision) AS subsample_less
   FROM col.sample s;
-- ddl-end --
ALTER VIEW col.v_subsample_quantity OWNER TO collec;
-- ddl-end --

-- object: col.getsampletypesfromcollection | type: FUNCTION --
-- DROP FUNCTION IF EXISTS col.getsampletypesfromcollection(integer) CASCADE;
CREATE OR REPLACE FUNCTION col.getsampletypesfromcollection (IN collection_id integer)
	RETURNS varchar
	LANGUAGE sql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	PARALLEL UNSAFE
	COST 1
	AS 
$function$
select array_to_string(array_agg(sample_type_name order by sample_type_name), ', ') as sampletypes
from col.collection_sampletype
join col.sample_type using (sample_type_id)
where collection_id = $1
$function$;
-- ddl-end --
ALTER FUNCTION col.getsampletypesfromcollection(integer) OWNER TO collec;
-- ddl-end --

-- object: col.getgroupsfromcollection | type: FUNCTION --
-- DROP FUNCTION IF EXISTS col.getgroupsfromcollection(integer) CASCADE;
CREATE OR REPLACE FUNCTION col.getgroupsfromcollection (collection_id integer)
	RETURNS varchar
	LANGUAGE sql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	PARALLEL UNSAFE
	COST 1
	AS 
$function$
select array_to_string(array_agg(groupe),', ') as groupes
from col.collection_group
join gacl.aclgroup using (aclgroup_id)
where collection_id = $1
$function$;
-- ddl-end --
ALTER FUNCTION col.getgroupsfromcollection(integer) OWNER TO collec;
-- ddl-end --

-- object: col.geteventtypesfromcollection | type: FUNCTION --
-- DROP FUNCTION IF EXISTS col.geteventtypesfromcollection(integer) CASCADE;
CREATE OR REPLACE FUNCTION col.geteventtypesfromcollection (IN collection_id integer)
	RETURNS varchar
	LANGUAGE sql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	PARALLEL UNSAFE
	COST 1
	AS 
$function$
select array_to_string(array_agg(event_type_name order by event_type_name), ', ') as eventtypes
from col.collection_eventtype
join col.event_type using (event_type_id)
where collection_id = $1
$function$;
-- ddl-end --
ALTER FUNCTION col.geteventtypesfromcollection(integer) OWNER TO collec;
-- ddl-end --

-- object: col.v_derivated_number | type: VIEW --
-- DROP VIEW IF EXISTS col.v_derivated_number CASCADE;
CREATE OR REPLACE VIEW col.v_derivated_number
AS 
SELECT s.uid,
	count(*) AS nb_derivated_sample
	FROM col.sample s
	JOIN col.sample d ON d.parent_sample_id = s.sample_id
	GROUP BY s.uid;
-- ddl-end --
ALTER VIEW col.v_derivated_number OWNER TO collec;
-- ddl-end --

-- object: col.v_sample_parents | type: VIEW --
-- DROP VIEW IF EXISTS col.v_sample_parents CASCADE;
CREATE OR REPLACE VIEW col.v_sample_parents
AS 
select ss.createdsample_id as sample_id,
array_to_string (array_agg((p.uid::text || ' '|| po.identifier::text) order by p.uid), ', ') as sample_parents
from subsample ss
join sample p on (ss.sample_id = p.sample_id)
join object po on (p.uid = po.uid)
group by ss.createdsample_id;
-- ddl-end --
ALTER VIEW col.v_sample_parents OWNER TO collec;
-- ddl-end --



-- ** [ Created constraints ]

-- object: collection_eventtype_pk | type: CONSTRAINT --
-- ALTER TABLE col.collection_eventtype DROP CONSTRAINT IF EXISTS collection_eventtype_pk CASCADE;
ALTER TABLE col.collection_eventtype ADD CONSTRAINT collection_eventtype_pk PRIMARY KEY (collection_id,event_type_id);
-- ddl-end --

-- object: collection_sampletype_pk | type: CONSTRAINT --
-- ALTER TABLE col.collection_sampletype DROP CONSTRAINT IF EXISTS collection_sampletype_pk CASCADE;
ALTER TABLE col.collection_sampletype ADD CONSTRAINT collection_sampletype_pk PRIMARY KEY (collection_id,sample_type_id);
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

-- object: collection_eventtype_event_type_fk | type: CONSTRAINT --
-- ALTER TABLE col.collection_eventtype DROP CONSTRAINT IF EXISTS collection_eventtype_event_type_fk CASCADE;
ALTER TABLE col.collection_eventtype ADD CONSTRAINT collection_eventtype_event_type_fk FOREIGN KEY (event_type_id)
REFERENCES col.event_type (event_type_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: collection_eventtype_collection_fk | type: CONSTRAINT --
-- ALTER TABLE col.collection_eventtype DROP CONSTRAINT IF EXISTS collection_eventtype_collection_fk CASCADE;
ALTER TABLE col.collection_eventtype ADD CONSTRAINT collection_eventtype_collection_fk FOREIGN KEY (collection_id)
REFERENCES col.collection (collection_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

-- object: collection_sampletype_collection_fk | type: CONSTRAINT --
-- ALTER TABLE col.collection_sampletype DROP CONSTRAINT IF EXISTS collection_sampletype_collection_fk CASCADE;
ALTER TABLE col.collection_sampletype ADD CONSTRAINT collection_sampletype_collection_fk FOREIGN KEY (collection_id)
REFERENCES col.collection (collection_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: collection_sampletype_sample_type_fk | type: CONSTRAINT --
-- ALTER TABLE col.collection_sampletype DROP CONSTRAINT IF EXISTS collection_sampletype_sample_type_fk CASCADE;
ALTER TABLE col.collection_sampletype ADD CONSTRAINT collection_sampletype_sample_type_fk FOREIGN KEY (sample_type_id)
REFERENCES col.sample_type (sample_type_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE CASCADE;
-- ddl-end --

INSERT INTO col.dbversion (dbversion_number, dbversion_date) VALUES (E'26.1', E'2026-02-01');