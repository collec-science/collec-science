/*
 * Collec-Science - 4/5/2018
 * Script de modification de la base de donnees
 * basculement de la version 1.2.3 a la version 2.0
 * Execution de ce script en ligne de commande, en etant connecte root :
 * su postgres -c "psql -f upgrade-1.2-1.2.3.sql"
 */

\c "dbname=collec"
create extension if not exists pg_trgm with schema pg_catalog;

/*
 * connexion a la base collec, avec l'utilisateur collec, en localhost,
 * depuis psql
 */
\c "dbname=collec user=collec password=collecPassword host=localhost"

\ir pgsql/col_alter_1.2-1.2.3.sql
