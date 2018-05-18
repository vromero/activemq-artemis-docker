![latest 2.5.0](https://img.shields.io/badge/latest-2.5.0-green.svg?style=flat) ![License MIT](https://img.shields.io/badge/license-APACHE-blue.svg) [![Build Status](https://travis-ci.org/vromero/activemq-artemis-docker.svg?branch=master)](https://travis-ci.org/vromero/activemq-artemis-docker) [![](https://img.shields.io/docker/stars/vromero/activemq-artemis.svg)](https://hub.docker.com/r/vromero/activemq-artemis 'DockerHub') [![](https://img.shields.io/docker/pulls/vromero/activemq-artemis.svg)](https://hub.docker.com/r/vromero/activemq-artemis 'DockerHub') [![Say Thanks!](https://img.shields.io/badge/Say%20Thanks-!-1EAEDB.svg)](https://saythanks.io/to/vromero)

## 1. What is ActiveMQ Artemis?

[Apache ActiveMQ Artemis](https://activemq.apache.org/artemis) is an open source project to build a multi-protocol, embeddable, very high performance, clustered, asynchronous messaging system. Apache ActiveMQ Artemis is an example of Message Oriented Middleware (MoM).

![logo](https://activemq.apache.org/artemis/images/activemq-logo.png)

## 2. Tags and `Dockerfile` links

| Debian Based                                                                                 | Alpine Based                                                                                               |
|--------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| [`latest`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile) | [`latest-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine) |
| [`2.5.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.5.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.4.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.4.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.3.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.3.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.2.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.2.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.1.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.1.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.0.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.0.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`1.5.5`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`1.5.5-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| ~~[`1.5.4`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)~~  | ~~[`1.5.4-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)~~  |
| ~~[`1.5.3`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)~~  | ~~[`1.5.3-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)~~  |
| ~~[`1.5.2`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)~~  | ~~[`1.5.2-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)~~  |
| ~~[`1.5.1`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)~~  | ~~[`1.5.1-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)~~  |
| ~~[`1.5.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)~~  | ~~[`1.5.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)~~  |
| ~~[`1.4.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)~~  | ~~[`1.4.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)~~  |
| ~~[`1.3.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)~~  | ~~[`1.3.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)~~  |
| ~~[`1.2.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)~~  | ~~[`1.2.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)~~  |
| ~~[`1.1.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)~~  | ~~[`1.1.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)~~  |
| ~~[`1.0.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)~~  | ~~[`1.0.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)~~  |

## 3. About this image

The ActiveMQ Artemis images come in two flavors, both equally supported. :

- **Debian based**: the default one.
- **Alpine based**: much lighter.

All versions of ActiveMQ Artemis are provided for the time being but versions previous to 1.5.5 shall be considered deprecated and could be removed at any time.

## 4. How to use this image

You can find how to run this image in the section *Running the image*. Beware as the default 
configuration is not recommended for production usage, at the very least you'll want to set your own 
login and password. This is described with detail in section *Setting the username and password*.
In case you also want to set some customized memory limits, this is described in
*Setting the memory values*.

ActiveMQ Artemis typically persists the queue state to disk. In order to leverage the most of your
disk ActiveMQ artemis might require some fine-tuning. The good news is that this process is
fully automated and its described in *Performing a performance journal test*.

JMX uses RMI and therefore random ports. This is extremely bad for automatization in Docker and
in general. For that reason its not supported for most of the use cases. However, when using this
image in orchestrators like Kubernetes you might want to connect from a sidecar where it
does make sense. How to enable JMX is described in section *Enabling JMX*.

The Jolokia console CORS header won't be a problem by default as it set to `*`, however if you want to 
narrow it down for improved security don't miss the section *Settings the console's allow origin*.

Some of the configurations mentioned above are scripted automations that modify the
configuration files. You might have your own configuration that you want to provide as a whole.
In that case disregard the aforementioned sections and find how to pass your own
configuration in section *Using external configuration files*.

If instead you want to use the configuration parameters and make some non-mayor changes to the
configuration you could use the mechanisms to apply some small transformations using XSLT
as described in section *Overriding parts of the configuration*.

## 5. Running the image

There are different methods to run a Docker image, from interactive Docker to Kubernetes and Docker
Compose. This documentation will cover only Docker with an interactive terminal mode. You should
refer to the appropriate documentation for more information around other execution methods.

To run ActiveMQ with AMQP, JMS and the web console open (if your are running `2.3.0` or later),
run the following command:

```console
docker run -it --rm \
  -p 8161:8161 \
  -p 61616:61616 \
  vromero/activemq-artemis
```  

After a few seconds you'll see in the output a block similar to:

    _        _               _
    / \  ____| |_  ___ __  __(_) _____
    / _ \|  _ \ __|/ _ \  \/  | |/  __/
    / ___ \ | \/ |_/  __/ |\/| | |\___ \
    /_/   \_\|   \__\____|_|  |_|_|/___ /
    Apache ActiveMQ Artemis x.x.x

    HH:mm:ss,SSS INFO  [...] AMQ101000: Starting ActiveMQ Artemis Server

At this point you can open the web server port at [`8161`](http://127.0.0.1:8161) and check the web console using
the default username and password of `artemis` / `simetraehcapa`.

### 5.1 Setting the username and password

If you wish to change the default username and password of `artemis` / `simetraehcapa`, you can do so with the `ARTEMIS_USERNAME` and `ARTEMIS_PASSWORD` environment variables:

```console
docker run -it --rm \
  -e ARTEMIS_USERNAME=myuser \
  -e ARTEMIS_PASSWORD=otherpassword \
  vromero/activemq-artemis
```

### 5.2 Setting the memory values

By default this image does leverage the new features that came in Java 8u131 related to memory ergonomics in containerized environments, more information about it [here](https://developers.redhat.com/blog/2017/03/14/java-inside-docker/). 

It does use a `-XX:MaxRAMFraction=2` meaning that half of the memory made avaiable to the container will be used by the Java heap, leaving the other half for other types of Java memory and other OS purposes. However, in some
circumstances it might be advisable to fine tune the memory to manual values, in that case you can set the memory that you application needs by using the parameters `ARTEMIS_MIN_MEMORY` and `ARTEMIS_MAX_MEMORY`:

```console
docker run -it --rm \
  -e 'ARTEMIS_MIN_MEMORY=1512M' \
  -e 'ARTEMIS_MAX_MEMORY=3048M' \
  vromero/activemq-artemis
```

The previous example will launch Apache ActiveMQ Artemis in docker with 1512 MB of memory, with a maximum usage of 3048 MB of memory.
The format of the values passed is the same than the format used for the Java `-Xms` and `-Xmx` parameters and its documented [here](http://docs.oracle.com/javase/7/docs/technotes/tools/solaris/java.html).

### 5.3 Performing a performance journal test

Different kinds of volumes need different values in fine tuning. In ActiveMQ Artemis the `journal-buffer-timeout` is oftentimes configured for this purpose.
**Since `1.5.3`** it is possible to calculate the optimal value automatically. This image supports this automation using the environment variable: `ARTEMIS_PERF_JOURNAL` with one of the following values:

| Value            | Description                                                       |
|------------------|-------------------------------------------------------------------|
|`AUTO` (default)  | Checks for the existence of a `.perf-journal-completed` file in the data volume, if it doesn't exist performs the calculation, applies the configuration and creates the file. |
|`NEVER`           | Never do the performance journal configuration                    |
|`ALWAYS`          | Always do the performance journal configuration                   |

It is safe to leave it as `AUTO` even for the casual usage of this image given that the image already have 
incorporated a `.perf-journal-completed` for its internal directory used when no volume is mounted.
One example of execution with the performance journal calibration set to be executed always can be found
in the next listing:

```console
docker run -it --rm \
  -e ARTEMIS_PERF_JOURNAL=ALWAYS \
  vromero/activemq-artemis
```

### 5.4 Enabling JMX

Due to the JMX's nature, often with dynamics ports for RMI and the need having configure the public IP address to reach the RMI server.
It is discouraged to use JMX in Docker. Although in certain scenarios, it could be advisable, as when deploying in a
container orchestrator such as Kubernetes or Mesos, and deploying along side this container a side car. For such cases
the following environment variable could be used: `ENABLE_JMX`.

It is also possible to set the JMX port and the JMX RMI port with these two environment variables respectively: `JMX_PORT` (default: 1099) and `JMX_RMI_PORT` (default: 1098).

Given that JMX is intended for side cars, it is attached only to localhost and not protected with SSL. Likewise, its ports are not declared in the `Dockerfile`.

```console
docker run -it --rm \
  -e ENABLE_JMX=true \
  -e JMX_PORT=1199 \
  -e JMX_RMI_PORT=1198 \
  vromero/activemq-artemis
```

### 5.5 Settings the console's allow origin

ActiveMQ Artemis console uses Jolokia. In the default vanilla non-docker installation Jolokia does set a CORS header to
allow only localhost. In the docker image this create problems as things are rarely accesed as localhost.

Therefore the docker image does set the CORS header to `*` by default. However there is a mechanism to narrow it
down to whatever value is best suited to you for improved security through the environmnet property: `JOLOKIA_ALLOW_ORIGIN`.

```console
docker run -it --rm \
  -e JOLOKIA_ALLOW_ORIGIN=192.168.1.1 \
  vromero/activemq-artemis
```

### 5.6 Using external configuration files

It is possible to mount a whole artemis `etc` directory in this image in the volume `/var/lib/artemis/etc`.
Be careful as this might be an overkill for many situations where only small tweaks are necessary.  

When using this technique be aware that the configuration files of Artemis might change from version to version.
Generally speaking, when in need to configure Artemis beyond what it is offered by this image using environment 
variables, it is recommended to use the partial override mechanism described in the next section.

### 5.7 Overriding parts of the configuration

The default ActiveMQ Artemis configuration can be partially modified, instead of completely replaced as in the previous section, using two mechanisms. Merge snippets and XSLT tranformations.

**Merging snippets**

Multiple files with snippets of configuration can be dropped in the `/var/lib/artemis/etc-override` volume. Those configuration files must be named following the name convention `broker-{{num}}.xml` where `num` is a numeric representation of the snippet.
The configuration files will be *merged* with the default configuration. An alphabetical precedence of the file names will be considered for the merge and in case of collision the latest change will be treated as final.

For instance lets say that you want to add a diverts section, you could have a local directory, lets say `/var/artemis-data/etc-override`
where you could place a `broker-00.xml` file that looks like the following listing:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>

<configuration xmlns="urn:activemq" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:activemq /schema/artemis-configuration.xsd">
   <core xmlns="urn:activemq:core" xsi:schemaLocation="urn:activemq:core ">
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

Please notice the `core` element change along with the versions:

- `1.0.0` up to `1.5.5`: `<core xmlns="urn:activemq:core">`
- `2.5.0` onwards: `<core xmlns="urn:activemq:core" xsi:schemaLocation="urn:activemq:core ">`

**Configuration transformations**

For the use cases where instead of merging, the desired outcome is a deletion or some other kind of advanced transformation a file named `broker-00.xslt`
in `/var/lib/artemis/etc-override` is supported. For instance to delete the `jms` definitions that is present by default in the `broker.xml` file shown below:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>

<configuration xmlns="urn:activemq" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:activemq /schema/artemis-configuration.xsd">
  ...
  <jms xmlns="urn:activemq:jms">
    <queue name="myfancyqueue"/>
    <queue name="myotherqueue"/>
  </jms>
  ...
</configuration>
```

A file name `broker-00.xslt` with content like the following listing, could be used:

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
docker run -it --rm \
  -v /var/artemis-data/override:/var/lib/artemis/etc-override \
  vromero/activemq-artemis \
  cat ../etc/broker.xml
```

### 5.8 Mount points

| Mount point                      | Description                                                       |
|--------------------------------- |-------------------------------------------------------------------|
|`/var/lib/artemis/data`           | Holds the data files used for storing persistent messages         |
|`/var/lib/artemis/etc`            | Hold the instance configuration files                             |
|`/var/lib/artemis/etc-override`   | Hold the instance configuration files                             |


### 5.9 Exposed ports

| Port    | Description                                                     |
|-------- |-----------------------------------------------------------------|
| `8161`  | Web Server                                                      |
| `61616` | Core,MQTT,AMQP,HORNETQ,STOMP,Openwire                           |
| `5445`  | HORNETQ,STOMP                                                   |
| `5672`  | AMQP                                                            |
| `1883`  | MQTT                                                            |
| `61613` | STOMP                                                           |

## 6. License

View [license information](http://www.apache.org/licenses/LICENSE-2.0) for the software contained in this image.

## 7. User Feedback

### 7.1 Issues

If you have any problems with or questions about this image, please contact us through a [GitHub issue](https://github.com/vromero/activemq-artemis-docker/issues).

### 7.2 Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub issue](https://github.com/vromero/activemq-artemis-docker/issues), especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.
