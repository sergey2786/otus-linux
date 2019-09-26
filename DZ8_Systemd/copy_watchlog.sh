#!/bin/bash 
cd 1
cp watchlog /etc/sysconfig/ && cp watchlog.sh /opt/watchlog.sh && cp watchlog.log /var/log/watchlog.log
chmod +x /opt/watchlog.sh
cp watchlog.service /etc/systemd/system/ && cp watchlog.timer /etc/systemd/system/
systemctl daemon-reload
systemctl start watchlog.timer
