# ActiveMQ Artemis

FROM openjdk:8-jre-alpine
MAINTAINER Victor Romero <victor.romero@gmail.com>

# add user and group for artemis
RUN addgroup -S artemis && adduser -S -G artemis artemis

RUN apk add --no-cache libaio xmlstarlet jq

ENV GOSU_VERSION 1.10
RUN set -x \
    && apk add --no-cache --virtual .gosu-deps \
        dpkg \
        gnupg \
        openssl \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apk del .gosu-deps

# Uncompress and validate
RUN set -x && \
    apk add --no-cache --virtual .gosu-deps wget gnupg && \
  mkdir /opt && cd /opt && \
  wget -q http://www-us.apache.org/dist/activemq/activemq-artemis/1.5.3/apache-artemis-1.5.3-bin.tar.gz && \
  wget -q http://www.us.apache.org/dist/activemq/activemq-artemis/1.5.3/apache-artemis-1.5.3-bin.tar.gz.asc && \
  wget -q http://apache.org/dist/activemq/KEYS && \
  gpg --import KEYS && \
  gpg apache-artemis-1.5.3-bin.tar.gz.asc && \
  tar xfz apache-artemis-1.5.3-bin.tar.gz && \
  ln -s apache-artemis-1.5.3 apache-artemis && \
  rm -f apache-artemis-1.5.3-bin.tar.gz KEYS apache-artemis-1.5.3-bin.tar.gz.asc && \
  apk del .gosu-deps

# Create broker instance
RUN cd /var/lib && \
  /opt/apache-artemis-1.5.3/bin/artemis create artemis \
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

RUN mkdir -p /opt/merge
COPY merge.xslt /opt/merge

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
VOLUME ["/var/lib/artemis/etc-override"]

WORKDIR /var/lib/artemis/bin

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["artemis-server"]
