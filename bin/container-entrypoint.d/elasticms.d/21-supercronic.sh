#!/usr/bin/env bash

OUTDIR="/app/etc/crontabs /app/etc/supervisor.d"
mkdir -p $OUTDIR

echo "    - Writing Supercronic crontab file..."

if [[ -f /app/etc/crontabs/elasticms ]]
then

  if rm /app/etc/crontabs/elasticms; then  
    apply-template /app/config/elasticms.crontab.tmpl /app/etc/crontabs/elasticms
  else
    echo "    - Supercronic crontab file exists and will be used ..."
  fi

else

  apply-template /app/config/elasticms.crontab.tmpl /app/etc/crontabs/elasticms

fi

echo "    - Configure Supervisord for Supercronic usage..."

if [[ -f /app/etc/supervisor.d/supercronic.ini ]]
then

  if rm /app/etc/supervisor.d/supercronic.ini; then  
    apply-template /app/config/supercronic.ini.tmpl /app/etc/supervisor.d/supercronic.ini
  else
    echo "    - Supervisord config file exists and will be used ..."
  fi

else

  apply-template /app/config/supercronic.ini.tmpl /app/etc/supervisor.d/supercronic.ini

fi

true
