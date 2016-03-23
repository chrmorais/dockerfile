#!/bin/sh
echo "[i] Init MYSQL"
/mysql-startup.sh
echo "[i] Starting Gateway"
cd /app/gateway && nohup /usr/bin/npm start > /dev/null &
echo "[i] Starting ServiceManager"
cd /app/servicemanager && /usr/bin/npm start
echo "[i] Starting Webconsole"
cd /app/webconsole/dist && /usr/bin/npm start
