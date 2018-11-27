#!/bin/bash
clear

#######################################################################################################
#Responsável: Felipe Almeida - Blood Royale

#Criação: 18/05/2017

#Modificação: 18/05/2017

#Função: Preparar o Arquivo de Configuração Padrão do Firewall --iptables--
#######################################################################################################

#INICIANDO SCRIPT
echo -e "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo -e "!!!!!!!!Iniciando a Configuração do Firewall!!!!!!!!!"
echo -e "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
sleep 3; clear

#Zerando todas as Regras
echo "ZERANDO REGRAS"
echo "......................."
echo
sleep 2
echo "REGRAS ZERADAS!!!"
iptables -F

sleep 3; clear

#ESTABELECENDO POLÍTICA
echo "CONFIGURANDO POLÍTICA"
echo ".............................."
echo
sleep 2
echo "POLÍTICA RESTRITIVA HABILITADA"
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

sleep 3; clear

#A rede interna deve acessar HTTP, HTTPS, FTP, SMTP e IMAP externos
echo "CONFIGURANDO ACESSOS PARA A REDE INTERNA"
echo "HTTP - HTTPS - FTP - SMTP - IMAP"
echo
sleep 2
echo "ACESSO DEFINIDO!!!"
iptables -A INPUT -p tcp -d 192.168.1.10/24 -m multiport --dports 80,443,21,25,143 -j ACCEPT
iptables -A OUTPUT -p tcp -d 192.168.1.10/24 -m multiport --sports 80,443,21,25,143 -j ACCEPT
iptables -A FORWARD -p tcp -d 192.168.1.10/24 -m multiport --dports 80,443,21,25,143 -j ACCEPT

iptables -A INPUT -p tcp -d 192.168.1.11/24 -m multiport --dports 80,443,21,25,143 -j ACCEPT
iptables -A OUTPUT -p tcp -d 192.168.1.11/24 -m multiport --sports 80,443,21,25,143 -j ACCEPT
iptables -A FORWARD -p tcp -d 192.168.1.11/24 -m multiport --dports 80,443,21,25,143 -j ACCEPT

sleep 3; clear

#O firewall deve aceitar conexões ssh da rede interna
echo "CONFIGURANDO REDE PARA ACESSO SSH"
echo "............................................."
echo
sleep 2
echo "ACESSO CONFIGURADO!!!"
iptables -A INPUT -p tcp -m tcp --dport 22 -i eth1 -j ACCEPT

sleep 3; clear

#Aceitar pacotes ICMP originados da rede interna
echo "CONFIGURAÇÃO PARA ACESSO DE PACOTES ICMP"
echo
sleep 2
echo "PACOTES ICMP CONFIGURADO PARA SEREM ACEITADOS!!!"
iptables -A INPUT -p icmp --icmp-type 8 -s 192.168.1.0 -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type 8 -s 192.168.1.0 -j ACCEPT
iptables -A FORWARD -p icmp --icmp-type 8 -s 192.168.1.0 -j ACCEPT

sleep 2; clear

#FINALIZANDO SCRIPT
echo -e "##########CONFIGURAÇÕES DO IPTABLES APLICADAS##########"
sleep 1
echo -e "##########SEU FIREWALL FOI CONFIGURADO COM SUCESSO!!!##########"
sleep 1
echo -e "##########FINALIZANDO SCRIPT EM 3 SEGUNDOS...##########"

sleep 1; clear

echo -e "3..."
sleep 1
echo -e "2.."
sleep 1
echo -e "1."
sleep 1
echo -e "bye ^^"
sleep 2; clear

exit
