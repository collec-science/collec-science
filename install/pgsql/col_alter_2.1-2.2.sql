set search_path = col;
insert into dbparam (dbparam_id, dbparam_name, dbparam_value) 
values 
(3, 'mapDefaultX', -0.70),
(4, 'mapDefaultY', 44.77),
(5, 'mapDefaultZoom', 7)
;

CREATE SEQUENCE "referent_referent_id_seq";

CREATE TABLE "referent" (
                "referent_id" INTEGER NOT NULL DEFAULT nextval('"referent_referent_id_seq"'),
                referent_name varchar not null,
                referent_email varchar,
                address_name varchar,
                address_line2 varchar,
                address_line3 varchar,
                address_city varchar,
                address_country varchar,
                referent_phone varchar,
                CONSTRAINT referent_pk PRIMARY KEY (referent_id)
);
comment on table referent is 'Table of sample referents';
comment on column referent.referent_name is 'Name, firstname-lastname or department name';
comment on column referent.referent_email is 'Email for contact';
comment on column referent.address_name is 'Name for postal address';
comment on column referent.address_line2 is 'second line in postal address';
comment on column referent.address_line3 is 'third line in postal address';
comment on column referent.address_city is 'ZIPCode and City in postal address';
comment on column referent.address_country is 'Country in postal address';
comment on column referent.referent_phone is 'Contact phone';
alter sequence referent_referent_id_seq OWNED BY referent.referent_id;

alter table object add COLUMN referent_id int,
ADD CONSTRAINT "referent_object_fk"
FOREIGN KEY ("referent_id")
REFERENCES "referent" ("referent_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

alter table collection add COLUMN referent_id int,
ADD CONSTRAINT "referent_collection_fk"
FOREIGN KEY ("referent_id")
REFERENCES "referent" ("referent_id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE UNIQUE INDEX referent_referent_name_idx ON col.referent
	USING btree
	(
	  referent_name COLLATE pg_catalog."default" ASC NULLS LAST
	)
	TABLESPACE pg_default;
