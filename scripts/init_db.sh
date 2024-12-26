#!/usr/bin/env bash
set -x
set -eo pipefail

# configure DB per env vars or fallthrough to defaults
DB_PORT="${POSTGRES_PORT:=5432}"
SUPERUSER="${SUPERUSER:=postgres}"
SUPERUSER_PWD="${SUPERUSER_PWD:=password}"

# spin up the DB in a container
CONTAINER_NAME="postgres"
docker run \
    --env POSTGRES_USER=${SUPERUSER} \
    --env POSTGRES_PASSWORD=${SUPERUSER_PWD} \
    --publish "${DB_PORT}:5432" \
    --detach \
    --name "${CONTAINER_NAME}" \
    postgres -N 1000
