#!/bin/bash

# Add missing components

uname -a | grep 'ubuntu'
if [ $? == 0 ]; then
        apt-get -y install vim net-tools traceroute;
else
        yum -y install vim net-tools traceroute;
fi


# Add myip variable (shows public IP)

echo "export myip=`curl ipinfo.io/ip`" >> /root/.bashrc
source /root/.bashrc
