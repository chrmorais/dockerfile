#!/bin/sh

if [ -d /app/mysql ]; then
  echo "[i] MySQL directory already present, skipping creation"
else
  echo "[i] MySQL data directory not found, creating initial DBs"

  mysql_install_db --user=root > /dev/null

  mkdir -p /run/mysqld /app/mysql

  # Start the MySQL daemon in the background.
  /usr/bin/mysqld &
  mysql_pid=$!

  until mysqladmin ping &>/dev/null; do
    echo -n "."; sleep 0.2
  done

  # Permit root login without password from outside container.
  mysql -e "GRANT ALL ON *.* TO root@'%' IDENTIFIED BY '' WITH GRANT OPTION"

  # create the default database from the ADDed file.
  mysql < /schema.sql

  # Tell the MySQL daemon to shutdown.
  mysqladmin shutdown

  # Wait for the MySQL daemon to exit.
  wait $mysql_pid

  
fi

echo "[i] Starting MYSQL"
nohup /usr/bin/mysqld --user=root --console > /dev/null &
