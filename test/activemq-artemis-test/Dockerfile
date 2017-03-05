FROM java:8
MAINTAINER Victor Romero <victor.romero@gmail.com>

RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends ca-certificates curl mosquitto-clients

RUN mkdir /opt/activemq-artemis-test
WORKDIR /opt/activemq-artemis-test

RUN curl -s -O https://raw.githubusercontent.com/pgrange/bash_unit/master/install.sh
RUN bash install.sh

ENV DOCKERIZE_VERSION v0.3.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

COPY docker-entrypoint.sh /
RUN mkdir /opt/activemq-artemis-test/tests
VOLUME ["/opt/activemq-artemis-test/tests"]

ENTRYPOINT ["/docker-entrypoint.sh"]
