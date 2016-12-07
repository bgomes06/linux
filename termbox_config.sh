#!/bin/bash

# Add missing components

yum -y install vim net-tools traceroute;


# Add myip variable (shows public IP)

echo "alias myip=`curl ipinfo.io/ip`" >> /root/.bashrc


