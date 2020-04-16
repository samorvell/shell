# Joao Geraldo de Arruda       versao: 001/04/02 - Unix Sparc Solaris 8 #
#-----------------------------------------------------------------------------#
#CRIA CABECALHO DO OPERATOR
#-----------------------------------------------------------------------------#
LJ=`uname -n | cut -c6-7`      
if test $LJ = HO            
   then                     
   LOJA=" H. O. "           
   LJPING=0
else                        
   LOJA="LOJA $LJ"          
   LJPING=$LJ
fi                          
RAZAO="MAKRO ATACADISTA S.A"
TOFF=`tput rmso`
TBOLD=`tput bold`
TBLINK=`tput blink`
TRES=`tput smso`
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
ANO=`date | cut -c25-29`
HORA=`date | cut -c12-19`
export RAZAO LJ LOJA DATE TOFF TBOLD TBLINK DIA_SEM DIA MES ANO HORA LJ LOJA
