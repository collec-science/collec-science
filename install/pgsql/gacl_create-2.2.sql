/*
 * Collec-Science - 4 mai 2018
 * Script de creation des tables necessaires a la gestion des droits
 * deux schemas sont necessaires, l'un pour les donnees proprement dites, 
 * l'autre pour la gestion des droits (habilitations et des traces)
 * Ce script permet la creation du schema pour la gestion des droits
 * modifiez si necessaire le nom du schema :
 * - lignes 14 et 15
 */

/*
 * Creation du schema de gestion des droits
 */
create schema if not exists gacl;
set search_path = gacl;

CREATE TABLE aclacl (
                aclaco_id INTEGER NOT NULL,
                aclgroup_id INTEGER NOT NULL,
                CONSTRAINT aclacl_pk PRIMARY KEY (aclaco_id, aclgroup_id)
);
COMMENT ON TABLE aclacl IS 'Rights table';


CREATE SEQUENCE aclaco_aclaco_id_seq;

CREATE TABLE aclaco (
                aclaco_id INTEGER NOT NULL DEFAULT nextval('aclaco_aclaco_id_seq'),
                aclappli_id INTEGER NOT NULL,
                aco VARCHAR NOT NULL,
                CONSTRAINT aclaco_pk PRIMARY KEY (aclaco_id)
);
COMMENT ON TABLE aclaco IS 'List of managed rights';


ALTER SEQUENCE aclaco_aclaco_id_seq OWNED BY aclaco.aclaco_id;

CREATE SEQUENCE aclappli_aclappli_id_seq;

CREATE TABLE aclappli (
                aclappli_id INTEGER NOT NULL DEFAULT nextval('aclappli_aclappli_id_seq'),
                appli VARCHAR NOT NULL,
                applidetail VARCHAR,
                CONSTRAINT aclappli_pk PRIMARY KEY (aclappli_id)
);
COMMENT ON TABLE aclappli IS 'Managed software table';
COMMENT ON COLUMN aclappli.appli IS 'Software name from rights management';
COMMENT ON COLUMN aclappli.applidetail IS 'Software description';


ALTER SEQUENCE aclappli_aclappli_id_seq OWNED BY aclappli.aclappli_id;

CREATE SEQUENCE aclgroup_aclgroup_id_seq;

CREATE TABLE aclgroup (
                aclgroup_id INTEGER NOT NULL DEFAULT nextval('aclgroup_aclgroup_id_seq'),
                groupe VARCHAR NOT NULL,
                aclgroup_id_parent INTEGER,
                CONSTRAINT aclgroup_pk PRIMARY KEY (aclgroup_id)
);
COMMENT ON TABLE aclgroup IS 'Login groups';


ALTER SEQUENCE aclgroup_aclgroup_id_seq OWNED BY aclgroup.aclgroup_id;

CREATE SEQUENCE acllogin_acllogin_id_seq;

CREATE TABLE acllogin (
                acllogin_id INTEGER NOT NULL DEFAULT nextval('acllogin_acllogin_id_seq'),
                login VARCHAR NOT NULL,
                logindetail VARCHAR NOT NULL,
                CONSTRAINT acllogin_pk PRIMARY KEY (acllogin_id)
);
COMMENT ON TABLE acllogin IS 'Users login';
COMMENT ON COLUMN acllogin.logindetail IS 'Nom affiché';


ALTER SEQUENCE acllogin_acllogin_id_seq OWNED BY acllogin.acllogin_id;

CREATE TABLE acllogingroup (
                acllogin_id INTEGER NOT NULL,
                aclgroup_id INTEGER NOT NULL,
                CONSTRAINT acllogingroup_pk PRIMARY KEY (acllogin_id, aclgroup_id)
);
COMMENT ON TABLE acllogingroup IS 'Relationship between logins and groups';


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

CREATE TABLE logingestion (
    id integer NOT NULL,
    login character varying(32) NOT NULL,
    password character varying(255),
    nom character varying(32),
    prenom character varying(32),
    mail character varying(255),
    datemodif date,
    actif smallint default 1,
    is_clientws BOOLEAN DEFAULT false NOT NULL,
    tokenws VARCHAR
);
ALTER TABLE  logingestion
    ADD CONSTRAINT pk_logingestion PRIMARY KEY (id);
	
CREATE SEQUENCE seq_logingestion_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 999999
    CACHE 1;

ALTER TABLE logingestion ALTER COLUMN id SET DEFAULT nextval('seq_logingestion_id'::regclass);


CREATE SEQUENCE login_oldpassword_login_oldpassword_id_seq;

CREATE TABLE login_oldpassword (
                login_oldpassword_id INTEGER NOT NULL DEFAULT nextval('login_oldpassword_login_oldpassword_id_seq'),
                id INTEGER DEFAULT nextval('seq_logingestion_id'::regclass) NOT NULL,
                password VARCHAR(255),
                CONSTRAINT login_oldpassword_pk PRIMARY KEY (login_oldpassword_id)
);
COMMENT ON TABLE login_oldpassword IS 'Table with old passwords';


ALTER SEQUENCE login_oldpassword_login_oldpassword_id_seq OWNED BY login_oldpassword.login_oldpassword_id;

ALTER TABLE login_oldpassword ADD CONSTRAINT logingestion_login_oldpassword_fk
FOREIGN KEY (id)
REFERENCES logingestion (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE SEQUENCE log_log_id_seq;

CREATE TABLE log (
                log_id INTEGER NOT NULL DEFAULT nextval('log_log_id_seq'),
                login VARCHAR(32) NOT NULL,
                nom_module VARCHAR,
                log_date TIMESTAMP NOT NULL,
                commentaire VARCHAR,
                ipaddress varchar,
                CONSTRAINT log_pk PRIMARY KEY (log_id)
);
COMMENT ON TABLE log IS 'list of connexions and actions recorded';
COMMENT ON COLUMN log.log_date IS 'Connexion time';
COMMENT ON COLUMN log.commentaire IS 'others data';
comment on column log.ipaddress is 'ip address of client';

ALTER SEQUENCE log_log_id_seq OWNED BY log.log_id;

CREATE INDEX log_date_idx
 ON log
 ( log_date );

CREATE INDEX log_login_idx
 ON log
 ( login );

 CREATE SEQUENCE "passwordlost_passwordlost_id_seq";

CREATE TABLE "passwordlost" (
                "passwordlost_id" INTEGER NOT NULL DEFAULT nextval('"passwordlost_passwordlost_id_seq"'),
                "id" INTEGER NOT NULL,
                "token" VARCHAR NOT NULL,
                "expiration" TIMESTAMP NOT NULL,
                "usedate" TIMESTAMP,
                CONSTRAINT "passwordlost_pk" PRIMARY KEY ("passwordlost_id")
);
COMMENT ON TABLE "passwordlost" IS 'password lost table';
COMMENT ON COLUMN "passwordlost"."token" IS 'token used for renewal';
COMMENT ON COLUMN "passwordlost"."expiration" IS 'Token expiration date';


ALTER SEQUENCE "passwordlost_passwordlost_id_seq" OWNED BY "passwordlost"."passwordlost_id";

ALTER TABLE "passwordlost" ADD CONSTRAINT "logingestion_passwordlost_fk"
FOREIGN KEY ("id")
REFERENCES "logingestion" ("id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
 
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

