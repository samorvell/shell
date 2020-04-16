####################################################
#Menu para operacoes com impressoras              #
# Wilson Roberto Cortez        versao: 001/03/98   #
# Joao Geraldo de Arruda       versao: 001/04/02 - Unix Sparc Solaris 8 #
####################################################
clear
opc=999; msg=" " 
while test $opc -ne 0
do 
#-----------------------------------------------------------------------------#
. $OPERATOR/CABEC_OPERATOR.sh #criacao do cabecalho do operator                
#-----------------------------------------------------------------------------#
      clear;tput rev
      echo "     " $RAZAO "      " $LOJA "   " $DIA_SEM $DIA $MES $ANO $HORA
      tput cup 2 29
      echo "I M P R E S S O R A S" 
      tput sgr0
      echo
      echo "                           $TBOLD  1$TOFF - Manutencao das Impressoras"
      echo "                           $TBOLD  2$TOFF - Fila de impressao"
      echo "                           $TBOLD  3$TOFF - Cancelar impressao"
      echo "                           $TBOLD  4$TOFF - Situacao Servico de Impressao"
      echo "                           $TBOLD  5$TOFF - Ativar uma impressora"
      echo "                           $TBOLD  6$TOFF - Desativar uma impressora"
      echo "                           $TBOLD  7$TOFF - STARTUP no Servico de impressao"
      echo "                           $TBOLD  8$TOFF - SHUTDOWN Servico de impressao"
      echo "                           $TBOLD  0$TOFF - Volta ao menu principal"
      tput cup 19 0;                                                      
      echo "                             Opcao Escolhida -->  "  >/dev/tty
      tput cup 19 49;
      read opc  
      case $opc in 
	 1) sh altimp.sh;;
         2) clear; sudo lpstat -u
            echo $LJ \(Fila de Impressao\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
         3) clear; lpstat -u;echo; 
                   echo "IMPRESSAO A SER CANCELADA ";echo;echo
                   echo -n "IMPRESSORA / NUMERO / ALL  ==> "; read IMPR 
                   if test $IMPR = all
                      then 
                      IMP=`lpstat -o | cut -c1-20`
                   else
                      IMP=`lpstat -o |grep $IMPR | cut -c1-20`
                   fi
                   echo cancel $IMP;
                   sudo cancel $IMP
                   echo $LJ \(Cancelou Impressao: "$IMP"\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
         4) clear; lpstat -t |more
            echo $LJ \(Status do Serv. Impressao\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
         5) clear; echo -n "NOME DA IMPRESSORA / ALL (PARA TODAS) ==>"; read IMP
                   if test $IMP = all -o $IMP = ALL 
                      then 
                          IMP=`ls /etc/cups/ppd | cut -f1 -d "."`
               read nada
                          sudo cupsenable $IMP
read nada
                          sudo accept $IMP
read nada
                      else
                          ls /etc/cups/ppd/$IMP.ppd >/dev/null 2>&1
                          if [ $? != 0 ]
                             then 
                                echo;echo;echo;echo;echo;
                                echo "\07 A IMPRESSORA $IMP NAO EXISTE"
                                echo;echo;echo;echo;echo;
                             else
                                sudo cupsenable $IMP
                                sudo accept $IMP
                          fi
                   fi
            echo $LJ \(Enable da Impressora: "$IMP"\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
         6) clear; echo -n "NOME DA IMPRESSORA / ALL (PARA TODAS) ==>"; read IMP
                   if test $IMP = all -o $IMP = ALL 
                      then 
                          IMP=`ls /etc/cups/ppd | cut -f1 -d "."`
                          sudo cupsdisable $IMP
                          sudo reject $IMP
                      else
                          ls /etc/cups/ppd/$IMP.ppd >/dev/null 2>&1
                          if [ $? != 0 ]
                             then 
                                echo;echo;echo;echo;echo;
                                echo "\07 A IMPRESSORA $IMP NAO EXISTE"
                                echo;echo;echo;echo;echo;
                             else
                                sudo cupsdisable $IMP
                                sudo reject $IMP
                          fi
                   fi

            echo $LJ \(Disable da Impressora: "$IMP"\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
         7) clear; sudo service cups start
            echo $LJ \(Startup do Serv. Impressao\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
         8) clear; sudo service cups stop
            echo $LJ \(Shutdown do Serv. Impressao\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
         0) clear; exit;;
         *) echo;echo "                                Opcao Invalida";;
      esac 
      opc=999;echo "tecle <enter> para continuar "; read nada
done

