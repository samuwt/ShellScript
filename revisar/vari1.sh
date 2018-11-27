
#!/bin/bash
clear
echo
echo "Continuar com a execução do script? [n=não]"
echo
read RESP
echo
[ "$RESP" = "n" ] && exit
clear
ls -l /
