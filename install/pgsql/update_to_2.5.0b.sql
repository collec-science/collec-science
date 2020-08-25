alter table col.dataset_template add column xslcontent varchar ;
COMMENT ON COLUMN col.dataset_template.xslcontent IS E'Transformation of the generated xml to create a specific xml file';
