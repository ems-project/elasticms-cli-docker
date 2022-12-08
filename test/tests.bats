#!/usr/bin/env bats
load "helpers/tests"
load "helpers/docker"
load "helpers/dataloaders"

load "lib/batslib"
load "lib/output"

export BATS_DOCKER_IMAGE_NAME="${DOCKER_IMAGE_NAME:-docker.io/elasticms/cli:rc}"

@test "[$TEST_FILE] Running ElasticMS Client test command" {
  run docker run --rm ${BATS_DOCKER_IMAGE_NAME} elasticms ems:status
  assert_output -l -r ".*[OK].*"
}