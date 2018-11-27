#!/bin/bash
clear
echo
[ "$OPC1" = "1" ] && exit
clear
[ "$OPC2" = "2" ] && exit
clear
echo 'Digite o caminho do arquivo ou diretorio:'
read CAMINHO
[ -d "$CAMINHO" ] && echo "$CAMINHO: É um diretório" && exit
[ -f "$CAMINHO" ] && echo "$CAMINHO: É um arquivo" && exit
echo
echo "O caminho colocado não existe"

