#!/bin/bash

INITIAL=1
FILE=/data/etesyncdb.sqlite3

if [ -f "$FILE" ]; then
    INITIAL=0
fi

# Copy settings into ini file
chevron -d /data/options.json /etc/server/config.mustache > /etc/server/etesync-server.ini

echo "Start migration"
./manage.py migrate

echo "Migration done"

if [ $INITIAL == 1 ]; then
    GENERATEDPASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    echo
    echo
    echo
    echo "********************************"
    echo "Creating Admin with password '$GENERATEDPASSWORD'"
    echo "Make sure to save the password somewhere safe as it cannot be recoverd."
    echo "This password can be changed once the server is running."
    echo "********************************"
    echo
    echo
    echo
    ./manage.py shell -c "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@admin.com', '$GENERATEDPASSWORD')"
    GENERATEDPASSWORD=""
fi

bashio::config.require.ssl
if bashio::config.true 'ssl'; then
  # Setup ssl in nginx
  sed 's#%%portandmode%%#443 ssl#g' /etc/nginx/nginx.conf > /etc/nginx/nginx.conf

  CERTFILE=$(bashio::config 'certfile')
  KEYFILE=$(bashio::config 'keyfile')

  sed 's#%%certificatefile%%#${CERTFILE}#g' /etc/nginx/nginx.conf > /etc/nginx/nginx.conf
  sed 's#%%certificatekeyfile%%#${KEYFILE}#g' /etc/nginx/nginx.conf > /etc/nginx/nginx.conf
else
  # Setup http ports in nginx
  sed 's#%%portandmode%%#80 default#g' /etc/nginx/nginx.conf > /etc/nginx/nginx.conf
  sed "s#ssl_certificate /ssl/%%certificatefile%%##g" /etc/nginx/nginx.conf > /etc/nginx/nginx.conf
  sed "s#ssl_certificate_key /ssl/%%certificatekeyfile%%##g" /etc/nginx/nginx.conf > /etc/nginx/nginx.conf
fi

# Start supervisord
supervisord --nodaemon --configuration /etc/supervisord.conf