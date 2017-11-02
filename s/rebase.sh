#!/bin/bash
CURRENT_BRANCH=`git symbolic-ref HEAD | sed 's!refs\/heads\/!!'`

git fetch main \
  && git checkout master \
  && git pull main master \
  && git checkout $CURRENT_BRANCH \
  && git rebase master
