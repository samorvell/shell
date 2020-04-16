dia=`date '+%d' `
mes=`date '+%m' `
hor=`date |cut -c12-13 `
min=`date |cut -c15-16 `
L=`uname |cut -c6-7 `
echo LOJA $L
echo $dia $mes $hor $min
exit
hora=`expr $hor + 1 `
if [ $hora -lt 10 ]
   then 
   hora="0"$hora
fi
if [ -r /home/operator/horario_de_veraow -o $L = 25 -o $L = 26 ]
   then 
   echo Horario de verao ja esta atualizado 
else
   horaantes=`date`
   echo $dia $mes $hora $min
   echo $mes$dia$hora$min
   date $mes$dia$hora$min
   echo "Alteracao de Horario efetuado. " > /home/operator/horario_de_veraow
   echo "Antes : "$horaantes              >> /home/operator/horario_de_veraow
   echo "Depois: "`date`                 >> /home/operator/horario_de_veraow
   echo Horario de verao atualizado neste momento 
fi
