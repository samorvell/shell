#! /bin/bash
echo -e "
	1-item1
	2-item2
	3-item3"
echo -n "Escolha uma opção:"
read OPT
case $OPT in
1) echo "Executando funcionalidade 1"
   read UM
dois=`figlet $UM`
	echo "Opcao $dois "
;;
2) echo "Executando funcionalidade 2"
;;
3) echo "Executando funcionalidade 3"
;;
*) echo "Opção invalida"
;;
esac
