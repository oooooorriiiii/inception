FROM alpine:3.16

RUN addgroup -S adminer \
    && adduser -S -G adminer adminer \
    && mkdir -p /var/www/html \
    # && mkdir /var/www/html/plugins-enabled \
    && chown -R adminer:adminer /var/www/html

RUN apk update && apk upgrade && apk add --no-cache \
    curl \
    php8

WORKDIR /var/www/html

ENV	ADMINER_VERSION 4.8.1
ENV	ADMINER_DOWNLOAD_SHA256 2fd7e6d8f987b243ab1839249551f62adce19704c47d3d0c8dd9e57ea5b9c6b3
ENV	ADMINER_COMMIT 1f173e18bdf0be29182e0d67989df56eadea4754

RUN	set -x \
&&	apk add --no-cache --virtual .build-deps git \
&&	curl -fsSL "https://github.com/vrana/adminer/releases/download/v$ADMINER_VERSION/adminer-$ADMINER_VERSION.php" -o adminer.php \
&&	echo "$ADMINER_DOWNLOAD_SHA256  adminer.php" |sha256sum -c - \
&&	git clone --recurse-submodules=designs --depth 1 --shallow-submodules --branch "v$ADMINER_VERSION" https://github.com/vrana/adminer.git /tmp/adminer \
&&	commit="$(git -C /tmp/adminer/ rev-parse HEAD)" \
&&	[ "$commit" = "$ADMINER_COMMIT" ] \
&&	cp -r /tmp/adminer/designs/ /tmp/adminer/plugins/ . \
&&	rm -rf /tmp/adminer/ \
&&	apk del --no-network  .build-deps

COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT [ "entrypoint.sh" ]

USER adminer
CMD [ "php", "-S", "[::]:8080", "-t", "/var/www/html" ]

EXPOSE 8080
