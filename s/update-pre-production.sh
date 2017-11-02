#!/bin/bash

# docker-compose -f docker-compose-pre-production.yml stop \
#   && git fetch main \
#   && git checkout pre_production \
#   && git pull main pre_production \
#   && docker-compose -f docker-compose-pre-production.yml run --rm --entrypoint=/bin/bash api -c "bundle install && s/wait_for_it.sh db:3306 elasticsearch:9200 -- bundle exec rake db:migrate:reset" \
#   && docker-compose -f docker-compose-pre-production.yml run --rm --entrypoint=/bin/bash api -c "bundle exec rake db:seed" \
#   && s/gen-schema-pre-production.sh \
#   && s/start-pre-production.sh

docker-compose -f docker-compose-pre-production.yml stop \
  && git fetch main \
  && git checkout pre_production \
  && git pull main pre_production \
  && docker-compose -f docker-compose-pre-production.yml run --rm --entrypoint=/bin/bash api -c "bundle install && s/wait_for_it.sh db:3306 -- bundle exec rake db:migrate:reset" \
  && docker-compose -f docker-compose-pre-production.yml run --rm --entrypoint=/bin/bash api -c "bundle exec rake db:seed" \
  && s/gen-schema-pre-production.sh \
  && s/start-pre-production.sh
