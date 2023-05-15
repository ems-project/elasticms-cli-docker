# ElasticMS Client [![Docker Build](https://github.com/ems-project/elasticms-cli-docker/actions/workflows/docker-build.yml/badge.svg?branch=5.x)](https://github.com/ems-project/elasticms-cli-docker/actions/workflows/docker-build.yml)

This docker image is not intended to run containers permanently as a webserver or nodeJS server, it should be used to run single commands to execute tasks.  
Some schedulers like Kubernetes or Openshift give the possibility to run tasks at regular intervals like Cronjobs.  This image can be used in this context.  

## Prerequisite

You must install `bats`, `make`, `m4`.

# Build

```sh
make build[-dev|-all] ELASTICMS_CLI_VERSION=<ElasticMS CLI version you want to build> \
                      [ TIKA_VERSION=<Tika version you want to include> ] \
                      [ DOCKER_IMAGE_NAME=<ElasticMS Web Docker Image Name you want to build> ] \
```

## Example building __prd__ Docker image

```sh
make build ELASTICMS_CLI_VERSION=5.2.0 TIKA_VERSION=2.6.0
```

__Provide docker image__ : `docker.io/elasticms/cli:5.1.2-prd` with ElasticMS Client Version v5.2.0 and Tika App Version v2.6.0

## Example building __dev__ Docker image

```sh
make build-dev ELASTICMS_CLI_VERSION=5.1.2
```

__Provide docker image__ : `docker.io/elasticms/cli:5.1.2-dev`

# Test

```sh
make test[-dev|-all] ELASTICMS_CLI_VERSION=<ElasticMS CLI Version you want to test>
```

## Example testing of __prd__ builded docker image

```sh
make test ELASTICMS_CLI_VERSION=5.1.2
```

## Example testing of __dev__ builded docker image

```sh
make test-dev ELASTICMS_CLI_VERSION=5.1.2
```

# Releases

Releases are done via GitHub actions and uploaded on Docker Hub.

# Supported tags and respective Dockerfile links

- [`5.x.y`, `5.x`, `5`, `5.x.y-prd`, `5.x-prd`, `5-prd`, `5.x.y-dev`, `5.x-dev`, `5-dev`](Dockerfile)

# Image Variants

The elasticms/cli images come in many flavors, each designed for a specific use case.

## `docker.io/elasticms/cli:<version>[-prd]`  

This variant contains the [ElasticMS CLI tool](https://github.com/ems-project/elasticms-cli) installed in a Production PHP environment.  

## `docker.io/elasticms/cli:<version>-dev`

This variant contains the [ElasticMS CLI tool](https://github.com/ems-project/elasticms-cli) installed in a Development PHP environment.  

# Usage

## [elasticms-client](https://github.com/ems-project/elasticms-cli)

```
docker run -it --rm docker.io/elasticms/cli:<version> <elasticms-command>
```