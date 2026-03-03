#!/bin/sh
set -e

echo "Warte auf PostgreSQL auf $DATABASE_HOST:$DATABASE_PORT..."

# -q für "quiet" (keine Ausgabe außer Fehlern)
# Die Schleife läuft, solange pg_isready *nicht* erfolgreich ist (Exit-Code != 0)
while ! pg_isready -h "$DATABASE_HOST" -p "$DATABASE_PORT" -q; do
  echo "PostgreSQL ist nicht erreichbar - schlafe 1 Sekunde"
  sleep 1
done

echo "PostgreSQL ist bereit - fahre fort..."

python manage.py collectstatic --noinput
python manage.py makemigrations
python manage.py migrate
exec gunicorn --bind 0.0.0.0:8000 --workers 3 conduit.wsgi:application