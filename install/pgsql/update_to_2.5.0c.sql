-- [ Created objects ] --
-- object: col.license | type: TABLE --
-- DROP TABLE IF EXISTS col.license CASCADE;
CREATE TABLE col.license (
	license_id serial NOT NULL,
	license_name varchar NOT NULL,
	license_url varchar,
	CONSTRAINT license_pk PRIMARY KEY (license_id)

);
-- ddl-end --
COMMENT ON TABLE col.license IS E'List of licenses usable to communicate informations on the collections';
-- ddl-end --
COMMENT ON COLUMN col.license.license_name IS E'Name of the license';
-- ddl-end --
COMMENT ON COLUMN col.license.license_url IS E'Link of download of the text of the license';
-- ddl-end --
ALTER TABLE col.license OWNER TO collec;
-- ddl-end --

INSERT INTO col.license (license_name, license_url) VALUES (E'CC0', E'https://creativecommons.org/publicdomain/zero/1.0/');
-- ddl-end --
INSERT INTO col.license (license_name, license_url) VALUES (E'CCBY', E'https://creativecommons.org/licenses/by/4.0/');
-- ddl-end --

-- object: license_id | type: COLUMN --
-- ALTER TABLE col.collection DROP COLUMN IF EXISTS license_id CASCADE;
ALTER TABLE col.collection ADD COLUMN license_id integer;
-- ddl-end --

-- [ Created foreign keys ] --
-- object: license_fk | type: CONSTRAINT --
-- ALTER TABLE col.collection DROP CONSTRAINT IF EXISTS license_fk CASCADE;
ALTER TABLE col.collection ADD CONSTRAINT license_fk FOREIGN KEY (license_id)
REFERENCES col.license (license_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

update col.dataset_type set fields = E'["collection_name","collection_displayname","collection_keywords","referent_name","referent_firstname","academical_directory","academical_link","referent_email","address_name","address_line2","address_line3","address_city","address_country","referent_phone","license_name","license_url","fixed_value"]'
where dataset_type_id = 2;