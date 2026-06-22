#!/bin/bash
set -e

# Create APP_DB_NAME for API/auth (SQLAlchemy); vectors stay in POSTGRES_DB.
# See https://github.com/mem0ai/mem0/blob/main/server/init-db.sh
DB="${APP_DB_NAME:-mem0_app}"
psql -v ON_ERROR_STOP=1 -v dbname="$DB" --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    SELECT format('CREATE DATABASE %I', :'dbname')
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = :'dbname')\gexec
EOSQL
