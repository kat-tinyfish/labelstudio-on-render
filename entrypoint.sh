#!/bin/bash
set -e

DB_PATH=/data/label_studio.sqlite3

# Start Label Studio in the background to initialize DB if it doesn't exist
if [ ! -f "$DB_PATH" ]; then
  echo "Initializing Label Studio database..."
  label-studio start --host 0.0.0.0 --port 8080 --data-dir /data &
  sleep 10
  pkill -f "label-studio start" || true
  sleep 2
fi

# Create admin user if it doesn't exist
label-studio user --username "$LS_ADMIN_USERNAME" --password "$LS_ADMIN_PASSWORD" --email "$LS_ADMIN_EMAIL" --data-dir /data || true

# Start Label Studio in the foreground
exec label-studio start --host 0.0.0.0 --port 8080 --data-dir /data
