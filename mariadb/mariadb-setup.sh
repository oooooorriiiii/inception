#!/bin/sh

if [ -d "/run/mysql" ]; then
    echo "mysql already installed"
    chown -R mysql:mysql /run/mysqld
else
    echo "mysql not found, installing"
    mkdir -p /run/mysqld
    chown -R mysql:mysql /run/mysqld
fi

if [ -d "/var/lib/mysql/mysql" ]; then
    echo "mysql directory already present"
    chown -R mysql:mysql /var/lib/mysql
else
    echo "Initializing mysql"
    chown -R mysql:mysql /var/lib/mysql
    mysql_install_db --user=mysql -basedir=/usr --datadir=/var/lib/mysql --rpm

    cat << EOF > $tmpfile
USE mysql ;
FLUSH PRIVILEGES ;

DROP DATABASE IF EXISTS test ;

GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY ${MYSQL_ROOT_PASSWORD} WITH GRANT OPTION ;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY ${MYSQL_ROOT_PASSWORD} WITH GRANT OPTION ;
SET PASSWORD FOR 'root'@'localhost' = PASSWORD(${MYSQL_ROOT_PASSWORD}) ;
SET PASSWORD FOR 'root'@'%' = PASSWORD(${MYSQL_ROOT_PASSWORD}) ;
FLUSH PRIVILEGES ;

CREATE DATABASE IF NOT EXISTS ${MYSQL_DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci ;
CREATE USER '${MYSQL_DB_USER}'@'localhost' IDENTIFIED BY '${MYSQL_DB_PASSWORD}' ;
CREATE USER '${MYSQL_DB_USER}'@'%' IDENTIFIED BY ${MYSQL_DB_PASSWORD} ;
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_DB_USER}'@'localhost' ;
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_DB_USER}'@'%' ;
FLUSH PRIVILEGES ;

EOF

    /usr/bin/mysql --user=mysql --bootstrap < $tmpfile

fi

exec mysqld --user=mysql --console
