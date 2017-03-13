#!/bin/bash
set -e

# Log to tty to enable docker logs container-name
sed -i "s/logger.handlers=.*/logger.handlers=CONSOLE/g" ../etc/logging.properties

# Update users and roles with if username and password is passed as argument
if [[ "$ARTEMIS_USERNAME" && "$ARTEMIS_PASSWORD" ]]; then
  sed -i "s/amq[ ]*=.*/amq=$ARTEMIS_USERNAME\n/g" ../etc/artemis-roles.properties
  sed -i "s/artemis[ ]*=.*/$ARTEMIS_USERNAME=$ARTEMIS_PASSWORD\n/g" ../etc/artemis-users.properties
fi

# Update min memory if the argument is passed
if [[ "$ARTEMIS_MIN_MEMORY" ]]; then
  sed -i "s/-Xms512M/-Xms$ARTEMIS_MIN_MEMORY/g" ../etc/artemis.profile
fi

# Update max memory if the argument is passed
if [[ "$ARTEMIS_MAX_MEMORY" ]]; then
  sed -i "s/-Xmx1024M/-Xmx$ARTEMIS_MAX_MEMORY/g" ../etc/artemis.profile
fi

if [ -f /var/lib/artemis/etc-override/broker.xslt ]; then
  echo Applying broker.xslt
  cp /var/lib/artemis/etc/broker.xml /tmp/broker.xml
  xmlstarlet tr /var/lib/artemis/etc-override/broker.xslt /tmp/broker.xml > /var/lib/artemis/etc/broker.xml
else
  echo No broker.xslt found
fi

if [ -f /var/lib/artemis/etc-override/broker.xml ]; then
  cp /var/lib/artemis/etc/broker.xml /tmp/broker.xml
  xmlstarlet tr /opt/merge/merge.xslt -s with=/var/lib/artemis/etc-override/broker.xml /tmp/broker.xml > /var/lib/artemis/etc/broker.xml
else
  echo No broker.xml override found
fi

function performance-journal {
  if [[ "$ARTEMIS_PERF_JOURNAL" = "AUTO" || "$ARTEMIS_PERF_JOURNAL" = "ALWAYS" ]]; then

    if [[ -e /var/lib/artemis/data/.perf-journal-completed ]]; then
      echo "Volume's journal buffer already fine tuned"
      return
    fi

    echo -n "Calculating performance journal ... "
    RECOMMENDED_JOURNAL_BUFFER=$(gosu artemis "./artemis" "perf-journal" | grep "<journal-buffer-timeout" | xmlstarlet sel -t -c '/journal-buffer-timeout/text()' || true)
    if [ -z "$RECOMMENDED_JOURNAL_BUFFER" ]; then
      echo "There was an error calculating the performance journal, gracefully handling it"
      return
    fi

    xmlstarlet ed -L \
      -N activemq="urn:activemq" \
      -N core="urn:activemq:core" \
      -u "/activemq:configuration/core:core/core:journal-buffer-timeout" \
      -v "$RECOMMENDED_JOURNAL_BUFFER" ../etc/broker.xml
      echo $RECOMMENDED_JOURNAL_BUFFER

    if [[ "$ARTEMIS_PERF_JOURNAL" = "AUTO" ]]; then
      touch /var/lib/artemis/data/.perf-journal-completed
    fi
  fi
}

performance-journal

if [ "$1" = 'artemis-server' ]; then
	set -- gosu artemis "./artemis" "run"
fi

exec "$@"
