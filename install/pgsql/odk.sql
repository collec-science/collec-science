-- ** Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- ** pgModeler version: 1.2.3
-- ** Diff date: 2026-08-24 13:34:50
-- ** Source model: collec
-- ** Database: collab
-- ** PostgreSQL version: 18.0

-- ** [ Diff summary ]
-- ** Dropped objects: 0
-- ** Created objects: 17
-- ** Changed objects: 0

SET check_function_bodies = false;
-- ddl-end --

SET search_path=public,pg_catalog;
-- ddl-end --


-- ** [ Created objects ]

-- object: col.odk | type: TABLE --
-- DROP TABLE IF EXISTS col.odk CASCADE;
CREATE TABLE col.odk (
	odk_id serial NOT NULL,
	collection_id integer NOT NULL,
	campaign_id integer,
	odk_project varchar,
	odk_name varchar NOT NULL,
	odk_description varchar,
	odk_version varchar NOT NULL DEFAULT 1.0,
	odk_author varchar NOT NULL,
	with_subsample smallint DEFAULT 0,
	CONSTRAINT odk_pk PRIMARY KEY (odk_id)
);
-- ddl-end --
COMMENT ON TABLE col.odk IS E'List of odk projects';
-- ddl-end --
COMMENT ON COLUMN col.odk.odk_project IS E'Name of the project in the ODK platform';
-- ddl-end --
COMMENT ON COLUMN col.odk.odk_name IS E'Name of the form';
-- ddl-end --
COMMENT ON COLUMN col.odk.odk_code IS E'Code of the odk form. Used when generate identifiers to the samples';
-- ddl-end --
COMMENT ON COLUMN col.odk.odk_description IS E'Description of the form';
-- ddl-end --
COMMENT ON COLUMN col.odk.odk_version IS E'Version of the odk form';
-- ddl-end --
COMMENT ON COLUMN col.odk.odk_author IS E'Login of the author of the form';
COMMENT ON COLUMN col.odk.with_subsample IS E'if 1, it is possible to declare a sample subsample of the last sample which is not subsample';
-- ddl-end --

-- object: col.odk_referent | type: TABLE --
-- DROP TABLE IF EXISTS col.odk_referent CASCADE;
CREATE TABLE col.odk_referent (
	odk_id integer NOT NULL,
	referent_id integer NOT NULL,
	CONSTRAINT odk_referent_pk PRIMARY KEY (odk_id,referent_id)
);
-- ddl-end --
COMMENT ON TABLE col.odk_referent IS E'List of referents attached to an odk project';
-- ddl-end --

-- object: col.odk_station | type: TABLE --
-- DROP TABLE IF EXISTS col.odk_station CASCADE;
CREATE TABLE col.odk_station (
	odk_id integer NOT NULL,
	sampling_place_id integer,
	CONSTRAINT odk_station_pk PRIMARY KEY (odk_id,sampling_place_id)
);
-- ddl-end --
COMMENT ON TABLE col.odk_station IS E'List of stations attached to an odk project';
-- ddl-end --

-- object: col.odk_sampletype | type: TABLE --
-- DROP TABLE IF EXISTS col.odk_sampletype CASCADE;
CREATE TABLE col.odk_sampletype (
	odk_sampletype_id serial NOT NULL,
	odk_id integer NOT NULL,
	sample_type_id integer NOT NULL,
	sampletype_order smallint NOT NULL DEFAULT 1,
	image_number smallint NOT NULL DEFAULT -1,
	sound_number smallint NOT NULL DEFAULT -1,
	video_number smallint NOT NULL DEFAULT -1
	identifier_prefix varchar,
	CONSTRAINT odk_sampletype_pk PRIMARY KEY (odk_sampletype_id)
);
-- ddl-end --
COMMENT ON TABLE col.odk_sampletype IS E'List of types of samples usable in the odk form';
-- ddl-end --
COMMENT ON COLUMN col.odk_sampletype.parent_sampletype_id IS E'Id of the sample type parent when the current sample type is only a subsample';
-- ddl-end --
COMMENT ON COLUMN col.odk_sampletype.sampletype_order IS E'Sort order of the sample types';
-- ddl-end --
COMMENT ON COLUMN col.odk_sampletype.image_number IS E'-1: no image\n0: not defined, but possible\n1..: fixed number of images';
-- ddl-end --
COMMENT ON COLUMN col.odk_sampletype.sound_number IS E'-1: no sound record\n0: not defined, but possible\n1..: fixed number of recorded sounds';
-- ddl-end --
COMMENT ON COLUMN col.odk_sampletype.video_number IS E'-1: no video\n0: not defined, but possible\n1..: fixed number of videos';
-- ddl-end --
COMMENT ON COLUMN col.odk_sampletype.identifier_prefix IS E'Prefix used to create a new business identifier';

-- object: col.odk_line | type: TABLE --
-- DROP TABLE IF EXISTS col.odk_line CASCADE;
CREATE TABLE col.odk_line (
	odk_line_id serial NOT NULL,
	odk_id integer,
	line_order smallint NOT NULL DEFAULT 1,
	line_type varchar NOT NULL,
	line_name varchar,
	line_label varchar,
	line_default varchar,
	line_required varchar,
	line_relevant varchar,
	line_constraint varchar,
	line_constraint_message varchar,
	line_appearance varchar,
	line_calculation varchar,
	line_hint varchar,
	line_read_only varchar,
	line_choice_filter varchar,
	line_repeat_count varchar,
	line_parameters varchar,
	CONSTRAINT odk_line_pk PRIMARY KEY (odk_line_id)
);
-- ddl-end --
COMMENT ON TABLE col.odk_line IS E'Lines corresponding to the ods file';
-- ddl-end --
COMMENT ON COLUMN col.odk_line.line_type IS E'Type of information';
-- ddl-end --
COMMENT ON COLUMN col.odk_line.line_name IS E'column name';
-- ddl-end --
COMMENT ON COLUMN col.odk_line.line_label IS E'Displayed label';
-- ddl-end --
COMMENT ON COLUMN col.odk_line.line_default IS E'Default value';
-- ddl-end --
COMMENT ON COLUMN col.odk_line.line_required IS E'Specify if information is mandatory';
-- ddl-end --
COMMENT ON COLUMN col.odk_line.line_relevant IS E'condition of display of this line';
-- ddl-end --
COMMENT ON COLUMN col.odk_line.line_constraint IS E'Constraint of data entry';
-- ddl-end --
COMMENT ON COLUMN col.odk_line.line_constraint_message IS E'Message associated to the contraint';
-- ddl-end --
COMMENT ON COLUMN col.odk_line.line_appearance IS E'Apperance of the field';
-- ddl-end --
COMMENT ON COLUMN col.odk_line.line_calculation IS E'Formula of calculation';
-- ddl-end --
COMMENT ON COLUMN col.odk_line.line_hint IS E'Online help on the field';
-- ddl-end --
COMMENT ON COLUMN col.odk_line.line_read_only IS E'Specify if the field is readonly';
-- ddl-end --
COMMENT ON COLUMN col.odk_line.line_choice_filter IS E'filter on the choice';
-- ddl-end --
COMMENT ON COLUMN col.odk_line.line_repeat_count IS E'Number of loops in the same group';
-- ddl-end --
COMMENT ON COLUMN col.odk_line.line_parameters IS E'Others parameters';
-- ddl-end --

-- object: col.odk_choice | type: TABLE --
-- DROP TABLE IF EXISTS col.odk_choice CASCADE;
CREATE TABLE col.odk_choice (
	odk_choice_id serial NOT NULL,
	odk_id integer,
	list_name varchar NOT NULL,
	choice_name varchar NOT NULL,
	choice_label varchar NOT NULL,
	choice_filter varchar,
	CONSTRAINT odk_choice_pk PRIMARY KEY (odk_choice_id)
);
-- ddl-end --



-- ** [ Created foreign keys ]

-- object: collection_fk | type: CONSTRAINT --
-- ALTER TABLE col.odk DROP CONSTRAINT IF EXISTS collection_fk CASCADE;
ALTER TABLE col.odk ADD CONSTRAINT collection_fk FOREIGN KEY (collection_id)
REFERENCES col.collection (collection_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: campaign_fk | type: CONSTRAINT --
-- ALTER TABLE col.odk DROP CONSTRAINT IF EXISTS campaign_fk CASCADE;
ALTER TABLE col.odk ADD CONSTRAINT campaign_fk FOREIGN KEY (campaign_id)
REFERENCES col.campaign (campaign_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: odk_fk | type: CONSTRAINT --
-- ALTER TABLE col.odk_referent DROP CONSTRAINT IF EXISTS odk_fk CASCADE;
ALTER TABLE col.odk_referent ADD CONSTRAINT odk_fk FOREIGN KEY (odk_id)
REFERENCES col.odk (odk_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: referent_fk | type: CONSTRAINT --
-- ALTER TABLE col.odk_referent DROP CONSTRAINT IF EXISTS referent_fk CASCADE;
ALTER TABLE col.odk_referent ADD CONSTRAINT referent_fk FOREIGN KEY (referent_id)
REFERENCES col.referent (referent_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: odk_fk | type: CONSTRAINT --
-- ALTER TABLE col.odk_station DROP CONSTRAINT IF EXISTS odk_fk CASCADE;
ALTER TABLE col.odk_station ADD CONSTRAINT odk_fk FOREIGN KEY (odk_id)
REFERENCES col.odk (odk_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: sampling_place_fk | type: CONSTRAINT --
-- ALTER TABLE col.odk_station DROP CONSTRAINT IF EXISTS sampling_place_fk CASCADE;
ALTER TABLE col.odk_station ADD CONSTRAINT sampling_place_fk FOREIGN KEY (sampling_place_id)
REFERENCES col.sampling_place (sampling_place_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: odk_fk | type: CONSTRAINT --
-- ALTER TABLE col.odk_sampletype DROP CONSTRAINT IF EXISTS odk_fk CASCADE;
ALTER TABLE col.odk_sampletype ADD CONSTRAINT odk_fk FOREIGN KEY (odk_id)
REFERENCES col.odk (odk_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: sample_type_fk | type: CONSTRAINT --
-- ALTER TABLE col.odk_sampletype DROP CONSTRAINT IF EXISTS sample_type_fk CASCADE;
ALTER TABLE col.odk_sampletype ADD CONSTRAINT sample_type_fk FOREIGN KEY (sample_type_id)
REFERENCES col.sample_type (sample_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: odk_fk | type: CONSTRAINT --
-- ALTER TABLE col.odk_line DROP CONSTRAINT IF EXISTS odk_fk CASCADE;
ALTER TABLE col.odk_line ADD CONSTRAINT odk_fk FOREIGN KEY (odk_id)
REFERENCES col.odk (odk_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: odk_fk | type: CONSTRAINT --
-- ALTER TABLE col.odk_choice DROP CONSTRAINT IF EXISTS odk_fk CASCADE;
ALTER TABLE col.odk_choice ADD CONSTRAINT odk_fk FOREIGN KEY (odk_id)
REFERENCES col.odk (odk_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: rel_odk_sample_type_parent | type: CONSTRAINT --
-- ALTER TABLE col.odk_sampletype DROP CONSTRAINT IF EXISTS rel_odk_sample_type_parent CASCADE;
ALTER TABLE col.odk_sampletype ADD CONSTRAINT rel_odk_sample_type_parent FOREIGN KEY (parent_sampletype_id)
REFERENCES col.odk_sampletype (odk_sampletype_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- DROP TABLE IF EXISTS col.odk_identifier CASCADE;
CREATE TABLE col.odk_identifier (
	odk_id integer NOT NULL,
	identifier_type_id integer NOT NULL,
	CONSTRAINT odk_identifier_pk PRIMARY KEY (odk_id,identifier_type_id)
);
-- ddl-end --
COMMENT ON TABLE col.odk_identifier IS E'List of secundary identifiers used in the form';
-- ddl-end --

-- object: odk_fk | type: CONSTRAINT --
-- ALTER TABLE col.odk_identifier DROP CONSTRAINT IF EXISTS odk_fk CASCADE;
ALTER TABLE col.odk_identifier ADD CONSTRAINT odk_fk FOREIGN KEY (odk_id)
REFERENCES col.odk (odk_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: identifier_type_fk | type: CONSTRAINT --
-- ALTER TABLE col.odk_identifier DROP CONSTRAINT IF EXISTS identifier_type_fk CASCADE;
ALTER TABLE col.odk_identifier ADD CONSTRAINT identifier_type_fk FOREIGN KEY (identifier_type_id)
REFERENCES col.identifier_type (identifier_type_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --


