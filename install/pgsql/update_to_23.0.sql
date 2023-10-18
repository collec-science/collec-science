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