#!/bin/bash

echo "Start migration"
./manage.py migrate

echo "Migration done"

echo "Createing Admin"

./manage.py shell -c "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'adminpass')"

echo "Starting DEBUG Server"
echo "DO NOT USE FOR PRODUCTION STUFF"

./manage.py runserver 0.0.0.0:8800