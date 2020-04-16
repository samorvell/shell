# Menu para criacao de grupos/usuarios   
# Wilson Roberto Cortez 
clear
x=0
opc=0; msg=" " 
while test $opc -ne 5
do 
      clear 
      echo 
      echo "                         MENU PRINCIPAL     " 
      echo 
      echo "              1 - Exibe todos os grupos        "
      echo "              2 - Exibe todos os usuarios      "
      echo "              3 - Cria um usuario              "
      echo "              4 - Cria um grupo                "
      echo "              0 - Fim " 
      echo 
      echo -n '                  Opcao Escolhida --> '
      read opc  
      echo 
      echo 
      echo 
      echo $msg 
      case $opc in 
         1) msg=" "; clear; more /etc/group;;
         2) msg=" "; clear; more /etc/passwd;;
         3) msg=" "; clear;
            echo -n "NOME  DO USUARIO ==> "; read USER
            echo -n "DIRETORIO HOME   ==> "; read DIR
            echo -n "GRUPO DO USUARIO ==> "; read GRUPO
            if test `grep -c "^$USER:" /etc/passwd` -ne 0
               then  echo "O usuario $USER  ja existe "
               else  echo "useradd -g $GRUPO -d $DIR $USER"
                     mkdir $DIR
                     useradd -g $GRUPO -d $DIR $USER;
                     passwd $USER;
                     chown -R $USER $DIR
                     chgrp -R $GRUPO $DIR 
                     echo "chown -R $USER $DIR"
            fi;
            echo;echo "Digite <enter> para continuar "; read nada;;
         4) msg=" "; clear;echo -n "NOME DO GRUPO ==> " ; read GRUPO;
                     groupadd $GRUPO;;
         0) clear; exit;;
         *) msg='     Querido usuario, digite uma opcao correta!!!';;
      esac 
      echo; echo $msg; echo
done


