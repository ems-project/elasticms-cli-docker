#!/usr/bin/env bash

echo "    - Configure Supervisord ..."

OUTDIR="/app/etc"
mkdir -p $OUTDIR

apply-template /app/config/supervisord.conf.tmpl /app/etc/supervisord.conf

true
