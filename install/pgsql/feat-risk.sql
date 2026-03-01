-- object: col.risk | type: TABLE --
-- DROP TABLE IF EXISTS col.risk CASCADE;
CREATE TABLE col.risk (
	risk_id serial NOT NULL,
	risk_name varchar NOT NULL,
	CONSTRAINT risk_pk PRIMARY KEY (risk_id)
);
-- ddl-end --
COMMENT ON TABLE col.risk IS E'Risks attached to a sample or a container';
-- ddl-end --
COMMENT ON COLUMN col.risk.risk_name IS E'Risk classification according to the European CLP directive';
-- ddl-end --

alter table col.sample_type add column risk_id integer;
alter table col.container_type add column risk_id integer;

-- object: col.product | type: TABLE --
-- DROP TABLE IF EXISTS col.product CASCADE;
CREATE TABLE col.product (
	product_id serial NOT NULL,
	product_name varchar NOT NULL,
	CONSTRAINT product_pk PRIMARY KEY (product_id)
);
-- ddl-end --
COMMENT ON TABLE col.product IS E'List of products used with samples or containers';
-- ddl-end --
COMMENT ON COLUMN col.product.product_name IS E'Name of the product';
-- ddl-end --

alter table col.sample_type add column product_id integer;
alter table col.container_type add column product_id integer;

insert into col.risk (risk_name)
select distinct clp_classification
from col.container_type
where clp_classification is not null;

insert into col.product (product_name)
select distinct storage_product
from col.container_type
where storage_product is not null;

update col.container_type
set risk_id = (
    select risk_id from col.risk
    where clp_classification = risk_name
)
where clp_classification is not null;

update col.container_type
set product_id = (
    select product_id from col.product
    where storage_product = product_name
)
where storage_product is not null;

update col.sample_type s
set risk_id = (
    select risk_id from col.risk
    where clp_classification = risk_name
)
from container_type c
where s.container_type_id = c.container_type_id
and clp_classification is not null;

update col.sample_type s
set product_id = (
    select product_id from col.product
    where storage_product = product_name
)
from container_type c
where s.container_type_id = c.container_type_id
and storage_product is not null;

alter table col.container_type drop column storage_product;
alter table col.container_type drop column clp_classification;

-- object: product_fk | type: CONSTRAINT --
-- ALTER TABLE col.sample_type DROP CONSTRAINT IF EXISTS product_fk CASCADE;
ALTER TABLE col.sample_type ADD CONSTRAINT product_fk FOREIGN KEY (product_id)
REFERENCES col.product (product_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: product_fk | type: CONSTRAINT --
-- ALTER TABLE col.container_type DROP CONSTRAINT IF EXISTS product_fk CASCADE;
ALTER TABLE col.container_type ADD CONSTRAINT product_fk FOREIGN KEY (product_id)
REFERENCES col.product (product_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --


-- object: risk_fk | type: CONSTRAINT --
-- ALTER TABLE col.sample_type DROP CONSTRAINT IF EXISTS risk_fk CASCADE;
ALTER TABLE col.sample_type ADD CONSTRAINT risk_fk FOREIGN KEY (risk_id)
REFERENCES col.risk (risk_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: risk_fk | type: CONSTRAINT --
-- ALTER TABLE col.container_type DROP CONSTRAINT IF EXISTS risk_fk CASCADE;
ALTER TABLE col.container_type ADD CONSTRAINT risk_fk FOREIGN KEY (risk_id)
REFERENCES col.risk (risk_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --
