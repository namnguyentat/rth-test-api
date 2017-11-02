#!/bin/bash

# docker-compose -f docker-compose-staging.yml stop \
#   && git fetch main \
#   && git checkout staging \
#   && git pull main staging \
#   && docker-compose -f docker-compose-staging.yml run --rm --entrypoint=/bin/bash api -c "bundle install && s/wait_for_it.sh db:3306 elasticsearch:9200 -- bundle exec rake db:migrate:reset" \
#   && docker-compose -f docker-compose-staging.yml run --rm --entrypoint=/bin/bash api -c "bundle exec rake db:seed db:fake" \
#   && s/gen-schema-staging.sh \
#   && s/start-staging.sh

docker-compose -f docker-compose-staging.yml stop \
  && git fetch main \
  && git checkout staging \
  && git pull main staging \
  && docker-compose -f docker-compose-staging.yml run --rm --entrypoint=/bin/bash api -c "bundle install && s/wait_for_it.sh db:3306 -- bundle exec rake db:migrate:reset" \
  && docker-compose -f docker-compose-staging.yml run --rm --entrypoint=/bin/bash api -c "bundle exec rake db:seed db:fake" \
  && s/gen-schema-staging.sh \
  && s/start-staging.sh
