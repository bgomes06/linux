#!/bin/bash

#######################################
## Config menus
##
#######################################

# DETECTING OS...

# OS DETECTEDS
# 1 FOR DEBIAN-LIKE
# 2 FOR FEDORA-LIKE
OS_DETECTED='0'

uname -a | grep 'ubuntu'
if [ $? == 0 ]; then
	echo "OS: DEBIAN-LIKE"
	OS_DT='1'
else
	echo "OS: FEDORA-LIKE"
	OS_DT='2'
fi

function call_debian(){
	echo "$@"
	apt-get -y install "$@"
}

function call_fedora(){
	echo "$@"
	yum -y install "$@"
}


function network_tools(){
	tools=(net-tools traceroute nmap)

	if [ $OS_DT == '1' ]; then
        	call_debian "${tools[@]}";
	else
        	call_fedora "${tools[@]}" ;
	fi
}

	
function lamp(){
	tools=(httpd mysql-server php php-mysql)
	mysql_inst='n'
	
	if [ $OS_DT == '1' ]; then
        	call_debian "${tools[@]}";
	else
        	call_fedora "${tools[@]}" ;
	fi

	service httpd start
	service mysqld start

	chkconfig httpd on
	chkconfig mysqld on

	read -p "Press y to configure MySQL now, or ENTER to skip: " mysql_inst

	if [ $mysql_inst=='y']; then
		/usr/bin/mysql_secure_installation
	fi
}

echo 'Escolha o que deseja fazer: '
echo '1) Ferramentas de rede'
echo '2) Instalação LAMP'
echo '99) Sair'

read -p 'Digite a opção desejada: ' option

while True:
do
	case $option in
		1)
		network_tools
		break
		;;
		2)
		lamp	
		break
		;;
		3)
		;;
		99)
		exit	
		*)
		echo "Opcao invalida! Escolha uma nova opcao ou 99 para sair.
	esac
done

#echo "export myip=`curl ipinfo.io/ip`" >> /root/.bashrc
#source /root/.bashrc
