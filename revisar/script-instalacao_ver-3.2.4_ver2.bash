#!/bin/bash

#############################################################
#                  Instalação Zabbix-3.2.4					#
# Pacotes sendo instalados sem a necessidade de confirmação	#
#############################################################

clear
printf "\n\033[41;1;38mInstalação Zabbix 2017\033[0;0m\n\n"
apt-get update > /dev/null 2> /dev/null
if [ $? != 0 ]; then 
	printf "\n\033[31mFalha na atualização do repositório Debian\033[0;0m\n\n"
	echo ""
else
	printf "\n\033[44;1;38m1. Instalado dependências\033[0;0m\n\n"
	# sleep 2
	apt-get install build-essential snmp vim libssh2-1-dev libssh2-1 libopenipmi-dev -y --force-yes
	if [ $? != 0 ]; then 
		printf "\n\033[31mFalha na Instalação de alguns pacotes\033[0;0m\n\n"
		echo ""
	else
		apt-get install libsnmp-dev wget libcurl4-gnutls-dev fping libxml2 libxml2-dev curl libcurl3-gnutls -y --force-yes
		if [ $? != 0 ]; then 
			printf "\n\033[31mFalha na Instalação de alguns pacotes\033[0;0m\n\n"
			echo ""
		else
			apt-get install libcurl3-gnutls-dev libiksemel-dev libiksemel-utils libiksemel3 sudo -y --force-yes
			if [ $? != 0 ]; then 
				printf "\n\033[31mFalha na Instalação de alguns pacotes\033[0;0m\n\n"
				echo ""
			else
				apt-get install apache2 php5 php5-mysql libapache2-mod-php5 php5-gd -y --force-yes
				if [ $? != 0 ]; then 
					printf "\n\033[31mFalha na Instalação de alguns pacotes\033[0;0m\n\n"
					echo ""
				else
					apt-get install libpq5 libpq-dev mysql-server mysql-client libmysqld-dev -y --force-yes
					if [ $? != 0 ]; then 
						printf "\n\033[31mFalha na Instalação de alguns pacotes\033[0;0m\n\n"
						echo ""
					else
						printf "\n\033[44;1;38m2. Criando o banco de dados no MySQL\033[0;0m\n\n"
						mysql -u root -pmysql -e "create database zabbix character set utf8;"
						mysql -u root -pmysql -e "GRANT ALL PRIVILEGES ON *.* TO zabbix@localhost IDENTIFIED BY 'zabbix' WITH GRANT OPTION;"
						if [ $? != 0 ]; then 
							printf "\n\033[31mFalha na criação do banco de dados no MySQL\033[0;0m\n\n"
							echo ""
						else
							printf "\n\033[44;1;38m3. Configurando o PHP\033[0;0m\n\n"
							sed -i 's/;date.timezone =/date.timezone = "America\/Sao_Paulo"/g' /etc/php5/apache2/php.ini
							sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php5/apache2/php.ini
							sed -i 's/max_input_time = 60/max_input_time = 300/g' /etc/php5/apache2/php.ini
							sed -i 's/post_max_size = 8M/post_max_size = 16M/g' /etc/php5/apache2/php.ini
							sed -i 's/;always_populate_raw_post_data = -1/always_populate_raw_post_data = -1/g' /etc/php5/apache2/php.ini
							/etc/init.d/apache2 restart
							if [ $? != 0 ]; then 
								printf "\n\033[31mFalha na configuração do PHP\033[0;0m\n\n"
								echo ""
							else
								printf "\n\033[44;1;38m4. Instalando o Zabbix\033[0;0m\n\n"
								sleep 2
								printf "\n\033[36m4.1. Criando usuário zabbix, descompactando tarball e populando banco\033[0;0m\n\n"
								sleep 2
								adduser zabbix
								cp zabbix-3.2.4.tar.gz /usr/src
								cd /usr/src
								tar -zxvf zabbix-3.2.4.tar.gz
								chmod -R +x zabbix-3.2.4
								printf "\n\033[36m4.2. Populando o banco de dados no MySQL\033[0;0m\n\n"
								cat zabbix-3.2.4/database/mysql/schema.sql |mysql -uzabbix -pzabbix zabbix
								cat zabbix-3.2.4/database/mysql/images.sql | mysql -uzabbix -pzabbix zabbix
								cat zabbix-3.2.4/database/mysql/data.sql | mysql -uzabbix -pzabbix zabbix
								
								printf "\n\033[36m4.3. Compilando e Instalando Zabbix\033[0;0m\n\n"
								# sleep 2
								cd zabbix-3.2.4/
								./configure --enable-server --enable-agent --with-mysql --with-jabber=/usr --with-libcurl=/usr/bin/curl-config --with-ssh2 --with-openipmi --with-libxml2 --with-net-snmp && printf "\n\033[45;1;32mConfigurado\033[0;0m\n\n"
								echo ""
								# sleep 2
								make install && printf "\n\033[45;1;32mCompilado e Instalado\033[0;0m\n\n"
								# sleep 2
								if [ $? != 0 ]; then 
									printf "\n\033[31mFalha na Compilação e Instalação Zabbix\033[0;0m\n\n"
									echo ""
								else	
									printf "\n\033[44;1;38m5. Configurando Zabbix\033[0;0m\n\n"
									# sleep 2
									printf "\n\033[36m5.1. Configurando Agent Zabbix\033[0;0m\n\n"
									sleep 2
									sed -i 's/# PidFile=\/tmp\/zabbix_agentd.pid/PidFile=\/tmp\/zabbix_agentd.pid/g' /usr/local/etc/zabbix_agentd.conf
									sed -i 's/# LogFileSize=1/LogFileSize=2/g' /usr/local/etc/zabbix_agentd.conf
									sed -i 's/# DebugLevel=3/DebugLevel=3/g' /usr/local/etc/zabbix_agentd.conf
									sed -i 's/# ListenPort=10050/ListenPort=10050/g' /usr/local/etc/zabbix_agentd.conf
								
									sed -i 's/Hostname=Zabbix server/Hostname=zabbixServer/g' /usr/local/etc/zabbix_agentd.conf
									sed -i 's/debian/zabbixServer/g' /etc/hostname
								
									sed -i 's/# Timeout=3/Timeout=3/g' /usr/local/etc/zabbix_agentd.conf
								
									printf "\n\033[36m5.2. Configurando Zabbix Server\033[0;0m\n\n"
									# sleep 2								
									sed -i 's/# ListenPort=10051/ListenPort=10051/g' /usr/local/etc/zabbix_server.conf
									sed -i 's/# LogFileSize=1/LogFileSize=2/g' /usr/local/etc/zabbix_server.conf
									sed -i 's/# PidFile=\/tmp\/zabbix_server.pid/PidFile=\/tmp\/zabbix_server.pid/g' /usr/local/etc/zabbix_server.conf
									sed -i 's/# DBHost=localhost/DBHost=localhost/g' /usr/local/etc/zabbix_server.conf
									sed -i 's/# DBPassword=/DBPassword=zabbix/g' /usr/local/etc/zabbix_server.conf
									sed -i 's/# StartIPMIPollers=0/StartIPMIPollers=1/g' /usr/local/etc/zabbix_server.conf
									sed -i 's/# StartDiscoverers=1/StartDiscoverers=5/g' /usr/local/etc/zabbix_server.conf
									sed -i 's/Timeout=4/Timeout=3/g' /usr/local/etc/zabbix_server.conf
									sed -i 's/# FpingLocation=\/usr\/sbin\/fping/FpingLocation=\/usr\/bin\/fping/g' /usr/local/etc/zabbix_server.conf
								
									printf "\n\033[36m5.3. Copiando os arquivos de frontend do Zabbix para o diretório /var/www/html/zabbix\033[0;0m\n\n"
									# sleep 2	
									mkdir /var/www/html/zabbix
									cp -R /usr/src/zabbix-3.2.4/frontends/php/* /var/www/html/zabbix/
								
									# Tornando os arquivos executáveis
									chown -R www-data:www-data /var/www/html/zabbix/
								
									cp /usr/src/zabbix_server /etc/init.d/
									cp /usr/src/zabbix_agentd /etc/init.d/
									chmod +x /etc/init.d/zabbix_server /etc/init.d/zabbix_agentd
								
									# Executando
									/etc/init.d/zabbix_server start
									/etc/init.d/zabbix_agentd start
								
									# Habilitando os scripts para serem executados quando o computador for ligado.
									echo ""
									update-rc.d -f zabbix_server defaults
									update-rc.d -f zabbix_agentd defaults
								
																
									if [ $? != 0 ]; then 
										printf "\n\033[31mFalha na Instalação do Zabbix\033[0;0m\n\n"
										echo ""
									else
										cd
										rm /usr/src/script-instalacao*
										rm -rf /usr/src/zabbix*										
										printf "\n\033[33mFinalizada Instalação.\033[0;0m\n\n"
									fi
								fi							
							fi								
						fi					
					fi
				fi
			fi
		fi
	fi
fi
