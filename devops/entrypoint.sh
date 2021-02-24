#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
if [ -f /opt/funbox/tmp/pids/server.pid ]; then
  rm /opt/funbox/tmp/pids/server.pid
fi

# Then exec the container's main process (what's set a CMD in the Dockerfile).
exec "$@"