######################################################
## INCREMENTA O LOG.DIARIO COM TRANSMISSOES        ###
## Marco  - Jan / 98           Versao:001/08/98    ###
## Captura uulog gerando LOG.DIARIO                ###
## ALTERADO EM ABRIL de 2005 - GERALDO             ###
## RODA INDEPENDENTE DE TER UUCICO ou uucico no    ###
## MOMENTO, para atualizar logs para verificacao   ###
## da transmissao diaria por modem                 ###
######################################################
#-------------  Rotina para teste de gravacao do LOG -------------
#-------------  Obs.: sempre ira gravar o registro anterior ------
TESTE_STA ()
{
sta=`echo $LINHA_W |cut -c1-1`
if test $sta != I
   then
   echo $LINHA_W" "$HORA >> /home/operator/LOG.DIARIO
   LINHA_W=I
fi
}
#-------------  Final da rotina teste de gravacao do LOG ---------
#
#-------------  Rotina de Montagem de linha detalhe --------------
MONTA ()
{
STATUS=`echo $L |cut -f3 -d\( |cut -f1 -d! |cut -c1-5 `
if test $STATUS = MAKRO
   then
   ORIGEM=`echo $L |cut -f3 -d\( | cut -f1 -d! `
   if test $ORIGEM = MAKROHO
      then
      OCORRENCIA="TR.HO->LJ"
   else
      OCORRENCIA="TR.LJ->HO"
   fi
   ARQW=`echo $L |cut -f3 -d\( | cut -f1 -d"@" `
   ARQUIVO=`basename $ARQW `
   LINHA_W="@"$LOJA" "$OCORRENCIA" "$ARQUIVO"    "$DIA" "$HORAG
else
   LINHA_W=I
fi
}
#-------------  Final da Rotina de Montagem de linha detalhe ------
OP=`ps -eaf |grep -v grep |grep -v $$ |grep -c $0`
ps -eaf |grep -v grep |grep -v $$ |grep -c $0
#if [ "$OP" -gt 0 ]
#   then
#   echo Este processo ja esta em execucao no momento...
#   echo "Digite <enter> para continuar ==> \c"
#   read nn
#   exit
#fi 
#UUCP=NOAR
#while test "$UUCP" = "NOAR"
#do
#   UU=`ps -eaf |grep -v grep | grep -c UUCICO `
#   uu=`ps -eaf |grep -v grep | grep -c uucico `
#   ii=`uustat |wc |cut -c1-8`
#   if test $UU = 0 -a $uu = 0 -a $ii = 0
#      then
#      UUCP=OK
#   fi
#   if test $NAME -a $NAME = operator 
#      then
#      UUCP=OK
#   fi
#   if test $UUCP != OK
#      then
#      clear
#      uustat
#      echo 
#      echo "\07Existe Transmissao pendente, o log nao estara totalmente atualizado"
#      echo 
#      echo 
#      echo "Digite <enter> para continuar \c"
#      read resp
#      exit
#   fi
#done
#echo
uulog > /home/operator/UULOG.DIARIO
/usr/lib/uucp/uudemon.cleanup > /dev/null 2>&1
cat /home/operator/UULOG.DIARIO >> /home/operator/UULOG.SEMANAL
cat /home/operator/UULOG.DIARIO >> /home/operator/UULOG_TRANS_MODEM
#clear;echo "Limpando os Arquivos do UUCP, Favor aguardar..."
#/usr/lib/uucp/uudemon.cleanup > /dev/null 2>&1 &
rm -r /var/uucp/.Log/uucico/MAK* > /dev/null 2>&1
rm -r /var/uucp/.Log/uucp/MAK* > /dev/null 2>&1

ARQ=`ps -eaf |grep /usr/lib/uucp/uugetty|grep -v grep|cut -c9-15`
echo;echo Cancelando o processo $ARQ
kill $ARQ > /dev/null 2>&1
echo
echo OK!!!
echo
echo "Favor aguarde... Este eh um processo demorado"
tr -s ' ' '@' < /home/operator/UULOG.DIARIO > /tmp/lista
W_UULOG=`cat /tmp/lista `
LINHA_W=I
for L in $W_UULOG
do
      #USER=`echo $L |cut -f1 -d"@"`
      LOJA=`echo $L |cut -f2 -d"@" | cut -c6-8 `
      DIA=`echo $L |cut -f2 -d\( | cut -f1 -d- ` 
      HORA=`echo $L |cut -f2 -d\( | cut -f2 -d- |cut -f1 -d,`
      RETORNO=`echo $L |cut -f2 -d ")" |cut -f1 -d "(" |cut -f2 -d"@" `
      case $RETORNO in
	OK) TESTE_STA 
            HORAG=`echo $HORA`;;
        REQUEST) STATUS=`echo $L |cut -f3 -d\( |cut -f1 -d! |cut -c1-5 `
                 if [ "$STATUS" = MAKRO ]
		    then
		    TESTE_STA
                    MONTA
		 else
		    LINHA_W=I
                 fi
                 HORAG=`echo $HORA`;;
        REQUESTED) STATUS=`echo $L |cut -f3 -d\( |cut -f1 -d! |cut -c1-5 `
                 if [ "$STATUS" = MAKRO ]
		    then
		    TESTE_STA
		 else
		    LINHA_W=I
                 fi
                 HORAG=`echo $HORA`;;
        MOVE:) TESTE_STA
               HORAG=`echo $HORA`;;
        REMOTE) STATUS=`echo $L |cut -f3 -d\( |cut -f1 -d! |cut -c1-5 `
                if [ "$STATUS" = MAKRO ]
		   then
		   TESTE_STA
		   MONTA
		 else
		    LINHA_W=I
                fi
                HORAG=`echo $HORA`;;
	PERMISSION) LINHA_W=I
                    HORAG=`echo $HORA`;;
	FAILED) LINHA_W=I
                HORAG=`echo $HORA`;;
        *) if [ -n "$RETORNO" ]
              then
              TESTE_STA
           fi
           HORAG=`echo $HORA`;;
      esac
done
LJ=`uname | cut -c6-7`
tail -1000 /home/operator/LOG.DIARIO > /home/operator/LOG.DIARIO.NEW
mv /home/operator/LOG.DIARIO.NEW /home/operator/LOG.DIARIO
echo $LJ \(Limpou LOG.DIARIO \) `date` `tty` >> /home/operator/LOG.OPERATOR
tail -5000 /home/operator/LOG.OPERATOR > /home/operator/LOG.OPERATOR.NEW
mv /home/operator/LOG.OPERATOR.NEW /home/operator/LOG.OPERATOR
echo $LJ \(Limpou LOG.OPERATOR \) `date` `tty` >> /home/operator/LOG.OPERATOR
exit
