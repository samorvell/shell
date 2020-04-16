#! /bin/bash
clear
OPT=999; msg=" "
while  test $OPT -ne 0
do
/home0/users/trescon/progs/./CABEMENU.sh #Criacao de cabecalho MENU
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
                          0 - Sair

                          Opcao Escolhida --> " OPT
        case $OPT in
        1)echo "Carregando programa! "
        echo "Deseja mesmo continuar? " y/n
        read RESP
        if [ ${RESP} = y  ] ; then
        echo "Ok! Pressione enter! "
        read
                else
                echo "Saindo ... Pressione enter!"
                read
                exit 1
        fi
        ./GLPOSRES.sh
;;

        2)echo "Carregrando programa! "
         echo "Deseja mesmo continuar? " y/n
        read RESP
        if [ ${RESP} = y  ] ; then
        echo "Ok! Pressione enter! "
        read
        				else
                echo "Saindo ... Pressione enter!"
                read
                exit 1
        fi

        ./SCRCOM.sh

;;

        0)echo  "Saindo ...  Pressione enter!  "
        read
        exit 1

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