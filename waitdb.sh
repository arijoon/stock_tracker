#!/bin/sh

while ! pg_isready -q -h $PGHOST -p $PGPORT -U $PGUSER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

app=/opt/app/bin/${APP_NAME} 

# Create database if it doesn't exist.
if [[ -z `psql -Atqc "\\list $PGDATABASE"` ]]; then
  echo "Database $PGDATABASE does not exist. Creating..."
  
  echo "Database $PGDATABASE created."
fi

exec $app eval StockTracker.Release.migrate

exec $app start