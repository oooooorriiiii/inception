!/bin/sh

# create mysql
if [ -d "/run/mysql" ]; then
	echo "[INFO] mysql already present, skipping creation"
	chown -R mysql:mysql /run/mysqld
else
	echo "[INFO] mysql not found, creating..."
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

# create mysql data directory
if [ -d /var/lib/mysql/mysql ]; then
	echo "[INFO] mysql directory already present, skipping creation"
	chown -R mysql:mysql /var/lib/mysql
else
	echo "[INFO] mysql data directory not found, creating initial DBs"
	chown -R mysql /var/lib/mysql
	#mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null
	mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql --rpm > /dev/null

	TEMP_FILE=`/tmp/mysql-first-time.sql`
	if [ ! -f "$TEMP_FILE" ]; then
		return 1
	fi

	cat > "$TEMP_FILE" << EOF
USE mysql ;
FLUSH PRIVILEGES ;
DROP DATABASE IF EXISTS test ;
GRANT ALL ON *.* TO 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
GRANT ALL ON *.* TO 'root'@'localhost' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;
SET PASSWORD FOR 'root'@'%'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;
FLUSH PRIVILEGES ;
CREATE DATABASE IF NOT EXISTS $WP_DB_NAME CHARACTER SET utf8 COLLATE utf8_general_ci ;
CREATE USER '$WP_DB_USER'@'localhost' IDENTIFIED BY '$WP_DB_PASSWORD';
CREATE USER '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO '$WP_DB_USER'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO '$WP_DB_USER'@'%';
FLUSH PRIVILEGES ;
EOF
	/usr/bin/mysqld --user=mysql --bootstrap < $TEMP_FILE
	echo "[INFO] mysql init process done. Ready for start up."
fi

# allow remote connections
sed -i "s|.*skip-networking.*|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

exec /usr/bin/mysqld --user=mysql --console
#/usr/bin/mysql root -p$MYSQL_ROOT_PASSWORD < $tfile
