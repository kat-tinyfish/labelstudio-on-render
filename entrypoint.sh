#!/bin/bash

echo "Injecting CSRF_TRUSTED_ORIGINS into Django settings..."

SETTINGS_FILE=/label-studio/label_studio/settings/base.py

if ! grep -q "CSRF_TRUSTED_ORIGINS" "$SETTINGS_FILE"; then
  echo "" >> "$SETTINGS_FILE"
  echo "import os" >> "$SETTINGS_FILE"
  echo "CSRF_TRUSTED_ORIGINS = os.environ.get('DJANGO_CSRF_TRUSTED_ORIGINS', '').split(',')" >> "$SETTINGS_FILE"
fi

# Use the PORT Render expects
PORT=${PORT:-8080}
echo "Starting Label Studio on port $PORT"

exec label-studio start --port "$PORT" --host 0.0.0.0 --no-browser
