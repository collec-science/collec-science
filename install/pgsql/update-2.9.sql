CREATE UNIQUE INDEX referent_referent_name_firstname_idx ON col.referent USING btree (referent_name,referent_firstname);
drop index col.referent_referent_name_idx;
alter table col.container add column collection_id int;
ALTER TABLE col.container ADD CONSTRAINT collection_fk FOREIGN KEY (collection_id)
REFERENCES col.collection (collection_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
CREATE INDEX container_collection_id_idx ON col.container
USING btree(collection_id);
