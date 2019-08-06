set search_path = col;

DROP VIEW IF EXISTS col.last_movement CASCADE;
CREATE VIEW col.last_movement
AS 

SELECT s.uid,
    s.movement_id,
    s.movement_date,
    s.movement_type_id,
    s.container_id,
    c.uid AS container_uid,
    s.line_number,
    s.column_number,
    s.movement_reason_id
   FROM (col.movement s
     LEFT JOIN col.container c USING (container_id))
  WHERE (s.movement_id = ( SELECT st.movement_id
           FROM col.movement st
          WHERE (s.uid = st.uid)
          ORDER BY st.movement_date DESC
         LIMIT 1));

alter table protocol
add column authorization_number varchar,
add column authorization_date timestamp;
comment on column protocol.authorization_number is 'Number of the prelevement authorization';
comment on column protocol.authorization_date is 'Date of the prelevement authorization';
