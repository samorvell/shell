###########################################################
### Recebe malote e executa os scripts  ( SO NAS LOJAS) ### 
### Wilson R. Cortez  / alterado por Marco A. Ribeiro   ###
### versao: 004/10/97   correio_lj.sh                   ###
###########################################################
clear;
LJ=`uname -n | cut -c6-7`;export LJ
DATE=`date ` 
wdata=`date "+%d%m%Y"`;export wdata
echo "***********************************************" >> /home/operator/MALOTE.log
echo "MALOTE - LOJA $LJ - $DATE " >> /home/operator/MALOTE.log
echo "###############################################" >> /home/operator/MALOTE.log
rm /home/rxtx/loja$LJ/$MALOTE >/dev/null 2>&1
rm /home/rxtx/loja$LJ/$MALOTE.Z >/dev/null 2>&1
rm $DIR* >/dev/null 2>&1
uucp MAKROHO!/home/rxtx/comum/$MALOTE.Z /home/rxtx/loja$LJ/$MALOTE.Z
ARQUIVO=NAO_CHEGOU
until test $ARQUIVO != NAO_CHEGOU
do
  sleep 10
  uustat
  if [ `uustat -a |grep -v grep |grep MAKROHO |grep -c $MALOTE.Z ` = 0 ]
     then 
     ARQUIVO=OK
  fi
done
if [ ! -f /home/rxtx/loja$LJ/$MALOTE.Z ]
   then 
   banner PROCESSO DE MALOTE CANCELADO |lp -onobanner
   exit 
fi
uncompress /home/rxtx/loja$LJ/$MALOTE.Z
cd  /
cpio -icvBdmul -I /home/rxtx/loja$LJ/$MALOTE
for i in $DIR*.lst
do
##    echo lp -onobanner $i
   lp -onobanner $i
done
for i in $DIR*.LST
do
   lp -onobanner $i
done
tm=`ls -lai $DIR$SCRIPT |cut -c38-46`
echo @#$wdata.$SCRIPT.$tm > /tmp/listwork
sh $DIR$SCRIPT
#tail -50 /home/operator/LOG.OPERATOR > /tmp/worklog
#cat /tmp/worklog > /home/operator/LOG.OPERATOR
#rm /tmp/worklog
#cat /home/operator/LOG.OPERATOR >> /home/operator/MALOTE.log
cat /tmp/listwork >> /home/operator/MALOTE.log
if [ $DIR = /home/correio/geral/ ] 
   then
   nomelog=$wdata.$MALOTE.$LJ.g.log
else
   nomelog=$wdata.$MALOTE.e.log
fi
mv /home/operator/MALOTE.log /home/rxtx/loja$LJ/$nomelog
uucp /home/rxtx/loja$LJ/$nomelog MAKROHO!/home/rxtx/loja$LJ/$nomelog
if [ $DIR = /home/correio/geral/ ] 
   then 
   banner malote diario ok malote diario ok |lp -onobanner
else
   banner malote especifico ok malote expecifico ok |lp -onobanner
fi
