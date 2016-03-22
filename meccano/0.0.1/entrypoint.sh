#!/bin/sh
echo "gateway"
cd /app/gateway && nohup /usr/bin/npm start > /dev/null &
echo "servicemanager"
cd /app/servicemanager && nohup /usr/bin/npm start > /dev/null &
echo "webconsole"
cd /app/webconsole/dist && /usr/bin/npm start &
