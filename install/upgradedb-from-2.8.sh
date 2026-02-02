#!/bin/bash
ROOT=install/pgsql
psql $ADDRESS -f "$ROOT/col_alter_2.8-2.8.1.sql"
psql $ADDRESS -f "$ROOT/col_alter_2.8.1-24.0.sql"
psql $ADDRESS -f "$ROOT/col_alter_24.0-24.1.sql"
psql $ADDRESS -f "$ROOT/col_alter_24.1-25.0.sql"
psql $ADDRESS -f "$ROOT/col_alter_25.0-26.0.sql"
psql $ADDRESS -f "$ROOT/col_alter_26.0-26.1.sql"