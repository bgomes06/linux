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
echo '3) '
echo '99) Sair'

read -p 'Digite a opção desejada: ' option

case $option in
	1)
	network_tools
	;;
	2)
	echo '2'
	;;
	3)
	echo '3'
	;;
	99)
	echo '99'
	;;
esac


#echo "export myip=`curl ipinfo.io/ip`" >> /root/.bashrc
#source /root/.bashrc
