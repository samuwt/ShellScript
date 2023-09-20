#!/bin/bash

#####################################################
## Criado em 20/09/2023
## Autor: Samuel Cavalcante
## Destinado a execução do serviço do samba.
##### versão 1.0923

## VARIAVEIS DE AMBIENTE
padrao="\033[m"
cyan="\033[0;36m"
red="\033[0;31m"
green="\033[0;32m"
yellow="\033[0;33m"
arquivosamba=/etc/samba/smb.conf
menu=99

clear

while [ $menu != 0 ]
do
    echo ""
    echo "#### MENU DE ESCOLHA ####"
    echo $green
    echo "#### 1 - Criar pasta e aplicar permissão"
    echo "#### 2 - Novo compartilhamento"
    echo "#### 3 - Adicionar usuário de acesso"
    echo $red
    echo "### 0 - Sair"

    printf "> "
    read resp
    echo $padrao
    case $resp in

    0)
        exit
    ;;

    1)
        echo "Informe o nome da pasta para criação"
        printf "> "
        read nomepasta

        echo "Digite 1 para criar essa pasta no /mnt "
        echo "Digite 2 para criar essa pasta na / (raiz do sistema)"
        printf "> "
        read caminho

        if [ $caminho = 1 ]; then
                mkdir /mnt/$nomepasta
                echo "Pasta Criadan e permissão aplicada (777)"
                chmod 777 /mnt/$nomepasta
        elif [ $caminho = 2 ]
        then
                echo $yellow
                echo "Pasta Criadan e permissão aplicada (777)"
                mkdir /$nomepasta
                chmod 777 /$nomepasta
        else
            echo $red
            echo "------- Inserção errada ----------"
        fi
    ;;
    
    2)
        echo $green
        echo "Iniciando configurações."
        echo "Realizando copia de arquivo smb.conf para smb.conf.bkp"
        mv /etc/samba/smb.conf /etc/samba/smb.conf.bkp 

	touch $arquivosamba

        echo "[GLOBAL] #Configurações globais" > $arquivosamba

        echo "Nome do workgroup (Pode ser a sigla do cliente ou nome)"
        printf = "> "
        read workgroup
        echo "workgroup = $workgroup" >> $arquivosamba

        echo ""
        echo "Digite o nome do compartilhamento"
        printf "> "
        read nomecomp

        echo ""
        echo "Digite o comentário da pasta (pode ser o setor)"
        printf "> "
        read coment
        
        echo ""
        echo "Digite o nome da pasta"
        printf "> "
        read nomepasta

        caminhopasta=$(find / -type d -name "$nomepasta")
        echo "$caminhopasta"
        
        echo ""
        echo "Digite os usuário que terão acesso"
        printf "> "
        read usuarios

        #### PASSANDO CONFIGURAÇÕES PARA O ARQUIVO $arquivosamba
        echo "" >> $arquivosamba
        echo "[$nomecomp]" >> $arquivosamba
        echo "comment = $coment" >> $arquivosamba
        echo "path = $caminhopasta" >> $arquivosamba
        echo "valid users = $usuarios" >> $arquivosamba
        echo "writeable = yes" >> $arquivosamba
    ;;

    3)
        echo "Digite o nome do usuário que deseja criar para acesso ao samba"
        printf "> "
        read smbuser

        useradd $smbuser

        smbpasswd -a $smbuser
    ;;
    esac
    systemctl restart smbd.service
echo $padrao
done
