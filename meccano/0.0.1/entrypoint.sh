#!/bin/sh
echo "[i] Starting MYSQL"
nohup /usr/sbin/mysqld --user=root --console > /dev/null &
echo "[i] Starting Gateway"
cd /app/gateway && nohup npm start > /dev/null &
echo "[i] Starting ServiceManager"
cd /app/servicemanager && nohup npm start  > /dev/null &
echo "[i] Starting Webconsole"
cd /app/webconsole/dist && npm start > /dev/null
