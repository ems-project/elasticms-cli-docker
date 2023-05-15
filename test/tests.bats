#!/usr/bin/env bats
load "helpers/tests"
load "helpers/docker"
load "helpers/dataloaders"

load "lib/batslib"
load "lib/output"

export BATS_ELASTICMS_CLI_VERSION="${ELASTICMS_CLI_VERSION:-5.1.2}"
export BATS_TIKA_VERSION="${TIKA_VERSION:-2.7.0}"

export BATS_DOCKER_IMAGE_NAME="${DOCKER_IMAGE_NAME:-docker.io/elasticms/cli:rc}"

@test "[$TEST_FILE] Test ElasticMS Client version command" {
  run docker run --rm ${BATS_DOCKER_IMAGE_NAME} ems:version
  assert_output -l -r "^${BATS_ELASTICMS_CLI_VERSION}$"
}

@test "[$TEST_FILE] Test Tika App version command" {
  run docker run --rm ${BATS_DOCKER_IMAGE_NAME} java -jar /opt/bin/tika-app.jar --version
  assert_output -l -r "^Apache Tika ${BATS_TIKA_VERSION}$"
}
