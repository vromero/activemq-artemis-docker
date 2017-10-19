# Supported tags and respective `Dockerfile` links

-	[`2.3.0`, `latest`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/2.3.0/Dockerfile)
-	[`2.3.0-alpine`, `latest`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/2.3.0-alpine/Dockerfile)
-	[`2.2.0`, `latest`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/2.2.0/Dockerfile)
-	[`2.2.0-alpine`, `latest`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/2.2.0-alpine/Dockerfile)
-	[`2.1.0`, `latest`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/2.1.0/Dockerfile)
-	[`2.1.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/2.1.0-alpine/Dockerfile)
-	[`2.0.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/2.0.0/Dockerfile)
-	[`2.0.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/2.0.0-alpine/Dockerfile)
-	[`1.5.5`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/1.5.5/Dockerfile)
-	[`1.5.5-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/1.5.5-alpine/Dockerfile)
-	[`1.5.4`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/1.5.4/Dockerfile)
-	[`1.5.4-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/1.5.4-alpine/Dockerfile)
-	[`1.5.3`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/1.5.3/Dockerfile)
-	[`1.5.3-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/1.5.3-alpine/Dockerfile)
-	[`1.5.2`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/1.5.2/Dockerfile)
-	[`1.5.1`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/1.5.1/Dockerfile)
-	[`1.5.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/1.5.0/Dockerfile)
-	[`1.4.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/1.4.0/Dockerfile)
-	[`1.3.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/1.3.0/Dockerfile)
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

## Configuring JMX

Due to the JMX's nature, often with dynamics ports for RMI and the need having configure the public IP address to reach the RMI server.
It is discouraged to use JMX in Docker. Although in certain scenarios, it could be advisable, as when deploying in a
container orchestrator such as Kubernetes or Mesos, and deploying along side this container a side car. For such cases
the following environment variable could be used: `ENABLE_JMX`.

It is also possible to set the JMX port and the JMX RMI port with these two environment variables respectively: `JMX_PORT` (default: 1099) and `JMX_RMI_PORT` (default: 1098).

Given that JMX is intended for side cars, it is attached only to localhost and not protected with SSL. Likewise, its ports are not declared in the `Dockerfile`.

```console
$ docker run -d -e ENABLE_JMX=true -e JMX_PORT=1199 -e JMX_RMI_PORT=1198 vromero/activemq-artemis
```

## Performing a performance journal test

Different kinds of volumes need different values in fine tuning.
It is possible to calculate the journal-buffer-timeout you should use with the current data folder and
apply it directly to the broker configuration using the environment variable: `ARTEMIS_PERF_JOURNAL` with one
of the following valid values:

| Value            | Description                                                       |
|------------------|-------------------------------------------------------------------|
|`AUTO`            | Checks for the existence of a `.perf-journal-completed` file in the data volume, if it doesn't exist performs the calculation, applies the configuration and creates the file. |
|`NEVER` (default) | Never do the performance journal configuration                    |
|`ALWAYS`          | Always do the performance journal configuration                   |

It is advisable to set it up in `AUTO` in non manually configured containers, although given that this image is
often used for quick tests and non production environments it is set as NEVER as default value.

```console
$ docker run -d -e ARTEMIS_PERF_JOURNAL=AUTO vromero/activemq-artemis
```

This option is available since `1.5.3`.

## Overriding parts of the configuration

It is possible to mount a whole artemis `etc` directory in this image in the volume `/var/lib/artemis/etc`.
But this is an overkill for many situations where only small tweaks are necessary.  

For those cases `/var/lib/artemis/etc-override` can be used.

Multiple files with snippets of configuration can be dropped in the `etc-override` folder. Those configuration files must be named following the name convention `broker-{{desc}}.xml` where `desc` is a numeric representation of the snippet.
The configuration files will be *merged* with the default configuration. An alphabetical precedence of the file names will be considered for the merge and in case of collision the latest change will be treated as final.

For instance lets say that you want to add a diverts section, you could have a local directory, lets say `/var/artemis-data/etc-override`
where you could place a `broker-00.xml` file that looks like the following listing:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>

<configuration xmlns="urn:activemq" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:activemq /schema/artemis-server.xsd">
   <core xmlns="urn:activemq:core">
      <diverts>
         <divert name="order-divert">
            <routing-name>order-divert</routing-name>
            <address>orders</address>
            <forwarding-address>spyTopic</forwarding-address>
            <exclusive>false</exclusive>
         </divert>
      </diverts>
   </core>
</configuration>
```

For the use cases where instead of merging, the desired outcome is an override, a file named `broker-00.xslt`
in `/var/lib/artemis/etc-override` is supported. For instance to delete override the `jms` definitions instead of merging, these files could be used:

`broker.xml`

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>

<configuration xmlns="urn:activemq" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:activemq /schema/artemis-configuration.xsd">
  <jms xmlns="urn:activemq:jms">
    <queue name="myfancyqueue"/>
    <queue name="myotherqueue"/>
  </jms>
</configuration>
```

`broker-00.xslt`

```xslt
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:activemq="urn:activemq" xmlns:jms="urn:activemq:jms">

 <xsl:output omit-xml-declaration="yes"/>

    <xsl:template match="node()|@*">
      <xsl:copy>
         <xsl:apply-templates select="node()|@*"/>
      </xsl:copy>
    </xsl:template>

    <xsl:template match="*[local-name()='jms']"/>
</xsl:stylesheet>
```

If you would like to see the final result of your transformations, execute the following:

```
docker run -v /var/artemis-data/override:/var/lib/artemis/etc-override -it --rm vromero/activemq-artemis cat ../etc/broker.xml
```

## Mount points

| Mount point                      | Description                                                       |
|--------------------------------- |-------------------------------------------------------------------|
|`/var/lib/artemis/data`           | Holds the data files used for storing persistent messages         |
|`/var/lib/artemis/etc`            | Hold the instance configuration files                             |
|`/var/lib/artemis/etc-override`   | Hold the instance configuration files                             |


## Exposed ports

| Port    | Description                                                     |
|-------- |-----------------------------------------------------------------|
| `8161`  | Web Server                                                      |
| `61616` | Core,MQTT,AMQP,HORNETQ,STOMP,Openwire                           |
| `5445`  | HORNETQ,STOMP                                                   |
| `5672`  | AMQP                                                            |
| `1883`  | MQTT                                                            |
| `61613` | STOMP                                                           |

Since Artemis `2.3.0`, there a console available in the Web Server port at
`/console` using the login/password set up with `ARTEMIS_USERNAME` and `ARTEMIS_PASSWORD`.

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
