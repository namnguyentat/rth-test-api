#!/bin/bash
CURRENT_BRANCH=`git symbolic-ref HEAD | sed 's!refs\/heads\/!!'`

# docker-compose stop \
#   && git fetch main \
#   && git checkout master \
#   && git pull main master \
#   && git checkout $CURRENT_BRANCH \
#   && git rebase master \
#   && docker-compose run --rm --entrypoint=/bin/bash api -c "bundle install && s/wait_for_it.sh db:3306 elasticsearch:9200 -- bundle exec rake db:migrate:reset" \
#   && docker-compose run --rm --entrypoint=/bin/bash api -c "bundle exec rake db:seed db:fake" \
#   && s/gen-schema.sh \
#   && s/start.sh



docker-compose stop \
  && git fetch main \
  && git checkout master \
  && git pull main master \
  && git checkout $CURRENT_BRANCH \
  && git rebase master \
  && docker-compose run --rm --entrypoint=/bin/bash api -c "bundle install && s/wait_for_it.sh db:3306 -- bundle exec rake db:migrate:reset" \
  && docker-compose run --rm --entrypoint=/bin/bash api -c "bundle exec rake db:seed db:fake" \
  && s/gen-schema.sh \
  && s/start.sh