#!/bin/sh

while ! mariadb -h$MYSQL_HOST -u$WP_DB_USER -p$WP_DB_PASSWORD $WP_DB_NAME --silent; do
    echo "Waiting for database connection..."
    sleep 1
done

wp core download --allow-root

wp config create \
    --allow-root \
    --dbname=${WP_DB_NAME} \
    --dbuser=${WP_DB_USER} \
    --dbpass=${WP_DB_PASSWORD} \
    --dbhost=${MYSQL_HOST}

wp core install \
    --allow-root \
    --url=${WP_URL} \
    --title=${WP_TITLE} \
    --admin_user=${WP_ADMIN_USER} \
    --admin_password=${WP_ADMIN_PASSWORD} \
    --admin_email=${WP_ADMIN_EMAIL}

wp user create \
    --allow-root \
    --role=author \
    --user_pass=${WP_AUTHOR_PASSWORD} \
    ${WP_AUTHOR_USER}

wp theme install \
    --allow-root \
    ${WP_THEME}

mkdir -p /var/run/php-fpm

php-fpm --nodemonize
