#!/bin/bash

echo "Start migration"
./manage.py migrate

echo "Migration done"

echo "Createing Admin"

.manage.py createsuperuser

echo "Starting DEBUG Server"
echo "DO NOT USE FOR PRODUCTION STUFF"

./manage.py runserver 0.0.0.0:8800