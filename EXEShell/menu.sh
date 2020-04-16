#########################################################################
#   Menu principal do operador                                          #   
#   Wilson Roberto Cortez   versao:001/03/98                            # 
# Joao Geraldo de Arruda       versao: 001/04/02 - Unix Sparc Solaris 8 #
# Noboru Ajeitando...                                                   #
#########################################################################
#CORREIO
sudo chown operator /home/operator/* > /dev/null 2>&1 &
sudo chmod 750 /home/operator/* > /dev/null 2>&1 &
sudo chgrp root /home/operator/* > /dev/null 2>&1 &
clear;
opc=999; msg=" " 
while  test $opc -ne 0
do 
#-----------------------------------------------------------------------------#
. $OPERATOR/CABEC_OPERATOR.sh #criacao do cabecalho do operator              
#-----------------------------------------------------------------------------#
      clear;tput rev
      echo "     " $RAZAO "      " $LOJA "   " $DIA_SEM $DIA $MES $ANO $HORA
      tput cup 2 24
      echo "M E N U   P R I N C I P A L" 
      tput sgr0
      echo
      echo
      echo "                            $TBOLD 1$TOFF - Impressoras"          
      echo "                            $TBOLD 2$TOFF - Processos" 
#      echo "                            $TBOLD 3$TOFF - Oracle "
      echo "                            $TBOLD 4$TOFF - Checagem dos Arquivos Recebidos"      
      echo "                            $TBOLD 5$TOFF - Ativar / Desativar rede Loja"      
      echo "                            $TBOLD 6$TOFF - Transmissao" 
      echo "                            $TBOLD 7$TOFF - Execucao Rotina rb00"
      echo "                            $TBOLD 8$TOFF - Password"       
      echo "                           $TBOLD  9$TOFF - Malote "
      echo "                           $TBOLD 10$TOFF - Operacoes c/ TCP/IP"
      echo "                           $TBOLD 12$TOFF - Verificar mensagens do sistema"
      echo "                           $TBOLD  0$TOFF - Fim"            
      tput cup 19 0;                                                    
      echo "                             Opcao Escolhida -->  "  >/dev/tty
      tput cup 19 49;                                                    
      read opc  
      case $opc in 
         1) clear; sh ./printer.sh;;
         2) clear; sh ./processos.sh;;
#         3) clear;
#            if test $LJ = 77
#                then
#                   clear; sh ./oracle10_77.sh
#                   else 
#              if [ $LOGNAME = operator ]                                   
#                 then                                                        
#                    if [ `ps -eaf | grep -v grep | grep -c "sh ./oracle8.sh"` -ge 1 -o `ps -eaf | grep -v grep | grep -c "sh ./backup.sh"` -ge 1 -o `ps -eaf | grep -v grep | grep -c "sh ./menutab.sh"` -ge 1 ]
#                       then
#                       clear                                                
#                       echo;echo;echo;echo                                  
#                       echo "\07 Somente é permitido um menu ORACLE / BACKUP / REORGANIZAÇÃO por vez."
#                       echo ""
#                       echo ""
#                       echo " \07Verifique pois devem existir mais de 01 (HUM) operator conectado no momento,    feche todos e tente novamente. "
#                       echo ""
#                       echo "--------------------------------------------------------------------------------"
#                       sudo who | grep operator 
#                       echo ""
#                       echo "TECLE ENTER"
#                       read nada
#                       continue
#                    else 
#                          sh ./oracle10.sh
#                    fi                                                         
#              fi                                                           
#            fi;;                                                       
         4) sudo su - storep;
            ;;                                                       
         5) sudo su - storep;;
         6) clear; sh ./trans.sh;;
         7) clear; /usr/bin/ssh rb00@localhost
            ;;
         8) clear; sh ./password.sh
            echo $LJ \(Executou Password\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
         9) sh ./correio.sh;;
        10) clear; sh ./tcpip.sh;;
         0) clear
	    exit;;
         *) echo;echo;echo
            echo -n "               Opcao Invalida,  tecle <enter> para continuar ";read nada;;
      esac
      opc=999
done
