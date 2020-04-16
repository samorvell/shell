# Rotina para pegar data do sistema e somar um(1), consistindo em seguida
# Devolve ao script que o chamou a data correta.
# Obs.: Consiste inclusive ano bisexto.
# Marco A. Ribeiro em Maio/97
tabmes=312831303130313130313031
wdata=`date "+ %d%m%Y "`;wdata=`expr $wdata + 101000000 |cut -c2-9`
wdia=`echo $wdata | cut -c1-2`
wmes=`echo $wdata | cut -c3-4`
wano=`echo $wdata | cut -c5-8`
p1=`expr $wmes \* 2 - 1 `
p2=`expr $p1 + 1 `
comp=`echo $tabmes | cut -c$p1-$p2 `
wbi=`expr $wano - $wano / 4 \* 4 `
if [ $wbi = 0 -a $wmes = 02 ];then
   comp=29
fi
if [ $wdia -gt $comp ];then
   wdia=01;wmes=`expr $wmes + 1 `
   if [ $wmes -lt 10 ];then
      wmes=`expr $wmes + 100 |cut -c2-3`
   fi
fi
if [ $wmes -gt 12 ];then
   wmes=01;wano=`expr $wano + 1 `
fi
wdata=`expr $wdia$wmes$wano`
echo $wdata > wdig
