#########################################
### Gravacao das FITAS p/ FISCO       ###        
### Paulo Noboru Hirota               ### 
#########################################
clear;
opc=999; msg=" " 
LJ=`uname | cut -c6-7`
if test $LJ = HO 
   then 
   LOJA=" H. O. "
else 
   LOJA="LOJA $LJ"
fi
RAZAO="MAKRO ATACADISTA S.A"
DATE=`date | cut -c1-16` 
TOFF=`tput rmso`
TBOLD=`tput bold`
TBLINK=`tput blink`
TRES=`tput smso`
export RAZAO LJ LOJA DATE TOFF TBOLD TBLINK TRES 
while  test $opc -ne 0
do 
      clear;tput rev
      echo "        " $RAZAO "        " $LOJA "        " $DATE "       "
      tput cup 2 24
      echo "M E N U   P R I N C I P A L" 
      tput sgr0
      tput cup 5 20; echo "$TBOLD  1$TOFF - RESTAURAR BACKUP SEMANAL"
      tput cup 6 20; echo "$TBOLD  2$TOFF - MOSTRAR ARQUIVOS RESTAURADOS"
      tput cup 7 20; echo "$TBOLD  3$TOFF - GERAR ARQUIVOS P/ FISCO (1 dia)"
      tput cup 8  20; echo "$TBOLD  4$TOFF - VERIFICAR DIAS GERADOS P/ FISCO" 
      tput cup 9 20; echo "$TBOLD  5$TOFF - GRAVAR O MES TODO EM FITA" 
      tput cup 10 20; echo "$TBOLD  8$TOFF - BACKUP ANTES RECUPERACAO" 
      tput cup 11 20; echo "$TBOLD  9$TOFF - RESTORE APOS RECUPERACAO" 
      echo "                    $TBOLD  0$TOFF - Fim"
      echo
      echo -n '                           Opcao Escolhida --> '
      read opc  
      case $opc in 
         1) clear;
# restore da fita backup semanal,                            
# uncompress nos arquivos,
# import das tabelas invoice,invoice_line e invoice_vat no usuario flavio,
# export das tabelas invoice,invoice_line e invoice_vat do usuario flavio no
#  /work/FISCO_DDMMAA,
# remover os arquivos exp000.*
# criar lista dos arquivos do /work/FISCO_* e fazer backup (01 a 31 - mes),
# remover os arquivos que foram feito o backup (/work/FISCO_*).
# Noboru 10/04/1997.

#
# restore da fita backup semanal
clear;echo;echo "Colocar a fita backup semanal para restore dos exp000.*"
echo;echo -n "Restore dos arquivos exp000.* Continua (S/N) ==> ";read CONT
if test $CONT = S -o $CONT = s                                
   then
      rm /work/ARQUIVOS/exp000.*
      cpio -icvBdmul -I /dev/rmt/c0t3d0s0 *exp000.*.Z
   else
      echo;
fi;;
         2) clear; ls -lai /work/ARQUIVOS/exp000* | more 
            echo "TECLE <ENTER> PARA CONTINUAR"; read sadsa;;
         3) clear;
# 
echo;echo -n "Digite dia da semana (maisculo)==> "; read SEMANA
export SEMANA
if test `ls /work/ARQUIVOS/exp000* |grep -c $SEMANA ` = 0
 then 
 echo "ESTE DIA NAO FOI RESTAURADO, VERIFICAR.....";read nada 
else
#### echo;echo -n "Digite data no formato DDMMAAAA  ==> "; read DDMMAAAA
#### export DDMMAAAA
 # uncompress no arquivo
 echo;echo "Fazendo uncompress no arquivo exp000.$SEMANA aguarde..."
 uncompress /work/ARQUIVOS/exp000.$SEMANA 
 #
 # Dropa e Cria Tabelas de Fisco no Usuario flavio.
 $ORACLE_HOME/bin/sqlplus -s flavio/flavio_ho @$OPERATOR/dropfisco.sql
 $ORACLE_HOME/bin/sqlplus -s flavio/flavio_ho @$REORG/FISCO_INVOICE_CT.sql
 $ORACLE_HOME/bin/sqlplus -s flavio/flavio_ho @$REORG/FISCO_INVOICE_LINE_CT.sql
 $ORACLE_HOME/bin/sqlplus -s flavio/flavio_ho @$REORG/FISCO_INVOICE_VAT_CT.sql
 echo;echo "  FIM DO DROP E CREATE TABLE."
 #
 # import das tabelas fisco no usuario flavio.                        
 #clear;                                                        
 echo;echo;                                                    
 echo;echo -n "IMPORT DAS TABELAS, CONTINUA (S/N) ==> "; read CONT
 if test $CONT = S -o $CONT = s                                
    then                                                       
    echo;echo "Iniciando o import..."
    #$ORACLE_HOME/bin/imp flavio/flavio_ho parfile=$OPERATOR/impfisco.par 2> /tmp/impfisco.log
    $ORACLE_HOME/bin/imp flavio/flavio_ho parfile=$OPERATOR/impfisco.par
    echo;echo "Fim do import..."
 else                                                          
    exit;
 fi
 #
######  ACHA DATA NO ARQUIVO INVOICE ###
 echo "clear break    " >  /tmp/XXX
 echo "clear col      " >> /tmp/XXX
 echo "clear comp     " >> /tmp/XXX
 echo "set heading off" >> /tmp/XXX
 echo "set linesize 132" >>  /tmp/XXX
 echo "set pagesize 60 " >>  /tmp/XXX
 echo "set feedback off" >>  /tmp/XXX
 echo "set verify off" >>  /tmp/XXX
 echo "select MAX(to_char(invoice_date,'DDMMYYYY')) from invoice;" >> /tmp/XXX
 echo "exit" >> /tmp/XXX
 mv /tmp/XXX /tmp/XXX.sql
 DDMMAAAA=`$ORACLE_HOME/bin/sqlplus -s flavio/flavio_ho @/tmp/XXX`
 export DDMMAAAA
 # export das tabelas invoice,invoice_line,invoice_vat. 
 echo;echo "Iniciando o export..."
 DDMMAAAA=`echo $DDMMAAAA |cut -c1-8`
ARQ=/work/FISCO_$DDMMAAAA.dmp
export ARQ
echo $ARQ
echo "buffer=32768" > $OPERATOR/expfisco.par
echo "grants=y" >> $OPERATOR/expfisco.par
echo "indexes=y" >> $OPERATOR/expfisco.par
echo "rows=y" >> $OPERATOR/expfisco.par
echo "constraints=y" >> $OPERATOR/expfisco.par
echo "compress=y" >> $OPERATOR/expfisco.par
echo "userid=flavio/flavio_ho" >> $OPERATOR/expfisco.par
echo "tables=(INVOICE,INVOICE_LINE,INVOICE_VAT)" >> $OPERATOR/expfisco.par
echo "file=$ARQ" >> /home/operator/expfisco.par

 $ORACLE_HOME/bin/exp flavio/flavio_ho parfile=$OPERATOR/expfisco.par
 echo;echo "Fim do export..."
 #
 echo; echo "Comprimindo o arquivo exp000.$SEMANA"
 compress /work/ARQUIVOS/exp000.$SEMANA; 
 echo; echo "Comprimindo o arquivo $ARQ"
 compress $ARQ;
fi;;

         4) clear; ls -lai /work/FISCO_*| more;;
         5) clear; 
#
# criar lista do /work/FISCO_* e fazer o backup
echo;echo -n "Completou o mes para fazer o backup ? (S/N) ==> "; read CONT
if test $CONT = S -o $CONT = s
   then 
     echo;echo "Backup Fisco Ref. ao mes ... "
     find /work/FISCO_* -print > $OPERATOR/lista.fisco
     cpio -ocvB < $OPERATOR/lista.fisco -O /dev/rmt/c0t3d0s0
   else
     exit;
fi;
#
# remover lista.fisco e /work/FISCO_*
echo;echo -n " O backup foi ok ?  (S/N) ==> "; read CONT
if test $CONT = S -o $CONT = s
   then 
     rm $OPERATOR/lista.fisco
     rm /work/FISCO_*
   else
     exit;
fi;;
         8) echo;echo " Montar a fita para backup antes recuperacao."
            echo;echo -n " A fita esta montada para backup ? (S/N) ==> "; read CONT
            if test $CONT = S -o $CONT = s
               then
                  find /work/ARQUIVOS/exp000* -print > $OPERATOR/lista.exp000
                  echo;echo " Gravando backup antes recuperacao." 
                  cpio -ocvB < $OPERATOR/lista.exp000 -O /dev/rmt/c0t3d0s0
               else 
                  exit;
            fi;;
         9) echo;echo " Colocar a fita backup antes recuperacao para restore."  
            echo;echo -n "Ok para restore ?  Continua (S/N) ==> ";read CONT
            if test $CONT = S -o $CONT = s                                
               then
                  rm /work/ARQUIVOS/exp000.*
                  cpio -icvBdmul -I /dev/rmt/c0t3d0s0 *exp000.*.Z
               else
                  exit;
             fi;;
         0) clear; exit;;
         *) echo;echo;echo
            echo -n "               Opcao Invalida,  tecle <enter> para continuar ";read nada;;
      esac
      opc=999
done
