#!/bin/bash
ROOT=install/pgsql
psql $ADDRESS -f "$ROOT/col_alter_2.7-2.8.sql"
psql $ADDRESS -f "$ROOT/col_alter_2.8-2.8.1.sql"
psql $ADDRESS -f "$ROOT/col_alter_2.8.1-23.0.sql"
