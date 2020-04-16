# Menu para operacoes com o sistema de loja _ usuario rb00
# Wilson Roberto Cortez 
clear
opc=999; msg=" " 
while test $opc -ne 0
do 
  clear          
# clear;tput rev
# echo "        " $RAZAO "        " $LOJA "        " $DATE "       "
  tput cup 2 25
  echo "S I S T E M A   D E   L O J A "
  tput sgr0
  echo
  echo 
  echo "                         $TBOLD 1$TOFF - Visualizar arquivo"
  echo "                         $TBOLD 2$TOFF - Copiar um arquivo"
  echo "                         $TBOLD 3$TOFF - Mover arquivo"
  echo "                         $TBOLD 4$TOFF - Remover arquivo"
  echo "                         $TBOLD 5$TOFF - Concatenar arquivos"
  echo "                         $TBOLD S$TOFF - Fim"
  echo
  echo
  echo -n '                          Opcao Escolhida --> '
  read opc  
  echo 
  case $opc in 
       1) echo; echo -n "NOME DO ARQUIVO ==> "; read ARQ
                clear; more $ARQ;;
       2) echo; echo -n "NOME DO ARQUIVO ORIGEM ==> "; read ARQO
                echo -n "NOME DO ARQUIVO DESTINO ==> "; read ARQD
                cp $ARQO $ARQD;;
       3) echo; echo -n "NOME DO ARQUIVO ORIGEM ==> "; read ARQO
                echo -n "NOME DO ARQUIVO DESTINO ==> "; read ARQD
                mv $ARQO $ARQD;;
       4) echo; echo -n "NOME DO ARQUIVO ==> "; read ARQ
                rm -i $ARQ;;
       5) echo; echo -n "NOME DOS ARQUIVOS ORIGEM ==> "; read ARQ
                echo -n "NOME DO ARQUIVO DESTINO ==> "; read ARQD
                cat $ARQO  > $ARQD;;
         S) clear; exit;;
         s) clear; exit;;
         *) echo;echo "                                Opcao Invalida";;
      esac 
      opc=999;echo;echo "tecle <enter> para continuar ";read nada
done
