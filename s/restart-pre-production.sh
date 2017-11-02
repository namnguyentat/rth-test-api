#!/bin/bash

docker-compose -f docker-compose-pre-production.yml stop \
  && docker-compose -f docker-compose-pre-production.yml up -d
