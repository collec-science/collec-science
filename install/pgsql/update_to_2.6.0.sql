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
/**
 * country origin
 */
alter table col.sample add column country_origin_id int;
ALTER TABLE col.sample ADD CONSTRAINT country_fk1 FOREIGN KEY (country_origin_id)
REFERENCES col.country (country_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;

/**
 * dataset_template
 */
alter table col.dataset_column add column search_order smallint;
COMMENT ON COLUMN col.dataset_column.search_order IS E'To search a sample, order of the current field to trigger the search';

update col.dataset_type 
set fields = '["uid","uuid","identifier","wgs84_x","wgs84_y","location_accuracy","object_status_name","referent_name","referent_email","address_name","address_line2","address_line3","address_city","address_country","referent_phone","referent_firstname","academic_directory","academic_link","object_comment","identifiers","sample_creation_date","sampling_date","multiple_value","sampling_place_name","expiration_date","sample_type_name","storage_product","clp_classification","multiple_type_name","collection_name","metadata","metadata_unit","parent_uid","parent_uuid","parent_identifiers","web_address","content_type","container_uid","container_identifier","container_uuid","storage_type_name","fixed_value","country_code","country_origin_code","trashed"]'
where dataset_type_id = 1;


/**
 * end of script
 */
INSERT INTO col.dbversion (dbversion_number, dbversion_date) VALUES (E'2.6', E'2021-04-16');