/*
 * connexion a la base collec, avec l'utilisateur collec, en localhost,
 * depuis psql
 * from psql, connection to collec database with user collec on localhost server
 */
CREATE EXTENSION postgis
WITH SCHEMA public;
-- ddl-end --
-- object: btree_gin | type: EXTENSION --
-- DROP EXTENSION IF EXISTS btree_gin CASCADE;
CREATE EXTENSION IF NOT EXISTS btree_gin
WITH SCHEMA pg_catalog;
-- ddl-end --

-- object: pgcrypto | type: EXTENSION --
-- DROP EXTENSION IF EXISTS pgcrypto CASCADE;
CREATE EXTENSION pgcrypto
WITH SCHEMA public;
-- ddl-end --


-- object: grant_95c2183ced | type: PERMISSION --
GRANT CREATE,CONNECT,TEMPORARY
   ON DATABASE collec
   TO collec;
-- ddl-end --

\c "dbname=collec user=collec password=collecPassword host=localhost"
\ir pgsql/col_alter_2.3-2.4.sql