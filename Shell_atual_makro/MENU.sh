#! /bin/bash
clear
OPT=999; msg=" "
while  test $OPT -ne 0
do
clear
#/home0/users/trescon/progs/./CABEMENU.sh #Criacao de cabecalho MENU
TBOLD=`tput bold`
TOFF=`tput rmso`

tput rev
tput cup 2 27
echo "  MAKRO ATACADISTA S.A  "
tput cup 5 24
echo  "  M E N U   P R I N C I P A L "
tput sgr0
read -p "

                          1 - GL Posto e Restaurante
                          2 - Reprocessar arquivos SCRCOM
                          3 - Reenvio arquivos NIELSEN
			  4 - Atualizar autonumber
			  5 - Reprocessa HOLOGL 
                          0 - Sair

                          Opcao Escolhida --> " OPT
        case $OPT in
        1) ./GLPOSREST.sh ;;
        2) ./SCRCOM.sh   ;;
        3) ./NIELSEN.sh     ;;
	4) ./AUTONUMBER.sh ;;
	5) ./HOLOGL.sh ;;
        0)clear
        exit
;;
        *)echo -e       "

                        Favor informar uma opcao valida!
                         Pressione enter para continuar!"
        read nada
        #./MENU.sh
        clear
        esac
        OPT=999
done
