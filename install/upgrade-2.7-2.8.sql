/*
 * connexion a la base collec, avec l'utilisateur collec, en localhost,
 * depuis psql
 * from psql, connection to collec database with user collec on localhost server
 */
\c "dbname=collec user=collec password=collecPassword host=localhost"
\ir pgsql/col_alter_2.7-2.8.sql
