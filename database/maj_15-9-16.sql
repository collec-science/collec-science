


CREATE SEQUENCE "eabxcol"."col"."multiple_type_multiple_type_id_seq";

CREATE TABLE "eabxcol"."col"."multiple_type" (
                "multiple_type_id" INTEGER NOT NULL DEFAULT nextval('"eabxcol"."col"."multiple_type_multiple_type_id_seq"'),
                "multiple_type_name" VARCHAR NOT NULL,
                CONSTRAINT "multiple_type_pk" PRIMARY KEY ("multiple_type_id")
);
COMMENT ON TABLE "eabxcol"."col"."multiple_type" IS 'Table des types de contenus multiples';


ALTER SEQUENCE "eabxcol"."col"."multiple_type_multiple_type_id_seq" OWNED BY "eabxcol"."col"."multiple_type"."multiple_type_id";

ALTER TABLE "eabxcol"."col"."sample" ADD COLUMN "multiple_value" DOUBLE PRECISION;


ALTER TABLE "eabxcol"."col"."sample_type" ADD COLUMN "multiple_type_id" INTEGER;

ALTER TABLE "eabxcol"."col"."sample_type" ADD COLUMN "multiple_unit" VARCHAR;

CREATE SEQUENCE "eabxcol"."col"."subsample_subsample_id_seq";

CREATE TABLE "eabxcol"."col"."subsample" (
                "subsample_id" INTEGER NOT NULL DEFAULT nextval('"eabxcol"."col"."subsample_subsample_id_seq"'),
                "sample_id" INTEGER NOT NULL,
                "subsample_date" TIMESTAMP NOT NULL,
                "movement_type_id" INTEGER NOT NULL,
                "subsample_quantity" DOUBLE PRECISION,
                "subsample_comment" VARCHAR,
                "subsample_login" VARCHAR NOT NULL,
                CONSTRAINT "subsample_pk" PRIMARY KEY ("subsample_id")
);
COMMENT ON TABLE "eabxcol"."col"."subsample" IS 'Table des prélèvements et restitutions de sous-échantillons';
COMMENT ON COLUMN "eabxcol"."col"."subsample"."subsample_date" IS 'Date/heure de l''opération';
COMMENT ON COLUMN "eabxcol"."col"."subsample"."subsample_quantity" IS 'Quantité prélevée ou restituée';
COMMENT ON COLUMN "eabxcol"."col"."subsample"."subsample_login" IS 'Login de l''utilisateur ayant réalisé l''opération';


ALTER SEQUENCE "eabxcol"."col"."subsample_subsample_id_seq" OWNED BY "eabxcol"."col"."subsample"."subsample_id";

ALTER TABLE "eabxcol"."col"."subsample" ADD CONSTRAINT "movement_type_subsample_fk"
FOREIGN KEY ("movement_type_id")
REFERENCES "eabxcol"."col"."movement_type" ("movement_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "eabxcol"."col"."sample_type" ADD CONSTRAINT "multiple_type_sample_type_fk"
FOREIGN KEY ("multiple_type_id")
REFERENCES "eabxcol"."col"."multiple_type" ("multiple_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE "eabxcol"."col"."subsample" ADD CONSTRAINT "sample_subsample_fk"
FOREIGN KEY ("sample_id")
REFERENCES "eabxcol"."col"."sample" ("sample_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
