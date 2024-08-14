#!/bin/bash
ROOT=install/pgsql
psql $ADDRESS -f "$ROOT/col_alter_2.6-2.7.sql"
psql $ADDRESS -f "$ROOT/col_alter_2.7-2.8.sql"
psql $ADDRESS -f "$ROOT/col_alter_2.8-2.8.1.sql"
psql $ADDRESS -f "$ROOT/col_alter_2.8.1-24.0.sql"
psql $ADDRESS -f "$ROOT/col_alter_24.0-24.1.sql"
