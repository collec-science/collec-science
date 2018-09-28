/*
 * Collec-Science - 22/6/2018  / 2018-06-22
 * Script de modification de la base de donnees / update database script
 * basculement de la version 2.0 ou 2.0.1 a la version 2.1 /upgrade from 2.0 or 2.0.1 to 2.1
 * Execution de ce script en ligne de commande, en etant connecte root :
 * at prompt, connected as root:
 * su postgres -c "psql -f upgrade-2.0-2.1.sql"
 */

/*
 * connexion a la base collec, avec l'utilisateur collec, en localhost,
 * depuis psql
 * from psql, connection to collec database with user collec on localhost server
 */
\c "dbname=collec user=collec password=collecPassword host=localhost"

\ir pgsql/col_alter_2.1-2.2.sql
