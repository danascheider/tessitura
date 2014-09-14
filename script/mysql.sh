#!/usr/bin/env bash

echo mysql-server mysql-server/root_password select "vagrant" | debconf-set-selections
echo mysql-server mysql-server/root_password_again select "vagrant" | debconf-set-selections

sudo -i
apt-get install -y mysql-server libmysql-ruby libmysqlclient-dev

mysql -u root -p vagrant

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf
service mysql restart

exit