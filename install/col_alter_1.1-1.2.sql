set search_path = col;

CREATE TABLE "dbparam" (
                "dbparam_id" INTEGER NOT NULL,
                "dbparam_name" VARCHAR NOT NULL,
                "dbparam_value" VARCHAR,
                CONSTRAINT "dbparam_pk" PRIMARY KEY ("dbparam_id")
);
COMMENT ON TABLE "dbparam" IS 'Table des parametres associes de maniere intrinseque a l''instance';
COMMENT ON COLUMN "dbparam"."dbparam_name" IS 'Nom du parametre';
COMMENT ON COLUMN "dbparam"."dbparam_value" IS 'Valeur du paramètre';

insert into dbparam(dbparam_id, dbparam_name) values (1, 'APPLI_code');

ALTER TABLE "identifier_type" ADD COLUMN "used_for_search" BOOLEAN DEFAULT 'f' NOT NULL;
comment on column identifier_type.used_for_search is 'Indique si l''identifiant doit être utilise pour les recherches a partir des codes-barres';

ALTER TABLE "label" ADD COLUMN "identifier_only" BOOLEAN DEFAULT 'f' NOT NULL;
comment on column label.identifier_only is 'true : le qrcode ne contient qu''un identifiant metier';

update metadata set metadata_schema = replace(metadata_schema::varchar, '"nom":', '"name":')::json ;
update metadata set metadata_schema = replace(metadata_schema::varchar, '"require":', '"required":')::json ;
update metadata set metadata_schema = replace(metadata_schema::varchar, '"meusureUnit":', '"measureUnit":')::json ;

/*
 * Fin d'execution du script
 * Mise a jour de dbversion
 */
insert into dbversion ("dbversion_number", "dbversion_date")
values 
('1.2','2017-10-20');
