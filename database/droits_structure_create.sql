create schema gacl;

CREATE TABLE gacl.aclacl (
                aclaco_id INTEGER NOT NULL,
                aclgroup_id INTEGER NOT NULL,
                CONSTRAINT aclacl_pk PRIMARY KEY (aclaco_id, aclgroup_id)
);
COMMENT ON TABLE gacl.aclacl IS 'Table des droits attribués';


CREATE SEQUENCE gacl.aclaco_aclaco_id_seq;

CREATE TABLE gacl.aclaco (
                aclaco_id INTEGER NOT NULL DEFAULT nextval('gacl.aclaco_aclaco_id_seq'),
                aclappli_id INTEGER NOT NULL,
                aco VARCHAR NOT NULL,
                CONSTRAINT aclaco_pk PRIMARY KEY (aclaco_id)
);
COMMENT ON TABLE gacl.aclaco IS 'Table des droits gérés';


ALTER SEQUENCE gacl.aclaco_aclaco_id_seq OWNED BY gacl.aclaco.aclaco_id;

CREATE SEQUENCE gacl.aclappli_aclappli_id_seq;

CREATE TABLE gacl.aclappli (
                aclappli_id INTEGER NOT NULL DEFAULT nextval('gacl.aclappli_aclappli_id_seq'),
                appli VARCHAR NOT NULL,
                applidetail VARCHAR,
                CONSTRAINT aclappli_pk PRIMARY KEY (aclappli_id)
);
COMMENT ON TABLE gacl.aclappli IS 'Table des applications gérées';
COMMENT ON COLUMN gacl.aclappli.appli IS 'Nom de l''application pour la gestion des droits';
COMMENT ON COLUMN gacl.aclappli.applidetail IS 'Description de l''application';


ALTER SEQUENCE gacl.aclappli_aclappli_id_seq OWNED BY gacl.aclappli.aclappli_id;

CREATE SEQUENCE gacl.aclgroup_aclgroup_id_seq;

CREATE TABLE gacl.aclgroup (
                aclgroup_id INTEGER NOT NULL DEFAULT nextval('gacl.aclgroup_aclgroup_id_seq'),
                groupe VARCHAR NOT NULL,
                aclgroup_id_parent INTEGER,
                CONSTRAINT aclgroup_pk PRIMARY KEY (aclgroup_id)
);
COMMENT ON TABLE gacl.aclgroup IS 'Groupes des logins';


ALTER SEQUENCE gacl.aclgroup_aclgroup_id_seq OWNED BY gacl.aclgroup.aclgroup_id;

CREATE SEQUENCE gacl.acllogin_acllogin_id_seq;

CREATE TABLE gacl.acllogin (
                acllogin_id INTEGER NOT NULL DEFAULT nextval('gacl.acllogin_acllogin_id_seq'),
                login VARCHAR NOT NULL,
                logindetail VARCHAR NOT NULL,
                CONSTRAINT acllogin_pk PRIMARY KEY (acllogin_id)
);
COMMENT ON TABLE gacl.acllogin IS 'Table des logins des utilisateurs autorisés';
COMMENT ON COLUMN gacl.acllogin.logindetail IS 'Nom affiché';


ALTER SEQUENCE gacl.acllogin_acllogin_id_seq OWNED BY gacl.acllogin.acllogin_id;

CREATE TABLE gacl.acllogingroup (
                acllogin_id INTEGER NOT NULL,
                aclgroup_id INTEGER NOT NULL,
                CONSTRAINT acllogingroup_pk PRIMARY KEY (acllogin_id, aclgroup_id)
);
COMMENT ON TABLE gacl.acllogingroup IS 'Table des relations entre les logins et les groupes';



ALTER TABLE gacl.aclacl ADD CONSTRAINT aclaco_aclacl_fk
FOREIGN KEY (aclaco_id)
REFERENCES gacl.aclaco (aclaco_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE gacl.aclaco ADD CONSTRAINT aclappli_aclaco_fk
FOREIGN KEY (aclappli_id)
REFERENCES gacl.aclappli (aclappli_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE gacl.aclacl ADD CONSTRAINT aclgroup_aclacl_fk
FOREIGN KEY (aclgroup_id)
REFERENCES gacl.aclgroup (aclgroup_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE gacl.aclgroup ADD CONSTRAINT aclgroup_aclgroup_fk
FOREIGN KEY (aclgroup_id_parent)
REFERENCES gacl.aclgroup (aclgroup_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE gacl.acllogingroup ADD CONSTRAINT aclgroup_acllogingroup_fk
FOREIGN KEY (aclgroup_id)
REFERENCES gacl.aclgroup (aclgroup_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE gacl.acllogingroup ADD CONSTRAINT acllogin_acllogingroup_fk
FOREIGN KEY (acllogin_id)
REFERENCES gacl.acllogin (acllogin_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE TABLE gacl.log
(
   log_id       serial        NOT NULL,
   login        varchar(32)   NOT NULL,
   nom_module   varchar,
   log_date     timestamp     NOT NULL,
   commentaire  varchar
);

-- Column log_id is associated with sequence gacl.log_log_id_seq

ALTER TABLE gacl.log
   ADD CONSTRAINT log_pk
   PRIMARY KEY (log_id);

CREATE INDEX log_date_idx ON gacl.log USING btree (log_date);
CREATE INDEX log_login_idx ON gacl.log USING btree (login);


COMMENT ON TABLE gacl.log IS 'Liste des connexions ou des actions enregistrées';
COMMENT ON COLUMN gacl.log.log_date IS 'Heure de connexion';
COMMENT ON COLUMN gacl.log.commentaire IS 'Donnees complementaires enregistrees';

