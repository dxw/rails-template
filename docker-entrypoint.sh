#!/bin/bash
set -e

echo "ENTRYPOINT: Starting docker entrypoint…"

setup_database()
{
  echo "ENTRYPOINT: Running rake db:prepare…"
  # Migrate the database and if one doesn't exist then create one
  bundle exec rake db:prepare
  echo "ENTRYPOINT: Finished database setup."
}

if [ -z ${DATABASE_URL+x} ]; then echo "Skipping database setup"; else setup_database; fi

echo "ENTRYPOINT: Finished docker entrypoint."
exec "$@"
