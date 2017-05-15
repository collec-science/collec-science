
set search_path=col;

CREATE TABLE "metadata_form" (
    metadata_form_id serial NOT NULL, 
    schema json, 
    CONSTRAINT metadata_form_pk PRIMARY KEY (metadata_form_id)
    );

DROP TABLE sample_metadata;

CREATE TABLE "sample_metadata"(
    sample_metadata_id serial NOT NULL, 
    data json, 
    CONSTRAINT sample_metadata_pk PRIMARY KEY (sample_metadata_id)
    );

ALTER TABLE "operation" ADD COLUMN metadata_form_id integer, 
ADD CONSTRAINT metadata_form_fk 
FOREIGN KEY ("metadata_form_id")
REFERENCES "metadata_form" ("metadata_form_id") MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION;

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