CREATE SEQUENCE col.sampling_place_sampling_place_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE col.sampling_place_sampling_place_id_seq OWNER TO collec;

CREATE TABLE col.sampling_place (
	sampling_place_id integer NOT NULL DEFAULT nextval('col.sampling_place_sampling_place_id_seq'::regclass),
	sampling_place_name character varying NOT NULL,
	collection_id integer,
	sampling_place_code character varying,
	sampling_place_x double precision,
	sampling_place_y double precision,
	CONSTRAINT sampling_place_pk PRIMARY KEY (sampling_place_id)

);
-- ddl-end --
COMMENT ON TABLE col.sampling_place IS E'Table of sampling places';
-- ddl-end --
COMMENT ON COLUMN col.sampling_place.sampling_place_name IS E'Name of the sampling place';
-- ddl-end --
COMMENT ON COLUMN col.sampling_place.collection_id IS E'Collection of rattachment';
-- ddl-end --
COMMENT ON COLUMN col.sampling_place.sampling_place_code IS E'Working code of the station';
-- ddl-end --
COMMENT ON COLUMN col.sampling_place.sampling_place_x IS E'Longitude of the station, in WGS84';
-- ddl-end --
COMMENT ON COLUMN col.sampling_place.sampling_place_y IS E'Latitude of the station, in WGS84';
-- ddl-end --
ALTER TABLE col.sampling_place OWNER TO collec;
-- ddl-end --

-- object: collection_sampling_place_fk | type: CONSTRAINT --
-- ALTER TABLE col.sampling_place DROP CONSTRAINT IF EXISTS collection_sampling_place_fk CASCADE;
ALTER TABLE col.sampling_place ADD CONSTRAINT collection_sampling_place_fk FOREIGN KEY (collection_id)
REFERENCES col.collection (collection_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE col.sample ADD CONSTRAINT sampling_place_sample_fk FOREIGN KEY (sampling_place_id)
REFERENCES col.sampling_place (sampling_place_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
