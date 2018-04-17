set search_path = col;
/*
 * Mise a jour de la base de donnees
 * A executer dans tous les schemas contenant des donnees
 * Mise a jour a realiser pour toutes les versions anterieures a la version 1.0.4
 */

/*
 * Modification de la vue last_movement
 */
create or replace view last_movement as (
SELECT s.uid,
    s.storage_id,
    s.storage_date,
    s.movement_type_id,
    s.container_id,
    c.uid AS container_uid
   FROM storage s
    left outer JOIN container c USING (container_id)
   where s.storage_id = (
   select st.storage_id from storage st
   where s.uid = st.uid 
    order by st.storage_date desc limit 1
    )
      );
      
comment on view last_movement is 'Dernier mouvement d''un objet';
