alter table col.dataset_template add column xslcontent varchar ;
COMMENT ON COLUMN col.dataset_template.xslcontent IS E'Transformation of the generated xml to create a specific xml file';

-- object: collection_keywords | type: COLUMN --
-- ALTER TABLE col.collection DROP COLUMN IF EXISTS collection_keywords CASCADE;
ALTER TABLE col.collection ADD COLUMN collection_keywords varchar;
-- ddl-end --

COMMENT ON COLUMN col.collection.collection_keywords IS E'List of keywords, separed by a comma';
-- ddl-end --


-- object: collection_displayname | type: COLUMN --
-- ALTER TABLE col.collection DROP COLUMN IF EXISTS collection_displayname CASCADE;
ALTER TABLE col.collection ADD COLUMN collection_displayname varchar;
-- ddl-end --

COMMENT ON COLUMN col.collection.collection_displayname IS E'Name used to communicate from the collection, in export module by example';
-- ddl-end --


-- object: referent_firstname | type: COLUMN --
-- ALTER TABLE col.referent DROP COLUMN IF EXISTS referent_firstname CASCADE;
ALTER TABLE col.referent ADD COLUMN referent_firstname varchar;
-- ddl-end --

COMMENT ON COLUMN col.referent.referent_firstname IS E'Firstname of the referent';
-- ddl-end --


-- object: academical_directory | type: COLUMN --
-- ALTER TABLE col.referent DROP COLUMN IF EXISTS academical_directory CASCADE;
ALTER TABLE col.referent ADD COLUMN academical_directory varchar;
-- ddl-end --

COMMENT ON COLUMN col.referent.academical_directory IS E'Academical directory used to identifier the referent, as https://orcid.org or https://www.researchgate.net';
-- ddl-end --


-- object: academical_link | type: COLUMN --
-- ALTER TABLE col.referent DROP COLUMN IF EXISTS academical_link CASCADE;
ALTER TABLE col.referent ADD COLUMN academical_link varchar;
-- ddl-end --

COMMENT ON COLUMN col.referent.academical_link IS E'Link used to identify the referent, as https://orcid.org/0000-0003-4207-4107';
-- ddl-end --

update col.dataset_type set fields =  E'["uid","uuid","identifier","wgs84_x","wgs84_y","location_accuracy","object_status_name","referent_name","referent_email","address_name","address_line2","address_line3","address_city","address_country","referent_phone","referent_firstname","academic_directory","academic_link","object_comment","identifiers","sample_creation_date","sampling_date","multiple_value","sampling_place_name","expiration_date","sample_type_name","storage_product","clp_classification","multiple_type_name","collection_name","metadata","parent_uid","parent_uuid","parent_identifiers","web_address","content_type","container_uid","container_identifier","container_uuid","storage_type_name","fixed_value"]'
where dataset_type_id = 1;
update col.dataset_type set fields = E'["collection_name","collection_displayname","collection_keywords","referent_name","referent_firstname","academical_directory","academical_link","referent_email","address_name","address_line2","address_line3","address_city","address_country","referent_phone","fixed_value"]'
where dataset_type_id = 2;

CREATE TABLE col.samplesearch (
	samplesearch_id serial NOT NULL,
	samplesearch_name varchar NOT NULL,
	samplesearch_data json,
	samplesearch_login varchar,
	collection_id integer
);
-- ddl-end --
COMMENT ON TABLE col.samplesearch IS E'List of sample saved search';
-- ddl-end --
COMMENT ON COLUMN col.samplesearch.samplesearch_name IS E'Name of the search parameters';
-- ddl-end --
COMMENT ON COLUMN col.samplesearch.samplesearch_data IS E'List of all research parameters';
-- ddl-end --
COMMENT ON COLUMN col.samplesearch.samplesearch_login IS E'Login of the creator';
-- ddl-end --
ALTER TABLE col.samplesearch OWNER TO collec;
-- ddl-end --

-- object: collection_fk | type: CONSTRAINT --
-- ALTER TABLE col.samplesearch DROP CONSTRAINT IF EXISTS collection_fk CASCADE;
ALTER TABLE col.samplesearch ADD CONSTRAINT collection_fk FOREIGN KEY (collection_id)
REFERENCES col.collection (collection_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
