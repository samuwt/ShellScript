#!/bin/bash
clear

echo -e "\n\n\n\n\n\n"
echo "Escolha uma opção:"
echo "01 - Listar as pastas e arquivos"
echo "02 - Listar as pastas e arquivos com detalhes"
echo "03 - Informar a hora atual"
echo "04 - Informar a data atual"
echo "05 - Exibir somente os usuários criados"
echo "06 - Mostrar somente o IP"
printf ":"

read OPC
case $OPC in
"1")
	ls
;;
"2")
	ls -l
;;
"3")
	date "+Hora: %H:%M"
;;
"4")
	date "+Data: %d/%m/%y"
;;
"5")
	cat /etc/passwd |grep /home |cut -d ':' -f1
;;
"6")
	ifconfig enp |grep Bcast: |cut -d ':' -f 2,4 |tr -d 'Bcast' |tr -d ' ' |tr ':' '/'
;;
"*")
	echo "Opção inválida"
;;
esac
