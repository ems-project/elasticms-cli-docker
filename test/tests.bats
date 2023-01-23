#!/usr/bin/env bats
load "helpers/tests"
load "helpers/docker"
load "helpers/dataloaders"

load "lib/batslib"
load "lib/output"

export BATS_ELASTICMS_CLIENT_VERSION="${ELASTICMS_CLIENT_VERSION:-5.1.2}"

export BATS_DOCKER_IMAGE_NAME="${DOCKER_IMAGE_NAME:-docker.io/elasticms/cli:rc}"

@test "[$TEST_FILE] Test ElasticMS Client version command" {
  run docker run --rm ${BATS_DOCKER_IMAGE_NAME} ems:version
  assert_output -l -r "^${BATS_ELASTICMS_CLIENT_VERSION}$"
}