FROM debian:bullseye-slim

RUN set -x && \
    apt-get update && apt-get -y install \
        mariadb-server && \
    rm -rf /var/lib/apt/lists/*

RUN set -x && \
    mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld

VOLUME /var/lib/mysql

COPY ./mariadb-setup.sh /usr/local/bin/mariadb-setup.sh
COPY ./50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

ENTRYPOINT [ "mariadb-setup.sh" ]

EXPOSE 3306
CMD ["mysqld"]