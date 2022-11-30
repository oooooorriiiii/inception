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
	wp config create --dbname=$WP_DB_NAME --dbuser=$WP_DB_USER --dbpass=$WP_DB_PASSWORD \
		--dbhost=$MYSQL_HOST --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root
	wp core install --url=$DOMAIN_NAME/wordpress --title=$WP_TITLE --admin_user=$WP_ADMIN_USER \
		--admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root
	wp user create $WP_USER $WP_EMAIL --role=author --user_pass=$WP_PASSWORD --allow-root
	wp theme install ryu --activate --allow-root

	# redis
    sed -i "40i define('WP_REDIS_HOST', '$REDIS_HOST');" wp-config.php
    sed -i "41i define('WP_REDIS_PORT', 6379);" wp-config.php
    sed -i "42i define('WP_REDIS_PASSWORD', '$REDIS_PWD');" wp-config.php
    sed -i "43i define('WP_REDIS_TIMEOUT', 1);" wp-config.php
    sed -i "44i define('WP_REDIS_READ_TIMEOUT', 1);" wp-config.php
    sed -i "45i define('WP_REDIS_DATABASE', 0);\n" wp-config.php
	sed -i "46i define('WP_CACHE', true);" wp-config.php
	#sed -i "47i define('WP_CACHE_KEY_SALT', 'dpoveda.42.fr');" wp-config.php
	# install redir plugin to wordpress
    wp plugin install redis-cache --activate --allow-root

	# update plugins
    wp plugin update --all --allow-root

	echo "[INFO] wordpress installation finished"
	touch /var/www/html/$WP_FILE_ONINSTALL
fi

# enable redis
wp redis enable --allow-root

echo "[INFO] starting php-fpm..."
mkdir -p /var/run/php-fpm7
#php-fpm7 -R --nodaemonize
php-fpm7 --nodaemonize

# # exit immediately if a command fails or unset variables are used.
# # https://sipb.mit.edu/doc/safe-shell/
# # https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#The-Set-Builtin
# set -eu -o pipefail

# # logging functions
# log_base() {
# 	local type="$1"; shift
# 	printf '%s [%s] [Entrypoint]: %s\n' "$(date --rfc-3339=seconds)" "$type" "$*"
# }

# log_info() {
# 	log_base Info "$@"
# }

# log_error() {
#   log_base ERROR "$@" >&2
#   exit 1
# }

# wait_until_db_start() {
#   log_info "Waiting for MariaDB to start."
#   local i
#   for i in {10..0}; do
#     if [ "$i" = 0 ]; then
#       log_error "Could not connect to MariaDB."
#     fi
#     if mysql -h mariadb -u "${WP_DB_USER}" -p"${WP_DB_PASSWORD}" <<<'SELECT 1;' &> /dev/null; then
#       break
#     fi
#     sleep 1
#   done
#   log_info "MariaDB is started."
# }

# # check whether WP is installed.
# is_wp_installed() {
#   # consider WP is installed, if the wp-config.php file exists.
#   [ -e "${WP_PATH}/wp-config.php" ]
# }

# install_wp() {
#   log_info "Installing WordPress."
#   # generates a wp-config.php file.
#   # https://developer.wordpress.org/cli/commands/config/create/
#   wp config create \
#     --dbname="${WP_DB_NAME}" \
#     --dbuser="${WP_DB_USER}" \
#     --dbpass="${WP_DB_PASSWORD}" \
#     --dbhost=mariadb:3306 \
#     --path="${WP_PATH}" \
#     --allow-root

#   # runs the standard WordPress installation process.
#   # https://developer.wordpress.org/cli/commands/core/install/
#   wp core install \
#     --url="${WP_URL}" \
#     --title="${WP_TITLE}" \
#     --admin_user="${WP_ADMIN_USER}" \
#     --admin_password="${WP_ADMIN_PASS}" \
#     --admin_email="${WP_ADMIN_EMAIL}" \
#     --path="${WP_PATH}" \
#     --allow-root

#   # create a new user with an editor role.
#   # editor can publish and manage posts including the posts of other users.
#   # https://developer.wordpress.org/cli/commands/user/create/
#   wp user create \
#     "ymori" \
#     "ymori@example.com" \
#     --user_pass="ymori42" \
#     --role=editor \
#     --path="${WP_PATH}" \
#     --allow-root

#   log_info "WordPress is successfully installed."
# }

# wait_until_db_start
# if ! is_wp_installed; then
#   install_wp
# fi
# exec "$@"
