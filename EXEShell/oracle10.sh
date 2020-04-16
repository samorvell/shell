####################################################
# Menu do Oracle 7                                 #
# Wilson Roberto Cortez         versao: 001/03/98  #
# Atualizado (BLOCK_USER)       Noboru 12/01/2001. #
# Joao Geraldo de Arruda       versao: 001/04/02 - Unix Sparc Solaris 8 #
####################################################
clear
opc=999
while test $opc -ne 0
do 
. $OPERATOR/CABEC_OPERATOR.sh #cria cabecalho                                   
      clear;tput rev
      echo "     " $RAZAO "      " $LOJA "   " $DIA_SEM $DIA $MES $ANO $HORA
      tput cup 2 33
      echo "O R A C L E   10   " 
      tput sgr0
      echo
      echo 
      echo "                            $TBOLD 1$TOFF - Ativar Banco de Dados"
      echo "                            $TBOLD 2$TOFF - Desativar Banco de Dados"
#      echo "                            $TBOLD 3$TOFF - Manutenção de Tabelas" 
      echo "                            $TBOLD 0$TOFF - Volta ao menu principal"
      tput cup 19 0;
      echo "                             Opcao Escolhida -->  "  >/dev/tty
      tput cup 19 49;
      read opc
      echo 
      case $opc in 
         1) clear 

          ROTINA="./backup.sh";  export ROTINA                                 
          MSG="\07 Executando BACKUP FISICO DIARIO, favor aguardar"; export MSG
#------------------------------------------------------------------------------#
          . $OPERATOR/VERIFICA_ROTINA_BACKUP.sh  $ROTINA $MSG                  
#------------------------------------------------------------------------------#
          sudo /etc/init.d/oracle start # ATIVA ORACLE
#------------------------------------------------------------------------------#
          echo;;
         2) clear 
#------------------------------------------------------------------------------#
         . $OPERATOR/VERIFICA_ROTINA_DIARIA.sh                                  
#------------------------------------------------------------------------------#
         . $OPERATOR/VERIFICA_REDE.sh                  
#------------------------------------------------------------------------------#
         . $OPERATOR/VERIFICA_ROTINA_REORG.sh $ROTINA $MSG                      
#------------------------------------------------------------------------------#
         . $OPERATOR/CANCEL_PROCESSOS.sh                  
#------------------------------------------------------------------------------#
          sudo /etc/init.d/oracle stop # DESATIVA ORACLE
#------------------------------------------------------------------------------#
         echo;;
#         3) clear;
##------------------------------------------------------------------------------#
#          . $OPERATOR/VERIFICA_ROTINA_DIARIA.sh                        
##------------------------------------------------------------------------------#
#         . $OPERATOR/VERIFICA_REDE.sh                  
##------------------------------------------------------------------------------#
#          ROTINA="./backup.sh";  export ROTINA                                 
#          MSG="\07 Executando BACKUP FISICO DIARIO, favor aguardar"; export MSG
##------------------------------------------------------------------------------#
#          . $OPERATOR/VERIFICA_ROTINA_BACKUP.sh  $ROTINA $MSG 
##------------------------------------------------------------------------------#
#          sh ./menutab.sh ;;
##------------------------------------------------------------------------------#
         0) clear;
            exit;;
         *) echo;
            echo "                                Opcao Invalida";;
      esac
      if test $opc -ne 3 
         then
         echo;echo "Tecle <enter> para continuar";opc=999;read nada
      fi 
done
