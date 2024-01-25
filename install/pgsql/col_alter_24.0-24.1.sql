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