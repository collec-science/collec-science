set search_path = col, public;

CREATE SEQUENCE "eabxcol"."col"."document_document_id_seq";

CREATE TABLE "eabxcol"."col"."document" (
                "document_id" INTEGER NOT NULL DEFAULT nextval('"eabxcol"."col"."document_document_id_seq"'),
                "uid" INTEGER NOT NULL,
                "mime_type_id" INTEGER NOT NULL,
                "document_import_date" TIMESTAMP NOT NULL,
                "document_name" VARCHAR NOT NULL,
                "document_description" VARCHAR,
                "data" BYTEA,
                "thumbnail" BYTEA,
                "size" INTEGER,
                "document_creation_date" TIMESTAMP,
                CONSTRAINT "document_pk" PRIMARY KEY ("document_id")
);
COMMENT ON TABLE "eabxcol"."col"."document" IS 'Documents numériques rattachés à un poisson ou à un événement';
COMMENT ON COLUMN "eabxcol"."col"."document"."document_import_date" IS 'Date d''import dans la base de données';
COMMENT ON COLUMN "eabxcol"."col"."document"."document_name" IS 'Nom d''origine du document';
COMMENT ON COLUMN "eabxcol"."col"."document"."document_description" IS 'Description libre du document';
COMMENT ON COLUMN "eabxcol"."col"."document"."data" IS 'Contenu du document';
COMMENT ON COLUMN "eabxcol"."col"."document"."thumbnail" IS 'Vignette au format PNG (documents pdf, jpg ou png)';
COMMENT ON COLUMN "eabxcol"."col"."document"."size" IS 'Taille du fichier téléchargé';
COMMENT ON COLUMN "eabxcol"."col"."document"."document_creation_date" IS 'Date de création du document (date de prise de vue de la photo)';


ALTER SEQUENCE "eabxcol"."col"."document_document_id_seq" OWNED BY "eabxcol"."col"."document"."document_id";


CREATE SEQUENCE "eabxcol"."col"."mime_type_mime_type_id_seq";

CREATE TABLE "eabxcol"."col"."mime_type" (
                "mime_type_id" INTEGER NOT NULL DEFAULT nextval('"eabxcol"."col"."mime_type_mime_type_id_seq"'),
                "extension" VARCHAR NOT NULL,
                "content_type" VARCHAR NOT NULL,
                CONSTRAINT "mime_type_pk" PRIMARY KEY ("mime_type_id")
);
COMMENT ON TABLE "eabxcol"."col"."mime_type" IS 'Types mime des fichiers importés';
COMMENT ON COLUMN "eabxcol"."col"."mime_type"."extension" IS 'Extension du fichier correspondant';
COMMENT ON COLUMN "eabxcol"."col"."mime_type"."content_type" IS 'type mime officiel';


ALTER SEQUENCE "eabxcol"."col"."mime_type_mime_type_id_seq" OWNED BY "eabxcol"."col"."mime_type"."mime_type_id";


ALTER TABLE "eabxcol"."col"."document" ADD CONSTRAINT "mime_type_document_fk"
FOREIGN KEY ("mime_type_id")
REFERENCES "eabxcol"."col"."mime_type" ("mime_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "eabxcol"."col"."document" ADD CONSTRAINT "object_document_fk"
FOREIGN KEY ("uid")
REFERENCES "eabxcol"."col"."object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  1,  'application/pdf',  'pdf');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  2,  'application/zip',  'zip');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  3,  'audio/mpeg',  'mp3');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  4,  'image/jpeg',  'jpg');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES(  5,  'image/jpeg',  'jpeg');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  6,  'image/png',  'png');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  7,  'image/tiff',  'tiff');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  9,  'application/vnd.oasis.opendocument.text',  'odt');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  10,  'application/vnd.oasis.opendocument.spreadsheet',  'ods');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  11,  'application/vnd.ms-excel',  'xls');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  12,  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',  'xlsx');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  13,  'application/msword',  'doc');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  14,  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',  'docx');
 
 INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  8,  'text/csv',  'csv');
 
create or replace view col.last_photo as (
select document_id, uid
from col.document
where mime_type_id in (4,5,6)
order by document_creation_date desc, document_import_date desc, document_id desc
limit 1);
