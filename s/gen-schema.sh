#!/bin/bash

docker-compose run --rm --entrypoint=/bin/bash api -c "bundle exec rake graph:schema" \
  && mv -f schema.json ../frontend
