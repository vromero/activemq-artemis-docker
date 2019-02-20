# ActiveMQ Artemis

##########################################################
## Build Image                                           #
##########################################################
FROM openjdk:8u171-jdk-stretch as builder
LABEL maintainer="Victor Romero <victor.romero@gmail.com>"

ARG ACTIVEMQ_ARTEMIS_VERSION
ARG ACTIVEMQ_DISTRIBUTION_URL
ENV JMX_EXPORTER_VERSION=0.3.1
ENV JGROUPS_KUBERNETES_VERSION=0.9.3

# add user and group for artemis
RUN groupadd -r artemis && useradd -r -s /bin/false -g artemis artemis

RUN apt-get -qq -o=Dpkg::Use-Pty=0 update && \
  apt-get -qq -o=Dpkg::Use-Pty=0 install -y --no-install-recommends \
    libaio1=0.3.110-3 \
    xmlstarlet=1.6.1-2 \
    jq=1.5+dfsg-1.3 \
    ca-certificates=20161130+nmu1+deb9u1 \
    wget=1.18-5+deb9u2 && \
  rm -rf /var/lib/apt/lists/*

# Make sure pipes are considered to detemine success, see: https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Uncompress and validate
WORKDIR /opt
RUN if (echo "${ACTIVEMQ_DISTRIBUTION_URL}" | grep -Eq  ".zip\$" ) ; \
    then \
      mkdir tmp && \
      wget "${ACTIVEMQ_DISTRIBUTION_URL}" -P tmp/ && \
      unzip -d tmp -q "tmp/*.zip" && rm -f tmp/*.zip && ls -l tmp/ && \
        mv tmp/* ./apache-artemis-${ACTIVEMQ_ARTEMIS_VERSION} && \
        ln -s "/opt/apache-artemis-${ACTIVEMQ_ARTEMIS_VERSION}" "/opt/apache-artemis" && \
        rmdir tmp; \
    elif test -n "${ACTIVEMQ_DISTRIBUTION_URL}" ; \
    then \
      echo "Only .zip format is supported when using ACTIVEMQ_DISTRIBUTION_URL" && \
      exit 2; \
    else \
      wget "https://repository.apache.org/content/repositories/releases/org/apache/activemq/apache-artemis/${ACTIVEMQ_ARTEMIS_VERSION}/apache-artemis-${ACTIVEMQ_ARTEMIS_VERSION}-bin.tar.gz" && \
      wget "https://repository.apache.org/content/repositories/releases/org/apache/activemq/apache-artemis/${ACTIVEMQ_ARTEMIS_VERSION}/apache-artemis-${ACTIVEMQ_ARTEMIS_VERSION}-bin.tar.gz.asc" && \
      wget "http://apache.org/dist/activemq/KEYS" && \
      gpg --no-tty --import "KEYS" && \
      gpg --no-tty "apache-artemis-${ACTIVEMQ_ARTEMIS_VERSION}-bin.tar.gz.asc" && \
      tar xfz "apache-artemis-${ACTIVEMQ_ARTEMIS_VERSION}-bin.tar.gz" && \
      ln -s "/opt/apache-artemis-${ACTIVEMQ_ARTEMIS_VERSION}" "/opt/apache-artemis" && \
      rm -f "apache-artemis-${ACTIVEMQ_ARTEMIS_VERSION}-bin.tar.gz" "KEYS" "apache-artemis-${ACTIVEMQ_ARTEMIS_VERSION}-bin.tar.gz.asc"; \
    fi

# Create broker instance
# Per recommendation of https://activemq.apache.org/artemis/docs/latest/perf-tuning.html : -XX:+AggressiveOpts -XX:+UseFastAccessorMethods -XX:+UseParallelOldGC 
WORKDIR /var/lib
RUN if test "${ACTIVEMQ_ARTEMIS_VERSION}" = "1.0.0" ; \
    then \
      echo n | "/opt/apache-artemis-${ACTIVEMQ_ARTEMIS_VERSION}/bin/artemis" create artemis \
        --home /opt/apache-artemis \
        --user artemis \
        --password simetraehcapa \
        --cluster-user artemisCluster \
        --cluster-password simetraehcaparetsulc ; \
    else \
      "/opt/apache-artemis-${ACTIVEMQ_ARTEMIS_VERSION}/bin/artemis" create artemis \
        --home /opt/apache-artemis \
        --user artemis \
        --password simetraehcapa \
        --role amq \
        --require-login \
        --cluster-user artemisCluster \
        --cluster-password simetraehcaparetsulc ; \
    fi 

# Using KUBE_PING 0.9.3. Can't upgrade to 1.x.x as Artemis uses JGroups 3.3.x 
# https://github.com/jgroups-extras/jgroups-kubernetes/issues/30
WORKDIR /opt/jgroupskubernetes
RUN wget -O ivy-2.4.0.jar http://search.maven.org/remotecontent?filepath=org/apache/ivy/ivy/2.4.0/ivy-2.4.0.jar && \
  java -jar ivy-2.4.0.jar -dependency org.jgroups.kubernetes kubernetes "${JGROUPS_KUBERNETES_VERSION}" -retrieve "[artifact]-[revision](-[classifier]).[ext]" -types jar && \
  java -jar ivy-2.4.0.jar -dependency org.jgroups.kubernetes dns "${JGROUPS_KUBERNETES_VERSION}" -retrieve "[artifact]-[revision](-[classifier]).[ext]" -types jar && \
  rm ivy-2.4.0.jar
  
WORKDIR /var/lib/artemis/etc

# --java-options doesn't seem to work across the board on all versions adding them manually
RUN sed -i "s/JAVA_ARGS=\"/JAVA_ARGS=\"-Djava.net.preferIPv4Addresses=true -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=2 /g" ../etc/artemis.profile

# Ports are only exposed with an explicit argument, there is no need to binding
# the web console to localhost
RUN xmlstarlet ed -L -N amq="http://activemq.org/schema" \
    -u "/amq:broker/amq:web/@bind" \
    -v "http://0.0.0.0:8161" bootstrap.xml

# In a similar fashion the jolokia access is restricted to localhost only. Disabling
# this as in the natural environmnets for the image like Kubernetes this is problematic.
RUN if (echo "${ACTIVEMQ_ARTEMIS_VERSION}" | grep -Eq  "(2.[^0-3]\\.[0-9]|[^1-2]\\.[0-9]\\.[0-9]+)" ) ; then xmlstarlet ed --inplace --subnode "/restrict" --type elem -n "remote" jolokia-access.xml && xmlstarlet ed --inplace --subnode "/restrict/remote" --type elem -n host -v "0.0.0.0/0" jolokia-access.xml; fi

# Remove default values for memory in artemis profile in order to let the automatic
# Java ergonomics detection work https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/ergonomics.html
RUN sed -i "s/-Xm[xs][^ \"]*//g" ../etc/artemis.profile

# For the casual run of the image make the docker-entrypoint-sh think 
# that the performance journal calibration is already completed
RUN if (echo "${ACTIVEMQ_ARTEMIS_VERSION}" | grep -Eq  "(1.5\\.[3-5]|[^1]\\.[0-9]\\.[0-9]+)" ) ; then touch /var/lib/artemis/data/.perf-journal-completed; fi

WORKDIR /opt/jmx-exporter
RUN wget "https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${JMX_EXPORTER_VERSION}/jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar" && \
  wget "https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${JMX_EXPORTER_VERSION}/jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar.sha1" && \
  echo "$(cat "jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar.sha1")" "jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar" | sha1sum -c - && \
  rm "jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar.sha1" && \
  ln -s "/opt/jmx-exporter/jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar" "/opt/jmx-exporter/jmx_prometheus_javaagent.jar"
COPY assets/jmx-exporter-config.yaml /opt/jmx-exporter/etc/

##########################################################
## Run Image                                             #
##########################################################
FROM openjdk:8-jre-alpine
LABEL maintainer="Victor Romero <victor.romero@gmail.com>"
ARG ACTIVEMQ_ARTEMIS_VERSION
ENV ACTIVEMQ_ARTEMIS_VERSION=$ACTIVEMQ_ARTEMIS_VERSION

# add user and group for artemis
RUN addgroup -g 1000 -S artemis && adduser -u 1000 -S -G artemis artemis

# Sadly this line is likely to fail every so often, see: https://medium.com/@stschindler/the-problem-with-docker-and-alpines-package-pinning-18346593e891
# Still versions are pinned to maintain some small level of https://reproducible-builds.org/
RUN apk add --no-cache \
  libaio=0.3.111-r0 \
  xmlstarlet=1.6.1-r0 \
  jq=1.6-r0 \
  dumb-init=1.2.2-r1 \
  sed=4.5-r0 \
  gettext=0.19.8.1-r4

COPY --from=builder "/opt/apache-artemis-${ACTIVEMQ_ARTEMIS_VERSION}" "/opt/apache-artemis-${ACTIVEMQ_ARTEMIS_VERSION}"
COPY --from=builder "/var/lib/artemis" "/var/lib/artemis"
COPY --from=builder "/opt/jmx-exporter" "/opt/jmx-exporter"

# To enable RESTORE_CONFIGURATION
COPY --from=builder "/var/lib/artemis/etc" "/var/lib/artemis/etc-backup"

RUN ln -s "/opt/apache-artemis-${ACTIVEMQ_ARTEMIS_VERSION}" /opt/apache-artemis
RUN chown -R artemis.artemis /var/lib/artemis 
RUN chown -R artemis.artemis /opt/jmx-exporter

RUN mkdir -p /opt/assets
COPY assets/merge.xslt /opt/assets
COPY assets/enable-jmx.xml /opt/assets

# Web Server
EXPOSE 8161

# JMX Exporter
EXPOSE 9404

# Port for CORE,MQTT,AMQP,HORNETQ,STOMP,OPENWIRE
EXPOSE 61616

# Port for HORNETQ,STOMP
EXPOSE 5445

# Port for AMQP
EXPOSE 5672

# Port for MQTT
EXPOSE 1883

#Port for STOMP
EXPOSE 61613

WORKDIR /var/lib/artemis/bin

USER artemis

RUN mkdir /var/lib/artemis/lock

# Expose some outstanding folders
VOLUME ["/var/lib/artemis/data"]
VOLUME ["/var/lib/artemis/tmp"]
VOLUME ["/var/lib/artemis/etc"]
VOLUME ["/var/lib/artemis/etc-override"]
VOLUME ["/var/lib/artemis/lock"]

COPY assets/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["artemis-server"]
