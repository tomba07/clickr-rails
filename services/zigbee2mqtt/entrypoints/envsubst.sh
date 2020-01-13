#!/bin/sh
# Interpolate (substitute) environment variables in ../data/configuration.yaml.env.
# Write the result to /app/data/configuration.yaml

INPUT=/clickr/data/configuration.yaml.env
OUTPUT=/app/data/configuration.yaml

( echo "cat <<EOF" ; cat "$INPUT" ; echo EOF ) | sh > "$OUTPUT"

./run.sh
