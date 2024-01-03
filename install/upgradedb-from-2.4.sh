#!/bin/bash
ROOT=install/pgsql
psql $ADDRESS -f "$ROOT/col_alter_2.4-2.5.sql"
psql $ADDRESS -f "$ROOT/col_alter_2.5-2.6.sql"
psql $ADDRESS -f "$ROOT/col_alter_2.6-2.7.sql"
psql $ADDRESS -f "$ROOT/col_alter_2.7-2.8.sql"
psql $ADDRESS -f "$ROOT/col_alter_2.8-2.8.1.sql"
psql $ADDRESS -f "$ROOT/col_alter_2.8.1-24.0.sql"
