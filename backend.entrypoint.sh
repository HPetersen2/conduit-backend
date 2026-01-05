#!/bin/sh
set -e

python manage.py migrate
python manage.py collectstatic
exec gunicorn --bind 0.0.0.0:8000 --workers 3 conduit.wsgi:application