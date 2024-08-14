/*
 * Script de basculement de la version 1.0.8 de collec-science vers la version 1.1
 * ATTENTION : des modifications doivent être apportees dans le schema de gestion des droits
 * (premiere partie du script)
 * et dans le schema contenant les donnees 
 * (seconde partie du script)
 * 
 * Avant de lancer le script, vous devrez vous assurer que les commandes 
 * set search_path = xxx;
 * 
 * sont correctes (noms des schemas utilises par votre implementation)
 * et ceci pour les deux parties du script, en lignes 24 et 57
 * 
 * Une table est creee : gacl.passwordlost. Assurez-vous que le compte de connexion
 * utilise par l'application dispose des droits de modification sur cette table
 * 
 */

/*
 * Premiere partie : mise a jour du schema de gestion des droits
 * Modifiez le cas echeant la commande search_path pour indiquer le nom du schema utilise
 * dans votre implementation
 */
set search_path = gacl;
/*
 * Ajout de la table pour gerer les renouvellements de mots de passe
 */
 
CREATE SEQUENCE "passwordlost_passwordlost_id_seq";

CREATE TABLE "passwordlost" (
                "passwordlost_id" INTEGER NOT NULL DEFAULT nextval('"passwordlost_passwordlost_id_seq"'),
                "id" INTEGER NOT NULL,
                "token" VARCHAR NOT NULL,
                "expiration" TIMESTAMP NOT NULL,
                "usedate" TIMESTAMP,
                CONSTRAINT "passwordlost_pk" PRIMARY KEY ("passwordlost_id")
);
COMMENT ON TABLE "passwordlost" IS 'Table de suivi des pertes de mots de passe';
COMMENT ON COLUMN "passwordlost"."token" IS 'Jeton utilise pour le renouvellement';
COMMENT ON COLUMN "passwordlost"."expiration" IS 'Date d''expiration du jeton';


ALTER SEQUENCE "passwordlost_passwordlost_id_seq" OWNED BY "passwordlost"."passwordlost_id";

ALTER TABLE "passwordlost" ADD CONSTRAINT "logingestion_passwordlost_fk"
FOREIGN KEY ("id")
REFERENCES "logingestion" ("id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/*
 * Seconde partie du script : mise a jour du schema comprenant les donnees
 */

set search_path=col;

ALTER TABLE "operation" 
ADD COLUMN operation_version varchar,
ADD COLUMN last_edit_date timestamp,
ADD CONSTRAINT operation_name_version_unique UNIQUE (operation_name,operation_version);
COMMENT ON COLUMN "operation"."operation_version" IS 'Version de l''opération';
COMMENT ON COLUMN "operation"."last_edit_date" IS 'Date de dernière éditione l''opératon';

DROP TABLE IF EXISTS "metadata_attribute" CASCADE;
DROP TABLE  IF EXISTS "metadata_schema" CASCADE;
DROP TABLE  IF EXISTS "metadata_set" CASCADE;

ALTER TABLE "sample_type" DROP COLUMN metadata_set_id;
ALTER TABLE "sample_type" DROP COLUMN metadata_set_id_second;

alter table sample add column metadata json;
comment on column sample.metadata is 'Metadonnees associees de l''echantillon';

ALTER TABLE "container_type" ADD COLUMN "columns" INTEGER DEFAULT 1 NOT NULL;
ALTER TABLE "container_type" ADD COLUMN "lines" INTEGER DEFAULT 1 NOT NULL;

comment on column container_type.columns is 'Nombre de colonnes de stockage dans le container';
comment on column container_type.lines is 'Nombre de lignes de stockage dans le container';

ALTER TABLE "storage" ADD COLUMN "column_number" INTEGER DEFAULT 1 NOT NULL;
ALTER TABLE "storage" ADD COLUMN "line_number" INTEGER DEFAULT 1 NOT NULL;

comment on column storage.column_number is 'No de la colonne de stockage dans le container';
comment on column storage.line_number is 'No de la ligne de stockage dans le container';

alter table container_type add column first_line varchar default 'T' not null;
comment on column container_type.first_line is 'T : top, premiere ligne en haut
B: bottom, premiere ligne en bas';


CREATE SEQUENCE "printer_printer_id_seq";

CREATE TABLE "printer" (
                "printer_id" INTEGER NOT NULL DEFAULT nextval('"printer_printer_id_seq"'),
                "printer_name" VARCHAR NOT NULL,
                "printer_queue" VARCHAR NOT NULL,
                "printer_server" VARCHAR,
                "printer_user" VARCHAR,
                "printer_comment" VARCHAR,
                CONSTRAINT "printer_pk" PRIMARY KEY ("printer_id")
);
COMMENT ON TABLE "printer" IS 'Table des imprimantes gerees directement par le serveur';
COMMENT ON COLUMN "printer"."printer_name" IS 'Nom general de l''imprimante, affiche dans les masques de saisie';
COMMENT ON COLUMN "printer"."printer_queue" IS 'Nom de l''imprimante telle qu''elle est connue par le systeme';
COMMENT ON COLUMN "printer"."printer_server" IS 'Adresse du serveur, si imprimante non locale';
COMMENT ON COLUMN "printer"."printer_user" IS 'Utilisateur autorise a imprimer ';
COMMENT ON COLUMN "printer"."printer_comment" IS 'Commentaire';


ALTER SEQUENCE "printer_printer_id_seq" OWNED BY "printer"."printer_id";

/*
 * Reconfiguration des metadonnees
 */

ALTER TABLE "label" ADD COLUMN "metadata_id" INTEGER;

CREATE SEQUENCE "metadata_metadata_id_seq";

CREATE TABLE "metadata" (
                "metadata_id" INTEGER NOT NULL DEFAULT nextval('"metadata_metadata_id_seq"'),
                "metadata_name" VARCHAR NOT NULL,
                "metadata_schema" json,
                CONSTRAINT "metadata_pk" PRIMARY KEY ("metadata_id")
);
COMMENT ON TABLE "metadata" IS 'Table des metadata utilisables dans les types d''echantillons';
COMMENT ON COLUMN "metadata"."metadata_name" IS 'Nom du jeu de metadonnees';
COMMENT ON COLUMN "metadata"."metadata_schema" IS 'Schéma en JSON du formulaire des métadonnées';

ALTER SEQUENCE "metadata_metadata_id_seq" OWNED BY "metadata"."metadata_id";

ALTER TABLE "sample" DROP COLUMN "sample_metadata_id";

ALTER TABLE "sample_type" ADD COLUMN "metadata_id" INTEGER;


ALTER TABLE "label" ADD CONSTRAINT "metadata_label_fk"
FOREIGN KEY ("metadata_id")
REFERENCES "metadata" ("metadata_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "sample_type" ADD CONSTRAINT "metadata_sample_type_fk"
FOREIGN KEY ("metadata_id")
REFERENCES "metadata" ("metadata_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "protocol" ADD COLUMN "project_id" int;

ALTER TABLE "protocol" ADD CONSTRAINT "project_protocol_fk"
FOREIGN KEY ("project_id")
REFERENCES "project" ("project_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/*
 * Creation des vues
 */



DROP VIEW IF EXISTS last_movement CASCADE;

CREATE OR REPLACE VIEW last_movement
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
   FROM storage s
     LEFT JOIN container c USING (container_id)
  WHERE s.storage_id = (( SELECT st.storage_id
           FROM storage st
          WHERE s.uid = st.uid
          ORDER BY st.storage_date DESC
         LIMIT 1));

COMMENT ON VIEW last_movement IS 'Dernier mouvement d''un objet';

/*
 * Fin d'execution du script
 * Mise a jour de dbversion
 */
insert into dbversion ("dbversion_number", "dbversion_date")
values 
('1.1','2017-09-01');
