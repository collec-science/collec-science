/*
 * Script de modification base collec version 1.0.4 -> 1.0.5
 * a executer dans tous les schemas contenant des donnees
 * adapter la commande set search_path au schema concerne
 */

set search_path=col;

CREATE SEQUENCE "sampling_place_sampling_place_id_seq";

CREATE TABLE "sampling_place" (
                "sampling_place_id" INTEGER NOT NULL DEFAULT nextval('"sampling_place_sampling_place_id_seq"'),
                "sampling_place_name" VARCHAR NOT NULL,
                CONSTRAINT "sampling_place_pk" PRIMARY KEY ("sampling_place_id")
);
COMMENT ON TABLE "sampling_place" IS 'Table des lieux génériques d''échantillonnage';


ALTER SEQUENCE "sampling_place_sampling_place_id_seq" OWNED BY "sampling_place"."sampling_place_id";

alter table "sample" add column "sampling_place_id" integer;

ALTER TABLE "sample" ADD CONSTRAINT "sampling_place_sample_fk"
FOREIGN KEY ("sampling_place_id")
REFERENCES "sampling_place" ("sampling_place_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
