insert into col.dbparam (dbparam_name, dbparam_value) values ('containerNameUnique', '0');
insert into col.dbparam (dbparam_name, dbparam_value) values ('consultSeesAll', '0');
alter table col.dbparam add column dbparam_description varchar;
alter table col.dbparam add column dbparam_description_en varchar;
COMMENT ON COLUMN col.dbparam.dbparam_description IS E'Description of the parameter';
-- ddl-end --
COMMENT ON COLUMN col.dbparam.dbparam_description_en IS E'Description of the parameter, in English';
-- ddl-end --

update col.dbparam set dbparam_description = 'Code de l''instance. Ce code figurera dans les QRcodes', dbparam_description_en = 'Instance code. This code will appear in the Qrcodes' where dbparam_name = 'APPLI_code';
update col.dbparam set dbparam_description = 'Nom de l''instance, affiché dans l''interface', dbparam_description_en = 'Instance name, displayed in the interface' where dbparam_name = 'APPLI_title';
update col.dbparam set dbparam_description = 'Longitude de positionnement par défaut des cartes', dbparam_description_en = 'Default positioning longitude for maps' where dbparam_name = 'mapDefaultX';
update col.dbparam set dbparam_description = 'Latitude de positionnement par défaut des cartes', dbparam_description_en = 'Default positioning latitude for maps' where dbparam_name = 'mapDefaultY';
update col.dbparam set dbparam_description = 'Niveau de zoom par défaut dans les cartes', dbparam_description_en = 'Default zoom level in maps' where dbparam_name = 'mapDefaultZoom';
update col.dbparam set dbparam_description = 'Nom affiché dans les applications de génération de codes uniques pour l''identification à double facteur', dbparam_description_en = 'Name displayed in applications generating unique codes for two-factor identification' where dbparam_name = 'otp_issuer';
update col.dbparam set dbparam_description = 'Si positionné à 1, les utilisateurs avec le droit de consultation peuvent visualiser toutes les métadonnées de tous les échantillons', dbparam_description_en = 'If set to 1, users with consultation rights can view all the metadata for all the samples' where dbparam_name = 'consultSeesAll';
update col.dbparam set dbparam_description = 'Si positionné à 1, le logiciel interdira la création de deux contenants avec le même nom', dbparam_description_en = 'If set to 1, the software will prohibit the creation of two containers with the same name' where dbparam_name = 'containerNameUnique';

alter table col.object alter column change_date set default now();

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

INSERT INTO col.dbparam (dbparam_name, dbparam_value, dbparam_description, dbparam_description_en) VALUES (E'notificationDelay', E'7', E'Nombre de jours entre deux envois de notifications. 0 : pas de notifications', E'Number of days between two notifications. 0: no notification');
INSERT INTO col.dbparam (dbparam_name, dbparam_value, dbparam_description, dbparam_description_en) VALUES (E'notificationLastDate', DEFAULT, E'Date de l''envoi des dernières notifications', E'Date of last notifications sent');

alter table col.collection 
add column notification_enabled boolean DEFAULT false,
add column	notification_mails varchar,
add column	expiration_delay smallint DEFAULT 0,
add column	event_due_delay smallint DEFAULT 0;
COMMENT ON COLUMN col.collection.notification_enabled IS E'True if notifications are sent for samples of the collection';
-- ddl-end --
COMMENT ON COLUMN col.collection.notification_mails IS E'List of mails used to notify events on the collection (separator: semicolon)';
-- ddl-end --
COMMENT ON COLUMN col.collection.expiration_delay IS E'Number of days before expiration of samples to notify this expiration. 0: no notification';
-- ddl-end --
COMMENT ON COLUMN col.collection.event_due_delay IS E'Number of days before the due date of an event to notify this due date. 0: no notification';
-- ddl-end --
CREATE VIEW col.v_derivated_number
AS 
select s.uid, count(*) -1 as nb_derivated_sample
from col.sample s
join col.sample d on (d.parent_sample_id = s.sample_id)
group by s.uid;
-- ddl-end --
COMMENT ON VIEW col.v_derivated_number IS E'Get the number of derivated samples from an uid';
-- ddl-end --
ALTER VIEW col.v_derivated_number OWNER TO collec;
-- ddl-end --

/**
 * add the column last_movement_id in object
 */

alter table col.object add column last_movement_id integer;
comment on column col.object.last_movement_id is 'Last movement recorded to the object';
ALTER TABLE col.object ADD CONSTRAINT object_last_movement_id_fk FOREIGN KEY (last_movement_id)
REFERENCES col.movement (movement_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;

update col.object o SET last_movement_id = lm.movement_id 
from col.last_movement lm 
WHERE o.uid = lm.uid;

create or replace view col.last_movement as 
SELECT m.uid,
    m.movement_id,
    m.movement_date,
    m.movement_type_id,
    m.container_id,
    c.uid AS container_uid,
	o.identifier as container_identifier,
    m.line_number,
    m.column_number,
    m.movement_reason_id
   FROM col.movement m
   JOIN col.object o on (m.movement_id = o.last_movement_id)
   LEFT JOIN col.container c USING (container_id);

CREATE UNIQUE INDEX referent_referent_name_firstname_idx ON col.referent USING btree (referent_name,referent_firstname);
drop index col.referent_referent_name_idx;
alter table col.container add column collection_id int;
ALTER TABLE col.container ADD CONSTRAINT collection_fk FOREIGN KEY (collection_id)
REFERENCES col.collection (collection_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
CREATE INDEX container_collection_id_idx ON col.container
USING btree(collection_id);


insert into col.dbversion (dbversion_number, dbversion_date) values ('24.0','2024-01-02');
