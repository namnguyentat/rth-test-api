#!/bin/bash

# git fetch main \
#   && git checkout main/production \
#   && git checkout -b production \
#   && cp config/application.yml.tmpl config/application.yml \
#   && docker-compose -f docker-compose-production.yml build \
#   && docker-compose -f docker-compose-production.yml run --rm --entrypoint=/bin/bash api -c "bundle install && s/wait_for_it.sh db:3306 elasticsearch:9200 -- bundle exec rake db:migrate:reset db:seed" \
#   && s/gen-schema-production.sh

git fetch main \
  && git checkout main/production \
  && git checkout -b production \
  && cp config/application.yml.tmpl config/application.yml \
  && docker-compose -f docker-compose-production.yml build \
  && docker-compose -f docker-compose-production.yml run --rm --entrypoint=/bin/bash api -c "bundle install && s/wait_for_it.sh db:3306 -- bundle exec rake db:migrate:reset db:seed" \
  && s/gen-schema-production.sh
