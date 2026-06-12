INSERT INTO col.dataset_type (dataset_type_id, dataset_type_name, fields) VALUES (E'5', E'elabftw', DEFAULT);
-- ddl-end --
COMMENT ON TABLE col.dataset_type IS E'Origine of the dataset: sample, collection, document, elabftw';
-- ddl-end --
INSERT INTO col.dataset_template (dataset_template_name, export_format_id, separator, filename, dataset_type_id) 
VALUES (E'elabftw', E'1', E',', E'export_to_elabftw.csv', E'5');
-- ddl-end --
