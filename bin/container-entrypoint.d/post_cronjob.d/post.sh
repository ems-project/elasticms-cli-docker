#!/usr/bin/env bash
set -o pipefail

export ELASTICMS_CLI_JOB_ENDTIME=`date +%s`

rm -f ${ELASTICMS_CLI_LOG_TMP_FILE}

echo "--------------------------------------"
echo "Finished Job at $(date +"%Y-%m-%d %H:%M:%S") after $((ELASTICMS_CLI_JOB_ENDTIME-ELASTICMS_CLI_JOB_STARTTIME)) seconds"
echo "======================================"
