
set search_path=col;

CREATE TABLE "metadata_form" (
    metadata_form_id serial NOT NULL, 
    metadata_schema json not null, 
    CONSTRAINT metadata_form_pk PRIMARY KEY (metadata_form_id)
    );
COMMENT ON TABLE "metadata_form" IS 'Table des schémas des formulaires de métadonnées';
COMMENT ON COLUMN "metadata_form"."metadata_schema" IS 'Schéma en JSON du formulaire des métadonnées ';

DROP TABLE sample_metadata;

CREATE TABLE "sample_metadata"(
    sample_metadata_id serial NOT NULL, 
    data json not null, 
    CONSTRAINT sample_metadata_pk PRIMARY KEY (sample_metadata_id)
    );
COMMENT ON TABLE "sample_metadata" IS 'Table des métadonnées';
COMMENT ON COLUMN "sample_metadata"."data" IS 'Métadonnées en JSON';


ALTER TABLE "operation" 
ADD COLUMN metadata_form_id integer, 
ADD COLUMN operation_version varchar,
ADD COLUMN last_edit_date timestamp,
ADD CONSTRAINT metadata_form_fk 
FOREIGN KEY ("metadata_form_id")
REFERENCES "metadata_form" ("metadata_form_id") MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION,
ADD CONSTRAINT operation_name_version_unique UNIQUE (operation_name,operation_version);
COMMENT ON COLUMN "operation"."operation_version" IS 'Version de l''opération';
COMMENT ON COLUMN "operation"."last_edit_date" IS 'Date de dernière éditione l''opératon';

ALTER TABLE "sample" ADD COLUMN sample_metadata_id integer, 
ADD CONSTRAINT sample_metadata_fk 
FOREIGN KEY ("sample_metadata_id")
REFERENCES "sample_metadata" ("sample_metadata_id") MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "sample_type" DROP COLUMN metadata_set_id;
ALTER TABLE "sample_type" DROP COLUMN metadata_set_id_second;

DROP TABLE "metadata_attribute";
DROP TABLE "metadata_schema";
DROP TABLE "metadata_set";

ALTER TABLE label ADD COLUMN operation_id integer,
ADD constraint label_operation_fk foreign key (operation_id)
REFERENCES operation (operation_id) match simple
ON update no action ON delete no action;
