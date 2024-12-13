FROM	debian:bullseye

ENV	DEBIAN_FRONTEND=noninteractive

RUN	apt-get update -y && apt-get upgrade -y
RUN	apt-get install -y wget
RUN	apt-get install -y php7.4 php-fpm php-mysql mariadb-client
RUN	mkdir -p /var/www/ \
	&&	chown -R www-data:www-data /var/www \
	&&	chmod 755 /var/www

COPY	./conf/www.conf  /etc/php/7.4/fpm/pool.d/

RUN	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&&	chmod +x wp-cli.phar \
	&&	mv wp-cli.phar /usr/local/bin/wp \
	&&	chmod 755 /usr/local/bin/wp

RUN	wp core download --allow-root --path='/var/www/wordpress'

COPY	./tools/wpscript.sh .

RUN	chmod +x wpscript.sh

EXPOSE	9000

CMD	["bash", "./wpscript.sh"]