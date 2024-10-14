FROM mongo:3
ADD scripts /tmp/scripts

# Ensure the script has executable permissions
RUN chmod +x /tmp/scripts/mongo_create_insert.sh

# Modify MongoDB to use /data/db-users as the dbpath
RUN mkdir -p /data/db-users \
    && echo "dbpath = /data/db-users" > /etc/mongodb.conf \
    && chown -R mongodb:mongodb /data/db-users

RUN su - mongodb && mongod --fork --logpath /var/log/mongodb.log --dbpath /data/db-users \
    && /tmp/scripts/mongo_create_insert.sh \
    && mongod --dbpath /data/db-users --shutdown \
    && chown -R mongodb /data/db-users

VOLUME /data/db-users

CMD ["mongod", "--config", "/etc/mongodb.conf", "--smallfiles"]
