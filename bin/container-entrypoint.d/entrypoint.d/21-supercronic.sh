#!/usr/bin/env bash

export ELASTICMS_CLI_SUPERCRONIC_JSON_LOGGING=${ELASTICMS_CLI_SUPERCRONIC_JSON_LOGGING:-false}
export ELASTICMS_CLI_SUPERCRONIC_OVERLAPPING=${ELASTICMS_CLI_SUPERCRONIC_OVERLAPPING:-false}
export ELASTICMS_CLI_SUPERCRONIC_PASSTHROUGH_LOGS=${ELASTICMS_CLI_SUPERCRONIC_PASSTHROUGH_LOGS:-false}
export ELASTICMS_CLI_SUPERCRONIC_PROMETHEUS_LISTEN_HOST=${ELASTICMS_CLI_SUPERCRONIC_PROMETHEUS_LISTEN_HOST:-}
export ELASTICMS_CLI_SUPERCRONIC_PROMETHEUS_LISTEN_PORT=${ELASTICMS_CLI_SUPERCRONIC_PROMETHEUS_LISTEN_PORT:-9746}
export ELASTICMS_CLI_SUPERCRONIC_QUIET=${ELASTICMS_CLI_SUPERCRONIC_QUIET:-false}
export ELASTICMS_CLI_SUPERCRONIC_SENTRY_DSN=${ELASTICMS_CLI_SUPERCRONIC_SENTRY_DSN:-""}
export ELASTICMS_CLI_SUPERCRONIC_TEST=${ELASTICMS_CLI_SUPERCRONIC_TEST:-false}

ELASTICMS_CLI_SUPERCRONIC_COMMAND_FLAGS_ARR=()

if [[ "${DEBUG}" == "true" ]] ; then
  ELASTICMS_CLI_SUPERCRONIC_COMMAND_FLAGS_ARR+=" -debug"
fi

if [[ "${ELASTICMS_CLI_SUPERCRONIC_JSON_LOGGING}" == "true" ]] ; then
  ELASTICMS_CLI_SUPERCRONIC_COMMAND_FLAGS_ARR+=" -json"
fi

if [[ "${ELASTICMS_CLI_SUPERCRONIC_OVERLAPPING}" == "true" ]] ; then
  ELASTICMS_CLI_SUPERCRONIC_COMMAND_FLAGS_ARR+=" -overlapping"
fi

if [[ "${ELASTICMS_CLI_SUPERCRONIC_PASSTHROUGH_LOGS}" == "true" ]] ; then
  ELASTICMS_CLI_SUPERCRONIC_COMMAND_FLAGS_ARR+=" -passthrough-logs"
fi

if [[ -n "${ELASTICMS_CLI_SUPERCRONIC_PROMETHEUS_LISTEN_HOST}" ]] ; then
  ELASTICMS_CLI_SUPERCRONIC_COMMAND_FLAGS_ARR+=" -prometheus-listen-address ${ELASTICMS_CLI_SUPERCRONIC_PROMETHEUS_LISTEN_HOST}:${ELASTICMS_CLI_SUPERCRONIC_PROMETHEUS_LISTEN_PORT}"
fi

if [[ "${ELASTICMS_CLI_SUPERCRONIC_QUIET}" == "true" ]] ; then
  ELASTICMS_CLI_SUPERCRONIC_COMMAND_FLAGS_ARR+=" -quiet"
fi

if [[ -n "${ELASTICMS_CLI_SUPERCRONIC_SENTRY_DSN}" ]] ; then
  ELASTICMS_CLI_SUPERCRONIC_COMMAND_FLAGS_ARR+=" -sentry-dsn ${ELASTICMS_CLI_SUPERCRONIC_SENTRY_DSN}"
fi

if [[ "${ELASTICMS_CLI_SUPERCRONIC_TEST}" == "true" ]] ; then
  ELASTICMS_CLI_SUPERCRONIC_COMMAND_FLAGS_ARR+=" -test"
fi

export ELASTICMS_CLI_SUPERCRONIC_COMMAND_FLAGS="${ELASTICMS_CLI_SUPERCRONIC_COMMAND_FLAGS_ARR[*]}"

export ELASTICMS_CLI_ENTRYPOINT_INITIALIZED="true"

true