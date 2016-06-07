ALTER TABLE "eabxcol"."col"."container" DROP CONSTRAINT "container_container_fk";

ALTER TABLE "eabxcol"."col"."container" DROP COLUMN "parent_container_id";

ALTER TABLE "eabxcol"."col"."container" DROP COLUMN "container_range";
