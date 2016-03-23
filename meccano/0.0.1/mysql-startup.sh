#!/bin/sh

if [ -d /app/mysql ]; then
  echo "[i] MySQL directory already present, skipping creation"
else
  echo "[i] MySQL data directory not found, creating initial DBs"
  mkdir -p /run/mysqld /app/mysql

  echo "[i] MySQL mysql_install_db"
  mysql_install_db --user=root > /dev/null

  echo "[i] MySQL create schema"
  # Start the MySQL daemon in the background.
  nohup /usr/sbin/mysqld > /dev/null &
  mysql_pid=$!

  until mysqladmin ping>/dev/null; do
    echo -n "."; sleep 1;
  done

  echo "[i] MySQL GRANT"
  # Permit root login without password from outside container.
  mysql -e "CREATE USER iot IDENTIFIED BY 'secret$1';GRANT ALL ON *.* TO 'iot'@'%';"

  # create the default database from the ADDed file.
    echo "[i] MySQL schema"
  mysql < /schema.sql

  echo "[i] MySQL shutdown"
  # Tell the MySQL daemon to shutdown.
  mysqladmin shutdown

  # Wait for the MySQL daemon to exit.
  wait $mysql_pid


fi
