#!/bin/bash

echo “DEFININDO VARIAVEIS”
IPTABLES=/usr/sbin/iptables
echo “OK”

echo “LIMPANDO TABELA FILTER”
$IPTABLES -t filter -F
$IPTABLES -t filter -P INPUT ACCEPT
$IPTABLES -t filter -P OUTPUT ACCEPT
$IPTABLES -t filter -P FORWARD ACCEPT
$IPTABLES -t filter -X
echo “OK”
echo “LIMPANDO TABELA NAT”
$IPTABLES -t nat -F
$IPTABLES -t nat -P PREROUTING ACCEPT
$IPTABLES -t nat -P OUTPUT ACCEPT
$IPTABLES -t nat -P POSTROUTING ACCEPT
$IPTABLES -t nat -X
echo “OK”
echo “LIMPANDO TABELA MANGLE”
$IPTABLES -t mangle -F
$IPTABLES -t mangle -P PREROUTING ACCEPT
$IPTABLES -t mangle -P INPUT ACCEPT
$IPTABLES -t mangle -P FORWARD ACCEPT
$IPTABLES -t mangle -P OUTPUT ACCEPT
$IPTABLES -t mangle -P POSTROUTING ACCEPT
$IPTABLES -t mangle -X
echo “OK”

echo “-LIBERAR ACESSO PELO LINK DE INTERNET”
$IPTABLES -t nat -A POSTROUTING -s 192.168.1.0/255.255.255.0 -o eno1 -j MASQUERADE
$IPTABLES -t nat -A POSTROUTING -s 192.168.2.0/255.255.255.0 -o ens3f0 -j MASQUERADE
echo “—OK”

echo “-ATIVANDO NAT”
echo 1 > /proc/sys/net/ipv4/ip_forward
$IPTABLES -A FORWARD -s 192.168.2.0/24 -j ACCEPT
$IPTABLES -A FORWARD -d 192.168.2.0/24 -j ACCEPT
$IPTABLES -t nat -A POSTROUTING -o eno1 -s 192.168.1.0/24 -j MASQUERADE
$IPTABLES -t nat -A POSTROUTING -o ens3f0 -s 192.168.2.0/24 -j MASQUERADE
$IPTABLES -t nat -A POSTROUTING -o ens3f0 -j MASQUERADE
echo “—OK”

## FORCE CONNECTIONS THROUGH SQUID

$IPTABLES -t nat -A PREROUTING -s 192.168.1.0/255.255.255.0 -p tcp --dport 80 -j REDIRECT --to-port 3128
#$IPTABLES -t nat -A PREROUTING -s 192.168.1.0/255.255.255.0 -p tcp --dport 443 -j REDIRECT --to-port 3128

echo "Adding new firewall rules..."
$IPTABLES -I INPUT -s 192.168.1.22 -p ICMP --icmp-type 8 -j ACCEPT
$IPTABLES -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
$IPTABLES -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
$IPTABLES -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
$IPTABLES -A INPUT -i lo -j ACCEPT
$IPTABLES -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
$IPTABLES -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
$IPTABLES -A INPUT -p tcp -m tcp --dport 25 -j ACCEPT
$IPTABLES -A INPUT -p tcp -m tcp --dport 465 -j ACCEPT
$IPTABLES -A INPUT -p tcp -m tcp --dport 110 -j ACCEPT
$IPTABLES -A INPUT -p tcp -m tcp --dport 995 -j ACCEPT
$IPTABLES -A INPUT -p tcp -m tcp --dport 143 -j ACCEPT
$IPTABLES -A INPUT -p tcp -m tcp --dport 993 -j ACCEPT
$IPTABLES -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
#$IPTABLES -A INPUT -p tcp -s YOUR_IP_ADDRESS -m tcp --dport 22 -j ACCEPT
$IPTABLES -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
   
##  DEFAULT RULES FOR TABLES
##$IPTABLES -P OUTPUT ACCEPT
##$IPTABLES -P INPUT DROP

echo "Saving and restarting iptables service..."
sleep 2

service iptables save
systemctl restart iptables

sleep 1

echo “-REGRAS APLICADAS”
$IPTABLES -t nat -nL
$IPTABLES -t filter -nL
$IPTABLES -t mangle -nL
$IPTABLES -nL
echo “—OK”

