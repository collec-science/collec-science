set search_path = col;

DROP VIEW IF EXISTS last_movement CASCADE;
CREATE VIEW last_movement
AS 

SELECT s.uid,
    s.movement_id,
    s.movement_date,
    s.movement_type_id,
    s.container_id,
    c.uid AS container_uid,
    s.line_number,
    s.column_number,
    s.movement_reason_id
   FROM (movement s
     LEFT JOIN container c USING (container_id))
  WHERE (s.movement_id = ( SELECT st.movement_id
           FROM movement st
          WHERE (s.uid = st.uid)
          ORDER BY st.movement_date DESC
         LIMIT 1));

alter table protocol
add column authorization_number varchar,
add column authorization_date timestamp;
comment on column protocol.authorization_number is 'Number of the prelevement authorization';
comment on column protocol.authorization_date is 'Date of the prelevement authorization';


-- object: borrower_borrower_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS borrower_borrower_id_seq CASCADE;
CREATE SEQUENCE borrower_borrower_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: borrower | type: TABLE --
-- DROP TABLE IF EXISTS borrower CASCADE;
CREATE TABLE borrower (
	borrower_id integer NOT NULL DEFAULT nextval('borrower_borrower_id_seq'::regclass),
	borrower_name varchar NOT NULL,
	borrower_address varchar,
	borrower_phone varchar,
	CONSTRAINT borrower_pk PRIMARY KEY (borrower_id)

);
-- ddl-end --
COMMENT ON TABLE borrower IS 'List of borrowers';
-- ddl-end --
COMMENT ON COLUMN borrower.borrower_address IS 'Address of the borrower';
-- ddl-end --
COMMENT ON COLUMN borrower.borrower_phone IS 'Phone of the contact of the borrower';
-- ddl-end --


-- object: borrowing_borrowing_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS borrowing_borrowing_id_seq CASCADE;
CREATE SEQUENCE borrowing_borrowing_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: borrowing | type: TABLE --
-- DROP TABLE IF EXISTS borrowing CASCADE;
CREATE TABLE borrowing (
	borrowing_id integer NOT NULL DEFAULT nextval('borrowing_borrowing_id_seq'::regclass),
	borrowing_date timestamp NOT NULL,
	expected_return_date timestamp,
	uid integer NOT NULL,
	borrower_id integer NOT NULL,
	return_date timestamp,
	CONSTRAINT borrowing_pk PRIMARY KEY (borrowing_id)

);
-- ddl-end --
COMMENT ON COLUMN borrowing.borrowing_date IS 'Date of the borrowing';
-- ddl-end --
COMMENT ON COLUMN borrowing.expected_return_date IS 'Expected return date of the object';
-- ddl-end --
COMMENT ON COLUMN borrowing.return_date IS 'Date of return of the object';
-- ddl-end --




-- object: borrowing_uid_idx | type: INDEX --
-- DROP INDEX IF EXISTS borrowing_uid_idx CASCADE;
CREATE INDEX borrowing_uid_idx ON borrowing
	USING btree
	(
	  uid
	);
-- ddl-end --

-- object: borrowing_borrower_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS borrowing_borrower_id_idx CASCADE;
CREATE INDEX borrowing_borrower_id_idx ON borrowing
	USING btree
	(
	  borrower_id
	);
-- ddl-end --

-- [ Created foreign keys ] --
-- object: object_fk | type: CONSTRAINT --
-- ALTER TABLE borrowing DROP CONSTRAINT IF EXISTS object_fk CASCADE;
ALTER TABLE borrowing ADD CONSTRAINT object_fk FOREIGN KEY (uid)
REFERENCES object (uid) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: borrower_fk | type: CONSTRAINT --
-- ALTER TABLE borrowing DROP CONSTRAINT IF EXISTS borrower_fk CASCADE;
ALTER TABLE borrowing ADD CONSTRAINT borrower_fk FOREIGN KEY (borrower_id)
REFERENCES borrower (borrower_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

insert into object_status (object_status_id, object_status_name)
values
(6, 'Objet prêté');
select setval('object_status_object_status_id_seq', 6);

create or replace view last_borrowing as (
select borrowing_id, uid, borrowing_date, expected_return_date, borrower_id
from borrowing b1
 where borrowing_id = (
 select borrowing_id from borrowing b2
 where b1.uid = b2.uid 
 and b2.return_date is null
 order by borrowing_date desc limit 1));

 insert into dbversion (dbversion_number, dbversion_date)
 values
 ('2.3', '2019-08-14');
