#!/bin/bash
#set -eux

service mariadb start

# Wait for MariaDB to be ready
# tries to connect as root to Mariadb and launch a simple mysql command to check if it's ready
# dev/null used to suppress output
until mariadb -u root -p"${SQL_ROOT_PASSWORD}" -e "SELECT 1" &>/dev/null; do
  echo "Waiting for MariaDB to be ready..."
  sleep 1
done

# Secure the initial root access and remove default databases
mariadb -u root -p"${SQL_ROOT_PASSWORD}" -e "
  ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
  DELETE FROM mysql.user WHERE User='';
  DROP DATABASE IF EXISTS test;
  FLUSH PRIVILEGES;
"

# Create a new database and user, use env credentials
mariadb -u root -p"${SQL_ROOT_PASSWORD}" -e "
  CREATE DATABASE IF NOT EXISTS ${SQL_DATABASE};
  CREATE USER IF NOT EXISTS '${SQL_USER}'@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';
  GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO '${SQL_USER}'@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';
  FLUSH PRIVILEGES;
"

# Shutdown and restart MariaDB with your specified configuration
mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown
mysqld_safe --user=mysql --port=3306 --bind-address=0.0.0.0 --socket='/run/mysqld/mysqld.sock' --datadir='/var/lib/mysql' --pid-file='/var/run/mysqld/mysqld.pid' --skip-networking=off --max_allowed_packet=64M

echo "MariaDB database and user were created successfully!"
# mariadb -e "CREATE DATABASE IF NOT EXISTS \`abdel\`;"
# mariadb -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"
# mariadb -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
# mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
# mariadb -e "FLUSH PRIVILEGES;"

# mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown
# #mysqladmin -u root shutdown
# # exec mysqld_safe
# mysqld_safe --port=3306 --bind-address=0.0.0.0 --socket='/run/mysqld/mysqld.sock' --user=mysql --datadir='/var/lib/mysql'
# #print status