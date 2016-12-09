#!/bin/bash

############################
## Install LAMP 
##
############################

yum install httpd mysql-server php php-mysql

service httpd start
service mysqld start

chkconfig httpd on
chkconfig mysqld on


read -p "Press y to configure MySQL now, or ENTER to skip: " mysql_inst

if [ $mysql_inst=='y']; then
/usr/bin/mysql_secure_installation
fi

