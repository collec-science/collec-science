/**
 * Update to v2.7 from v2.6
 */
CREATE TABLE col.barcode (
  barcode_id serial NOT NULL,
  barcode_name varchar NOT NULL,
  barcode_code varchar NOT NULL DEFAULT 'QR',
  CONSTRAINT barcode_pk PRIMARY KEY (barcode_id)
);

-- ddl-end --
COMMENT ON TABLE col.barcode IS E'Models of barcodes usable';

-- ddl-end --
COMMENT ON COLUMN col.barcode.barcode_name IS E'Name of the model';

-- ddl-end --
COMMENT ON COLUMN col.barcode.barcode_code IS E'Value of the barcode used by the generating application, if occures. Default value: QR for QRcode';

-- ddl-end --
ALTER TABLE col.barcode OWNER TO collec;

-- ddl-end --
INSERT INTO col.barcode (barcode_name, barcode_code)
  VALUES (E'QRCode', E'QR');

-- ddl-end --
INSERT INTO col.barcode (barcode_name, barcode_code)
  VALUES (E'EAN 128', E'C128');

-- ddl-end --
ALTER TABLE col.label
  ADD COLUMN barcode_id integer NOT NULL DEFAULT 1;

ALTER TABLE col.label
  ADD CONSTRAINT barcode_fk FOREIGN KEY (barcode_id) REFERENCES col.barcode (barcode_id) MATCH FULL ON DELETE NO ACTION ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE col.campaign
  ADD COLUMN uuid uuid NOT NULL DEFAULT gen_random_uuid ();

COMMENT ON COLUMN col.campaign.uuid IS E'UUID of the campaign';

UPDATE
  col.dataset_type
SET
  fields = E'["uid","uuid","identifier","wgs84_x","wgs84_y","location_accuracy","object_status_name","referent_name","referent_email","address_name","address_line2","address_line3","address_city","address_country","referent_phone","referent_firstname","academic_directory","academic_link","object_comment","identifiers","sample_creation_date","sampling_date","multiple_value","sampling_place_name","expiration_date","sample_type_name","storage_product","clp_classification","multiple_type_name","collection_name","metadata","metadata_unit","parent_uid","parent_uuid","parent_identifiers","web_address","content_type","container_uid","container_identifier","container_uuid","storage_type_name","fixed_value","country_code","country_origin_code","trashed","campaign_id","campaign_name","campaign_uuid"]'
WHERE
  dataset_type_id = 1;


ALTER TABLE col.container_type
  ADD COLUMN line_in_char boolean NOT NULL DEFAULT FALSE,
  ADD COLUMN column_in_char boolean NOT NULL DEFAULT FALSE;

COMMENT ON COLUMN col.container_type.line_in_char IS E'Is the number of the line is displayed in character?';

COMMENT ON COLUMN col.container_type.column_in_char IS E'Is the number of the column is displayed in character?';


ALTER TABLE col.collection
  ADD COLUMN no_localization boolean NOT NULL DEFAULT FALSE;

COMMENT ON COLUMN col.collection.no_localization IS E'True if the localization of samples is not used';


ALTER TABLE col.subsample
  ADD COLUMN borrower_id int,
  ADD CONSTRAINT borrower_fk FOREIGN KEY (borrower_id) REFERENCES col.borrower (borrower_id) MATCH FULL ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;


ALTER TABLE col.request
  ADD COLUMN collection_id int,
  ADD CONSTRAINT collection_fk FOREIGN KEY (collection_id) REFERENCES col.collection (collection_id) MATCH FULL ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;


ALTER TABLE col.document
  ADD COLUMN external_storage boolean NOT NULL DEFAULT FALSE,
  ADD COLUMN external_storage_path varchar;

COMMENT ON COLUMN col.document.external_storage IS E'Is the document stored in the external storage?';

COMMENT ON COLUMN col.document.external_storage_path IS E'Path to the file, relative to the root of the external storage';

CREATE INDEX external_storage_path_idx ON col.document USING btree (external_storage_path);

CREATE INDEX uid_idx ON col.document USING btree (uid);

ALTER TABLE col.collection
  ADD COLUMN external_storage_enabled boolean NOT NULL DEFAULT FALSE,
  ADD COLUMN external_storage_root varchar;

COMMENT ON COLUMN col.collection.external_storage_root IS E'Root path of the documents stored out of the database';

COMMENT ON COLUMN col.collection.external_storage_enabled IS E'Enable the storage of sample''s documents out of the database';


UPDATE
  col.request
SET
  body = 'SELECT ' || body;


ALTER TABLE col.referent
  ADD COLUMN referent_organization varchar;

COMMENT ON COLUMN col.referent.referent_organization IS 'Referent''s organization';


INSERT INTO col.dbversion (dbversion_number, dbversion_date)
  VALUES ('2.7', '2022-06-20');
