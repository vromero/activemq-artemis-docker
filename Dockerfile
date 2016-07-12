# ActiveMQ Apollo 1.2.0

FROM java:8
MAINTAINER Victor Romero <victor.romero@gmail.com>

# add user and group for artemis
RUN groupadd -r artemis && useradd -r -g artemis artemis

RUN apt-get -qq -o=Dpkg::Use-Pty=0 update && apt-get -qq -o=Dpkg::Use-Pty=0 upgrade -y && \
  apt-get -qq -o=Dpkg::Use-Pty=0 install -y --no-install-recommends libaio1 xmlstarlet && \
  rm -rf /var/lib/apt/lists/*

# grab gosu for easy step-down from root
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN apt-get -qq -o=Dpkg::Use-Pty=0 update && apt-get -qq install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
	&& wget -q -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
	&& wget -q -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
	&& gpg --verify /usr/local/bin/gosu.asc \
	&& rm /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu

# Uncompress and validate
RUN cd /opt && wget -q http://www.us.apache.org/dist/activemq/activemq-artemis/1.2.0/apache-artemis-1.2.0-bin.tar.gz && \
  wget -q http://www.us.apache.org/dist/activemq/activemq-artemis/1.2.0/apache-artemis-1.2.0-bin.tar.gz.asc && \
  wget -q http://apache.org/dist/activemq/KEYS && \
  gpg --import KEYS && \
  gpg apache-artemis-1.2.0-bin.tar.gz.asc && \
  tar xfz apache-artemis-1.2.0-bin.tar.gz && \
  ln -s apache-artemis-1.2.0 apache-artemis && \
  rm -f apache-artemis-1.2.0-bin.tar.gz KEYS apache-artemis-1.2.0-bin.tar.gz.asc

# Create broker instance
RUN cd /var/lib && \
  /opt/apache-artemis-1.2.0/bin/artemis create artemis \
    --home /opt/apache-artemis \
    --user artemis \
    --password simetraehcapa \
    --role amq \
    --require-login \
    --cluster-user artemisCluster \
    --cluster-password simetraehcaparetsulc

# Ports are only exposed with an explicit argument, there is no need to binding
# the web console to localhost
RUN cd /var/lib/artemis/etc && \
  xmlstarlet ed -L -N amq="http://activemq.org/schema" \
    -u "/amq:broker/amq:web/@bind" \
    -v "http://0.0.0.0:8161" bootstrap.xml

RUN chown -R artemis.artemis /var/lib/artemis

# Web Server
EXPOSE 8161

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

# Expose some outstanding folders
VOLUME ["/var/lib/artemis/data"]
VOLUME ["/var/lib/artemis/tmp"]
VOLUME ["/var/lib/artemis/etc"]

WORKDIR /var/lib/artemis/bin

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["artemis-server"]
