#!/bin/bash
set -e

# Start Label Studio in the background to initialize DB
label-studio start --host 0.0.0.0 --port 8080 --data-dir /data &
sleep 10

# Create admin user if it doesn't exist
label-studio user --username "$LS_ADMIN_USERNAME" --password "$LS_ADMIN_PASSWORD" --email "$LS_ADMIN_EMAIL" --data-dir /data || true

# Kill the background Label Studio process
pkill -f "label-studio start" || true
sleep 2

# Start Label Studio in the foreground
exec label-studio start --host 0.0.0.0 --port 8080 --data-dir /data
