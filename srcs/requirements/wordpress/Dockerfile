FROM debian:bullseye

EXPOSE 9000
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y wget php7.3 php-fpm php-mysql mariadb-client curl mycli

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY /tools/wpscript.sh /
RUN  chmod +x wpscript.sh

ENTRYPOINT ["bash" , "./wpscript.sh"]