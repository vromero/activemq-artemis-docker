#!/bin/sh
set -e

# Log to tty to enable docker logs container-name
sed -i "s/logger.handlers=.*/logger.handlers=CONSOLE/g" ../etc/logging.properties

BROKER_HOME=/var/lib/artemis/
OVERRIDE_PATH=$BROKER_HOME/etc-override
CONFIG_PATH=$BROKER_HOME/etc

# Update users and roles with if username and password is passed as argument
if [ "$ARTEMIS_USERNAME" ] && [ "$ARTEMIS_PASSWORD" ]; then
  # From 1.0.0 up to 1.1.0 the artemis roles file was user=groups, later on it became group=users
  if echo "${ACTIVEMQ_ARTEMIS_VERSION}" | grep -Eq "1.[01].0" ; then
    sed -i "s/artemis=amq/$ARTEMIS_USERNAME=amq\n/g" ../etc/artemis-roles.properties
  else
    sed -i "s/amq[ ]*=.*/amq=$ARTEMIS_USERNAME\n/g" ../etc/artemis-roles.properties
  fi
  sed -i "s/artemis[ ]*=.*/$ARTEMIS_USERNAME=$ARTEMIS_PASSWORD\n/g" ../etc/artemis-users.properties
fi

# Update min memory if the argument is passed
if [ "$ARTEMIS_MIN_MEMORY" ]; then
  sed -i "s/-Xms[^ \"]*/-Xms$ARTEMIS_MIN_MEMORY/g" ../etc/artemis.profile
fi

# Update max memory if the argument is passed
if [ "$ARTEMIS_MAX_MEMORY" ]; then
  sed -i "s/-Xmx[^ \"]*/-Xmx$ARTEMIS_MAX_MEMORY/g" ../etc/artemis.profile
fi

files=$(find $OVERRIDE_PATH -name "broker*" -type f | cut -d. -f1 | sort -u );
if [ ${#files[@]} ]; then
  for f in $files; do
    if [ -f "$f.xslt" ]; then
      xmlstarlet tr "$f.xslt" $CONFIG_PATH/broker.xml > /tmp/broker-tr.xml
      mv /tmp/broker-tr.xml $CONFIG_PATH/broker.xml
    fi
    if [ -f "$f.xml" ]; then
      xmlstarlet tr /opt/assets/merge.xslt -s replace=true -s with="$f.xml" $CONFIG_PATH/broker.xml > /tmp/broker-merge.xml
      mv /tmp/broker-merge.xml $CONFIG_PATH/broker.xml
    fi
  done
else
  echo No configuration snippets found
fi

if [ "$ENABLE_JMX" ]; then
  sed -i "s/^JAVA_ARGS=\"/JAVA_ARGS=\"-Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.port=${JMX_PORT:-1099} -Dcom.sun.management.jmxremote.rmi.port=${JMX_RMI_PORT:-1098} -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false /g" $CONFIG_PATH/artemis.profile
  cp $CONFIG_PATH/broker.xml /tmp/broker.xml
  xmlstarlet tr /opt/assets/merge.xslt -s replace=true -s with=/opt/assets/enable-jmx.xml /tmp/broker.xml > /tmp/broker-merge.xml
  mv /tmp/broker-merge.xml "$CONFIG_PATH/broker.xml"
fi

if [ -e /var/lib/artemis/etc/jolokia-access.xml ]; then
  xmlstarlet ed --inplace -u '/restrict/cors/allow-origin' -v "${JOLOKIA_ALLOW_ORIGIN:-*}" /var/lib/artemis/etc/jolokia-access.xml
fi

performanceJournal() {
  perfJournalConfiguration=${ARTEMIS_PERF_JOURNAL:-AUTO}
  if [ "$perfJournalConfiguration" = "AUTO" ] || [ "$perfJournalConfiguration" = "ALWAYS" ]; then

    if [ -e /var/lib/artemis/data/.perf-journal-completed ]; then
      echo "Volume's journal buffer already fine tuned"
      return
    fi

    echo "Calculating performance journal ... "
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
      echo "$RECOMMENDED_JOURNAL_BUFFER"

    if [ "$perfJournalConfiguration" = "AUTO" ]; then
      touch /var/lib/artemis/data/.perf-journal-completed
    fi
  fi
}

performanceJournal

if [ "$1" = 'artemis-server' ]; then
	set -- gosu artemis "sh" "./artemis" "run"
fi

exec "$@"
