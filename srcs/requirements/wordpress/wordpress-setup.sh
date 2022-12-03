#!/bin/sh

# wait until database is ready
while ! mariadb -h$MYSQL_HOST -u$WP_DB_USER -p$WP_DB_PASSWORD $WP_DB_NAME --silent; do
	echo "[INFO] waiting for database..."
	sleep 1;
done

# check if wordpress is installed
if [ ! -f "/var/www/html/$WP_FILE_ONINSTALL" ]; then
	echo "[INFO] installing wordpress..."

	# wp-cli
	wp core download --allow-root
	wp config create \
        --dbname=$WP_DB_NAME \
        --dbuser=$WP_DB_USER \
        --dbpass=$WP_DB_PASSWORD \
		--dbhost=$MYSQL_HOST \
        --dbcharset="utf8" \
        --dbcollate="utf8_general_ci" \
        --allow-root
	wp core install \
        --url=$DOMAIN_NAME/wordpress \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
		--admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --skip-email \
        --allow-root
	wp user create $WP_USER $WP_EMAIL \
        --role=author \
        --user_pass=$WP_PASSWORD \
        --allow-root

	# redis
    # sed -i "40i define('WP_REDIS_HOST', '$REDIS_HOST');" wp-config.php
    # sed -i "41i define('WP_REDIS_PORT', 6379);" wp-config.php
    # sed -i "42i define('WP_REDIS_PASSWORD', '$REDIS_PWD');" wp-config.php
    # sed -i "43i define('WP_REDIS_TIMEOUT', 1);" wp-config.php
    # sed -i "44i define('WP_REDIS_READ_TIMEOUT', 1);" wp-config.php
    # sed -i "45i define('WP_REDIS_DATABASE', 0);\n" wp-config.php
	# sed -i "46i define('WP_CACHE', true);" wp-config.php
    # wp plugin install redis-cache --activate --allow-root

	# update plugins
    wp plugin update --all --allow-root

	echo "[INFO] wordpress installation finished"
	touch /var/www/html/$WP_FILE_ONINSTALL
fi

# enable redis
# wp redis enable --allow-root

echo "[INFO] starting php-fpm..."
mkdir -p /var/run/php-fpm7
php-fpm8 --nodaemonize