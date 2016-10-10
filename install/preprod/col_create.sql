create or replace view "col"."aclgroup" as select * from "gacl"."aclgroup";

CREATE SEQUENCE "col"."booking_booking_id_seq";

CREATE TABLE "col"."booking" (
                "booking_id" INTEGER NOT NULL DEFAULT nextval('"col"."booking_booking_id_seq"'),
                "uid" INTEGER NOT NULL,
                "booking_date" TIMESTAMP NOT NULL,
                "date_from" TIMESTAMP NOT NULL,
                "date_to" TIMESTAMP NOT NULL,
                "booking_comment" VARCHAR,
                "booking_login" VARCHAR NOT NULL,
                CONSTRAINT "booking_pk" PRIMARY KEY ("booking_id")
);
COMMENT ON TABLE "col"."booking" IS 'Table des réservations d''objets';
COMMENT ON COLUMN "col"."booking"."booking_date" IS 'Date de la réservation';
COMMENT ON COLUMN "col"."booking"."date_from" IS 'Date-heure de début de la réservation';
COMMENT ON COLUMN "col"."booking"."date_to" IS 'Date-heure de fin de la réservation';
COMMENT ON COLUMN "col"."booking"."booking_comment" IS 'Commentaire';
COMMENT ON COLUMN "col"."booking"."booking_login" IS 'Compte ayant réalisé la réservation';


ALTER SEQUENCE "col"."booking_booking_id_seq" OWNED BY "col"."booking"."booking_id";

CREATE SEQUENCE "col"."container_container_id_seq";

CREATE TABLE "col"."container" (
                "container_id" INTEGER NOT NULL DEFAULT nextval('"col"."container_container_id_seq"'),
                "uid" INTEGER NOT NULL,
                "container_type_id" INTEGER NOT NULL,
                CONSTRAINT "container_pk" PRIMARY KEY ("container_id")
);
COMMENT ON TABLE "col"."container" IS 'Liste des conteneurs d''échantillon';


ALTER SEQUENCE "col"."container_container_id_seq" OWNED BY "col"."container"."container_id";

CREATE SEQUENCE "col"."container_family_container_family_id_seq";

CREATE TABLE "col"."container_family" (
                "container_family_id" INTEGER NOT NULL DEFAULT nextval('"col"."container_family_container_family_id_seq"'),
                "container_family_name" VARCHAR NOT NULL,
                "is_movable" BOOLEAN DEFAULT true NOT NULL,
                CONSTRAINT "container_family_pk" PRIMARY KEY ("container_family_id")
);
COMMENT ON TABLE "col"."container_family" IS 'Famille générique des conteneurs';
COMMENT ON COLUMN "col"."container_family"."is_movable" IS 'Indique si la famille de conteneurs est déplçable facilement ou non (éprouvette : oui, armoire : non)';


ALTER SEQUENCE "col"."container_family_container_family_id_seq" OWNED BY "col"."container_family"."container_family_id";

CREATE SEQUENCE "col"."container_type_container_type_id_seq";

CREATE TABLE "col"."container_type" (
                "container_type_id" INTEGER NOT NULL DEFAULT nextval('"col"."container_type_container_type_id_seq"'),
                "container_type_name" VARCHAR NOT NULL,
                "container_family_id" INTEGER NOT NULL,
                "storage_condition_id" INTEGER,
                "label_id" INTEGER,
                "container_type_description" VARCHAR,
                "storage_product" VARCHAR,
                "clp_classification" VARCHAR,
                CONSTRAINT "container_type_pk" PRIMARY KEY ("container_type_id")
);
COMMENT ON TABLE "col"."container_type" IS 'Table des types de conteneurs';
COMMENT ON COLUMN "col"."container_type"."container_type_description" IS 'Description longue';
COMMENT ON COLUMN "col"."container_type"."storage_product" IS 'Produit utilisé pour le stockage (formol, alcool...)';
COMMENT ON COLUMN "col"."container_type"."clp_classification" IS 'Classification du risque conformément à la directive européenne CLP';


ALTER SEQUENCE "col"."container_type_container_type_id_seq" OWNED BY "col"."container_type"."container_type_id";

CREATE SEQUENCE "col"."document_document_id_seq";

CREATE TABLE "col"."document" (
                "document_id" INTEGER NOT NULL DEFAULT nextval('"col"."document_document_id_seq"'),
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
COMMENT ON TABLE "col"."document" IS 'Documents numériques rattachés à un poisson ou à un événement';
COMMENT ON COLUMN "col"."document"."document_import_date" IS 'Date d''import dans la base de données';
COMMENT ON COLUMN "col"."document"."document_name" IS 'Nom d''origine du document';
COMMENT ON COLUMN "col"."document"."document_description" IS 'Description libre du document';
COMMENT ON COLUMN "col"."document"."data" IS 'Contenu du document';
COMMENT ON COLUMN "col"."document"."thumbnail" IS 'Vignette au format PNG (documents pdf, jpg ou png)';
COMMENT ON COLUMN "col"."document"."size" IS 'Taille du fichier téléchargé';
COMMENT ON COLUMN "col"."document"."document_creation_date" IS 'Date de création du document (date de prise de vue de la photo)';


ALTER SEQUENCE "col"."document_document_id_seq" OWNED BY "col"."document"."document_id";

CREATE SEQUENCE "col"."event_event_id_seq";

CREATE TABLE "col"."event" (
                "event_id" INTEGER NOT NULL DEFAULT nextval('"col"."event_event_id_seq"'),
                "uid" INTEGER NOT NULL,
                "event_date" TIMESTAMP NOT NULL,
                "event_type_id" INTEGER NOT NULL,
                "still_available" VARCHAR,
                "event_comment" VARCHAR,
                CONSTRAINT "event_pk" PRIMARY KEY ("event_id")
);
COMMENT ON TABLE "col"."event" IS 'Table des événements';
COMMENT ON COLUMN "col"."event"."event_date" IS 'Date / heure de l''événement';
COMMENT ON COLUMN "col"."event"."still_available" IS 'définit ce qu''il reste de disponible dans l''objet';


ALTER SEQUENCE "col"."event_event_id_seq" OWNED BY "col"."event"."event_id";

CREATE SEQUENCE "col"."event_type_event_type_id_seq";

CREATE TABLE "col"."event_type" (
                "event_type_id" INTEGER NOT NULL DEFAULT nextval('"col"."event_type_event_type_id_seq"'),
                "event_type_name" VARCHAR NOT NULL,
                "is_sample" BOOLEAN DEFAULT false NOT NULL,
                "is_container" BOOLEAN DEFAULT false NOT NULL,
                CONSTRAINT "event_type_pk" PRIMARY KEY ("event_type_id")
);
COMMENT ON TABLE "col"."event_type" IS 'Types d''événement';
COMMENT ON COLUMN "col"."event_type"."is_sample" IS 'L''événement s''applique aux échantillons';
COMMENT ON COLUMN "col"."event_type"."is_container" IS 'L''événement s''applique aux conteneurs';


ALTER SEQUENCE "col"."event_type_event_type_id_seq" OWNED BY "col"."event_type"."event_type_id";

CREATE SEQUENCE "col"."identifier_type_identifier_type_id_seq";

CREATE TABLE "col"."identifier_type" (
                "identifier_type_id" INTEGER NOT NULL DEFAULT nextval('"col"."identifier_type_identifier_type_id_seq"'),
                "identifier_type_name" VARCHAR NOT NULL,
                "identifier_type_code" VARCHAR NOT NULL,
                CONSTRAINT "identifier_type_pk" PRIMARY KEY ("identifier_type_id")
);
COMMENT ON TABLE "col"."identifier_type" IS 'Table des types d''identifiants';
COMMENT ON COLUMN "col"."identifier_type"."identifier_type_name" IS 'Nom textuel de l''identifiant';
COMMENT ON COLUMN "col"."identifier_type"."identifier_type_code" IS 'Code utilisé pour la génération des étiquettes';


ALTER SEQUENCE "col"."identifier_type_identifier_type_id_seq" OWNED BY "col"."identifier_type"."identifier_type_id";

CREATE SEQUENCE "col"."label_label_id_seq";

CREATE TABLE "col"."label" (
                "label_id" INTEGER NOT NULL DEFAULT nextval('"col"."label_label_id_seq"'),
                "label_name" VARCHAR NOT NULL,
                "label_xsl" VARCHAR NOT NULL,
                "label_fields" VARCHAR DEFAULT 'uid,id,clp,db' NOT NULL,
                CONSTRAINT "label_pk" PRIMARY KEY ("label_id")
);
COMMENT ON TABLE "col"."label" IS 'Table des modèles d''étiquettes';
COMMENT ON COLUMN "col"."label"."label_name" IS 'Nom du modèle';
COMMENT ON COLUMN "col"."label"."label_xsl" IS 'Contenu du fichier XSL utilisé pour la transformation FOP (https://xmlgraphics.apache.org/fop/)';
COMMENT ON COLUMN "col"."label"."label_fields" IS 'Liste des champs à intégrer dans le QRCODE, séparés par une virgule';


ALTER SEQUENCE "col"."label_label_id_seq" OWNED BY "col"."label"."label_id";

CREATE SEQUENCE "col"."metadata_attribute_metadata_attribute_id_seq";

CREATE TABLE "col"."metadata_attribute" (
                "metadata_attribute_id" INTEGER NOT NULL DEFAULT nextval('"col"."metadata_attribute_metadata_attribute_id_seq"'),
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
COMMENT ON TABLE "col"."metadata_attribute" IS 'Table des attributs rattachés à un jeu de métadonnées';
COMMENT ON COLUMN "col"."metadata_attribute"."metadata_name" IS 'Nom de la métadonnée (creator, name...)';
COMMENT ON COLUMN "col"."metadata_attribute"."metadata_code" IS 'Code normalisé de la métadonnée (ex : dcterms:creator)';
COMMENT ON COLUMN "col"."metadata_attribute"."metadata_order" IS 'Ordre d''affichage des informations dans la grille de saisie';
COMMENT ON COLUMN "col"."metadata_attribute"."metadata_measure_unit" IS 'Unité de mesure utilisée';
COMMENT ON COLUMN "col"."metadata_attribute"."metadata_enum" IS 'Liste des valeurs possibles, séparées par ;';


ALTER SEQUENCE "col"."metadata_attribute_metadata_attribute_id_seq" OWNED BY "col"."metadata_attribute"."metadata_attribute_id";

CREATE SEQUENCE "col"."metadata_schema_metadata_schema_id_seq";

CREATE TABLE "col"."metadata_schema" (
                "metadata_schema_id" INTEGER NOT NULL DEFAULT nextval('"col"."metadata_schema_metadata_schema_id_seq"'),
                "metadata_schema_name" VARCHAR NOT NULL,
                "metadata_schema_short_name" VARCHAR,
                "uri" VARCHAR,
                CONSTRAINT "metadata_schema_pk" PRIMARY KEY ("metadata_schema_id")
);
COMMENT ON TABLE "col"."metadata_schema" IS 'Liste des schémas de métadonnées utilisés';
COMMENT ON COLUMN "col"."metadata_schema"."metadata_schema_name" IS 'Nom complet du schéma';
COMMENT ON COLUMN "col"."metadata_schema"."metadata_schema_short_name" IS 'abréviation habituelle (CC, DC...)';
COMMENT ON COLUMN "col"."metadata_schema"."uri" IS 'Adresse URI d''accès à la description du schéma';


ALTER SEQUENCE "col"."metadata_schema_metadata_schema_id_seq" OWNED BY "col"."metadata_schema"."metadata_schema_id";

CREATE SEQUENCE "col"."metadata_set_metadata_set_id_seq";

CREATE TABLE "col"."metadata_set" (
                "metadata_set_id" INTEGER NOT NULL DEFAULT nextval('"col"."metadata_set_metadata_set_id_seq"'),
                "metadata_set_name" VARCHAR NOT NULL,
                CONSTRAINT "metadata_set_pk" PRIMARY KEY ("metadata_set_id")
);
COMMENT ON TABLE "col"."metadata_set" IS 'Jeu de métadonnées permettant de décrire précisément un échantillon';


ALTER SEQUENCE "col"."metadata_set_metadata_set_id_seq" OWNED BY "col"."metadata_set"."metadata_set_id";

CREATE SEQUENCE "col"."mime_type_mime_type_id_seq";

CREATE TABLE "col"."mime_type" (
                "mime_type_id" INTEGER NOT NULL DEFAULT nextval('"col"."mime_type_mime_type_id_seq"'),
                "extension" VARCHAR NOT NULL,
                "content_type" VARCHAR NOT NULL,
                CONSTRAINT "mime_type_pk" PRIMARY KEY ("mime_type_id")
);
COMMENT ON TABLE "col"."mime_type" IS 'Types mime des fichiers importés';
COMMENT ON COLUMN "col"."mime_type"."extension" IS 'Extension du fichier correspondant';
COMMENT ON COLUMN "col"."mime_type"."content_type" IS 'type mime officiel';


ALTER SEQUENCE "col"."mime_type_mime_type_id_seq" OWNED BY "col"."mime_type"."mime_type_id";

CREATE SEQUENCE "col"."movement_type_movement_type_id_seq";

CREATE TABLE "col"."movement_type" (
                "movement_type_id" INTEGER NOT NULL DEFAULT nextval('"col"."movement_type_movement_type_id_seq"'),
                "movement_type_name" VARCHAR NOT NULL,
                CONSTRAINT "movement_type_pk" PRIMARY KEY ("movement_type_id")
);
COMMENT ON TABLE "col"."movement_type" IS 'Type de mouvement';


ALTER SEQUENCE "col"."movement_type_movement_type_id_seq" OWNED BY "col"."movement_type"."movement_type_id";

CREATE SEQUENCE "col"."multiple_type_multiple_type_id_seq";

CREATE TABLE "col"."multiple_type" (
                "multiple_type_id" INTEGER NOT NULL DEFAULT nextval('"col"."multiple_type_multiple_type_id_seq"'),
                "multiple_type_name" VARCHAR NOT NULL,
                CONSTRAINT "multiple_type_pk" PRIMARY KEY ("multiple_type_id")
);
COMMENT ON TABLE "col"."multiple_type" IS 'Table des types de contenus multiples';


ALTER SEQUENCE "col"."multiple_type_multiple_type_id_seq" OWNED BY "col"."multiple_type"."multiple_type_id";

CREATE SEQUENCE "col"."object_uid_seq";

CREATE TABLE "col"."object" (
                "uid" INTEGER NOT NULL DEFAULT nextval('"col"."object_uid_seq"'),
                "identifier" VARCHAR,
                "object_status_id" INTEGER,
                "wgs84_x" DOUBLE PRECISION,
                "wgs84_y" DOUBLE PRECISION,
                CONSTRAINT "object_pk" PRIMARY KEY ("uid")
);
COMMENT ON TABLE "col"."object" IS 'Table des objets
Contient les identifiants génériques';
COMMENT ON COLUMN "col"."object"."identifier" IS 'Identifiant fourni le cas échéant par le projet';
COMMENT ON COLUMN "col"."object"."wgs84_x" IS 'Longitude GPS, en valeur décimale';
COMMENT ON COLUMN "col"."object"."wgs84_y" IS 'Latitude GPS, en décimal';


ALTER SEQUENCE "col"."object_uid_seq" OWNED BY "col"."object"."uid";

CREATE SEQUENCE "col"."object_identifier_object_identifier_id_seq";

CREATE TABLE "col"."object_identifier" (
                "object_identifier_id" INTEGER NOT NULL DEFAULT nextval('"col"."object_identifier_object_identifier_id_seq"'),
                "uid" INTEGER NOT NULL,
                "identifier_type_id" INTEGER NOT NULL,
                "object_identifier_value" VARCHAR NOT NULL,
                CONSTRAINT "object_identifier_pk" PRIMARY KEY ("object_identifier_id")
);
COMMENT ON TABLE "col"."object_identifier" IS 'Table des identifiants complémentaires normalisés';
COMMENT ON COLUMN "col"."object_identifier"."object_identifier_value" IS 'Valeur de l''identifiant';


ALTER SEQUENCE "col"."object_identifier_object_identifier_id_seq" OWNED BY "col"."object_identifier"."object_identifier_id";

CREATE SEQUENCE "col"."object_status_object_status_id_seq";

CREATE TABLE "col"."object_status" (
                "object_status_id" INTEGER NOT NULL DEFAULT nextval('"col"."object_status_object_status_id_seq"'),
                "object_status_name" VARCHAR NOT NULL,
                CONSTRAINT "object_status_pk" PRIMARY KEY ("object_status_id")
);
COMMENT ON TABLE "col"."object_status" IS 'Table des statuts possibles des objets';


ALTER SEQUENCE "col"."object_status_object_status_id_seq" OWNED BY "col"."object_status"."object_status_id";

CREATE SEQUENCE "col"."operation_operation_id_seq";

CREATE TABLE "col"."operation" (
                "operation_id" INTEGER NOT NULL DEFAULT nextval('"col"."operation_operation_id_seq"'),
                "protocol_id" INTEGER NOT NULL,
                "operation_name" VARCHAR NOT NULL,
                "operation_order" INTEGER,
                CONSTRAINT "operation_pk" PRIMARY KEY ("operation_id")
);
COMMENT ON COLUMN "col"."operation"."operation_order" IS 'Ordre de réalisation de l''opération dans le protocole';


ALTER SEQUENCE "col"."operation_operation_id_seq" OWNED BY "col"."operation"."operation_id";

CREATE SEQUENCE "col"."project_project_id_seq";

CREATE TABLE "col"."project" (
                "project_id" INTEGER NOT NULL DEFAULT nextval('"col"."project_project_id_seq"'),
                "project_name" VARCHAR NOT NULL,
                CONSTRAINT "project_pk" PRIMARY KEY ("project_id")
);
COMMENT ON TABLE "col"."project" IS 'Table des projets';


ALTER SEQUENCE "col"."project_project_id_seq" OWNED BY "col"."project"."project_id";

CREATE TABLE "col"."projet_group" (
                "project_id" INTEGER NOT NULL,
                "aclgroup_id" INTEGER NOT NULL,
                CONSTRAINT "projet_group_pk" PRIMARY KEY ("project_id", "aclgroup_id")
);
COMMENT ON TABLE "col"."projet_group" IS 'Table des autorisations d''accès à un projet';


CREATE SEQUENCE "col"."protocol_protocol_id_seq";

CREATE TABLE "col"."protocol" (
                "protocol_id" INTEGER NOT NULL DEFAULT nextval('"col"."protocol_protocol_id_seq"'),
                "protocol_name" VARCHAR NOT NULL,
                "protocol_file" BYTEA,
                "protocol_year" SMALLINT,
                "protocol_version" VARCHAR DEFAULT 'v1.0' NOT NULL,
                CONSTRAINT "protocol_pk" PRIMARY KEY ("protocol_id")
);
COMMENT ON COLUMN "col"."protocol"."protocol_file" IS 'Description PDF du protocole';
COMMENT ON COLUMN "col"."protocol"."protocol_year" IS 'Année du protocole';
COMMENT ON COLUMN "col"."protocol"."protocol_version" IS 'Version du protocole';


ALTER SEQUENCE "col"."protocol_protocol_id_seq" OWNED BY "col"."protocol"."protocol_id";

CREATE SEQUENCE "col"."sample_sample_id_seq";

CREATE TABLE "col"."sample" (
                "sample_id" INTEGER NOT NULL DEFAULT nextval('"col"."sample_sample_id_seq"'),
                "uid" INTEGER NOT NULL,
                "project_id" INTEGER NOT NULL,
                "sample_type_id" INTEGER NOT NULL,
                "sample_creation_date" TIMESTAMP NOT NULL,
                "sample_date" TIMESTAMP,
                "parent_sample_id" INTEGER,
                "multiple_value" DOUBLE PRECISION,
                CONSTRAINT "sample_pk" PRIMARY KEY ("sample_id")
);
COMMENT ON TABLE "col"."sample" IS 'Table des échantillons';
COMMENT ON COLUMN "col"."sample"."sample_creation_date" IS 'Date de création de l''enregistrement dans la base de données';
COMMENT ON COLUMN "col"."sample"."sample_date" IS 'Date de création de l''échantillon physique';
COMMENT ON COLUMN "col"."sample"."multiple_value" IS 'Nombre initial de sous-échantillons';


ALTER SEQUENCE "col"."sample_sample_id_seq" OWNED BY "col"."sample"."sample_id";

CREATE TABLE "col"."sample_metadata" (
                "sample_id" INTEGER NOT NULL,
                "data" VARCHAR NOT NULL,
                CONSTRAINT "sample_metadata_pk" PRIMARY KEY ("sample_id")
);
COMMENT ON COLUMN "col"."sample_metadata"."data" IS 'Champ JSONB pour stockage des données spécifiques de l''échantillon';


CREATE SEQUENCE "col"."sample_type_sample_type_id_seq";

CREATE TABLE "col"."sample_type" (
                "sample_type_id" INTEGER NOT NULL DEFAULT nextval('"col"."sample_type_sample_type_id_seq"'),
                "sample_type_name" VARCHAR NOT NULL,
                "container_type_id" INTEGER,
                "operation_id" INTEGER,
                "metadata_set_id" INTEGER,
                "metadata_set_id_second" INTEGER,
                "multiple_type_id" INTEGER,
                "multiple_unit" VARCHAR,
                CONSTRAINT "sample_type_pk" PRIMARY KEY ("sample_type_id")
);
COMMENT ON TABLE "col"."sample_type" IS 'Types d''échantillons';
COMMENT ON COLUMN "col"."sample_type"."metadata_set_id_second" IS 'Second jeu de métadonnées rattaché au type';
COMMENT ON COLUMN "col"."sample_type"."multiple_unit" IS 'Unité caractérisant le sous-échantillon';


ALTER SEQUENCE "col"."sample_type_sample_type_id_seq" OWNED BY "col"."sample_type"."sample_type_id";

CREATE SEQUENCE "col"."storage_storage_id_seq";

CREATE TABLE "col"."storage" (
                "storage_id" INTEGER NOT NULL DEFAULT nextval('"col"."storage_storage_id_seq"'),
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
COMMENT ON TABLE "col"."storage" IS 'Gestion du stockage des échantillons';
COMMENT ON COLUMN "col"."storage"."storage_date" IS 'Date/heure du mouvement';
COMMENT ON COLUMN "col"."storage"."range" IS 'Emplacement de l''échantillon dans le conteneur';
COMMENT ON COLUMN "col"."storage"."login" IS 'Nom de l''utilisateur ayant réalisé l''opération';
COMMENT ON COLUMN "col"."storage"."storage_comment" IS 'Commentaire';


ALTER SEQUENCE "col"."storage_storage_id_seq" OWNED BY "col"."storage"."storage_id";

CREATE SEQUENCE "col"."storage_condition_storage_condition_id_seq";

CREATE TABLE "col"."storage_condition" (
                "storage_condition_id" INTEGER NOT NULL DEFAULT nextval('"col"."storage_condition_storage_condition_id_seq"'),
                "storage_condition_name" VARCHAR NOT NULL,
                CONSTRAINT "storage_condition_pk" PRIMARY KEY ("storage_condition_id")
);
COMMENT ON TABLE "col"."storage_condition" IS 'Condition de stockage';


ALTER SEQUENCE "col"."storage_condition_storage_condition_id_seq" OWNED BY "col"."storage_condition"."storage_condition_id";

CREATE SEQUENCE "col"."storage_reason_storage_reason_id_seq";

CREATE TABLE "col"."storage_reason" (
                "storage_reason_id" INTEGER NOT NULL DEFAULT nextval('"col"."storage_reason_storage_reason_id_seq"'),
                "storage_reason_name" VARCHAR NOT NULL,
                CONSTRAINT "storage_reason_pk" PRIMARY KEY ("storage_reason_id")
);
COMMENT ON TABLE "col"."storage_reason" IS 'Table des raisons de stockage/déstockage';


ALTER SEQUENCE "col"."storage_reason_storage_reason_id_seq" OWNED BY "col"."storage_reason"."storage_reason_id";

CREATE SEQUENCE "col"."subsample_subsample_id_seq";

CREATE TABLE "col"."subsample" (
                "subsample_id" INTEGER NOT NULL DEFAULT nextval('"col"."subsample_subsample_id_seq"'),
                "sample_id" INTEGER NOT NULL,
                "subsample_date" TIMESTAMP NOT NULL,
                "movement_type_id" INTEGER NOT NULL,
                "subsample_quantity" DOUBLE PRECISION,
                "subsample_comment" VARCHAR,
                "subsample_login" VARCHAR NOT NULL,
                CONSTRAINT "subsample_pk" PRIMARY KEY ("subsample_id")
);
COMMENT ON TABLE "col"."subsample" IS 'Table des prélèvements et restitutions de sous-échantillons';
COMMENT ON COLUMN "col"."subsample"."subsample_date" IS 'Date/heure de l''opération';
COMMENT ON COLUMN "col"."subsample"."subsample_quantity" IS 'Quantité prélevée ou restituée';
COMMENT ON COLUMN "col"."subsample"."subsample_login" IS 'Login de l''utilisateur ayant réalisé l''opération';


ALTER SEQUENCE "col"."subsample_subsample_id_seq" OWNED BY "col"."subsample"."subsample_id";

ALTER TABLE "col"."storage" ADD CONSTRAINT "container_storage_fk"
FOREIGN KEY ("container_id")
REFERENCES "col"."container" ("container_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."container_type" ADD CONSTRAINT "container_family_container_type_fk"
FOREIGN KEY ("container_family_id")
REFERENCES "col"."container_family" ("container_family_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."container" ADD CONSTRAINT "container_type_container_fk"
FOREIGN KEY ("container_type_id")
REFERENCES "col"."container_type" ("container_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."sample_type" ADD CONSTRAINT "container_type_sample_type_fk"
FOREIGN KEY ("container_type_id")
REFERENCES "col"."container_type" ("container_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."event" ADD CONSTRAINT "event_type_event_fk"
FOREIGN KEY ("event_type_id")
REFERENCES "col"."event_type" ("event_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."object_identifier" ADD CONSTRAINT "identifier_type_object_identifier_fk"
FOREIGN KEY ("identifier_type_id")
REFERENCES "col"."identifier_type" ("identifier_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."container_type" ADD CONSTRAINT "label_container_type_fk"
FOREIGN KEY ("label_id")
REFERENCES "col"."label" ("label_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."metadata_attribute" ADD CONSTRAINT "metadata_schema_metadata_attribute_fk"
FOREIGN KEY ("metadata_schema_id")
REFERENCES "col"."metadata_schema" ("metadata_schema_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."metadata_attribute" ADD CONSTRAINT "metadata_set_metadata_attribute_fk"
FOREIGN KEY ("metadata_set_id")
REFERENCES "col"."metadata_set" ("metadata_set_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."sample_type" ADD CONSTRAINT "metadata_set_sample_type_fk"
FOREIGN KEY ("metadata_set_id")
REFERENCES "col"."metadata_set" ("metadata_set_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."sample_type" ADD CONSTRAINT "metadata_set_sample_type_fk1"
FOREIGN KEY ("metadata_set_id_second")
REFERENCES "col"."metadata_set" ("metadata_set_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."document" ADD CONSTRAINT "mime_type_document_fk"
FOREIGN KEY ("mime_type_id")
REFERENCES "col"."mime_type" ("mime_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."storage" ADD CONSTRAINT "movement_type_storage_fk"
FOREIGN KEY ("movement_type_id")
REFERENCES "col"."movement_type" ("movement_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."subsample" ADD CONSTRAINT "movement_type_subsample_fk"
FOREIGN KEY ("movement_type_id")
REFERENCES "col"."movement_type" ("movement_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."sample_type" ADD CONSTRAINT "multiple_type_sample_type_fk"
FOREIGN KEY ("multiple_type_id")
REFERENCES "col"."multiple_type" ("multiple_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."booking" ADD CONSTRAINT "object_booking_fk"
FOREIGN KEY ("uid")
REFERENCES "col"."object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."container" ADD CONSTRAINT "object_container_fk"
FOREIGN KEY ("uid")
REFERENCES "col"."object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."document" ADD CONSTRAINT "object_document_fk"
FOREIGN KEY ("uid")
REFERENCES "col"."object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."event" ADD CONSTRAINT "object_event_fk"
FOREIGN KEY ("uid")
REFERENCES "col"."object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."object_identifier" ADD CONSTRAINT "object_object_identifier_fk"
FOREIGN KEY ("uid")
REFERENCES "col"."object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."sample" ADD CONSTRAINT "object_sample_fk"
FOREIGN KEY ("uid")
REFERENCES "col"."object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."storage" ADD CONSTRAINT "object_storage_fk"
FOREIGN KEY ("uid")
REFERENCES "col"."object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."object" ADD CONSTRAINT "object_status_object_fk"
FOREIGN KEY ("object_status_id")
REFERENCES "col"."object_status" ("object_status_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."sample_type" ADD CONSTRAINT "operation_sample_type_fk"
FOREIGN KEY ("operation_id")
REFERENCES "col"."operation" ("operation_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."projet_group" ADD CONSTRAINT "project_projet_group_fk"
FOREIGN KEY ("project_id")
REFERENCES "col"."project" ("project_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."sample" ADD CONSTRAINT "project_sample_fk"
FOREIGN KEY ("project_id")
REFERENCES "col"."project" ("project_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."operation" ADD CONSTRAINT "protocol_operation_fk"
FOREIGN KEY ("protocol_id")
REFERENCES "col"."protocol" ("protocol_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."sample" ADD CONSTRAINT "sample_sample_fk"
FOREIGN KEY ("parent_sample_id")
REFERENCES "col"."sample" ("sample_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."sample_metadata" ADD CONSTRAINT "sample_sample_metadata_fk"
FOREIGN KEY ("sample_id")
REFERENCES "col"."sample" ("sample_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."subsample" ADD CONSTRAINT "sample_subsample_fk"
FOREIGN KEY ("sample_id")
REFERENCES "col"."sample" ("sample_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."sample" ADD CONSTRAINT "sample_type_sample_fk"
FOREIGN KEY ("sample_type_id")
REFERENCES "col"."sample_type" ("sample_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."container_type" ADD CONSTRAINT "storage_condition_container_type_fk"
FOREIGN KEY ("storage_condition_id")
REFERENCES "col"."storage_condition" ("storage_condition_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."storage" ADD CONSTRAINT "storage_reason_storage_fk"
FOREIGN KEY ("storage_reason_id")
REFERENCES "col"."storage_reason" ("storage_reason_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

create or replace view "col".last_movement as (
select s.uid, storage_id, storage_date, movement_type_id, container_id, c.uid as "container_uid"
from col.storage s
left outer join col.container c using (container_id)
order by storage_date desc limit 1);


insert into "col".movement_type (movement_type_id, movement_type_name) values (1, 'Entrée/Entry'),(2, 'Sortie/Exit');

INSERT INTO "col".mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  1,  'application/pdf',  'pdf');
 
 INSERT INTO "col".mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  2,  'application/zip',  'zip');
 
 INSERT INTO "col".mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  3,  'audio/mpeg',  'mp3');
 
 INSERT INTO "col".mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  4,  'image/jpeg',  'jpg');
 
 INSERT INTO "col".mime_type(  mime_type_id,  content_type,  extension)
 VALUES(  5,  'image/jpeg',  'jpeg');
 
 INSERT INTO "col".mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  6,  'image/png',  'png');
 
 INSERT INTO "col".mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  7,  'image/tiff',  'tiff');
 
 INSERT INTO "col".mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  9,  'application/vnd.oasis.opendocument.text',  'odt');
 
 INSERT INTO "col".mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  10,  'application/vnd.oasis.opendocument.spreadsheet',  'ods');
 
 INSERT INTO "col".mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  11,  'application/vnd.ms-excel',  'xls');
 
 INSERT INTO "col".mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  12,  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',  'xlsx');
 
 INSERT INTO "col".mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  13,  'application/msword',  'doc');
 
 INSERT INTO "col".mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  14,  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',  'docx');
 
 INSERT INTO "col".mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  8,  'text/csv',  'csv');
 
create or replace view "col".last_photo as (
select d.document_id, d.uid
from "col".document d
where document_id = (
select d1.document_id from "col".document d1
where d1.mime_type_id in (4,5,6) 
and d.uid = d1.uid
order by d1.document_creation_date desc, d1.document_import_date desc, d1.document_id desc
limit 1)
);

CREATE OR REPLACE VIEW "col".last_movement
AS 
 SELECT s.uid, s.storage_id, s.storage_date, s.movement_type_id, s.container_id, c.uid AS container_uid
   FROM "col".storage s
   JOIN "col".container c USING (container_id)
  WHERE s.storage_date = (( SELECT max(st1.storage_date) AS max
      FROM "col".storage st1
     WHERE st1.uid = s.uid));
     
CREATE OR REPLACE VIEW "col".v_object_identifier
AS 
 SELECT object_identifier.uid, array_to_string(array_agg((identifier_type.identifier_type_code::text || ':'::text) || object_identifier.object_identifier_value::text ORDER BY identifier_type.identifier_type_code, object_identifier.object_identifier_value), ','::text) AS identifiers
   FROM "col".object_identifier
   JOIN "col".identifier_type USING (identifier_type_id)
  GROUP BY object_identifier.uid
  ORDER BY object_identifier.uid;
