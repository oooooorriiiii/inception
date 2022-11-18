#!/bin/sh

sed -i "s/define('DB_NAME', 'database_name_here');/define('DB_NAME', '$MYSQL_DATABASE_NAME');/g" /usr/src/wordpress/wp-config-sample.php
sed -i "s/define('DB_USER', 'username_here');/define('DB_USER', '$MYSQL_USER');/g" /usr/src/wordpress/wp-config-sample.php
sed -i "s/define('DB_PASSWORD', 'password_here');/define('DB_PASSWORD', '$MYSQL_PASSWORD');/g" /usr/src/wordpress/wp-config-sample.php
sed -i "s/define('DB_HOST', 'localhost');/define('DB_HOST', '$MYSQL_HOST_NAME');/g" /usr/src/wordpress/wp-config-sample.php

