/*
 * issue #592
 */

alter table col.event add column due_date timestamp,
alter column event_date drop not null
;
COMMENT ON COLUMN col.event.due_date IS E'Due date of the event';

-- object: event_date_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.event_date_idx CASCADE;
CREATE INDEX event_date_idx ON col.event
USING btree
(
	event_date
);
-- ddl-end --

-- object: due_date_idx | type: INDEX --
-- DROP INDEX IF EXISTS col.due_date_idx CASCADE;
CREATE INDEX due_date_idx ON col.event
USING btree
(
	due_date
);
-- ddl-end --
