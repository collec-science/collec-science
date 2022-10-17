CREATE UNIQUE INDEX referent_referent_name_firstname_idx ON col.referent USING btree (referent_name,referent_firstname);
drop index col.referent_referent_name_idx;