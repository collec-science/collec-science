


CREATE SEQUENCE "eabxcol"."col"."identifier_type_identifier_type_id_seq";

CREATE TABLE "eabxcol"."col"."identifier_type" (
                "identifier_type_id" INTEGER NOT NULL DEFAULT nextval('"eabxcol"."col"."identifier_type_identifier_type_id_seq"'),
                "identifier_type_name" VARCHAR NOT NULL,
                "identifier_type_code" VARCHAR NOT NULL,
                CONSTRAINT "identifier_type_pk" PRIMARY KEY ("identifier_type_id")
);
COMMENT ON TABLE "eabxcol"."col"."identifier_type" IS 'Table des types d''identifiants';
COMMENT ON COLUMN "eabxcol"."col"."identifier_type"."identifier_type_name" IS 'Nom textuel de l''identifiant';
COMMENT ON COLUMN "eabxcol"."col"."identifier_type"."identifier_type_code" IS 'Code utilisé pour la génération des étiquettes';


ALTER SEQUENCE "eabxcol"."col"."identifier_type_identifier_type_id_seq" OWNED BY "eabxcol"."col"."identifier_type"."identifier_type_id";

ALTER TABLE "eabxcol"."col"."label" ADD COLUMN "label_fields" VARCHAR DEFAULT 'uid,id,clp,db' NOT NULL;


CREATE SEQUENCE "eabxcol"."col"."object_identifier_object_identifier_id_seq";

CREATE TABLE "eabxcol"."col"."object_identifier" (
                "object_identifier_id" INTEGER NOT NULL DEFAULT nextval('"eabxcol"."col"."object_identifier_object_identifier_id_seq"'),
                "uid" INTEGER NOT NULL,
                "identifier_type_id" INTEGER NOT NULL,
                "object_identifier_value" VARCHAR NOT NULL,
                CONSTRAINT "object_identifier_pk" PRIMARY KEY ("object_identifier_id")
);
COMMENT ON TABLE "eabxcol"."col"."object_identifier" IS 'Table des identifiants complémentaires normalisés';
COMMENT ON COLUMN "eabxcol"."col"."object_identifier"."object_identifier_value" IS 'Valeur de l''identifiant';


ALTER SEQUENCE "eabxcol"."col"."object_identifier_object_identifier_id_seq" OWNED BY "eabxcol"."col"."object_identifier"."object_identifier_id";


ALTER TABLE "eabxcol"."col"."object_identifier" ADD CONSTRAINT "identifier_type_object_identifier_fk"
FOREIGN KEY ("identifier_type_id")
REFERENCES "eabxcol"."col"."identifier_type" ("identifier_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "eabxcol"."col"."object_identifier" ADD CONSTRAINT "object_object_identifier_fk"
FOREIGN KEY ("uid")
REFERENCES "eabxcol"."col"."object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

create or replace view col.v_object_identifier as (
select uid, array_to_string(array_agg(identifier_type_code||':'||object_identifier_value order by identifier_type_code, object_identifier_value),',') as identifiers
from col.object_identifier
join col.identifier_type using (identifier_type_id)
group by uid
order by uid
);
