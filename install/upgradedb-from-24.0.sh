#!/bin/bash
ROOT=install/pgsql
psql $ADDRESS -f "$ROOT/col_alter_24.0-24.1.sql"
psql $ADDRESS -f "$ROOT/col_alter_24.1-25.0.sql"