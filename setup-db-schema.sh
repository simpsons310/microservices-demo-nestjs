#!/bin/sh
# This script creates the required schemas for all services in the PostgreSQL database container.

set -e

DB_CONTAINER=ecommerce_postgres
DB_USER=postgres
DB_NAME=ecommerce_db

# Wait for the database to be ready
until docker exec -it $DB_CONTAINER pg_isready -U $DB_USER; do
  echo "Waiting for PostgreSQL to be ready..."
  sleep 2
done

echo "Creating schemas: user_schema, product_schema, order_schema..."
docker exec -i $DB_CONTAINER psql -U $DB_USER -d $DB_NAME <<EOSQL
CREATE SCHEMA IF NOT EXISTS user_schema;
CREATE SCHEMA IF NOT EXISTS product_schema;
CREATE SCHEMA IF NOT EXISTS order_schema;
EOSQL

echo "Schemas created successfully."
