--create schema col;

CREATE SEQUENCE "col"."container_container_id_seq";

CREATE TABLE "col"."container" (
                "container_id" INTEGER NOT NULL DEFAULT nextval('"col"."container_container_id_seq"'),
                "uid" INTEGER NOT NULL,
                "container_type_id" INTEGER NOT NULL,
                "Parent_container_id" INTEGER NOT NULL,
                "container_range" VARCHAR,
                CONSTRAINT "container_pk" PRIMARY KEY ("container_id")
);
COMMENT ON TABLE "col"."container" IS 'Liste des conteneurs d''échantillon';
COMMENT ON COLUMN "col"."container"."container_range" IS 'Emplacement de stockage du conteneur dans le conteneur parent';


ALTER SEQUENCE "col"."container_container_id_seq" OWNED BY "col"."container"."container_id";

CREATE SEQUENCE "col"."container_type_container_type_id_seq";

CREATE TABLE "col"."container_type" (
                "container_type_id" INTEGER NOT NULL DEFAULT nextval('"col"."container_type_container_type_id_seq"'),
                "container_type_name" VARCHAR NOT NULL,
                CONSTRAINT "container_type_pk" PRIMARY KEY ("container_type_id")
);
COMMENT ON TABLE "col"."container_type" IS 'Table des types de conteneurs';


ALTER SEQUENCE "col"."container_type_container_type_id_seq" OWNED BY "col"."container_type"."container_type_id";

CREATE TABLE "col"."event" (
                "event_id" INTEGER NOT NULL,
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

CREATE SEQUENCE "col"."metadata_attribute_metadata_attribute_id_seq";

CREATE TABLE "col"."metadata_attribute" (
                "metadata_attribute_id" INTEGER NOT NULL DEFAULT nextval('"col"."metadata_attribute_metadata_attribute_id_seq"'),
                "metadata_set_id" INTEGER NOT NULL,
                "metadata_schema_id" INTEGER,
                "metadata_name" VARCHAR NOT NULL,
                "metadata_code" VARCHAR,
                CONSTRAINT "metadata_attribute_pk" PRIMARY KEY ("metadata_attribute_id")
);
COMMENT ON TABLE "col"."metadata_attribute" IS 'Table des attributs rattachés à un jeu de métadonnées';
COMMENT ON COLUMN "col"."metadata_attribute"."metadata_name" IS 'Nom de la métadonnée (creator, name...)';
COMMENT ON COLUMN "col"."metadata_attribute"."metadata_code" IS 'Code normalisé de la métadonnée (ex : dcterms:creator)';


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

CREATE SEQUENCE "col"."movement_type_movement_type_id_seq";

CREATE TABLE "col"."movement_type" (
                "movement_type_id" INTEGER NOT NULL DEFAULT nextval('"col"."movement_type_movement_type_id_seq"'),
                "movement_type_name" VARCHAR NOT NULL,
                CONSTRAINT "movement_type_pk" PRIMARY KEY ("movement_type_id")
);
COMMENT ON TABLE "col"."movement_type" IS 'Type de mouvement';


ALTER SEQUENCE "col"."movement_type_movement_type_id_seq" OWNED BY "col"."movement_type"."movement_type_id";

CREATE SEQUENCE "col"."object_uid_seq";

CREATE TABLE "col"."object" (
                "uid" INTEGER NOT NULL DEFAULT nextval('"col"."object_uid_seq"'),
                "identifier" VARCHAR,
                CONSTRAINT "object_pk" PRIMARY KEY ("uid")
);
COMMENT ON TABLE "col"."object" IS 'Table des objets
Contient les identifiants génériques';
COMMENT ON COLUMN "col"."object"."identifier" IS 'Identifiant fourni le cas échéant par le projet';


ALTER SEQUENCE "col"."object_uid_seq" OWNED BY "col"."object"."uid";

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


CREATE SEQUENCE "col"."sample_sample_id_seq";

CREATE TABLE "col"."sample" (
                "sample_id" INTEGER NOT NULL DEFAULT nextval('"col"."sample_sample_id_seq"'),
                "uid" INTEGER NOT NULL,
                "project_id" INTEGER NOT NULL,
                "sample_type_id" INTEGER NOT NULL,
                "sample_creation_date" TIMESTAMP NOT NULL,
                "sample_date" TIMESTAMP,
                "Parent_sample_id" INTEGER NOT NULL,
                CONSTRAINT "sample_pk" PRIMARY KEY ("sample_id")
);
COMMENT ON TABLE "col"."sample" IS 'Table des échantillons';
COMMENT ON COLUMN "col"."sample"."sample_creation_date" IS 'Date de création de l''enregistrement dans la base de données';
COMMENT ON COLUMN "col"."sample"."sample_date" IS 'Date de création de l''échantillon physique';


ALTER SEQUENCE "col"."sample_sample_id_seq" OWNED BY "col"."sample"."sample_id";

CREATE SEQUENCE "col"."sample_attribute_sample_attribute_id_seq";

CREATE TABLE "col"."sample_attribute" (
                "sample_attribute_id" INTEGER NOT NULL DEFAULT nextval('"col"."sample_attribute_sample_attribute_id_seq"'),
                "metadata_attribute_id" INTEGER NOT NULL,
                "sample_attribute_value" VARCHAR NOT NULL,
                "sample_id" INTEGER NOT NULL,
                CONSTRAINT "sample_attribute_pk" PRIMARY KEY ("sample_attribute_id")
);
COMMENT ON TABLE "col"."sample_attribute" IS 'Attributs descriptifs des échantillons';


ALTER SEQUENCE "col"."sample_attribute_sample_attribute_id_seq" OWNED BY "col"."sample_attribute"."sample_attribute_id";

CREATE SEQUENCE "col"."sample_type_sample_type_id_seq";

CREATE TABLE "col"."sample_type" (
                "sample_type_id" INTEGER NOT NULL DEFAULT nextval('"col"."sample_type_sample_type_id_seq"'),
                "sample_type_name" VARCHAR NOT NULL,
                "metadata_set_id" INTEGER,
                CONSTRAINT "sample_type_pk" PRIMARY KEY ("sample_type_id")
);
COMMENT ON TABLE "col"."sample_type" IS 'Types d''échantillons';


ALTER SEQUENCE "col"."sample_type_sample_type_id_seq" OWNED BY "col"."sample_type"."sample_type_id";

CREATE SEQUENCE "col"."storage_storage_id_seq";

CREATE TABLE "col"."storage" (
                "storage_id" INTEGER NOT NULL DEFAULT nextval('"col"."storage_storage_id_seq"'),
                "uid" INTEGER NOT NULL,
                "container_id" INTEGER,
                "movement_type_id" INTEGER NOT NULL,
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

ALTER TABLE "col"."container" ADD CONSTRAINT "container_container_fk"
FOREIGN KEY ("Parent_container_id")
REFERENCES "col"."container" ("container_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."storage" ADD CONSTRAINT "container_storage_fk"
FOREIGN KEY ("container_id")
REFERENCES "col"."container" ("container_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."container" ADD CONSTRAINT "container_type_container_fk"
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


ALTER TABLE "col"."projet_group" ADD CONSTRAINT "group_projet_aclgroup_fk"
FOREIGN KEY ("aclgroup_id")
REFERENCES "gacl"."aclgroup" ("aclgroup_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE "col"."sample_attribute" ADD CONSTRAINT "metadata_attribute_sample_attribute_fk"
FOREIGN KEY ("metadata_attribute_id")
REFERENCES "col"."metadata_attribute" ("metadata_attribute_id")
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

ALTER TABLE "col"."storage" ADD CONSTRAINT "movement_type_storage_fk"
FOREIGN KEY ("movement_type_id")
REFERENCES "col"."movement_type" ("movement_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."container" ADD CONSTRAINT "object_container_fk"
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

ALTER TABLE "col"."sample" ADD CONSTRAINT "sample_sample_fk"
FOREIGN KEY ("Parent_sample_id")
REFERENCES "col"."sample" ("sample_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "col"."sample_attribute" ADD CONSTRAINT "sample_sample_attribute_fk"
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
