FROM alpine:3.14

RUN apk update && apk upgrade && apk add --no-cache \
    mariadb \
    mariadb-client \
    mariadb-common && \
    rm -rf /var/cache/apk/*

COPY ./mariadb-setup.sh /tmp/run.sh
RUN chmod +x /tmp/run.sh

CMD [ "sh", "/tmp/run.sh" ]