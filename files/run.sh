#!/bin/bash

INITIAL=1
FILE=/data/db.sqlite3
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

echo "Starting DEBUG Server"
echo "DO NOT USE FOR PRODUCTION STUFF"

./manage.py runserver 0.0.0.0:8800