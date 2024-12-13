#!/bin/bash
# set -eux

if [ ! -f /var/www/wordpress/wp-config.php ];then

	sleep 15
	cd /var/www/wordpress
	wp config create	--allow-root \
				--dbname="${MYSQL_DATABASE}" \
				--dbuser="${MYSQL_USER_LOGIN}" \
				--dbpass="${MYSQL_USER_PASSWORD}" \
				--dbhost=mariadb:3306 \

	wp core install		--allow-root \
				--url="https://${DOMAIN_NAME}" \
				--title="${SITE_TITLE}" \
				--admin_user="${MYSQL_ADMIN_USER}" \
				--admin_password="${MYSQL_ADMIN_PASSWORD}" \
				--admin_email="${MYSQL_ADMIN_EMAIL}" ;

	wp user create		--allow-root \
				"${MYSQL_USER_LOGIN}" "${MYSQL_USER_EMAIL}" \
				--role=author \
				--user_pass="${MYSQL_USER_PASSWORD}";

	wp cache flush --allow-root
	wp plugin install contact-form-7 --activate --allow-root
	sleep 5
	sed -i "41 i define( 'WP_REDIS_HOST', 'redis' );\ndefine( 'WP_REDIS_PORT', '6379' );\n" wp-config.php
fi

if [ ! -d /run/php ]; then
	mkdir /run/php;
fi

service php7.4-fpm start
	sleep 3

service php7.4-fpm stop
	sleep 3

exec /usr/sbin/php-fpm7.4 -F -R