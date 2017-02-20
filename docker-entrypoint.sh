#!/bin/bash
set -e

WORKDIR=$(pwd)
EFFECTIVE_ARTEMIS_USERNAME=${ARTEMIS_USERNAME:-artemis}
EFFECTIVE_ARTEMIS_PASSWORD=${ARTEMIS_PASSWORD:-simetraehcapa}

if [ ! "$(ls -A /var/lib/artemis/etc)" ]; then
	# Create broker instance
	cd /var/lib && \
	  /opt/apache-artemis-1.5.0/bin/artemis create artemis \
		--home /opt/apache-artemis \
		--user $EFFECTIVE_ARTEMIS_USERNAME \
		--password $EFFECTIVE_ARTEMIS_PASSWORD \
		--role amq \
		--require-login \
		--cluster-user artemisCluster \
		--cluster-password simetraehcaparetsulc

	# Ports are only exposed with an explicit argument, there is no need to binding
	# the web console to localhost
	cd /var/lib/artemis/etc && \
	  xmlstarlet ed -L -N amq="http://activemq.org/schema" \
		-u "/amq:broker/amq:web/@bind" \
		-v "http://0.0.0.0:8161" bootstrap.xml

	chown -R artemis.artemis /var/lib/artemis
	
	cd $WORKDIR
fi

# Log to tty to enable docker logs container-name
sed -i "s/logger.handlers=.*/logger.handlers=CONSOLE/g" ../etc/logging.properties

# Update min memory if the argument is passed
if [[ "$ARTEMIS_MIN_MEMORY" ]]; then
  sed -i "s/-Xms512M/-Xms$ARTEMIS_MIN_MEMORY/g" ../etc/artemis.profile
fi

# Update max memory if the argument is passed
if [[ "$ARTEMIS_MAX_MEMORY" ]]; then
  sed -i "s/-Xmx1024M/-Xmx$ARTEMIS_MAX_MEMORY/g" ../etc/artemis.profile
fi

if [ "$1" = 'artemis-server' ]; then
	set -- gosu artemis "./artemis" "run"
fi

exec "$@"
