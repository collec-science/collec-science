#!/bin/bash 
#!This is local_pg_dumpall
#Script de backup sequentiel avec support des gros blobs des bases postgres

PSQL_VERSION=`psql --version | cut -f 3 -d ' ' | cut -d '.' -f 1,2`
DUMPPATH=/var/lib/postgresql/backup
#cree le repertoire de backup s'il n'existe pas
if [ ! -d $DUMPPATH ] 
then
 mkdir -p $DUMPPATH
 chmod o-r,o-x,o-w $DUMPPATH
 fi
# chown -R postgres:postgres $DUMPPATH
LOG=$DUMPPATH/pgbackup.log
echo `date` > $LOG
echo "Sauvegarde des bases de donnees - dumpall" >>$LOG
/usr/bin/pg_dumpall |gzip -c > $DUMPPATH/pg.out.gz 2>>$LOG

# Pour chaque base de données
LIST=$(psql -tl | cut -d '|' -f1 | grep -v ' : ')
echo Liste des bases : $LIST

for DBNAME in $LIST
	do
    # Ne backup pas les bases "modèles" de postgresql
    [ "$DBNAME" = "template0" -o "$DBNAME" = "template1" ] && continue

    # Dump la base :
    echo -n Dumping "$DBNAME" : >> $LOG
    if pg_dump --blobs ${DBNAME} | gzip -9 -c >${DUMPPATH}/${DBNAME}.gz; then
	echo "ok" > /dev/null
    else
        rm -f ${DUMPPATH}/${DBNAME}.tgz
        echo "FAILED!" >>$LOG
    fi
    # ajout du vacuum - EQ le 31/8/17
    vacuumdb -d "$DBNAME" --analyze 
done

cp /etc/postgresql/${PSQL_VERSION}/main/pg_hba.conf ${DUMPPATH}
