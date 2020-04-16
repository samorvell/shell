########################################################################
# Menu principal do sistema de Correio Eletronico - MENU DE LOJA       # 
# Wilson R. Cortez / alterado por Marco A. Ribeiro  versao: 001/03/98  #
########################################################################
clear;
opc=999; msg=" " 
#JULIANO=`date "+ %j " ` 
wdata=`date "+%d%m%Y"`
while  test $opc -ne 0
 do 

DIA=`date | cut -c9-10`
DIA_SEM=`date | cut -c1-3`  
case $DIA_SEM in  
 Sun) DIA_SEM="Domingo";; Mon) DIA_SEM="Segunda";; Tue) DIA_SEM="Terca";;
 Wed) DIA_SEM="Quarta";;  Thu) DIA_SEM="Quinta";;  Fri) DIA_SEM="Sexta";;
 Sat) DIA_SEM="Sabado";;    *) DIA_SEM=err;;
esac
MES=`date | cut -c5-7`
case $MES in  
 Jan) MES="Janeiro";;Feb) MES="Fevereiro";;Mar) MES="Marco";;Apr) MES="Abril";;
 May) MES="Maio";;Jun) MES="Junho";;Jul) MES="Julho";;Aug) MES="Agosto";;
 Sep) MES="Setembro";;Oct) MES="Outubro";;Nov) MES="Novembro";;
 Dec) MES="Dezembro";;  *) MES=err;;  
esac
ANO=`date | cut -c25-28`
HORA=`date | cut -c12-19`
export DIA_SEM DIA MES ANO HORA
  clear;tput rev
  echo "     " $RAZAO "      " $LOJA "   " $DIA_SEM $DIA $MES $ANO $HORA
  tput cup 2 25
  echo "C O R R E I O  E L E T R O N I C O" 
  tput sgr0
  echo
  echo 
  echo "                           $TBOLD  1$TOFF - Diario" 
  echo "                           $TBOLD  2$TOFF - Especifico"
  echo "                           $TBOLD  3$TOFF - Cancelamento"
  echo "                           $TBOLD  4$TOFF - Status "
  echo "                           $TBOLD  5$TOFF - Log" 
  echo "                           $TBOLD  0$TOFF - Fim"
  tput cup 19 0;
  echo "                             Opcao Escolhida -->  "  >/dev/tty
  tput cup 19 49;
  read opc  
  case $opc in 
       1) MALOTE=SUNOTE; export MALOTE
	  DIR=/home/correio/geral/; export DIR
	  SCRIPT=GE.SCRIPT.SCT; export SCRIPT
          nohup sh $OPERATOR/correio_lj.sh &
	  echo $LJ \(Executou Malote Diario\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
       2) MALOTE=SUNOTE.$LJ;export MALOTE
          DIR=/home/correio/lj$LJ/; export DIR
          SCRIPT=$LJ.SCRIPT.SCT; export SCRIPT
          nohup sh $OPERATOR/correio_lj.sh &
          echo $LJ \(Executou Malote Especifico\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
       3) UU=`uustat |grep MALOTE. | cut -c1-12 `
          for i in $UU
          do
           echo uustat -k $i
           uustat -k $i
          done
          PROCESS=` ps -eaf |grep -v grep |grep "correio_lj.sh" |cut -c9-14 `
          if [ -n "$PROCESS" ]
             then 
             kill -9 $PROCESS
          else
             clear;echo "Nao existe nenhum processamento do correio\
sendo executado no momento" 
             echo -n "                Tecle <enter> para continuar ";read nada;
          fi
          echo $LJ \(Cancelou Malote\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
       4) clear; echo "DIRETORIO DE TRANSMISSAO " > a; echo  >> a
          ls -lai /home/rxtx/loja$LJ | grep malote >> a
          echo >> a ;echo "ARQUIVOS EM TRANSMISSAO " >> a; echo >> a
          uustat >> a 
          echo >> a; echo "PROGRAMAS EM EXECUCAO " >> a; echo >> a
          ps -eaf |grep -v grep |grep correio_lj >> a
          echo >> a; echo "DIRETORIO GERAL - DIARIO " >> a; echo >> a
          ls -lai /home/correio/geral/ >> a 
          echo >> a; echo "DIRETORIO  - ESPECIFICO " >> a; echo >> a
          ls -lai /home/correio/lj$LJ >> a 
          clear;pg -r a;rm a
          echo $LJ \(Verificou Status das Transmissoes\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
       5) if [ -r /home/rxtx/loja$LJ/$wdata.MALOTE.$LJ.log ]
             then
	     clear
             pg -r /home/rxtx/loja$LJ/$wdata.MALOTE.$LJ.log
             echo $LJ \(Verificou LOG do Malote\) `date` `tty` >> $OPERATOR/LOG.OPERATOR
          else
             echo "O Log: $wdata.MALOTE.$LJ.log nao existe !!! digite <enter> para continuar";read resp
          fi;;
       0) clear
          exit;;
       *) echo;echo;echo
          tput cup 21 0
          echo -n "               Opcao Invalida, tecle <enter> para continuar ";read nada;;
       esac
       opc=999
 done
