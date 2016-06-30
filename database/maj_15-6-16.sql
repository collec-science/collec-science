


ALTER TABLE "eabxcol"."col"."container" ADD COLUMN "container_status_id" INTEGER DEFAULT 1;

CREATE SEQUENCE "eabxcol"."col"."container_status_container_status_id_seq";

CREATE TABLE "eabxcol"."col"."container_status" (
                "container_status_id" INTEGER NOT NULL DEFAULT nextval('"eabxcol"."col"."container_status_container_status_id_seq"'),
                "container_status_name" VARCHAR NOT NULL,
                CONSTRAINT "container_status_pk" PRIMARY KEY ("container_status_id")
);
COMMENT ON TABLE "eabxcol"."col"."container_status" IS 'État des conteneurs (utilisé, préparé, en stock, détruit ou réformé...)';


ALTER SEQUENCE "eabxcol"."col"."container_status_container_status_id_seq" OWNED BY "eabxcol"."col"."container_status"."container_status_id";

COMMENT ON COLUMN "eabxcol"."col"."container_type"."clp_classification" IS 'Classification du risque conformément à la directive européenne CLP';

COMMENT ON COLUMN "eabxcol"."col"."container_type"."container_type_description" IS 'Description longue';

COMMENT ON COLUMN "eabxcol"."col"."container_type"."storage_product" IS 'Produit utilisé pour le stockage (formol, alcool...)';




ALTER TABLE "eabxcol"."col"."container" ADD CONSTRAINT "container_status_container_fk"
FOREIGN KEY ("container_status_id")
REFERENCES "eabxcol"."col"."container_status" ("container_status_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

create sequence "eabxcol"."col"."event_event_id_seq" owned by "eabxcol"."col"."event"."event_id";
alter table "eabxcol"."col"."event" alter column event_id set default nextval( '"eabxcol"."col"."event_event_id_seq"');

alter table col.projet_group rename to project_group;
