#!/bin/bash
set -e

# Function to check if a user exists
user_exists() {
    psql -U postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='$1'" | grep -q 1
}

# Function to check if a database exists
db_exists() {
    psql -U postgres -lqt | cut -d \| -f 1 | grep -qw "$1"
}

# Check and create the user if it doesn't exist
if ! user_exists "$POSTGRES_USER"; then
    echo "Creating user $POSTGRES_USER..."
    psql -U postgres -v ON_ERROR_STOP=1 <<-EOSQL
        CREATE USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD';
EOSQL
fi

# Check and create the database if it doesn't exist
if ! db_exists "$POSTGRES_DB"; then
    echo "Creating database $POSTGRES_DB..."
    psql -U postgres -v ON_ERROR_STOP=1 <<-EOSQL
        CREATE DATABASE $POSTGRES_DB OWNER $POSTGRES_USER;
EOSQL
fi

# If the database exists or was just created, set privileges
if db_exists "$POSTGRES_DB"; then
    echo "Setting privileges for user $POSTGRES_USER on database $POSTGRES_DB..."
    psql -U postgres -v ON_ERROR_STOP=1 --dbname "$POSTGRES_DB" <<-EOSQL
        GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $POSTGRES_USER;

        -- Connect to the database
        \c $POSTGRES_DB

        -- Grant schema privileges
        ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO $POSTGRES_USER;
        ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON SEQUENCES TO $POSTGRES_USER;
        ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON FUNCTIONS TO $POSTGRES_USER;

        -- Grant usage on schema
        GRANT USAGE ON SCHEMA public TO $POSTGRES_USER;
        GRANT ALL PRIVILEGES ON SCHEMA public TO $POSTGRES_USER;
EOSQL
fi