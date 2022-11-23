#!/bin/bash

set -eu -o pipefail

# if [ -d "/run/mysql" ]; then
#     echo "mysql already installed"
#     chown -R mysql:mysql /run/mysqld
# else
#     echo "mysql not found, installing"
#     mkdir -p /run/mysqld
#     chown -R mysql:mysql /run/mysqld
# fi

# chmod 644 /etc/mysql/mariadb.conf.d/50-server.cnf

# if [ -d "/var/lib/mysql/mysql" ]; then
#     echo "mysql directory already present"
#     chown -R mysql:mysql /var/lib/mysql
# else
#     echo "Initializing mysql"
#     chown -R mysql /var/lib/mysql
#     mysql_install_db --user=mysql -basedir=/usr --datadir=/var/lib/mysql --rpm

#     cat << EOF > $tmpfile
# USE mysql ;
# FLUSH PRIVILEGES ;

# DROP DATABASE IF EXISTS test ;

# GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY ${MYSQL_ROOT_PASSWORD} WITH GRANT OPTION ;
# GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY ${MYSQL_ROOT_PASSWORD} WITH GRANT OPTION ;
# SET PASSWORD FOR 'root'@'localhost' = PASSWORD(${MYSQL_ROOT_PASSWORD}) ;
# SET PASSWORD FOR 'root'@'%' = PASSWORD(${MYSQL_ROOT_PASSWORD}) ;
# FLUSH PRIVILEGES ;

# CREATE DATABASE IF NOT EXISTS ${MYSQL_DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci ;
# CREATE USER '${MYSQL_DB_USER}'@'localhost' IDENTIFIED BY '${MYSQL_DB_PASSWORD}' ;
# CREATE USER '${MYSQL_DB_USER}'@'%' IDENTIFIED BY ${MYSQL_DB_PASSWORD} ;
# GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_DB_USER}'@'localhost' ;
# GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_DB_USER}'@'%' ;
# FLUSH PRIVILEGES ;

# EOF

#     /usr/bin/mysql --user=mysql --bootstrap < $tmpfile

# fi

docker_tmp_start() {
    mysqld --skip-networking -uroot &

    local i
    for i in {10..0}; do
      if mysql <<<'SELECT 1;' &> /dev/null; then
        break
      fi
      sleep 1
    done
    echo "Temporary server started."
}

docker_process_init_files() {
  local f
  for f; do
    case "$f" in
      *.sh)
        echo "running $f";
        # ShellCheck can't follow non-constant source. Use a directive to specify location.
        # shellcheck disable=SC1090
        . "$f"
        ;;
      *.sql)
        echo "running $f";
        mysql < "$f"
        ;;
      *) echo "ignoring $f"; ;;
    esac
  done
}

docker_tmp_server_stop() {
  echo "Stopping temporary server."
  mysqladmin shutdown
  echo "Temporary server stopped."
}

initialize_db() {
    docker_tmp_start
    docker_process_init_files /docker-entrypoint-initdb.d/*
    docker_tmp_server_stop
}

DB_NAME="wordpress"

is_initialized() {
  # Consider DB is initialized, if wordpress database exists.
  [ -e /var/lib/mysql/"${DB_NAME}" ]
}

if ! is_initialized; then
    echo "Initializing mysql"
    initialize_db
fi

exec "$@"
