/**
 * Script of change of the schema gacl
 */

alter table gacl.logingestion add column nbattempts smallint DEFAULT 0,
	add column lastattempt timestamp;
COMMENT ON COLUMN gacl.logingestion.nbattempts IS E'Number of connection attemps';
-- ddl-end --
COMMENT ON COLUMN gacl.logingestion.lastattempt IS E'last attemp of connection';
-- ddl-end --
