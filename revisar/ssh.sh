#!/bin/bash

#Autores: Felipe Almeida; Jéssica Caroline; Jhonatas Lima; Matheus de Costas


clear

padrao="\033[m"
cyan="\033[0;36m"
red="\033[0;31m"
green="\033[0;32m"
yellow="\033[0;33m"

# Configurando o IP para DHCP
dhcp=$(ping 10.107.136.20 -c1 |grep received |cut -d ',' -f2)
if [ "$dhcp" = " 1 received" ]
then
	echo -e $green
	echo "IP configurado!"
else
	echo "source /etc/network/interfaces.d/*" > /etc/network/interfaces
	echo "auto lo" >> /etc/network/interfaces
	echo "iface lo inet loopback" >> /etc/network/interfaces
	echo "allow-hotplug eth0" >> /etc/network/interfaces
	echo "iface eth0 inet dhcp" >> /etc/network/interfaces
fi

# Configuração para a montagem do pacote openssh-server
echo -e $cyan
echo "Verificando se o serviço SSH está Instalado..."
echo
dpkg -l |grep openssh-server
if [ $? = 0 ]
then
	echo
	echo -e $green
	echo "SSH já existe em sua máquina!"
else
	mkdir /mnt/repo
	mount -t nfs 10.107.132.20:/home/celso/FTP/Linux/DEBIAN8.5 /mnt/repo
	seq 8 |xargs -I@ echo "deb file:/mnt/repo/dvd@ jessie main contrib" > /etc/apt/sources.list
	apt-get update
	apt-get install openssh-server
fi

sleep 2; clear

# Configuração para não permitir mais de um bkp
echo -e $cyan
echo "===Analisando Processos para BACKUP==="
echo
dir=/etc/ssh/
file=sshd_config.bkp
if [ -e "$dir$file" ]
then
	echo -e $green
	echo "Arquivo de Backup já existe "
sleep 2; clear
	echo -e $cyan
	echo "INICIANDO MENU DE OPÇÕES. . ."
sleep 2; clear
	echo "Bem-Vindo ao BETA SSHi3 === Versão 0.1 "
else
	mv /etc/ssh/sshd_config /etc/ssh/sshd_config.bkp
	echo $green
	echo "Arquivo de Backup criado com SUCESSO!!!"
sleep 2; clear
	echo -e $cyan
	echo "INICIANDO MENU DE OPÇÕES. . ."
sleep 2; clear
	echo "Bem-Vindo ao BETA SSHi3 === Versão 0.1 "
fi

sleep 2; clear

resp="99"
while [ resp != "0" ]
do

	echo -e $cyan
	echo "BETA SSHi3 === Versão 0.1"
	echo -e $padrao
	echo "Configurações do SSH! "
	echo "Escolha uma opção que deseja alterar: "
	echo "============================================================"
	echo "1 - Iniciar/Parar "
	echo "2 - Alterar porta padrão "
	echo "3 - Bloquear/Desbloquear Root "
	echo "4 - Permitir usuários "
	echo "5 - Negar usuários  "
	echo "6 - Definir TimeOut "
	echo "7 - Definir Banner de acesso "
	echo "8 - Mostrar Configurações atuais do SSH "
	echo "0 - Sair "
	echo "============================================================="
	echo
	printf "> "
	read resp

	case $resp in
	1)
		#Iniciar e Parar
		opt1=$(service ssh status |grep "inactive" |cut -d ':' -f2)
		if [ -n "$opt1" ]
		then
        		echo -e $yellow
			echo "Iniciar (s,n) "
			printf ">"
        		read opt2
        		if [ "$opt2" = "s" ]
        		then
                		/etc/init.d/ssh start

        		fi
		else
        		echo -e $yellow
			echo "Parar (s,n) "
			printf ">"
        		read opt2
        		if [ "$opt2" = "s" ]
        		then
                		/etc/init.d/ssh stop

        		fi
		fi

sleep 2; clear

echo -e $padrao

	;;
	2)
		#Alterar Porta de acesso
		echo -e $yellow
		echo "Alterar Porta de Acesso (acima de 5000) "
		echo "Informe o Número de Porta "
		printf ">"
		read port
		echo
		if [ $port -lt 5000 ]
		then
			echo -e $red
			echo "PORTA INVÁLIDA!!! "
			echo
			echo "Escolha uma porta acima de 5000. Por Favor! "
			echo -e $padrao
sleep 3; clear
		else
			echo -e $green
			echo "Porta alterada com SUCESSO!!! "
			echo -e $yellow
			echo "Porta Definida = $port "
			echo -e $padrao
sleep 3; clear
		fi
		sed -i 's/^Port=.*/Port=$port/' /etc/ssh/sshd_config
	;;
	3)
		#Bloquear ou Desbloquear Root
		echo -e $yellow
		echo "Definir Permissão de Acesso para o Root "
		echo -e $padrao
		echo "Bloquear (no) Desbloquear (yes) "
		printf ">"
		read root
		echo -e $green
		echo "Acesso do Root Configurado com SUCESSO!!!"
		echo -e padrao
		sed -i 's/^PermitRootLogin=.*/PermitRootLogin $root' /etc/ssh/sshd_config
sleep 3; clear
	;;
	4)
		#Permitir  Users
		echo -e $yellow
		echo "Permitir Usuários"
		echo
		echo "Informe o NOME do USUÁRIO criado ou já existente "
		printf ">"
		read users
		echo -e $green
		echo "Usuário $users definido com SUCESSO!!! "
		echo -e $padrao
		sed -i 's/^AllowUsers=.*/AllowUsers $users' /etc/ssh/sshd_config
sleep 3; clear
	;;
	5)
		#Bloquear Users
		echo -e $yellow
		echo "Negar usuários"
		echo "Informe o NOME  do USUÁRIO criado ou já existente "
		printf ">"
		read nega
		echo -e $green
		echo "Usuário $users negado com SUCESSO!!!"
		echo -e $padrao
		sed -i 's/^DenyUsers=.*/DenyUsers $nega' /etc/ssh/sshd_config
sleep 3; clear
	;;
	6)
		#Definir tempo de ausência
		echo -e $yellow
		echo "Definir Timeout"
		echo "Informe o tempo de inatividade da conexão "
		printf ">"
		read time
		echo -e $green
		echo "O tempo de inatividade definido com SUCESSO!!!"
		sed -i 's/^protocol 2/protocol 2' /etc/ssh/sshd_config
		sed -i 's/^ClientAliveInterval=.*/ClientAliveInterval $time' /etc/ssh/sshd_config
		sed -i 's/^ClientAliveCountMax 0/ClientAliveCountMax 0' /etc/ssh/sshs_config
sleep 3; clear
	;;
	7)
		#Definir banner
		echo -e $yellow
		echo "Definir o Banner"
		echo "Escreva seu Texto "
		printf ">"
		read banner
		echo -e $green
		echo "O Texto Definido para o Banner é:"
		echo -e $padrao
		echo "$banner"
		echo "$banner" > /etc/motd
		sed -i 's/Banner /etc/motd=.*/Banner /etc/motd' /etc/ssh/sshd_config
sleep 3; clear
	;;
	8)
		#Mostrando configurações SSH
		echo -e $yellow
		echo "Configurações Atuais do SSH "
		echo -e $padrao
		cat /etc/ssh/sshd_config
sleep 10; clear
	;;
	0)
		#Sair
		echo -e $cyan
		echo "Obrigado por Utilizar o nosso Script =) "
		echo -e $padrao
		sleep 1; clear
		exit
	;;
	*)
		#Opção Inválida
		echo -e $red
		echo "Opção Inválida "
		echo -e $padrao
		sleep 1; clear
	esac
done
