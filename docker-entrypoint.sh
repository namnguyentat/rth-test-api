#!/bin/bash
set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle exec whenever --update-crontab \
  && service cron restart \
  && s/wait_for_it.sh db:3306 redis:6379 \
  && exec bundle exec "$@"
