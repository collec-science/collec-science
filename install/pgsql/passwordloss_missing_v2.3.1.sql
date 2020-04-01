CREATE SEQUENCE gacl.passwordlost_passwordlost_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE gacl.passwordlost_passwordlost_id_seq OWNER TO collec;

CREATE TABLE gacl.passwordlost (
	passwordlost_id integer NOT NULL DEFAULT nextval('gacl.passwordlost_passwordlost_id_seq'::regclass),
	id integer NOT NULL,
	token character varying NOT NULL,
	expiration timestamp NOT NULL,
	usedate timestamp,
	CONSTRAINT passwordlost_pk PRIMARY KEY (passwordlost_id)

);
-- ddl-end --
COMMENT ON TABLE gacl.passwordlost IS E'Password loss tracking table';
-- ddl-end --
COMMENT ON COLUMN gacl.passwordlost.id IS E'Logingestion id key';
-- ddl-end --
COMMENT ON COLUMN gacl.passwordlost.token IS E'Token used to renewal';
-- ddl-end --
COMMENT ON COLUMN gacl.passwordlost.expiration IS E'Expiration date-time of the token';
-- ddl-end --
COMMENT ON COLUMN gacl.passwordlost.usedate IS E'Used date-time of the token';
-- ddl-end --
ALTER TABLE gacl.passwordlost OWNER TO collec;
-- ddl-end --

-- object: logingestion_passwordlost_fk | type: CONSTRAINT --
-- ALTER TABLE gacl.passwordlost DROP CONSTRAINT IF EXISTS logingestion_passwordlost_fk CASCADE;
ALTER TABLE gacl.passwordlost ADD CONSTRAINT logingestion_passwordlost_fk FOREIGN KEY (id)
REFERENCES gacl.logingestion (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
