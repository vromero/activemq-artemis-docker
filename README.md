![latest 2.16.0](https://img.shields.io/badge/latest-2.16.0-blue.svg?style=flat) ![License MIT](https://img.shields.io/badge/license-APACHE-blue.svg) [![Build Status](https://travis-ci.org/vromero/activemq-artemis-docker.svg?branch=master)](https://travis-ci.org/vromero/activemq-artemis-docker) [![](https://img.shields.io/docker/stars/vromero/activemq-artemis.svg)](https://hub.docker.com/r/vromero/activemq-artemis 'DockerHub') [![](https://img.shields.io/docker/pulls/vromero/activemq-artemis.svg)](https://hub.docker.com/r/vromero/activemq-artemis 'DockerHub') [![Say Thanks!](https://img.shields.io/badge/Say%20Thanks-!-1EAEDB.svg)](https://saythanks.io/to/vromero)

## THIS PROJECT IS ARCHIVED 

It has been quite a ride but after a few years, with multiple initiatives going on around Artemis and Docker both from Redhat and from Apache, I've decided that its time to let these project take the spot the community around this project and I have been occuping till now.

Of course the project will remain read-only and you should feel free to fork but I won't be maintaining anymore.

## 1. What is ActiveMQ Artemis?

[Apache ActiveMQ Artemis](https://activemq.apache.org/artemis) is an open source project to build a multi-protocol, embeddable, very high performance, clustered, asynchronous messaging system. Apache ActiveMQ Artemis is an example of Message Oriented Middleware (MoM).

![logo](https://activemq.apache.org/assets/img/activemq_logo_black_small.png)

## 2. Tags and `Dockerfile` links

| Debian Based                                                                                 | Alpine Based                                                                                               |
|--------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| [`latest`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile) | [`latest-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine) |
| [`2.16.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.16.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.15.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.15.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.14.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.14.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.13.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.13.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.12.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.12.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.11.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.11.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.10.1`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.10.1-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.10.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.10.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.9.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.9.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.8.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.8.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.7.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.7.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.6.4`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.6.4-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.6.3`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.6.3-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.6.2`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.6.2-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.6.1`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.6.1-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.6.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.6.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.5.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.5.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.4.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.4.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.3.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.3.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.2.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.2.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.1.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.1.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`2.0.0`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`2.0.0-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| [`1.5.6`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)  | [`1.5.6-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)  |
| ~~[`1.5.5`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile)~~  | ~~[`1.5.5-alpine`](https://raw.githubusercontent.com/vromero/activemq-artemis-docker/master/src/Dockerfile.alpine)~~  |
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

The ActiveMQ Artemis images come in two flavors, both equally supported :

- **Debian based**: the default one.
- **Alpine based**: much lighter.

All versions of ActiveMQ Artemis are provided for the time being but versions previous to 1.5.5 shall be considered deprecated and could be removed at any time.

This image shall not be considered production ready as is. If you plan to use this image in a production environment, fork the image in order to maintain stability as
the build is [reproducible](https://reproducible-builds.org/) in a best effort basis. Then at each rebase, make sure you tests the changes you are importing.

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

In rare ocassions you might find the need of running ActiveMQ Artemis without security. This
is described in section *Disabling security*.

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

### 5.4 Critical Analysis

Since 2.3.0 ActiveMQ Artemis can monitor *Queue delivery (add to the queue)*, *Journal storage* and *Paging operations* timings for anomalies in case there are IO errors or Memory issues (describe in detail [here](https://activemq.apache.org/components/artemis/documentation/latest/critical-analysis.html)).

The following properties can configure the critical analysis:

| Value                            | Description                                                                       |
|----------------------------------|-----------------------------------------------------------------------------------|
|`CRITICAL_ANALYZER`               | Enable or disable the critical analysis (default true or false)                   |
|`CRITICAL_ANALYZER_TIMEOUT`       | Timeout used to do the critical analysis (default 120000 milliseconds)            |
|`CRITICAL_ANALYZER_CHECK_PERIOD`  | Time used to check the response times (default half of critical-analyzer-timeout) |
|`CRITICAL_ANALYZER_POLICY`        | Should the server log, be halted or shutdown upon failures (default HALT or LOG)  |

### 5.5 Enabling JMX

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

### 5.6 Using JSON Output

It can be oftentimes preferrable to have the log output structured in a parseable format. 
This image supports the usage of `org.jboss.logmanager.formatters.JsonFormatter` to format
the output. To enable it `LOG_FORMATTER=JSON` can be passed as environment variable.

```console
docker run -it --rm \
  -e LOG_FORMATTER=JSON \
  vromero/activemq-artemis
```
When used, the output will look similar to the following listing:

```console
     _        _               _
    / \  ____| |_  ___ __  __(_) _____
   / _ \|  _ \ __|/ _ \  \/  | |/  __/
  / ___ \ | \/ |_/  __/ |\/| | |\___ \
 /_/   \_\|   \__\____|_|  |_|_|/___ /
 Apache ActiveMQ Artemis 2.x.x

{"timestamp":"2020-04-25T09:43:17.222Z","sequence":0,"loggerClassName":"org.apache.activemq.artemis.integration.bootstrap.ActiveMQBootstrapLogger_$logger","loggerName":"org.apache.activemq.artemis.integration.bootstrap","level":"INFO","message":"AMQ101000: Starting ActiveMQ Artemis Server","threadName":"main","threadId":1,"mdc":{},"ndc":"","hostName":"354e0e2e67cb","processName":"Artemis","processId":78}
{"timestamp":"2020-04-25T09:43:17.408Z","sequence":1,"loggerClassName":"org.apache.activemq.artemis.core.server.ActiveMQServerLogger_$logger","loggerName":"org.apache.activemq.artemis.core.server","level":"INFO","message":"AMQ221000: live Message Broker is starting with configuration Broker Configuration (clustered=false,journalDirectory=data/journal,bindingsDirectory=data/bindings,largeMessagesDirectory=data/large-messages,pagingDirectory=data/paging)","threadName":"main","threadId":1,"mdc":{},"ndc":"","hostName":"354e0e2e67cb","processName":"Artemis","processId":78}
{"timestamp":"2020-04-25T09:43:17.648Z","sequence":2,"loggerClassName":"org.apache.activemq.artemis.core.server.ActiveMQServerLogger_$logger","loggerName":"org.apache.activemq.artemis.core.server","level":"INFO","message":"AMQ221012: Using AIO Journal","threadName":"main","threadId":1,"mdc":{},"ndc":"","hostName":"354e0e2e67cb","processName":"Artemis","processId":78}
```

### 5.7 Prometheus metrics

When using this image in a orchestrated environmnet like in Kubernetes. It is often useful to have metrics endpoints compatible
with prometheus to ease monitoring.

This image can export such metrics in port `9404` thanks to the integration with the Prometheus [JMX exporter](https://github.com/prometheus/jmx_exporter). In order to enable it the environmnet variable `ENABLE_JMX_EXPORTER` should
be present, it will also inderectly enable JMX as if `ENABLE_JMX` was set.

To see what is exported just:

```console
docker run -it --rm \
  -p9404:9404 \
  -e ENABLE_JMX_EXPORTER=true \
  vromero/activemq-artemis
```

And then in a different terminal run:

```console
curl http://127.0.0.1:9404
```

To obtain the following and more:

```
# HELP artemis_disk_scan_period How often to check for disk space usage, in milliseconds (org.apache.activemq.artemis<broker="0.0.0.0"><>DiskScanPeriod)
# TYPE artemis_disk_scan_period counter
artemis_disk_scan_period 5000.0
# HELP artemis_durable_delivering_count number of durable messages that this queue is currently delivering to its consumers (org.apache.activemq.artemis<broker="0.0.0.0", component=addresses, address="DLQ", subcomponent=queues, routing-type="anycast", queue="DLQ"><>DurableDeliveringCount)
# TYPE artemis_durable_delivering_count counter
artemis_durable_delivering_count{queue="DLQ",address="DLQ",} 0.0
artemis_durable_delivering_count{queue="ExpiryQueue",address="ExpiryQueue",} 0.0
# HELP artemis_journal_min_files Number of journal files to pre-create (org.apache.activemq.artemis<broker="0.0.0.0"><>JournalMinFiles)
# TYPE artemis_journal_min_files counter
artemis_journal_min_files 2.0
# HELP artemis_message_expiry_thread_priority Priority of the thread used to scan message expiration (org.apache.activemq.artemis<broker="0.0.0.0"><>MessageExpiryThreadPriority)
# TYPE artemis_message_expiry_thread_priority counter
artemis_message_expiry_thread_priority 3.0
# HELP artemis_messages_killed number of messages removed from this queue since it was created due to exceeding the max delivery attempts (org.apache.activemq.artemis<broker="0.0.0.0", component=addresses, address="DLQ", subcomponent=queues, routing-type="anycast", queue="DLQ"><>MessagesKilled)
# TYPE artemis_messages_killed counter
artemis_messages_killed{queue="DLQ",address="DLQ",} 0.0
artemis_messages_killed{queue="ExpiryQueue",address="ExpiryQueue",} 0.0
# HELP artemis_address_memory_usage_percentage Memory used by all the addresses on broker as a percentage of global maximum limit (org.apache.activemq.artemis<broker="0.0.0.0"><>AddressMemoryUsagePercentage)
# TYPE artemis_address_memory_usage_percentage counter
artemis_address_memory_usage_percentage 0.0
# HELP artemis_journal_sync_non_transactional Whether the journal is synchronized when receiving non-transactional datar (org.apache.activemq.artemis<broker="0.0.0.0"><>JournalSyncNonTransactional)
# TYPE artemis_journal_sync_non_transactional counter
artemis_journal_sync_non_transactional 1.0
# HELP artemis_journal_buffer_size Size of the internal buffer on the journal (org.apache.activemq.artemis<broker="0.0.0.0"><>JournalBufferSize)
# TYPE artemis_journal_buffer_size counter
artemis_journal_buffer_size 501760.0
# HELP artemis_journal_max_io Maximum number of write requests that can be in the AIO queue at any given time (org.apache.activemq.artemis<broker="0.0.0.0"><>JournalMaxIO)
# TYPE artemis_journal_max_io counter
artemis_journal_max_io 4096.0
```

In case you need more control over the metrics that are exported, you can mount a [jmx-exporter](https://github.com/prometheus/jmx_exporter)
configuration file in `/opt/jmx-exporter/etc-override` with the file name `jmx-exporter-config.yaml`.

### 5.8 Settings the console's allow origin

ActiveMQ Artemis console uses Jolokia. In the default vanilla non-docker installation Jolokia does set a CORS header to
allow only localhost. In the docker image this create problems as things are rarely accesed as localhost.

Therefore the docker image does set the CORS header to `*` by default. However there is a mechanism to narrow it
down to whatever value is best suited to you for improved security through the environmnet property: `JOLOKIA_ALLOW_ORIGIN`.

```console
docker run -it --rm \
  -e JOLOKIA_ALLOW_ORIGIN=192.168.1.1 \
  vromero/activemq-artemis
```

### 5.9 Overriding parts of the configuration

ActiveMQ Artemis support disabling the security using the element `<security-enabled>false</security-enabled>`
as described in the official [documentation](https://activemq.apache.org/artemis/docs/latest/security.html).
This docker image makes it simple to set that element using the environment property: `DISABLE_SECURITY`:

```console
docker run -it --rm \
  -e DISABLE_SECURITY=true \
  vromero/activemq-artemis
```

Please keep in mind no production system, possible no environment at all, should ever disable security.
Make sure you read the falacy number one of the [falacies of the distributed computing](https://en.wikipedia.org/wiki/Fallacies_of_distributed_computing) before disabling the security.

### 5.10 Using external configuration files

It is possible to mount a whole artemis `etc` directory in this image in the volume `/var/lib/artemis/etc`.
Be careful as this might be an overkill for many situations where only small tweaks are necessary.  

When using this technique be aware that the configuration files of Artemis might change from version to version.
Generally speaking, when in need to configure Artemis beyond what it is offered by this image using environment
variables, it is recommended to use the partial override mechanism described in the next section.

### 5.11 Overriding parts of the configuration

The default ActiveMQ Artemis configuration can be partially modified, instead of completely replaced as in the previous section, using three mechanisms. Merge snippets, XSLT tranformations and entrypoint overrides.

**Merging snippets**

Multiple files with snippets of configuration can be dropped in the `/var/lib/artemis/etc-override` volume. Those configuration files must be named following the name convention `broker-{{num}}.xml` where `num` is a numeric representation of the snippet.
The configuration files will be *merged* with the default configuration. An alphabetical precedence of the file names will be considered for the merge and in case of collision the latest change will be treated as final.

For instance lets say that you want to add a diverts section, you could have a local directory, lets say `/var/artemis-data/etc-override`
where you could place a `broker-00.xml` file that looks like the following listing:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>

<configuration xmlns="urn:activemq" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:activemq /schema/artemis-configuration.xsd">
   <!-- from 1.0.0 to 1.5.5 the following line should be : <core xmlns="urn:activemq:core"> -->
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
- `2.0.0` onwards: `<core xmlns="urn:activemq:core" xsi:schemaLocation="urn:activemq:core ">`

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

**Entrypoint Overrides**

Multiple shell scripts can be dropped in the `/var/lib/artemis/etc-override` volume. Those shell files must be named following the name convention `entrypoint-{{num}}.sh` where `num` is a numeric representation of the snippet.
The shell scripts will be *executed* in alphabetical precedence of the file names on startup of the docker container.   

A typical use case for using entrypoint overrides would be if you want to make a minor modification to a file which cannot be overriden using the 2 methods above and you do not want to expose the etc volume.


If you would like to see the final result of your transformations, execute the following:

```
docker run -it --rm \
  -v /var/artemis-data/override:/var/lib/artemis/etc-override \
  vromero/activemq-artemis \
  cat ../etc/broker.xml
```

### 5.12 Broker Config

ActiveMQ allows you to override key configuration values using [System properties](https://activemq.apache.org/artemis/docs/latest/configuration-index.html#System-properties).
This docker image has built in support to set these values by passing environment variables prefixed with BROKER_CONFIG to the docker image.  

Below is an example which overrides the global-max-size and disk-scan-period values
```
docker run -it --rm   -p 8161:8161 \
    -e BROKER_CONFIG_GLOBAL_MAX_SIZE=50000 \
    -e BROKER_CONFIG_DISK_SCAN_PERIOD=6000 \
    vromero/activemq-artemis
```

### 5.13 Environment Variables

Additionally, the following environment variables are supported

| Env Var         | Default          | Description                                                       |
|---------------- |----------------- |-------------------------------------------------------------------|
|JAVA_OPTS        |                  |Will pass additional java options to the artemis runtime           |

### 5.14 Mount points

| Mount point                      | Description                                                              |
|--------------------------------- |--------------------------------------------------------------------------|
|`/var/lib/artemis/data`           | Holds the data files used for storing persistent messages                |
|`/var/lib/artemis/etc`            | Holds the instance configuration files                                   |
|`/var/lib/artemis/etc-override`   | Holds the instance configuration files                                   |
|`/var/lib/artemis/lock`           | Holds the command line locks (typically not useful to mount)             |
|`/opt/jmx-exporter/etc-override`  | Holds the configuration file for jmx-exporter `jmx-exporter-config.yaml` |

### 5.15 Exposed ports

| Port    | Description                                                     |
|-------- |-----------------------------------------------------------------|
| `8161`  | Web Server                                                      |
| `9404`  | JMX Exporter                                                    |
| `61616` | Core,MQTT,AMQP,HORNETQ,STOMP,Openwire                           |
| `5445`  | HORNETQ,STOMP                                                   |
| `5672`  | AMQP                                                            |
| `1883`  | MQTT                                                            |
| `61613` | STOMP                                                           |

## 6. Running in orchestrators

At the moment only docker is directly supported for this image. However there is an attempt to create
a helm chart for Kubernetes and some configuration tuning for OpenShift.

### 6.1 Running in Kubernetes

ActiveMQ Artemis can leverage [JGroups](http://www.jgroups.org/) to discover the members of the cluster. And JGroups
can be extended with a plugin called [jgroups-kubernetes](https://github.com/jgroups-extras/jgroups-kubernetes/tree/0.9.3)
that allows JGroups to discover using Kubernetes. Both KUBE_PING (via Kubernetes API) and DNS_PING (using the SRV records of a
[Kubernetes service](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#srv-records)) building blocks are
included to facilitate initial membership discovery.

[jgroups-kubernetes](https://github.com/jgroups-extras/jgroups-kubernetes/tree/0.9.3) version `0.9.3` is included in the
classpath of this image, however everything about the configuration of jgroups and jgroups-kubernetes is left to the user.

If you rather prefer a easier solution to run a cluster of ActiveMQ Artemis nodes, there is an attempt to create a Helm chart
by the same author of this image. It can be found [here](https://github.com/vromero/activemq-artemis-helm). It
does leverage `jgroups-kubernetes` in a transparent way.

### 6.2 OpenShift

OpenShift has diverted a bit from Kubernetes (e.g: automounts empty volumes in all declared volumes without
the user asking for it at all) and Docker (e.g: runs on an random user).

The biggest problem to run this image is the automount of empty directories because it empties the `etc` directory.
In order to restore it the environment variable `RESTORE_CONFIGURATION` has been created. It can be used as follows:

```bash
oc new-app --name=artemis vromero/activemq-artemis -e RESTORE_CONFIGURATION=true
```

## 7. License

View [license information](http://www.apache.org/licenses/LICENSE-2.0) for the software contained in this image.

## 8. User Feedback

### 8.1 Issues

If you have any problems with or questions about this image, please contact us through a [GitHub issue](https://github.com/vromero/activemq-artemis-docker/issues).

### 8.2 Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub issue](https://github.com/vromero/activemq-artemis-docker/issues), especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.
