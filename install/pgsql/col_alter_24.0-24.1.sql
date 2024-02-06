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
     left join col.object o2 on (c.uid = o2.uid);
-- ddl-end --
ALTER VIEW col.last_movement OWNER TO collec;
-- ddl-end --

CREATE or replace view col.slots_used
AS 
SELECT
   container_id, count(*) as nb_slots_used
FROM
   col.last_movement
WHERE
   movement_type_id = 1
   group by container_id;
-- ddl-end --
ALTER VIEW col.slots_used OWNER TO collec;

-- [ Created objects ] --
-- object: locale | type: COLUMN --
-- ALTER TABLE gacl.logingestion DROP COLUMN IF EXISTS locale CASCADE;
ALTER TABLE gacl.logingestion ADD COLUMN locale varchar;
-- ddl-end --

COMMENT ON COLUMN gacl.logingestion.locale IS E'Preferred locale for the user';
-- ddl-end --


-- object: referent_referent_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.referent_referent_name_idx CASCADE;
CREATE UNIQUE INDEX referent_referent_name_idx ON col.referent
USING btree
(
	referent_name
)
WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: object_change_date_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.object_change_date_idx CASCADE;
CREATE INDEX object_change_date_idx ON col.object
USING btree
(
	change_date
);
-- ddl-end --

-- object: col.campaign_group | type: TABLE --
-- DROP TABLE IF EXISTS col.campaign_group CASCADE;
CREATE TABLE col.campaign_group (
	campaign_id integer NOT NULL,
	aclgroup_id integer NOT NULL,
	CONSTRAINT campaign_group_pk PRIMARY KEY (campaign_id,aclgroup_id)
);
-- ddl-end --
COMMENT ON TABLE col.campaign_group IS E'Rights to modify the samples sampled during a campaign';
-- ddl-end --
ALTER TABLE col.campaign_group OWNER TO collec;
-- ddl-end --

-- object: event_id | type: COLUMN --
-- ALTER TABLE col.document DROP COLUMN IF EXISTS event_id CASCADE;
ALTER TABLE col.document ADD COLUMN event_id integer;
-- ddl-end --
ALTER TABLE col.document ALTER COLUMN uuid SET DEFAULT gen_random_uuid();
-- ddl-end --
COMMENT ON COLUMN gacl.logingestion.nbattempts IS E'Number of connection attempts';
-- ddl-end --
COMMENT ON COLUMN gacl.logingestion.lastattempt IS E'last attempt of connection';
-- ddl-end --
-- object: campaign_fk | type: CONSTRAINT --
-- ALTER TABLE col.campaign_group DROP CONSTRAINT IF EXISTS campaign_fk CASCADE;
ALTER TABLE col.campaign_group ADD CONSTRAINT campaign_fk FOREIGN KEY (campaign_id)
REFERENCES col.campaign (campaign_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: aclgroup_fk | type: CONSTRAINT --
-- ALTER TABLE col.campaign_group DROP CONSTRAINT IF EXISTS aclgroup_fk CASCADE;
ALTER TABLE col.campaign_group ADD CONSTRAINT aclgroup_fk FOREIGN KEY (aclgroup_id)
REFERENCES gacl.aclgroup (aclgroup_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: event_fk | type: CONSTRAINT --
-- ALTER TABLE col.document DROP CONSTRAINT IF EXISTS event_fk CASCADE;
ALTER TABLE col.document ADD CONSTRAINT event_fk FOREIGN KEY (event_id)
REFERENCES col.event (event_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

insert into col.dbversion (dbversion_number, dbversion_date) values ('24.1','2024-01-31');