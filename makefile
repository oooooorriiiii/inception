# nginx
debug_nginx: debug_nginx_run

debug_nginx_build:
	docker build -t nginx_d_img ./nginx

debug_nginx_run: debug_nginx_build
	docker run --rm -it -p 80:80 -p 443:443 nginx_d_img /bin/bash

# wordpress
debug_wordpress: debug_wordpress_run

debug_wordpress_build:
	docker build -t wordpress_d_img ./wordpress

debug_wordpress_run: debug_wordpress_build
	docker run --rm -it -p 80:80 -p 443:443 wordpress_d_img /bin/bash

# db
debug_db: debug_db_run

debug_db_build:
	docker build -t db_d_img ./mariadb

debug_db_run: debug_db_build
	docker run --rm -it -p 80:80 -p 443:443 db_d_img /bin/bash