#!/bin/bash

docker-compose -f docker-compose-staging.yml stop \
  && docker-compose -f docker-compose-staging.yml up -d
