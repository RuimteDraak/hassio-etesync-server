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

# Start supervisord
supervisord --nodaemon --configuration /etc/supervisord.conf