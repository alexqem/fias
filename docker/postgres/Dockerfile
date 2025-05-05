FROM postgres:17.4-alpine

COPY init-user-db.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/init-user-db.sh