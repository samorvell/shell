######################################################
# Menu - Processos                                   #
# Wilson Roberto Cortez          versao: 001/03/98   #
# Joao Geraldo de Arruda       versao: 001/04/02 - Unix Sparc Solaris 8 #
######################################################
clear
opc=999
while test $opc -ne 0
do 
#-----------------------------------------------------------------------------#
. $OPERATOR/CABEC_OPERATOR.sh #criacao do cabecalho do operator                
#-----------------------------------------------------------------------------#
      clear;tput rev
      echo "     " $RAZAO "      " $LOJA "     " $DIA_SEM $DIA $MES $ANO $HORA
      tput cup 2 30
      echo "P R O C E S S O S" 
      tput sgr0
      echo 
      echo "                         $TBOLD 1$TOFF - Verificar usuarios"
      echo "                         $TBOLD 2$TOFF - Cancelar Usuario "
      echo "                         $TBOLD 3$TOFF - Verificar processos"
      echo "                         $TBOLD 4$TOFF - Cancelar processos"
    # echo "                         $TBOLD 7$TOFF - Alterar a Data do Sistema"
    # echo "                         $TBOLD 8$TOFF - Remove BLOCK_USER"
      echo "                         $TBOLD 0$TOFF - Volta ao menu principal"
      tput cup 15 0;                                                      
      echo "                             Opcao Escolhida -->  "  >/dev/tty
      tput cup 15 49;                                                     
      read opc
      case $opc in 
         1) clear; who | more
            echo $LJ \(Verificou Usuarios\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
#         2) clear; who;ps -eaf |grep -v "oracle " |grep -v root > a;
          2) clear; who;ps -eaf |grep -v "oracle " |grep -v root|grep -v close_store |grep -v rbdayrun > a;
            echo;echo;
            echo -n "NOME DO USUARIO A SER CANCELADO ==> "; read USR;
            echo;echo
            grep $USR  < a; 
            PROCESS=`egrep "$USR"  < a | cut -c9-14`; 
            echo;echo;
            echo "PROCESSO(S) A SER(EM) CANCELADO(S) "; echo;echo; echo $PROCESS; 
            echo;echo;echo -n "CONFIRMA O CANCELAMENTO S/N ==> "; read CONF;
            if test $CONF = S -o $CONF = s
               then
               echo;echo;echo kill -9 $PROCESS
               sudo /usr/bin/kill -9 $PROCESS > /dev/null 2>&1
               echo $LJ \(Cancelou Usuario: $USR\) `date` `tty` >> $OPERATOR/LOG.OPERATOR
            else
               echo "CANCELAMENTO NAO CONFIRMADO " 
            fi;;
         3) clear; ps -eaf| more
            echo $LJ \(Verificando Processos\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
         #4) clear; ps -eaf|grep -v grep| grep -v root |grep -v "oracle " > a;
         4) clear; ps -eaf|grep -v grep| grep -v root |grep -v "oracle "|grep -v close_store |grep -v rbdayrun > a;
            more a;
            ps -eaf|grep -v grep > a;
            echo;echo;
            echo -n "No. DO PROCESSO A SER CANCELADO ==> "; read PROCESS;
            CONF=x
            if test `egrep "$PROCESS" < a| grep -v "consulta "| grep -c root` -ne 0 
               then 
                  egrep "$PROCESS" < a;echo 
                  echo;echo "PROCESSO DO ROOT NAO PODE SER CANCELADO"
                  echo;echo "CANCELAMENTO NAO PROCESSADO" 
               else 
                  egrep "$PROCESS" < a; rm a; echo;echo 
                  echo -n "CONFIRMA O CANCELAMENTO S/N ==> "; read CONF
                 if test $CONF = S -o $CONF = s
                    then 
                        echo "kill -9 $PROCESS"
                        sudo /usr/bin/kill -9 $PROCESS > /dev/null 2>&1
			Nome=`ps -eaf|grep -v grep|grep $PROCESS |cut -c47-100`
                        echo $LJ \(Cancelou Processo $Nome\) `date` `tty` >> $OPERATOR/LOG.OPERATOR
                 else
                        echo "CANCELAMENTO NAO CONFIRMADO" 
                 fi
            fi;;
#	 7) sh alt_data.sh;;
         0) clear
	    exit;;
         *) echo;
            echo "                                 Opcao Invalida";;
      esac 
      echo;echo "Tecle <enter> para continuar";opc=999;read nada
done
