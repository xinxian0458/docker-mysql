#!/bin/bash
service mysql start
sleep 5s

mysql -uroot -ppassword<<EOF
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

apt-get install -y supervisor
sh -c 'echo ";mysql" >> /etc/supervisor/supervisord.conf' && \
sh -c 'echo "[program:mysqld]" >> /etc/supervisor/supervisord.conf' && \
sh -c 'echo "command=/usr/bin/mysqld_safe" >> /etc/supervisor/supervisord.conf' && \
sh -c 'echo "stopsignal=6" >> /etc/supervisor/supervisord.conf'

killall mysqld
sleep 10s

supervisord -n
