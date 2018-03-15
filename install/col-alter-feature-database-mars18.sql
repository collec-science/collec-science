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
         LIMIT 1))
;

/*
 * Renommage de project en collection
 */
alter table project rename to collection;
comment on table collection is 'List of all collections into the database';
alter table collection rename project_id to collection_id;
alter table collection rename project_name to collection_name;
alter table protocol rename project_id to collection_id;
alter table sample rename project_id to collection_id;

alter table project_group rename to collection_group;
alter table collection_group rename project_id to collection_id;

/*
 * Renommage du droit projet en collection
 */
set search_path = gacl;
update aclaco set aco = 'collection' where aco = 'projet';
update aclgroup set groupe = 'collection' where groupe = 'projet';

/*
 * Ajout de la date d'expiration de l'echantillon
 */
alter table sample add column expiration_date timestamp;
alter table sample rename column sample_date to sampling_date;
create index sample_sample_creation_date_idx on sample(sample_creation_date);
create index sample_sampling_date_idx on sample(sampling_date);
create index sample_expiration_date_idx on sample(expiration_date);

/*
 * Ajout du champ supportant la fonction javascript utilisee pour generer le code de l'identifiant
 */
alter table sample_type add column identifier_generator_js varchar;
comment on column sample_type.identifier_generator_js is 'Champ comprenant le code de la fonction javascript permettant de générer automatiquement un identifiant à partir des informations saisies';

 