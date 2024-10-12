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

# Start MongoDB in the background (using the correct dbpath)
mongod --fork --logpath /var/log/mongodb.log --dbpath /data/db-users --bind_ip 127.0.0.1

# Wait for MongoDB to start
sleep 5

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
