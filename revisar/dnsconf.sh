#!/bin/bash

####### SCRIPT PARA INSTALAÇÃO E CONFIGURAÇÃO DO SERVIÇO DNS #######
####################################################################
####### Solicitado por Fernando Leonid.
####### Pensado e criado por Leticia, Mayara, Pamela e Samuel.
####################################################################
####### Data de criação: 17 de maio de 2017.
####### Data de Modificação: 06 de junho de 2017.
####################################################################

# Limpar a tela para melhor vizualização
clear

echo "#### Pingando"; sleep 1
echo
# Testando a conectividade com o servidor.
dhcp=$(ping 10.107.132.20 -c1 |grep received |cut -d ',' -f2)



# Teste do ping -- Estrutura de decisão caso o ping der errado.
if [ "$dhcp" = "0 received " ]
then
	# Configuração da rede se o ping der errado.
	echo "#### Configurando Rede"; sleep 2
	echo

	echo "source /etc/network/interfaces.d/*" > /etc/network/interfaces
	echo "auto lo" >> /etc/network/interfaces
	echo "iface lo inet loopback" >> /etc/network/interfaces
	echo "auto eth0" >> /etc/network/interfaces
	echo "allow-hotplug eth0" >> /etc/network/interfaces
	echo "iface eth0 inet dhcp" >> /etc/network/interfaces

	echo "#### A REDE foi Configurada"; sleep 2
	echo
else
	# Caso o ping de certo então ele diz ao usuário
	echo "#### VOCÊ ESTÁ CONECTADO"; sleep 2
	echo
fi




# Verificando se o BIND está instalado
if [ -d /etc/bind/ ]; then
        echo "### BIND JÁ ESTÁ INSTALADO"; sleep 1
else
       # Caso não esteja ele montará e instalará o BIND
        # MONTANDO REPOSITÓRIO E INSTALANDO BIND
        echo "#### Montando repositório"; sleep 1
        echo

        # Criando um diretório para fazer a montagem do repositório.
        mkdir /mnt/repo

        # Montando o repositório.
        mount -t nfs 10.107.132.20:/home/celso/FTP/Linux/DEBIAN8.5 /mnt/repo

        echo "### CONFIGURANDO SOURCES.LIST"; sleep 1
        echo

        # Configurando o arquivo sources.list.
        seq 8 | xargs -I@ echo "deb file:/mnt/repo/dvd@ jessie main contrib" > /etc/apt/sources.list

        # Ataualizar os pacotes.
        apt-get update
        echo "#### INSTALANDO O BIND"; sleep 1; clear
        echo

        # Instalando o bind.
        apt-get install bind9
        echo
        echo "### BIND INSTALADO"; sleep 2; clear
        echo

fi



# Laço de repetição
opt="99"
while [ '$opt' != "0" ]
do
	# Menu de escolha do script.
	clear
	echo "Escolha uma opção: "
	echo "1 - Criar Zona"
	echo "2 - Excluir Zona"
	echo "3 - Criar Host"
	echo "4 - Excluir Host"
	echo "5 - Listar Zonas"
	echo "6 - Listar Hosts"
	echo "7 - Sobre os Desenvolvedores"
	echo "8 - Sobre o Script"
	echo "0 - Sair"
	echo
	printf "> "
	read opt

	# A variável que guarda a opção escolhida no menu pelo usuário.
	case $opt in

	1) # Caso o usuário digite -1- || CRIAR ZONA

		# Mostrando para o usuário as zonas que já existem
		echo "## ZONAS QUE JÁ EXISTEM"

		cat /etc/bind/named.conf.default-zones | grep zone | tr '"' ' ' | tr '{' ' '
		echo

		# Etapa de criação de ZONA, aqui se pergunta ao usuário qual o nome da ZONA que ele deseja criar.
		printf "Digite o nome da zona que deseja criar: "
		read CZONA

		cat /etc/bind/named.conf.default-zones | grep 'zone "'$CZONA'' | cut -d '.' -f1 | cut -d '"' -f2 > /dev/null
		if [ $? != 0 ]
		then
			# Processo de criação de zona
			echo 'zone "'$CZONA'.com.br" {' >> /etc/bind/named.conf.default-zones
			echo "	type master;" >> /etc/bind/named.conf.default-zones
			echo '	file "/etc/bind/db.'$CZONA'.com.br";' >> /etc/bind/named.conf.default-zones
			echo "};" >> /etc/bind/named.conf.default-zones
			touch /etc/bind/db.$CZONA.com.br

			# Mostrando que foi criado
			echo "$CZONA Criada com Sucesso"; sleep 2
		else
			echo "ESSA ZONA JÁ EXISTE"
			echo "### Voltando para o Menu"
		fi
	;;





	2) # Caso o usuário digite -2- || EXCLUIR ZONA

		# Mostrando para o usuário as zonas que existem
		echo "## ZONAS QUE JÁ EXISTEM"

		cat /etc/bind/named.conf.default-zones | grep zone | tr '"' ' ' | tr '{' ' '
		echo

		# Etapa de exclusão de ZONA.
		printf "Digite o nome da zona que deseja excluir:"
		read ZONA

		sed -i "/$ZONA/, +3d" /etc/bind/named.conf.default-zones
		rm -r /etc/bind/db.$ZONA.com.br
		echo
		echo
		echo "### Zona '$ZONA' foi excluída com SUCESSO"; sleep 2
	;;





	3) # Caso o usuário digite -3- || CRIAR HOST

		# Etapa de criação de HOST, aqui se pergunta ao usuário qual o nome do HOST que ele deseja criar.
		printf "Digite o nome da zona criada: "
		read CZONE

		printf "Digite o IP do HOST: "
		read IP
		IPOK=$(echo $IP|grep -E '^((1[0-9][0-9]|2[0-4][0-9]|25[0-5]|[0-9]?[0-9])\.){3}(1[0-9][0-9]|2[0-4][0-9]|25[0-5]|[0-9]?[0-9])')
                if [ -z $ipok ]
                then
                        echo "'$IP' Este IP é INVÁLIDO"
			echo "### Retornando ao MENU"; sleep 2
                else
                        echo "'$IP' Este IP é VÁLIDO"

			echo "Configuração padrão sendo enviada"
			# Configuração padrão do arquivo db.
			echo '$'"TTL	86400" >> /etc/bind/db.$CZONE.com.br
			echo "@	IN	SOA ns1."$CZONE".com.br.	root."$CZONE".com.br. (" >> /etc/bind/db.$CZONE.com.br
			echo "			1	; Serial" >> /etc/bind/db.$CZONE.com.br
			echo "			86400	; Refresh" >> /etc/bind/db.$CZONE.com.br
			echo "			86400	; Retry" >> /etc/bind/db.$CZONE.com.br
			echo "			86400	; Expire" >> /etc/bind/db.$CZONE.com.br
			echo "			86400 )	; Negative Cache TTL" >> /etc/bind/db.$CZONE.com.br
			echo ";" >> /etc/bind/db.$CZONE.com.br
			echo ";" >> /etc/bind/db.$CZONE.com.br
			echo "@	IN	NS	ns1."$CZONE".com.br." >> /etc/bind/db.$CZONE.com.br
			echo "ns1	IN	A	"$IP >> /etc/bind/db.$CZONE.com.br

			echo "## AVISO> NS1 já foi criado automaticamente"
			printf "Digite o nome do HOST que deseja Criar: "
			read NOME
			echo $NOME"	IN	A	"$IP >> /etc/bind/db.$CZONE.com.br

			echo "### HOST '$NOME' criado com sucesso"
               fi


		# Restartando o serviço do bind9 para que sejam lidas as novas configurações.
		service bind9 restart

		# Monstrando o status para o usuário.
		service bind9 status

		# Informando ao usuário que o serviço bind foi reestartado.
		echo "SERVIÇO BIND REESTARTADO"; sleep 2
	;;





	4) # Caso o usuário digite -4- || EXCLUIR HOST

		# Etapa de exclusão de HOST
		echo "Qual zona deseja excluir (nome_da_zona)"
		printf "> "
		read HOST

		sed -i "/ns1	IN/ d" /etc/bind/db.$HOST.com.br
		echo "### HOST da zona '$HOST' foi excluído com SUCESSO"; sleep 2

	;;





	5) # Caso o usuário digite -5- || LISTAR ZONA

		# Etapa de listagem, aqui se lista as ZONAS CRIADAS PELO USUÁRIO.
		echo "ZONAS CRIADAS"
		cat /etc/bind/named.conf.default-zones | grep db | cut -d '.' -f2,3,4 | grep .br | tr '"' ' ' | tr ';' ' '
		echo
		echo; sleep 5
	;;





	6) # Caso o usuário digite -6- || LISTAR HOST

		echo "ZONAS CRIADAS"
		cat /etc/bind/named.conf.default-zones | grep db | cut -d '.' -f2,3,4 | grep .br | tr '"' ' ' | tr ';' ' '
		echo

		# Etapa de listagem, aqui se lista os HOSTS CRIADOS PELO USUÁRIO.
		echo "De qual zona deseja ver o host? "
		printf "> "
		read HOST

		cat /etc/bind/db.$HOST.com.br | grep 'IN      A' > /dev/null

		# Verificando se existe algum HOST nesse arquivo de banco de dados
		if [ $? != 0 ]
		then
		        echo "NÃO HÁ HOSTS NESTE ARQUIVO!"; sleep 2
		else
			cat /etc/bind/db.$HOST.com.br | grep 'IN      A'
		fi


		echo
		echo; sleep 5

	;;





	7) # Caso o usuário digite -7- || INFORMAÇÕES SORE OS DESENVOLVEDORES

		# INFORMAÇÕES SOBRE OS DESENVOLVEDORES
		echo " Os desenvolvedores desse trabalho são:"; sleep 2
		echo " Leticia Tracanella Ferraz, 1999, São Paulo - SP"; sleep 1
		echo " Mayara Sthefany Campos dos Santos, 2000, Osasco - SP"; sleep 1
		echo " Pamela Vieira, 2000, Francisco Morato - SP"; sleep 1
		echo " Samuel Henrique Paes Cavalcante, 2000, Carapicuiba - SP";sleep 1
	;;





	8) # Caso o usuário digite -8- || INFORMAÇÕES SOBRE O SCRIPT

		# INFORMAÇÕES SOBRE O SCRIPT
		echo "Data de criação: 17 de maio de 2017"; sleep 2
		echo "Data da Ultima modificação: 25 de maio de 2017"; sleep 2
		echo "Local da criação: SENAI ""Prof. Vicente Amato"" - Jandira -SP"; sleep 2
		echo "O objetivo do script é automatizar as tarefas de configuração do serviço DNS, "; sleep 2
		echo "priorizando a otimização do tempo e dos custos!"; sleep 1
	;;





	0) # Caso o usuário digite -0- || SAIR

		echo "Quer mesmo encerrar o SCRIPT? (s/n)"
                printf "> "
                read SN

                if [ $SN = "s" ]
                then
                        echo "#### Obrigado por utilizar este SCRIPT"; sleep 1
                        echo "######################################"; sleep 1
                        echo
                        exit

                else
			echo "## OPÇÃO INVÁLIDA, VOLTANDO PARA O MENU"
                        echo "#### Voltando para o menu"; sleep 1; clear
                fi


	;;

	esac
done
