#!/bin/bash

set -e

echo "Migrating database..."
/app/bin/backend eval Repo.Migrator.migrate

exec "$@"