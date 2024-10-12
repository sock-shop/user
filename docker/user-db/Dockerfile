FROM mongo:3
ADD ./scripts /tmp/scripts

# Modify child mongo to use /data/db-users as dbpath (because /data/db won't persist the build because it is already a VOLUME)
RUN mkdir -p /data/db-users /var/log/mongodb \
    && echo "dbpath = /data/db-users" > /etc/mongodb.conf \
    && echo "logpath = /var/log/mongodb/mongodb.log" >> /etc/mongodb.conf \
    && chown -R mongodb:mongodb /data/db-users /var/log/mongodb

# Ensure the script has executable permissions
RUN chmod +x /tmp/scripts/mongo_create_insert.sh

# Switch to the 'mongodb' user
USER mongodb

# Run MongoDB, execute the script, and shut down MongoDB
RUN mongod --config /etc/mongodb.conf --bind_ip 127.0.0.1 & \
    sleep 5 && /tmp/scripts/mongo_create_insert.sh && \
    mongo --eval "db.getSiblingDB('admin').shutdownServer()"

# Switch back to root to make the directory a VOLUME and fix any permission issues
USER root

# Ensure the correct permissions
RUN chown -R mongodb:mongodb /data/db-users

# Make the new dir a VOLUME to persist it
VOLUME /data/db-users

# Use CMD to run MongoDB with the new configuration
CMD ["mongod", "--config", "/etc/mongodb.conf", "--smallfiles"]


#FROM mongo:3
#ADD ./scripts /tmp/scripts
#
## Modify child mongo to use /data/db-users as dbpath (because /data/db won't persist the build because it is already a VOLUME)
#RUN mkdir -p /data/db-users /var/log/mongodb \
#    && echo "dbpath = /data/db-users" > /etc/mongodb.conf \
#    && chown -R mongodb:mongodb /data/db-users /var/log/mongodb
#
## Ensure the script has executable permissions
#RUN chmod +x /tmp/scripts/mongo_create_insert.sh
#
## Switch to the 'mongodb' user
#USER mongodb
#
## Run MongoDB, execute the script, and shut down MongoDB
#RUN mongod --logpath /var/log/mongodb.log --dbpath /data/db-users --bind_ip 127.0.0.1 & \
#    /tmp/scripts/mongo_create_insert.sh && mongod --shutdown --dbpath /data/db-users
#
## Switch back to root to make the directory a VOLUME and fix any permission issues
#USER root
#
## Ensure the correct permissions
#RUN chown -R mongodb:mongodb /data/db-users
#
## Make the new dir a VOLUME to persist it
#VOLUME /data/db-users
#
## Use CMD to run MongoDB with the new configuration
#CMD ["mongod", "--config", "/etc/mongodb.conf", "--smallfiles"]

#FROM mongo:3
#ADD ./scripts /tmp/scripts
#
## Modify child mongo to use /data/db-accounts as dbpath (because /data/db wont persist the build because it is already a VOLUME)
#RUN mkdir -p /data/db-users \
#    && echo "dbpath = /data/db-users" > /etc/mongodb.conf \
#    && chown -R mongodb:mongodb /data/db-users
#
#RUN su - mongodb && mongod --fork --logpath /var/log/mongodb.log --dbpath /data/db-users  \
#    && /tmp/scripts/mongo_create_insert.sh \
#    && mongod --dbpath /data/db-users --shutdown \
#    && chown -R mongodb /data/db-users
#
## Make the new dir a VOLUME to persist it
#VOLUME /data/db-users
#
#CMD ["mongod", "--config", "/etc/mongodb.conf", "--smallfiles"]
