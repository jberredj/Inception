#!/bin/sh
if [ ! -f /var/www/html/wp-config.php ]; then
 	cd /var/www/html/
	wp core download --allow-root
	until mysqladmin -hmariadb -u${MARIADB_USR} -p${MARIADB_USRPASSWD} ping; do
       sleep 2
    done
	echo wp config create --dbhost=mariadb:3306 --dbname=${MARIADB_DB} --dbuser=${MARIADB_USR} --dbpass=${MARIADB_USRPASSWD} --dbcharset="utf8" --allow-root
	wp config create --dbhost=mariadb:3306 --dbname=${MARIADB_DB} --dbuser=${MARIADB_USR} --dbpass=${MARIADB_USRPASSWD} --dbcharset="utf8" --allow-root
	wp core install --url=${WP_SITE_URL} --title="${WP_SITE_TITLE}" --admin_user=${WP_ADM} --admin_password=${WP_ADM_PASSWD} --admin_email="$WP_ADM@42.fr" --allow-root
	wp user create ${WP_USR} "$WP_USR"@student.42.fr --role=author --user_pass=${WP_USR_PASSWD} --allow-root
	chown -R www-data:www-data /var/www/html/
fi


/usr/sbin/php-fpm7.3 -F -R