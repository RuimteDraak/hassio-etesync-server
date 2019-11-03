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
    echo "Createing Admin"
    ./manage.py shell -c "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'adminpass')"
fi

# Start supervisord
supervisord --nodaemon --configuration /etc/supervisord.conf