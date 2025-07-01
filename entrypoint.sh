#!/bin/bash
set -e

DB_PATH=/data/label_studio.sqlite3

# Remove any existing DB for a truly blank start (CAUTION: this deletes all data on every deploy!)
rm -f "$DB_PATH"

# Start Label Studio in the background to initialize DB
label-studio start --host 0.0.0.0 --port 8080 --data-dir /data &
sleep 10
pkill -f "label-studio start" || true
sleep 2

# Create admin user
label-studio user --username "$LS_ADMIN_USERNAME" --password "$LS_ADMIN_PASSWORD" --email "$LS_ADMIN_EMAIL" --data-dir /data || true

echo "==== ENVIRONMENT VARIABLES ===="
env
echo "==============================="

# Start Label Studio in the foreground
exec label-studio start --host 0.0.0.0 --port 8080 --data-dir /data
