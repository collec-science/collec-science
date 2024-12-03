
CREATE USER collec WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
 PASSWORD 'collecPassword'
;

/*
 * Database creation
 */
create database collec owner collec;
\c "dbname=collec"
 create extension if not exists postgis schema public;
 create extension if not exists pgcrypto schema public;
 create extension if not exists pg_trgm schema pg_catalog;


\c "dbname=collec user=collec password=collecPassword host=localhost"

/**
 * create structure
 */
\ir pgsql/collec_create.sql
