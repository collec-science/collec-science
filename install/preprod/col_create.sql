create schema col;

set search_path = col, public;

create or replace view "aclgroup" as select * from "gacl"."aclgroup";

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
                CONSTRAINT "container_type_pk" PRIMARY KEY ("container_type_id")
);
COMMENT ON TABLE "container_type" IS 'Table des types de conteneurs';
COMMENT ON COLUMN "container_type"."container_type_description" IS 'Description longue';
COMMENT ON COLUMN "container_type"."storage_product" IS 'Produit utilisé pour le stockage (formol, alcool...)';
COMMENT ON COLUMN "container_type"."clp_classification" IS 'Classification du risque conformément à la directive européenne CLP';


ALTER SEQUENCE "container_type_container_type_id_seq" OWNED BY "container_type"."container_type_id";

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
                CONSTRAINT "label_pk" PRIMARY KEY ("label_id")
);
COMMENT ON TABLE "label" IS 'Table des modèles d''étiquettes';
COMMENT ON COLUMN "label"."label_name" IS 'Nom du modèle';
COMMENT ON COLUMN "label"."label_xsl" IS 'Contenu du fichier XSL utilisé pour la transformation FOP (https://xmlgraphics.apache.org/fop/)';
COMMENT ON COLUMN "label"."label_fields" IS 'Liste des champs à intégrer dans le QRCODE, séparés par une virgule';


ALTER SEQUENCE "label_label_id_seq" OWNED BY "label"."label_id";

CREATE SEQUENCE "metadata_attribute_metadata_attribute_id_seq";

CREATE TABLE "metadata_attribute" (
                "metadata_attribute_id" INTEGER NOT NULL DEFAULT nextval('"metadata_attribute_metadata_attribute_id_seq"'),
                "metadata_set_id" INTEGER NOT NULL,
                "metadata_schema_id" INTEGER,
                "metadata_name" VARCHAR NOT NULL,
                "metadata_code" VARCHAR,
                "metadata_order" INTEGER DEFAULT 1 NOT NULL,
                "metadata_type" VARCHAR DEFAULT 'varchar' NOT NULL,
                "metadata_defaultvalue" VARCHAR,
                "metadata_measure_unit" VARCHAR,
                "metadata_multivalue" BOOLEAN DEFAULT false NOT NULL,
                "metadata_enum" VARCHAR,
                CONSTRAINT "metadata_attribute_pk" PRIMARY KEY ("metadata_attribute_id")
);
COMMENT ON TABLE "metadata_attribute" IS 'Table des attributs rattachés à un jeu de métadonnées';
COMMENT ON COLUMN "metadata_attribute"."metadata_name" IS 'Nom de la métadonnée (creator, name...)';
COMMENT ON COLUMN "metadata_attribute"."metadata_code" IS 'Code normalisé de la métadonnée (ex : dcterms:creator)';
COMMENT ON COLUMN "metadata_attribute"."metadata_order" IS 'Ordre d''affichage des informations dans la grille de saisie';
COMMENT ON COLUMN "metadata_attribute"."metadata_measure_unit" IS 'Unité de mesure utilisée';
COMMENT ON COLUMN "metadata_attribute"."metadata_enum" IS 'Liste des valeurs possibles, séparées par ;';


ALTER SEQUENCE "metadata_attribute_metadata_attribute_id_seq" OWNED BY "metadata_attribute"."metadata_attribute_id";

CREATE SEQUENCE "metadata_schema_metadata_schema_id_seq";

CREATE TABLE "metadata_schema" (
                "metadata_schema_id" INTEGER NOT NULL DEFAULT nextval('"metadata_schema_metadata_schema_id_seq"'),
                "metadata_schema_name" VARCHAR NOT NULL,
                "metadata_schema_short_name" VARCHAR,
                "uri" VARCHAR,
                CONSTRAINT "metadata_schema_pk" PRIMARY KEY ("metadata_schema_id")
);
COMMENT ON TABLE "metadata_schema" IS 'Liste des schémas de métadonnées utilisés';
COMMENT ON COLUMN "metadata_schema"."metadata_schema_name" IS 'Nom complet du schéma';
COMMENT ON COLUMN "metadata_schema"."metadata_schema_short_name" IS 'abréviation habituelle (CC, DC...)';
COMMENT ON COLUMN "metadata_schema"."uri" IS 'Adresse URI d''accès à la description du schéma';


ALTER SEQUENCE "metadata_schema_metadata_schema_id_seq" OWNED BY "metadata_schema"."metadata_schema_id";

CREATE SEQUENCE "metadata_set_metadata_set_id_seq";

CREATE TABLE "metadata_set" (
                "metadata_set_id" INTEGER NOT NULL DEFAULT nextval('"metadata_set_metadata_set_id_seq"'),
                "metadata_set_name" VARCHAR NOT NULL,
                CONSTRAINT "metadata_set_pk" PRIMARY KEY ("metadata_set_id")
);
COMMENT ON TABLE "metadata_set" IS 'Jeu de métadonnées permettant de décrire précisément un échantillon';


ALTER SEQUENCE "metadata_set_metadata_set_id_seq" OWNED BY "metadata_set"."metadata_set_id";

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
                "operation_id" INTEGER NOT NULL DEFAULT nextval('"operation_operation_id_seq"'),
                "protocol_id" INTEGER NOT NULL,
                "operation_name" VARCHAR NOT NULL,
                "operation_order" INTEGER,
                CONSTRAINT "operation_pk" PRIMARY KEY ("operation_id")
);
COMMENT ON COLUMN "operation"."operation_order" IS 'Ordre de réalisation de l''opération dans le protocole';


ALTER SEQUENCE "operation_operation_id_seq" OWNED BY "operation"."operation_id";

CREATE SEQUENCE "project_project_id_seq";

CREATE TABLE "project" (
                "project_id" INTEGER NOT NULL DEFAULT nextval('"project_project_id_seq"'),
                "project_name" VARCHAR NOT NULL,
                CONSTRAINT "project_pk" PRIMARY KEY ("project_id")
);
COMMENT ON TABLE "project" IS 'Table des projets';


ALTER SEQUENCE "project_project_id_seq" OWNED BY "project"."project_id";

CREATE TABLE "projet_group" (
                "project_id" INTEGER NOT NULL,
                "aclgroup_id" INTEGER NOT NULL,
                CONSTRAINT "projet_group_pk" PRIMARY KEY ("project_id", "aclgroup_id")
);
COMMENT ON TABLE "projet_group" IS 'Table des autorisations d''accès à un projet';


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
                CONSTRAINT "sample_pk" PRIMARY KEY ("sample_id")
);
COMMENT ON TABLE "sample" IS 'Table des échantillons';
COMMENT ON COLUMN "sample"."sample_creation_date" IS 'Date de création de l''enregistrement dans la base de données';
COMMENT ON COLUMN "sample"."sample_date" IS 'Date de création de l''échantillon physique';
COMMENT ON COLUMN "sample"."multiple_value" IS 'Nombre initial de sous-échantillons';


ALTER SEQUENCE "sample_sample_id_seq" OWNED BY "sample"."sample_id";

CREATE TABLE "sample_metadata" (
                "sample_id" INTEGER NOT NULL,
                "data" jsonb NOT NULL,
                CONSTRAINT "sample_metadata_pk" PRIMARY KEY ("sample_id")
);
COMMENT ON COLUMN "sample_metadata"."data" IS 'Champ JSONB pour stockage des données spécifiques de l''échantillon';


CREATE SEQUENCE "sample_type_sample_type_id_seq";

CREATE TABLE "sample_type" (
                "sample_type_id" INTEGER NOT NULL DEFAULT nextval('"sample_type_sample_type_id_seq"'),
                "sample_type_name" VARCHAR NOT NULL,
                "container_type_id" INTEGER,
                "operation_id" INTEGER,
                "metadata_set_id" INTEGER,
                "metadata_set_id_second" INTEGER,
                "multiple_type_id" INTEGER,
                "multiple_unit" VARCHAR,
                CONSTRAINT "sample_type_pk" PRIMARY KEY ("sample_type_id")
);
COMMENT ON TABLE "sample_type" IS 'Types d''échantillons';
COMMENT ON COLUMN "sample_type"."metadata_set_id_second" IS 'Second jeu de métadonnées rattaché au type';
COMMENT ON COLUMN "sample_type"."multiple_unit" IS 'Unité caractérisant le sous-échantillon';


ALTER SEQUENCE "sample_type_sample_type_id_seq" OWNED BY "sample_type"."sample_type_id";

CREATE SEQUENCE "storage_storage_id_seq";

CREATE TABLE "storage" (
                "storage_id" INTEGER NOT NULL DEFAULT nextval('"storage_storage_id_seq"'),
                "uid" INTEGER NOT NULL,
                "container_id" INTEGER,
                "movement_type_id" INTEGER NOT NULL,
                "storage_reason_id" INTEGER,
                "storage_date" TIMESTAMP NOT NULL,
                "range" VARCHAR,
                "login" VARCHAR NOT NULL,
                "storage_comment" VARCHAR,
                CONSTRAINT "storage_pk" PRIMARY KEY ("storage_id")
);
COMMENT ON TABLE "storage" IS 'Gestion du stockage des échantillons';
COMMENT ON COLUMN "storage"."storage_date" IS 'Date/heure du mouvement';
COMMENT ON COLUMN "storage"."range" IS 'Emplacement de l''échantillon dans le conteneur';
COMMENT ON COLUMN "storage"."login" IS 'Nom de l''utilisateur ayant réalisé l''opération';
COMMENT ON COLUMN "storage"."storage_comment" IS 'Commentaire';


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

ALTER TABLE "metadata_attribute" ADD CONSTRAINT "metadata_schema_metadata_attribute_fk"
FOREIGN KEY ("metadata_schema_id")
REFERENCES "metadata_schema" ("metadata_schema_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "metadata_attribute" ADD CONSTRAINT "metadata_set_metadata_attribute_fk"
FOREIGN KEY ("metadata_set_id")
REFERENCES "metadata_set" ("metadata_set_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "sample_type" ADD CONSTRAINT "metadata_set_sample_type_fk"
FOREIGN KEY ("metadata_set_id")
REFERENCES "metadata_set" ("metadata_set_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "sample_type" ADD CONSTRAINT "metadata_set_sample_type_fk1"
FOREIGN KEY ("metadata_set_id_second")
REFERENCES "metadata_set" ("metadata_set_id")
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

ALTER TABLE "sample_type" ADD CONSTRAINT "operation_sample_type_fk"
FOREIGN KEY ("operation_id")
REFERENCES "operation" ("operation_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "projet_group" ADD CONSTRAINT "project_projet_group_fk"
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

ALTER TABLE "sample_metadata" ADD CONSTRAINT "sample_sample_metadata_fk"
FOREIGN KEY ("sample_id")
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

create or replace view last_movement as (
select s.uid, storage_id, storage_date, movement_type_id, container_id, c.uid as "container_uid"
from storage s
left outer join container c using (container_id)
order by storage_date desc limit 1);


insert into movement_type (movement_type_id, movement_type_name) values (1, 'Entrée/Entry'),(2, 'Sortie/Exit');

INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  1,  'application/pdf',  'pdf');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  2,  'application/zip',  'zip');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  3,  'audio/mpeg',  'mp3');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  4,  'image/jpeg',  'jpg');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES(  5,  'image/jpeg',  'jpeg');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  6,  'image/png',  'png');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  7,  'image/tiff',  'tiff');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  9,  'application/vnd.oasis.opendocument.text',  'odt');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  10,  'application/vnd.oasis.opendocument.spreadsheet',  'ods');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  11,  'application/vnd.ms-excel',  'xls');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  12,  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',  'xlsx');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  13,  'application/msword',  'doc');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  14,  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',  'docx');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  8,  'text/csv',  'csv');
 
create or replace view last_photo as (
select d.document_id, d.uid
from document d
where document_id = (
select d1.document_id from document d1
where d1.mime_type_id in (4,5,6) 
and d.uid = d1.uid
order by d1.document_creation_date desc, d1.document_import_date desc, d1.document_id desc
limit 1)
);

CREATE OR REPLACE VIEW last_movement
AS 
 SELECT s.uid, s.storage_id, s.storage_date, s.movement_type_id, s.container_id, c.uid AS container_uid
   FROM storage s
   JOIN container c USING (container_id)
  WHERE s.storage_date = (( SELECT max(st1.storage_date) AS max
      FROM storage st1
     WHERE st1.uid = s.uid));
     
CREATE OR REPLACE VIEW v_object_identifier
AS 
 SELECT object_identifier.uid, array_to_string(array_agg((identifier_type.identifier_type_code::text || ':'::text) || object_identifier.object_identifier_value::text ORDER BY identifier_type.identifier_type_code, object_identifier.object_identifier_value), ','::text) AS identifiers
   FROM object_identifier
   JOIN identifier_type USING (identifier_type_id)
  GROUP BY object_identifier.uid
  ORDER BY object_identifier.uid;
  
/*
 * Ajout de donnees par defaut
 */
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

