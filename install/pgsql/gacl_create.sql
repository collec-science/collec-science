create schema if not exists gacl;
set search_path = gacl;

-- object: aclgroup_aclgroup_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS aclgroup_aclgroup_id_seq CASCADE;
CREATE SEQUENCE aclgroup_aclgroup_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE aclgroup_aclgroup_id_seq OWNER TO postgres;
-- ddl-end --

-- object: aclacl | type: TABLE --
-- DROP TABLE IF EXISTS aclacl CASCADE;
CREATE TABLE aclacl (
	aclaco_id integer NOT NULL,
	aclgroup_id integer NOT NULL,
	CONSTRAINT aclacl_pk PRIMARY KEY (aclaco_id,aclgroup_id)

);
-- ddl-end --
COMMENT ON TABLE aclacl IS 'Table des droits attribués';
-- ddl-end --
ALTER TABLE aclacl OWNER TO postgres;
-- ddl-end --

-- object: aclaco_aclaco_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS aclaco_aclaco_id_seq CASCADE;
CREATE SEQUENCE aclaco_aclaco_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE aclaco_aclaco_id_seq OWNER TO postgres;
-- ddl-end --

-- object: aclaco | type: TABLE --
-- DROP TABLE IF EXISTS aclaco CASCADE;
CREATE TABLE aclaco (
	aclaco_id integer NOT NULL DEFAULT nextval('aclaco_aclaco_id_seq'::regclass),
	aclappli_id integer NOT NULL,
	aco character varying NOT NULL,
	CONSTRAINT aclaco_pk PRIMARY KEY (aclaco_id)

);
-- ddl-end --
COMMENT ON TABLE aclaco IS 'Table des droits gérés';
-- ddl-end --
ALTER TABLE aclaco OWNER TO postgres;
-- ddl-end --

-- object: aclappli_aclappli_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS aclappli_aclappli_id_seq CASCADE;
CREATE SEQUENCE aclappli_aclappli_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE aclappli_aclappli_id_seq OWNER TO postgres;
-- ddl-end --

-- object: aclappli | type: TABLE --
-- DROP TABLE IF EXISTS aclappli CASCADE;
CREATE TABLE aclappli (
	aclappli_id integer NOT NULL DEFAULT nextval('aclappli_aclappli_id_seq'::regclass),
	appli character varying NOT NULL,
	applidetail character varying,
	CONSTRAINT aclappli_pk PRIMARY KEY (aclappli_id)

);
-- ddl-end --
COMMENT ON TABLE aclappli IS 'Table des applications gérées';
-- ddl-end --
COMMENT ON COLUMN aclappli.appli IS 'Nom de l''application pour la gestion des droits';
-- ddl-end --
COMMENT ON COLUMN aclappli.applidetail IS 'Description de l''application';
-- ddl-end --
ALTER TABLE aclappli OWNER TO postgres;
-- ddl-end --

-- object: aclgroup | type: TABLE --
-- DROP TABLE IF EXISTS aclgroup CASCADE;
CREATE TABLE aclgroup (
	aclgroup_id integer NOT NULL DEFAULT nextval('aclgroup_aclgroup_id_seq'::regclass),
	groupe character varying NOT NULL,
	aclgroup_id_parent integer,
	CONSTRAINT aclgroup_pk PRIMARY KEY (aclgroup_id)

);
-- ddl-end --
COMMENT ON TABLE aclgroup IS 'Groupes des logins';
-- ddl-end --
ALTER TABLE aclgroup OWNER TO postgres;
-- ddl-end --

-- object: acllogin_acllogin_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS acllogin_acllogin_id_seq CASCADE;
CREATE SEQUENCE acllogin_acllogin_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE acllogin_acllogin_id_seq OWNER TO postgres;
-- ddl-end --

-- object: acllogin | type: TABLE --
-- DROP TABLE IF EXISTS acllogin CASCADE;
CREATE TABLE acllogin (
	acllogin_id integer NOT NULL DEFAULT nextval('acllogin_acllogin_id_seq'::regclass),
	login character varying NOT NULL,
	logindetail character varying NOT NULL,
	CONSTRAINT acllogin_pk PRIMARY KEY (acllogin_id)

);
-- ddl-end --
COMMENT ON TABLE acllogin IS 'Table des logins des utilisateurs autorisés';
-- ddl-end --
COMMENT ON COLUMN acllogin.logindetail IS 'Nom affiché';
-- ddl-end --
ALTER TABLE acllogin OWNER TO postgres;
-- ddl-end --

-- object: acllogingroup | type: TABLE --
-- DROP TABLE IF EXISTS acllogingroup CASCADE;
CREATE TABLE acllogingroup (
	acllogin_id integer NOT NULL,
	aclgroup_id integer NOT NULL,
	CONSTRAINT acllogingroup_pk PRIMARY KEY (acllogin_id,aclgroup_id)

);
-- ddl-end --
COMMENT ON TABLE acllogingroup IS 'Table des relations entre les logins et les groupes';
-- ddl-end --
ALTER TABLE acllogingroup OWNER TO postgres;
-- ddl-end --

-- object: log_log_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS log_log_id_seq CASCADE;
CREATE SEQUENCE log_log_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE log_log_id_seq OWNER TO postgres;
-- ddl-end --

-- object: log | type: TABLE --
-- DROP TABLE IF EXISTS log CASCADE;
CREATE TABLE log (
	log_id integer NOT NULL DEFAULT nextval('log_log_id_seq'::regclass),
	login character varying(32) NOT NULL,
	nom_module character varying,
	log_date timestamp NOT NULL,
	commentaire character varying,
	ipaddress character varying,
	CONSTRAINT log_pk PRIMARY KEY (log_id)

);
-- ddl-end --
COMMENT ON TABLE log IS 'Liste des connexions ou des actions enregistrées';
-- ddl-end --
COMMENT ON COLUMN log.log_date IS 'Heure de connexion';
-- ddl-end --
COMMENT ON COLUMN log.commentaire IS 'Donnees complementaires enregistrees';
-- ddl-end --
COMMENT ON COLUMN log.ipaddress IS 'Adresse IP du client';
-- ddl-end --
ALTER TABLE log OWNER TO postgres;
-- ddl-end --

-- object: seq_logingestion_id | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS seq_logingestion_id CASCADE;
CREATE SEQUENCE seq_logingestion_id
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 999999
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE seq_logingestion_id OWNER TO postgres;
-- ddl-end --

-- object: logingestion | type: TABLE --
-- DROP TABLE IF EXISTS logingestion CASCADE;
CREATE TABLE logingestion (
	id integer NOT NULL DEFAULT nextval('seq_logingestion_id'::regclass),
	login character varying(32) NOT NULL,
	password character varying(255),
	nom character varying(32),
	prenom character varying(32),
	mail character varying(255),
	datemodif timestamp,
	actif smallint DEFAULT 1,
	is_clientws boolean DEFAULT false,
	tokenws character varying,
	is_expired boolean DEFAULT false,
	CONSTRAINT pk_logingestion PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE logingestion OWNER TO postgres;
-- ddl-end --
-- object: log_date_idx | type: INDEX --
-- DROP INDEX IF EXISTS log_date_idx CASCADE;
CREATE INDEX log_date_idx ON log
	USING btree
	(
	  log_date
	)
	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: log_login_idx | type: INDEX --
-- DROP INDEX IF EXISTS log_login_idx CASCADE;
CREATE INDEX log_login_idx ON log
	USING btree
	(
	  login
	)
	WITH (FILLFACTOR = 90);
-- ddl-end --
-- object: log_ip_idx | type: INDEX --
-- DROP INDEX IF EXISTS log_ip_idx CASCADE;
CREATE INDEX log_ip_idx ON log
	USING btree
	(
	  ipaddress
	);
-- ddl-end --

-- object: log_commentaire_idx | type: INDEX --
-- DROP INDEX IF EXISTS log_commentaire_idx CASCADE;
CREATE INDEX log_commentaire_idx ON log
	USING btree
	(
	  commentaire
	);
-- ddl-end --

-- object: logingestion_login_idx | type: INDEX --
-- DROP INDEX IF EXISTS logingestion_login_idx CASCADE;
CREATE UNIQUE INDEX logingestion_login_idx ON logingestion
	USING btree
	(
	  login
	);
-- ddl-end --

-- object: aclaco_aclacl_fk | type: CONSTRAINT --
-- ALTER TABLE aclacl DROP CONSTRAINT IF EXISTS aclaco_aclacl_fk CASCADE;
ALTER TABLE aclacl ADD CONSTRAINT aclaco_aclacl_fk FOREIGN KEY (aclaco_id)
REFERENCES aclaco (aclaco_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: aclgroup_aclacl_fk | type: CONSTRAINT --
-- ALTER TABLE aclacl DROP CONSTRAINT IF EXISTS aclgroup_aclacl_fk CASCADE;
ALTER TABLE aclacl ADD CONSTRAINT aclgroup_aclacl_fk FOREIGN KEY (aclgroup_id)
REFERENCES aclgroup (aclgroup_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: aclappli_aclaco_fk | type: CONSTRAINT --
-- ALTER TABLE aclaco DROP CONSTRAINT IF EXISTS aclappli_aclaco_fk CASCADE;
ALTER TABLE aclaco ADD CONSTRAINT aclappli_aclaco_fk FOREIGN KEY (aclappli_id)
REFERENCES aclappli (aclappli_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: aclgroup_aclgroup_fk | type: CONSTRAINT --
-- ALTER TABLE aclgroup DROP CONSTRAINT IF EXISTS aclgroup_aclgroup_fk CASCADE;
ALTER TABLE aclgroup ADD CONSTRAINT aclgroup_aclgroup_fk FOREIGN KEY (aclgroup_id_parent)
REFERENCES aclgroup (aclgroup_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: aclgroup_acllogingroup_fk | type: CONSTRAINT --
-- ALTER TABLE acllogingroup DROP CONSTRAINT IF EXISTS aclgroup_acllogingroup_fk CASCADE;
ALTER TABLE acllogingroup ADD CONSTRAINT aclgroup_acllogingroup_fk FOREIGN KEY (aclgroup_id)
REFERENCES aclgroup (aclgroup_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: acllogin_acllogingroup_fk | type: CONSTRAINT --
-- ALTER TABLE acllogingroup DROP CONSTRAINT IF EXISTS acllogin_acllogingroup_fk CASCADE;
ALTER TABLE acllogingroup ADD CONSTRAINT acllogin_acllogingroup_fk FOREIGN KEY (acllogin_id)
REFERENCES acllogin (acllogin_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

/*
 * pre-remplissage du schema
 */
/*
 * Compte admin par defaut
 */
insert into logingestion (id, login, password, nom) values (1, 'admin', 'cd916028a2d8a1b901e831246dd5b9b4d3832786ddc63bbf5af4b50d9fc98f50', 'Administrator');
insert into acllogin (acllogin_id, login, logindetail) values (1, 'admin', 'admin');
/*
 * Ajout des droits necessaires
 */
insert into aclappli (aclappli_id, appli) values (1, 'col');
insert into aclaco (aclaco_id, aclappli_id, aco) 
values 
(1, 1, 'admin'),
(2, 1, 'param'),
(3, 1, 'collection'),
(4, 1, 'gestion'),
(5, 1, 'consult'),
(6, 1, 'import');
insert into aclgroup (aclgroup_id, groupe, aclgroup_id_parent) 
values 
(1, 'admin', null),
(2, 'consult', null),
(3, 'gestion', 2),
(4, 'collection', 3),
(5, 'param', 4),
(6, 'import', 3);

insert into aclacl (aclaco_id, aclgroup_id)
values
(1, 1),
(2, 5),
(3, 4),
(4, 3),
(5, 2),
(6, 6);

insert into acllogingroup (acllogin_id, aclgroup_id)
values
(1, 1),
(1, 5);

select setval('seq_logingestion_id', (select max(id) from logingestion));
select setval('aclappli_aclappli_id_seq', (select max(aclappli_id) from aclappli));
select setval('aclaco_aclaco_id_seq', (select max(aclaco_id) from aclaco));
select setval('acllogin_acllogin_id_seq', (select max(acllogin_id) from acllogin));
select setval('aclgroup_aclgroup_id_seq', (select max(aclgroup_id) from aclgroup));

