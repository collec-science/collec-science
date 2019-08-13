/*
 * connexion a la base collec, avec l'utilisateur collec, en localhost,
 * depuis psql
 * from psql, connection to collec database with user collec on localhost server
 */
\c "dbname=collec user=collec password=collecPassword host=localhost"
\ir pgsql/gacl_alter_2.2-2.3.sql
\ir pgsql/col_alter_2.2-2.3.sql