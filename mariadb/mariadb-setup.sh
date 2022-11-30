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

	tfile=`mktemp`
	if [ ! -f "$tfile" ]; then
		return 1
	fi

	cat << EOF > $tfile
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

#UPDATE mysql.global_priv SET Host='%' WHERE Host='localhost' AND User='$WP_DB_USER' ;
#UPDATE mysql.db SET Host='%' WHERE Host='localhost' AND User='$WP_DB_USER' ;
#GRANT ALL PRIVILEGES ON '$WP_DB_NAME'.* TO '$WP_DB_USER'@'localhost';
#GRANT ALL PRIVILEGES ON '$WP_DB_NAME'.* TO '$WP_DB_USER'@'%';
	ps -ef > /out_1.txt
	/usr/bin/mysqld --user=mysql --bootstrap < $tfile
	#/usr/bin/mysql root -p$MYSQL_ROOT_PASSWORD < $tfile
	#rm -f $tfile
	ps -ef > /out_2.txt
	echo "[INFO] mysql init process done. Ready for start up."
fi

# allow remote connections
sed -i "s|.*skip-networking.*|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

exec /usr/bin/mysqld --user=mysql --console
#/usr/bin/mysql root -p$MYSQL_ROOT_PASSWORD < $tfile

# set -eu -o pipefail

# # if [ -d "/run/mysql" ]; then
# #     echo "mysql already installed"
# #     chown -R mysql:mysql /run/mysqld
# # else
# #     echo "mysql not found, installing"
# #     mkdir -p /run/mysqld
# #     chown -R mysql:mysql /run/mysqld
# # fi

# # chmod 644 /etc/mysql/mariadb.conf.d/50-server.cnf

# # if [ -d "/var/lib/mysql/mysql" ]; then
# #     echo "mysql directory already present"
# #     chown -R mysql:mysql /var/lib/mysql
# # else
# #     echo "Initializing mysql"
# #     chown -R mysql /var/lib/mysql
# #     mysql_install_db --user=mysql -basedir=/usr --datadir=/var/lib/mysql --rpm

# #     cat << EOF > $tmpfile
# # USE mysql ;
# # FLUSH PRIVILEGES ;

# # DROP DATABASE IF EXISTS test ;

# # GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY ${MYSQL_ROOT_PASSWORD} WITH GRANT OPTION ;
# # GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY ${MYSQL_ROOT_PASSWORD} WITH GRANT OPTION ;
# # SET PASSWORD FOR 'root'@'localhost' = PASSWORD(${MYSQL_ROOT_PASSWORD}) ;
# # SET PASSWORD FOR 'root'@'%' = PASSWORD(${MYSQL_ROOT_PASSWORD}) ;
# # FLUSH PRIVILEGES ;

# # CREATE DATABASE IF NOT EXISTS ${MYSQL_DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci ;
# # CREATE USER '${MYSQL_DB_USER}'@'localhost' IDENTIFIED BY '${MYSQL_DB_PASSWORD}' ;
# # CREATE USER '${MYSQL_DB_USER}'@'%' IDENTIFIED BY ${MYSQL_DB_PASSWORD} ;
# # GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_DB_USER}'@'localhost' ;
# # GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_DB_USER}'@'%' ;
# # FLUSH PRIVILEGES ;

# # EOF

# #     /usr/bin/mysql --user=mysql --bootstrap < $tmpfile

# # fi

# docker_tmp_start() {
#     mysqld --skip-networking -uroot &

#     local i
#     for i in {10..0}; do
#       if mysql <<<'SELECT 1;' &> /dev/null; then
#         break
#       fi
#       sleep 1
#     done
#     echo "Temporary server started."
# }

# docker_process_init_files() {
#   local f
#   for f; do
#     case "$f" in
#       *.sh)
#         echo "running $f";
#         # ShellCheck can't follow non-constant source. Use a directive to specify location.
#         # shellcheck disable=SC1090
#         . "$f"
#         ;;
#       *.sql)
#         echo "running $f";
#         mysql < "$f"
#         ;;
#       *) echo "ignoring $f"; ;;
#     esac
#   done
# }

# docker_tmp_server_stop() {
#   echo "Stopping temporary server."
#   mysqladmin shutdown
#   echo "Temporary server stopped."
# }

# initialize_db() {
#     docker_tmp_start
#     docker_process_init_files /docker-entrypoint-initdb.d/*
#     docker_tmp_server_stop
# }

# DB_NAME="wordpress"

# is_initialized() {
#   # Consider DB is initialized, if wordpress database exists.
#   [ -e /var/lib/mysql/"${DB_NAME}" ]
# }

# if ! is_initialized; then
#     echo "Initializing mysql"
#     initialize_db
# fi

# exec "$@"
