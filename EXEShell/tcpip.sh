############################################################
# By Joao Geraldo De Arruda                                #
# and (Wilson Roberto Cortez)           versao: 001/03/98  #
# Joao Geraldo de Arruda       versao: 001/04/02 - Unix Sparc Solaris 8 #
############################################################
clear
opc=999; msg=" " 
while test $opc -ne 0
do 
. $OPERATOR/CABEC_OPERATOR.sh
  clear;tput rev
  echo "     " $RAZAO "      " $LOJA "   " $DIA_SEM $DIA $MES $ANO $HORA
  tput cup 2 28
  echo "O P E R A C O E S   T C P  / I P "
  tput sgr0
  echo
  echo 
  echo "                            $TBOLD 1$TOFF - Ping com o PDV MESTRE"
  echo "                            $TBOLD 2$TOFF - Ping com outros PDVS"
  echo "                            $TBOLD 3$TOFF - Ping c/ outros MICROS DA REDE"
  echo "                            $TBOLD 4$TOFF - Teste c/ COMSAT"
  echo "                            $TBOLD 0$TOFF - Fim"
  tput cup 19 0;
  echo "                             Opcao Escolhida -->  "  >/dev/tty
  tput cup 19 49;
  read opc
  echo
  case $opc in
   1) clear;host="171.$LJPING.99.1" 
      echo " AGUARDE POIS ESTOU TENTANDO "
      ping -c 5 $host
      echo $LJ \(Executou Ping com PDV Mestre\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
   2) clear;
      echo -n "ENTRE COM O NUMERO DO PDV ==> ";read PDV
      echo " AGUARDE POIS ESTOU TENTANDO "
      host="171.$LJPING.99.$PDV"
      ping -c 5 $host
      echo $LJ \(Executou Ping com outros PDVS\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
   3) clear;
      echo -n "ENTRE COM O ENDERECO IP DO MICRO  ";read END_MICRO
      echo " AGUARDE POIS ESTOU TENTANDO "
      host="$END_MICRO"
      ping -c5 $host
      echo $LJ \(Executou Ping com outros MICROS\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
   4) clear;
      echo " AGUARDE VOU TESTAR A COMSAT "
      ROUTERLJ="171.$LJ.88.100"
      ROUTERHO="10.52.254.100"
      HOSTHO="MAKROHO"
      ping -c5 $ROUTERLJ >/tmp/logrouterlj
      ping -c5 $ROUTERHO >/tmp/logrouterho
      ping -c5 $HOSTHO  >/tmp/loghostho

      if test `cat /tmp/logrouterlj | grep -c " 0% packet loss"` -eq 1
         then STATUS="OK"
              SERVER="ROTEADOR DA LOJA = "
              MENS=""
      else
         STATUS=`cat /tmp/logrouterlj | grep -w "5 packets"`
         SERVER="ROTEADOR DA LOJA = "
         MENS="VERIFICAR SUA REDE INTERNA (HUBs , SWITCH, CABEAMENTO)"
      fi

      if test `cat /tmp/logrouterho | grep -c " 0% packet loss"` -eq 1
         then STATUS1="OK"
              SERVER1="ROTEADOR DO H.O = "
              MENS1=""
      else
         STATUS1=`cat /tmp/logrouterho | grep -w "5 packets"`
         SERVER1="ROTEADOR DO H.O = "
         MENS1="ABRIR CHAMADO NA COMSAT, NAO CONSEGUE PING COM ROTEADOR DO H.O"
      fi

      if test `cat /tmp/loghostho | grep -c " 0% packet loss"` -eq 1
         then STATUS2="OK"
              SERVER2="SERVIDOR DO H.O = "
              MENS2=""
      else
         STATUS2=`cat /tmp/loghostho | grep -w "5 packets"`
         SERVER2="SERVIDOR DO H.O = "
         MENS2="ACIONAR SUPORTE TECNICO"
      fi
      echo;
TBOLD=`tput bold`  
TBLINK=`tput blink`
TOFF=`tput rmso`   
      echo "$SERVER $STATUS"
      echo $TBOLD"$MENS"$TOFF
      echo;
      echo "$SERVER1 $STATUS1"
      echo $TBOLD"$MENS1"$TOFF
      echo;
      echo "$SERVER2 $STATUS2"
      echo $TBOLD"$MENS2"$TOFF
      rm /tmp/logrouterlj > /dev/null 2>&1
      rm /tmp/logrouterho > /dev/null 2>&1
      rm /tmp/loghostho > /dev/null 2>&1
      echo $LJ \(Executou Teste com COMSAT\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
   0) exit;;
   *) echo -n "      Opcao invalida  !!!!  Tecle <ENTER> para continuar";;
  esac 
  opc=999;echo;echo "tecle <enter> para continuar ";read nada
done  
