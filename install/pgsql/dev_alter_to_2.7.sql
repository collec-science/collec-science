/**
 * Update to v2.7 - develop
 */

/*
 * 3/2/2022
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

INSERT INTO col.barcode (barcode_name, barcode_code) VALUES (E'QRCode', E'QR');
-- ddl-end --
INSERT INTO col.barcode (barcode_name, barcode_code) VALUES (E'EAN 128', E'C128');
-- ddl-end --

alter table col.label add column barcode_id integer NOT null default 1;

ALTER TABLE col.label ADD CONSTRAINT barcode_fk FOREIGN KEY (barcode_id)
REFERENCES col.barcode (barcode_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;

