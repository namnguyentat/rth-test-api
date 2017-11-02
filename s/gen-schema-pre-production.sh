#!/bin/bash

docker-compose -f docker-compose-pre-production.yml run --rm --entrypoint=/bin/bash api -c "bundle exec rake graph:schema" \
  && mv -f schema.json ../frontend
