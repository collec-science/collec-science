
CREATE SEQUENCE "eabxcol"."col"."container_family_container_family_id_seq";

CREATE TABLE "eabxcol"."col"."container_family" (
                "container_family_id" INTEGER NOT NULL DEFAULT nextval('"eabxcol"."col"."container_family_container_family_id_seq"'),
                "container_family_name" VARCHAR NOT NULL,
                "is_movable" BOOLEAN DEFAULT true NOT NULL,
                CONSTRAINT "container_family_pk" PRIMARY KEY ("container_family_id")
);
COMMENT ON TABLE "eabxcol"."col"."container_family" IS 'Famille générique des conteneurs';
COMMENT ON COLUMN "eabxcol"."col"."container_family"."is_movable" IS 'Indique si la famille de conteneurs est déplçable facilement ou non (éprouvette : oui, armoire : non)';


ALTER SEQUENCE "eabxcol"."col"."container_family_container_family_id_seq" OWNED BY "eabxcol"."col"."container_family"."container_family_id";

ALTER TABLE "eabxcol"."col"."container_type" ADD COLUMN "container_family_id" INTEGER NOT NULL;


ALTER TABLE "eabxcol"."col"."container_type" ADD CONSTRAINT "container_family_container_type_fk"
FOREIGN KEY ("container_family_id")
REFERENCES "eabxcol"."col"."container_family" ("container_family_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "eabxcol"."col"."container_type" ADD COLUMN "clp_classification" VARCHAR;

ALTER TABLE "eabxcol"."col"."container_type" ADD COLUMN "container_type_description" VARCHAR;

CREATE SEQUENCE "eabxcol"."col"."storage_condition_storage_condition_id_seq";

CREATE TABLE "eabxcol"."col"."storage_condition" (
                "storage_condition_id" INTEGER NOT NULL DEFAULT nextval('"eabxcol"."col"."storage_condition_storage_condition_id_seq"'),
                "storage_condition_name" VARCHAR NOT NULL,
                CONSTRAINT "storage_condition_pk" PRIMARY KEY ("storage_condition_id")
);
COMMENT ON TABLE "eabxcol"."col"."storage_condition" IS 'Condition de stockage';


ALTER SEQUENCE "eabxcol"."col"."storage_condition_storage_condition_id_seq" OWNED BY "eabxcol"."col"."storage_condition"."storage_condition_id";

ALTER TABLE "eabxcol"."col"."container_type" ADD CONSTRAINT "storage_condition_container_type_fk"
FOREIGN KEY ("storage_condition_id")
REFERENCES "eabxcol"."col"."storage_condition" ("storage_condition_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "eabxcol"."col"."container_type" ADD COLUMN "storage_condition_id" INTEGER;

ALTER TABLE "eabxcol"."col"."container_type" ADD COLUMN "storage_product" VARCHAR;

ALTER TABLE "eabxcol"."col"."container_type" ADD CONSTRAINT "storage_condition_container_type_fk"
FOREIGN KEY ("storage_condition_id")
REFERENCES "eabxcol"."col"."storage_condition" ("storage_condition_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
