#!/bin/bash
if [ ! -d /var/lib/mysql/${MARIADB_DB} ]; then
	mysql_install_db --user=root --ldata=/var/lib/mysql
    mysqld&
    until mysqladmin ping; do
        sleep 2
    done
    mysql -u root -e "CREATE DATABASE ${MARIADB_DB};\
	CREATE USER '${MARIADB_ADM}'@'%' IDENTIFIED BY '${MARIADB_ADM_PASSWD}';\
	GRANT ALL ON *.* TO '${MARIADB_ADM}'@'%';\
	CREATE USER '${MARIADB_USR}'@'%' IDENTIFIED BY '${MARIADB_USRPASSWD}';\
    GRANT ALL ON ${MARIADB_DB}.* TO '${MARIADB_USR}'@'%';\ 
    DELETE FROM mysql.user WHERE user='root';\
    FLUSH PRIVILEGES;"

    killall mysqld
fi

mysqld