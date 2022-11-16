FROM	debian:buster

RUN	apt update && \
	apt install -y nginx openssl \
	vim				# for debug

RUN	mkdir /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 365 \
	-subj '/C=JP/ST=Tokyo/L=Minato/CN=42' \
	-newkey rsa:4069 \
	-keyout /etc/nginx/ssl/prikey.key \
	-out /etc/nginx/ssl/cert.crt 

COPY	./conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE	443

CMD	["nginx", "-g", "daemon off;"]
