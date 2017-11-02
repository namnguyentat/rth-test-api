#!/bin/bash

# docker-compose -f docker-compose-production.yml stop \
#   && git fetch main \
#   && git checkout production \
#   && git pull origin production \
#   && docker-compose -f docker-compose-production.yml run --rm --entrypoint=/bin/bash api -c "bundle install && s/wait_for_it.sh db:3306 elasticsearch:9200 -- bundle exec rake db:migrate" \
#   && s/gen-schema-production.sh \
#   && s/start-production.sh

docker-compose -f docker-compose-production.yml stop \
  && git fetch main \
  && git checkout production \
  && git pull origin production \
  && docker-compose -f docker-compose-production.yml run --rm --entrypoint=/bin/bash api -c "bundle install && s/wait_for_it.sh db:3306 -- bundle exec rake db:migrate" \
  && s/gen-schema-production.sh \
  && s/start-production.sh