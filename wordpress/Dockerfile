FROM debian:bullseye-slim

# https://make.wordpress.org/hosting/handbook/server-environment/
RUN apt-get update && apt-get -y install \
        wget \
        curl \

        php \

        php-json \
        php-mysql \

        php-curl \
        php-dom \
        php-exif \
        php-fileinfo \
        # php-hash \
        php-imagick \
        php-mbstring \
        # php-openssl \
        # php-pcre \
        php-xml \
        php-zip

RUN apt-get -y install \
        php-memcached \
        php-opcache \
        php-redis \

        # php-bc \
        # php-filter \
        # php-image \
        php-iconv \
        php-intl \
        php-simplexml \
        # php-sodium \
        php-xmlreader \
        # php-zlib \

        php-ssh2 \
        php-ftp \
        php-sockets \

        mariadb-client

# RUN adduser -S nginx && addgroup -S nginx

CMD ["bin/bash"]
