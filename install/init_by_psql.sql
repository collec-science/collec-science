/*
 * COLLEC - 29/05/2017
 * Script de creation des tables destinees a recevoir les donnees de l'application
 * version minimale de Postgresql : 9.4.
 * Schema par defaut : col. Si vous voulez creer les donnees dans d'autres schemas, modifiez les 
 * lignes 279 et 280 en consequence
 * Execution de ce script en ligne de commande, en etant connecte root :
 * su postgres -c "psql -f init_by_psql.sql"
 * dans la configuration de postgresql :
 * /etc/postgresql/version/main/pg_hba.conf
 * inserez les lignes suivantes (connexion avec uniquement le compte collec en local) :
 * host    collec             collec             127.0.0.1/32            md5
 * host    all            collec                  0.0.0.0/0               reject
 */
 
 /*
  * Creation du compte de connexion et de la base de donnees
  */
CREATE USER collec WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
 PASSWORD 'collecPassword'  
;

create database collec owner collec;

/*
 * connexion a la base talend, avec l'utilisateur talend, en localhost,
 * depuis psql
 */
\c "dbname=collec user=collec password=collecPassword host=localhost"

/*
 * Creation des tables dans le schema gacl
 */
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

insert into aclappli (aclappli_id, appli) values (1, 'col');
insert into aclaco (aclaco_id, aclappli_id, aco) values (1, 1, 'admin');
insert into acllogin (acllogin_id, login, logindetail) values (1, 'admin', 'admin');
insert into aclgroup (aclgroup_id, groupe) values (1, 'admin');
insert into acllogingroup (acllogin_id, aclgroup_id) values (1, 1);
insert into aclacl (aclaco_id, aclgroup_id) values (1, 1);
/*
 * ajout des autres droits necessaires dans l'application
 */
insert into aclaco (aclaco_id, aclappli_id, aco) 
values 
(2, 1, 'param'),
(3, 1, 'projet'),
(4, 1, 'gestion'),
(5, 1, 'consult');

insert into aclgroup (aclgroup_id, groupe, aclgroup_id_parent) 
values 
(2, 'consult', null),
(3, 'gestion', 2),
(4, 'projet', 3),
(5, 'param', 4);

insert into aclacl (aclaco_id, aclgroup_id)
values 
(2, 5),
(3, 4),
(4, 3),
(5, 2);

insert into acllogingroup (acllogin_id, aclgroup_id)
values
(1, 5);

/*
 * Creation de la table des logins
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
ALTER TABLE  logingestion
    ADD CONSTRAINT pk_logingestion PRIMARY KEY (id);
	
CREATE SEQUENCE seq_logingestion_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 999999
    CACHE 1;

ALTER TABLE logingestion ALTER COLUMN id SET DEFAULT nextval('seq_logingestion_id'::regclass);

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
COMMENT ON TABLE log IS 'Liste des connexions ou des actions enregistrées';
COMMENT ON COLUMN log.log_date IS 'Heure de connexion';
COMMENT ON COLUMN log.commentaire IS 'Donnees complementaires enregistrees';
comment on column log.ipaddress is 'Adresse IP du client';

ALTER SEQUENCE log_log_id_seq OWNED BY log.log_id;

CREATE INDEX log_date_idx
 ON log
 ( log_date );

CREATE INDEX log_login_idx
 ON log
 ( login );

/*
 * Mise a jour des compteurs pour les tables de gestion des droits
 */
 
select setval('seq_logingestion_id', (select max(id) from logingestion));
select setval('aclappli_aclappli_id_seq', (select max(aclappli_id) from aclappli));
select setval('aclaco_aclaco_id_seq', (select max(aclaco_id) from aclaco));
select setval('acllogin_acllogin_id_seq', (select max(acllogin_id) from acllogin));
select setval('aclgroup_aclgroup_id_seq', (select max(aclgroup_id) from aclgroup));

/*
 * Creation des tables dans le schema col
 */

create schema col;
set search_path = col;

create or replace view "aclgroup" as select * from "gacl"."aclgroup";

CREATE SEQUENCE "booking_booking_id_seq";

CREATE TABLE "booking" (
                "booking_id" INTEGER NOT NULL DEFAULT nextval('"booking_booking_id_seq"'),
                "uid" INTEGER NOT NULL,
                "booking_date" TIMESTAMP NOT NULL,
                "date_from" TIMESTAMP NOT NULL,
                "date_to" TIMESTAMP NOT NULL,
                "booking_comment" VARCHAR,
                "booking_login" VARCHAR NOT NULL,
                CONSTRAINT "booking_pk" PRIMARY KEY ("booking_id")
);
COMMENT ON TABLE "booking" IS 'Table des réservations d''objets';
COMMENT ON COLUMN "booking"."booking_date" IS 'Date de la réservation';
COMMENT ON COLUMN "booking"."date_from" IS 'Date-heure de début de la réservation';
COMMENT ON COLUMN "booking"."date_to" IS 'Date-heure de fin de la réservation';
COMMENT ON COLUMN "booking"."booking_comment" IS 'Commentaire';
COMMENT ON COLUMN "booking"."booking_login" IS 'Compte ayant réalisé la réservation';


ALTER SEQUENCE "booking_booking_id_seq" OWNED BY "booking"."booking_id";

CREATE SEQUENCE "container_container_id_seq";

CREATE TABLE "container" (
                "container_id" INTEGER NOT NULL DEFAULT nextval('"container_container_id_seq"'),
                "uid" INTEGER NOT NULL,
                "container_type_id" INTEGER NOT NULL,
                CONSTRAINT "container_pk" PRIMARY KEY ("container_id")
);
COMMENT ON TABLE "container" IS 'Liste des conteneurs d''échantillon';


ALTER SEQUENCE "container_container_id_seq" OWNED BY "container"."container_id";

CREATE SEQUENCE "container_family_container_family_id_seq";

CREATE TABLE "container_family" (
                "container_family_id" INTEGER NOT NULL DEFAULT nextval('"container_family_container_family_id_seq"'),
                "container_family_name" VARCHAR NOT NULL,
                "is_movable" BOOLEAN DEFAULT true NOT NULL,
                CONSTRAINT "container_family_pk" PRIMARY KEY ("container_family_id")
);
COMMENT ON TABLE "container_family" IS 'Famille générique des conteneurs';
COMMENT ON COLUMN "container_family"."is_movable" IS 'Indique si la famille de conteneurs est déplçable facilement ou non (éprouvette : oui, armoire : non)';


ALTER SEQUENCE "container_family_container_family_id_seq" OWNED BY "container_family"."container_family_id";

CREATE SEQUENCE "container_type_container_type_id_seq";

CREATE TABLE "container_type" (
                "container_type_id" INTEGER NOT NULL DEFAULT nextval('"container_type_container_type_id_seq"'),
                "container_type_name" VARCHAR NOT NULL,
                "container_family_id" INTEGER NOT NULL,
                "storage_condition_id" INTEGER,
                "label_id" INTEGER,
                "container_type_description" VARCHAR,
                "storage_product" VARCHAR,
                "clp_classification" VARCHAR,
                CONSTRAINT "container_type_pk" PRIMARY KEY ("container_type_id")
);
COMMENT ON TABLE "container_type" IS 'Table des types de conteneurs';
COMMENT ON COLUMN "container_type"."container_type_description" IS 'Description longue';
COMMENT ON COLUMN "container_type"."storage_product" IS 'Produit utilisé pour le stockage (formol, alcool...)';
COMMENT ON COLUMN "container_type"."clp_classification" IS 'Classification du risque conformément à la directive européenne CLP';


ALTER SEQUENCE "container_type_container_type_id_seq" OWNED BY "container_type"."container_type_id";

CREATE SEQUENCE "document_document_id_seq";

CREATE TABLE "document" (
                "document_id" INTEGER NOT NULL DEFAULT nextval('"document_document_id_seq"'),
                "uid" INTEGER NOT NULL,
                "mime_type_id" INTEGER NOT NULL,
                "document_import_date" TIMESTAMP NOT NULL,
                "document_name" VARCHAR NOT NULL,
                "document_description" VARCHAR,
                "data" BYTEA,
                "thumbnail" BYTEA,
                "size" INTEGER,
                "document_creation_date" TIMESTAMP,
                CONSTRAINT "document_pk" PRIMARY KEY ("document_id")
);
COMMENT ON TABLE "document" IS 'Documents numériques rattachés à un poisson ou à un événement';
COMMENT ON COLUMN "document"."document_import_date" IS 'Date d''import dans la base de données';
COMMENT ON COLUMN "document"."document_name" IS 'Nom d''origine du document';
COMMENT ON COLUMN "document"."document_description" IS 'Description libre du document';
COMMENT ON COLUMN "document"."data" IS 'Contenu du document';
COMMENT ON COLUMN "document"."thumbnail" IS 'Vignette au format PNG (documents pdf, jpg ou png)';
COMMENT ON COLUMN "document"."size" IS 'Taille du fichier téléchargé';
COMMENT ON COLUMN "document"."document_creation_date" IS 'Date de création du document (date de prise de vue de la photo)';


ALTER SEQUENCE "document_document_id_seq" OWNED BY "document"."document_id";

CREATE SEQUENCE "event_event_id_seq";

CREATE TABLE "event" (
                "event_id" INTEGER NOT NULL DEFAULT nextval('"event_event_id_seq"'),
                "uid" INTEGER NOT NULL,
                "event_date" TIMESTAMP NOT NULL,
                "event_type_id" INTEGER NOT NULL,
                "still_available" VARCHAR,
                "event_comment" VARCHAR,
                CONSTRAINT "event_pk" PRIMARY KEY ("event_id")
);
COMMENT ON TABLE "event" IS 'Table des événements';
COMMENT ON COLUMN "event"."event_date" IS 'Date / heure de l''événement';
COMMENT ON COLUMN "event"."still_available" IS 'définit ce qu''il reste de disponible dans l''objet';


ALTER SEQUENCE "event_event_id_seq" OWNED BY "event"."event_id";

CREATE SEQUENCE "event_type_event_type_id_seq";

CREATE TABLE "event_type" (
                "event_type_id" INTEGER NOT NULL DEFAULT nextval('"event_type_event_type_id_seq"'),
                "event_type_name" VARCHAR NOT NULL,
                "is_sample" BOOLEAN DEFAULT false NOT NULL,
                "is_container" BOOLEAN DEFAULT false NOT NULL,
                CONSTRAINT "event_type_pk" PRIMARY KEY ("event_type_id")
);
COMMENT ON TABLE "event_type" IS 'Types d''événement';
COMMENT ON COLUMN "event_type"."is_sample" IS 'L''événement s''applique aux échantillons';
COMMENT ON COLUMN "event_type"."is_container" IS 'L''événement s''applique aux conteneurs';


ALTER SEQUENCE "event_type_event_type_id_seq" OWNED BY "event_type"."event_type_id";

CREATE SEQUENCE "identifier_type_identifier_type_id_seq";

CREATE TABLE "identifier_type" (
                "identifier_type_id" INTEGER NOT NULL DEFAULT nextval('"identifier_type_identifier_type_id_seq"'),
                "identifier_type_name" VARCHAR NOT NULL,
                "identifier_type_code" VARCHAR NOT NULL,
                CONSTRAINT "identifier_type_pk" PRIMARY KEY ("identifier_type_id")
);
COMMENT ON TABLE "identifier_type" IS 'Table des types d''identifiants';
COMMENT ON COLUMN "identifier_type"."identifier_type_name" IS 'Nom textuel de l''identifiant';
COMMENT ON COLUMN "identifier_type"."identifier_type_code" IS 'Code utilisé pour la génération des étiquettes';


ALTER SEQUENCE "identifier_type_identifier_type_id_seq" OWNED BY "identifier_type"."identifier_type_id";

CREATE SEQUENCE "label_label_id_seq";

CREATE TABLE "label" (
                "label_id" INTEGER NOT NULL DEFAULT nextval('"label_label_id_seq"'),
                "label_name" VARCHAR NOT NULL,
                "label_xsl" VARCHAR NOT NULL,
                "label_fields" VARCHAR DEFAULT 'uid,id,clp,db' NOT NULL,
                CONSTRAINT "label_pk" PRIMARY KEY ("label_id")
);
COMMENT ON TABLE "label" IS 'Table des modèles d''étiquettes';
COMMENT ON COLUMN "label"."label_name" IS 'Nom du modèle';
COMMENT ON COLUMN "label"."label_xsl" IS 'Contenu du fichier XSL utilisé pour la transformation FOP (https://xmlgraphics.apache.org/fop/)';
COMMENT ON COLUMN "label"."label_fields" IS 'Liste des champs à intégrer dans le QRCODE, séparés par une virgule';


ALTER SEQUENCE "label_label_id_seq" OWNED BY "label"."label_id";

CREATE SEQUENCE "metadata_attribute_metadata_attribute_id_seq";

CREATE TABLE "metadata_attribute" (
                "metadata_attribute_id" INTEGER NOT NULL DEFAULT nextval('"metadata_attribute_metadata_attribute_id_seq"'),
                "metadata_set_id" INTEGER NOT NULL,
                "metadata_schema_id" INTEGER,
                "metadata_name" VARCHAR NOT NULL,
                "metadata_code" VARCHAR,
                "metadata_order" INTEGER DEFAULT 1 NOT NULL,
                "metadata_type" VARCHAR DEFAULT 'varchar' NOT NULL,
                "metadata_defaultvalue" VARCHAR,
                "metadata_measure_unit" VARCHAR,
                "metadata_multivalue" BOOLEAN DEFAULT false NOT NULL,
                "metadata_enum" VARCHAR,
                CONSTRAINT "metadata_attribute_pk" PRIMARY KEY ("metadata_attribute_id")
);
COMMENT ON TABLE "metadata_attribute" IS 'Table des attributs rattachés à un jeu de métadonnées';
COMMENT ON COLUMN "metadata_attribute"."metadata_name" IS 'Nom de la métadonnée (creator, name...)';
COMMENT ON COLUMN "metadata_attribute"."metadata_code" IS 'Code normalisé de la métadonnée (ex : dcterms:creator)';
COMMENT ON COLUMN "metadata_attribute"."metadata_order" IS 'Ordre d''affichage des informations dans la grille de saisie';
COMMENT ON COLUMN "metadata_attribute"."metadata_measure_unit" IS 'Unité de mesure utilisée';
COMMENT ON COLUMN "metadata_attribute"."metadata_enum" IS 'Liste des valeurs possibles, séparées par ;';


ALTER SEQUENCE "metadata_attribute_metadata_attribute_id_seq" OWNED BY "metadata_attribute"."metadata_attribute_id";

CREATE SEQUENCE "metadata_schema_metadata_schema_id_seq";

CREATE TABLE "metadata_schema" (
                "metadata_schema_id" INTEGER NOT NULL DEFAULT nextval('"metadata_schema_metadata_schema_id_seq"'),
                "metadata_schema_name" VARCHAR NOT NULL,
                "metadata_schema_short_name" VARCHAR,
                "uri" VARCHAR,
                CONSTRAINT "metadata_schema_pk" PRIMARY KEY ("metadata_schema_id")
);
COMMENT ON TABLE "metadata_schema" IS 'Liste des schémas de métadonnées utilisés';
COMMENT ON COLUMN "metadata_schema"."metadata_schema_name" IS 'Nom complet du schéma';
COMMENT ON COLUMN "metadata_schema"."metadata_schema_short_name" IS 'abréviation habituelle (CC, DC...)';
COMMENT ON COLUMN "metadata_schema"."uri" IS 'Adresse URI d''accès à la description du schéma';


ALTER SEQUENCE "metadata_schema_metadata_schema_id_seq" OWNED BY "metadata_schema"."metadata_schema_id";

CREATE SEQUENCE "metadata_set_metadata_set_id_seq";

CREATE TABLE "metadata_set" (
                "metadata_set_id" INTEGER NOT NULL DEFAULT nextval('"metadata_set_metadata_set_id_seq"'),
                "metadata_set_name" VARCHAR NOT NULL,
                CONSTRAINT "metadata_set_pk" PRIMARY KEY ("metadata_set_id")
);
COMMENT ON TABLE "metadata_set" IS 'Jeu de métadonnées permettant de décrire précisément un échantillon';


ALTER SEQUENCE "metadata_set_metadata_set_id_seq" OWNED BY "metadata_set"."metadata_set_id";

CREATE SEQUENCE "mime_type_mime_type_id_seq";

CREATE TABLE "mime_type" (
                "mime_type_id" INTEGER NOT NULL DEFAULT nextval('"mime_type_mime_type_id_seq"'),
                "extension" VARCHAR NOT NULL,
                "content_type" VARCHAR NOT NULL,
                CONSTRAINT "mime_type_pk" PRIMARY KEY ("mime_type_id")
);
COMMENT ON TABLE "mime_type" IS 'Types mime des fichiers importés';
COMMENT ON COLUMN "mime_type"."extension" IS 'Extension du fichier correspondant';
COMMENT ON COLUMN "mime_type"."content_type" IS 'type mime officiel';


ALTER SEQUENCE "mime_type_mime_type_id_seq" OWNED BY "mime_type"."mime_type_id";

CREATE SEQUENCE "movement_type_movement_type_id_seq";

CREATE TABLE "movement_type" (
                "movement_type_id" INTEGER NOT NULL DEFAULT nextval('"movement_type_movement_type_id_seq"'),
                "movement_type_name" VARCHAR NOT NULL,
                CONSTRAINT "movement_type_pk" PRIMARY KEY ("movement_type_id")
);
COMMENT ON TABLE "movement_type" IS 'Type de mouvement';


ALTER SEQUENCE "movement_type_movement_type_id_seq" OWNED BY "movement_type"."movement_type_id";

CREATE SEQUENCE "multiple_type_multiple_type_id_seq";

CREATE TABLE "multiple_type" (
                "multiple_type_id" INTEGER NOT NULL DEFAULT nextval('"multiple_type_multiple_type_id_seq"'),
                "multiple_type_name" VARCHAR NOT NULL,
                CONSTRAINT "multiple_type_pk" PRIMARY KEY ("multiple_type_id")
);
COMMENT ON TABLE "multiple_type" IS 'Table des types de contenus multiples';


ALTER SEQUENCE "multiple_type_multiple_type_id_seq" OWNED BY "multiple_type"."multiple_type_id";

CREATE SEQUENCE "object_uid_seq";

CREATE TABLE "object" (
                "uid" INTEGER NOT NULL DEFAULT nextval('"object_uid_seq"'),
                "identifier" VARCHAR,
                "object_status_id" INTEGER,
                "wgs84_x" DOUBLE PRECISION,
                "wgs84_y" DOUBLE PRECISION,
                CONSTRAINT "object_pk" PRIMARY KEY ("uid")
);
COMMENT ON TABLE "object" IS 'Table des objets
Contient les identifiants génériques';
COMMENT ON COLUMN "object"."identifier" IS 'Identifiant fourni le cas échéant par le projet';
COMMENT ON COLUMN "object"."wgs84_x" IS 'Longitude GPS, en valeur décimale';
COMMENT ON COLUMN "object"."wgs84_y" IS 'Latitude GPS, en décimal';


ALTER SEQUENCE "object_uid_seq" OWNED BY "object"."uid";

CREATE SEQUENCE "object_identifier_object_identifier_id_seq";

CREATE TABLE "object_identifier" (
                "object_identifier_id" INTEGER NOT NULL DEFAULT nextval('"object_identifier_object_identifier_id_seq"'),
                "uid" INTEGER NOT NULL,
                "identifier_type_id" INTEGER NOT NULL,
                "object_identifier_value" VARCHAR NOT NULL,
                CONSTRAINT "object_identifier_pk" PRIMARY KEY ("object_identifier_id")
);
COMMENT ON TABLE "object_identifier" IS 'Table des identifiants complémentaires normalisés';
COMMENT ON COLUMN "object_identifier"."object_identifier_value" IS 'Valeur de l''identifiant';


ALTER SEQUENCE "object_identifier_object_identifier_id_seq" OWNED BY "object_identifier"."object_identifier_id";

CREATE SEQUENCE "object_status_object_status_id_seq";

CREATE TABLE "object_status" (
                "object_status_id" INTEGER NOT NULL DEFAULT nextval('"object_status_object_status_id_seq"'),
                "object_status_name" VARCHAR NOT NULL,
                CONSTRAINT "object_status_pk" PRIMARY KEY ("object_status_id")
);
COMMENT ON TABLE "object_status" IS 'Table des statuts possibles des objets';


ALTER SEQUENCE "object_status_object_status_id_seq" OWNED BY "object_status"."object_status_id";

CREATE SEQUENCE "operation_operation_id_seq";

CREATE TABLE "operation" (
                "operation_id" INTEGER NOT NULL DEFAULT nextval('"operation_operation_id_seq"'),
                "protocol_id" INTEGER NOT NULL,
                "operation_name" VARCHAR NOT NULL,
                "operation_order" INTEGER,
                CONSTRAINT "operation_pk" PRIMARY KEY ("operation_id")
);
COMMENT ON COLUMN "operation"."operation_order" IS 'Ordre de réalisation de l''opération dans le protocole';


ALTER SEQUENCE "operation_operation_id_seq" OWNED BY "operation"."operation_id";

CREATE SEQUENCE "project_project_id_seq";

CREATE TABLE "project" (
                "project_id" INTEGER NOT NULL DEFAULT nextval('"project_project_id_seq"'),
                "project_name" VARCHAR NOT NULL,
                CONSTRAINT "project_pk" PRIMARY KEY ("project_id")
);
COMMENT ON TABLE "project" IS 'Table des projets';


ALTER SEQUENCE "project_project_id_seq" OWNED BY "project"."project_id";

CREATE TABLE "project_group" (
                "project_id" INTEGER NOT NULL,
                "aclgroup_id" INTEGER NOT NULL,
                CONSTRAINT "project_group_pk" PRIMARY KEY ("project_id", "aclgroup_id")
);
COMMENT ON TABLE "project_group" IS 'Table des autorisations d''accès à un projet';


CREATE SEQUENCE "protocol_protocol_id_seq";

CREATE TABLE "protocol" (
                "protocol_id" INTEGER NOT NULL DEFAULT nextval('"protocol_protocol_id_seq"'),
                "protocol_name" VARCHAR NOT NULL,
                "protocol_file" BYTEA,
                "protocol_year" SMALLINT,
                "protocol_version" VARCHAR DEFAULT 'v1.0' NOT NULL,
                CONSTRAINT "protocol_pk" PRIMARY KEY ("protocol_id")
);
COMMENT ON COLUMN "protocol"."protocol_file" IS 'Description PDF du protocole';
COMMENT ON COLUMN "protocol"."protocol_year" IS 'Année du protocole';
COMMENT ON COLUMN "protocol"."protocol_version" IS 'Version du protocole';


ALTER SEQUENCE "protocol_protocol_id_seq" OWNED BY "protocol"."protocol_id";

CREATE SEQUENCE "sample_sample_id_seq";

CREATE TABLE "sample" (
                "sample_id" INTEGER NOT NULL DEFAULT nextval('"sample_sample_id_seq"'),
                "uid" INTEGER NOT NULL,
                "project_id" INTEGER NOT NULL,
                "sample_type_id" INTEGER NOT NULL,
                "sample_creation_date" TIMESTAMP NOT NULL,
                "sample_date" TIMESTAMP,
                "parent_sample_id" INTEGER,
                "multiple_value" DOUBLE PRECISION,
                CONSTRAINT "sample_pk" PRIMARY KEY ("sample_id")
);
COMMENT ON TABLE "sample" IS 'Table des échantillons';
COMMENT ON COLUMN "sample"."sample_creation_date" IS 'Date de création de l''enregistrement dans la base de données';
COMMENT ON COLUMN "sample"."sample_date" IS 'Date de création de l''échantillon physique';
COMMENT ON COLUMN "sample"."multiple_value" IS 'Nombre initial de sous-échantillons';


ALTER SEQUENCE "sample_sample_id_seq" OWNED BY "sample"."sample_id";

CREATE TABLE "sample_metadata" (
                "sample_id" INTEGER NOT NULL,
                "data" json NOT NULL,
                CONSTRAINT "sample_metadata_pk" PRIMARY KEY ("sample_id")
);
COMMENT ON COLUMN "sample_metadata"."data" IS 'Champ JSONB pour stockage des données spécifiques de l''échantillon';


CREATE SEQUENCE "sample_type_sample_type_id_seq";

CREATE TABLE "sample_type" (
                "sample_type_id" INTEGER NOT NULL DEFAULT nextval('"sample_type_sample_type_id_seq"'),
                "sample_type_name" VARCHAR NOT NULL,
                "container_type_id" INTEGER,
                "operation_id" INTEGER,
                "metadata_set_id" INTEGER,
                "metadata_set_id_second" INTEGER,
                "multiple_type_id" INTEGER,
                "multiple_unit" VARCHAR,
                CONSTRAINT "sample_type_pk" PRIMARY KEY ("sample_type_id")
);
COMMENT ON TABLE "sample_type" IS 'Types d''échantillons';
COMMENT ON COLUMN "sample_type"."metadata_set_id_second" IS 'Second jeu de métadonnées rattaché au type';
COMMENT ON COLUMN "sample_type"."multiple_unit" IS 'Unité caractérisant le sous-échantillon';


ALTER SEQUENCE "sample_type_sample_type_id_seq" OWNED BY "sample_type"."sample_type_id";

CREATE SEQUENCE "storage_storage_id_seq";

CREATE TABLE "storage" (
                "storage_id" INTEGER NOT NULL DEFAULT nextval('"storage_storage_id_seq"'),
                "uid" INTEGER NOT NULL,
                "container_id" INTEGER,
                "movement_type_id" INTEGER NOT NULL,
                "storage_reason_id" INTEGER,
                "storage_date" TIMESTAMP NOT NULL,
                "storage_location" VARCHAR,
                "login" VARCHAR NOT NULL,
                "storage_comment" VARCHAR,
                CONSTRAINT "storage_pk" PRIMARY KEY ("storage_id")
);
COMMENT ON TABLE "storage" IS 'Gestion du stockage des échantillons';
COMMENT ON COLUMN "storage"."storage_date" IS 'Date/heure du mouvement';
COMMENT ON COLUMN "storage"."storage_location" IS 'Emplacement de l''échantillon dans le conteneur';
COMMENT ON COLUMN "storage"."login" IS 'Nom de l''utilisateur ayant réalisé l''opération';
COMMENT ON COLUMN "storage"."storage_comment" IS 'Commentaire';


ALTER SEQUENCE "storage_storage_id_seq" OWNED BY "storage"."storage_id";

CREATE SEQUENCE "storage_condition_storage_condition_id_seq";

CREATE TABLE "storage_condition" (
                "storage_condition_id" INTEGER NOT NULL DEFAULT nextval('"storage_condition_storage_condition_id_seq"'),
                "storage_condition_name" VARCHAR NOT NULL,
                CONSTRAINT "storage_condition_pk" PRIMARY KEY ("storage_condition_id")
);
COMMENT ON TABLE "storage_condition" IS 'Condition de stockage';


ALTER SEQUENCE "storage_condition_storage_condition_id_seq" OWNED BY "storage_condition"."storage_condition_id";

CREATE SEQUENCE "storage_reason_storage_reason_id_seq";

CREATE TABLE "storage_reason" (
                "storage_reason_id" INTEGER NOT NULL DEFAULT nextval('"storage_reason_storage_reason_id_seq"'),
                "storage_reason_name" VARCHAR NOT NULL,
                CONSTRAINT "storage_reason_pk" PRIMARY KEY ("storage_reason_id")
);
COMMENT ON TABLE "storage_reason" IS 'Table des raisons de stockage/déstockage';


ALTER SEQUENCE "storage_reason_storage_reason_id_seq" OWNED BY "storage_reason"."storage_reason_id";

CREATE SEQUENCE "subsample_subsample_id_seq";

CREATE TABLE "subsample" (
                "subsample_id" INTEGER NOT NULL DEFAULT nextval('"subsample_subsample_id_seq"'),
                "sample_id" INTEGER NOT NULL,
                "subsample_date" TIMESTAMP NOT NULL,
                "movement_type_id" INTEGER NOT NULL,
                "subsample_quantity" DOUBLE PRECISION,
                "subsample_comment" VARCHAR,
                "subsample_login" VARCHAR NOT NULL,
                CONSTRAINT "subsample_pk" PRIMARY KEY ("subsample_id")
);
COMMENT ON TABLE "subsample" IS 'Table des prélèvements et restitutions de sous-échantillons';
COMMENT ON COLUMN "subsample"."subsample_date" IS 'Date/heure de l''opération';
COMMENT ON COLUMN "subsample"."subsample_quantity" IS 'Quantité prélevée ou restituée';
COMMENT ON COLUMN "subsample"."subsample_login" IS 'Login de l''utilisateur ayant réalisé l''opération';


ALTER SEQUENCE "subsample_subsample_id_seq" OWNED BY "subsample"."subsample_id";

ALTER TABLE "storage" ADD CONSTRAINT "container_storage_fk"
FOREIGN KEY ("container_id")
REFERENCES "container" ("container_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "container_type" ADD CONSTRAINT "container_family_container_type_fk"
FOREIGN KEY ("container_family_id")
REFERENCES "container_family" ("container_family_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "container" ADD CONSTRAINT "container_type_container_fk"
FOREIGN KEY ("container_type_id")
REFERENCES "container_type" ("container_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "sample_type" ADD CONSTRAINT "container_type_sample_type_fk"
FOREIGN KEY ("container_type_id")
REFERENCES "container_type" ("container_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "event" ADD CONSTRAINT "event_type_event_fk"
FOREIGN KEY ("event_type_id")
REFERENCES "event_type" ("event_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "object_identifier" ADD CONSTRAINT "identifier_type_object_identifier_fk"
FOREIGN KEY ("identifier_type_id")
REFERENCES "identifier_type" ("identifier_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "container_type" ADD CONSTRAINT "label_container_type_fk"
FOREIGN KEY ("label_id")
REFERENCES "label" ("label_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "metadata_attribute" ADD CONSTRAINT "metadata_schema_metadata_attribute_fk"
FOREIGN KEY ("metadata_schema_id")
REFERENCES "metadata_schema" ("metadata_schema_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "metadata_attribute" ADD CONSTRAINT "metadata_set_metadata_attribute_fk"
FOREIGN KEY ("metadata_set_id")
REFERENCES "metadata_set" ("metadata_set_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "sample_type" ADD CONSTRAINT "metadata_set_sample_type_fk"
FOREIGN KEY ("metadata_set_id")
REFERENCES "metadata_set" ("metadata_set_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "sample_type" ADD CONSTRAINT "metadata_set_sample_type_fk1"
FOREIGN KEY ("metadata_set_id_second")
REFERENCES "metadata_set" ("metadata_set_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "document" ADD CONSTRAINT "mime_type_document_fk"
FOREIGN KEY ("mime_type_id")
REFERENCES "mime_type" ("mime_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "storage" ADD CONSTRAINT "movement_type_storage_fk"
FOREIGN KEY ("movement_type_id")
REFERENCES "movement_type" ("movement_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "subsample" ADD CONSTRAINT "movement_type_subsample_fk"
FOREIGN KEY ("movement_type_id")
REFERENCES "movement_type" ("movement_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "sample_type" ADD CONSTRAINT "multiple_type_sample_type_fk"
FOREIGN KEY ("multiple_type_id")
REFERENCES "multiple_type" ("multiple_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "booking" ADD CONSTRAINT "object_booking_fk"
FOREIGN KEY ("uid")
REFERENCES "object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "container" ADD CONSTRAINT "object_container_fk"
FOREIGN KEY ("uid")
REFERENCES "object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "document" ADD CONSTRAINT "object_document_fk"
FOREIGN KEY ("uid")
REFERENCES "object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "event" ADD CONSTRAINT "object_event_fk"
FOREIGN KEY ("uid")
REFERENCES "object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "object_identifier" ADD CONSTRAINT "object_object_identifier_fk"
FOREIGN KEY ("uid")
REFERENCES "object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "sample" ADD CONSTRAINT "object_sample_fk"
FOREIGN KEY ("uid")
REFERENCES "object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "storage" ADD CONSTRAINT "object_storage_fk"
FOREIGN KEY ("uid")
REFERENCES "object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "object" ADD CONSTRAINT "object_status_object_fk"
FOREIGN KEY ("object_status_id")
REFERENCES "object_status" ("object_status_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "sample_type" ADD CONSTRAINT "operation_sample_type_fk"
FOREIGN KEY ("operation_id")
REFERENCES "operation" ("operation_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "project_group" ADD CONSTRAINT "project_project_group_fk"
FOREIGN KEY ("project_id")
REFERENCES "project" ("project_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "sample" ADD CONSTRAINT "project_sample_fk"
FOREIGN KEY ("project_id")
REFERENCES "project" ("project_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "operation" ADD CONSTRAINT "protocol_operation_fk"
FOREIGN KEY ("protocol_id")
REFERENCES "protocol" ("protocol_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "sample" ADD CONSTRAINT "sample_sample_fk"
FOREIGN KEY ("parent_sample_id")
REFERENCES "sample" ("sample_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "sample_metadata" ADD CONSTRAINT "sample_sample_metadata_fk"
FOREIGN KEY ("sample_id")
REFERENCES "sample" ("sample_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "subsample" ADD CONSTRAINT "sample_subsample_fk"
FOREIGN KEY ("sample_id")
REFERENCES "sample" ("sample_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "sample" ADD CONSTRAINT "sample_type_sample_fk"
FOREIGN KEY ("sample_type_id")
REFERENCES "sample_type" ("sample_type_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "container_type" ADD CONSTRAINT "storage_condition_container_type_fk"
FOREIGN KEY ("storage_condition_id")
REFERENCES "storage_condition" ("storage_condition_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE "storage" ADD CONSTRAINT "storage_reason_storage_fk"
FOREIGN KEY ("storage_reason_id")
REFERENCES "storage_reason" ("storage_reason_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

create or replace view last_movement as (
SELECT s.uid,
    s.storage_id,
    s.storage_date,
    s.movement_type_id,
    s.container_id,
    c.uid AS container_uid
   FROM col.storage s
    left outer JOIN col.container c USING (container_id)
   where s.storage_id = (
   select st.storage_id from storage st
   where s.uid = st.uid 
    order by st.storage_date desc limit 1
    )
      );
      
comment on view last_movement is 'Dernier mouvement d''un objet';


insert into movement_type (movement_type_id, movement_type_name) 
values 
(1, 'Entrée/Entry'),
(2, 'Sortie/Exit');

INSERT INTO mime_type(  mime_type_id,  content_type,  extension)
 VALUES
 (  1,  'application/pdf',  'pdf'),
 (  2,  'application/zip',  'zip'),
 (  3,  'audio/mpeg',  'mp3'),
 (  4,  'image/jpeg',  'jpg'),
 (  5,  'image/jpeg',  'jpeg'),
 (  6,  'image/png',  'png'),
 (  7,  'image/tiff',  'tiff'),
 (  9,  'application/vnd.oasis.opendocument.text',  'odt'),
 (  10,  'application/vnd.oasis.opendocument.spreadsheet',  'ods'),
 (  11,  'application/vnd.ms-excel',  'xls'),
 (  12,  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',  'xlsx'),
 (  13,  'application/msword',  'doc'),
 (  14,  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',  'docx'),
 (  8,  'text/csv',  'csv');
 
create or replace view last_photo as (
select d.document_id, d.uid
from document d
where document_id = (
select d1.document_id from document d1
where d1.mime_type_id in (4,5,6) 
and d.uid = d1.uid
order by d1.document_creation_date desc, d1.document_import_date desc, d1.document_id desc
limit 1)
);

CREATE OR REPLACE VIEW last_movement
AS 
 SELECT s.uid, s.storage_id, s.storage_date, s.movement_type_id, s.container_id, c.uid AS container_uid
   FROM storage s
   JOIN container c USING (container_id)
  WHERE s.storage_date = (( SELECT max(st1.storage_date) AS max
      FROM storage st1
     WHERE st1.uid = s.uid));
     
CREATE OR REPLACE VIEW v_object_identifier
AS 
 SELECT object_identifier.uid, array_to_string(array_agg((identifier_type.identifier_type_code::text || ':'::text) || object_identifier.object_identifier_value::text ORDER BY identifier_type.identifier_type_code, object_identifier.object_identifier_value), ','::text) AS identifiers
   FROM object_identifier
   JOIN identifier_type USING (identifier_type_id)
  GROUP BY object_identifier.uid
  ORDER BY object_identifier.uid;
  
/*
 * Ajout de donnees par defaut
 */
 INSERT INTO label
(
  label_name,
  label_xsl,
  label_fields
)
VALUES
(
  'Exemple - ne pas utiliser',
  '<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="objects">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="label"
              page-height="5cm" page-width="10cm" margin-left="0.5cm" margin-top="0.5cm" margin-bottom="0cm" margin-right="0.5cm">  
              <fo:region-body/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      
      <fo:page-sequence master-reference="label">
         <fo:flow flow-name="xsl-region-body">        
          <fo:block>
          <xsl:apply-templates select="object" />
          </fo:block>

        </fo:flow>
      </fo:page-sequence>
    </fo:root>
   </xsl:template>
  <xsl:template match="object">

  <fo:table table-layout="fixed" border-collapse="collapse"  border-style="none" width="8cm" keep-together.within-page="always">
  <fo:table-column column-width="4cm"/>
  <fo:table-column column-width="4cm" />
 <fo:table-body  border-style="none" >
 	<fo:table-row>
  		<fo:table-cell> 
  		<fo:block>
  		<fo:external-graphic>
      <xsl:attribute name="src">
             <xsl:value-of select="concat(uid,''.png'')" />
       </xsl:attribute>
       <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
       <xsl:attribute name="height">4cm</xsl:attribute>
        <xsl:attribute name="content-width">4cm</xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
      
       </fo:external-graphic>
 		</fo:block>
   		</fo:table-cell>
  		<fo:table-cell>
<fo:block><fo:inline font-weight="bold">IRSTEA</fo:inline></fo:block>
  			<fo:block>uid:<fo:inline font-weight="bold"><xsl:value-of select="db"/>:<xsl:value-of select="uid"/></fo:inline></fo:block>
  			<fo:block>id:<fo:inline font-weight="bold"><xsl:value-of select="id"/></fo:inline></fo:block>
  			<fo:block>prj:<fo:inline font-weight="bold"><xsl:value-of select="prj"/></fo:inline></fo:block>
  			<fo:block>clp:<fo:inline font-weight="bold"><xsl:value-of select="clp"/></fo:inline></fo:block>
  		</fo:table-cell>
  	  	</fo:table-row>
  </fo:table-body>
  </fo:table>
   <fo:block page-break-after="always"/>

  </xsl:template>
</xsl:stylesheet>',
  'uid,id,clp,db,prj'
);
select setval('label_label_id_seq',(select max(label_id) from label)); 

/*
 * Tables de parametres generales
 */
 insert into container_family (container_family_id, container_family_name, is_movable)
 values 
 (1, 'Immobilier', false),
 (2, 'Mobilier', false);
 
select setval('container_family_container_family_id_seq', (select max(container_family_id) from container_family));
insert into container_type (container_type_name, container_family_id)
values 
('Site', 1),
('Bâtiment', 1),
('Pièce', 1),
('Armoire', 2),
('Congélateur', 2);

INSERT INTO event_type
(
  event_type_name,
  is_sample,
  is_container
)
VALUES
(  'Autre',  TRUE,  TRUE),
(  'Conteneur cassé',  FALSE,  TRUE),
(  'Échantillon détruit',  TRUE,  FALSE),
(  'Prélèvement pour analyse',  TRUE,  FALSE),
(  'Échantillon totalement analysé, détruit', TRUE,  FALSE);

INSERT INTO multiple_type (  multiple_type_name)
VALUES
(  'Unité'),
(  'Pourcentage'),
(  'Quantité ou volume'),
(  'Autre');

INSERT INTO object_status(  object_status_name)
VALUES
(  'État normal'),
(  'Objet pré-réservé pour usage ultérieur'),
(  'Objet détruit'),
(  'Echantillon vidé de tout contenu');

/*
 * ajouts version 1.0.5
 */
CREATE SEQUENCE "sampling_place_sampling_place_id_seq";

CREATE TABLE "sampling_place" (
                "sampling_place_id" INTEGER NOT NULL DEFAULT nextval('"sampling_place_sampling_place_id_seq"'),
                "sampling_place_name" VARCHAR NOT NULL,
                CONSTRAINT "sampling_place_pk" PRIMARY KEY ("sampling_place_id")
);
COMMENT ON TABLE "sampling_place" IS 'Table des lieux génériques d''échantillonnage';


ALTER SEQUENCE "sampling_place_sampling_place_id_seq" OWNED BY "sampling_place"."sampling_place_id";

alter table "sample" add column "sampling_place_id" integer;

ALTER TABLE "sample" ADD CONSTRAINT "sampling_place_sample_fk"
FOREIGN KEY ("sampling_place_id")
REFERENCES "sampling_place" ("sampling_place_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

alter table "sample" add column dbuid_origin varchar;
comment on column "sample".dbuid_origin is 'référence utilisée dans la base de données d''origine, sous la forme db:uid
Utilisé pour lire les étiquettes créées dans d''autres instances';

/*
 * Feature dbversion_verify - 29/05/2017
 */
CREATE SEQUENCE "dbversion_dbversion_id_seq";

CREATE TABLE "dbversion" (
                "dbversion_id" INTEGER NOT NULL DEFAULT nextval('"dbversion_dbversion_id_seq"'),
                "dbversion_number" VARCHAR NOT NULL,
                "dbversion_date" TIMESTAMP NOT NULL,
                CONSTRAINT "dbversion_pk" PRIMARY KEY ("dbversion_id")
);
COMMENT ON TABLE "dbversion" IS 'Table des versions de la base de donnees';
COMMENT ON COLUMN "dbversion"."dbversion_number" IS 'Numero de la version';
COMMENT ON COLUMN "dbversion"."dbversion_date" IS 'Date de la version';


ALTER SEQUENCE "dbversion_dbversion_id_seq" OWNED BY "dbversion"."dbversion_id";

/*
 * fin du script
 */


/*
 * Derniere ligne systematique, a mettre a jour a chaque evolution (numero de version de la base de donnees)
 */
 
insert into dbversion(dbversion_number, dbversion_date) values ('dev 24-05-17', '2017-05-24');
