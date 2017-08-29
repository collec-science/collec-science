/*
 * collec-science
 * Script de creation des tables contenant les donnees
 * version adaptee a la version 1.1 de l'application
 * a n'utiliser que pour une nouvelle installation
 * 
 * Le script de creation du schema des droits doit avoir ete execute auparavant
 * (gacl_create_1.1.sql)
 */
create schema if not exists col;
set search_path = col;

CREATE OR REPLACE VIEW aclgroup
(
  aclgroup_id,
  groupe,
  aclgroup_id_parent
)
AS 
 SELECT aclgroup.aclgroup_id,
    aclgroup.groupe,
    aclgroup.aclgroup_id_parent
   FROM gacl.aclgroup;

CREATE SEQUENCE "booking_booking_id_seq";

CREATE TABLE "booking" (
                "booking_id" INTEGER NOT NULL DEFAULT nextval('"booking_booking_id_seq"'),
                "uid" INTEGER NOT NULL,
                "booking_date" TIMESTAMP NOT NULL,
                "date_from" TIMESTAMP NOT NULL,
                "date_to" TIMESTAMP NOT NULL,
                "booking_comment" VARCHAR,
                "booking_login" VARCHAR NOT NULL,
                CONSTRAINT "booking_pk" PRIMARY KEY ("booking_id")
);
COMMENT ON TABLE "booking" IS 'Table des réservations d''objets';
COMMENT ON COLUMN "booking"."booking_date" IS 'Date de la réservation';
COMMENT ON COLUMN "booking"."date_from" IS 'Date-heure de début de la réservation';
COMMENT ON COLUMN "booking"."date_to" IS 'Date-heure de fin de la réservation';
COMMENT ON COLUMN "booking"."booking_comment" IS 'Commentaire';
COMMENT ON COLUMN "booking"."booking_login" IS 'Compte ayant réalisé la réservation';


ALTER SEQUENCE "booking_booking_id_seq" OWNED BY "booking"."booking_id";

CREATE SEQUENCE "container_container_id_seq";

CREATE TABLE "container" (
                "container_id" INTEGER NOT NULL DEFAULT nextval('"container_container_id_seq"'),
                "uid" INTEGER NOT NULL,
                "container_type_id" INTEGER NOT NULL,
                CONSTRAINT "container_pk" PRIMARY KEY ("container_id")
);
COMMENT ON TABLE "container" IS 'Liste des conteneurs d''échantillon';


ALTER SEQUENCE "container_container_id_seq" OWNED BY "container"."container_id";

CREATE SEQUENCE "container_family_container_family_id_seq";

CREATE TABLE "container_family" (
                "container_family_id" INTEGER NOT NULL DEFAULT nextval('"container_family_container_family_id_seq"'),
                "container_family_name" VARCHAR NOT NULL,
                "is_movable" BOOLEAN DEFAULT true NOT NULL,
                CONSTRAINT "container_family_pk" PRIMARY KEY ("container_family_id")
);
COMMENT ON TABLE "container_family" IS 'Famille générique des conteneurs';
COMMENT ON COLUMN "container_family"."is_movable" IS 'Indique si la famille de conteneurs est déplçable facilement ou non (éprouvette : oui, armoire : non)';


ALTER SEQUENCE "container_family_container_family_id_seq" OWNED BY "container_family"."container_family_id";

CREATE SEQUENCE "container_type_container_type_id_seq";

CREATE TABLE "container_type" (
                "container_type_id" INTEGER NOT NULL DEFAULT nextval('"container_type_container_type_id_seq"'),
                "container_type_name" VARCHAR NOT NULL,
                "container_family_id" INTEGER NOT NULL,
                "storage_condition_id" INTEGER,
                "label_id" INTEGER,
                "container_type_description" VARCHAR,
                "storage_product" VARCHAR,
                "clp_classification" VARCHAR,
                "lines" INTEGER DEFAULT 1 NOT NULL,
                "columns" INTEGER DEFAULT 1 NOT NULL,
                "first_line" VARCHAR DEFAULT T NOT NULL,
                CONSTRAINT "container_type_pk" PRIMARY KEY ("container_type_id")
);
COMMENT ON TABLE "container_type" IS 'Table des types de conteneurs';
COMMENT ON COLUMN "container_type"."container_type_description" IS 'Description longue';
COMMENT ON COLUMN "container_type"."storage_product" IS 'Produit utilisé pour le stockage (formol, alcool...)';
COMMENT ON COLUMN "container_type"."clp_classification" IS 'Classification du risque conformément à la directive européenne CLP';
COMMENT ON COLUMN "container_type"."lines" IS 'Nombre de lignes de stockage dans le container';
COMMENT ON COLUMN "container_type"."columns" IS 'Nombre de colonnes de stockage dans le container';
COMMENT ON COLUMN "container_type"."first_line" IS 'T : top, premiere ligne en haut
B: bottom, premiere ligne en bas';


ALTER SEQUENCE "container_type_container_type_id_seq" OWNED BY "container_type"."container_type_id";

CREATE SEQUENCE "dbversion_dbversion_id_seq";

CREATE TABLE "dbversion" (
                "dbversion_id" INTEGER NOT NULL DEFAULT nextval('"dbversion_dbversion_id_seq"'),
                "dbversion_number" VARCHAR NOT NULL,
                "dbversion_date" TIMESTAMP NOT NULL,
                CONSTRAINT "dbversion_pk" PRIMARY KEY ("dbversion_id")
);
COMMENT ON TABLE "dbversion" IS 'Table des versions de la base de donnees';
COMMENT ON COLUMN "dbversion"."dbversion_number" IS 'Numero de la version';
COMMENT ON COLUMN "dbversion"."dbversion_date" IS 'Date de la version';


ALTER SEQUENCE "dbversion_dbversion_id_seq" OWNED BY "dbversion"."dbversion_id";

CREATE SEQUENCE "document_document_id_seq";

CREATE TABLE "document" (
                "document_id" INTEGER NOT NULL DEFAULT nextval('"document_document_id_seq"'),
                "uid" INTEGER NOT NULL,
                "mime_type_id" INTEGER NOT NULL,
                "document_import_date" TIMESTAMP NOT NULL,
                "document_name" VARCHAR NOT NULL,
                "document_description" VARCHAR,
                "data" BYTEA,
                "thumbnail" BYTEA,
                "size" INTEGER,
                "document_creation_date" TIMESTAMP,
                CONSTRAINT "document_pk" PRIMARY KEY ("document_id")
);
COMMENT ON TABLE "document" IS 'Documents numériques rattachés à un poisson ou à un événement';
COMMENT ON COLUMN "document"."document_import_date" IS 'Date d''import dans la base de données';
COMMENT ON COLUMN "document"."document_name" IS 'Nom d''origine du document';
COMMENT ON COLUMN "document"."document_description" IS 'Description libre du document';
COMMENT ON COLUMN "document"."data" IS 'Contenu du document';
COMMENT ON COLUMN "document"."thumbnail" IS 'Vignette au format PNG (documents pdf, jpg ou png)';
COMMENT ON COLUMN "document"."size" IS 'Taille du fichier téléchargé';
COMMENT ON COLUMN "document"."document_creation_date" IS 'Date de création du document (date de prise de vue de la photo)';


ALTER SEQUENCE "document_document_id_seq" OWNED BY "document"."document_id";

CREATE SEQUENCE "event_event_id_seq";

CREATE TABLE "event" (
                "event_id" INTEGER NOT NULL DEFAULT nextval('"event_event_id_seq"'),
                "uid" INTEGER NOT NULL,
                "event_date" TIMESTAMP NOT NULL,
                "event_type_id" INTEGER NOT NULL,
                "still_available" VARCHAR,
                "event_comment" VARCHAR,
                CONSTRAINT "event_pk" PRIMARY KEY ("event_id")
);
COMMENT ON TABLE "event" IS 'Table des événements';
COMMENT ON COLUMN "event"."event_date" IS 'Date / heure de l''événement';
COMMENT ON COLUMN "event"."still_available" IS 'définit ce qu''il reste de disponible dans l''objet';


ALTER SEQUENCE "event_event_id_seq" OWNED BY "event"."event_id";

CREATE SEQUENCE "event_type_event_type_id_seq";

CREATE TABLE "event_type" (
                "event_type_id" INTEGER NOT NULL DEFAULT nextval('"event_type_event_type_id_seq"'),
                "event_type_name" VARCHAR NOT NULL,
                "is_sample" BOOLEAN DEFAULT false NOT NULL,
                "is_container" BOOLEAN DEFAULT false NOT NULL,
                CONSTRAINT "event_type_pk" PRIMARY KEY ("event_type_id")
);
COMMENT ON TABLE "event_type" IS 'Types d''événement';
COMMENT ON COLUMN "event_type"."is_sample" IS 'L''événement s''applique aux échantillons';
COMMENT ON COLUMN "event_type"."is_container" IS 'L''événement s''applique aux conteneurs';


ALTER SEQUENCE "event_type_event_type_id_seq" OWNED BY "event_type"."event_type_id";

CREATE SEQUENCE "identifier_type_identifier_type_id_seq";

CREATE TABLE "identifier_type" (
                "identifier_type_id" INTEGER NOT NULL DEFAULT nextval('"identifier_type_identifier_type_id_seq"'),
                "identifier_type_name" VARCHAR NOT NULL,
                "identifier_type_code" VARCHAR NOT NULL,
                CONSTRAINT "identifier_type_pk" PRIMARY KEY ("identifier_type_id")
);
COMMENT ON TABLE "identifier_type" IS 'Table des types d''identifiants';
COMMENT ON COLUMN "identifier_type"."identifier_type_name" IS 'Nom textuel de l''identifiant';
COMMENT ON COLUMN "identifier_type"."identifier_type_code" IS 'Code utilisé pour la génération des étiquettes';


ALTER SEQUENCE "identifier_type_identifier_type_id_seq" OWNED BY "identifier_type"."identifier_type_id";

CREATE SEQUENCE "label_label_id_seq";

CREATE TABLE "label" (
                "label_id" INTEGER NOT NULL DEFAULT nextval('"label_label_id_seq"'),
                "label_name" VARCHAR NOT NULL,
                "label_xsl" VARCHAR NOT NULL,
                "label_fields" VARCHAR DEFAULT 'uid,id,clp,db' NOT NULL,
                "metadata_id" INTEGER,
                CONSTRAINT "label_pk" PRIMARY KEY ("label_id")
);
COMMENT ON TABLE "label" IS 'Table des modèles d''étiquettes';
COMMENT ON COLUMN "label"."label_name" IS 'Nom du modèle';
COMMENT ON COLUMN "label"."label_xsl" IS 'Contenu du fichier XSL utilisé pour la transformation FOP (https://xmlgraphics.apache.org/fop/)';
COMMENT ON COLUMN "label"."label_fields" IS 'Liste des champs à intégrer dans le QRCODE, séparés par une virgule';


ALTER SEQUENCE "label_label_id_seq" OWNED BY "label"."label_id";

CREATE SEQUENCE "mime_type_mime_type_id_seq";

CREATE TABLE "mime_type" (
                "mime_type_id" INTEGER NOT NULL DEFAULT nextval('"mime_type_mime_type_id_seq"'),
                "extension" VARCHAR NOT NULL,
                "content_type" VARCHAR NOT NULL,
                CONSTRAINT "mime_type_pk" PRIMARY KEY ("mime_type_id")
);
COMMENT ON TABLE "mime_type" IS 'Types mime des fichiers importés';
COMMENT ON COLUMN "mime_type"."extension" IS 'Extension du fichier correspondant';
COMMENT ON COLUMN "mime_type"."content_type" IS 'type mime officiel';


ALTER SEQUENCE "mime_type_mime_type_id_seq" OWNED BY "mime_type"."mime_type_id";

CREATE SEQUENCE "movement_type_movement_type_id_seq";

CREATE TABLE "movement_type" (
                "movement_type_id" INTEGER NOT NULL DEFAULT nextval('"movement_type_movement_type_id_seq"'),
                "movement_type_name" VARCHAR NOT NULL,
                CONSTRAINT "movement_type_pk" PRIMARY KEY ("movement_type_id")
);
COMMENT ON TABLE "movement_type" IS 'Type de mouvement';


ALTER SEQUENCE "movement_type_movement_type_id_seq" OWNED BY "movement_type"."movement_type_id";

CREATE SEQUENCE "multiple_type_multiple_type_id_seq";

CREATE TABLE "multiple_type" (
                "multiple_type_id" INTEGER NOT NULL DEFAULT nextval('"multiple_type_multiple_type_id_seq"'),
                "multiple_type_name" VARCHAR NOT NULL,
                CONSTRAINT "multiple_type_pk" PRIMARY KEY ("multiple_type_id")
);
COMMENT ON TABLE "multiple_type" IS 'Table des types de contenus multiples';


ALTER SEQUENCE "multiple_type_multiple_type_id_seq" OWNED BY "multiple_type"."multiple_type_id";

CREATE SEQUENCE "object_uid_seq";

CREATE TABLE "object" (
                "uid" INTEGER NOT NULL DEFAULT nextval('"object_uid_seq"'),
                "identifier" VARCHAR,
                "object_status_id" INTEGER,
                "wgs84_x" DOUBLE PRECISION,
                "wgs84_y" DOUBLE PRECISION,
                CONSTRAINT "object_pk" PRIMARY KEY ("uid")
);
COMMENT ON TABLE "object" IS 'Table des objets
Contient les identifiants génériques';
COMMENT ON COLUMN "object"."identifier" IS 'Identifiant fourni le cas échéant par le projet';
COMMENT ON COLUMN "object"."wgs84_x" IS 'Longitude GPS, en valeur décimale';
COMMENT ON COLUMN "object"."wgs84_y" IS 'Latitude GPS, en décimal';


ALTER SEQUENCE "object_uid_seq" OWNED BY "object"."uid";

CREATE SEQUENCE "object_identifier_object_identifier_id_seq";

CREATE TABLE "object_identifier" (
                "object_identifier_id" INTEGER NOT NULL DEFAULT nextval('"object_identifier_object_identifier_id_seq"'),
                "uid" INTEGER NOT NULL,
                "identifier_type_id" INTEGER NOT NULL,
                "object_identifier_value" VARCHAR NOT NULL,
                CONSTRAINT "object_identifier_pk" PRIMARY KEY ("object_identifier_id")
);
COMMENT ON TABLE "object_identifier" IS 'Table des identifiants complémentaires normalisés';
COMMENT ON COLUMN "object_identifier"."object_identifier_value" IS 'Valeur de l''identifiant';


ALTER SEQUENCE "object_identifier_object_identifier_id_seq" OWNED BY "object_identifier"."object_identifier_id";

CREATE SEQUENCE "object_status_object_status_id_seq";

CREATE TABLE "object_status" (
                "object_status_id" INTEGER NOT NULL DEFAULT nextval('"object_status_object_status_id_seq"'),
                "object_status_name" VARCHAR NOT NULL,
                CONSTRAINT "object_status_pk" PRIMARY KEY ("object_status_id")
);
COMMENT ON TABLE "object_status" IS 'Table des statuts possibles des objets';


ALTER SEQUENCE "object_status_object_status_id_seq" OWNED BY "object_status"."object_status_id";

CREATE SEQUENCE "operation_operation_id_seq";

CREATE TABLE "operation" (
                "operation_id" INTEGER DEFAULT nextval('operation_operation_id_seq'::regclass) NOT NULL DEFAULT nextval('"operation_operation_id_seq"'),
                "protocol_id" INTEGER NOT NULL,
                "operation_name" VARCHAR NOT NULL,
                "operation_order" INTEGER,
                "operation_version" VARCHAR,
                "last_edit_date" TIMESTAMP,
                CONSTRAINT "operation_pk" PRIMARY KEY ("operation_id"),
                CONSTRAINT "operation_name_version_unique" UNIQUE ("operation_name","operation_version");
);
COMMENT ON COLUMN "operation"."operation_order" IS 'Ordre de réalisation de l''opération dans le protocole';
COMMENT ON COLUMN "operation"."operation_version" IS 'Version de l''opération';
COMMENT ON COLUMN "operation"."last_edit_date" IS 'Date de dernière édition de l opération';


ALTER SEQUENCE "operation_operation_id_seq" OWNED BY "operation"."operation_id";

CREATE SEQUENCE "project_project_id_seq";

CREATE TABLE "project" (
                "project_id" INTEGER NOT NULL DEFAULT nextval('"project_project_id_seq"'),
                "project_name" VARCHAR NOT NULL,
                CONSTRAINT "project_pk" PRIMARY KEY ("project_id")
);
COMMENT ON TABLE "project" IS 'Table des projets';


ALTER SEQUENCE "project_project_id_seq" OWNED BY "project"."project_id";

CREATE TABLE "project_group" (
                "project_id" INTEGER NOT NULL,
                "aclgroup_id" INTEGER NOT NULL,
                CONSTRAINT "project_group_pk" PRIMARY KEY ("project_id", "aclgroup_id")
);
COMMENT ON TABLE "project_group" IS 'Table des autorisations d''accès à un projet';


CREATE SEQUENCE "protocol_protocol_id_seq";

CREATE TABLE "protocol" (
                "protocol_id" INTEGER NOT NULL DEFAULT nextval('"protocol_protocol_id_seq"'),
                "protocol_name" VARCHAR NOT NULL,
                "protocol_file" BYTEA,
                "protocol_year" SMALLINT,
                "protocol_version" VARCHAR DEFAULT 'v1.0' NOT NULL,
                CONSTRAINT "protocol_pk" PRIMARY KEY ("protocol_id")
);
COMMENT ON COLUMN "protocol"."protocol_file" IS 'Description PDF du protocole';
COMMENT ON COLUMN "protocol"."protocol_year" IS 'Année du protocole';
COMMENT ON COLUMN "protocol"."protocol_version" IS 'Version du protocole';


ALTER SEQUENCE "protocol_protocol_id_seq" OWNED BY "protocol"."protocol_id";

CREATE SEQUENCE "sample_sample_id_seq";

CREATE TABLE "sample" (
                "sample_id" INTEGER NOT NULL DEFAULT nextval('"sample_sample_id_seq"'),
                "uid" INTEGER NOT NULL,
                "project_id" INTEGER NOT NULL,
                "sample_type_id" INTEGER NOT NULL,
                "sample_creation_date" TIMESTAMP NOT NULL,
                "sample_date" TIMESTAMP,
                "parent_sample_id" INTEGER,
                "multiple_value" DOUBLE PRECISION,
                "sampling_place_id" INTEGER,
                "dbuid_origin" VARCHAR,
                "metadata" json,
                CONSTRAINT "sample_pk" PRIMARY KEY ("sample_id")
);
COMMENT ON TABLE "sample" IS 'Table des échantillons';
COMMENT ON COLUMN "sample"."sample_creation_date" IS 'Date de création de l''enregistrement dans la base de données';
COMMENT ON COLUMN "sample"."sample_date" IS 'Date de création de l''échantillon physique';
COMMENT ON COLUMN "sample"."multiple_value" IS 'Nombre initial de sous-échantillons';
COMMENT ON COLUMN "sample"."dbuid_origin" IS 'référence utilisée dans la base de données d''origine, sous la forme db:uid
Utilisé pour lire les étiquettes créées dans d''autres instances';


ALTER SEQUENCE "sample_sample_id_seq" OWNED BY "sample"."sample_id";

CREATE SEQUENCE "sample_type_sample_type_id_seq";

CREATE TABLE "sample_type" (
                "sample_type_id" INTEGER NOT NULL DEFAULT nextval('"sample_type_sample_type_id_seq"'),
                "sample_type_name" VARCHAR NOT NULL,
                "container_type_id" INTEGER,
                "multiple_type_id" INTEGER,
                "multiple_unit" VARCHAR,
                "operation_id" INTEGER,
                CONSTRAINT "sample_type_pk" PRIMARY KEY ("sample_type_id")
);
COMMENT ON TABLE "sample_type" IS 'Types d''échantillons';
COMMENT ON COLUMN "sample_type"."multiple_unit" IS 'Unité caractérisant le sous-échantillon';


ALTER SEQUENCE "sample_type_sample_type_id_seq" OWNED BY "sample_type"."sample_type_id";

CREATE SEQUENCE "sampling_place_sampling_place_id_seq";

CREATE TABLE "sampling_place" (
                "sampling_place_id" INTEGER NOT NULL DEFAULT nextval('"sampling_place_sampling_place_id_seq"'),
                "sampling_place_name" VARCHAR NOT NULL,
                CONSTRAINT "sampling_place_pk" PRIMARY KEY ("sampling_place_id")
);
COMMENT ON TABLE "sampling_place" IS 'Table des lieux génériques d''échantillonnage';


ALTER SEQUENCE "sampling_place_sampling_place_id_seq" OWNED BY "sampling_place"."sampling_place_id";

CREATE SEQUENCE "storage_storage_id_seq";

CREATE TABLE "storage" (
                "storage_id" INTEGER NOT NULL DEFAULT nextval('"storage_storage_id_seq"'),
                "uid" INTEGER NOT NULL,
                "container_id" INTEGER,
                "movement_type_id" INTEGER NOT NULL,
                "storage_reason_id" INTEGER,
                "storage_date" TIMESTAMP NOT NULL,
                "storage_location" VARCHAR,
                "login" VARCHAR NOT NULL,
                "storage_comment" VARCHAR,
                "line_number" INTEGER DEFAULT 1 NOT NULL,
                "column_number" INTEGER DEFAULT 1 NOT NULL,
                CONSTRAINT "storage_pk" PRIMARY KEY ("storage_id")
);
COMMENT ON TABLE "storage" IS 'Gestion du stockage des échantillons';
COMMENT ON COLUMN "storage"."storage_date" IS 'Date/heure du mouvement';
COMMENT ON COLUMN "storage"."storage_location" IS 'Emplacement de l''échantillon dans le conteneur';
COMMENT ON COLUMN "storage"."login" IS 'Nom de l''utilisateur ayant réalisé l''opération';
COMMENT ON COLUMN "storage"."storage_comment" IS 'Commentaire';
COMMENT ON COLUMN "storage"."line_number" IS 'N° de la ligne de stockage dans le container';
COMMENT ON COLUMN "storage"."column_number" IS 'Numéro de la colonne de stockage dans le container';


ALTER SEQUENCE "storage_storage_id_seq" OWNED BY "storage"."storage_id";

CREATE SEQUENCE "storage_condition_storage_condition_id_seq";

CREATE TABLE "storage_condition" (
                "storage_condition_id" INTEGER NOT NULL DEFAULT nextval('"storage_condition_storage_condition_id_seq"'),
                "storage_condition_name" VARCHAR NOT NULL,
                CONSTRAINT "storage_condition_pk" PRIMARY KEY ("storage_condition_id")
);
COMMENT ON TABLE "storage_condition" IS 'Condition de stockage';


ALTER SEQUENCE "storage_condition_storage_condition_id_seq" OWNED BY "storage_condition"."storage_condition_id";

CREATE SEQUENCE "storage_reason_storage_reason_id_seq";

CREATE TABLE "storage_reason" (
                "storage_reason_id" INTEGER NOT NULL DEFAULT nextval('"storage_reason_storage_reason_id_seq"'),
                "storage_reason_name" VARCHAR NOT NULL,
                CONSTRAINT "storage_reason_pk" PRIMARY KEY ("storage_reason_id")
);
COMMENT ON TABLE "storage_reason" IS 'Table des raisons de stockage/déstockage';


ALTER SEQUENCE "storage_reason_storage_reason_id_seq" OWNED BY "storage_reason"."storage_reason_id";

CREATE SEQUENCE "subsample_subsample_id_seq";

CREATE TABLE "subsample" (
                "subsample_id" INTEGER NOT NULL DEFAULT nextval('"subsample_subsample_id_seq"'),
                "sample_id" INTEGER NOT NULL,
                "subsample_date" TIMESTAMP NOT NULL,
                "movement_type_id" INTEGER NOT NULL,
                "subsample_quantity" DOUBLE PRECISION,
                "subsample_comment" VARCHAR,
                "subsample_login" VARCHAR NOT NULL,
                CONSTRAINT "subsample_pk" PRIMARY KEY ("subsample_id")
);
COMMENT ON TABLE "subsample" IS 'Table des prélèvements et restitutions de sous-échantillons';
COMMENT ON COLUMN "subsample"."subsample_date" IS 'Date/heure de l''opération';
COMMENT ON COLUMN "subsample"."subsample_quantity" IS 'Quantité prélevée ou restituée';
COMMENT ON COLUMN "subsample"."subsample_login" IS 'Login de l''utilisateur ayant réalisé l''opération';


ALTER SEQUENCE "subsample_subsample_id_seq" OWNED BY "subsample"."subsample_id";


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

ALTER TABLE "project_group" ADD CONSTRAINT "aclgroup_projet_group_fk"
FOREIGN KEY ("aclgroup_id")
REFERENCES "aclgroup" ("aclgroup_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "storage" ADD CONSTRAINT "container_storage_fk"
FOREIGN KEY ("container_id")
REFERENCES "container" ("container_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "container_type" ADD CONSTRAINT "container_family_container_type_fk"
FOREIGN KEY ("container_family_id")
REFERENCES "container_family" ("container_family_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "container" ADD CONSTRAINT "container_type_container_fk"
FOREIGN KEY ("container_type_id")
REFERENCES "container_type" ("container_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "sample_type" ADD CONSTRAINT "container_type_sample_type_fk"
FOREIGN KEY ("container_type_id")
REFERENCES "container_type" ("container_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "event" ADD CONSTRAINT "event_type_event_fk"
FOREIGN KEY ("event_type_id")
REFERENCES "event_type" ("event_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "object_identifier" ADD CONSTRAINT "identifier_type_object_identifier_fk"
FOREIGN KEY ("identifier_type_id")
REFERENCES "identifier_type" ("identifier_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "container_type" ADD CONSTRAINT "label_container_type_fk"
FOREIGN KEY ("label_id")
REFERENCES "label" ("label_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "document" ADD CONSTRAINT "mime_type_document_fk"
FOREIGN KEY ("mime_type_id")
REFERENCES "mime_type" ("mime_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "storage" ADD CONSTRAINT "movement_type_storage_fk"
FOREIGN KEY ("movement_type_id")
REFERENCES "movement_type" ("movement_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "subsample" ADD CONSTRAINT "movement_type_subsample_fk"
FOREIGN KEY ("movement_type_id")
REFERENCES "movement_type" ("movement_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "sample_type" ADD CONSTRAINT "multiple_type_sample_type_fk"
FOREIGN KEY ("multiple_type_id")
REFERENCES "multiple_type" ("multiple_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "booking" ADD CONSTRAINT "object_booking_fk"
FOREIGN KEY ("uid")
REFERENCES "object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "container" ADD CONSTRAINT "object_container_fk"
FOREIGN KEY ("uid")
REFERENCES "object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "document" ADD CONSTRAINT "object_document_fk"
FOREIGN KEY ("uid")
REFERENCES "object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "event" ADD CONSTRAINT "object_event_fk"
FOREIGN KEY ("uid")
REFERENCES "object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "object_identifier" ADD CONSTRAINT "object_object_identifier_fk"
FOREIGN KEY ("uid")
REFERENCES "object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "sample" ADD CONSTRAINT "object_sample_fk"
FOREIGN KEY ("uid")
REFERENCES "object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "storage" ADD CONSTRAINT "object_storage_fk"
FOREIGN KEY ("uid")
REFERENCES "object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "object" ADD CONSTRAINT "object_status_object_fk"
FOREIGN KEY ("object_status_id")
REFERENCES "object_status" ("object_status_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "label" ADD CONSTRAINT "operation_label_fk"
FOREIGN KEY ("operation_id")
REFERENCES "operation" ("operation_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "sample_type" ADD CONSTRAINT "operation_sample_type_fk"
FOREIGN KEY ("operation_id")
REFERENCES "operation" ("operation_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "project_group" ADD CONSTRAINT "project_projet_group_fk"
FOREIGN KEY ("project_id")
REFERENCES "project" ("project_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "sample" ADD CONSTRAINT "project_sample_fk"
FOREIGN KEY ("project_id")
REFERENCES "project" ("project_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "operation" ADD CONSTRAINT "protocol_operation_fk"
FOREIGN KEY ("protocol_id")
REFERENCES "protocol" ("protocol_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "sample" ADD CONSTRAINT "sample_sample_fk"
FOREIGN KEY ("parent_sample_id")
REFERENCES "sample" ("sample_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "subsample" ADD CONSTRAINT "sample_subsample_fk"
FOREIGN KEY ("sample_id")
REFERENCES "sample" ("sample_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "sample" ADD CONSTRAINT "sample_type_sample_fk"
FOREIGN KEY ("sample_type_id")
REFERENCES "sample_type" ("sample_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "sample" ADD CONSTRAINT "sampling_place_sample_fk"
FOREIGN KEY ("sampling_place_id")
REFERENCES "sampling_place" ("sampling_place_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "container_type" ADD CONSTRAINT "storage_condition_container_type_fk"
FOREIGN KEY ("storage_condition_id")
REFERENCES "storage_condition" ("storage_condition_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "storage" ADD CONSTRAINT "storage_reason_storage_fk"
FOREIGN KEY ("storage_reason_id")
REFERENCES "storage_reason" ("storage_reason_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

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

/*
 * Creation des vues
 */
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
    s.line_number,
    s.column_number
   FROM storage s
     LEFT JOIN container c USING (container_id)
  WHERE s.storage_id = (( SELECT st.storage_id
           FROM storage st
          WHERE s.uid = st.uid
          ORDER BY st.storage_date DESC
         LIMIT 1));
         
CREATE OR REPLACE VIEW last_photo
(
  document_id,
  uid
)
AS 
 SELECT d.document_id,
    d.uid
   FROM document d
  WHERE d.document_id = (( SELECT d1.document_id
           FROM document d1
          WHERE (d1.mime_type_id = ANY (ARRAY[4, 5, 6])) AND d.uid = d1.uid
          ORDER BY d1.document_creation_date DESC, d1.document_import_date DESC, d1.document_id DESC
         LIMIT 1));

CREATE OR REPLACE VIEW v_object_identifier
(
  uid,
  identifiers
)
AS 
 SELECT object_identifier.uid,
    array_to_string(array_agg((identifier_type.identifier_type_code::text || ':'::text) || object_identifier.object_identifier_value::text ORDER BY identifier_type.identifier_type_code, object_identifier.object_identifier_value), ','::text) AS identifiers
   FROM object_identifier
     JOIN identifier_type USING (identifier_type_id)
  GROUP BY object_identifier.uid
  ORDER BY object_identifier.uid;

  
 /*
 * Initialisation par defaut des donnees
 */
 
 insert into movement_type (movement_type_id, movement_type_name) 
values 
(1, 'Entrée/Entry'),
(2, 'Sortie/Exit');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  1,  'application/pdf',  'pdf'),
 (  2,  'application/zip',  'zip'),
 (  3,  'audio/mpeg',  'mp3'),
 (  4,  'image/jpeg',  'jpg'),
 (  5,  'image/jpeg',  'jpeg'),
 (  6,  'image/png',  'png'),
 (  7,  'image/tiff',  'tiff'),
 (  9,  'application/vnd.oasis.opendocument.text',  'odt'),
 (  10,  'application/vnd.oasis.opendocument.spreadsheet',  'ods'),
 (  11,  'application/vnd.ms-excel',  'xls'),
 (  12,  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',  'xlsx'),
 (  13,  'application/msword',  'doc'),
 (  14,  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',  'docx'),
 (  8,  'text/csv',  'csv');
 INSERT INTO label
(
  label_name,
  label_xsl,
  label_fields
)
VALUES
(
  'Exemple - ne pas utiliser',
  '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="objects">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="label"
              page-height="5cm" page-width="10cm" margin-left="0.5cm" margin-top="0.5cm" margin-bottom="0cm" margin-right="0.5cm">  
              <fo:region-body/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      
      <fo:page-sequence master-reference="label">
         <fo:flow flow-name="xsl-region-body">        
          <fo:block>
          <xsl:apply-templates select="object" />
          </fo:block>

        </fo:flow>
      </fo:page-sequence>
    </fo:root>
   </xsl:template>
  <xsl:template match="object">

  <fo:table table-layout="fixed" border-collapse="collapse"  border-style="none" width="8cm" keep-together.within-page="always">
  <fo:table-column column-width="4cm"/>
  <fo:table-column column-width="4cm" />
 <fo:table-body  border-style="none" >
 	<fo:table-row>
  		<fo:table-cell> 
  		<fo:block>
  		<fo:external-graphic>
      <xsl:attribute name="src">
             <xsl:value-of select="concat(uid,''.png'')" />
       </xsl:attribute>
       <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
       <xsl:attribute name="height">4cm</xsl:attribute>
        <xsl:attribute name="content-width">4cm</xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
      
       </fo:external-graphic>
 		</fo:block>
   		</fo:table-cell>
  		<fo:table-cell>
<fo:block><fo:inline font-weight="bold">IRSTEA</fo:inline></fo:block>
  			<fo:block>uid:<fo:inline font-weight="bold"><xsl:value-of select="db"/>:<xsl:value-of select="uid"/></fo:inline></fo:block>
  			<fo:block>id:<fo:inline font-weight="bold"><xsl:value-of select="id"/></fo:inline></fo:block>
  			<fo:block>prj:<fo:inline font-weight="bold"><xsl:value-of select="prj"/></fo:inline></fo:block>
  			<fo:block>clp:<fo:inline font-weight="bold"><xsl:value-of select="clp"/></fo:inline></fo:block>
  		</fo:table-cell>
  	  	</fo:table-row>
  </fo:table-body>
  </fo:table>
   <fo:block page-break-after="always"/>

  </xsl:template>
</xsl:stylesheet>',
  'uid,id,clp,db,prj'
);
select setval('label_label_id_seq',(select max(label_id) from label)); 

/*
 * Tables de parametres generales
 */
 insert into container_family (container_family_id, container_family_name, is_movable)
 values 
 (1, 'Immobilier', false),
 (2, 'Mobilier', false);
 
select setval('container_family_container_family_id_seq', (select max(container_family_id) from container_family));
insert into container_type (container_type_name, container_family_id)
values 
('Site', 1),
('Bâtiment', 1),
('Pièce', 1),
('Armoire', 2),
('Congélateur', 2);

INSERT INTO event_type
(
  event_type_name,
  is_sample,
  is_container
)
VALUES
(  'Autre',  TRUE,  TRUE),
(  'Conteneur cassé',  FALSE,  TRUE),
(  'Échantillon détruit',  TRUE,  FALSE),
(  'Prélèvement pour analyse',  TRUE,  FALSE),
(  'Échantillon totalement analysé, détruit', TRUE,  FALSE);

INSERT INTO multiple_type (  multiple_type_name)
VALUES
(  'Unité'),
(  'Pourcentage'),
(  'Quantité ou volume'),
(  'Autre');

INSERT INTO object_status(  object_status_name)
VALUES
(  'État normal'),
(  'Objet pré-réservé pour usage ultérieur'),
(  'Objet détruit'),
(  'Echantillon vidé de tout contenu');

/*
 * Fin d'execution du script
 * Mise a jour de dbversion
 */
insert into dbversion ("dbversion_number", "dbversion_date")
values 
('1.1','2017-09-01');
