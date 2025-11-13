#!/bin/bash
set -e

# Split DATABASE_NAMES by comma and create each database
IFS=',' read -ra DBS <<< "$DATABASE_NAMES"
for db in "${DBS[@]}"; do
  echo "Creating database: $db"
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE "$db";
EOSQL
done