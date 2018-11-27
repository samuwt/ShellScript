#!/bin/bash
clear
echo "---> Script de Montagem\n"
echo
echo "---> Iniciando configurações..."
echo "########################################################################"

echo -e "source /etc/network/interfaces.d/* 
auto lo
iface lo inet loopback
auto eth0
allow-hotplug eth0
iface eth0 inet dhcp" > /etc/network/interfaces

/etc/init.d/networking restart

echo "########################################################################"
ifconfig eth0
echo "########################################################################"
ping -c4 10.107.132.20
echo "########################################################################"
echo "---> Configurando a montagem"
mkdir /mnt/repositorio
echo "########################################################################"
showmount -e 10.107.132.20
echo "########################################################################"
echo
mount -t nfs 10.107.132.20:/home/celso/FTP/Linux/DEBIAN8.3/REP /mnt/repositorio
seq 13 | xargs -I@ echo "deb file:/mnt/repositorio/dvd@ jessie main contrib" > /etc/apt/sources.list
apt-get update
echo "########################################################################"
echo
echo "---> Instalando SSH"
apt-get install openssh-server
echo "########################################################################"
echo
echo "---> Instalando VIM"
apt-get install vim
clear
echo "########################################"
echo "########################################"
echo "##Parabéns! Configuração finalizada :)##"
echo "########################################"
echo "########################################"
echo
