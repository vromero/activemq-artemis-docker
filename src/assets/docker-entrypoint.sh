#!/bin/sh
set -e

BROKER_HOME=/var/lib/artemis
OVERRIDE_PATH=$BROKER_HOME/etc-override
CONFIG_PATH=$BROKER_HOME/etc
export BROKER_HOME OVERRIDE_PATH CONFIG_PATH

# In case this is running in a non standard system that automounts
# empty volumes like OpenShift, restore the configuration into the 
# volume
if [ "$RESTORE_CONFIGURATION" ] && [ -z "$(ls -A ${CONFIG_PATH})" ]; then
  cp -R "${CONFIG_PATH}"-backup/* "${CONFIG_PATH}"
  echo Configuration restored
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

# Log to tty to enable docker logs container-name
sed -i "s/logger.handlers=.*/logger.handlers=CONSOLE/g" ${CONFIG_PATH}/logging.properties

# Set the broker name to the host name to ease experience in external monitors and in the console
if (echo "${ACTIVEMQ_ARTEMIS_VERSION}" | grep -Eq "(1\\.[^0-2]\\.[0-9]+|2\\.[0-9]\\.[0-9]+)" ) ; then 
  xmlstarlet ed -L \
    -N activemq="urn:activemq" \
    -N core="urn:activemq:core" \
    -u "/activemq:configuration/core:core/core:name" \
    -v "$(hostname)" ../etc/broker.xml
fi


# Update users and roles with if username and password is passed as argument
if [ "$ARTEMIS_USERNAME" ] && [ "$ARTEMIS_PASSWORD" ]; then
  # From 1.0.0 up to 1.1.0 the artemis roles file was user=groups
  # From 1.2.0 to 1.4.0 became group=users and we still set it with sed
  if echo "${ACTIVEMQ_ARTEMIS_VERSION}" | grep -Eq "1.[01].[0-9]" ; then
    sed -i "s/artemis=amq/$ARTEMIS_USERNAME=amq\\n/g" ../etc/artemis-roles.properties
  elif echo "${ACTIVEMQ_ARTEMIS_VERSION}" | grep -Eq "1.[2-4].[0-9]" ; then
    sed -i "s/amq[ ]*=.*/amq=$ARTEMIS_USERNAME\\n/g" ../etc/artemis-roles.properties
  fi
  
  # 1.5.0 and later are set using the cli both for username and role
  if echo "${ACTIVEMQ_ARTEMIS_VERSION}" | grep -Eq "1.[0-4].[0-9]" ; then
    sed -i "s/artemis[ ]*=.*/$ARTEMIS_USERNAME=$ARTEMIS_PASSWORD\\n/g" ../etc/artemis-users.properties
  else
    $BROKER_HOME/bin/artemis user rm --user artemis
    $BROKER_HOME/bin/artemis user add --user "$ARTEMIS_USERNAME" --password "$ARTEMIS_PASSWORD" --role amq
  fi
fi

# Update min memory if the argument is passed
if [ "$ARTEMIS_MIN_MEMORY" ]; then
  sed -i "/-Xms/!s/^JAVA_ARGS=\"/JAVA_ARGS=\"-Xms$ARTEMIS_MIN_MEMORY /g" $CONFIG_PATH/artemis.profile
fi

# Update max memory if the argument is passed
if [ "$ARTEMIS_MAX_MEMORY" ]; then
  sed -i "/-Xmx/!s/^JAVA_ARGS=\"/JAVA_ARGS=\"-Xmx$ARTEMIS_MAX_MEMORY /g" $CONFIG_PATH/artemis.profile
fi

# Support extra java opts from JAVA_OPTS env
sed -i "/JAVA_OPTS/!s/^JAVA_ARGS=\"/JAVA_ARGS=\"\$JAVA_OPTS /g" $CONFIG_PATH/artemis.profile;

mergeXmlFiles() {
  xmlstarlet tr /opt/assets/merge.xslt -s replace=true -s with="$2" "$1" > /tmp/broker-merge.xml
  mv /tmp/broker-merge.xml "$3"
}

files=$(find $OVERRIDE_PATH -name "broker*" -type f | cut -d. -f1 | sort -u );
if [ ${#files[@]} ]; then
  for f in $files; do
    if [ -f "$f.xslt" ]; then
      xmlstarlet tr "$f.xslt" $CONFIG_PATH/broker.xml > /tmp/broker-tr.xml
      mv /tmp/broker-tr.xml $CONFIG_PATH/broker.xml
    fi
    if [ -f "$f.xml" ]; then
      mergeXmlFiles "$CONFIG_PATH/broker.xml" "$f.xml" "$CONFIG_PATH/broker.xml"
    fi
  done
else
  echo No configuration snippets found
fi

if [ "$ENABLE_JMX" ] || [ "$ENABLE_JMX_EXPORTER" ]; then
  sed -i "/com.sun.management.jmxremote/!s/^JAVA_ARGS=\"/JAVA_ARGS=\"-Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.port=${JMX_PORT:-1099} -Dcom.sun.management.jmxremote.rmi.port=${JMX_RMI_PORT:-1098} -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false /g" $CONFIG_PATH/artemis.profile
  mergeXmlFiles "$CONFIG_PATH/broker.xml" /opt/assets/enable-jmx.xml "$CONFIG_PATH/broker.xml"
fi

if [ "$ENABLE_JMX_EXPORTER" ]; then
  if [ -f /opt/jmx-exporter/etc-override/jmx-exporter-config.yaml ]; then
    cp /opt/jmx-exporter/etc-override/jmx-exporter-config.yaml /opt/jmx-exporter/etc/jmx-exporter-config.yaml
  fi
  sed -i "/jmx_prometheus_javaagent.jar/!s/^JAVA_ARGS=\"/JAVA_ARGS=\"-javaagent:\\/opt\\/jmx-exporter\\/jmx_prometheus_javaagent.jar=9404:\\/opt\\/jmx-exporter\\/etc\\/jmx-exporter-config.yaml /g" $CONFIG_PATH/artemis.profile
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
  fi
}

if (echo "${ACTIVEMQ_ARTEMIS_VERSION}" | grep -Eq  "(1.5\\.[3-5]|[^1]\\.[0-9]\\.[0-9]+)" ) ; then 
  performanceJournal
fi

# Add BROKER_CONFIGS env variable to startup options
sed -i "/BROKER_CONFIGS/!s/^JAVA_ARGS=\"/JAVA_ARGS=\"\$BROKER_CONFIGS /g" $CONFIG_PATH/artemis.profile;

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
