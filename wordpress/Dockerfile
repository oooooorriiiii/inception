FROM debian:bullseye-slim

# https://make.wordpress.org/hosting/handbook/server-environment/
RUN apt-get update && apt-get -y install \
        wget \
        curl \
        php \
        mariadb-client

# RUN adduser -S nginx && addgroup -S nginx

RUN set -eux; \
    version='6.1.1'; \
    sha1='80f0f829645dec07c68bcfe0a0a1e1d563992fcb'; \
    curl -o wordpress.tar.gz -fL "https://wordpress.org/wordpress-${version}.tar.gz"; \
    echo "$sha1 *wordpress.tar.gz" | sha1sum -c -; \
    tar -xzf wordpress.tar.gz -C /usr/src/; \
    rm wordpress.tar.gz

COPY ./wordpress-setup.sh /usr/local/bin/wordpress-setup.sh
RUN chmod +x /usr/local/bin/wordpress-setup.sh && ./usr/local/bin/wordpress-setup.sh

VOLUME /usr/src/wordpress

CMD ["bin/bash"]
