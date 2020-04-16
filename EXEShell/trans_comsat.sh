RT_REATIVA_TRANSMISSAO ( )
{     
      cat /tmp/uustat.tmp >>$OPERATOR/LOG.OPERATOR > /dev/null 2>&1
      rm /var/spool/uucp/.Status/* > /dev/null 2>&1
}
################################################################################
# Verfica se a COMSAT esta OK                                                  #
################################################################################
OPERATOR=/home/operator;	export OPERATOR
LJ=`uname | cut -c6-7`
ping -s 56 -c 5 MAKROHO > /dev/null 2>&1
VT_RETPING=$?;              
if [ $VT_RETPING != 0 ]
   then  
      echo $LJ \(COMSAT fora do ar\) `date` `tty` >> $OPERATOR/LOG.OPERATOR
      uustat -a >/tmp/uustat.tmp 
      if test -s /tmp/uustat.tmp 
            then 
               tput cup 22 0 ;echo "COMSAT FORA DO AR ,FAVOR VERIFICAR">/dev/console
               tput cup 22 0 ;echo "EXISTEM TRANSMISSOES PENDENTES, EXECUTE PROCEDIMENTOS PARA ENVIAR POR MODEM">/dev/console
               tput cup 19 49
               echo "EXISTEM TRANSMISSOES PENDENTES" | lp 
               echo $LJ \(Transmissoes Pendentes, Operador Avisado\) `date` `tty` >> $OPERATOR/LOG.OPERATOR
               uustat -a >> $OPERATOR/LOG.OPERATOR
               RT_REATIVA_TRANSMISSAO
      else
      tput cup 22 0 ;echo "$LJ COMSAT FORA DO AR ,FAVOR VERIFICAR">/dev/console
      tput cup 19 49
      fi
   else
      echo $LJ \(COMSAT OK\) `date` `tty` >> $OPERATOR/LOG.OPERATOR
      cp /etc/uucp/Systems.comsat /etc/uucp/oldconfig/Systems
      #/usr/sbin/uusched
      uustat -a >/tmp/uustat.tmp 
      if test -s /tmp/uustat.tmp 
            then 
               echo $LJ \(Transmissoes Pendentes que Serao Reativadas OK\) `date` `tty` >> $OPERATOR/LOG.OPERATOR
          #     RT_REATIVA_TRANSMISSAO
      fi
fi
