
SET check_function_bodies = false;
-- ddl-end --

SET search_path=public,pg_catalog,col,gacl;
-- ddl-end --

-- ** [ Created objects ]

-- object: history | type: COLUMN --
ALTER TABLE col.sample ADD COLUMN history json;
-- ddl-end --

COMMENT ON COLUMN col.sample.history IS E'History of the sample when it''s imported from another database\ndborigin: code of the database of origin\ntype: event/parent\ndate: date of event (yyyy-mm-dd)\nname: name of the event / identifier of the parent\ncomment: comment of the event';
-- ddl-end --


-- object: operation_id | type: COLUMN --
ALTER TABLE col.sample ADD COLUMN operation_id integer;
-- ddl-end --

UPDATE col.sample s 
set operation_id = st.operation_id
FROM col.sample_type st
WHERE s.sample_type_id = st.sample_type_id
and st.operation_id is not null;

-- object: sample_operation_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.sample_operation_id_idx CASCADE;
CREATE INDEX sample_operation_id_idx ON col.sample
USING btree
(
	operation_id
);
-- ddl-end --

-- ** [ Dropped objects ]

ALTER TABLE col.sample_type DROP CONSTRAINT IF EXISTS operation_sample_type_fk CASCADE;
-- ddl-end --
ALTER TABLE col.sample_type DROP COLUMN IF EXISTS operation_id CASCADE;
-- ddl-end --


-- ** [ Created foreign keys ]

-- object: operation_fk | type: CONSTRAINT --
-- ALTER TABLE col.sample DROP CONSTRAINT IF EXISTS operation_fk CASCADE;
ALTER TABLE col.sample ADD CONSTRAINT operation_fk FOREIGN KEY (operation_id)
REFERENCES col.operation (operation_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

ALTER TABLE col.operation add column operation_code varchar;
COMMENT ON COLUMN col.operation.operation_code IS E'Code of operation, for importations';
ALTER TABLE col.operation add constraint operation_code_unique UNIQUE (operation_code);

insert into col.dbversion(dbversion_number, dbversion_date) values ('26.2', '2026-06-11');
