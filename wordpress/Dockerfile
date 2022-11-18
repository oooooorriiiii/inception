FROM debian:bullseye-slim

# https://make.wordpress.org/hosting/handbook/server-environment/
RUN apt-get update && apt-get -y install \
        wget \
        curl \
        php \
        mariadb-client

# RUN adduser -S nginx && addgroup -S nginx

CMD ["bin/bash"]
