set search_path=col;

ALTER TABLE "container_type" ADD COLUMN "columns" INTEGER DEFAULT 1 NOT NULL;
ALTER TABLE "container_type" ADD COLUMN "lines" INTEGER DEFAULT 1 NOT NULL;

comment on column container_type.columns is 'Nombre de colonnes de stockage dans le container';
comment on column container_type.lines is 'Nombre de lignes de stockage dans le container';

ALTER TABLE "storage" ADD COLUMN "column_number" INTEGER DEFAULT 1 NOT NULL;
ALTER TABLE "storage" ADD COLUMN "line_number" INTEGER DEFAULT 1 NOT NULL;

comment on column storage.column_number is 'N¢X de la colonne de stockage dans le container';
comment on column storage.line_number is 'N¢X de la ligne de stockage dans le container';

alter table container_type add column first_line varchar default 'T' not null;
comment on column container_type.first_line is 'T : top, premiere ligne en haut
B: bottom, premiere ligne en bas';

DROP VIEW IF EXISTS col.last_movement CASCADE;

CREATE OR REPLACE VIEW col.last_movement
(
  uid,
  storage_id,
  storage_date,
  movement_type_id,
  container_id,
  container_uid,
  line_number,
  column_number
)
AS 
 SELECT s.uid,
    s.storage_id,
    s.storage_date,
    s.movement_type_id,
    s.container_id,
    c.uid AS container_uid,
    line_number,
    column_number
   FROM col.storage s
     LEFT JOIN col.container c USING (container_id)
  WHERE s.storage_id = (( SELECT st.storage_id
           FROM col.storage st
          WHERE s.uid = st.uid
          ORDER BY st.storage_date DESC
         LIMIT 1));

COMMENT ON VIEW col.last_movement IS 'Dernier mouvement d''un objet';


