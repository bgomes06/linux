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

function basic_tools(){
	btools=(vim)

	if [ $OS_DT == '1' ]; then
        	call_debian "${btools[@]}";
	else
        	call_fedora "${btools[@]}" ;
	fi
}

function network_tools(){
	tools=(net-tools traceroute nmap bind-utils)

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

function config_files(){
	
	echo "set number" > /root/.vimrc
	echo "set ic" >> /root/.vimrc
	echo "set autoindent" >> /root/.vimrc
	echo "set tabstop=4" >> /root/.vimrc
	echo "syntax on" >> /root/.vimrc
	echo "colo desert" >> /root/.vimrc
	source /root/.vimrc

	echo "export myip=`curl ipinfo.io/ip`" >> /root/.bashrc
	source /root/.bashrc
	

}


echo 'Escolha o que deseja fazer: '
echo '0) Ferramentas básicas (inclui ferramentas de rede)'
echo '1) Ferramentas de rede'
echo '2) Instalação LAMP'
echo '99) Sair'

read -p 'Digite a opção desejada: ' option

while :
do
	case $option in
		0)
		basic_tools
		network_tools
		break
		;;
		1)
		network_tools
		break
		;;
		2)
		lamp	
		break
		;;
		3)
		break
		;;
		99)
		exit	
		;;
		*)
		echo "Opcao invalida! Escolha uma nova opcao ou 99 para sair."
	esac
done

config_files
