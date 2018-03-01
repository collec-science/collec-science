set search_path = gacl;

ALTER TABLE "logingestion" ADD COLUMN "is_clientws" BOOLEAN DEFAULT false NOT NULL;

ALTER TABLE "logingestion" ADD COLUMN "tokenws" VARCHAR;
