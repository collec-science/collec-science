CREATE UNIQUE INDEX referent_referent_name_firstname_idx ON col.referent USING btree (referent_name,referent_firstname);
drop index col.referent_referent_name_idx;
alter table col.container add column collection_id int;
ALTER TABLE col.container ADD CONSTRAINT collection_fk FOREIGN KEY (collection_id)
REFERENCES col.collection (collection_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
CREATE INDEX container_collection_id_idx ON col.container
USING btree(collection_id);

CREATE TABLE col.translation (
	translation_id serial NOT NULL,
	translation_country varchar NOT NULL,
	initial_label varchar NOT NULL,
	country_label varchar,
	CONSTRAINT translation_pk PRIMARY KEY (translation_id)
);
-- ddl-end --
COMMENT ON TABLE col.translation IS E'Table of translations from English to other languages';
-- ddl-end --
COMMENT ON COLUMN col.translation.translation_country IS E'Country code on 2 positions (fr, en), in lowercase';
-- ddl-end --
COMMENT ON COLUMN col.translation.initial_label IS E'Initial label to translate';
-- ddl-end --
COMMENT ON COLUMN col.translation.country_label IS E'Label translated';
-- ddl-end --
ALTER TABLE col.translation OWNER TO collec;
-- ddl-end --

-- object: initial_label_code_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.initial_label_code_idx CASCADE;
CREATE UNIQUE INDEX initial_label_code_idx ON col.translation
USING btree
(
	translation_country,
	initial_label
);

-- object: col.translate | type: FUNCTION --
-- DROP FUNCTION IF EXISTS col.translate(varchar,varchar) CASCADE;
CREATE FUNCTION col.translate (IN initial_label varchar, IN country_code varchar)
	RETURNS varchar
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	PARALLEL UNSAFE
	COST 1
	AS $$
declare translated text := '';
begin
	select country_label into translated from translation 
	where country_code = $2
	and initial_label = $1;
	return coalesce (translated, initial_label);
end
$$;
-- ddl-end --
ALTER FUNCTION col.translate(varchar,varchar) OWNER TO collec;
-- ddl-end --
COMMENT ON FUNCTION col.translate(varchar,varchar) IS E'Translation of contents of tables of parameters';
-- ddl-end --

