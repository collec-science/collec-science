/*
 * Script de modification base collec version 1.0.5 -> 1.0.6
 * a executer dans tous les schemas contenant des donnees
 * adapter la commande set search_path au schema concerne
 */

set search_path=col;

alter table sample add column dbuid_origin varchar;
comment on column sample.dbuid_origin is 'référence utilisée dans la base de données d''origine, sous la forme db:uid
Utilisé pour lire les étiquettes créées dans d''autres instances';

