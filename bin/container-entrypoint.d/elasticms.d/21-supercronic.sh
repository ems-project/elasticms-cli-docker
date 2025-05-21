#!/usr/bin/env bash

OUTDIR="/app/etc/crontabs /app/etc/supervisor.d"
mkdir -p $OUTDIR

log "INFO" "| Configure Supercronic"

if [[ -f /app/etc/crontabs/elasticms ]]
then

  if rm /app/etc/crontabs/elasticms; then  
    apply-template /app/config/elasticms.crontab.tmpl /app/etc/crontabs/elasticms
  else
    log "WARN" "| Supercronic crontab file exists and will be used"
  fi

else

  log "INFO" "| Writing Supercronic crontab file"
  apply-template /app/config/elasticms.crontab.tmpl /app/etc/crontabs/elasticms

fi

if [[ -f /app/etc/supervisor.d/supercronic.ini ]]
then

  if rm /app/etc/supervisor.d/supercronic.ini; then  
    apply-template /app/config/supercronic.ini.tmpl /app/etc/supervisor.d/supercronic.ini
  else
    log "WARN" "| Supervisor config file exists and will be used"
  fi

else

  log "INFO" "| Writing Supervisor config file for Supercronic usage"
  apply-template /app/config/supercronic.ini.tmpl /app/etc/supervisor.d/supercronic.ini

fi

true
