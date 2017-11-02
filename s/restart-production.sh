#!/bin/bash

docker-compose -f docker-compose-production.yml stop \
  && docker-compose -f docker-compose-production.yml up -d
