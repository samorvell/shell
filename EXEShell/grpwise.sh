############################################################             
# By Joao Geraldo De Arruda                                #             
# Joao Geraldo de Arruda       versao: 001/09/03 - Unix Sparc Solaris 8 #
############################################################             
clear                                                                    
opc=999; msg=" "                                                         
while test $opc -ne 0                                                    
do                                                                       
. $OPERATOR/CABEC_OPERATOR.sh                                            
  clear;tput rev                                                         
  echo "     " $RAZAO "      " $LOJA "   " $DIA_SEM $DIA $MES $ANO $HORA 
  tput cup 2 28                                                          
  echo "O P E R A C O E S   G R O U P W I S E"                           
  tput sgr0                                                              
  echo                                                                   
  echo                                                                   
  echo "                            $TBOLD 1$TOFF - Startup GroupWise"   
  echo "                            $TBOLD 2$TOFF - Shutdown GroupWise"  
  echo "                            $TBOLD 0$TOFF - Fim"                 
  tput cup 19 0;                                                         
  echo "                             Opcao Escolhida -->  "  >/dev/tty
  tput cup 19 49;                                                        
  read opc    
  echo        
  case $opc in
    1) clear;  
       if [ `ps  -eaf | grep -v grep | grep -c "gwmta"` -eq 1 -a `ps -eaf | grep -v grep | grep -c "gwpoa"` -eq 1 ]
        then 
           echo "GroupWise JA ESTA ATIVO"
           sleep 3                       
        else
           sudo /usr/bin/pkill -9 gwmta        
           sudo /usr/bin/pkill -9 gwpoa        
           sleep 10                       
           sudo sh /home1/gw/gw.sh       
           echo "Aguarde ................"
           sleep 10                       
           echo "Startup GroupWise Ok ..."
       fi
       echo $LJ \(Startup GroupWise\)`date` `tty` >>$OPERATOR/LOG.OPERATOR;;
    2) clear;
       echo "Aguarde ................"                                     
       sh /etc/rc0.d/K91grpwise                                            
       sleep 10                                                            
       echo "Shutdown GroupWise Ok ..."                                    
       echo $LJ \(Stop Groupwise\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
    0) exit;;
    *) echo -n "      Opcao invalida  !!!!  Tecle <ENTER> para continuar";;
    esac
       opc=999;echo;echo "tecle <enter> para continuar ";read nada
    done
