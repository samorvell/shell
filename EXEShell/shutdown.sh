###################################################################
# Menu para Shutdown no sistema inclusive Oracle                  #
# Wilson Roberto Cortez                        versao: 001/03/98  #
# Joao Geraldo de Arruda       versao: 001/04/02 - Unix Sparc Solaris 8 #
###################################################################
clear
opc=999
while test $opc -ne 0
do 
#-----------------------------------------------------------------------------#
. $OPERATOR/CABEC_OPERATOR.sh #criacao do cabecalho do operator                
#-----------------------------------------------------------------------------#
      clear;tput rev
      echo "     " $RAZAO "      " $LOJA "   " $DIA_SEM $DIA $MES $ANO $HORA
      tput cup 2 32
      echo "S H U T D O W N"             
      tput sgr0
      echo
      echo 
      echo "                            $TBOLD 1$TOFF - Verificar usuarios"
      echo "                            $TBOLD 2$TOFF - Verificar processos"
      echo "                            $TBOLD 3$TOFF - SHUTDOWN"
      echo "                            $TBOLD 0$TOFF - Volta ao menu principal"
      tput cup 19 0;                                                      
      echo "                             Opcao Escolhida -->  "  >/dev/tty
      tput cup 19 49;                                                     
      read opc  
      echo 
      case $opc in 
         1) clear; who| more
            echo $LJ \(Verificou Usuarios\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
         2) clear; ps -eaf|egrep -v "root"|egrep -v "oracle" |grep -v grep
            echo $LJ \(Verificou Processos\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
         3) clear;
#------------------------------------------------------------------------------#
         . $OPERATOR/VERIFICA_ROTINA_DIARIA.sh                                  
#------------------------------------------------------------------------------#
         . $OPERATOR/VERIFICA_ROTINA_REORG.sh                                   
#------------------------------------------------------------------------------#
         . $OPERATOR/VERIFICA_REDE.sh
#------------------------------------------------------------------------------#
                                                                                
         ROTINA="./backup.sh";  export ROTINA                                   
         MSG="\07 Executando BACKUP FISICO DIARIO, favor aguardar"; export MSG  
#------------------------------------------------------------------------------#
         . $OPERATOR/VERIFICA_ROTINA_BACKUP.sh $ROTINA $MSG                     
#------------------------------------------------------------------------------#
                                                                                
         ROTINA="/usr/sbin/ufsdump";    export ROTINA                           
         MSG="\07 Executando BACKUP FISICO MENSAL, favor aguardar"; export MSG  
#------------------------------------------------------------------------------#
         . $OPERATOR/VERIFICA_ROTINA_BACKUP.sh $ROTINA $MSG                     
#------------------------------------------------------------------------------#
         G="0"
         echo "O VALOR DE I PODE SER : 0 - DESLIGAR"
         echo "                        6 - REBOOT"
         echo;echo;echo -n "QUAL O VALOR DE i ==> "; read I
         if [ $I = "0" ]
            then 
               COMMAND="poweroff"
         else
               COMMAND="shutdown -g0 -y -i6"
         fi    
         echo;echo;echo $COMMAND
         echo;echo;
         echo -n "CONFIRMA OS PARAMETROS ACIMA  (S/N) ==> "; read CONF
         if [ $CONF = S -o $CONF = s ]
             then 
                echo "SHUTDOWN EM ANDAMENTO AGUARDE..." 
                echo "ENCERRANDO CORREIO.... AGUARDE..."
#------------------------------------------------------------------------------#
#         sh /etc/rc1.d/K91grpwise # DESATIVA GROUPWISE                          
#------------------------------------------------------------------------------#
                echo "ENCERRANDO BANCO DE DADOS..."
#------------------------------------------------------------------------------#
         sudo /etc/init.d/oracle stop # DESATIVA ORACLE                          
#------------------------------------------------------------------------------#
                 sudo $COMMAND
                echo $LJ \(Executou Shutdown-Unix com opcoes -"$COMMAND"\) `date` `tty` >> $OPERATOR/LOG.OPERATOR
                   fi;;
         0) clear
            exit;;
         *) echo;echo
            echo "                                 Opcao Invalida";;
      esac 
      opc=999;echo;echo "Tecle <enter> para continuar";read nada
done
