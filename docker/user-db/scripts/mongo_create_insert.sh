##!/usr/bin/env bash
#
#SCRIPT_DIR=$(dirname "$0")
#
#mongod --fork --logpath /var/log/mongodb.log --dbpath /data/db/
#
#FILES=$SCRIPT_DIR/*-create.js
#for f in $FILES; do mongo localhost:27017/users $f; done
#
#FILES=$SCRIPT_DIR/*-insert.js
#for f in $FILES; do mongo localhost:27017/users $f; done


##!/usr/bin/env bash
#
#SCRIPT_DIR=$(dirname "$0")
#
## Start MongoDB in the background
#mongod --fork --logpath /var/log/mongodb.log --dbpath /data/db/  --bind_ip 127.0.0.1
#
## Wait for MongoDB to be ready
##until mongo --eval "print(\"waited for connection\")" 127.0.0.1:27017; do
##    echo "Waiting for MongoDB to start..."
##    sleep 2
##done
#
## Run your MongoDB scripts
#FILES=$SCRIPT_DIR/*-create.js
#for f in $FILES; do mongo localhost:27017/users $f; done
#
#FILES=$SCRIPT_DIR/*-insert.js
#for f in $FILES; do mongo localhost:27017/users $f; done

#!/bin/bash

SCRIPT_DIR=$(dirname "$0")
MAX_RETRIES=10  # Maximum number of retries (adjustable)
RETRY_INTERVAL=2  # Time (in seconds) between retries

# Start MongoDB in the background (using the correct dbpath)
mongod --fork --logpath /var/log/mongodb.log --dbpath /data/db-users --bind_ip 127.0.0.1

# Function to check if MongoDB is running
check_mongo_running() {
  netstat -tuln | grep -q '27017'
}

# Function to check if MongoDB is responsive
check_mongo_responsive() {
  mongo --eval "db.stats()" >/dev/null 2>&1
}

# Wait for MongoDB to bind to the port (27017)
echo "Waiting for MongoDB to start..."
for ((i=1; i<=MAX_RETRIES; i++)); do
  if check_mongo_running; then
    echo "MongoDB service is up and running."
    break
  fi
  if [ "$i" -eq "$MAX_RETRIES" ]; then
    echo "MongoDB failed to start after $MAX_RETRIES attempts. Exiting..."
    exit 1
  fi
  echo "MongoDB is not running yet. Retry $i/$MAX_RETRIES..."
  sleep $RETRY_INTERVAL
done

# Check MongoDB availability with the mongo shell
echo "Checking if MongoDB is responsive..."
for ((i=1; i<=MAX_RETRIES; i++)); do
  if check_mongo_responsive; then
    echo "MongoDB is ready to accept connections."
    break
  fi
  if [ "$i" -eq "$MAX_RETRIES" ]; then
    echo "MongoDB is not responding after $MAX_RETRIES attempts. Exiting..."
    exit 1
  fi
  echo "MongoDB is not responding yet. Retry $i/$MAX_RETRIES..."
  sleep $RETRY_INTERVAL
done

# Run your MongoDB scripts for creating collections
FILES=$SCRIPT_DIR/*-create.js
for f in $FILES; do
  echo "Executing $f ..."
  mongo localhost:27017/users $f
done

# Run your MongoDB scripts for inserting data
FILES=$SCRIPT_DIR/*-insert.js
for f in $FILES; do
  echo "Executing $f ..."
  mongo localhost:27017/users $f
done

# Shutdown MongoDB after executing the scripts
mongo --eval "db.getSiblingDB('admin').shutdownServer()"

# Wait for MongoDB to shut down
sleep 3
