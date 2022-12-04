FROM alpine:3.14

RUN apk update && apk upgrade && apk add --no-cache \
    mariadb \
    mariadb-client \
    mariadb-common && \
    rm -rf /var/cache/apk/*

COPY ./mariadb-setup.sh /tmp/run.sh
RUN chmod +x /tmp/run.sh

ENTRYPOINT [ "/tmp/run.sh" ]

CMD [ "/usr/bin/mysqld", "--user=mysql", "--console" ]