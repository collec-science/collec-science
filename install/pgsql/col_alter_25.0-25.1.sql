set search_path = col,gacl,public;
update col.metadata
set metadata_schema = regexp_replace(metadata_schema::varchar, 'N/A', '','ig')::json;
update col.metadata
set metadata_schema = regexp_replace(metadata_schema::varchar, 'N\\/A', '','ig')::json;
/*
 * create the label_optical content from label 
 */
 CREATE TABLE col.label_optical (
	label_optical_id serial NOT NULL,
	label_id integer NOT NULL,
	barcode_id integer NOT NULL,
	content_type smallint NOT NULL DEFAULT 1,
	radical varchar,
	optical_content varchar NOT NULL,
	CONSTRAINT label_optical_pk PRIMARY KEY (label_optical_id)
);
COMMENT ON COLUMN col.label_optical.content_type IS E'1: json\n2: identifier\n3: radical and identifier, as uri';
COMMENT ON COLUMN col.label_optical.radical IS E'Radical in the optical code, as base of uri';
COMMENT ON COLUMN col.label_optical.optical_content IS E'Content of the optical code, as list of fields if type 1, used identifier if type 2 or 3';
ALTER TABLE col.label_optical OWNER TO collec;
ALTER TABLE col.label_optical ADD CONSTRAINT label_fk FOREIGN KEY (label_id)
REFERENCES col.label (label_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE col.label_optical ADD CONSTRAINT barcode_fk FOREIGN KEY (barcode_id)
REFERENCES col.barcode (barcode_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
insert into col.label_optical (label_id, barcode_id, content_type, optical_content)
select label_id, 
barcode_id, 
case when identifier_only is true then 2 else 1 end,
label_fields
from col.label
order by label_id;
ALTER TABLE col.label DROP CONSTRAINT IF EXISTS barcode_fk CASCADE;
alter table col.label drop column barcode_id;
alter table col.label drop column identifier_only;
alter table col.label drop column label_fields;
