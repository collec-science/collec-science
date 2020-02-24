-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.9.2-beta
-- PostgreSQL version: 9.6
-- Project Site: pgmodeler.io
-- Model Author: ---


-- Database creation must be done outside a multicommand file.
-- These commands were put in this file only as a convenience.
-- -- object: collec | type: DATABASE --
-- -- DROP DATABASE IF EXISTS collec;
-- CREATE DATABASE collec
-- 	ENCODING = 'UTF8'
-- 	LC_COLLATE = 'fr_FR.UTF-8'
-- 	LC_CTYPE = 'fr_FR.UTF-8'
-- 	TABLESPACE = pg_default
-- 	OWNER = postgres;
-- -- ddl-end --
--
create schema if not exists col;

SET search_path = col,gacl;
-- ddl-end --

-- object: booking_booking_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS booking_booking_id_seq CASCADE;
CREATE SEQUENCE booking_booking_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: booking | type: TABLE --
-- DROP TABLE IF EXISTS booking CASCADE;
CREATE TABLE booking (
	booking_id integer NOT NULL DEFAULT nextval('booking_booking_id_seq'::regclass),
	uid integer NOT NULL,
	booking_date timestamp NOT NULL,
	date_from timestamp NOT NULL,
	date_to timestamp NOT NULL,
	booking_comment character varying,
	booking_login character varying NOT NULL,
	CONSTRAINT booking_pk PRIMARY KEY (booking_id)

);
-- ddl-end --
COMMENT ON TABLE booking IS 'Table des réservations d''objets';
-- ddl-end --
COMMENT ON COLUMN booking.booking_date IS 'Date de la réservation';
-- ddl-end --
COMMENT ON COLUMN booking.date_from IS 'Date-heure de début de la réservation';
-- ddl-end --
COMMENT ON COLUMN booking.date_to IS 'Date-heure de fin de la réservation';
-- ddl-end --
COMMENT ON COLUMN booking.booking_comment IS 'Commentaire';
-- ddl-end --
COMMENT ON COLUMN booking.booking_login IS 'Compte ayant réalisé la réservation';
-- ddl-end --


-- object: project_project_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS project_project_id_seq CASCADE;
CREATE SEQUENCE project_project_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: collection_group | type: TABLE --
-- DROP TABLE IF EXISTS collection_group CASCADE;
CREATE TABLE collection_group (
	collection_id integer NOT NULL,
	aclgroup_id integer NOT NULL,
	CONSTRAINT projet_group_pk PRIMARY KEY (collection_id,aclgroup_id)

);
-- ddl-end --
COMMENT ON TABLE collection_group IS 'Table des autorisations d''accès à un projet';
-- ddl-end --

-- object: container_container_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS container_container_id_seq CASCADE;
CREATE SEQUENCE container_container_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: container | type: TABLE --
-- DROP TABLE IF EXISTS container CASCADE;
CREATE TABLE container (
	container_id integer NOT NULL DEFAULT nextval('container_container_id_seq'::regclass),
	uid integer NOT NULL,
	container_type_id integer NOT NULL,
	CONSTRAINT container_pk PRIMARY KEY (container_id)

);
-- ddl-end --
COMMENT ON TABLE container IS 'Liste des conteneurs d''échantillon';
-- ddl-end --

-- object: container_family_container_family_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS container_family_container_family_id_seq CASCADE;
CREATE SEQUENCE container_family_container_family_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: container_family | type: TABLE --
-- DROP TABLE IF EXISTS container_family CASCADE;
CREATE TABLE container_family (
	container_family_id integer NOT NULL DEFAULT nextval('container_family_container_family_id_seq'::regclass),
	container_family_name character varying NOT NULL,
	CONSTRAINT container_family_pk PRIMARY KEY (container_family_id)

);
-- ddl-end --
COMMENT ON TABLE container_family IS 'Famille générique des conteneurs';
-- ddl-end --

-- object: container_type_container_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS container_type_container_type_id_seq CASCADE;
CREATE SEQUENCE container_type_container_type_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: container_type | type: TABLE --
-- DROP TABLE IF EXISTS container_type CASCADE;
CREATE TABLE container_type (
	container_type_id integer NOT NULL DEFAULT nextval('container_type_container_type_id_seq'::regclass),
	container_type_name character varying NOT NULL,
	container_family_id integer NOT NULL,
	clp_classification character varying,
	container_type_description character varying,
	storage_condition_id integer,
	storage_product character varying,
	label_id integer,
	columns integer NOT NULL DEFAULT 1,
	lines integer NOT NULL DEFAULT 1,
	first_line character varying NOT NULL DEFAULT 'T',
	CONSTRAINT container_type_pk PRIMARY KEY (container_type_id)

);
-- ddl-end --
COMMENT ON TABLE container_type IS 'Table des types de conteneurs';
-- ddl-end --
COMMENT ON COLUMN container_type.clp_classification IS 'Classification du risque conformément à la directive européenne CLP';
-- ddl-end --
COMMENT ON COLUMN container_type.container_type_description IS 'Description longue';
-- ddl-end --
COMMENT ON COLUMN container_type.storage_product IS 'Produit utilisé pour le stockage (formol, alcool...)';
-- ddl-end --
COMMENT ON COLUMN container_type.columns IS 'Nombre de colonnes de stockage dans le container';
-- ddl-end --
COMMENT ON COLUMN container_type.lines IS 'Nombre de lignes de stockage dans le container';
-- ddl-end --
COMMENT ON COLUMN container_type.first_line IS 'T : top, premiere ligne en haut
B: bottom, premiere ligne en bas';
-- ddl-end --

-- object: document_document_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS document_document_id_seq CASCADE;
CREATE SEQUENCE document_document_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: document | type: TABLE --
-- DROP TABLE IF EXISTS document CASCADE;
CREATE TABLE document (
	document_id integer NOT NULL DEFAULT nextval('document_document_id_seq'::regclass),
	uid integer NOT NULL,
	mime_type_id integer NOT NULL,
	document_import_date timestamp NOT NULL,
	document_name character varying NOT NULL,
	document_description character varying,
	data bytea,
	thumbnail bytea,
	size integer,
	document_creation_date timestamp,
	CONSTRAINT document_pk PRIMARY KEY (document_id)

);
-- ddl-end --
COMMENT ON TABLE document IS 'Documents numériques rattachés à un poisson ou à un événement';
-- ddl-end --
COMMENT ON COLUMN document.document_import_date IS 'Date d''import dans la base de données';
-- ddl-end --
COMMENT ON COLUMN document.document_name IS 'Nom d''origine du document';
-- ddl-end --
COMMENT ON COLUMN document.document_description IS 'Description libre du document';
-- ddl-end --
COMMENT ON COLUMN document.data IS 'Contenu du document';
-- ddl-end --
COMMENT ON COLUMN document.thumbnail IS 'Vignette au format PNG (documents pdf, jpg ou png)';
-- ddl-end --
COMMENT ON COLUMN document.size IS 'Taille du fichier téléchargé';
-- ddl-end --
COMMENT ON COLUMN document.document_creation_date IS 'Date de création du document (date de prise de vue de la photo)';
-- ddl-end --

-- object: event_event_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS event_event_id_seq CASCADE;
CREATE SEQUENCE event_event_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: event | type: TABLE --
-- DROP TABLE IF EXISTS event CASCADE;
CREATE TABLE event (
	event_id integer NOT NULL DEFAULT nextval('event_event_id_seq'::regclass),
	uid integer NOT NULL,
	event_date timestamp NOT NULL,
	event_type_id integer NOT NULL,
	still_available character varying,
	event_comment character varying,
	CONSTRAINT event_pk PRIMARY KEY (event_id)

);
-- ddl-end --
COMMENT ON TABLE event IS 'Table des événements';
-- ddl-end --
COMMENT ON COLUMN event.event_date IS 'Date / heure de l''événement';
-- ddl-end --
COMMENT ON COLUMN event.still_available IS 'définit ce qu''il reste de disponible dans l''objet';
-- ddl-end --

-- object: event_type_event_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS event_type_event_type_id_seq CASCADE;
CREATE SEQUENCE event_type_event_type_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: event_type | type: TABLE --
-- DROP TABLE IF EXISTS event_type CASCADE;
CREATE TABLE event_type (
	event_type_id integer NOT NULL DEFAULT nextval('event_type_event_type_id_seq'::regclass),
	event_type_name character varying NOT NULL,
	is_sample boolean NOT NULL DEFAULT false,
	is_container boolean NOT NULL DEFAULT false,
	CONSTRAINT event_type_pk PRIMARY KEY (event_type_id)

);
-- ddl-end --
COMMENT ON TABLE event_type IS 'Types d''événement';
-- ddl-end --
COMMENT ON COLUMN event_type.is_sample IS 'L''événement s''applique aux échantillons';
-- ddl-end --
COMMENT ON COLUMN event_type.is_container IS 'L''événement s''applique aux conteneurs';
-- ddl-end --

-- object: identifier_type_identifier_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS identifier_type_identifier_type_id_seq CASCADE;
CREATE SEQUENCE identifier_type_identifier_type_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: identifier_type | type: TABLE --
-- DROP TABLE IF EXISTS identifier_type CASCADE;
CREATE TABLE identifier_type (
	identifier_type_id integer NOT NULL DEFAULT nextval('identifier_type_identifier_type_id_seq'::regclass),
	identifier_type_name character varying NOT NULL,
	identifier_type_code character varying NOT NULL,
	used_for_search boolean NOT NULL DEFAULT false,
	CONSTRAINT identifier_type_pk PRIMARY KEY (identifier_type_id)

);
-- ddl-end --
COMMENT ON TABLE identifier_type IS 'Table des types d''identifiants';
-- ddl-end --
COMMENT ON COLUMN identifier_type.identifier_type_name IS 'Nom textuel de l''identifiant';
-- ddl-end --
COMMENT ON COLUMN identifier_type.identifier_type_code IS 'Code utilisé pour la génération des étiquettes';
-- ddl-end --
COMMENT ON COLUMN identifier_type.used_for_search IS 'Indique si l''identifiant doit être utilise pour les recherches a partir des codes-barres';
-- ddl-end --

-- object: label_label_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS label_label_id_seq CASCADE;
CREATE SEQUENCE label_label_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: label | type: TABLE --
-- DROP TABLE IF EXISTS label CASCADE;
CREATE TABLE label (
	label_id integer NOT NULL DEFAULT nextval('label_label_id_seq'::regclass),
	label_name character varying NOT NULL,
	label_xsl character varying NOT NULL,
	label_fields character varying NOT NULL DEFAULT 'uid,id,clp,db',
	metadata_id integer,
	identifier_only boolean NOT NULL DEFAULT false,
	CONSTRAINT label_pk PRIMARY KEY (label_id)

);
-- ddl-end --
COMMENT ON TABLE label IS 'Table des modèles d''étiquettes';
-- ddl-end --
COMMENT ON COLUMN label.label_name IS 'Nom du modèle';
-- ddl-end --
COMMENT ON COLUMN label.label_xsl IS 'Contenu du fichier XSL utilisé pour la transformation FOP (https://xmlgraphics.apache.org/fop/)';
-- ddl-end --
COMMENT ON COLUMN label.identifier_only IS 'true : le qrcode ne contient qu''un identifiant metier';
-- ddl-end --

-- object: storage_storage_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS storage_storage_id_seq CASCADE;
CREATE SEQUENCE storage_storage_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: last_photo | type: VIEW --
-- DROP VIEW IF EXISTS last_photo CASCADE;
CREATE VIEW last_photo
AS

SELECT d.document_id,
    d.uid
   FROM document d
  WHERE (d.document_id = ( SELECT d1.document_id
           FROM document d1
          WHERE ((d1.mime_type_id = ANY (ARRAY[4, 5, 6])) AND (d.uid = d1.uid))
          ORDER BY d1.document_creation_date DESC, d1.document_import_date DESC, d1.document_id DESC
         LIMIT 1));
-- ddl-end --

-- object: mime_type_mime_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS mime_type_mime_type_id_seq CASCADE;
CREATE SEQUENCE mime_type_mime_type_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: mime_type | type: TABLE --
-- DROP TABLE IF EXISTS mime_type CASCADE;
CREATE TABLE mime_type (
	mime_type_id integer NOT NULL DEFAULT nextval('mime_type_mime_type_id_seq'::regclass),
	extension character varying NOT NULL,
	content_type character varying NOT NULL,
	CONSTRAINT mime_type_pk PRIMARY KEY (mime_type_id)

);
-- ddl-end --
COMMENT ON TABLE mime_type IS 'Types mime des fichiers importés';
-- ddl-end --
COMMENT ON COLUMN mime_type.extension IS 'Extension du fichier correspondant';
-- ddl-end --
COMMENT ON COLUMN mime_type.content_type IS 'type mime officiel';
-- ddl-end --

-- object: storage_reason_storage_reason_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS storage_reason_storage_reason_id_seq CASCADE;
CREATE SEQUENCE storage_reason_storage_reason_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: movement_type_movement_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS movement_type_movement_type_id_seq CASCADE;
CREATE SEQUENCE movement_type_movement_type_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: movement_type | type: TABLE --
-- DROP TABLE IF EXISTS movement_type CASCADE;
CREATE TABLE movement_type (
	movement_type_id integer NOT NULL DEFAULT nextval('movement_type_movement_type_id_seq'::regclass),
	movement_type_name character varying NOT NULL,
	CONSTRAINT movement_type_pk PRIMARY KEY (movement_type_id)

);
-- ddl-end --
COMMENT ON TABLE movement_type IS 'Type de mouvement';
-- ddl-end --

-- object: multiple_type_multiple_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS multiple_type_multiple_type_id_seq CASCADE;
CREATE SEQUENCE multiple_type_multiple_type_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: multiple_type | type: TABLE --
-- DROP TABLE IF EXISTS multiple_type CASCADE;
CREATE TABLE multiple_type (
	multiple_type_id integer NOT NULL DEFAULT nextval('multiple_type_multiple_type_id_seq'::regclass),
	multiple_type_name character varying NOT NULL,
	CONSTRAINT multiple_type_pk PRIMARY KEY (multiple_type_id)

);
-- ddl-end --
COMMENT ON TABLE multiple_type IS 'Table des types de contenus multiples';
-- ddl-end --

-- object: object_uid_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS object_uid_seq CASCADE;
CREATE SEQUENCE object_uid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: object_identifier_object_identifier_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS object_identifier_object_identifier_id_seq CASCADE;
CREATE SEQUENCE object_identifier_object_identifier_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: object_identifier | type: TABLE --
-- DROP TABLE IF EXISTS object_identifier CASCADE;
CREATE TABLE object_identifier (
	object_identifier_id integer NOT NULL DEFAULT nextval('object_identifier_object_identifier_id_seq'::regclass),
	uid integer NOT NULL,
	identifier_type_id integer NOT NULL,
	object_identifier_value character varying NOT NULL,
	CONSTRAINT object_identifier_pk PRIMARY KEY (object_identifier_id)

);
-- ddl-end --
COMMENT ON TABLE object_identifier IS 'Table des identifiants complémentaires normalisés';
-- ddl-end --
COMMENT ON COLUMN object_identifier.object_identifier_value IS 'Valeur de l''identifiant';
-- ddl-end --

-- object: object_status_object_status_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS object_status_object_status_id_seq CASCADE;
CREATE SEQUENCE object_status_object_status_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: object_status | type: TABLE --
-- DROP TABLE IF EXISTS object_status CASCADE;
CREATE TABLE object_status (
	object_status_id integer NOT NULL DEFAULT nextval('object_status_object_status_id_seq'::regclass),
	object_status_name character varying NOT NULL,
	CONSTRAINT object_status_pk PRIMARY KEY (object_status_id)

);
-- ddl-end --
COMMENT ON TABLE object_status IS 'Table des statuts possibles des objets';
-- ddl-end --

-- object: object | type: TABLE --
-- DROP TABLE IF EXISTS object CASCADE;
CREATE TABLE object (
	uid integer NOT NULL DEFAULT nextval('object_uid_seq'::regclass),
	identifier character varying,
	wgs84_x double precision,
	wgs84_y double precision,
	object_status_id integer,
	referent_id integer,
	CONSTRAINT object_pk PRIMARY KEY (uid)

);
-- ddl-end --
COMMENT ON TABLE object IS 'Table des objets
Contient les identifiants génériques';
-- ddl-end --
COMMENT ON COLUMN object.identifier IS 'Identifiant fourni le cas échéant par le projet';
-- ddl-end --
COMMENT ON COLUMN object.wgs84_x IS 'Longitude GPS, en valeur décimale';
-- ddl-end --
COMMENT ON COLUMN object.wgs84_y IS 'Latitude GPS, en valeur décimale';
-- ddl-end --

-- object: operation_operation_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS operation_operation_id_seq CASCADE;
CREATE SEQUENCE operation_operation_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: operation | type: TABLE --
-- DROP TABLE IF EXISTS operation CASCADE;
CREATE TABLE operation (
	operation_id integer NOT NULL DEFAULT nextval('operation_operation_id_seq'::regclass),
	protocol_id integer NOT NULL,
	operation_name character varying NOT NULL,
	operation_order integer,
	metadata_form_id integer,
	operation_version character varying,
	last_edit_date timestamp,
	CONSTRAINT operation_name_version_unique UNIQUE (operation_name,operation_version),
	CONSTRAINT operation_pk PRIMARY KEY (operation_id)

);
-- ddl-end --
COMMENT ON COLUMN operation.operation_order IS 'Ordre de réalisation de l''opération dans le protocole';
-- ddl-end --
COMMENT ON COLUMN operation.operation_version IS 'Version de l''opération';
-- ddl-end --
COMMENT ON COLUMN operation.last_edit_date IS 'Date de dernière éditione l''opératon';
-- ddl-end --

-- object: collection | type: TABLE --
-- DROP TABLE IF EXISTS collection CASCADE;
CREATE TABLE collection (
	collection_id integer NOT NULL DEFAULT nextval('project_project_id_seq'::regclass),
	collection_name character varying NOT NULL,
	referent_id integer,
	CONSTRAINT project_pk PRIMARY KEY (collection_id)

);
-- ddl-end --
COMMENT ON TABLE collection IS 'List of all collections into the database';
-- ddl-end --

-- object: protocol_protocol_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS protocol_protocol_id_seq CASCADE;
CREATE SEQUENCE protocol_protocol_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: protocol | type: TABLE --
-- DROP TABLE IF EXISTS protocol CASCADE;
CREATE TABLE protocol (
	protocol_id integer NOT NULL DEFAULT nextval('protocol_protocol_id_seq'::regclass),
	protocol_name character varying NOT NULL,
	protocol_file bytea,
	protocol_year smallint,
	protocol_version character varying NOT NULL DEFAULT 'v1.0',
	collection_id integer,
	authorization_number varchar,
	authorization_date timestamp,
	CONSTRAINT protocol_pk PRIMARY KEY (protocol_id)

);
-- ddl-end --
COMMENT ON COLUMN protocol.protocol_file IS 'Description PDF du protocole';
-- ddl-end --
COMMENT ON COLUMN protocol.protocol_year IS 'Année du protocole';
-- ddl-end --
COMMENT ON COLUMN protocol.protocol_version IS 'Version du protocole';
-- ddl-end --
COMMENT ON COLUMN protocol.authorization_number IS 'Number of the prelevement authorization';
-- ddl-end --
COMMENT ON COLUMN protocol.authorization_date IS 'Date of the prelevement authorization';
-- ddl-end --

-- object: sample_sample_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS sample_sample_id_seq CASCADE;
CREATE SEQUENCE sample_sample_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: sample | type: TABLE --
-- DROP TABLE IF EXISTS sample CASCADE;
CREATE TABLE sample (
	sample_id integer NOT NULL DEFAULT nextval('sample_sample_id_seq'::regclass),
	uid integer NOT NULL,
	collection_id integer NOT NULL,
	sample_type_id integer NOT NULL,
	sample_creation_date timestamp NOT NULL,
	sampling_date timestamp,
	parent_sample_id integer,
	multiple_value double precision,
	sampling_place_id integer,
	dbuid_origin character varying,
	metadata json,
	expiration_date timestamp,
	CONSTRAINT sample_pk PRIMARY KEY (sample_id)

);
-- ddl-end --
COMMENT ON TABLE sample IS 'Table des échantillons';
-- ddl-end --
COMMENT ON COLUMN sample.sample_creation_date IS 'Date de création de l''enregistrement dans la base de données';
-- ddl-end --
COMMENT ON COLUMN sample.sampling_date IS 'Date de création de l''échantillon physique';
-- ddl-end --
COMMENT ON COLUMN sample.dbuid_origin IS 'référence utilisée dans la base de données d''origine, sous la forme db:uid
Utilisé pour lire les étiquettes créées dans d''autres instances';
-- ddl-end --
COMMENT ON COLUMN sample.metadata IS 'Metadonnees associees de l''echantillon';
-- ddl-end --

CREATE SEQUENCE "sampling_place_sampling_place_id_seq";

CREATE TABLE "sampling_place" (
                "sampling_place_id" INTEGER NOT NULL DEFAULT nextval('"sampling_place_sampling_place_id_seq"'),
                collection_id integer,
                "sampling_place_name" VARCHAR NOT NULL,
                sampling_place_code varchar,
 				sampling_place_x float8,
 				sampling_place_y float8,
                CONSTRAINT "sampling_place_pk" PRIMARY KEY ("sampling_place_id")
);
COMMENT ON TABLE "sampling_place" IS 'Table des lieux génériques d''échantillonnage';
comment on column sampling_place.sampling_place_code is 'Code métier de la station';
 comment on column sampling_place.sampling_place_x is 'Longitude de la station, en WGS84';
 comment on column sampling_place.sampling_place_y is 'Latitude de la station, en WGS84';


ALTER SEQUENCE "sampling_place_sampling_place_id_seq" OWNED BY "sampling_place"."sampling_place_id";

-- object: sample_type_sample_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS sample_type_sample_type_id_seq CASCADE;
CREATE SEQUENCE sample_type_sample_type_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: sample_type | type: TABLE --
-- DROP TABLE IF EXISTS sample_type CASCADE;
CREATE TABLE sample_type (
	sample_type_id integer NOT NULL DEFAULT nextval('sample_type_sample_type_id_seq'::regclass),
	sample_type_name character varying NOT NULL,
	container_type_id integer,
	multiple_type_id integer,
	multiple_unit character varying,
	metadata_id integer,
	operation_id integer,
	identifier_generator_js character varying,
	CONSTRAINT sample_type_pk PRIMARY KEY (sample_type_id)

);
-- ddl-end --
COMMENT ON TABLE sample_type IS 'Types d''échantillons';
-- ddl-end --
COMMENT ON COLUMN sample_type.identifier_generator_js IS 'Champ comprenant le code de la fonction javascript permettant de générer automatiquement un identifiant à partir des informations saisies';
-- ddl-end --

-- object: storage_condition_storage_condition_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS storage_condition_storage_condition_id_seq CASCADE;
CREATE SEQUENCE storage_condition_storage_condition_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: storage_condition | type: TABLE --
-- DROP TABLE IF EXISTS storage_condition CASCADE;
CREATE TABLE storage_condition (
	storage_condition_id integer NOT NULL DEFAULT nextval('storage_condition_storage_condition_id_seq'::regclass),
	storage_condition_name character varying NOT NULL,
	CONSTRAINT storage_condition_pk PRIMARY KEY (storage_condition_id)

);
-- ddl-end --
COMMENT ON TABLE storage_condition IS 'Condition de stockage';
-- ddl-end --

-- object: movement_reason | type: TABLE --
-- DROP TABLE IF EXISTS movement_reason CASCADE;
CREATE TABLE movement_reason (
	movement_reason_id integer NOT NULL DEFAULT nextval('storage_reason_storage_reason_id_seq'::regclass),
	movement_reason_name character varying NOT NULL,
	CONSTRAINT storage_reason_pk PRIMARY KEY (movement_reason_id)

);
-- ddl-end --
COMMENT ON TABLE movement_reason IS 'List of the reasons of the movement';
-- ddl-end --

-- object: movement | type: TABLE --
-- DROP TABLE IF EXISTS movement CASCADE;
CREATE TABLE movement (
	movement_id integer NOT NULL DEFAULT nextval('storage_storage_id_seq'::regclass),
	uid integer NOT NULL,
	container_id integer,
	movement_type_id integer NOT NULL,
	movement_date timestamp NOT NULL,
	storage_location character varying,
	login character varying NOT NULL,
	movement_comment character varying,
	movement_reason_id integer,
	column_number integer NOT NULL DEFAULT 1,
	line_number integer NOT NULL DEFAULT 1,
	CONSTRAINT storage_pk PRIMARY KEY (movement_id)

);
-- ddl-end --
COMMENT ON TABLE movement IS 'Records of objects movements';
-- ddl-end --
COMMENT ON COLUMN movement.movement_date IS 'Date/heure du mouvement';
-- ddl-end --
COMMENT ON COLUMN movement.storage_location IS 'Emplacement de l''échantillon dans le conteneur';
-- ddl-end --
COMMENT ON COLUMN movement.login IS 'Nom de l''utilisateur ayant réalisé l''opération';
-- ddl-end --
COMMENT ON COLUMN movement.movement_comment IS 'Commentaire';
-- ddl-end --
COMMENT ON COLUMN movement.column_number IS 'No de la colonne de stockage dans le container';
-- ddl-end --
COMMENT ON COLUMN movement.line_number IS 'No de la ligne de stockage dans le container';
-- ddl-end --

-- object: subsample_subsample_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS subsample_subsample_id_seq CASCADE;
CREATE SEQUENCE subsample_subsample_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: subsample | type: TABLE --
-- DROP TABLE IF EXISTS subsample CASCADE;
CREATE TABLE subsample (
	subsample_id integer NOT NULL DEFAULT nextval('subsample_subsample_id_seq'::regclass),
	sample_id integer NOT NULL,
	subsample_date timestamp NOT NULL,
	movement_type_id integer NOT NULL,
	subsample_quantity double precision,
	subsample_comment character varying,
	subsample_login character varying NOT NULL,
	CONSTRAINT subsample_pk PRIMARY KEY (subsample_id)

);
-- ddl-end --
COMMENT ON TABLE subsample IS 'Table des prélèvements et restitutions de sous-échantillons';
-- ddl-end --
COMMENT ON COLUMN subsample.subsample_date IS 'Date/heure de l''opération';
-- ddl-end --
COMMENT ON COLUMN subsample.subsample_quantity IS 'Quantité prélevée ou restituée';
-- ddl-end --
COMMENT ON COLUMN subsample.subsample_login IS 'Login de l''utilisateur ayant réalisé l''opération';
-- ddl-end --

-- object: v_object_identifier | type: VIEW --
-- DROP VIEW IF EXISTS v_object_identifier CASCADE;
CREATE VIEW v_object_identifier
AS

SELECT object_identifier.uid,
    array_to_string(array_agg((((identifier_type.identifier_type_code)::text || ':'::text) || (object_identifier.object_identifier_value)::text) ORDER BY identifier_type.identifier_type_code, object_identifier.object_identifier_value), ','::text) AS identifiers
   FROM (object_identifier
     JOIN identifier_type USING (identifier_type_id))
  GROUP BY object_identifier.uid
  ORDER BY object_identifier.uid;
-- ddl-end --


-- object: object_identifier_idx | type: INDEX --
-- DROP INDEX IF EXISTS object_identifier_idx CASCADE;
CREATE INDEX object_identifier_idx ON object
	USING gin
	(
	  identifier
	);
-- ddl-end --

-- object: object_identifier_value_idx | type: INDEX --
-- DROP INDEX IF EXISTS object_identifier_value_idx CASCADE;
CREATE INDEX object_identifier_value_idx ON object_identifier
	USING gin
	(
	  object_identifier_value
	);
-- ddl-end --

-- object: sample_dbuid_origin_idx | type: INDEX --
-- DROP INDEX IF EXISTS sample_dbuid_origin_idx CASCADE;
CREATE INDEX sample_dbuid_origin_idx ON sample
	USING gin
	(
	  dbuid_origin
	);
-- ddl-end --

-- object: sample_expiration_date_idx | type: INDEX --
-- DROP INDEX IF EXISTS sample_expiration_date_idx CASCADE;
CREATE INDEX sample_expiration_date_idx ON sample
	USING btree
	(
	  expiration_date
	);
-- ddl-end --

-- object: sample_sample_creation_date_idx | type: INDEX --
-- DROP INDEX IF EXISTS sample_sample_creation_date_idx CASCADE;
CREATE INDEX sample_sample_creation_date_idx ON sample
	USING btree
	(
	  sample_creation_date
	);
-- ddl-end --

-- object: sample_sample_date_idx | type: INDEX --
-- DROP INDEX IF EXISTS sample_sample_date_idx CASCADE;
CREATE INDEX sample_sample_date_idx ON sample
	USING btree
	(
	  sampling_date
	);
-- ddl-end --

-- object: borrower_borrower_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS borrower_borrower_id_seq CASCADE;
CREATE SEQUENCE borrower_borrower_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: borrowing_borrowing_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS borrowing_borrowing_id_seq CASCADE;
CREATE SEQUENCE borrowing_borrowing_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: borrower | type: TABLE --
-- DROP TABLE IF EXISTS borrower CASCADE;
CREATE TABLE borrower (
	borrower_id integer NOT NULL DEFAULT nextval('borrower_borrower_id_seq'::regclass),
	borrower_name varchar NOT NULL,
	borrower_address varchar,
	borrower_phone varchar,
	CONSTRAINT borrower_pk PRIMARY KEY (borrower_id)

);
-- ddl-end --
COMMENT ON TABLE borrower IS 'List of borrowers';
-- ddl-end --
COMMENT ON COLUMN borrower.borrower_address IS 'Address of the borrower';
-- ddl-end --
COMMENT ON COLUMN borrower.borrower_phone IS 'Phone of the contact of the borrower';
-- ddl-end --

-- object: borrowing | type: TABLE --
-- DROP TABLE IF EXISTS borrowing CASCADE;
CREATE TABLE borrowing (
	borrowing_id integer NOT NULL DEFAULT nextval('borrowing_borrowing_id_seq'::regclass),
	borrowing_date timestamp NOT NULL,
	expected_return_date timestamp,
	uid integer NOT NULL,
	return_date timestamp,
	borrower_id integer NOT NULL,
	CONSTRAINT borrowing_pk PRIMARY KEY (borrowing_id)

);
-- ddl-end --
COMMENT ON COLUMN borrowing.borrowing_date IS 'Date of the borrowing';
-- ddl-end --
COMMENT ON COLUMN borrowing.expected_return_date IS 'Expected return date of the object';
-- ddl-end --
COMMENT ON COLUMN borrowing.return_date IS 'Date of return of the object';
-- ddl-end --

-- object: object_fk | type: CONSTRAINT --
-- ALTER TABLE borrowing DROP CONSTRAINT IF EXISTS object_fk CASCADE;
ALTER TABLE borrowing ADD CONSTRAINT object_fk FOREIGN KEY (uid)
REFERENCES object (uid) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: borrower_fk | type: CONSTRAINT --
-- ALTER TABLE borrowing DROP CONSTRAINT IF EXISTS borrower_fk CASCADE;
ALTER TABLE borrowing ADD CONSTRAINT borrower_fk FOREIGN KEY (borrower_id)
REFERENCES borrower (borrower_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: borrowing_uid_idx | type: INDEX --
-- DROP INDEX IF EXISTS borrowing_uid_idx CASCADE;
CREATE INDEX borrowing_uid_idx ON borrowing
	USING btree
	(
	  uid
	);
-- ddl-end --

-- object: borrowing_borrower_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS borrowing_borrower_id_idx CASCADE;
CREATE INDEX borrowing_borrower_id_idx ON borrowing
	USING btree
	(
	  borrower_id
	);
-- ddl-end --

-- object: last_borrowing | type: VIEW --
-- DROP VIEW IF EXISTS last_borrowing CASCADE;
CREATE VIEW last_borrowing
AS

select borrowing_id, uid, borrowing_date, expected_return_date, borrower_id
from borrowing b1
 where borrowing_id = (
 select borrowing_id from borrowing b2
 where b1.uid = b2.uid
 and b2.return_date is null
 order by borrowing_date desc limit 1);
-- ddl-end --
COMMENT ON VIEW last_borrowing IS 'View to get the last borrowing for an object';
-- ddl-end --

CREATE SEQUENCE metadata_metadata_id_seq
    INCREMENT 1
    START 18
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;
CREATE TABLE metadata
(
    metadata_id integer NOT NULL DEFAULT nextval('metadata_metadata_id_seq'::regclass),
    metadata_name character varying NOT NULL,
    metadata_schema json,
    CONSTRAINT metadata_pk PRIMARY KEY (metadata_id)
);
COMMENT ON TABLE metadata
    IS 'Table des metadata utilisables dans les types d''echantillons';

COMMENT ON COLUMN metadata.metadata_name
    IS 'Nom du jeu de metadonnees';

COMMENT ON COLUMN metadata.metadata_schema
    IS 'Schéma en JSON du formulaire des métadonnées';

CREATE SEQUENCE printer_printer_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;
CREATE TABLE printer
(
    printer_id integer NOT NULL DEFAULT nextval('printer_printer_id_seq'::regclass),
    printer_name character varying  NOT NULL,
    printer_queue character varying  NOT NULL,
    printer_server character varying ,
    printer_user character varying ,
    printer_comment character varying ,
    CONSTRAINT printer_pk PRIMARY KEY (printer_id)
);
COMMENT ON TABLE printer
    IS 'Table des imprimantes gerees directement par le serveur';

COMMENT ON COLUMN printer.printer_name
    IS 'Nom general de l''imprimante, affiche dans les masques de saisie';

COMMENT ON COLUMN printer.printer_queue
    IS 'Nom de l''imprimante telle qu''elle est connue par le systeme';

COMMENT ON COLUMN printer.printer_server
    IS 'Adresse du serveur, si imprimante non locale';

COMMENT ON COLUMN printer.printer_user
    IS 'Utilisateur autorise a imprimer ';

COMMENT ON COLUMN printer.printer_comment
    IS 'Commentaire';


CREATE SEQUENCE referent_referent_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE referent_referent_id_seq OWNER TO collec;
-- ddl-end --

-- object: referent | type: TABLE --
-- DROP TABLE IF EXISTS referent CASCADE;
CREATE TABLE referent (
	referent_id integer NOT NULL DEFAULT nextval('referent_referent_id_seq'::regclass),
	referent_name character varying NOT NULL,
	referent_email character varying,
	address_name character varying,
	address_line2 character varying,
	address_line3 character varying,
	address_city character varying,
	address_country character varying,
	referent_phone character varying,
	CONSTRAINT referent_pk PRIMARY KEY (referent_id)

);
-- ddl-end --
COMMENT ON TABLE referent IS E'Table of sample referents';
-- ddl-end --
COMMENT ON COLUMN referent.referent_name IS E'Name, firstname-lastname or department name';
-- ddl-end --
COMMENT ON COLUMN referent.referent_email IS E'Email for contact';
-- ddl-end --
COMMENT ON COLUMN referent.address_name IS E'Name for postal address';
-- ddl-end --
COMMENT ON COLUMN referent.address_line2 IS E'second line in postal address';
-- ddl-end --
COMMENT ON COLUMN referent.address_line3 IS E'third line in postal address';
-- ddl-end --
COMMENT ON COLUMN referent.address_city IS E'ZIPCode and City in postal address';
-- ddl-end --
COMMENT ON COLUMN referent.address_country IS E'Country in postal address';
-- ddl-end --
COMMENT ON COLUMN referent.referent_phone IS E'Contact phone';
-- ddl-end --
ALTER TABLE referent OWNER TO collec;
-- ddl-end --

-- object: referent_referent_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS referent_referent_name_idx CASCADE;
CREATE UNIQUE INDEX referent_referent_name_idx ON referent
	USING btree
	(
	  referent_name
	);
-- ddl-end --

ALTER TABLE object ADD CONSTRAINT referent_object_fk FOREIGN KEY (referent_id)
REFERENCES referent (referent_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;


-- object: last_movement | type: VIEW --
-- DROP VIEW IF EXISTS last_movement CASCADE;
CREATE VIEW last_movement
AS

SELECT s.uid,
    s.movement_id,
    s.movement_date,
    s.movement_type_id,
    s.container_id,
    c.uid AS container_uid,
    s.line_number,
    s.column_number,
    s.movement_reason_id
   FROM (movement s
     LEFT JOIN container c USING (container_id))
  WHERE (s.movement_id = ( SELECT st.movement_id
           FROM movement st
          WHERE (s.uid = st.uid)
          ORDER BY st.movement_date DESC
         LIMIT 1));
-- ddl-end --
COMMENT ON VIEW last_movement IS 'Get the last movement for an object';
-- ddl-end --

-- object: dbversion_dbversion_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS dbversion_dbversion_id_seq CASCADE;
CREATE SEQUENCE dbversion_dbversion_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: dbversion | type: TABLE --
-- DROP TABLE IF EXISTS dbversion CASCADE;
CREATE TABLE dbversion (
	dbversion_id integer NOT NULL DEFAULT nextval('dbversion_dbversion_id_seq'::regclass),
	dbversion_number character varying NOT NULL,
	dbversion_date timestamp NOT NULL,
	CONSTRAINT dbversion_pk PRIMARY KEY (dbversion_id)

);
-- ddl-end --
COMMENT ON TABLE dbversion IS E'Table des versions de la base de donnees';
-- ddl-end --
COMMENT ON COLUMN dbversion.dbversion_number IS E'Numero de la version';
-- ddl-end --
COMMENT ON COLUMN dbversion.dbversion_date IS E'Date de la version';
-- ddl-end --

-- object: object_booking_fk | type: CONSTRAINT --
-- ALTER TABLE booking DROP CONSTRAINT IF EXISTS object_booking_fk CASCADE;
ALTER TABLE booking ADD CONSTRAINT object_booking_fk FOREIGN KEY (uid)
REFERENCES object (uid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: group_projet_aclgroup_fk | type: CONSTRAINT --
-- ALTER TABLE collection_group DROP CONSTRAINT IF EXISTS group_projet_aclgroup_fk CASCADE;
ALTER TABLE collection_group ADD CONSTRAINT group_projet_aclgroup_fk FOREIGN KEY (aclgroup_id)
REFERENCES gacl.aclgroup (aclgroup_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: project_projet_group_fk | type: CONSTRAINT --
-- ALTER TABLE collection_group DROP CONSTRAINT IF EXISTS project_projet_group_fk CASCADE;
ALTER TABLE collection_group ADD CONSTRAINT project_projet_group_fk FOREIGN KEY (collection_id)
REFERENCES collection (collection_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: container_type_container_fk | type: CONSTRAINT --
-- ALTER TABLE container DROP CONSTRAINT IF EXISTS container_type_container_fk CASCADE;
ALTER TABLE container ADD CONSTRAINT container_type_container_fk FOREIGN KEY (container_type_id)
REFERENCES container_type (container_type_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: object_container_fk | type: CONSTRAINT --
-- ALTER TABLE container DROP CONSTRAINT IF EXISTS object_container_fk CASCADE;
ALTER TABLE container ADD CONSTRAINT object_container_fk FOREIGN KEY (uid)
REFERENCES object (uid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: container_family_container_type_fk | type: CONSTRAINT --
-- ALTER TABLE container_type DROP CONSTRAINT IF EXISTS container_family_container_type_fk CASCADE;
ALTER TABLE container_type ADD CONSTRAINT container_family_container_type_fk FOREIGN KEY (container_family_id)
REFERENCES container_family (container_family_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: label_container_type_fk | type: CONSTRAINT --
-- ALTER TABLE container_type DROP CONSTRAINT IF EXISTS label_container_type_fk CASCADE;
ALTER TABLE container_type ADD CONSTRAINT label_container_type_fk FOREIGN KEY (label_id)
REFERENCES label (label_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: storage_condition_container_type_fk | type: CONSTRAINT --
-- ALTER TABLE container_type DROP CONSTRAINT IF EXISTS storage_condition_container_type_fk CASCADE;
ALTER TABLE container_type ADD CONSTRAINT storage_condition_container_type_fk FOREIGN KEY (storage_condition_id)
REFERENCES storage_condition (storage_condition_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: mime_type_document_fk | type: CONSTRAINT --
-- ALTER TABLE document DROP CONSTRAINT IF EXISTS mime_type_document_fk CASCADE;
ALTER TABLE document ADD CONSTRAINT mime_type_document_fk FOREIGN KEY (mime_type_id)
REFERENCES mime_type (mime_type_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: object_document_fk | type: CONSTRAINT --
-- ALTER TABLE document DROP CONSTRAINT IF EXISTS object_document_fk CASCADE;
ALTER TABLE document ADD CONSTRAINT object_document_fk FOREIGN KEY (uid)
REFERENCES object (uid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: event_type_event_fk | type: CONSTRAINT --
-- ALTER TABLE event DROP CONSTRAINT IF EXISTS event_type_event_fk CASCADE;
ALTER TABLE event ADD CONSTRAINT event_type_event_fk FOREIGN KEY (event_type_id)
REFERENCES event_type (event_type_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: object_event_fk | type: CONSTRAINT --
-- ALTER TABLE event DROP CONSTRAINT IF EXISTS object_event_fk CASCADE;
ALTER TABLE event ADD CONSTRAINT object_event_fk FOREIGN KEY (uid)
REFERENCES object (uid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: identifier_type_object_identifier_fk | type: CONSTRAINT --
-- ALTER TABLE object_identifier DROP CONSTRAINT IF EXISTS identifier_type_object_identifier_fk CASCADE;
ALTER TABLE object_identifier ADD CONSTRAINT identifier_type_object_identifier_fk FOREIGN KEY (identifier_type_id)
REFERENCES identifier_type (identifier_type_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: object_object_identifier_fk | type: CONSTRAINT --
-- ALTER TABLE object_identifier DROP CONSTRAINT IF EXISTS object_object_identifier_fk CASCADE;
ALTER TABLE object_identifier ADD CONSTRAINT object_object_identifier_fk FOREIGN KEY (uid)
REFERENCES object (uid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: object_status_object_fk | type: CONSTRAINT --
-- ALTER TABLE object DROP CONSTRAINT IF EXISTS object_status_object_fk CASCADE;
ALTER TABLE object ADD CONSTRAINT object_status_object_fk FOREIGN KEY (object_status_id)
REFERENCES object_status (object_status_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: protocol_operation_fk | type: CONSTRAINT --
-- ALTER TABLE operation DROP CONSTRAINT IF EXISTS protocol_operation_fk CASCADE;
ALTER TABLE operation ADD CONSTRAINT protocol_operation_fk FOREIGN KEY (protocol_id)
REFERENCES protocol (protocol_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: project_protocol_fk | type: CONSTRAINT --
-- ALTER TABLE protocol DROP CONSTRAINT IF EXISTS project_protocol_fk CASCADE;
ALTER TABLE protocol ADD CONSTRAINT project_protocol_fk FOREIGN KEY (collection_id)
REFERENCES collection (collection_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: object_sample_fk | type: CONSTRAINT --
-- ALTER TABLE sample DROP CONSTRAINT IF EXISTS object_sample_fk CASCADE;
ALTER TABLE sample ADD CONSTRAINT object_sample_fk FOREIGN KEY (uid)
REFERENCES object (uid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: project_sample_fk | type: CONSTRAINT --
-- ALTER TABLE sample DROP CONSTRAINT IF EXISTS project_sample_fk CASCADE;
ALTER TABLE sample ADD CONSTRAINT project_sample_fk FOREIGN KEY (collection_id)
REFERENCES collection (collection_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: sample_sample_fk | type: CONSTRAINT --
-- ALTER TABLE sample DROP CONSTRAINT IF EXISTS sample_sample_fk CASCADE;
ALTER TABLE sample ADD CONSTRAINT sample_sample_fk FOREIGN KEY (parent_sample_id)
REFERENCES sample (sample_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

ALTER TABLE "sample" ADD CONSTRAINT "sampling_place_sample_fk"
FOREIGN KEY ("sampling_place_id")
REFERENCES "sampling_place" ("sampling_place_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION;
-- object: sample_type_sample_fk | type: CONSTRAINT --
-- ALTER TABLE sample DROP CONSTRAINT IF EXISTS sample_type_sample_fk CASCADE;
ALTER TABLE sample ADD CONSTRAINT sample_type_sample_fk FOREIGN KEY (sample_type_id)
REFERENCES sample_type (sample_type_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: container_type_sample_type_fk | type: CONSTRAINT --
-- ALTER TABLE sample_type DROP CONSTRAINT IF EXISTS container_type_sample_type_fk CASCADE;
ALTER TABLE sample_type ADD CONSTRAINT container_type_sample_type_fk FOREIGN KEY (container_type_id)
REFERENCES container_type (container_type_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: multiple_type_sample_type_fk | type: CONSTRAINT --
-- ALTER TABLE sample_type DROP CONSTRAINT IF EXISTS multiple_type_sample_type_fk CASCADE;
ALTER TABLE sample_type ADD CONSTRAINT multiple_type_sample_type_fk FOREIGN KEY (multiple_type_id)
REFERENCES multiple_type (multiple_type_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --
ALTER TABLE "sample_type" ADD CONSTRAINT "metadata_sample_type_fk"
FOREIGN KEY ("metadata_id")
REFERENCES "metadata" ("metadata_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- object: operation_sample_type_fk | type: CONSTRAINT --
-- ALTER TABLE sample_type DROP CONSTRAINT IF EXISTS operation_sample_type_fk CASCADE;
ALTER TABLE sample_type ADD CONSTRAINT operation_sample_type_fk FOREIGN KEY (operation_id)
REFERENCES operation (operation_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: container_storage_fk | type: CONSTRAINT --
-- ALTER TABLE movement DROP CONSTRAINT IF EXISTS container_storage_fk CASCADE;
ALTER TABLE movement ADD CONSTRAINT container_storage_fk FOREIGN KEY (container_id)
REFERENCES container (container_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: movement_type_storage_fk | type: CONSTRAINT --
-- ALTER TABLE movement DROP CONSTRAINT IF EXISTS movement_type_storage_fk CASCADE;
ALTER TABLE movement ADD CONSTRAINT movement_type_storage_fk FOREIGN KEY (movement_type_id)
REFERENCES movement_type (movement_type_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: object_storage_fk | type: CONSTRAINT --
-- ALTER TABLE movement DROP CONSTRAINT IF EXISTS object_storage_fk CASCADE;
ALTER TABLE movement ADD CONSTRAINT object_storage_fk FOREIGN KEY (uid)
REFERENCES object (uid) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: storage_reason_storage_fk | type: CONSTRAINT --
-- ALTER TABLE movement DROP CONSTRAINT IF EXISTS storage_reason_storage_fk CASCADE;
ALTER TABLE movement ADD CONSTRAINT storage_reason_storage_fk FOREIGN KEY (movement_reason_id)
REFERENCES movement_reason (movement_reason_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: movement_type_subsample_fk | type: CONSTRAINT --
-- ALTER TABLE subsample DROP CONSTRAINT IF EXISTS movement_type_subsample_fk CASCADE;
ALTER TABLE subsample ADD CONSTRAINT movement_type_subsample_fk FOREIGN KEY (movement_type_id)
REFERENCES movement_type (movement_type_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: sample_subsample_fk | type: CONSTRAINT --
-- ALTER TABLE subsample DROP CONSTRAINT IF EXISTS sample_subsample_fk CASCADE;
ALTER TABLE subsample ADD CONSTRAINT sample_subsample_fk FOREIGN KEY (sample_id)
REFERENCES sample (sample_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --



/*
 * Initialisation par defaut des donnees
 */

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
  			<fo:block>col:<fo:inline font-weight="bold"><xsl:value-of select="col"/></fo:inline></fo:block>
  			<fo:block>clp:<fo:inline font-weight="bold"><xsl:value-of select="clp"/></fo:inline></fo:block>
  		</fo:table-cell>
  	  	</fo:table-row>
  </fo:table-body>
  </fo:table>
   <fo:block page-break-after="always"/>

  </xsl:template>
</xsl:stylesheet>',
  'uid,id,clp,db,col'
);
select setval('label_label_id_seq',(select max(label_id) from label));

/*
 * Tables de parametres generales
 */
 insert into container_family (container_family_id, container_family_name)
 values
 (1, 'Immobilier'),
 (2, 'Mobilier');

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

INSERT INTO object_status(  object_status_id, object_status_name)
VALUES
(  1, 'État normal'),
(  2, 'Objet pré-réservé pour usage ultérieur'),
(  3, 'Objet détruit'),
(  4, 'Echantillon vidé de tout contenu'),
( 5, 'Container plein'),
( 6, 'Objet prêté');
select setval('object_status_object_status_id_seq', 6);

CREATE TABLE "dbparam" (
                "dbparam_id" INTEGER NOT NULL,
                "dbparam_name" VARCHAR NOT NULL,
                "dbparam_value" VARCHAR,
                CONSTRAINT "dbparam_pk" PRIMARY KEY ("dbparam_id")
);
COMMENT ON TABLE "dbparam" IS 'Table des parametres associes de maniere intrinseque a l''instance';
COMMENT ON COLUMN "dbparam"."dbparam_name" IS 'Nom du parametre';
COMMENT ON COLUMN "dbparam"."dbparam_value" IS 'Valeur du paramètre';

insert into dbparam(dbparam_id, dbparam_name, dbparam_value) values
 (1, 'APPLI_code', 'cs_code'),
 (2, 'APPLI_title', 'Collec-Science - instance for '),
 (3, 'mapDefaultX', '-0.70'),
 (4, 'mapDefaultY', '44.77'),
 (5, 'mapDefaultZoom', '7')

 ;


/*
 * Fin d'execution du script
 * Mise a jour de dbversion
 */
insert into dbversion ("dbversion_number", "dbversion_date")
values
('2.3','2019-08-14');
