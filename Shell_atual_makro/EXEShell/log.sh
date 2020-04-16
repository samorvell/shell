#########################################################
# Exibe / Lista log das transmissoes                    # 
# E chamado pelo geralog.sh                             #
# Wilson Roberto Cortez alterado por Marco A. Ribeiro   #
# em Jan/98                           Versao: 001/01/98 #
# Joao Geraldo de Arruda       versao: 001/04/02 - Unix Sparc Solaris 8 #
#########################################################
clear
opc=99
while  test $opc -ne 0
do
. $OPERATOR/CABEC_OPERATOR.sh #cria cabecalho
  clear;tput rev                                                        
  echo "     " $RAZAO "      " $LOJA "   " $DIA_SEM $DIA $MES $ANO $HORA
  tput cup 2 33
  echo "    L O G    " 
      tput sgr0
  echo
      echo 
      echo "                            $TBOLD 1$TOFF - Exibe LOG  "
      echo "                            $TBOLD 2$TOFF - Imprime LOG"
      echo "                            $TBOLD 0$TOFF - Fim " 
      tput cup 19 0;
      echo "                             Opcao Escolhida -->  "  >/dev/tty
      tput cup 19 49;
      read opc  
      if [ -z "$opc" ]
	 then .;
      else
         if [ $opc = 1 -o $opc = 2 -o $opc = 0 ]
	    then
            if test $opc != 0
               then
               echo -n 'ARQUIVO: ';read ARQ
               if test -z "$ARQ"
                  then
                  ARQ=@
               fi
               echo;echo -n 'DATA mm/dd : ';read DATA
               if test -z "$DATA"
                  then
                  DATA=@
               fi
            fi
         fi
      fi
         case $opc in
            1) cat $OPERATOR/LOG.DIARIO |grep $ARQ |grep $DATA|tr -s '@' ' '|sort +0 +5| pg -r;;
            2) cat $OPERATOR/LOG.DIARIO|grep $ARQ |grep $DATA|tr -s '@' ' '|sort +0 +5|lp;;
            0) clear; exit;;
            *) echo  "Digite uma opcao correta!!!";sleep 1;;
         esac
         opc=99
done
