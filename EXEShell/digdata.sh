# Rotina para consistencia de data 
# Verifica  dias, mes e ano (inclusive bissexto)
# Se nao foi digitada a data, assume data do sistema
# Marco A. Ribeiro em Maio/97
lop=nok
tabmes=312831303130313130313031
mdata=`echo $wdata`
while test $lop = nok
do
  tput cup 22 0;echo "                                                        \c" 
  tput cup 22 43;echo "                                       \c"
  tput cup 22 43;
  echo "Data: "$mdata"\010\010\010\010\010\010\010\010\c"
  check=0
  read wdata;
  if [ -n "$wdata" ];then 
     wdia=`echo $wdata | cut -c1-2`
     wmes=`echo $wdata | cut -c3-4`
     wano=`echo $wdata | cut -c5-8`
     if [ -z "$wdia" -o -z "$wmes" -o -z "$wano" ];then
	check=1
     elif [ $wmes -lt 1 -o $wmes -gt 12 ];then
          check=1
	else
	p1=`expr $wmes \* 2 - 1 `
	p2=`expr $p1 + 1 `
	comp=`echo $tabmes | cut -c$p1-$p2 `
        if [ $wano -lt 1996 -o $wano -gt 2300 ];then
           check=1
        else
           wbi=`expr $wano - $wano / 4 \* 4 `
	   if [ $wbi = 0 -a $wmes = 02 ];then
	      comp=29
	   fi
            if [ $wdia -lt 1 -o $wdia -gt $comp ];then
               check=1
            else
               check=0
	    fi
	fi
     fi
  else
     wdata=`echo $mdata`
  fi
  if [ $check = 1 ];then
     tput cup 23 3; echo "\007 >> Data INCORRETA  dia: "$wdia"/"$wmes"/"$wano"\c"
     sleep 2;tput cup 23 3; echo "                                            \c"
  else
     lop=ok
     echo $wdata > wdig
  fi
done
