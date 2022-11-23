FROM debian:bullseye-slim

RUN set -x && \
    apt-get update && apt-get -y install \
        mariadb-server && \
    rm -rf /var/lib/apt/lists/*

RUN set -x && \
    mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld && \
    mkdir /docker-entrypoint-initdb.d

VOLUME /var/lib/mysql

COPY ./mariadb-setup.sh /usr/local/bin/mariadb-setup.sh
COPY ./50-server.conf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY init/* /docker-entrypoint-initdb.d/

RUN chmod 644 /etc/mysql/mariadb.conf.d/50-server.cnf

ENTRYPOINT [ "mariadb-setup.sh" ]

EXPOSE 3306
CMD ["mysqld"]