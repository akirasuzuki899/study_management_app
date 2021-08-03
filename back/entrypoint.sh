#!/bin/bash
set -e

rm -f /back/tmp/pids/server.pid

# bundle exec rails db:create
bundle exec rails db:migrate

exec "$@"