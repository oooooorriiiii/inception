FROM debian:bullseye-slim

# https://make.wordpress.org/hosting/handbook/server-environment/
RUN apt-get update && apt-get -y install \
        wget \
        curl \
        php \
        php-fpm \
        mariadb-client


# RUN  groupadd -r nginx && useradd -r -g nginx nginx

# COPY php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf
# COPY www.conf /etc/php/7.4/php-fpm.d/www.conf

RUN set -eux && \
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

COPY www.conf /etc/php/7.4/fpm/pool.d/www.conf

WORKDIR /var/www/html/wordpress

COPY ./wordpress-setup.sh /usr/local/bin/wordpress-setup.sh

CMD ["sh", "/usr/local/bin/wordpress-setup.sh"]
