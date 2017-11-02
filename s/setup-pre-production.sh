#!/bin/bash

# git fetch main \
#   && git checkout main/pre_production \
#   && git checkout -b pre_production \
#   && cp config/application.yml.tmpl config/application.yml \
#   && docker-compose -f docker-compose-pre-production.yml build \
#   && docker-compose -f docker-compose-pre-production.yml run --rm --entrypoint=/bin/bash api -c "bundle install && s/wait_for_it.sh db:3306 elasticsearch:9200 -- bundle exec rake db:migrate:reset db:seed" \
#   && s/gen-schema-pre-production.sh

git fetch main \
  && git checkout main/pre_production \
  && git checkout -b pre_production \
  && cp config/application.yml.tmpl config/application.yml \
  && docker-compose -f docker-compose-pre-production.yml build \
  && docker-compose -f docker-compose-pre-production.yml run --rm --entrypoint=/bin/bash api -c "bundle install && s/wait_for_it.sh db:3306 -- bundle exec rake db:migrate:reset db:seed" \
  && s/gen-schema-pre-production.sh
