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


#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")

# Start MongoDB in the background
mongod --fork --logpath /var/log/mongodb.log --dbpath /data/db/

# Wait for MongoDB to be ready
until mongo --eval "print(\"waited for connection\")" 127.0.0.1:27017; do
    echo "Waiting for MongoDB to start..."
    sleep 2
done

# Run your MongoDB scripts
FILES=$SCRIPT_DIR/*-create.js
for f in $FILES; do mongo localhost:27017/users $f; done

FILES=$SCRIPT_DIR/*-insert.js
for f in $FILES; do mongo localhost:27017/users $f; done
