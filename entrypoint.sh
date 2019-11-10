#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /usr/src/app/tmp/pids/server.pid

/bin/bash -l -c 'bundle exec rails db:create db:migrate'

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
