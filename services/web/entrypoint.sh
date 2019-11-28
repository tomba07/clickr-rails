#!/bin/sh
set -ex

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

if bundle exec rails db:exists; then
  bundle exec rails db:migrate
else
  bundle exec rails db:create db:migrate db:seed
fi


# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
