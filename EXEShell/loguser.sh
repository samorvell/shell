######################################################
## INCREMENTA O LOG DIARIO CON LOGIN DE USUARIOS   ###
## SOMENTE NAS PORTAS DE MODENS                    ###
## WILSON - MAR / 95                               ###
# Joao Geraldo de Arruda       versao: 001/04/02 - Unix Sparc Solaris 8 #
######################################################
## CAPTURA O CONTEUDO DO PS _EAF GREP CU
LJ=`uname -n | cut -c6-7 `
HORF=`date +%H:%M:%S `
DIA=`date +%d/%m `
ps -af |grep "cu " |grep -v grep | tr -s ' ' '@' > PS
cat PS
cat PS |grep -v MAKRO01 | grep -v MAKRO06 | grep -v MAKRO10 > PS1
cat PS1 |grep -v modem18 | grep -v modem26 > PS
PS=`cat PS |grep -v MAKRO01 | grep -v MAKRO06 | grep -v MAKRO10 ` 
rm PS PS1
for i in $PS 
do
  USER=`echo $i | cut -f2 -d"@" `
  PPAI=`echo $i | cut -f3 -d"@" `
  PFIO=`echo $i | cut -f4 -d"@" `
  HORI=`echo $i | cut -f6 -d"@" ` 
  TERMI=`echo $i | cut -f7 -d"@" `
  CPU=`echo $i | cut -f8 -d"@" `
  PROC=`echo $i | cut -f9 -d"@" `
  MODE=`echo $i | cut -f10 -d"@" ` 
  PROG=`echo $i | cut -c48-60 ` 
  if [ `cat PS |grep -c $PPAI ` = 1 ]
     then 
     echo $LJ USER $USER $DIA $HORI $HORF $PROC $MODE
     echo $LJ USER $USER $DIA $HORI $HORF $PROC $MODE >> $OPERATOR/LOG.USER
  fi 
done
