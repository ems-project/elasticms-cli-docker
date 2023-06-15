#!/usr/bin/env bash
set -o pipefail

source "${ELASTICMS_CLI_PRE_CRONJOB_PATH}/lib/helper.bash"

export ELASTICMS_CLI_JOB_STARTTIME=`date +%s`

echo "======================================"
echo "Starting Job at $(date +"%Y-%m-%d %H:%M:%S")"
echo "--------------------------------------"