#!/bin/bash
set -e

# Log to tty to enable docker logs container-name
sed -i "s/logger.handlers=.*/logger.handlers=CONSOLE/g" ../etc/logging.properties

# Update users and roles with if username and password is passed as argument
if [[ "$ARTEMIS_USERNAME" && "$ARTEMIS_PASSWORD" ]]; then
  sed -i "s/apollo=amq/$ARTEMIS_USERNAME=amq/g" ../etc/artemis-roles.properties
  sed -i "s/apollo=ollopaehcapa/$ARTEMIS_USERNAME=$ARTEMIS_PASSWORD/g" ../etc/artemis-users.properties
fi

if [ "$1" = 'artemis-server' ]; then
	set -- gosu artemis "./artemis" "run"
fi

exec "$@"
