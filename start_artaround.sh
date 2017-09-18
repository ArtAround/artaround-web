#!/bin/bash

echo "Rebooting application..."

sleep 5

# Remove the server pid if it exists
[ -e tmp/pids/server.pid ] && rm tmp/pids/server.pid

rails server -p 3000 -b '0.0.0.0'
