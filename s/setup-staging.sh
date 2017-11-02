#!/bin/bash

# git fetch main \
#   && git checkout main/staging \
#   && git checkout -b staging \
#   && cp config/application.yml.tmpl config/application.yml \
#   && docker-compose -f docker-compose-staging.yml build \
#   && docker-compose -f docker-compose-staging.yml run --rm --entrypoint=/bin/bash api -c "bundle install && s/wait_for_it.sh db:3306 elasticsearch:9200 -- bundle exec rake db:migrate:reset db:seed db:fake" \
#   && s/gen-schema-staging.sh

git fetch main \
  && git checkout main/staging \
  && git checkout -b staging \
  && cp config/application.yml.tmpl config/application.yml \
  && docker-compose -f docker-compose-staging.yml build \
  && docker-compose -f docker-compose-staging.yml run --rm --entrypoint=/bin/bash api -c "bundle install && s/wait_for_it.sh db:3306 -- bundle exec rake db:migrate:reset db:seed db:fake" \
  && s/gen-schema-staging.sh
