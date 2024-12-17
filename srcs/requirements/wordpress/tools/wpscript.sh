#!/bin/bash
# #set -eux

# cd /var/www/html/wordpress

# if ! wp core is-installed; then
# wp config create	--allow-root --dbname=${SQL_DATABASE} \
# 			--dbuser=${SQL_USER} \
# 			--dbpass=${SQL_PASSWORD} \
# 			--dbhost=${SQL_HOST} \
# 			--url=https://${DOMAIN_NAME};

# wp core install	--allow-root \
# 			--url=https://${DOMAIN_NAME} \
# 			--title=${SITE_TITLE} \
# 			--admin_user=${ADMIN_USER} \
# 			--admin_password=${ADMIN_PASSWORD} \
# 			--admin_email=${ADMIN_EMAIL};

# wp user create		--allow-root \
# 			${USER1_LOGIN} ${USER1_MAIL} \
# 			--role=author \
# 			--user_pass=${USER1_PASS} ;

# wp cache flush --allow-root

# # set the permalink structure
# wp rewrite structure '/%postname%/'

# fi

# if [ ! -d /run/php ]; then
# 	mkdir /run/php;
# fi

# # start the PHP FastCGI Process Manager (FPM) for PHP version 7.3 in the foreground
# exec /usr/sbin/php-fpm7.3 -F -R

# go into dir where wordpress installed, set permissions (write only by owner, read/execute by all)
# change ownership of all files in wordpress dir to www-data (user associated with NGINX)
cd /var/www/wordpress
chmod -R 755 /var/www/wordpress/
chown -R www-data:www-data /var/www/wordpress

echo "...Installing WordPress..."
# delete any existing files in wordpress dir
find /var/www/wordpress/ -mindepth 1 -delete

# download latest version and make sure download is finished before next cmds
wp core download --allow-root --path="/var/www/wordpress"

# ensure mariadb is running before continuing
sleep 5

# configures wordpress to connect to mariadb database
wp core config 
	--dbhost=mariadb:3306 \
	--dbname="$SQL_DATABASE" \
	--dbuser="$SQL_USER" \
	--dbpass="$SQL_PASSWORD" \ 
	--allow-root \
	--path="/var/www/wordpress"

# installs wordpress with specified site parameters
wp core install 
	--url="$DOMAIN_NAME" \
	--title="$SITE_TITLE" \
	--admin_user="$ADMIN_USER" \ 
	--admin_password="$ADMIN_PASSWORD" \
	--admin_email="$ADMIN_EMAIL" \
	--allow-root \
	--path="/var/www/wordpress"
# create new user as author with env varuables
wp user create 
	"$USER1_LOGIN" "$USER1_MAIL" \
	--user_pass="$USER1_PASS" \
	--role=author \
	--allow-root \
	--path="/var/www/wordpress"

# ensure any cached data is cleared to avoid conflicts
wp cache flush --allow-root

# Configure PHP-FPM to run on TCP port 9000- means it can interact with the web server inside the container
sed -i '36 s@/run/php/php7.4-fpm.sock@9000@' /etc/php/7.4/fpm/pool.d/www.conf
mkdir -p /run/php

# start in foreground so continues running in container
/usr/sbin/php-fpm7.4 -F