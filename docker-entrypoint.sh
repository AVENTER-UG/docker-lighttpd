#!/bin/bash
set -e

cd /var/www/htdocs/

if [ -n "$GIT_REPO" ]
then	
  git clone $GIT_REPO .
fi

if [ -n "$GIT_BRANCH" ]
then
  git checkout $GIT_BRANCH
fi

if [ -n "$GIT_TAG" ]
then
  git checkout tags/$GIT_TAG
fi

rm -rf /var/www/htdocs/.git

chown -R 100:82 /var/www/htdocs

exec "$@"

