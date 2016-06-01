

CREATE TABLE sturio.gacl.aclacl (
                aclaco_id INTEGER NOT NULL,
                aclgroup_id INTEGER NOT NULL,
                CONSTRAINT aclacl_pk PRIMARY KEY (aclaco_id, aclgroup_id)
);
COMMENT ON TABLE sturio.gacl.aclacl IS 'Table des droits attribués';


CREATE SEQUENCE sturio.gacl.aclaco_aclaco_id_seq;

CREATE TABLE sturio.gacl.aclaco (
                aclaco_id INTEGER NOT NULL DEFAULT nextval('sturio.gacl.aclaco_aclaco_id_seq'),
                aclappli_id INTEGER NOT NULL,
                aco VARCHAR NOT NULL,
                CONSTRAINT aclaco_pk PRIMARY KEY (aclaco_id)
);
COMMENT ON TABLE sturio.gacl.aclaco IS 'Table des droits gérés';


ALTER SEQUENCE sturio.gacl.aclaco_aclaco_id_seq OWNED BY sturio.gacl.aclaco.aclaco_id;

CREATE SEQUENCE sturio.gacl.aclappli_aclappli_id_seq;

CREATE TABLE sturio.gacl.aclappli (
                aclappli_id INTEGER NOT NULL DEFAULT nextval('sturio.gacl.aclappli_aclappli_id_seq'),
                appli VARCHAR NOT NULL,
                applidetail VARCHAR,
                CONSTRAINT aclappli_pk PRIMARY KEY (aclappli_id)
);
COMMENT ON TABLE sturio.gacl.aclappli IS 'Table des applications gérées';
COMMENT ON COLUMN sturio.gacl.aclappli.appli IS 'Nom de l''application pour la gestion des droits';
COMMENT ON COLUMN sturio.gacl.aclappli.applidetail IS 'Description de l''application';


ALTER SEQUENCE sturio.gacl.aclappli_aclappli_id_seq OWNED BY sturio.gacl.aclappli.aclappli_id;

CREATE SEQUENCE sturio.gacl.aclgroup_aclgroup_id_seq;

CREATE TABLE sturio.gacl.aclgroup (
                aclgroup_id INTEGER NOT NULL DEFAULT nextval('sturio.gacl.aclgroup_aclgroup_id_seq'),
                groupe VARCHAR NOT NULL,
                aclgroup_id_parent INTEGER,
                CONSTRAINT aclgroup_pk PRIMARY KEY (aclgroup_id)
);
COMMENT ON TABLE sturio.gacl.aclgroup IS 'Groupes des logins';


ALTER SEQUENCE sturio.gacl.aclgroup_aclgroup_id_seq OWNED BY sturio.gacl.aclgroup.aclgroup_id;

CREATE SEQUENCE sturio.gacl.acllogin_acllogin_id_seq;

CREATE TABLE sturio.gacl.acllogin (
                acllogin_id INTEGER NOT NULL DEFAULT nextval('sturio.gacl.acllogin_acllogin_id_seq'),
                login VARCHAR NOT NULL,
                logindetail VARCHAR NOT NULL,
                CONSTRAINT acllogin_pk PRIMARY KEY (acllogin_id)
);
COMMENT ON TABLE sturio.gacl.acllogin IS 'Table des logins des utilisateurs autorisés';
COMMENT ON COLUMN sturio.gacl.acllogin.logindetail IS 'Nom affiché';


ALTER SEQUENCE sturio.gacl.acllogin_acllogin_id_seq OWNED BY sturio.gacl.acllogin.acllogin_id;

CREATE TABLE sturio.gacl.acllogingroup (
                acllogin_id INTEGER NOT NULL,
                aclgroup_id INTEGER NOT NULL,
                CONSTRAINT acllogingroup_pk PRIMARY KEY (acllogin_id, aclgroup_id)
);
COMMENT ON TABLE sturio.gacl.acllogingroup IS 'Table des relations entre les logins et les groupes';


ALTER TABLE ONLY sturio.gacl.gaclacl ALTER COLUMN note TYPE TEXT, ALTER COLUMN note DROP NOT NULL;

ALTER TABLE ONLY sturio.gacl.gaclacl ALTER COLUMN return_value TYPE TEXT, ALTER COLUMN return_value DROP NOT NULL;

ALTER TABLE sturio.gacl.aclacl ADD CONSTRAINT aclaco_aclacl_fk
FOREIGN KEY (aclaco_id)
REFERENCES sturio.gacl.aclaco (aclaco_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sturio.gacl.aclaco ADD CONSTRAINT aclappli_aclaco_fk
FOREIGN KEY (aclappli_id)
REFERENCES sturio.gacl.aclappli (aclappli_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sturio.gacl.aclacl ADD CONSTRAINT aclgroup_aclacl_fk
FOREIGN KEY (aclgroup_id)
REFERENCES sturio.gacl.aclgroup (aclgroup_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sturio.gacl.aclgroup ADD CONSTRAINT aclgroup_aclgroup_fk
FOREIGN KEY (aclgroup_id_parent)
REFERENCES sturio.gacl.aclgroup (aclgroup_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sturio.gacl.acllogingroup ADD CONSTRAINT aclgroup_acllogingroup_fk
FOREIGN KEY (aclgroup_id)
REFERENCES sturio.gacl.aclgroup (aclgroup_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE sturio.gacl.acllogingroup ADD CONSTRAINT acllogin_acllogingroup_fk
FOREIGN KEY (acllogin_id)
REFERENCES sturio.gacl.acllogin (acllogin_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
