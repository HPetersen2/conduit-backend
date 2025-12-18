#!/bin/sh
set -e

python manage.py migrate
exec gunicorn --bind 0.0.0.0:8000 --workers 3 conduit.wsgi:application