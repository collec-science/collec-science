set search_path = col;
/*
 * Renommage de storage en movement
 */
alter table storage_reason rename to movement_reason;
comment on  table movement_reason is 'List of the reasons of the movement';
alter table movement_reason rename storage_reason_id to movement_reason_id;
alter table movement_reason rename storage_reason_name to movement_reason_name;

alter table storage rename to movement;
comment on table movement is 'Records of objects movements';
alter table movement rename storage_id to movement_id;
alter table movement rename storage_date to movement_date;
alter table movement rename storage_comment to movement_comment;
alter table movement rename storage_reason_id to movement_reason_id;

drop view last_movement;
CREATE VIEW last_movement
AS 
 SELECT s.uid,
    s.movement_id AS movement_id,
    s.movement_date AS movement_date,
    s.movement_type_id,
    s.container_id,
    c.uid AS container_uid,
    s.line_number,
    s.column_number
   FROM col.movement s
     LEFT JOIN col.container c USING (container_id)
  WHERE s.movement_id = (( SELECT st.movement_id AS movement_id
           FROM col.movement st
          WHERE s.uid = st.uid
          ORDER BY st.movement_date DESC
         LIMIT 1));

