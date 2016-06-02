
create schema gacl;
set search_path = gacl;

CREATE TABLE aclacl (
                aclaco_id INTEGER NOT NULL,
                aclgroup_id INTEGER NOT NULL,
                CONSTRAINT aclacl_pk PRIMARY KEY (aclaco_id, aclgroup_id)
);
COMMENT ON TABLE aclacl IS 'Table des droits attribués';


CREATE SEQUENCE aclaco_aclaco_id_seq;

CREATE TABLE aclaco (
                aclaco_id INTEGER NOT NULL DEFAULT nextval('aclaco_aclaco_id_seq'),
                aclappli_id INTEGER NOT NULL,
                aco VARCHAR NOT NULL,
                CONSTRAINT aclaco_pk PRIMARY KEY (aclaco_id)
);
COMMENT ON TABLE aclaco IS 'Table des droits gérés';


ALTER SEQUENCE aclaco_aclaco_id_seq OWNED BY aclaco.aclaco_id;

CREATE SEQUENCE aclappli_aclappli_id_seq;

CREATE TABLE aclappli (
                aclappli_id INTEGER NOT NULL DEFAULT nextval('aclappli_aclappli_id_seq'),
                appli VARCHAR NOT NULL,
                applidetail VARCHAR,
                CONSTRAINT aclappli_pk PRIMARY KEY (aclappli_id)
);
COMMENT ON TABLE aclappli IS 'Table des applications gérées';
COMMENT ON COLUMN aclappli.appli IS 'Nom de l''application pour la gestion des droits';
COMMENT ON COLUMN aclappli.applidetail IS 'Description de l''application';


ALTER SEQUENCE aclappli_aclappli_id_seq OWNED BY aclappli.aclappli_id;

CREATE SEQUENCE aclgroup_aclgroup_id_seq;

CREATE TABLE aclgroup (
                aclgroup_id INTEGER NOT NULL DEFAULT nextval('aclgroup_aclgroup_id_seq'),
                groupe VARCHAR NOT NULL,
                aclgroup_id_parent INTEGER,
                CONSTRAINT aclgroup_pk PRIMARY KEY (aclgroup_id)
);
COMMENT ON TABLE aclgroup IS 'Groupes des logins';


ALTER SEQUENCE aclgroup_aclgroup_id_seq OWNED BY aclgroup.aclgroup_id;

CREATE SEQUENCE acllogin_acllogin_id_seq;

CREATE TABLE acllogin (
                acllogin_id INTEGER NOT NULL DEFAULT nextval('acllogin_acllogin_id_seq'),
                login VARCHAR NOT NULL,
                logindetail VARCHAR NOT NULL,
                CONSTRAINT acllogin_pk PRIMARY KEY (acllogin_id)
);
COMMENT ON TABLE acllogin IS 'Table des logins des utilisateurs autorisés';
COMMENT ON COLUMN acllogin.logindetail IS 'Nom affiché';


ALTER SEQUENCE acllogin_acllogin_id_seq OWNED BY acllogin.acllogin_id;

CREATE TABLE acllogingroup (
                acllogin_id INTEGER NOT NULL,
                aclgroup_id INTEGER NOT NULL,
                CONSTRAINT acllogingroup_pk PRIMARY KEY (acllogin_id, aclgroup_id)
);
COMMENT ON TABLE acllogingroup IS 'Table des relations entre les logins et les groupes';



ALTER TABLE aclacl ADD CONSTRAINT aclaco_aclacl_fk
FOREIGN KEY (aclaco_id)
REFERENCES aclaco (aclaco_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE aclaco ADD CONSTRAINT aclappli_aclaco_fk
FOREIGN KEY (aclappli_id)
REFERENCES aclappli (aclappli_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE aclacl ADD CONSTRAINT aclgroup_aclacl_fk
FOREIGN KEY (aclgroup_id)
REFERENCES aclgroup (aclgroup_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE aclgroup ADD CONSTRAINT aclgroup_aclgroup_fk
FOREIGN KEY (aclgroup_id_parent)
REFERENCES aclgroup (aclgroup_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE acllogingroup ADD CONSTRAINT aclgroup_acllogingroup_fk
FOREIGN KEY (aclgroup_id)
REFERENCES aclgroup (aclgroup_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE acllogingroup ADD CONSTRAINT acllogin_acllogingroup_fk
FOREIGN KEY (acllogin_id)
REFERENCES acllogin (acllogin_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE TABLE log
(
   log_id       serial        NOT NULL,
   login        varchar(32)   NOT NULL,
   nom_module   varchar,
   log_date     timestamp     NOT NULL,
   commentaire  varchar,
   ipaddress varchar
);

-- Column log_id is associated with sequence log_log_id_seq

ALTER TABLE log
   ADD CONSTRAINT log_pk
   PRIMARY KEY (log_id);

CREATE INDEX log_date_idx ON log USING btree (log_date);
CREATE INDEX log_login_idx ON log USING btree (login);


COMMENT ON TABLE log IS 'Liste des connexions ou des actions enregistrées';
COMMENT ON COLUMN log.log_date IS 'Heure de connexion';
COMMENT ON COLUMN log.commentaire IS 'Donnees complementaires enregistrees';

/*
 * Gestion des logins de connexion
 */
 
CREATE TABLE logingestion (
    id integer NOT NULL,
    login character varying(32) NOT NULL,
    password character varying(255),
    nom character varying(32),
    prenom character varying(32),
    mail character varying(255),
    datemodif date,
    actif smallint default 1
);
ALTER TABLE ONLY logingestion
    ADD CONSTRAINT pk_logingestion PRIMARY KEY (id);
	
CREATE SEQUENCE seq_logingestion_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 999999
    CACHE 1;

ALTER TABLE ONLY logingestion ALTER COLUMN id SET DEFAULT nextval('seq_logingestion_id'::regclass);

insert into logingestion (id, login, password, nom) values (1, 'admin', 'cd916028a2d8a1b901e831246dd5b9b4d3832786ddc63bbf5af4b50d9fc98f50', 'Administrator');

CREATE SEQUENCE login_oldpassword_login_oldpassword_id_seq;

CREATE TABLE login_oldpassword (
                login_oldpassword_id INTEGER NOT NULL DEFAULT nextval('login_oldpassword_login_oldpassword_id_seq'),
                id INTEGER DEFAULT nextval('seq_logingestion_id'::regclass) NOT NULL,
                password VARCHAR(255),
                CONSTRAINT login_oldpassword_pk PRIMARY KEY (login_oldpassword_id)
);
COMMENT ON TABLE login_oldpassword IS 'Table contenant les anciens mots de passe';


ALTER SEQUENCE login_oldpassword_login_oldpassword_id_seq OWNED BY login_oldpassword.login_oldpassword_id;

ALTER TABLE login_oldpassword ADD CONSTRAINT logingestion_login_oldpassword_fk
FOREIGN KEY (id)
REFERENCES logingestion (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/*
 * Droits de base
 */
insert into aclappli (aclappli_id, appli) values (1, 'appli');
insert into aclaco (aclaco_id, aclappli_id, aco) values (1, 1, 'admin');
insert into acllogin (acllogin_id, login, logindetail) values (1, 'admin', 'admin');
insert into aclgroup (aclgroup_id, groupe) values (1, 'admin');
insert into acllogingroup (acllogin_id, aclgroup_id) values (1, 1);
insert into aclacl (aclaco_id, aclgroup_id) values (1, 1);
