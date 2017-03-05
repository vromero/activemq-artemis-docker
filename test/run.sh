#!/bin/bash
set -e

docker build -q -t activemq-artemis-test activemq-artemis-test

find ./tests/* -type d |  while read -r D
do
  echo $D
  cd $D
  docker-compose up --force-recreate --abort-on-container-exit
  TEST_STATUS=$(docker-compose ps -q | xargs docker inspect -f '{{ .Config.Image }} {{.State.ExitCode}}' | awk '/activemq-artemis-test/ {print $2}')

  if [ ${TEST_STATUS} -ne 0 ] ; then
    echo "Tests resulted in error"
    exit $RESULT
  fi
  docker-compose down
  docker-compose rm -f
  echo $?
  cd -
done
