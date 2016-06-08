create or replace view col.last_movement as (
select s.uid, storage_id, storage_date, movement_type_id, container_id, c.uid as "container_uid"
from col.storage s
left outer join col.container c using (container_id)
order by storage_date desc limit 1);
