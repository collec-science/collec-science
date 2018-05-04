/*
 * Script de mise a jour pour basculer la version 1.2.3 vers la version 2.0
 * Le script fonctionne avec les schemas gacl et col. Si vous utilisez d'autres noms de schemas,
 * corrigez les lignes 10 et 24
 */

/*
 * Schema des droits
 */
set search_path = gacl;

ALTER TABLE "logingestion" ADD COLUMN "is_clientws" BOOLEAN DEFAULT false NOT NULL;

ALTER TABLE "logingestion" ADD COLUMN "tokenws" VARCHAR;

/*
 * Renommage du droit projet en collection
 */
update aclaco set aco = 'collection' where aco = 'projet';
update aclgroup set groupe = 'collection' where groupe = 'projet';
/*
 * Schema des donnees
 */
set search_path = col;

create extension if not exists pg_trgm schema public;

/*
 * Renommage de storage en movement
 */
drop view last_movement;
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
   FROM movement s
     LEFT JOIN container c USING (container_id)
  WHERE s.movement_id = (( SELECT st.movement_id AS movement_id
           FROM movement st
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

/*
 * Suppression du champ is_movable pour les familles de containers
 */
 alter table container_family drop column is_movable;
 
 /*
  * Mise a niveau des lieux de collecte
  */
 alter table sampling_place add column collection_id integer,
 add column sampling_place_code varchar,
 add column sampling_place_x float8,
 add column sampling_place_y float8;
 ALTER TABLE sampling_place
  ADD CONSTRAINT collection_sampling_place_fk FOREIGN KEY (collection_id)
  REFERENCES collection (collection_id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;
 comment on column sampling_place.sampling_place_code is 'Code métier de la station';
 comment on column sampling_place.sampling_place_x is 'Longitude de la station, en WGS84';
 comment on column sampling_place.sampling_place_y is 'Latitude de la station, en WGS84';
 
/*
 * Ajouts d'index pour des questions de performance
 */
 create index movement_uid_idx on movement(uid);
 create index movement_container_id_idx on movement(container_id);
 create index movement_movement_date_desc_idx on movement(movement_date desc);
 create index movement_login_idx on movement(login);
 create index container_uid_idx on container(uid);
 create index object_identifier_uid_idx on object_identifier(uid);
 create index sample_uid_idx on sample(uid);
 create index sample_dbuid_origin_idx on sample(dbuid_origin);

 /*
 * Fin d'execution du script
 * Mise a jour de dbversion
 */
delete from dbversion;
insert into dbversion ("dbversion_number", "dbversion_date")
values 
('2.0','2018-05-04');

 
 
