#!/bin/bash

#################################################
##### Main functions menu
##### Author: Bruno Gomes
##### Last update: 27/01/17
#################################################

#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37

GREEN='\033[0;32m'
RED='\033[0;31m'
LCYAN='\033[1;36m'
NC='\033[0m' # No Color

##### Functions:

function network_restart(){
	systemctl network restart
}

function firewall_restart(){
	systemctl restart iptables
}

function proxy_restart(){
	systemctl restart squid
}

function firewall_clear(){
	/root/scripts/firewall_clear.sh
}

function firewall_default(){
	/root/scripts/firewall_script.sh
}

function sqreport_update(){
	/usr/local/bin/squid-analyzer /var/log/squid/access.log	
	/usr/local/bin/squid-analyzer /var/log/squid/cache.log	
}

function system_update(){
	yum -y update
}

function success(){
	echo -e "${GREEN}SUCCESS!! ${NC}"
	echo -e "${GREEN}SUCCESS!! ${NC}"
	echo -e "${GREEN}SUCCESS!! ${NC}"
	sleep 3
}

function failure(){
	echo -e "${RED}FAILURE!! ${NC}"
	echo -e "${RED}FAILURE!! ${NC}"
	echo -e "${RED}FAILURE!! ${NC}"
	sleep 3
}

while : 
do

clear

echo "
Menu de funções
Selecione uma função:

1) Update system
2) Network restart
3) Firewall restart
4) Proxy restart
5) Firewall clear (keep forwarding config)
6) Firewall basic rules 
7) Squid Report update now
99) exit 
"

	if [ ! -z "$1" ]; then
		echo -e "${LCYAN}Opção informada: "$1 ${NC}
		option=$1
	else
		echo "Insira sua opção: "
		read option
	fi
	case $option in
		1) 
		system_update && success || failure
		;;
		2) 
		network_restart && success || failure
		;;
		3)
		firewall_restart && success || failure
		;;
		4)
		proxy_restart && success || failure
		;;
		5)
		firewall_clear && success || failure
		;;
		6)
		firewall_default && success || failure
		;;
		7)
		sqreport_update && success || failure
		;;
		99)
		exit
		;;
		*)
		echo "Opção inválida!"
	esac
	if [ ! -z "$1" ]; then
		exit
	fi
done

