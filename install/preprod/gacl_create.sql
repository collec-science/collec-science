CREATE TABLE "collec"."gacl"."aclacl" 
(
  "aclaco_id"     INTEGER NOT NULL,
  "aclgroup_id"   INTEGER NOT NULL,
  CONSTRAINT "aclacl_pk" PRIMARY KEY ("aclaco_id","aclgroup_id")
);

COMMENT ON TABLE "collec"."gacl"."aclacl" IS 'Table des droits attribués';

CREATE SEQUENCE "collec"."gacl"."aclaco_aclaco_id_seq";

CREATE TABLE "collec"."gacl"."aclaco" 
(
  "aclaco_id"     INTEGER NOT NULL DEFAULT nextval ('"collec"."gacl"."aclaco_aclaco_id_seq"'),
  "aclappli_id"   INTEGER NOT NULL,
  "aco"           VARCHAR NOT NULL,
  CONSTRAINT "aclaco_pk" PRIMARY KEY ("aclaco_id")
);

COMMENT ON TABLE "collec"."gacl"."aclaco" IS 'Table des droits gérés';

ALTER SEQUENCE "collec"."gacl"."aclaco_aclaco_id_seq" OWNED BY "collec"."gacl"."aclaco"."aclaco_id";

CREATE SEQUENCE "collec"."gacl"."aclappli_aclappli_id_seq";

CREATE TABLE "collec"."gacl"."aclappli" 
(
  "aclappli_id"   INTEGER NOT NULL DEFAULT nextval ('"collec"."gacl"."aclappli_aclappli_id_seq"'),
  "appli"         VARCHAR NOT NULL,
  "applidetail"   VARCHAR,
  CONSTRAINT "aclappli_pk" PRIMARY KEY ("aclappli_id")
);

COMMENT ON TABLE "collec"."gacl"."aclappli" IS 'Table des applications gérées';

COMMENT ON COLUMN "collec"."gacl"."aclappli"."appli" IS 'Nom de l''application pour la gestion des droits';

COMMENT ON COLUMN "collec"."gacl"."aclappli"."applidetail" IS 'Description de l''application';

ALTER SEQUENCE "collec"."gacl"."aclappli_aclappli_id_seq" OWNED BY "collec"."gacl"."aclappli"."aclappli_id";

CREATE SEQUENCE "collec"."gacl"."aclgroup_aclgroup_id_seq";

CREATE TABLE "collec"."gacl"."aclgroup" 
(
  "aclgroup_id"          INTEGER NOT NULL DEFAULT nextval ('"collec"."gacl"."aclgroup_aclgroup_id_seq"'),
  "groupe"               VARCHAR NOT NULL,
  "aclgroup_id_parent"   INTEGER,
  CONSTRAINT "aclgroup_pk" PRIMARY KEY ("aclgroup_id")
);

COMMENT ON TABLE "collec"."gacl"."aclgroup" IS 'Groupes des logins';

ALTER SEQUENCE "collec"."gacl"."aclgroup_aclgroup_id_seq" OWNED BY "collec"."gacl"."aclgroup"."aclgroup_id";

CREATE SEQUENCE "collec"."gacl"."acllogin_acllogin_id_seq";

CREATE TABLE "collec"."gacl"."acllogin" 
(
  "acllogin_id"   INTEGER NOT NULL DEFAULT nextval ('"collec"."gacl"."acllogin_acllogin_id_seq"'),
  "login"         VARCHAR NOT NULL,
  "logindetail"   VARCHAR NOT NULL,
  CONSTRAINT "acllogin_pk" PRIMARY KEY ("acllogin_id")
);

COMMENT ON TABLE "collec"."gacl"."acllogin" IS 'Table des logins des utilisateurs autorisés';

COMMENT ON COLUMN "collec"."gacl"."acllogin"."logindetail" IS 'Nom affiché';

ALTER SEQUENCE "collec"."gacl"."acllogin_acllogin_id_seq" OWNED BY "collec"."gacl"."acllogin"."acllogin_id";

CREATE TABLE "collec"."gacl"."acllogingroup" 
(
  "acllogin_id"   INTEGER NOT NULL,
  "aclgroup_id"   INTEGER NOT NULL,
  CONSTRAINT "acllogingroup_pk" PRIMARY KEY ("acllogin_id","aclgroup_id")
);

COMMENT ON TABLE "collec"."gacl"."acllogingroup" IS 'Table des relations entre les logins et les groupes';

CREATE SEQUENCE "collec"."gacl"."log_log_id_seq";

CREATE TABLE "collec"."gacl"."log" 
(
  "log_id"        INTEGER NOT NULL DEFAULT nextval ('"collec"."gacl"."log_log_id_seq"'),
  "login"         VARCHAR(32) NOT NULL,
  "nom_module"    VARCHAR,
  "log_date"      TIMESTAMP NOT NULL,
  "commentaire"   VARCHAR,
  "ipaddress"     VARCHAR,
  CONSTRAINT "log_pk" PRIMARY KEY ("log_id")
);

COMMENT ON TABLE "collec"."gacl"."log" IS 'Liste des connexions ou des actions enregistrées';

COMMENT ON COLUMN "collec"."gacl"."log"."log_date" IS 'Heure de connexion';

COMMENT ON COLUMN "collec"."gacl"."log"."commentaire" IS 'Donnees complementaires enregistrees';

ALTER SEQUENCE "collec"."gacl"."log_log_id_seq" OWNED BY "collec"."gacl"."log"."log_id";

CREATE SEQUENCE "collec"."gacl"."login_oldpassword_login_oldpassword_id_seq";

CREATE TABLE "collec"."gacl"."login_oldpassword" 
(
  "login_oldpassword_id"   INTEGER  NOT NULL DEFAULT nextval ('"collec"."gacl"."login_oldpassword_login_oldpassword_id_seq"'),
  "id"                     INTEGER  NOT NULL,
  "password"               VARCHAR(255),
  CONSTRAINT "login_oldpassword_pk" PRIMARY KEY ("login_oldpassword_id")
);

COMMENT ON TABLE "collec"."gacl"."login_oldpassword" IS 'Table contenant les anciens mots de passe';

ALTER SEQUENCE "collec"."gacl"."login_oldpassword_login_oldpassword_id_seq" OWNED BY "collec"."gacl"."login_oldpassword"."login_oldpassword_id";

CREATE SEQUENCE "collec"."gacl"."logingestion_id_seq";

CREATE TABLE "collec"."gacl"."logingestion" 
(
  "id"          INTEGER NOT NULL DEFAULT nextval ('"collec"."gacl"."logingestion_id_seq"'),
  "login"       VARCHAR(32) NOT NULL,
  "password"    VARCHAR(255),
  "nom"         VARCHAR(32),
  "prenom"      VARCHAR(32),
  "mail"        VARCHAR(255),
  "datemodif"   DATE,
  "actif"       SMALLINT DEFAULT 1,
  CONSTRAINT "pk_logingestion" PRIMARY KEY ("id")
);

ALTER SEQUENCE "collec"."gacl"."logingestion_id_seq" OWNED BY "collec"."gacl"."logingestion"."id";

ALTER TABLE "collec"."gacl"."aclacl" ADD CONSTRAINT "aclaco_aclacl_fk" FOREIGN KEY ("aclaco_id") REFERENCES "collec"."gacl"."aclaco" ("aclaco_id") ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE;

ALTER TABLE "collec"."gacl"."aclaco" ADD CONSTRAINT "aclappli_aclaco_fk" FOREIGN KEY ("aclappli_id") REFERENCES "collec"."gacl"."aclappli" ("aclappli_id") ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE;

ALTER TABLE "collec"."gacl"."aclacl" ADD CONSTRAINT "aclgroup_aclacl_fk" FOREIGN KEY ("aclgroup_id") REFERENCES "collec"."gacl"."aclgroup" ("aclgroup_id") ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE;

ALTER TABLE "collec"."gacl"."aclgroup" ADD CONSTRAINT "aclgroup_aclgroup_fk" FOREIGN KEY ("aclgroup_id_parent") REFERENCES "collec"."gacl"."aclgroup" ("aclgroup_id") ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE;

ALTER TABLE "collec"."gacl"."acllogingroup" ADD CONSTRAINT "aclgroup_acllogingroup_fk" FOREIGN KEY ("aclgroup_id") REFERENCES "collec"."gacl"."aclgroup" ("aclgroup_id") ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE;

ALTER TABLE "collec"."gacl"."acllogingroup" ADD CONSTRAINT "acllogin_acllogingroup_fk" FOREIGN KEY ("acllogin_id") REFERENCES "collec"."gacl"."acllogin" ("acllogin_id") ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE;

ALTER TABLE "collec"."gacl"."login_oldpassword" ADD CONSTRAINT "logingestion_login_oldpassword_fk" FOREIGN KEY ("id") REFERENCES "collec"."gacl"."logingestion" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION NOT DEFERRABLE;

