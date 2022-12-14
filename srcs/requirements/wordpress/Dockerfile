FROM alpine:3.16

ENV DB_HOST="127.0.0.1"

# https://make.wordpress.org/hosting/handbook/server-environment/
# https://pkgs.org/
RUN apk update && apk upgrade && apk add --no-cache \
    wget \
    tar \
    mariadb-client \
    php8 \
    php8-fpm \
    # https://github.com/docker-library/wordpress/blob/69b6ba67e1d4771027d9089cb1d4cc974b27d773/latest/php8.1/fpm-alpine/Dockerfile#L39
    php8-bcmath \
    php8-exif \
    php8-gd \
    php8-intl \
    php8-mysqli \
    php8-pear \
    php8-phar \
    php8-zip

RUN adduser -S nginx && addgroup -S nginx
COPY ./conf/php-fpm.conf /etc/php8/php-fpm.conf
COPY ./conf/www.conf /etc/php8/php-fpm.d/www.conf

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp \
    && chmod +x /usr/local/bin/wp

WORKDIR /var/www/html/wordpress

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "php-fpm8", "--nodaemonize" ]