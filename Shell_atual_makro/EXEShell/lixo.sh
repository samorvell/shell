      echo " AGUARDE VOU TESTAR A COMSAT "
      ROUTERLJ="171.$LJ.88.100"
      ROUTERHO="10.52.254.100"
      HOSTHO="MAKROHO"
      ping $ROUTERLJ 56 5 >/tmp/logrouterlj
      ping $ROUTERHO 56 5 >/tmp/logrouterho
      ping $HOSTHO 56 5 >/tmp/loghostho

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
