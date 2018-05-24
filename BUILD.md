# Building the ActiveMQ Artemis Docker Image

Depending on your platform the build process may differ slightly. Support for as many build platforms as possible is provided in a best effort basis.

If you consistently can reproduce a test failure, please search for it in the [issue tracker](https://github.com/vromero/activemq-artemis-docker/issues) or file a new issue.

## Prerequisites

To build the ActiveMQ Artemis Docker Image the following tools are necessary:

- Docker
- Make
- goss and dgoss
- shellcheck

## Supported Platforms

Only UN*X based operating systems are supported currently for building this image. 

## Building the image

To build all versions running all tests jus type

```bash
make
```

This will run the full build (with the exception of the deployment phase) for all versions presents in the ALL_VERSIONS line in the Makefile, e.g:

```Makefile
ALL_VERSIONS=1.1.0 1.2.0 1.3.0 1.4.0 1.5.0 1.5.1 1.5.2 1.5.3 1.5.4 1.5.5 2.0.0 2.1.0 2.2.0 2.3.0 2.4.0 2.5.0 2.6.0
```

To just build *just one version* you can call `make` with `VERSION[-VARIANT]` where variant can be `-alpine` for an Alpine based image build or just nothing for a Debian based one, e.g:

```bash
make 2.6.0
```

```bash
make 2.6.0-alpine
```

It is also possible to just build the image without testing with `make build_2.6.0`, just testing: `make test_2.6.0`, running the image: `make run_2.6.0` or even run the image for a shell `make runsh_2.6.0`.

