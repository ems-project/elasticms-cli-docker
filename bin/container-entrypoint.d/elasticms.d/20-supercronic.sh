#!/usr/bin/env bash

if [[ ! -f /etc/crontabs/elasticms ]]
then
  echo "    - Writing Supercronic crontab file..."
  gomplate \
    -f /usr/local/etc/templates/elasticms.crontab.tmpl \
    -o /etc/crontabs/elasticms
fi

echo "    - Configure Supervisord for Supercronic usage..."

gomplate \
  -f /usr/local/etc/templates/supercronic.ini.tmpl \
  -o /etc/supervisord/supervisord.d/supercronic.ini

true
