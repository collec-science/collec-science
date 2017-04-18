/*
 * COLLEC - 18/04/2017
 * Script de population des  tables de gestion des droits et des traces avec le nom du schema d''application passé en paramètres
 * et celui d'un utilisateur id à qui on donne tous les droits
 */

 /* When database were created, the gacl_create-1.0.sql has inserted those rows : */
 /*
insert into aclappli (aclappli_id, appli) values (1, 'col');
insert into aclaco (aclaco_id, aclappli_id, aco) values (1, 1, 'admin');
insert into acllogin (acllogin_id, login, logindetail) values (1, 'admin', 'admin');
insert into aclgroup (aclgroup_id, groupe) values (1, 'admin');
insert into acllogingroup (acllogin_id, aclgroup_id) values (1, 1);
insert into aclacl (aclaco_id, aclgroup_id) values (1, 1);
insert into logingestion (id, login, password, nom) values (1, 'admin', 'cd916028a2d8a1b901e831246dd5b9b4d3832786ddc63bbf5af4b50d9fc98f50', 'Administrator');
*/

-- Now we considered that we are using many schema names for application ( $GACL_aco) --
-- We always need an admin with password 'password' -->
-- admin must belong to group 'param_group' who as the right 'param' (the right param must also be created)
-- This script creates a function that create all those groups, and associated rights

/*
*/

-- @script
-- @identifier create_rights_for_user
-- @title
-- @abstract
-- Create for a given user (all necessary groups and rights) for a given application in the specified schema of GACL
-- Pour tester (admin user is the first one, having 1 as id) : select create_rights_for_user('gacl', 'col', 1);
-- @/abstract
-- @input gacl_schema CHARACTER VARYING : the name of the GACL  schema in the database( $GACL_schema)
-- @input appli_name CHARACTER VARYING : the name of the application code in GACL  ( $GACL_aco)
-- @input userid integer : id of the user having all rights in the application (admin)
-- @/script

DROP FUNCTION IF EXISTS public.create_rights_for_user(CHARACTER VARYING);

CREATE OR REPLACE FUNCTION public.create_rights_for_user(gacl_schema CHARACTER VARYING, appli_name CHARACTER VARYING, userid integer) RETURNS INTEGER AS
$BODY$
DECLARE
	appli_id INTEGER;
	aco_id INTEGER;
	group_id INTEGER;

	test VARCHAR;
	appli_table VARCHAR := gacl_schema||'.'||'aclappli';
	aco_table VARCHAR := gacl_schema||'.'||'aclaco';
	group_table VARCHAR := gacl_schema||'.'||'aclgroup';
	aco_group_table VARCHAR := gacl_schema||'.'||'aclacl';
	login_group_table VARCHAR := gacl_schema||'.'||'acllogingroup';
BEGIN
	-- Find the unique id of the appli in the schema gacl
	EXECUTE 'SELECT aclappli_id FROM '||appli_table||' where appli = '''||appli_name||''' ' INTO appli_id;
	raise notice 'Mon identifiant appli %', appli_id;

	-- First, insert new corresponding rights for this application (values are invariant, hardcoded in PHP code)
	EXECUTE 'insert into '||aco_table||' (aclappli_id, aco) values ( '||appli_id ||', ''admin'');';
	EXECUTE 'insert into '||aco_table||' (aclappli_id, aco) values ( '||appli_id ||', ''param'');';
	EXECUTE 'insert into '||aco_table||' (aclappli_id, aco) values ( '||appli_id ||', ''projet'');';
	EXECUTE 'insert into '||aco_table||' (aclappli_id, aco) values ( '||appli_id ||', ''gestion'');';
	EXECUTE 'insert into '||aco_table||' (aclappli_id, aco) values ( '||appli_id ||', ''consult'');';


	-- Second, insert new groups for this application (values are free, but coded in a readable manner for this code)
	-- test := 'insert into '||group_table||'  (groupe) values ( ''param_group'');';
	--raise notice 'insert GROUP %', test;
	EXECUTE 'insert into '||group_table||'  (groupe) values ( ''param_group'');';
	EXECUTE 'insert into '||group_table||'  (groupe) values ( ''projet_group'');';
	EXECUTE 'insert into '||group_table||'  (groupe) values ( ''gestion_group'');';
	EXECUTE 'insert into '||group_table||'  (groupe) values ( ''consult_group'');';

	-- Third associate those group to their corresponding rights and put the user admin into the group

	-- Associate the right ''param'' with the user
    EXECUTE 'select aclaco_id from '||aco_table||' where aclappli_id = '||appli_id ||' and aco = ''param'' ' INTO aco_id ;
    EXECUTE 'select aclgroup_id from '||group_table||' where groupe = ''param_group'' ' INTO group_id ;
    EXECUTE 'insert into '||aco_group_table||' (aclaco_id, aclgroup_id) values ('||aco_id||','||group_id||') ;';
    EXECUTE 'insert into '||login_group_table||' (acllogin_id, aclgroup_id) values ('||userid||','||group_id||') ;';

    --  Associate the right ''projet'' with the user
    EXECUTE 'select aclaco_id from '||aco_table||' where aclappli_id = '||appli_id ||' and aco = ''projet'' ' INTO aco_id ;
    EXECUTE 'select aclgroup_id from '||group_table||' where groupe = ''projet_group'' ' INTO group_id ;
    EXECUTE 'insert into '||aco_group_table||' (aclaco_id, aclgroup_id) values ('||aco_id||','||group_id||') ;';
    EXECUTE 'insert into '||login_group_table||' (acllogin_id, aclgroup_id) values ('||userid||','||group_id||') ;';

    -- Associate  the right ''gestion'' with the user
    EXECUTE 'select aclaco_id from '||aco_table||' where aclappli_id = '||appli_id ||' and aco = ''gestion'' ' INTO aco_id ;
    EXECUTE 'select aclgroup_id from '||group_table||' where groupe = ''gestion_group'' ' INTO group_id ;
    EXECUTE 'insert into '||aco_group_table||' (aclaco_id, aclgroup_id) values ('||aco_id||','||group_id||') ;';
    EXECUTE 'insert into '||login_group_table||' (acllogin_id, aclgroup_id) values ('||userid||','||group_id||') ;';

    --  Associate the right ''consult'' with the user
    EXECUTE 'select aclaco_id from '||aco_table||' where aclappli_id = '||appli_id ||' and aco = ''consult'' ' INTO aco_id ;
    EXECUTE 'select aclgroup_id from '||group_table||' where groupe = ''consult_group'' ' INTO group_id ;
    EXECUTE 'insert into '||aco_group_table||' (aclaco_id, aclgroup_id) values ('||aco_id||','||group_id||') ;';
    EXECUTE 'insert into '||login_group_table||' (acllogin_id, aclgroup_id) values ('||userid||','||group_id||') ;';

    RETURN appli_id;
END;
$BODY$ LANGUAGE plpgsql VOLATILE;


