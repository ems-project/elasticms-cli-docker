#!/usr/bin/env bash

echo "    - Configure Supervisord ..."

gomplate \
  -f /usr/local/etc/templates/supervisord.conf.tmpl \
  -o /etc/supervisord/supervisord.conf

true
