alter table gacl.acllogin add column totp_key varchar;
COMMENT ON COLUMN gacl.acllogin.totp_key IS E'TOTP secret key for the user';
CREATE UNIQUE INDEX acllogin_login_idx ON gacl.acllogin
	USING btree
	(
	  login
	);
create sequence metabo.dbparam_dbparam_id_seq;
select setval( 'metabo.dbparam_dbparam_id_seq', (select max(dbparam_id) from metabo.dbparam));
alter table metabo.dbparam alter column dbparam_id set default nextval('metabo.dbparam_dbparam_id_seq');
insert into metabo.dbparam (dbparam_name, dbparam_value) values ('otp_issuer', 'metabo');
