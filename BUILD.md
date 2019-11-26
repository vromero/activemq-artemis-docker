# Building the ActiveMQ Artemis Docker Image

Depending on your platform the build process may differ slightly. Support for as many build platforms as possible is provided in a best effort basis.

If you consistently can reproduce a test failure, please search for it in the [issue tracker](https://github.com/vromero/activemq-artemis-docker/issues) or file a new issue.

## Prerequisites

To build the ActiveMQ Artemis Docker Image the following tools are necessary:

- Docker
- Make
- goss and dgoss
- shellcheck
- bats-core

## Supported Platforms

Only UN*X based operating systems are supported currently for building this image. 

## Building the image

To build all versions running all tests jus type

```bash
make
```

This will run the full build (with the exception of the deployment phase) for all versions presents in the filel `tags.csv`.

To just build *just one version* you can call `make` with `VERSION[-VARIANT]` where variant can be `-alpine` for an Alpine based image build or just nothing for a Debian based one, e.g:

```bash
make 2.6.0
```

```bash
make 2.6.0-alpine
```

It is also possible to just build the image without testing with `make build_2.8.0`, just testing: `make test_2.8.0`, running the image: `make run_2.8.0` or even run the image for a shell `make runsh_2.8.0`.

You can also override the artemis binary distribution url by passing a parameter containing a zip file containing the distribution.  ie.  `make BUILD_ARGS="--build-arg ACTIVEMQ_DISTRIBUTION_URL=https://repository.apache.org/content/repositories/releases/org/apache/activemq/apache-artemis/2.6.4/apache-artemis-2.8.0-bin.zip" 2.8.0`.   Note that you also need to pass in the version # as the first argument (ie 2.8.0)

