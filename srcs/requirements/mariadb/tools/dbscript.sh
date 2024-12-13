#!/bin/bash
# set -eux

if [ -d /var/lib/mysql/${MYSQL_DATABASE} ]; then
	echo "DATABASE HAS ALREADY BEEN CREATED."

else

	service mariadb start

	sleep 10
	# CREATE THE DATABASE
	mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
	#CREATE THE USER & GRANT PRIVILEGES
	mysql -u root -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER_LOGIN}\`@'wordpress_C.srcs_inception' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';"
	mysql -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER_LOGIN}\`@'wordpress_C.srcs_inception' WITH GRANT OPTION;"
	mysql -u root -e "ALTER USER '${MYSQL_USER_LOGIN}'@'wordpress_C.srcs_inception' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';"
	#CREATE THE ROOT USER	
	mysql -u root -e "CREATE USER IF NOT EXISTS \`${MYSQL_ADMIN_USER}\`@'%' IDENTIFIED BY '${MYSQL_ADMIN_PASSWORD}';"
	mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_ADMIN_USER}'@'%' WITH GRANT OPTION;"
	mysql -u root -e "ALTER USER '${MYSQL_ADMIN_USER}'@'%' IDENTIFIED BY '${MYSQL_ADMIN_PASSWORD}';"
	mysql -u root -p"${MYSQL_ADMIN_PASSWORD}" -e "FLUSH PRIVILEGES;"

	mysql -u root -p"${MYSQL_ADMIN_PASSWORD}" -e "SHUTDOWN;"
	sleep 5
fi

exec mysqld_safe