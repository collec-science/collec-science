/**
 * TOTP support
 */
alter table gacl.acllogin add column totp_key varchar;
COMMENT ON COLUMN gacl.acllogin.totp_key IS E'TOTP secret key for the user';
CREATE UNIQUE INDEX acllogin_login_idx ON gacl.acllogin
	USING btree
	(
	  login
	);
create sequence col.dbparam_dbparam_id_seq;
select setval( 'col.dbparam_dbparam_id_seq', (select max(dbparam_id) from col.dbparam));
alter table col.dbparam alter column dbparam_id set default nextval('col.dbparam_dbparam_id_seq');
insert into col.dbparam (dbparam_name, dbparam_value) values ('otp_issuer', 'collec-science');

/**
 * v_subsample_quantity
 */
create view col.v_subsample_quantity as (
select sample_id, uid, multiple_value,  
coalesce ((select sum(subsample_quantity) from col.subsample smore where smore.movement_type_id = 1 and smore.sample_id = s.sample_id),0) as subsample_more,
coalesce ((select sum(subsample_quantity) from col.subsample sless where sless.movement_type_id  = 2 and sless.sample_id = s.sample_id),0) as subsample_less
from col.sample s
)
;
