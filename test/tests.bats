#!/usr/bin/env bats
load "helpers/tests"
load "helpers/containers"
load "helpers/dataloaders"

load "lib/batslib"
load "lib/output"

export BATS_ELASTICMS_CLI_VERSION="${EMS_VERSION:-6.0.0}"
export BATS_TIKA_VERSION="${TIKA_VERSION:-2.9.2}"

export BATS_DOCKER_IMAGE_NAME="${DOCKER_IMAGE_NAME:-docker.io/elasticms/cli:rc}"

export BATS_CONTAINER_ENGINE="${CONTAINER_ENGINE:-podman}"
export BATS_CONTAINER_COMPOSE_ENGINE="${BATS_CONTAINER_ENGINE} compose"
export BATS_CONTAINER_NETWORK_NAME="${CONTAINER_NETWORK_NAME:-docker_default}"

#
# Containers configuration
#
export BATS_APP_TMP_VOLUME_NAME="app_tmp"
export BATS_APP_ETC_VOLUME_NAME="app_etc"
export BATS_APP_VAR_VOLUME_NAME="app_var"

@test "[$TEST_FILE] Check Docker external Volumes (local)" {

  BATS_CONTAINER_VOLUME_NAMES=("$BATS_APP_TMP_VOLUME_NAME")
  BATS_CONTAINER_VOLUME_NAMES+=("$BATS_APP_ETC_VOLUME_NAME")
  BATS_CONTAINER_VOLUME_NAMES+=("$BATS_APP_VAR_VOLUME_NAME")

  for BATS_CONTAINER_VOLUME_NAME in "${BATS_CONTAINER_VOLUME_NAMES[@]}"; do

    run ${BATS_CONTAINER_ENGINE} volume inspect ${BATS_CONTAINER_VOLUME_NAME}
  
    if [ "$status" -ne 0 ]; then

      run ${BATS_CONTAINER_ENGINE} volume create ${BATS_CONTAINER_VOLUME_NAME}
      [ "$status" -eq 0 ]
  
    fi

  done

}

@test "[$TEST_FILE] Test ElasticMS Client version command" {
  run ${BATS_CONTAINER_ENGINE} run --rm ${BATS_DOCKER_IMAGE_NAME} ems:version
  assert_output -l -r "^${BATS_ELASTICMS_CLI_VERSION}$"
}

@test "[$TEST_FILE] Test Tika App version command" {
  run ${BATS_CONTAINER_ENGINE} run --read-only --rm ${BATS_DOCKER_IMAGE_NAME} java -jar /app/bin/tika-app.jar --version
  assert_output -l -r "^Apache Tika ${BATS_TIKA_VERSION}$"
}

@test "[$TEST_FILE] Test ElasticMS Client version command via Cronjob" {
  BATS_ELASTICMS_CLI_COMMAND="ems:version --verbose"

  run ${BATS_CONTAINER_ENGINE} run --read-only --rm \
  -v $BATS_APP_TMP_VOLUME_NAME:/app/tmp \
  -v $BATS_APP_ETC_VOLUME_NAME:/app/etc \
  -v $BATS_APP_VAR_VOLUME_NAME:/app/var \
  ${BATS_DOCKER_IMAGE_NAME} cronjob ${BATS_ELASTICMS_CLI_COMMAND}
  assert_output -l -r "^${BATS_ELASTICMS_CLI_VERSION}$"

}

@test "[$TEST_FILE] Test ElasticMS Client version command via Crontab" {
  BATS_ELASTICMS_CLI_CROND_SCHEDULE="*/1 * * * *"
  BATS_ELASTICMS_CLI_COMMAND="ems:version --verbose"

  run ${BATS_CONTAINER_ENGINE} run --read-only -itd --rm --name ems-cron \
  -e "ELASTICMS_CLI_CROND_SCHEDULE=${BATS_ELASTICMS_CLI_CROND_SCHEDULE}" \
  -v $BATS_APP_TMP_VOLUME_NAME:/app/tmp \
  -v $BATS_APP_ETC_VOLUME_NAME:/app/etc \
  -v $BATS_APP_VAR_VOLUME_NAME:/app/var \
  ${BATS_DOCKER_IMAGE_NAME} crontab ${BATS_ELASTICMS_CLI_COMMAND}
  container_wait_for_log ems-cron 90 "time=\".*\" level=info msg=\"> ELASTICMS_COMMAND: ${BATS_ELASTICMS_CLI_COMMAND}\" channel=.* iteration=.* job.command=\"/app/bin/elasticms-job ${BATS_ELASTICMS_CLI_COMMAND}\" job.position=.* job.schedule=\".*\""
  container_wait_for_log ems-cron 90 "time=\".*\" level=info msg=${BATS_ELASTICMS_CLI_VERSION} channel=.* iteration=.* job.command=\"/app/bin/elasticms-job ${BATS_ELASTICMS_CLI_COMMAND}\" job.position=.* job.schedule=\".*\""

  run ${BATS_CONTAINER_ENGINE} stop ems-cron

}

@test "[$TEST_FILE] Test ElasticMS Client help on version command via Crontab" {
  export BATS_ELASTICMS_CLI_CROND_SCHEDULE="*/1 * * * *"
  export BATS_ELASTICMS_CLI_COMMAND="ems:version --verbose --help"

  run ${BATS_CONTAINER_ENGINE} run --read-only -itd --rm --name ems-cron \
  -e "ELASTICMS_CLI_CROND_SCHEDULE=${BATS_ELASTICMS_CLI_CROND_SCHEDULE}" \
  -e "DEBUG=true" \
  -v $BATS_APP_TMP_VOLUME_NAME:/app/tmp \
  -v $BATS_APP_ETC_VOLUME_NAME:/app/etc \
  -v $BATS_APP_VAR_VOLUME_NAME:/app/var \
  ${BATS_DOCKER_IMAGE_NAME} crontab ${BATS_ELASTICMS_CLI_COMMAND}
  container_wait_for_log ems-cron 90 "time=\".*\" level=info msg=\"> ELASTICMS_COMMAND: ${BATS_ELASTICMS_CLI_COMMAND}\" channel=.* iteration=.* job.command=\"/app/bin/elasticms-job ${BATS_ELASTICMS_CLI_COMMAND}\" job.position=.* job.schedule=\".*\""

  run ${BATS_CONTAINER_ENGINE} stop ems-cron

}

@test "[$TEST_FILE] Cleanup Docker external volumes (local)" {
  command docker volume rm ${BATS_APP_TMP_VOLUME_NAME}
  command docker volume rm ${BATS_APP_VAR_VOLUME_NAME}
  command docker volume rm ${BATS_APP_ETC_VOLUME_NAME}
}
