create view col.aclgroup as 
(select * from gacl.aclgroup);
ALTER TABLE "eabxcol"."col"."object" ADD COLUMN "wgs84_x" DOUBLE PRECISION;
comment on column col.object.wgs84_x is 'Longitude GPS, en valeur décimale';
ALTER TABLE "eabxcol"."col"."object" ADD COLUMN "wgs84_y" DOUBLE PRECISION;
comment on column col.object.wgs84_y is 'Latitude GPS, en valeur décimale';

CREATE SEQUENCE "eabxcol"."col"."booking_booking_id_seq";

CREATE TABLE "eabxcol"."col"."booking" (
                "booking_id" INTEGER NOT NULL DEFAULT nextval('"eabxcol"."col"."booking_booking_id_seq"'),
                "uid" INTEGER NOT NULL,
                "booking_date" TIMESTAMP NOT NULL,
                "date_from" TIMESTAMP NOT NULL,
                "date_to" TIMESTAMP NOT NULL,
                "booking_comment" VARCHAR,
                "booking_login" VARCHAR NOT NULL,
                CONSTRAINT "booking_pk" PRIMARY KEY ("booking_id")
);
COMMENT ON TABLE "eabxcol"."col"."booking" IS 'Table des réservations d''objets';
COMMENT ON COLUMN "eabxcol"."col"."booking"."booking_date" IS 'Date de la réservation';
COMMENT ON COLUMN "eabxcol"."col"."booking"."date_from" IS 'Date-heure de début de la réservation';
COMMENT ON COLUMN "eabxcol"."col"."booking"."date_to" IS 'Date-heure de fin de la réservation';
COMMENT ON COLUMN "eabxcol"."col"."booking"."booking_comment" IS 'Commentaire';
COMMENT ON COLUMN "eabxcol"."col"."booking"."booking_login" IS 'Compte ayant réalisé la réservation';


ALTER SEQUENCE "eabxcol"."col"."booking_booking_id_seq" OWNED BY "eabxcol"."col"."booking"."booking_id";
ALTER TABLE "eabxcol"."col"."booking" ADD CONSTRAINT "object_booking_fk"
FOREIGN KEY ("uid")
REFERENCES "eabxcol"."col"."object" ("uid")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
