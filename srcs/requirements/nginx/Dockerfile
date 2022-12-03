FROM alpine:3.14

RUN apk update && apk upgrade && apk add --no-cache \
	nginx \
	openssl

# open ssl certificate
RUN mkdir /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -sha256 \
	-keyout /etc/nginx/ssl/openssl.key \
	-out /etc/nginx/ssl/openssl.crt \
	-subj "/C=JP/ST=Tokyo/L=Minato/O=42tokyo/CN=ymori.42.jp/"

# nginx
RUN mkdir -p /run/nginx
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]