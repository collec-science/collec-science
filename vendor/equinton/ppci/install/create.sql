create schema app;

CREATE SEQUENCE app.dbversion_dbversion_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 7
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
CREATE TABLE app.dbversion (
	dbversion_id integer NOT NULL DEFAULT nextval('app.dbversion_dbversion_id_seq'::regclass),
	dbversion_number character varying NOT NULL,
	dbversion_date timestamp NOT NULL,
	CONSTRAINT dbversion_pk PRIMARY KEY (dbversion_id)
);

COMMENT ON TABLE app.dbversion IS E'Table of the database versions';

COMMENT ON COLUMN app.dbversion.dbversion_number IS E'Number of the version';

COMMENT ON COLUMN app.dbversion.dbversion_date IS E'Date of the version';


INSERT INTO app.dbversion (dbversion_number, dbversion_date) VALUES (E'24.0', E'2024-01-01');


CREATE TABLE app.dbparam (
	dbparam_id serial NOT NULL,
	dbparam_name character varying NOT NULL,
	dbparam_value character varying,
	dbparam_description varchar,
	dbparam_description_en varchar,
	CONSTRAINT dbparam_pk PRIMARY KEY (dbparam_id)
);

COMMENT ON TABLE app.dbparam IS E'Table of parameters intrinsically associated to the instance';

COMMENT ON COLUMN app.dbparam.dbparam_name IS E'Name of the parameter';

COMMENT ON COLUMN app.dbparam.dbparam_value IS E'Value of the parameter';

COMMENT ON COLUMN app.dbparam.dbparam_description IS E'Description of the parameter';

COMMENT ON COLUMN app.dbparam.dbparam_description_en IS E'Description of the parameter, in English';


INSERT INTO app.dbparam (dbparam_name, dbparam_value, dbparam_description, dbparam_description_en) VALUES (E'APPLI_code', E'app-code', E'Code de l''instance.', E'Instance code.');

INSERT INTO app.dbparam (dbparam_name, dbparam_value, dbparam_description, dbparam_description_en) VALUES (E'APPLI_title', E'Title app ', E'Nom de l''instance, affiché dans l''interface', E'Instance name, displayed in the interface');

INSERT INTO app.dbparam (dbparam_name, dbparam_value, dbparam_description, dbparam_description_en) VALUES (E'mapDefaultX', E'-0.7', E'Longitude de positionnement par défaut des cartes', E'Default positioning longitude for maps');

INSERT INTO app.dbparam (dbparam_name, dbparam_value, dbparam_description, dbparam_description_en) VALUES (E'mapDefaultY', E'44.77', E'Latitude de positionnement par défaut des cartes', E'Default positioning latitude for maps');

INSERT INTO app.dbparam (dbparam_name, dbparam_value, dbparam_description, dbparam_description_en) VALUES (E'mapDefaultZoom', E'7', E'Niveau de zoom par défaut dans les cartes', E'Default zoom level in maps');

INSERT INTO app.dbparam (dbparam_name, dbparam_value, dbparam_description, dbparam_description_en) VALUES (E'otp_issuer', E'app', E'Nom affiché dans les applications de génération de codes uniques pour l''identification à double facteur', E'Name displayed in applications generating unique codes for two-factor identification');


CREATE SCHEMA gacl;
CREATE SEQUENCE gacl.aclgroup_aclgroup_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 7
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
	
	CREATE TABLE gacl.aclacl (
	aclaco_id integer NOT NULL,
	aclgroup_id integer NOT NULL,
	CONSTRAINT aclacl_pk PRIMARY KEY (aclaco_id,aclgroup_id)
);

COMMENT ON TABLE gacl.aclacl IS E'Table of rights granted';
INSERT INTO gacl.aclacl (aclaco_id, aclgroup_id) VALUES (E'1', E'1');

INSERT INTO gacl.aclacl (aclaco_id, aclgroup_id) VALUES (E'2', E'2');

INSERT INTO gacl.aclacl (aclaco_id, aclgroup_id) VALUES (E'3', E'3');

INSERT INTO gacl.aclacl (aclaco_id, aclgroup_id) VALUES (E'4', E'4');


CREATE SEQUENCE gacl.aclaco_aclaco_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 7
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
	CREATE TABLE gacl.aclaco (
	aclaco_id integer NOT NULL DEFAULT nextval('gacl.aclaco_aclaco_id_seq'::regclass),
	aclappli_id integer NOT NULL,
	aco character varying NOT NULL,
	CONSTRAINT aclaco_pk PRIMARY KEY (aclaco_id)
);

COMMENT ON TABLE gacl.aclaco IS E'Table of managed rights';

COMMENT ON COLUMN gacl.aclaco.aco IS E'Name of the right in the application';

INSERT INTO gacl.aclaco (aclaco_id, aclappli_id, aco) VALUES (E'1', E'1', E'admin');

INSERT INTO gacl.aclaco (aclaco_id, aclappli_id, aco) VALUES (E'2', E'1', E'consult');
INSERT INTO gacl.aclaco (aclaco_id, aclappli_id, aco) VALUES (E'3', E'1', E'manage');
INSERT INTO gacl.aclaco (aclaco_id, aclappli_id, aco) VALUES (E'4', E'1', E'param');



CREATE SEQUENCE gacl.aclappli_aclappli_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 2
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

CREATE TABLE gacl.aclappli (
	aclappli_id integer NOT NULL DEFAULT nextval('gacl.aclappli_aclappli_id_seq'::regclass),
	appli character varying NOT NULL,
	applidetail character varying,
	CONSTRAINT aclappli_pk PRIMARY KEY (aclappli_id)
);

COMMENT ON TABLE gacl.aclappli IS E'Table of managed applications';

COMMENT ON COLUMN gacl.aclappli.appli IS E'Code of the application used to manage the rights';

COMMENT ON COLUMN gacl.aclappli.applidetail IS E'Description of the application';
INSERT INTO gacl.aclappli (aclappli_id, appli, applidetail) VALUES (E'1', E'app', E'App name');
CREATE TABLE gacl.aclgroup (
	aclgroup_id integer NOT NULL DEFAULT nextval('gacl.aclgroup_aclgroup_id_seq'::regclass),
	groupe character varying NOT NULL,
	aclgroup_id_parent integer,
	CONSTRAINT aclgroup_pk PRIMARY KEY (aclgroup_id)
);

COMMENT ON TABLE gacl.aclgroup IS E'Groups of logins';

COMMENT ON COLUMN gacl.aclgroup.groupe IS E'Name of the group';

COMMENT ON COLUMN gacl.aclgroup.aclgroup_id_parent IS E'Parent group who inherits of the rights attributed to this group';

INSERT INTO gacl.aclgroup (aclgroup_id, groupe, aclgroup_id_parent) VALUES (E'1', E'admin', DEFAULT);

INSERT INTO gacl.aclgroup (aclgroup_id, groupe, aclgroup_id_parent) VALUES (E'2', E'consult', DEFAULT);

INSERT INTO gacl.aclgroup (aclgroup_id, groupe, aclgroup_id_parent) VALUES (E'3', E'manage', E'2');

INSERT INTO gacl.aclgroup (aclgroup_id, groupe, aclgroup_id_parent) VALUES (E'4', E'param', E'3');

CREATE SEQUENCE gacl.acllogin_acllogin_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 2
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
	CREATE TABLE gacl.acllogin (
	acllogin_id integer NOT NULL DEFAULT nextval('gacl.acllogin_acllogin_id_seq'::regclass),
	login character varying NOT NULL,
	logindetail character varying NOT NULL,
	totp_key varchar,
	email varchar,
	CONSTRAINT acllogin_pk PRIMARY KEY (acllogin_id)
);

COMMENT ON TABLE gacl.acllogin IS E'List of logins granted to access to the modules of the application';

COMMENT ON COLUMN gacl.acllogin.login IS E'Login. It must be the same as the table logingestion';

COMMENT ON COLUMN gacl.acllogin.logindetail IS E'Displayed name';

COMMENT ON COLUMN gacl.acllogin.totp_key IS E'TOTP secret key for the user';

INSERT INTO gacl.acllogin (acllogin_id, login, logindetail) VALUES (E'1', E'admin', E'admin');

CREATE TABLE gacl.acllogingroup (
	acllogin_id integer NOT NULL,
	aclgroup_id integer NOT NULL,
	CONSTRAINT acllogingroup_pk PRIMARY KEY (acllogin_id,aclgroup_id)
);

COMMENT ON TABLE gacl.acllogingroup IS E'List of logins in the groups';


INSERT INTO gacl.acllogingroup (acllogin_id, aclgroup_id) VALUES (E'1', E'1');

INSERT INTO gacl.acllogingroup (acllogin_id, aclgroup_id) VALUES (E'1', E'4');
CREATE SEQUENCE gacl.log_log_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
	
CREATE TABLE gacl.log (
	log_id integer NOT NULL DEFAULT nextval('gacl.log_log_id_seq'::regclass),
	login character varying(32) NOT NULL,
	nom_module character varying,
	log_date timestamp NOT NULL,
	commentaire character varying,
	ipaddress character varying,
	CONSTRAINT log_pk PRIMARY KEY (log_id)
);
COMMENT ON TABLE gacl.log IS E'List of all recorded operations (logins, calls of modules, etc.)';

COMMENT ON COLUMN gacl.log.login IS E'Code of the login who performs the operation';

COMMENT ON COLUMN gacl.log.nom_module IS E'Name of the performed module';

COMMENT ON COLUMN gacl.log.log_date IS E'Date-time of the operation';

COMMENT ON COLUMN gacl.log.commentaire IS E'Complementary data recorded';

COMMENT ON COLUMN gacl.log.ipaddress IS E'IP address of the client';

CREATE SEQUENCE gacl.seq_logingestion_id
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 999999
	START WITH 2
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
CREATE TABLE gacl.logingestion (
	id integer NOT NULL DEFAULT nextval('gacl.seq_logingestion_id'::regclass),
	login varchar NOT NULL,
	password varchar,
	nom varchar,
	prenom varchar,
	mail character varying(255),
	datemodif timestamp,
	actif smallint DEFAULT 1,
	is_clientws boolean DEFAULT false,
	tokenws character varying,
	is_expired boolean DEFAULT false,
	nbattempts smallint DEFAULT 0,
	lastattempt timestamp,
	locale varchar,
	CONSTRAINT pk_logingestion PRIMARY KEY (id)
);

COMMENT ON TABLE gacl.logingestion IS E'List of logins used to connect to the application, when the account is managed by the application itself. This table also contains the accounts authorized to use the web services.';

COMMENT ON COLUMN gacl.logingestion.login IS E'Login used by the user';

COMMENT ON COLUMN gacl.logingestion.nom IS E'Name of the user';

COMMENT ON COLUMN gacl.logingestion.prenom IS E'Surname';

COMMENT ON COLUMN gacl.logingestion.mail IS E'email. Used to send password loss messages';

COMMENT ON COLUMN gacl.logingestion.datemodif IS E'Last date of change of the record';

COMMENT ON COLUMN gacl.logingestion.actif IS E'If 1, the account is active and can be logging to the application';

COMMENT ON COLUMN gacl.logingestion.is_clientws IS E'True if the login is used by a third-party application to call a web-service';

COMMENT ON COLUMN gacl.logingestion.tokenws IS E'Identification token used for the third-parties applications';

COMMENT ON COLUMN gacl.logingestion.is_expired IS E'If true, the account is expired (password older)';

COMMENT ON COLUMN gacl.logingestion.nbattempts IS E'Number of connection attempts';

COMMENT ON COLUMN gacl.logingestion.lastattempt IS E'last attempt of connection';

COMMENT ON COLUMN gacl.logingestion.locale IS E'Preferred locale for the user';


INSERT INTO gacl.logingestion (id, login, password, nom, prenom, mail, datemodif, actif, is_clientws, tokenws, is_expired) VALUES (E'1', E'admin', E'cd916028a2d8a1b901e831246dd5b9b4d3832786ddc63bbf5af4b50d9fc98f50', E'Administrator', DEFAULT, E'admin@mysociety.com', E'2017-08-24 00:00:00', E'1', E'false', DEFAULT, E'false');


CREATE SEQUENCE gacl.passwordlost_passwordlost_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
	
CREATE TABLE gacl.passwordlost (
	passwordlost_id integer NOT NULL DEFAULT nextval('gacl.passwordlost_passwordlost_id_seq'::regclass),
	id integer NOT NULL,
	token character varying NOT NULL,
	expiration timestamp NOT NULL,
	usedate timestamp,
	CONSTRAINT passwordlost_pk PRIMARY KEY (passwordlost_id)
);

COMMENT ON TABLE gacl.passwordlost IS E'Password loss tracking table';

COMMENT ON COLUMN gacl.passwordlost.id IS E'Logingestion id key';

COMMENT ON COLUMN gacl.passwordlost.token IS E'Token used to renewal';

COMMENT ON COLUMN gacl.passwordlost.expiration IS E'Expiration date-time of the token';

COMMENT ON COLUMN gacl.passwordlost.usedate IS E'Used date-time of the token';
CREATE INDEX log_date_idx ON gacl.log
USING btree
(
	log_date
)
WITH (FILLFACTOR = 90);
CREATE INDEX log_login_idx ON gacl.log
USING btree
(
	login
)
WITH (FILLFACTOR = 90);
CREATE INDEX log_commentaire_idx ON gacl.log
USING btree
(
	commentaire
)
WITH (FILLFACTOR = 90);
CREATE UNIQUE INDEX logingestion_login_idx ON gacl.logingestion
USING btree
(
	login
)
WITH (FILLFACTOR = 90);


-- object: log_ip_idx | type: INDEX --
-- DROP INDEX IF EXISTS gacl.log_ip_idx CASCADE;
CREATE INDEX log_ip_idx ON gacl.log
USING btree
(
	ipaddress
)
WITH (FILLFACTOR = 90);
CREATE INDEX log_module_idx ON gacl.log
USING btree
(
	nom_module
);
CREATE UNIQUE INDEX acllogin_login_idx ON gacl.acllogin
USING btree
(
	login
);
ALTER TABLE gacl.aclacl ADD CONSTRAINT aclaco_aclacl_fk FOREIGN KEY (aclaco_id)
REFERENCES gacl.aclaco (aclaco_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE gacl.aclacl ADD CONSTRAINT aclgroup_aclacl_fk FOREIGN KEY (aclgroup_id)
REFERENCES gacl.aclgroup (aclgroup_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE gacl.aclaco ADD CONSTRAINT aclappli_aclaco_fk FOREIGN KEY (aclappli_id)
REFERENCES gacl.aclappli (aclappli_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE gacl.aclgroup ADD CONSTRAINT aclgroup_aclgroup_fk FOREIGN KEY (aclgroup_id_parent)
REFERENCES gacl.aclgroup (aclgroup_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE gacl.acllogingroup ADD CONSTRAINT aclgroup_acllogingroup_fk FOREIGN KEY (aclgroup_id)
REFERENCES gacl.aclgroup (aclgroup_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE gacl.acllogingroup ADD CONSTRAINT acllogin_acllogingroup_fk FOREIGN KEY (acllogin_id)
REFERENCES gacl.acllogin (acllogin_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE gacl.passwordlost ADD CONSTRAINT logingestion_passwordlost_fk FOREIGN KEY (id)
REFERENCES gacl.logingestion (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
