/*
 * COLLEC - 29/05/2017
 * Script de creation des tables destinees a recevoir les donnees de l'application
 * version minimale de Postgresql : 9.4.
 * Schemas par defaut : col pour les donnees, et gacl pour les droits. 
 * Si vous voulez utiliser d'autres schemas, modifiez les scripts 
 * gacl_create_1.1.sql et col_create_1.1.sql en consequence
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
 * connexion a la base collec, avec l'utilisateur collec, en localhost,
 * depuis psql
 */
\c "dbname=collec user=collec password=collecPassword host=localhost"

/*
 * Creation des tables dans le schema gacl
 */
\ir ./gacl_create-1.1.sql

/*
 * Creation des tables dans le schema col
 */
\ir ./col_create_1.2.sql
