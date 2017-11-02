#!/bin/bash

# docker-compose build \
#   && cp config/application.yml.tmpl config/application.yml \
#   && docker-compose run --rm --entrypoint=/bin/bash api -c "bundle install && s/wait_for_it.sh db:3306 elasticsearch:9200 -- bundle exec rake db:migrate:reset db:seed db:fake" \
#   && s/gen-schema.sh

docker-compose build \
  && cp config/application.yml.tmpl config/application.yml \
  && docker-compose run --rm --entrypoint=/bin/bash api -c "bundle install && s/wait_for_it.sh db:3306 -- bundle exec rake db:migrate:reset db:seed db:fake" \
  && s/gen-schema.sh