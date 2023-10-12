insert into col.dbparam (dbparam_name, dbparam_value) values ('containerNameUnique', '1');
alter table col.collection add column sample_name_unique boolean NOT NULL DEFAULT false;
COMMENT ON COLUMN col.collection.sample_name_unique IS E'True if the sample identifier must be unique in the collection';

DROP VIEW IF EXISTS col.slots_used CASCADE;
DROP VIEW IF EXISTS col.last_movement CASCADE;
CREATE VIEW col.last_movement
AS 
SELECT s.uid,
    s.movement_id,
    s.movement_date,
    s.movement_type_id,
    s.container_id,
    c.uid AS container_uid,
	o.identifier as container_identifier,
    s.line_number,
    s.column_number,
    s.movement_reason_id
   FROM (col.movement s
     LEFT JOIN col.container c USING (container_id)
	LEFT JOIN col.object o on (o.uid = c.uid))
  WHERE (s.movement_id = ( SELECT st.movement_id
           FROM col.movement st
          WHERE (s.uid = st.uid)
          ORDER BY st.movement_date DESC
         LIMIT 1));
-- ddl-end --
ALTER VIEW col.last_movement OWNER TO collec;
-- ddl-end --

CREATE VIEW col.slots_used
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
-- ddl-end --