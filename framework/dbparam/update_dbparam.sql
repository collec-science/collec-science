alter table col.dbparam add column dbparam_description varchar;
alter table col.dbparam add column dbparam_description_en varchar;
COMMENT ON COLUMN col.dbparam.dbparam_description IS E'Description of the parameter';
-- ddl-end --
COMMENT ON COLUMN col.dbparam.dbparam_description_en IS E'Description of the parameter, in English';
-- ddl-end --

update col.dbparam set dbparam_description = 'Code de l''instance. Ce code figurera dans les QRcodes', dbparam_description_en = 'Instance code. This code will appear in the Qrcodes' where dbparam_name = 'APPLI_code';
update col.dbparam set dbparam_description = 'Nom de l''instance, affiché dans l''interface', dbparam_description_en = 'Instance name, displayed in the interface' where dbparam_name = 'APPLI_title';
update col.dbparam set dbparam_description = 'Longitude de positionnement par défaut des cartes', dbparam_description_en = 'Default positioning longitude for maps' where dbparam_name = 'mapDefaultX';
update col.dbparam set dbparam_description = 'Latitude de positionnement par défaut des cartes', dbparam_description_en = 'Default positioning latitude for maps' where dbparam_name = 'mapDefaultY';
update col.dbparam set dbparam_description = 'Niveau de zoom par défaut dans les cartes', dbparam_description_en = 'Default zoom level in maps' where dbparam_name = 'mapDefaultZoom';
update col.dbparam set dbparam_description = 'Nom affiché dans les applications de génération de codes uniques pour l''identification à double facteur', dbparam_description_en = 'Name displayed in applications generating unique codes for two-factor identification' where dbparam_name = 'otp_issuer';