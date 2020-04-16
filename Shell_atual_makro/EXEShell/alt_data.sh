########################################################################
# Shell para alteracao de Dia, Mes, Ano, Hora e Minuto do Sistema      #
# Este shell fica oculto no menu Procedimentos como opcao 7            #
# Obs.: Utilizado para alteracao do horario de verao                   #
# Marco A. Ribeiro                                  versao: 001/11/00  #
########################################################################
MENSAGEM ()
{
tput cup 23 20; echo -n $TBLINK$TBOLD$mens$TOFF
sleep $pause
tput cup 23 20; echo -n "\07                                                   "
}
dia=`date '+%d'`
mes=`date '+%m'`
hor=`date |cut -c12-13`
min=`date |cut -c15-16`
ano=`date |cut -c25-28`
tabmes=312831303130313130313031
LJ=`uname |cut -c6-7`
TBOLD=`tput bold`
TBLINK=`tput blink`
TOFF=`tput rmso`
st=not
clear
tput cup 0 0; echo $TOFF"                    Alteracao de Data e Hora do Sistema  -  Loja "$LJ
tput cup 2 0; echo "Atual------> "$TBOLD"Dia:"$dia"    Mes:"$mes"    Ano:"$ano"    Hora:"$hor"    Minuto:"$min$TOFF
tput cup 4 0; echo "Observacao .......:"$TBOLD"<enter>"$TOFF" no campo, conserva conteudo anterior"
tput cup 23 0; echo -n "Mensagens:"
lop=nok
while test $lop = nok
do
	tput cup 6 0; echo -n "Digite o Ano(aaaa):                             "
	tput cup 6 20; read dano
	if [ -z "$dano" ]
	   then
   	   dano=$ano
	   lop=ok
           tput cup 6 20; echo -n $dano
	else
	   case "$dano" in
		 2000|2001|2002|2003|2004|2005|2006|2007|2008|2009|2010|2011|2012|2013|2014|2015|2016|2017|2018|2019|2020|2021|2022|2023|2024|2025|2026|2027|2028|2029|2030|2031|2032|2033|2034|2035|2036)
					lop=ok
					st=alt
					tput cup 6 20; echo -n $TBOLD$dano$TOFF;;
	      	 *) mens="Ano invalido !!!"
              	    pause=2;MENSAGEM;;
	   esac
	fi
done
lop=nok
while test $lop = nok
do
	tput cup 8 0; echo -n "Digite o Mes(mm)  :                         "
	tput cup 8 20; read dmes
	if [ -z "$dmes" ]
	   then
	   dmes=$mes
	   lop=ok
           tput cup 8 20; echo -n $dmes
	else
	   case "$dmes" in
	         01|02|03|04|05|06|07|08|09|10|11|12)
					lop=ok
					st=alt
				        tira=`expr "$dmes" - "$mes"`
				        if [ "$tira" -gt 1 -o "$tira" -lt -1 ]
				           then
				           if [ "$dano" -eq "$ano" ]
					      then
				              tput cup 8 30
				              echo -n $TBLINK"Diferenca maior que um Mes"$TOFF
                                           fi
				        fi
					tput cup 8 20
					echo -n $TBOLD$dmes$TOFF;;
		 *) mens="Mes digitado invalido !!!"
		    pause=2
	            MENSAGEM;;
           esac
	fi
done
lop=nok
while test $lop = nok
do
	tput cup 10 0; echo -n "Digite o Dia(dd)  :                          "
	tput cup 10 20; read ddia
	if [ -z "$ddia" ]
	   then
	   ddia=$dia
	   lop=ok
           tput cup 10 20; echo -n $ddia
	else
	   case "$ddia" in
	         01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31)     p1=`expr $dmes \* 2 - 1`
				p2=`expr $p1 + 1`
				comp=`echo $tabmes | cut -c$p1-$p2`
				wbi=`expr $dano - $dano / 4 \* 4`
				if [ $wbi = 0 -a $dmes = 02 ]
				   then
				   comp=29
				fi
				if [ "$ddia" -gt "$comp" ]
				   then
				   mens="Dia digitado nao eh valido para o mes"
				   pause=2
				   MENSAGEM
				else
			   	   lop=ok
			   	   st=alt
				   tira=`expr "$ddia" - "$dia"`
				   if [ "$tira" -gt 1 -o "$tira" -lt -1 ]
				      then
				      if [ "$dmes" -eq "$mes" ]
					 then
				         tput cup 10 30
				         echo -n $TBLINK"Diferenca maior que um Dia"$TOFF
				      fi
				   fi
              		   	   tput cup 10 20
			   	   echo -n $TBOLD$ddia$TOFF
				fi;;
	        *) mens="Dia digitado invalido !!!"
		    pause=2
		    MENSAGEM;;
	   esac
	fi
done
lop=nok
while test $lop = nok
do
	tput cup 12 0; echo -n "Digite a Hora(hh) :                         "
	tput cup 12 20; read dhor
	if [ -z "$dhor" ]
	   then
	   dhor=$hor
	   lop=ok
           tput cup 12 20; echo -n $dhor
	else
	   case "$dhor" in
	         00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23 )			 lop=ok
	 			 st=alt
				 tira=`expr "$dhor" - "$hor"`
				 if [ "$tira" -gt 1 -o "$tira" -lt -1 ]
				    then
				    if [ "$ddia" -eq "$dia" ]
				       then
				       tput cup 12 30
				       echo -n $TBLINK"Diferenca maior que uma hora"$TOFF
                                    fi
				 fi
         			 tput cup 12 20; echo -n $TBOLD$dhor$TOFF;;
	         *) mens="Hora digitada invalida !!!"
	           pause=2;MENSAGEM;;
	   esac
	fi
done
lop=nok
while test $lop = nok
do
	tput cup 14 0; echo -n "Digite Minutos(mm):                         "
	tput cup 14 20; read dmin
	if [ -z "$dmin" ]
	   then
	   dmin=$min
	   lop=ok
           tput cup 14 20; echo -n $dmin
	else
	   case "$dmin" in
		 00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59 )
					lop=ok
					st=alt
					tput cup 14 20
					echo -n $TBOLD$dmin$TOFF;;
	      	 * )mens="Minutos digitado invalidos !!!"
	      	    pause=2;MENSAGEM;;
	   esac
	fi
done
tput cup 17 0; echo -n "Atual------> "$TBOLD"Dia:"$dia"    Mes:"$mes"    Ano:"$ano"    Hora:"$hor"    Minuto:"$min$TOFF
if [ "$st" = alt ]
   then
   tput cup 18 0; echo -n "Digitado---> "$TBLINK"Dia:"$ddia"    Mes:"$dmes"    Ano:"$dano"    Hora:"$dhor"    Minuto:"$dmin$TOFF
   horaantes=`date`
   tput cup 20 32; echo -n "Confirma (s/<n>):                          "
   tput cup 20 51; read resp
   if [ -z "$resp" ]
      then
      resp=n
   fi
   if [ "$resp" = s -o "$resp" = S ]
      then
      sudo date $dmes$ddia$dhor$dmin
      mens="Alteracao de Horario efetuado. "
      log=al
   else
      mens="Horario N A O  foi alterado"
      log=dn
   fi
else
      tput cup 18 0; echo -n "Digitado---> Dia:"$ddia"    Mes:"$dmes"    Ano:"$dano"    Hora:"$dhor"    Minuto:"$dmin
      mens="Nada alterado,  Nao houve digitacao!!!"
      log=nd
fi
pause=3;MENSAGEM
	case $log in
		al) echo $LJ \(Horario Alterado Antes: $horaantes \) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
		dn) echo $LJ \(Horario - Digitou mas N A O alterou\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
		nd) echo $LJ \(Horario - Entrou e nada digitou\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
	esac
clear
exit
