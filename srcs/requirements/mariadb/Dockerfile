FROM	debian:bullseye

ENV	DEBIAN_FRONTEND=noninteractive

RUN	apt-get update -y \
	&& apt-get upgrade -y \
	&& apt-get install -y mariadb-server

COPY	conf/my.cnf /etc/mysql/mariadb.conf.d/my.cnf

RUN	mkdir -p /var/run/mysqld \
	&& chown mysql:mysql /var/run/mysqld/ \
	&& chmod -R 755 /var/run/mysqld/

RUN 	mkdir -p /var/lib/mysql \
	&& chown mysql:mysql /var/lib/mysql/ \
	&& chmod -R 755 /var/lib/mysql/

EXPOSE	3306

COPY	./tools/dbscript.sh .

RUN	chmod +x ./dbscript.sh && chown mysql:mysql ./dbscript.sh

ENTRYPOINT ["bash", "./dbscript.sh"]