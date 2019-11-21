#!/bin/sh
set -ex

yarn balena login --token $BALENA_TOKEN

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
