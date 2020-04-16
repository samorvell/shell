######################################################
## INCREMENTA O LOG DIARIO CON TRANSMISSOES E      ###
## LIMPA TODOS OS ARQUIVOS DO UUCP                 ###
## WILSON - NOV / 94                               ###
# Joao Geraldo de Arruda       versao: 001/04/02 - Unix Sparc Solaris 8 #
######################################################
## CAPTURA O CONTEUDO DO UULOG
UUCP=NOAR
TT=`ps -eaf |grep -v grep | grep -c logtrans.sh `
if [ $TT != 1 ]
   then
   exit
fi 
while test "$UUCP" = "NOAR"
do 
   UU=`ps -eaf |grep -v grep | grep -c UUCICO `
   uu=`ps -eaf |grep -v grep | grep -c uucico `
   TT=`ps -eaf |grep -v grep | grep -c logtrans.sh `
   if test $UU = 0 -a $uu = 0 -a $TT = 1
      then 
      UUCP=OK
      echo if 1
   fi
   if test $NAME -a $NAME = operator -a $TT = 1 
      then 
      UUCP=OK
      echo if 2 $NAME
   fi
   if test $UUCP != OK
      then 
      echo if 3
      echo existe transmissao no momento, aguarde.....
      sleep 30
   fi
echo $uu $UU $TT $UUCP $NAME
done
echo $uu $UU $UUCP $NAME
uulog > $OPERATOR/UULOG   
## LIMPA OS ARQUIVOS DO UUCP 
clear;echo;echo "LIMPANDO OS ARQUIVOS DO UUCP, AGUARDE UM MOMENTO " 
/usr/lib/uucp/uudemon.cleanup
rm -r /var/spool/locks/*;
rm -r /var/uucp/.Log/uucico/MAK*;
rm -r /var/uucp/.Log/uucico/MAKROH*;
rm -r /var/uucp/.Log/uucp/MAK*;
rm -r /var/uucp/.Log/uucp/MAKROH*;
rm -r /var/uucp/MAKRO* ;            
rm -r /var/uucp/MAKROHO*;            
rm -r /var/spool/uucp/MAK* ;
rm -r /var/spool/uucp/MAKROHO/Z/* ;
rm -r /var/mail/uucp;
/usr/lib/uucp/uucleanup -C1 -D1 -W1 -X1 -o1 -x9 | more;
ARQ=`ps -eaf |grep /usr/lib/uucp/uugetty|grep -v grep|cut -c9-15`;
echo;echo Cancelando o processo $ARQ;
kill $ARQ;
tr -s ' ' '@' < /home/operator/UULOG > /home/operator/lista
W_UULOG=`cat /home/operator/lista ` 
LINHA_W=I
#rm /home/operator/lista
LOJA_ANT=XX
for L in $W_UULOG
do
      USER=`echo $L |cut -f1 -d"@"`
      LOJA=`echo $L |cut -f2 -d"@" | cut -c6-8 `
      DIA=`echo $L |cut -f2 -d\( | cut -f1 -d- ` 
      HORA=`echo $L |cut -f2 -d\( | cut -f2 -d- |cut -f1 -d,`
      STATUS=`echo $L |cut -f3 -d, | cut -c1`
      RETORNO1=`echo $L | cut -f4 -d"@" `
      RETORNO2=`echo $L | cut -f5 -d"@" `
####  ARQUIVO=`echo $L |cut -f3 -d\( | cut -f5 -d\/ | cut -f1 -d"@" `
      ARQW=`echo $L |cut -f3 -d\( | cut -f1 -d"@" `
      ARQUIVO=`basename $ARQW `
      ORIGEM=`echo $L |cut -f3 -d\( | cut -f1 -d! `
      if test $RETORNO1 = OK -o $RETORNO1 = REMOTE -o $RETORNO1 = REQUEST  
         then
         echo if  
         if test `echo $LINHA_W| cut -c1-1` != I -a $LOJA = $LOJA_ANT
            then
            echo $LINHA_W" "$HORA >> /home/operator/LOG.DIARIO 
            LINHA_W=I
         fi
      fi
      if test $RETORNO2 = REQUEST -o $RETORNO1 = REMOTE -a $RETORNO2 = REQUESTED  
         then
         echo if 2 
         if test `echo $LINHA_W| cut -c1-1`  != I -a $LOJA = $LOJA_ANT 
            then
            echo $LINHA_W" "$HORA >> /home/operator/LOG.DIARIO 
            LINHA_W=I
         fi
         ARQUIVO_W=$ARQUIVO 
         if test $ORIGEM = MAKROHO 
            then 
            OCORRENCIA="TR.HO->LJ"
         else    
            OCORRENCIA="TR.LJ->HO"
         fi
         LINHA_W="@"$LOJA" "$OCORRENCIA" "$ARQUIVO" "$DIA" "$HORA
      fi
      if test $RETORNO1 = CAUGHT -o $RETORNO1 = BAD -o $RETORNO1 = FAILED -o $RETORNO1 = DENIED -o $RETORNO1 = IN
         then 
            LINHA_W=I
      fi
      LOJA_ANT=$LOJA
      echo $L 
      echo $ARQUIVO
      echo $LINHA $LINHA_W
done
tail -5000 $OPERATOR/LOG.DIARIO > $OPERATOR/LOG.DIARIO.NEW
cp  $OPERATOR/LOG.DIARIO.NEW $OPERATOR/LOG.DIARIO 
cat $OPERATOR/UULOG >> $OPERATOR/UULOG.OLD
tail -5000 $OPERATOR/UULOG.OLD > $OPERATOR/UULOG
cp $OPERATOR/UULOG $OPERATOR/UULOG.OLD
