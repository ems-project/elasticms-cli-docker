#!/usr/bin/env bash

log "INFO" "| Configure Supervisor"

OUTDIR="/app/etc /app/var/run /app/var/log"
mkdir -p $OUTDIR

apply-template /app/config/supervisord.conf.tmpl /app/etc/supervisord.conf

true
