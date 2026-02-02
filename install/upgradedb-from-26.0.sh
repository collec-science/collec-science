#!/bin/bash
ROOT=install/pgsql
psql $ADDRESS -f "$ROOT/col_alter_26.0-26.1.sql"
