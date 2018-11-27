#!/bin/bash

######
# Criado por: Samuel Henrique Paes C.
# Data de Criação: 25 de maio de 2017 ás 17:30 de uma quinta-feira
# Última data de modificação: 25 de maio de 2017
# Última data de modificação: 26 de maio de 2017
###### [DATA DE MODIFICAÇÃO SERÁ ZERADA AO INICIO DE OUTRO MÊS (FAÇA MANUALMENTE)]
# Funcionalidade: Atualização automática do sistema de acordo com o que
# o usuário necessitar
######
# VERSÃO -- V1_BETA
######
# INICIANDO

clear

opt='99'
while [ $opt != 0 ]
do
	echo "################# ESCOLHA UM OPÇÃO #################"
	echo "1 - UPDATE"
	echo "2 - UPGRADE"
	echo "3 - LIMPAR CACHE (autoclean)"
	echo "4 - REMOVER PACOTES OBSOLETOS (autoremove)"
	echo "5 - REINICIAR A MÁQUINA"
	echo "10 - RESOLVER ERRO '50unattended-upgrades.ucf-dist'"
	echo "0 - SAIR"
	echo "####################################################"
	echo
	printf ">>> "
	read opt

	case $opt in

	1) # UPDATE
		echo "#### ATUALIZANDO REPOSITÓRIO"
		echo
		apt-get update
		echo
		echo "### REPOSITÓRIO ATUALIZADO"; sleep 2; clear
	;;

	2) # UPGRADE
		echo "#### ATUALIZANDO SISTEMA"
		echo
		apt-get upgrade
		echo
		echo "##### SISTEMA ATUALIZADO"; sleep 2; clear
	;;

	3) # AUTOCLEAN
		echo "#### LIMPANDO CACHE"
		echo
		apt-get autoclean
		echo
		echo "##### O CACHE FOI LIMPO" ; sleep 2; clear
	;;

	4) # AUTOREMOVE
		echo "#### REMOVENDO PACOTES OBSOLETOS"
		echo
		apt-get autoremove
		echo
		echo "### PACOTES OBSOLETOS REMOVIDOS"; sleep 2; clear
	;;

	5) # Reiniciando a máquina
		echo "Quer mesmo desligar a máquina (s/n)"
		printf "> "
		read SN

		if [ $SN = "s" ]
		then
			echo "#### GOOD BY"; sleep 1
			echo "#### I SEE YOU LATER"; sleep 2
			echo
			init 6

		else
			echo "#### Voltando para o menu"; sleep 2; clear
		fi
	;;

	10) # ERRO 50unattended-upgrades.ucf-dist
		echo "#### RESOLVENDO ERRO 50unattended-upgrades.ucf-dist"
		echo
		sudo rm /etc/apt/apt.conf.d/50unattended-upgrades.ucf-dist
		echo
		echo ">> REINICIE A MÁQUINA E ATUALIZE OS PACOTES NOVAMENTE <<"; sleep 4; clear
	;;

	0) # SAIR
		echo "OBRIGADO, VOLTE SEMPRE"
		exit

	;;

	*) # ERROR
		echo
		echo "NÃO RECONHEÇO ESTE CARACTER || VOLTANDO PARA O MENU"
		echo
	;;

	esac
done
