#!/bin/sh
set -e

BROKER_HOME=/var/lib/artemis
OVERRIDE_PATH=$BROKER_HOME/etc-override
CONFIG_PATH=$BROKER_HOME/etc
export BROKER_HOME OVERRIDE_PATH CONFIG_PATH

# Prepends a value in the JAVA_ARGS of artemis.profile
# $1 New string to be prepended to JAVA_ARGS
# $2 Deduplication string
prepend_java_arg() {
  sed -i "\#$1#!s#^\([[:space:]]\)*JAVA_ARGS=\"#\\1JAVA_ARGS=\"$2 #g" $CONFIG_PATH/artemis.profile
}

# Returns true if the semver version in $1 is greater 
# of equal than the one passed in $2
# $1 input version
# $2 comparison version
semver_greater_or_equal_than() {
  # shellcheck disable=SC2046
  test $(semver "${1}" "${2}") -ge 0
  return 
}

# In case this is running in a non standard system that automounts
# empty volumes like OpenShift, restore the configuration into the 
# volume
if [ "$RESTORE_CONFIGURATION" ] && [ -z "$(ls -A ${CONFIG_PATH})" ]; then
  cp -R "${CONFIG_PATH}"-backup/* "${CONFIG_PATH}"
  echo Configuration restored
fi

# Update logger if the argument is passed
if [ "$LOG_FORMATTER" = "JSON" ]; then
    sed -i "s/handler.CONSOLE.formatter=.*/handler.CONSOLE.formatter=JSON/g" ../etc/logging.properties
fi

# Never use in a production environment
if [ "$DISABLE_SECURITY" ]; then
    xmlstarlet ed -L \
      -N activemq="urn:activemq" \
      -N core="urn:activemq:core" \
      --subnode "/activemq:configuration/core:core[not(core:security-enabled)]" \
      -t elem \
      -n "security-enabled" \
      -v "false" ../etc/broker.xml 
fi

# Set the broker name to the host name to ease experience for external monitors and the console
if semver_greater_or_equal_than "${ACTIVEMQ_ARTEMIS_VERSION}" 1.3.0 ; then
  xmlstarlet ed -L \
    -N activemq="urn:activemq" \
    -N core="urn:activemq:core" \
    -u "/activemq:configuration/core:core/core:name" \
    -v "$(hostname)" ../etc/broker.xml
fi

# Update users and roles with if username and password is passed as argument
if [ "$ARTEMIS_USERNAME" ] && [ "$ARTEMIS_PASSWORD" ]; then

  # Roles update

  # 2.0.0 and later are set using the cli with a running broker
  if semver_greater_or_equal_than "${ACTIVEMQ_ARTEMIS_VERSION}" 1.2.0 ; then
    # From 1.2.0 on became group=users and we still set it with sed
    sed -i "s/amq[ ]*=.*/amq=$ARTEMIS_USERNAME\\n/g" ../etc/artemis-roles.properties
  else
    # From 1.0.0 up to 1.1.0 the artemis roles file was user=groups
    sed -i "s/artemis=amq/$ARTEMIS_USERNAME=amq\\n/g" ../etc/artemis-roles.properties
  fi

  # Users update

  # 2.16.0 and later are set using the cli with a running broker
  if semver_greater_or_equal_than "${ACTIVEMQ_ARTEMIS_VERSION}" 2.15.0 ; then
    HASHED_PASSWORD=$(${BROKER_HOME}/bin/artemis mask --hash "${ARTEMIS_PASSWORD}" | cut -d " " -f 2)
    sed -i "s/artemis[ ]*=.*/$ARTEMIS_USERNAME=ENC($HASHED_PASSWORD)\\n/g" ../etc/artemis-users.properties
  elif semver_greater_or_equal_than "${ACTIVEMQ_ARTEMIS_VERSION}" 1.5.0 ; then
    # 1.5.0 to 2.14.0 modified the users file directly and therefore didn't need a running broker
    if ${BROKER_HOME}/bin/artemis user list | grep -Eq "\"${INITIAL_ARTEMIS_USERNAME}\"" ; then
      $BROKER_HOME/bin/artemis user rm --user "${INITIAL_ARTEMIS_USERNAME}"
    fi
    if ${BROKER_HOME}/bin/artemis user list | grep -Eq "\"${ARTEMIS_USERNAME}\"" ; then
      $BROKER_HOME/bin/artemis user rm --user "$ARTEMIS_USERNAME"
    fi
    $BROKER_HOME/bin/artemis user add --user "$ARTEMIS_USERNAME" --password "$ARTEMIS_PASSWORD" --role amq
  else
    # 1.0.0 to 1.4.0 modify the file directly with the old format
    sed -i "s/artemis[ ]*=.*/$ARTEMIS_USERNAME=$ARTEMIS_PASSWORD\\n/g" ../etc/artemis-users.properties
  fi
fi

# Update min memory if the argument is passed
if [ "$ARTEMIS_MIN_MEMORY" ]; then
  prepend_java_arg "-Xms" "-Xms$ARTEMIS_MIN_MEMORY"
fi

# Update max memory if the argument is passed
if [ "$ARTEMIS_MAX_MEMORY" ]; then
  prepend_java_arg "-Xmx" "-Xmx$ARTEMIS_MAX_MEMORY"
fi

# Support extra java opts from JAVA_OPTS env
if [ "$JAVA_OPTS" ]; then
  prepend_java_arg "$JAVA_OPTS" "$JAVA_OPTS"
fi

mergeXmlFiles() {
  xmlstarlet tr /opt/assets/merge.xslt -s replace=true -s with="$2" "$1" > /tmp/broker-merge.xml
  mv /tmp/broker-merge.xml "$3"
}

files=$(find $OVERRIDE_PATH -name "broker*" -type f | sort -u );
if [ ${#files[@]} ]; then
  for f in $files; do
    fnoext=${f%.*}
    if [ -f "$fnoext.xslt" ]; then
      xmlstarlet tr "$fnoext.xslt" $CONFIG_PATH/broker.xml > /tmp/broker-tr.xml
      mv /tmp/broker-tr.xml $CONFIG_PATH/broker.xml
    fi
    if [ -f "$fnoext.xml" ]; then
      mergeXmlFiles "$CONFIG_PATH/broker.xml" "$fnoext.xml" "$CONFIG_PATH/broker.xml"
    fi
  done
else
  echo No configuration snippets found
fi

if [ "$ENABLE_JMX" ] || [ "$ENABLE_JMX_EXPORTER" ]; then
  prepend_java_arg "com.sun.management.jmxremote" "-Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.port=${JMX_PORT:-1099} -Dcom.sun.management.jmxremote.rmi.port=${JMX_RMI_PORT:-1098} -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
  mergeXmlFiles "$CONFIG_PATH/broker.xml" /opt/assets/enable-jmx.xml "$CONFIG_PATH/broker.xml"
fi

if [ "$ENABLE_JMX_EXPORTER" ]; then
  if [ -f /opt/jmx-exporter/etc-override/jmx-exporter-config.yaml ]; then
    cp /opt/jmx-exporter/etc-override/jmx-exporter-config.yaml /opt/jmx-exporter/etc/jmx-exporter-config.yaml
  fi
  prepend_java_arg "jmx_prometheus_javaagent.jar" "-javaagent:\\/opt\\/jmx-exporter\\/jmx_prometheus_javaagent.jar=9404:\\/opt\\/jmx-exporter\\/etc\\/jmx-exporter-config.yaml"
fi

if [ -n "$CRITICAL_ANALYZER" ]; then
  xmlstarlet ed -L \
    -N activemq="urn:activemq" \
    -N core="urn:activemq:core" \
    -u "/activemq:configuration/core:core/core:critical-analyzer" \
    -v "$CRITICAL_ANALYZER" ../etc/broker.xml
fi

if [ -n "$CRITICAL_ANALYZER_TIMEOUT" ]; then
  xmlstarlet ed -L \
    -N activemq="urn:activemq" \
    -N core="urn:activemq:core" \
    -u "/activemq:configuration/core:core/core:critical-analyzer-timeout" \
    -v "${CRITICAL_ANALYZER_TIMEOUT}" ../etc/broker.xml
fi

if [ -n "$CRITICAL_ANALYZER_CHECK_PERIOD" ]; then
  xmlstarlet ed -L \
    -N activemq="urn:activemq" \
    -N core="urn:activemq:core" \
    -u "/activemq:configuration/core:core/core:critical-analyzer-check-period" \
    -v "${CRITICAL_ANALYZER_CHECK_PERIOD}" ../etc/broker.xml
fi

if [ -n "$CRITICAL_ANALYZER_POLICY" ]; then
  xmlstarlet ed -L \
    -N activemq="urn:activemq" \
    -N core="urn:activemq:core" \
    -u "/activemq:configuration/core:core/core:critical-analyzer-policy" \
    -v "${CRITICAL_ANALYZER_POLICY}" ../etc/broker.xml
fi

if [ -e /var/lib/artemis/etc/jolokia-access.xml ]; then
  xmlstarlet ed --inplace -u '/restrict/cors/allow-origin' -v "${JOLOKIA_ALLOW_ORIGIN:-*}" /var/lib/artemis/etc/jolokia-access.xml
fi

performanceJournal() {
  perfJournalConfiguration=${ARTEMIS_PERF_JOURNAL:-AUTO}
  if [ "$perfJournalConfiguration" = "AUTO" ] || [ "$perfJournalConfiguration" = "ALWAYS" ]; then

    if [ "$perfJournalConfiguration" = "AUTO" ] && [ -e /var/lib/artemis/data/.perf-journal-completed ]; then
      echo "Volume's journal buffer already fine tuned"
      return
    fi

    echo "Calculating performance journal ... "
    RECOMMENDED_JOURNAL_BUFFER=$("./artemis" "perf-journal" | grep "<journal-buffer-timeout" | xmlstarlet sel -t -c '/journal-buffer-timeout/text()' || true)
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
  else
    echo "Skipping performance journal tuning as per user request"
  fi
}

if semver_greater_or_equal_than "${ACTIVEMQ_ARTEMIS_VERSION}" 1.5.3 ; then 
  performanceJournal
else
  echo "Ignoring any performance journal parameter as version predates it: ${ACTIVEMQ_ARTEMIS_VERSION}"
fi

# Add BROKER_CONFIGS env variable to startup options
prepend_java_arg "BROKER_CONFIGS" "\$BROKER_CONFIGS"

# Loop through all BROKER_CONFIG_... and convert to java system properties
env|grep -E "^BROKER_CONFIG_"|sed -e 's/BROKER_CONFIG_//g' >/tmp/brokerconfigs.txt
while read -r config
do
  PARAM=${config%%=*}
  PARAM_CAMEL_CASE=$(echo "$PARAM"|sed -r 's/./\L&/g; s/(^|-|_)(\w)/\U\2/g; s/./\L&/')
  VALUE=${config#*=}
  BROKER_CONFIGS="${BROKER_CONFIGS} -Dbrokerconfig.${PARAM_CAMEL_CASE}=${VALUE}"
done < /tmp/brokerconfigs.txt
rm -f /tmp/brokerconfigs.txt
export BROKER_CONFIGS

files=$(find $OVERRIDE_PATH -name "entrypoint*.sh" -type f | sort -u );
if [ ${#files[@]} ]; then
  for f in $files; do
    echo "Processing entrypoint override: $f"
    /bin/sh "$f"
  done
fi

if [ "$1" = 'artemis-server' ]; then
  exec dumb-init -- sh ./artemis run
fi

exec "$@"
