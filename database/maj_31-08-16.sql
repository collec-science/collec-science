
ALTER TABLE "eabxcol"."col"."container" DROP CONSTRAINT "container_status_container_fk";

ALTER TABLE "eabxcol"."col"."sample_attribute" DROP CONSTRAINT "metadata_attribute_sample_attribute_fk";

ALTER TABLE "eabxcol"."col"."sample_attribute" DROP CONSTRAINT "sample_sample_attribute_fk";

ALTER TABLE "eabxcol"."col"."container" DROP COLUMN "container_status_id";

DROP TABLE "eabxcol"."col"."container_status";

ALTER TABLE "eabxcol"."col"."metadata_attribute" ADD COLUMN "metadata_defaultvalue" VARCHAR;

ALTER TABLE "eabxcol"."col"."metadata_attribute" ADD COLUMN "metadata_enum" VARCHAR;

ALTER TABLE "eabxcol"."col"."metadata_attribute" ADD COLUMN "metadata_measure_unit" VARCHAR;

ALTER TABLE "eabxcol"."col"."metadata_attribute" ADD COLUMN "metadata_multivalue" BOOLEAN DEFAULT false NOT NULL;

ALTER TABLE "eabxcol"."col"."metadata_attribute" ADD COLUMN "metadata_order" INTEGER DEFAULT 1 NOT NULL;

ALTER TABLE "eabxcol"."col"."metadata_attribute" ADD COLUMN "metadata_type" VARCHAR DEFAULT 'varchar' NOT NULL;

ALTER TABLE "eabxcol"."col"."object" ADD COLUMN "object_status_id" INTEGER;

CREATE SEQUENCE "eabxcol"."col"."object_status_object_status_id_seq";

CREATE TABLE "eabxcol"."col"."object_status" (
                "object_status_id" INTEGER NOT NULL DEFAULT nextval('"eabxcol"."col"."object_status_object_status_id_seq"'),
                "object_status_name" VARCHAR NOT NULL,
                CONSTRAINT "object_status_pk" PRIMARY KEY ("object_status_id")
);
COMMENT ON TABLE "eabxcol"."col"."object_status" IS 'Table des statuts possibles des objets';


ALTER SEQUENCE "eabxcol"."col"."object_status_object_status_id_seq" OWNED BY "eabxcol"."col"."object_status"."object_status_id";

CREATE SEQUENCE "eabxcol"."col"."operation_operation_id_seq";

CREATE TABLE "eabxcol"."col"."operation" (
                "operation_id" INTEGER NOT NULL DEFAULT nextval('"eabxcol"."col"."operation_operation_id_seq"'),
                "protocol_id" INTEGER NOT NULL,
                "operation_name" VARCHAR NOT NULL,
                "operation_order" INTEGER,
                CONSTRAINT "operation_pk" PRIMARY KEY ("operation_id")
);
COMMENT ON COLUMN "eabxcol"."col"."operation"."operation_order" IS 'Ordre de réalisation de l''opération dans le protocole';


ALTER SEQUENCE "eabxcol"."col"."operation_operation_id_seq" OWNED BY "eabxcol"."col"."operation"."operation_id";

CREATE SEQUENCE "eabxcol"."col"."protocol_protocol_id_seq";

CREATE TABLE "eabxcol"."col"."protocol" (
                "protocol_id" INTEGER NOT NULL DEFAULT nextval('"eabxcol"."col"."protocol_protocol_id_seq"'),
                "protocol_name" VARCHAR NOT NULL,
                "protocol_file" BYTEA,
                "protocol_year" SMALLINT,
                "protocol_version" VARCHAR DEFAULT 'v1.0' NOT NULL,
                CONSTRAINT "protocol_pk" PRIMARY KEY ("protocol_id")
);
COMMENT ON COLUMN "eabxcol"."col"."protocol"."protocol_file" IS 'Description PDF du protocole';
COMMENT ON COLUMN "eabxcol"."col"."protocol"."protocol_year" IS 'Année du protocole';
COMMENT ON COLUMN "eabxcol"."col"."protocol"."protocol_version" IS 'Version du protocole';


ALTER SEQUENCE "eabxcol"."col"."protocol_protocol_id_seq" OWNED BY "eabxcol"."col"."protocol"."protocol_id";

DROP TABLE "eabxcol"."col"."sample_attribute";

CREATE TABLE "eabxcol"."col"."sample_metadata" (
                "sample_id" INTEGER NOT NULL,
                "data" varchar NOT NULL,
                CONSTRAINT "sample_metadata_pk" PRIMARY KEY ("sample_id")
);
COMMENT ON COLUMN "eabxcol"."col"."sample_metadata"."data" IS 'Champ JSONB pour stockage des données spécifiques de l''échantillon';


ALTER TABLE "eabxcol"."col"."sample_type" ADD COLUMN "container_type_id" INTEGER;

ALTER TABLE "eabxcol"."col"."sample_type" ADD COLUMN "metadata_set_id_second" INTEGER;

ALTER TABLE "eabxcol"."col"."sample_type" ADD COLUMN "operation_id" INTEGER;



ALTER TABLE "eabxcol"."col"."sample_type" ADD CONSTRAINT "container_type_sample_type_fk"
FOREIGN KEY ("container_type_id")
REFERENCES "eabxcol"."col"."container_type" ("container_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "eabxcol"."col"."sample_type" ADD CONSTRAINT "metadata_set_sample_type_fk1"
FOREIGN KEY ("metadata_set_id_second")
REFERENCES "eabxcol"."col"."metadata_set" ("metadata_set_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "eabxcol"."col"."object" ADD CONSTRAINT "object_status_object_fk"
FOREIGN KEY ("object_status_id")
REFERENCES "eabxcol"."col"."object_status" ("object_status_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "eabxcol"."col"."sample_type" ADD CONSTRAINT "operation_sample_type_fk"
FOREIGN KEY ("operation_id")
REFERENCES "eabxcol"."col"."operation" ("operation_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "eabxcol"."col"."operation" ADD CONSTRAINT "protocol_operation_fk"
FOREIGN KEY ("protocol_id")
REFERENCES "eabxcol"."col"."protocol" ("protocol_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "eabxcol"."col"."sample_metadata" ADD CONSTRAINT "sample_sample_metadata_fk"
FOREIGN KEY ("sample_id")
REFERENCES "eabxcol"."col"."sample" ("sample_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
