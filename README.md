# Supported tags and respective `Dockerfile` links

-	[`1.3.0`, `latest`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/Dockerfile)
-	[`1.2.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/1.2.0/Dockerfile)
-	[`1.1.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/1.1.0/Dockerfile)
-	[`1.0.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/1.0.0/Dockerfile)

# What is ActiveMQ Artemis?

Apache ActiveMQ Artemis is an open source project to build a multi-protocol, embeddable, very high performance, clustered, asynchronous messaging system. Apache ActiveMQ Artemis is an example of Message Oriented Middleware (MoM)

> [activemq.apache.org/artemis](https://activemq.apache.org/artemis/index.html)

![logo](https://activemq.apache.org/artemis/images/activemq-logo.png)

# How to use this image

## Running the daemon

ActiveMQ Artemis daemon can be run with the following command:

```console
$ docker run -d vromero/activemq-artemis
```

After a few seconds, you can run the following command `docker logs some-thing` (where some-thing is the name docker assigned to your instance), you'll see in the output a block similar to:

    _        _               _
    / \  ____| |_  ___ __  __(_) _____
    / _ \|  _ \ __|/ _ \  \/  | |/  __/
    / ___ \ | \/ |_/  __/ |\/| | |\___ \
    /_/   \_\|   \__\____|_|  |_|_|/___ /
    Apache ActiveMQ Artemis 1.1.0

    HH:mm:ss,SSS INFO  [org.apache.activemq.artemis.integration.bootstrap] AMQ101000: Starting ActiveMQ Artemis Server
    HH:mm:ss,SSS INFO  [org.apache.activemq.artemis.core.server] AMQ221000: live Message Broker is starting with configuration Broker Configuration (clustered=false,journalDirectory=./data/journal,bindingsDirectory=./data/bindings,largeMessagesDirectory=./data/large-messages,pagingDirectory=./data/paging)
    HH:mm:ss,SSS INFO  [org.apache.activemq.artemis.core.server] AMQ221012: Using AIO Journal
    HH:mm:ss,SSS INFO  [org.apache.activemq.artemis.core.server] AMQ221043: Protocol module found: [artemis-server]. Adding protocol support for: CORE
    HH:mm:ss,SSS INFO  [org.apache.activemq.artemis.core.server] AMQ221043: Protocol module found: [artemis-amqp-protocol]. Adding protocol support for: AMQP
    HH:mm:ss,SSS INFO  [org.apache.activemq.artemis.core.server] AMQ221043: Protocol module found: [artemis-hornetq-protocol]. Adding protocol support for: HORNETQ
    HH:mm:ss,SSS INFO  [org.apache.activemq.artemis.core.server] AMQ221043: Protocol module found: [artemis-mqtt-protocol]. Adding protocol support for: MQTT
    HH:mm:ss,SSS INFO  [org.apache.activemq.artemis.core.server] AMQ221043: Protocol module found: [artemis-openwire-protocol]. Adding protocol support for: OPENWIRE
    HH:mm:ss,SSS INFO  [org.apache.activemq.artemis.core.server] AMQ221043: Protocol module found: [artemis-stomp-protocol]. Adding protocol support for: STOMP
    HH:mm:ss,SSS INFO  [org.apache.activemq.artemis.core.server] AMQ221003: trying to deploy queue jms.queue.DLQ
    HH:mm:ss,SSS INFO  [org.apache.activemq.artemis.core.server] AMQ221003: trying to deploy queue jms.queue.ExpiryQueue
    HH:mm:ss,SSS INFO  [org.apache.activemq.artemis.core.server] AMQ221020: Started Acceptor at 0.0.0.0:61616 for protocols [CORE,MQTT,AMQP,HORNETQ,STOMP,OPENWIRE]
    HH:mm:ss,SSS INFO  [org.apache.activemq.artemis.core.server] AMQ221020: Started Acceptor at 0.0.0.0:5445 for protocols [HORNETQ,STOMP]
    HH:mm:ss,SSS INFO  [org.apache.activemq.artemis.core.server] AMQ221020: Started Acceptor at 0.0.0.0:5672 for protocols [AMQP]
    HH:mm:ss,SSS INFO  [org.apache.activemq.artemis.core.server] AMQ221020: Started Acceptor at 0.0.0.0:1883 for protocols [MQTT]
    HH:mm:ss,SSS INFO  [org.apache.activemq.artemis.core.server] AMQ221020: Started Acceptor at 0.0.0.0:61613 for protocols [STOMP]
    HH:mm:ss,SSS INFO  [org.apache.activemq.artemis.core.server] AMQ221007: Server is now live
    HH:mm:ss,SSS INFO  [org.apache.activemq.artemis.core.server] AMQ221001: Apache ActiveMQ Artemis Message Broker version 1.1.0 [nodeID=a949a672-6585-11e5-b408-e92ec3fcc125]
    HTTP Server started at http://0.0.0.0:8161

## Setting memory values

By default Artemis will use 512 Megabytes or RAM at minimum and 2048 Megabytes at maximum. You can set the memory that you application needs by using the parameters `ARTEMIS__MIN_MEMORY` and `ARTEMIS_MAX_MEMORY`:

```console
$ docker run -d -e 'ARTEMIS_MIN_MEMORY=1512M' -e 'ARTEMIS_MAX_MEMORY=3048M' vromero/activemq-artemis
```

The previous example will launch Apache ActiveMQ Artemis in docker with 1512 MB of memory, with a maximum usage of 3048 MB of memory.
The format of the values passed is the same than the format used for the Java `-Xms` and `-Xmx` parameters and its documented [here](http://docs.oracle.com/javase/7/docs/technotes/tools/solaris/java.html).


## Setting username and password

If you wish to change the default username and password of `artemis` / `simetraehcapa`, you can do so with the `ARTEMIS_USERNAME` and `ARTEMIS_PASSWORD` environmental variables:

```console
$ docker run -d -e ARTEMIS_USERNAME=myuser -e ARTEMIS_PASSWORD=otherpassword vromero/activemq-artemis
```

## Mount points

| Mount point            | Description                                                       |
|----------------------- |-------------------------------------------------------------------|
|`/var/lib/artemis/data` | Holds the data files used for storing persistent messages         |
|`/var/lib/artemis/etc`  | Hold the instance configuration files                             |

## Exposed ports

| Port    | Description                                                     |
|-------- |-----------------------------------------------------------------|
| `8161`  | Web Server                                                      |
| `61616` | Core,MQTT,AMQP,HORNETQ,STOMP,Openwire                           |
| `5445`  | HORNETQ,STOMP                                                   |
| `5672`  | AMQP                                                            |
| `1883`  | MQTT                                                            |
| `61613` | STOMP                                                           |

# License

View [license information](http://www.apache.org/licenses/LICENSE-2.0) for the software contained in this image.

# Supported Docker versions

This image is officially supported on Docker version 1.8.2.

Support for older versions (down to 1.0) is provided on a best-effort basis.

# User Feedback

## Issues

If you have any problems with or questions about this image, please contact us through a [GitHub issue](https://github.com/vromero/activemq-artemis-docker/issues).

## Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub issue](https://github.com/vromero/activemq-artemis-docker/issues), especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.
