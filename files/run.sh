#!/bin/bash

INITIAL=1
FILE=/data/etesync/etesyncdb.sqlite3

mkdir -p /data/etesync

if [ -f "$FILE" ]; then
    INITIAL=0
fi

echo "Start migration"
./manage.py migrate

echo "Migration done"

if [ $INITIAL == 1 ]; then
    echo "Createing Admin"
    ./manage.py shell -c "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'adminpass')"
fi

# Start supervisord
supervisord --nodaemon --configuration /etc/supervisord.conf