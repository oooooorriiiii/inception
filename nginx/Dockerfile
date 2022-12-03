FROM alpine:3.14

RUN apk update && apk upgrade && apk add --no-cache \
	nginx openssl

# open ssl certificate
RUN mkdir /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -sha256 \
	-keyout /etc/nginx/ssl/openssl.key \
	-out /etc/nginx/ssl/openssl.crt \
	-subj "/C=SP/ST=Madrid/L=Madrid/O=42/OU=IT/CN=dpoveda.42.fr/"

# nginx
RUN mkdir -p /run/nginx
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
#COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf
#RUN sed -i "s|.*#include /etc/nginx/conf.d/\*.conf;.*|include /etc/nginx/conf.d/\*.conf;|g" /etc/nginx/nginx.conf

# container restart if I just run 'nginx'
# don't know why becouse 'daemon off' is set in the default.conf file
#CMD ["nginx"]
CMD ["nginx", "-g", "daemon off;"]