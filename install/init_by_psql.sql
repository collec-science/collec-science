
CREATE USER sturwild WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
 PASSWORD 'sturwildPassword'
;

/*
 * Database creation
 */
create database sturwild owner sturwild;
\c "dbname=sturwild"
 create extension if not exists postgis schema public;
 create extension if not exists pgcrypto schema public;


\c "dbname=sturwild user=sturwild password=sturwildPassword host=localhost"

/**
 * create structure
 */
\ir pgsql/createtables.sql
\ir translatedb/comment_sql.sql
\ir translatedb/param_en.sql

