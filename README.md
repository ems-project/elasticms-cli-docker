# ElasticMS Client [![Docker Build](https://github.com/ems-project/elasticms-cli-docker/actions/workflows/docker-build.yml/badge.svg)](https://github.com/ems-project/elasticms-cli-docker/actions/workflows/docker-build.yml)

This docker image is not intended to run containers permanently as a webserver or nodeJS server, it should be used to run single commands to execute tasks.  
Some schedulers like Kubernetes or Openshift give the possibility to run tasks at regular intervals like Cronjobs.  This image can be used in this context.  

# Build

```
set -a
source .build.env
set +a

docker build --build-arg VERSION_ARG=${ELASTICMS_CLIENT_VERSION} \
             --build-arg RELEASE_ARG=snapshot \
             --build-arg BUILD_DATE_ARG="" \
             --build-arg VCS_REF_ARG="" \
             -t ${DOCKER_IMAGE_NAME}:latest .
```

# Test

```
set -a
source .build.env
set +a

bats test/tests.bats
```

# Usage

## [elasticms-client](https://github.com/ems-project/elasticms-cli)

```
docker run -it --rm docker.io/elasticms/cli:latest elasticms <command>
```