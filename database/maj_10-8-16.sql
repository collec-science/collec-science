create view col.aclgroup as 
(select * from gacl.aclgroup);
ALTER TABLE "eabxcol"."col"."object" ADD COLUMN "wgs84_x" DOUBLE PRECISION;
comment on column col.object.wgs84_x is 'Longitude GPS, en valeur décimale';
ALTER TABLE "eabxcol"."col"."object" ADD COLUMN "wgs84_y" DOUBLE PRECISION;
comment on column col.object.wgs84_y is 'Latitude GPS, en valeur décimale';
