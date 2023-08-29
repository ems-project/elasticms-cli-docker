#!/usr/bin/env bats
load "helpers/tests"
load "helpers/containers"
load "helpers/dataloaders"

load "lib/batslib"
load "lib/output"

export BATS_ELASTICMS_CLI_VERSION="${EMS_VERSION:-5.1.2}"
export BATS_TIKA_VERSION="${TIKA_VERSION:-2.7.0}"

export BATS_DOCKER_IMAGE_NAME="${DOCKER_IMAGE_NAME:-docker.io/elasticms/cli:rc}"

export BATS_CONTAINER_ENGINE="${CONTAINER_ENGINE:-podman}"
export BATS_CONTAINER_COMPOSE_ENGINE="${BATS_CONTAINER_ENGINE}-compose"
export BATS_CONTAINER_NETWORK_NAME="${CONTAINER_NETWORK_NAME:-docker_default}"

@test "[$TEST_FILE] Test ElasticMS Client version command" {
  run ${BATS_CONTAINER_ENGINE} run --rm ${BATS_DOCKER_IMAGE_NAME} ems:version
  assert_output -l -r "^${BATS_ELASTICMS_CLI_VERSION}$"
}

@test "[$TEST_FILE] Test Tika App version command" {
  run ${BATS_CONTAINER_ENGINE} run --rm ${BATS_DOCKER_IMAGE_NAME} java -jar /opt/bin/tika-app.jar --version
  assert_output -l -r "^Apache Tika ${BATS_TIKA_VERSION}$"
}

@test "[$TEST_FILE] Test ElasticMS Client version command via Cron" {
  BATS_ELASTICMS_CLI_CROND_SCHEDULE="*/1 * * * *"
  BATS_ELASTICMS_CLI_COMMAND="ems:version --verbose"

  run ${BATS_CONTAINER_ENGINE} run -itd --rm --name ems-cron -e "ELASTICMS_CLI_CROND_SCHEDULE=${BATS_ELASTICMS_CLI_CROND_SCHEDULE}" ${BATS_DOCKER_IMAGE_NAME} cron ${BATS_ELASTICMS_CLI_COMMAND}
  container_wait_for_log ems-cron 90 "time=\".*\" level=info msg=\"> ELASTICMS_COMMAND: ${BATS_ELASTICMS_CLI_COMMAND}\" channel=.* iteration=.* job.command=\"/usr/local/bin/elasticms-cronjob ${BATS_ELASTICMS_CLI_COMMAND}\" job.position=.* job.schedule=\".*\""
  container_wait_for_log ems-cron 90 "time=\".*\" level=info msg=${BATS_ELASTICMS_CLI_VERSION} channel=.* iteration=.* job.command=\"/usr/local/bin/elasticms-cronjob ${BATS_ELASTICMS_CLI_COMMAND}\" job.position=.* job.schedule=\".*\""

  run ${BATS_CONTAINER_ENGINE} stop ems-cron

}

@test "[$TEST_FILE] Test ElasticMS Client help on version command via Cron" {
  BATS_ELASTICMS_CLI_CROND_SCHEDULE="*/1 * * * *"
  BATS_ELASTICMS_CLI_COMMAND="ems:version --verbose --help"

  run ${BATS_CONTAINER_ENGINE} run -itd --rm --name ems-cron -e "ELASTICMS_CLI_CROND_SCHEDULE=${BATS_ELASTICMS_CLI_CROND_SCHEDULE}" ${BATS_DOCKER_IMAGE_NAME} cron ${BATS_ELASTICMS_CLI_COMMAND}
  container_wait_for_log ems-cron 90 "time=\".*\" level=info msg=\"> ELASTICMS_COMMAND: ${BATS_ELASTICMS_CLI_COMMAND}\" channel=.* iteration=.* job.command=\"/usr/local/bin/elasticms-cronjob ${BATS_ELASTICMS_CLI_COMMAND}\" job.position=.* job.schedule=\".*\""

  run ${BATS_CONTAINER_ENGINE} stop ems-cron

}