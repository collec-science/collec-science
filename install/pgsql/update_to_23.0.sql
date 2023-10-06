insert into col.dbparam (dbparam_name, dbparam_value) values ('containerNameUnique', '1');
alter table col.collection add column sample_name_unique boolean NOT NULL DEFAULT false;
COMMENT ON COLUMN col.collection.sample_name_unique IS E'True if the sample identifier must be unique in the collection';
