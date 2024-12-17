# use debian as the base image
FROM debian:bullseye

# install MariaDB and other dependencies
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y mariadb-server


# copy the provided config file to the container
# COPY ./conf/my.cnf /etc/mysql/mariadb.conf.d/my.cnf

# RUN mkdir -p /var/run/mysqld
# RUN mkdir -p /var/lib/mysql
# RUN chown mysql:mysql /var/run/mysqld/
# RUN chmod -R 755 /var/run/mysqld/
# RUN chown mysql:mysql /var/lib/mysql/
# RUN chmod -R 755 /var/lib/mysql/

RUN mkdir -p /var/run/mysqld /var/lib/mysql && \
    chown -R mysql:mysql /var/run/mysqld /var/lib/mysql && \
    chmod 777 /var/run/mysqld /var/lib/mysql

EXPOSE 3306

COPY ./tools/dbscript.sh ./
RUN chmod +x ./dbscript.sh

ENTRYPOINT ["bash", "./dbscript.sh"]
