#!/bin/bash
set -e

rm -f /back/tmp/pids/server.pid

exec "$@"