/*
 * collec-science
 * Script de creation des tables contenant les donnees / table creation script
 * version adaptee a la version 2.1 de l'application / for release 2.1
 * a n'utiliser que pour une nouvelle installation, et prevu pour etre appele depuis le script init_by_psql.sql
 * use only for a new deployement, may be call from init_by_psql.sql
 * Le script de creation du schema des droits doit avoir ete execute auparavant : gacl_create_2.1.sql
 * rights schema script must be execute before: gacl_create_2.1.sql
 * si les noms des schemas par defaut (gacl, col) sont modifies, corrigez les lignes :
 * if you want to change schemas names, change theses lines
 * 16 et 17 pour le schema contenant les donnees / data schema
 * 32 (FROM gacl.aclgroup),
 *  en remplacant gacl par le nom du schema utilise pour la gestion des droits
 * and replace gacl by the real schema name
 */
 create extension btree_gin schema pg_catalog;
 create extension pg_trgm schema pg_catalog;
create schema if not exists col;
set search_path = col;

/*
 * Creation de la vue vers aclgroup
 */
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
                CONSTRAINT "container_family_pk" PRIMARY KEY ("container_family_id")
);
COMMENT ON TABLE "container_family" IS 'Famille générique des conteneurs';

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
                "first_line" VARCHAR DEFAULT 'T' NOT NULL,
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
                "referent_id" INTEGER,
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
                "operation_id" INTEGER DEFAULT nextval('operation_operation_id_seq'::regclass) NOT NULL,
                "protocol_id" INTEGER NOT NULL,
                "operation_name" VARCHAR NOT NULL,
                "operation_order" INTEGER,
                "operation_version" VARCHAR,
                "last_edit_date" TIMESTAMP,
                CONSTRAINT "operation_pk" PRIMARY KEY ("operation_id"),
                CONSTRAINT "operation_name_version_unique" UNIQUE ("operation_name","operation_version")
);
COMMENT ON COLUMN "operation"."operation_order" IS 'Ordre de réalisation de l''opération dans le protocole';
COMMENT ON COLUMN "operation"."operation_version" IS 'Version de l''opération';
COMMENT ON COLUMN "operation"."last_edit_date" IS 'Date de dernière édition de l opération';


ALTER SEQUENCE "operation_operation_id_seq" OWNED BY "operation"."operation_id";

CREATE SEQUENCE "collection_collection_id_seq";

CREATE TABLE "collection" (
                "collection_id" INTEGER NOT NULL DEFAULT nextval('"collection_collection_id_seq"'),
                "collection_name" VARCHAR NOT NULL,
                "referent_id" INTEGER,
                CONSTRAINT "collection_pk" PRIMARY KEY ("collection_id")
);
COMMENT ON TABLE "collection" IS 'Table des collections';


ALTER SEQUENCE "collection_collection_id_seq" OWNED BY "collection"."collection_id";

CREATE TABLE "collection_group" (
                "collection_id" INTEGER NOT NULL,
                "aclgroup_id" INTEGER NOT NULL,
                CONSTRAINT "collection_group_pk" PRIMARY KEY ("collection_id", "aclgroup_id")
);
COMMENT ON TABLE "collection_group" IS 'Table des autorisations d''accès à un projet';


CREATE SEQUENCE "protocol_protocol_id_seq";

CREATE TABLE "protocol" (
                "protocol_id" INTEGER NOT NULL DEFAULT nextval('"protocol_protocol_id_seq"'),
                "protocol_name" VARCHAR NOT NULL,
                "protocol_file" BYTEA,
                "protocol_year" SMALLINT,
                "protocol_version" VARCHAR DEFAULT 'v1.0' NOT NULL,
                "collection_id" INTEGER,
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
                "collection_id" INTEGER NOT NULL,
                "sample_type_id" INTEGER NOT NULL,
                "sample_creation_date" TIMESTAMP NOT NULL,
                "sampling_date" TIMESTAMP,
                "expiration_date" timestamp,
                "parent_sample_id" INTEGER,
                "multiple_value" DOUBLE PRECISION,
                "sampling_place_id" INTEGER,
                "dbuid_origin" VARCHAR,
                "metadata" json,
                CONSTRAINT "sample_pk" PRIMARY KEY ("sample_id")
);
COMMENT ON TABLE "sample" IS 'Table des échantillons';
COMMENT ON COLUMN "sample"."sample_creation_date" IS 'Date de création de l''enregistrement dans la base de données';
COMMENT ON COLUMN "sample"."sampling_date" IS 'Date de création de l''échantillon physique';
COMMENT ON COLUMN "sample"."multiple_value" IS 'Nombre initial de sous-échantillons';
COMMENT ON COLUMN "sample"."dbuid_origin" IS 'référence utilisée dans la base de données d''origine, sous la forme db:uid
Utilisé pour lire les étiquettes créées dans d''autres instances';


ALTER SEQUENCE "sample_sample_id_seq" OWNED BY "sample"."sample_id";
create index sample_sample_creation_date_idx on sample(sample_creation_date);
create index sample_sampling_date_idx on sample(sampling_date);
create index sample_expiration_date_idx on sample(expiration_date);

CREATE SEQUENCE "sample_type_sample_type_id_seq";

CREATE TABLE "sample_type" (
                "sample_type_id" INTEGER NOT NULL DEFAULT nextval('"sample_type_sample_type_id_seq"'),
                "sample_type_name" VARCHAR NOT NULL,
                "container_type_id" INTEGER,
                "multiple_type_id" INTEGER,
                "multiple_unit" VARCHAR,
                "operation_id" INTEGER,
		"metadata_id" INTEGER,
		"identifier_generator_js" varchar,
                CONSTRAINT "sample_type_pk" PRIMARY KEY ("sample_type_id")
);
COMMENT ON TABLE "sample_type" IS 'Types d''échantillons';
COMMENT ON COLUMN "sample_type"."multiple_unit" IS 'Unité caractérisant le sous-échantillon';
comment on column sample_type.identifier_generator_js is 'Champ comprenant le code de la fonction javascript permettant de générer automatiquement un identifiant à partir des informations saisies';


ALTER SEQUENCE "sample_type_sample_type_id_seq" OWNED BY "sample_type"."sample_type_id";

CREATE SEQUENCE "sampling_place_sampling_place_id_seq";

CREATE TABLE "sampling_place" (
                "sampling_place_id" INTEGER NOT NULL DEFAULT nextval('"sampling_place_sampling_place_id_seq"'),
                collection_id integer,
                "sampling_place_name" VARCHAR NOT NULL,
                sampling_place_code varchar,
 				sampling_place_x float8,
 				sampling_place_y float8,
                CONSTRAINT "sampling_place_pk" PRIMARY KEY ("sampling_place_id")
);
COMMENT ON TABLE "sampling_place" IS 'Table des lieux génériques d''échantillonnage';
comment on column sampling_place.sampling_place_code is 'Code métier de la station';
 comment on column sampling_place.sampling_place_x is 'Longitude de la station, en WGS84';
 comment on column sampling_place.sampling_place_y is 'Latitude de la station, en WGS84';


ALTER SEQUENCE "sampling_place_sampling_place_id_seq" OWNED BY "sampling_place"."sampling_place_id";

CREATE SEQUENCE "movement_movement_id_seq";

CREATE TABLE "movement" (
                "movement_id" INTEGER NOT NULL DEFAULT nextval('"movement_movement_id_seq"'),
                "uid" INTEGER NOT NULL,
                "container_id" INTEGER,
                "movement_type_id" INTEGER NOT NULL,
                "movement_reason_id" INTEGER,
                "movement_date" TIMESTAMP NOT NULL,
                "storage_location" VARCHAR,
                "login" VARCHAR NOT NULL,
                "movement_comment" VARCHAR,
                "line_number" INTEGER DEFAULT 1 NOT NULL,
                "column_number" INTEGER DEFAULT 1 NOT NULL,
                CONSTRAINT "movement_pk" PRIMARY KEY ("movement_id")
);
COMMENT ON TABLE "movement" IS 'Gestion du stockage des échantillons';
COMMENT ON COLUMN "movement"."movement_date" IS 'Date/heure du mouvement';
COMMENT ON COLUMN "movement"."storage_location" IS 'Emplacement de l''échantillon dans le conteneur';
COMMENT ON COLUMN "movement"."login" IS 'Nom de l''utilisateur ayant réalisé l''opération';
COMMENT ON COLUMN "movement"."movement_comment" IS 'Commentaire';
COMMENT ON COLUMN "movement"."line_number" IS 'N° de la ligne de stockage dans le container';
COMMENT ON COLUMN "movement"."column_number" IS 'Numéro de la colonne de stockage dans le container';


ALTER SEQUENCE "movement_movement_id_seq" OWNED BY "movement"."movement_id";

CREATE SEQUENCE "storage_condition_storage_condition_id_seq";

CREATE TABLE "storage_condition" (
                "storage_condition_id" INTEGER NOT NULL DEFAULT nextval('"storage_condition_storage_condition_id_seq"'),
                "storage_condition_name" VARCHAR NOT NULL,
                CONSTRAINT "storage_condition_pk" PRIMARY KEY ("storage_condition_id")
);
COMMENT ON TABLE "storage_condition" IS 'Condition de stockage';


ALTER SEQUENCE "storage_condition_storage_condition_id_seq" OWNED BY "storage_condition"."storage_condition_id";

CREATE SEQUENCE "movement_reason_movement_reason_id_seq";

CREATE TABLE "movement_reason" (
                "movement_reason_id" INTEGER NOT NULL DEFAULT nextval('"movement_reason_movement_reason_id_seq"'),
                "movement_reason_name" VARCHAR NOT NULL,
                CONSTRAINT "movement_reason_pk" PRIMARY KEY ("movement_reason_id")
);
COMMENT ON TABLE "movement_reason" IS 'Table des raisons de stockage/déstockage';


ALTER SEQUENCE "movement_reason_movement_reason_id_seq" OWNED BY "movement_reason"."movement_reason_id";

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

CREATE SEQUENCE "referent_referent_id_seq";

CREATE TABLE "referent" (
                "referent_id" INTEGER NOT NULL DEFAULT nextval('"referent_referent_id_seq"'),
                referent_name varchar not null,
                referent_email varchar,
                address_name varchar,
                address_line2 varchar,
                address_line3 varchar,
                address_city varchar,
                address_country varchar,
                referent_phone varchar,
                CONSTRAINT referent_pk PRIMARY KEY (referent_id)
);
comment on table referent is 'Table of sample referents';
comment on column referent.referent_name is 'Name, firstname-lastname or department name';
comment on column referent.referent_email is 'Email for contact';
comment on column referent.address_name is 'Name for postal address';
comment on column referent.address_line2 is 'second line in postal address';
comment on column referent.address_line3 is 'third line in postal address';
comment on column referent.address_city is 'ZIPCode and City in postal address';
comment on column referent.address_country is 'Country in postal address';
comment on column referent.referent_phone is 'Contact phone';
alter sequence referent_referent_id_seq OWNED BY referent.referent_id;

ALTER TABLE "collection_group" ADD CONSTRAINT "aclgroup_projet_group_fk"
FOREIGN KEY ("aclgroup_id")
REFERENCES gacl.aclgroup ("aclgroup_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "movement" ADD CONSTRAINT "container_movement_fk"
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

ALTER TABLE "movement" ADD CONSTRAINT "movement_type_movement_fk"
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

ALTER TABLE "movement" ADD CONSTRAINT "object_movement_fk"
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


ALTER TABLE "sample_type" ADD CONSTRAINT "operation_sample_type_fk"
FOREIGN KEY ("operation_id")
REFERENCES "operation" ("operation_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "collection_group" ADD CONSTRAINT "collection_projet_group_fk"
FOREIGN KEY ("collection_id")
REFERENCES "collection" ("collection_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "sample" ADD CONSTRAINT "collection_sample_fk"
FOREIGN KEY ("collection_id")
REFERENCES "collection" ("collection_id")
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

ALTER TABLE "movement" ADD CONSTRAINT "movement_reason_movement_fk"
FOREIGN KEY ("movement_reason_id")
REFERENCES "movement_reason" ("movement_reason_id")
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

ALTER TABLE "protocol" ADD CONSTRAINT "collection_protocol_fk"
FOREIGN KEY ("collection_id")
REFERENCES "collection" ("collection_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sampling_place
  ADD CONSTRAINT collection_sampling_place_fk FOREIGN KEY (collection_id)
  REFERENCES collection (collection_id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

alter table object 
ADD CONSTRAINT "referent_object_fk"
FOREIGN KEY ("referent_id")
REFERENCES "referent" ("referent_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

alter table collection 
ADD CONSTRAINT "referent_collection_fk"
FOREIGN KEY ("referent_id")
REFERENCES "referent" ("referent_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

  /*
 * Ajouts d'index 
 */
 create index movement_uid_idx on movement(uid);
 create index movement_container_id_idx on movement(container_id);
 create index movement_movement_date_desc_idx on movement(movement_date desc);
 create index movement_login_idx on movement(login);
 create index container_uid_idx on container(uid);
 create index object_identifier_uid_idx on object_identifier(uid);
 create index sample_uid_idx on sample(uid);
create index object_identifier_idx on object using gin (identifier gin_trgm_ops);
create index object_identifier_value_idx on object_identifier using gin (object_identifier_value gin_trgm_ops);
create index sample_dbuid_origin_idx on sample using gin (dbuid_origin gin_trgm_ops);
CREATE UNIQUE INDEX referent_referent_name_idx ON referent
	USING btree
	(
	  referent_name COLLATE pg_catalog."default" ASC NULLS LAST
	)
	TABLESPACE pg_default;

  
/*
 * Creation des vues
 */
CREATE OR REPLACE VIEW last_movement
(
  uid,
  movement_id,
  movement_date,
  movement_type_id,
  container_id,
  container_uid,
  line_number,
  column_number
)
AS 
 SELECT s.uid,
    s.movement_id,
    s.movement_date,
    s.movement_type_id,
    s.container_id,
    c.uid AS container_uid,
    s.line_number,
    s.column_number
   FROM movement s
     LEFT JOIN container c USING (container_id)
  WHERE s.movement_id = (( SELECT st.movement_id
           FROM movement st
          WHERE s.uid = st.uid
          ORDER BY st.movement_date DESC
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
 insert into container_family (container_family_id, container_family_name)
 values 
 (1, 'Immobilier'),
 (2, 'Mobilier');
 
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
 * Ajouts version 1.2
 */
CREATE TABLE "dbparam" (
                "dbparam_id" INTEGER NOT NULL,
                "dbparam_name" VARCHAR NOT NULL,
                "dbparam_value" VARCHAR,
                CONSTRAINT "dbparam_pk" PRIMARY KEY ("dbparam_id")
);
COMMENT ON TABLE "dbparam" IS 'Table des parametres associes de maniere intrinseque a l''instance';
COMMENT ON COLUMN "dbparam"."dbparam_name" IS 'Nom du parametre';
COMMENT ON COLUMN "dbparam"."dbparam_value" IS 'Valeur du paramètre';

insert into dbparam(dbparam_id, dbparam_name, dbparam_value) values
 (1, 'APPLI_code', 'cs_code'),
 (2, 'APPLI_title', 'Collec-Science - instance for '),
 (3, 'mapDefaultX', '-0.70'),
 (4, 'mapDefaultY', '44.77'),
 (5, 'mapDefaultZoom', '7')

 ;

ALTER TABLE "identifier_type" ADD COLUMN "used_for_search" BOOLEAN DEFAULT 'f' NOT NULL;
comment on column identifier_type.used_for_search is 'Indique si l''identifiant doit être utilise pour les recherches a partir des codes-barres';

ALTER TABLE "label" ADD COLUMN "identifier_only" BOOLEAN DEFAULT 'f' NOT NULL;
comment on column label.identifier_only is 'true : le qrcode ne contient qu''un identifiant metier';




/*
 * Fin d'execution du script
 * Mise a jour de dbversion
 */
insert into dbversion ("dbversion_number", "dbversion_date")
values 
('2.2','2018-09-06');
