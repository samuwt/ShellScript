#!/bin/bash

#Autores do SSHi3: Felipe Almeida; Jéssica Caroline; Jhonatas Lima; Matheus Costa.
#Participação Especial: Professor Rogério; Samuel Henrique.
#Última edição: 08/06/2017 10:46
#Nome do programa: SSHi3
#Versão: BETA 1.0
#Nome do arquivo: ssh.sh.bkp
#Função Principal: Realizar configurações básicas no SSH,
#e permitir ao usuário autorizado, realizar alterações de acesso de maneira prática
#através de um menu de opções.
#Funções Secundárias: Estabelecer Rede, Instalar Pacotes, Criar Arquivo de BKP.
#Número de linhas do Programa: 402 Linhas
clear

#Central de Cores
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
	echo "Bem-Vindo ao BETA SSHi3 === Versão 1.0 "
else
	mv /etc/ssh/sshd_config /etc/ssh/sshd_config.bkp
	echo $green
	echo "Arquivo de Backup criado com SUCESSO!!!"
sleep 2; clear
	echo -e $cyan
	echo "INICIANDO MENU DE OPÇÕES. . ."
sleep 2; clear
	echo "Bem-Vindo ao BETA SSHi3 === Versão 1.0 "
fi

sleep 2; clear

echo "Aplicando configurações básicas"

sleep 1; clear

cat /etc/ssh/sshd_config | grep Port > /dev/null

if [ $? != 0 ]
then
	echo "Port 22" >> /etc/ssh/sshd_config
	echo "protocol 2" >> /etc/ssh/sshd_config
	echo "PermitRootLogin no" >> /etc/ssh/sshd_config
	echo "AllowUsers aluno" >> /etc/ssh/sshd_config
	echo "DenyUsers aluno" >> /etc/ssh/sshd_config
	echo "ClientAliveInterval 600" >> /etc/ssh/sshd_config
	echo "ClientAliveCountMax 0 " >> /etc/ssh/sshd_config
	echo "Banner /etc/motd" >> /etc/ssh/sshd_config
	echo "PrintMotd yes" >> /etc/ssh/sshd_config
	echo "Configurações padrões aplicadas"

sleep 2; clear

else
	echo "Configurações Básicas já foram aplicadas"

sleep 2; clear

fi

resp="99"
while [ resp != "0" ]
do

	echo -e $cyan
	echo "BETA SSHi3 === Versão 1.0"
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
			#Enviando resposta de usuário para arquivo de configuração
			portalta=$(cat /etc/ssh/sshd_config | grep Port | tr ' ' '#' | cut -d '#' -f2)
			cat /etc/ssh/sshd_config | grep Port | tr ' ' '#' | cut -d '#' -f2 > /dev/null

			if [ $? != 0 ]
			then
				echo "Port 22" >> /etc/ssh/sshd_config
			else
				echo -e $green
				echo "Porta alterada com SUCESSO!!! "
				echo -e $yellow
				echo "Porta Definida = $port "
				echo -e $padrao


				sed -ri "s/Port .*/Port $port/" /etc/ssh/sshd_config




			fi
sleep 3; clear
		fi
		service ssh restart > /dev/null
	;;
	3)
		#Bloquear ou Desbloquear Root
		echo -e $yellow
		echo "Definir Permissão de Acesso para o Root "
		echo -e $padrao
		echo "Bloquear (no) Desbloquear (yes) "
		printf ">"
		read root

		#Enviando resposta de usuário para arquivo de configuração
		root2=$(cat /etc/ssh/sshd_config | grep PermitRootLogin | tr ' ' '#' | cut -d '#' -f2)
		cat /etc/ssh/sshd_config | grep PermitRootLogin | tr ' ' '#' | cut -d '#' -f2 > /dev/null

		if [ $? != 0 ]
		then
			echo "PermitRootLogin no" >> /etc/ssh/sshd_config
		else
			echo -e $green
			echo "Acesso do Root Configurado com SUCESSO!!!"
			echo -e $padrao

			sed -i 's/PermitRootLogin '$root2'/PermitRootLogin '$root'/g' /etc/ssh/sshd_config

		fi
		service ssh restart > /dev/null

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

		#Enviando resposta de usuário para arquivo de configuração
		users2=$(cat /etc/ssh/sshd_config | grep AllowUsers | tr ' ' '#' | cut -d '#' -f2)
		cat /etc/ssh/sshd_config | grep AllowUsers | tr ' ' '#' | cut -d '#' -f2 > /dev/null

		if [ $? != 0 ]
		then
			echo "AllowUsers aluno" >> /etc/ssh/sshd_config
		else
			echo -e $green
			echo "Usuário $users definido com SUCESSO!!! "
			echo -e $padrao

			sed -i 's/AllowUsers '$users2'/AllowUsers '$users'/g' /etc/ssh/sshd_config
		fi
		service ssh restart > /dev/null

sleep 3; clear
	;;
	5)
		#Bloquear Users
		echo -e $yellow
		echo "Negar usuários"
		echo "Informe o NOME  do USUÁRIO criado ou já existente "
		printf ">"
		read nega

		#Enviando resposta de usuário para arquivo de configuração
		nega2=$(cat /etc/ssh/sshd_config | grep DenyUsers | tr ' ' '#' | cut -d '#' -f2)
		cat /etc/ssh/sshd_config | grep DenyUsers | tr ' ' '#' | cut -d '#' -f2 > /dev/null

		if [ $? != 0 ]
		then
			echo "DenyUsers aluno" >> /etc/ssh/sshd_config
		else
			echo -e $green
			echo "Usuário $nega negado com SUCESSO!!!"
			echo -e $padrao

			sed -i 's/DenyUsers '$nega2'/DenyUsers '$nega'/g' /etc/ssh/sshd_config
		fi
		service ssh restart > /dev/null

sleep 3; clear
	;;
	6)
		#Definir tempo de ausência
		echo -e $yellow
		echo "Definir Timeout"
		echo "Informe o tempo de inatividade da conexão "
		printf ">"
		read time

		#Enviando resposta de usuário para arquivo de configuração
		time2=$(cat /etc/ssh/sshd_config | grep ClientAliveInterval | tr ' ' '#' | cut -d '#' -f2)
		cat /etc/ssh/sshd_config | grep ClientAliveInterval | tr ' ' '#' | cut -d '#' -f2 > /dev/null

		if [ $? != 0 ]
		then
			echo "ClientAliveInterval 600" >> /etc/ssh/sshd_config
		else
			echo -e $green
			echo "O tempo de inatividade definido com SUCESSO!!!"
			sed -i 's/ClientAliveInterval '$time2'/ClientAliveInterval '$time'/g' /etc/ssh/sshd_config
		fi
		service ssh restart > /dev/null

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

		echo -e $green
		echo "Banner de Acesso Configurado com SUCESSO!!!"
		echo -e $padrao

		#Enviando banner para arquivo de configuração
		banner2=$(cat /etc/ssh/sshd_config | grep Banner | tr ' ' '#' | cut -d '#' -f2)
		cat /etc/ssh/sshd_config | grep Banner | tr ' ' '#' | cut -d '#' -f2 > /dev/null

		if [ $? != 0 ]
		then
			echo "Banner /etc/motd" >> /etc/ssh/sshd_config
		fi
		service ssh restart > /dev/null

sleep 3; clear
	;;
	8)
		#Mostrando configurações SSH
		echo -e $yellow
		echo "Configurações Atuais do SSH "
		echo -e $padrao
		cat /etc/ssh/sshd_config
		service ssh restart > /dev/null
sleep 5; clear
	;;
	0)
		#Sair
		echo -e $green
		echo "Obrigado por Utilizar o nosso Script =) "
		sleep 3; clear
		echo "###############"
		echo "###CRÉDITOS####"
		echo "###############"
		echo
		echo -e $padrao
		echo "Felipe Almeida (BloodRoyale)"
		echo "Jéssica Caroline (Pudimzinho)"
		echo "Samuel Henrique (ItsWatterson)"
		echo
		echo -e $green
		echo "##################"
		echo "##COLABORADORES###"
		echo "##################"
		echo
		echo -e $padrao
		echo "Matheus Costa (Detona), Jhonatas Lima (Jaba)"
		echo
		echo -e $green
		echo "######################"
		echo "##ESTRUTURA/PADRÕES###"
		echo "######################"
		echo
		echo -e $padrao
		echo "Felipe Almeida (BloodRoyale), Jéssica Caroline (Pudimzinho)"
		echo
		echo -e $green
		echo "##########################"
		echo "##PARTICIPAÇÃO ESPECIAL###"
		echo "##########################"
		echo
		echo -e $padrao
		echo "Samuel Henrique (ItsWatterson)"
		sleep 10; clear
		exit
	;;
	*)
		#Opção Inválida
		echo -e $red
		echo "Opção Inválida == TENTE OUTRA VEZ "
		echo -e $padrao
		sleep 1; clear
	esac
done
