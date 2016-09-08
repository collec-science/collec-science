
ALTER TABLE "eabxcol"."col"."container_type" ADD COLUMN "label_id" INTEGER;

CREATE SEQUENCE "eabxcol"."col"."label_label_id_seq";

CREATE TABLE "eabxcol"."col"."label" (
                "label_id" INTEGER NOT NULL DEFAULT nextval('"eabxcol"."col"."label_label_id_seq"'),
                "label_name" VARCHAR NOT NULL,
                "label_xsl" VARCHAR NOT NULL,
                CONSTRAINT "label_pk" PRIMARY KEY ("label_id")
);
COMMENT ON TABLE "eabxcol"."col"."label" IS 'Table des modèles d''étiquettes';
COMMENT ON COLUMN "eabxcol"."col"."label"."label_name" IS 'Nom du modèle';
COMMENT ON COLUMN "eabxcol"."col"."label"."label_xsl" IS 'Contenu du fichier XSL utilisé pour la transformation FOP (https://xmlgraphics.apache.org/fop/)';


ALTER SEQUENCE "eabxcol"."col"."label_label_id_seq" OWNED BY "eabxcol"."col"."label"."label_id";


ALTER TABLE "eabxcol"."col"."container_type" ADD CONSTRAINT "label_container_type_fk"
FOREIGN KEY ("label_id")
REFERENCES "eabxcol"."col"."label" ("label_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

