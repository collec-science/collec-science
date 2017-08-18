set search_path=col;

ALTER TABLE "container_type" ADD COLUMN "columns" INTEGER DEFAULT 1 NOT NULL;
ALTER TABLE "container_type" ADD COLUMN "lines" INTEGER DEFAULT 1 NOT NULL;

comment on column container_type.columns is 'Nombre de colonnes de stockage dans le container';
comment on column container_type.lines is 'Nombre de lignes de stockage dans le container';

ALTER TABLE "storage" ADD COLUMN "column_number" INTEGER;
ALTER TABLE "storage" ADD COLUMN "line_number" INTEGER;

comment on column storage.column_number is 'N¢X de la colonne de stockage dans le container';
comment on column storage.line_number is 'N¢X de la ligne de stockage dans le container';

