#!/bin/sh
set -e

if [ "$ARTEMIS_ENTRYPOINT_DEBUG" ];then
  set -x
fi

BROKER_HOME=/var/lib/artemis
OVERRIDE_PATH=$BROKER_HOME/etc-override
CONFIG_PATH=$BROKER_HOME/etc

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
      --subnode "/activemq:configuration/core:core" \
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

# add ability to override acceptor options
sed -i "/brokerconfig.acceptorArtemisArgs/!s/\(.*<acceptor.*\"artemis\".*61616\)\(.*\)\(<\/acceptor>\)/\1\${brokerconfig.acceptorArtemisArgs:\2}\${brokerconfig.acceptorArtemisArgsExtra}\3/g" ../etc/broker.xml

# Update users and roles with if username and password is passed as argument
if [ "$ARTEMIS_USERNAME" ] && [ "$ARTEMIS_PASSWORD" ]; then
  # From 1.0.0 up to 1.1.0 the artemis roles file was user=groups
  # From 1.2.0 to 1.4.0 became group=users and we still set it with sed
  if echo "${ACTIVEMQ_ARTEMIS_VERSION}" | grep -Eq "1.[01].[0-9]" ; then
    sed -i "s/artemis=amq/$ARTEMIS_USERNAME=amq\n/g" ../etc/artemis-roles.properties
  elif echo "${ACTIVEMQ_ARTEMIS_VERSION}" | grep -Eq "1.[2-4].[0-9]" ; then
    sed -i "s/amq[ ]*=.*/amq=$ARTEMIS_USERNAME\n/g" ../etc/artemis-roles.properties
  fi
  
  # 1.5.0 and later are set using the cli both for username and role
  if echo "${ACTIVEMQ_ARTEMIS_VERSION}" | grep -Eq "1.[0-4].[0-9]" ; then
    sed -i "s/artemis[ ]*=.*/$ARTEMIS_USERNAME=$ARTEMIS_PASSWORD\n/g" ../etc/artemis-users.properties
  else
    $BROKER_HOME/bin/artemis user rm --user artemis
    $BROKER_HOME/bin/artemis user add --user "$ARTEMIS_USERNAME" --password "$ARTEMIS_PASSWORD" --role amq
  fi
fi

# Update min memory if the argument is passed
if [ "$ARTEMIS_MIN_MEMORY" ]; then
  sed -i "s/^JAVA_ARGS=\"/JAVA_ARGS=\"-Xms$ARTEMIS_MIN_MEMORY /g" $CONFIG_PATH/artemis.profile
fi

# Update max memory if the argument is passed
if [ "$ARTEMIS_MAX_MEMORY" ]; then
  sed -i "s/^JAVA_ARGS=\"/JAVA_ARGS=\"-Xmx$ARTEMIS_MAX_MEMORY /g" $CONFIG_PATH/artemis.profile
fi

# Allow hawtio realm and role to be overriden via environment
sed -i "s/-Dhawtio.role=\([^ \$]\+\)/-Dhawtio.role=\${HAWTIO_ROLE:-\1}/g" $CONFIG_PATH/artemis.profile
sed -i "s/-Dhawtio.realm=\([^ \$]\+\)/-Dhawtio.realm=\${HAWTIO_REALM:-\1}/g" $CONFIG_PATH/artemis.profile

# Allow us to pass arbitray extra vars to the command line via JAVA_ARGS_EXTRAS env
if ! grep '^JAVA_ARGS=.*JAVA_ARGS_EXTRAS' $CONFIG_PATH/artemis.profile >/dev/null;then
  sed -i "s/^JAVA_ARGS=\"/JAVA_ARGS=\"\$JAVA_ARGS_EXTRAS /g" $CONFIG_PATH/artemis.profile;
fi

# allow us to override the broker jaas-security domain
if [ "$ARTEMIS_JAAS_DOMAIN" ];then
  xmlstarlet ed -L -P -N activemq="http://activemq.org/schema" -u "/activemq:broker/activemq:jaas-security/@domain" \
  -v "$ARTEMIS_JAAS_DOMAIN" $CONFIG_PATH/bootstrap.xml
fi

# add ldap domain to login.config if required
if [ "$LDAP_ENABLED" ];then
  # set default values
  export LDAP_REQUIRED=${LDAP_REQUIRED:-required}
  export LDAP_DEBUG=${LDAP_DEBUG:-false}
  export LDAP_USER_SEARCH_SUBTREE=${LDAP_USER_SEARCH_SUBTREE:-true}
  export LDAP_ROLE_SEARCH_SUBTREE=${LDAP_ROLE_SEARCH_SUBTREE:-true}
  if [ -f $CONFIG_PATH/login.config ];then
    # delete the activemqldap entry - https://stackoverflow.com/questions/37680636/sed-multiline-delete-with-pattern
    sed -i '/activemqldap {/{:a;N;/};/!ba};//d' $CONFIG_PATH/login.config
    # add it back with refreshed vars
    envsubst < /opt/assets/login-ldap.config >> $CONFIG_PATH/login.config
  fi
fi

# change default admin role if required
if [ "${ARTEMIS_ADMIN_ROLES}" ];then
  sed -i "s/roles=\"amq\"/roles=\"${ARTEMIS_ADMIN_ROLES}\"/g" $CONFIG_PATH/broker.xml $CONFIG_PATH/management.xml
fi

mergeXmlFiles() {
  xmlstarlet tr /opt/assets/merge.xslt -s replace=true -s with="$2" "$1" > /tmp/broker-merge.xml
  mv /tmp/broker-merge.xml "$3"
}

# Set broker name if required
if [ "${ACTIVEMQ_ARTEMIS_NAME}" ];then
  xmlstarlet ed -L \
    -N activemq="urn:activemq" \
    -N core="urn:activemq:core" \
    -u "/activemq:configuration/core:core/core:name" \
    -v "${ACTIVEMQ_ARTEMIS_NAME}" $CONFIG_PATH/broker.xml  
fi

if [ "${ENABLE_CLUSTER}" ];then
  # Delete clustering elements first, otherwise we could end up with duplicates.  
  for element in connectors broadcast-groups discovery-groups cluster-connections ha-policy
  do
    xmlstarlet ed -P -L -N activemq="urn:activemq" -N core="urn:activemq:core" \
      -d "/activemq:configuration/core:core/core:$element" $CONFIG_PATH/broker.xml
  done
  
  # Enable clustering
  mergeXmlFiles "$CONFIG_PATH/broker.xml" /opt/assets/enable-cluster.xml "$CONFIG_PATH/broker.xml"
  
  # Set cluster user/pass
  xmlstarlet ed -L -N activemq="urn:activemq" -N core="urn:activemq:core" \
    -u "/activemq:configuration/core:core/core:cluster-user" \
    -v "${CLUSTER_USER:-artemisCluster}" $CONFIG_PATH/broker.xml
  xmlstarlet ed -L -N activemq="urn:activemq" -N core="urn:activemq:core" \
    -u "/activemq:configuration/core:core/core:cluster-password" \
    -v "${CLUSTER_PASSWORD:-artemisCluster}" $CONFIG_PATH/broker.xml

  # Set the cluster uri
   xmlstarlet ed -P -L -N activemq="urn:activemq" -N core="urn:activemq:core" \
     -u "/activemq:configuration/core:core/core:connectors/core:connector" \
     -v "${CLUSTER_URI:-tcp://localhost:61616}" $CONFIG_PATH/broker.xml  

  # set the cluster-name
   xmlstarlet ed -P -L -N activemq="urn:activemq" -N core="urn:activemq:core" \
     -u "/activemq:configuration/core:core/core:cluster-connections/core:cluster-connection/@name" \
     -v "${CLUSTER_NAME:-mycluster}" $CONFIG_PATH/broker.xml
  
  # Configure ha-replication/master if required
  if [ "${HA_ROLE}" = "master" ];then
    mergeXmlFiles "$CONFIG_PATH/broker.xml" /opt/assets/enable-cluster-hamaster.xml "$CONFIG_PATH/broker.xml"
    if [ "${HA_GROUP_NAME}" ];then
      xmlstarlet ed -L -N activemq="urn:activemq" -N core="urn:activemq:core" \
        --subnode "/activemq:configuration/core:core/core:ha-policy/core:replication/core:master" \
        -t elem -n "group-name" -v "${HA_GROUP_NAME}" $CONFIG_PATH/broker.xml
    fi
  fi
  
  # Configure ha-replication/slave if required
  if [ "${HA_ROLE}" = "slave" ];then
    mergeXmlFiles "$CONFIG_PATH/broker.xml" /opt/assets/enable-cluster-haslave.xml "$CONFIG_PATH/broker.xml"
    if [ "${HA_GROUP_NAME}" ];then
      xmlstarlet ed -L -N activemq="urn:activemq" -N core="urn:activemq:core" \
        --subnode "/activemq:configuration/core:core/core:ha-policy/core:replication/core:slave" \
        -t elem -n "group-name" -v "${HA_GROUP_NAME}" $CONFIG_PATH/broker.xml
    fi
  fi  

  if [ "${CLUSTER_CONNECTIONS}" ];then
    for connector in ${CLUSTER_CONNECTIONS}
    do
      # do not add cluster connection for local broker
      if [ "${connector}" = "${CLUSTER_URI}" ];then
       continue
      fi
      count=$((count+1))
      SERVICE=$(echo "$connector"|sed -e 's/.*\/\(.*\):.*/\1/g')
      CONNECTOR_NAME="artemis-${count}-${SERVICE}"
      xmlstarlet ed -L -N activemq=urn:activemq -N core=urn:activemq:core -s /activemq:configuration/core:core/core:connectors \
       -t elem -n connector -v "${connector}\${brokerconfig.connectorArgs}" -i \$prev -t attr -n name -v "${CONNECTOR_NAME}" "$CONFIG_PATH/broker.xml"

      xmlstarlet ed -L -N activemq=urn:activemq -N core=urn:activemq:core -s \
       /activemq:configuration/core:core/core:cluster-connections/core:cluster-connection/core:static-connectors \
       -t elem -n connector-ref -v "${CONNECTOR_NAME}" "$CONFIG_PATH/broker.xml"
    done
  fi
fi
# End clustering config


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
  sed -i "s/^JAVA_ARGS=\"/JAVA_ARGS=\"-Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.port=${JMX_PORT:-1099} -Dcom.sun.management.jmxremote.rmi.port=${JMX_RMI_PORT:-1098} -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false /g" $CONFIG_PATH/artemis.profile
  mergeXmlFiles "$CONFIG_PATH/broker.xml" /opt/assets/enable-jmx.xml "$CONFIG_PATH/broker.xml"
fi

if [ "$ENABLE_JMX_EXPORTER" ]; then
  sed -i "s/^JAVA_ARGS=\"/JAVA_ARGS=\"-javaagent:\/opt\/jmx-exporter\/jmx_prometheus_javaagent.jar=9404:\/opt\/jmx-exporter\/jmx-exporter-config.yaml /g" $CONFIG_PATH/artemis.profile
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

###
# Update dynamic env vars
###
# Add BROKER_CONFIGS env variable to startup options
sed -i "/BROKER_CONFIGS/!s/^JAVA_ARGS=\"/JAVA_ARGS=\"\$BROKER_CONFIGS /g" $CONFIG_PATH/artemis.profile;

# Loop through all BROKER_CONFIG_... and convert to java system properties
env|grep -E "^BROKER_CONFIG_"|sed -e 's/BROKER_CONFIG_//g' >/tmp/brokerconfigs.txt
while read -r config
do
  PARAM=${config%%=*}
  PARAM_CAMEL_CASE=$(echo "$PARAM"|sed -r 's/./\L&/g; s/(^|-|_)(\w)/\U\2/g; s/./\L&/')
  VALUE=${config#*=}
  echo "PARAM=$PARAM_CAMEL_CASE VALUE=$VALUE"
  BROKER_CONFIGS="${BROKER_CONFIGS} -Dbrokerconfig.${PARAM_CAMEL_CASE}=${VALUE}"
done < /tmp/brokerconfigs.txt
rm -f /tmp/brokerconfigs.txt
export BROKER_CONFIGS

if [ "$1" = 'artemis-server' ]; then
  exec dumb-init -- sh ./artemis run
fi

exec "$@"
