#!/bin/bash
set -e

echo "Injecting CSRF_TRUSTED_ORIGINS into Django settings..."

SETTINGS_FILE=/label-studio/label_studio/settings/base.py

if ! grep -q "CSRF_TRUSTED_ORIGINS" "$SETTINGS_FILE"; then
  echo "" >> "$SETTINGS_FILE"
  echo "import os" >> "$SETTINGS_FILE"
  echo "CSRF_TRUSTED_ORIGINS = os.environ.get('DJANGO_CSRF_TRUSTED_ORIGINS', '').split(',')" >> "$SETTINGS_FILE"
fi

PORT=${PORT:-8080}
echo "Starting Label Studio on port $PORT"

# Start Label Studio in the background to initialize DB
label-studio start --host 0.0.0.0 --port "$PORT" --data-dir /data &
sleep 10

# Create admin user if it doesn't exist
label-studio user --username "$LS_ADMIN_USERNAME" --password "$LS_ADMIN_PASSWORD" --email "$LS_ADMIN_EMAIL" --data-dir /data || true

# Kill the background Label Studio process
pkill -f "label-studio start" || true
sleep 2

# Start Label Studio in the foreground
exec label-studio start --host 0.0.0.0 --port "$PORT" --data-dir /data
