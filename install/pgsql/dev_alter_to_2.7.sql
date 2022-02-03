/**
 * Update to v2.7 - develop
 */

/*
 * 3/2/2022
 */
CREATE TABLE col.barcode_type (
	barcode_id serial NOT NULL,
	barcode_name varchar NOT NULL,
	barcode_code varchar NOT NULL DEFAULT 'QR',
	CONSTRAINT barcode_type_pk PRIMARY KEY (barcode_id)

);
-- ddl-end --
COMMENT ON TABLE col.barcode_type IS E'Models of barcodes usable';
-- ddl-end --
COMMENT ON COLUMN col.barcode_type.barcode_name IS E'Name of the model';
-- ddl-end --
COMMENT ON COLUMN col.barcode_type.barcode_code IS E'Value of the barcode used by the generating application, if occures. Default value: QR for QRcode';
-- ddl-end --
ALTER TABLE col.barcode_type OWNER TO collec;
-- ddl-end --

INSERT INTO col.barcode_type (barcode_name, barcode_code) VALUES (E'QRCode', E'QR');
-- ddl-end --
INSERT INTO col.barcode_type (barcode_name, barcode_code) VALUES (E'EAN 128', E'C128');
-- ddl-end --

alter table col.label add column barcode_id integer NOT null default 1;

ALTER TABLE col.label ADD CONSTRAINT barcode_type_fk FOREIGN KEY (barcode_id)
REFERENCES col.barcode_type (barcode_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;


