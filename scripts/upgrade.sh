#!/bin/bash
# stop mysql service
supervisorctl stop mysqld
killall mysqld

export MYSQL_ROOT_PASSWORD=password

# remove mysql-server-5.5 packages
apt-get purge -y --auto-remove mysql-common mysql-server-5.5 mysql-server-core-5.5 mysql-client-5.5 mysql-client-core-5.5 

# install mysql-server-5.6
echo "mysql-server-5.6 mysql-server/root_password password $MYSQL_ROOT_PASSWORD" | debconf-set-selections
echo "mysql-server-5.6 mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD" | debconf-set-selections
apt-get install -y mysql-server-5.6
sed -i 's/bind-address.*/bind-address\=0\.0\.0\.0/g' /etc/mysql/my.cnf


# restart mysql service
supervisorctl restart mysqld

