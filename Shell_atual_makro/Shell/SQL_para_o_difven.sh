#echo 'Entre com o nome do sql a ser executado:'
#read  PRG
if [ ! -r $1.sql ]
then
  echo SQL $PRG.sql nao existe neste diretorio
  exit 1
fi

VT_PRGEXE=/tmp/${LOGNAME}_$1_roda.sql
cat > $VT_PRGEXE << end_sql
SET ECHO OFF
SET HEADING OFF
SET VERIFY OFF
SET PAGESIZE 0
SET LINESIZE 600
SET FEEDBACK OFF
alter session set NLS_NUMERIC_CHARACTERS = ',.';
SPOOL /tmp/&1.$LOGNAME
-- SELECT 'EXECUTANDO LOJA:', STORE_NO from STORE;
end_sql

cat  $1.sql  >>  $VT_PRGEXE

cat >> $VT_PRGEXE << end_sql
spool off
exit;
end_sql

rm /tmp/$1*${LOGNAME} >/dev/null 2>/dev/null
for file in `cat $MAKRO/admin/bin/lojas_lin`
do
        VT_HOST_LJ=`$MS_PROGS/get_var_store.sh $file 4`
        echo chamando loja ${VT_HOST_LJ} ... arquivo lojas !!!!
  sqlplus -s ops$storep/ops$storep@${VT_HOST_LJ} @$VT_PRGEXE $1_${VT_HOST_LJ}.lst &
  sleep 1
done

echo "Aguarde... Executando nas lojas"
wait
VT_LJ_ERR=""
for file in `cat $MAKRO/admin/bin/lojas_lin`
do

        VT_HOST_LJ=`$MS_PROGS/get_var_store.sh $file 4`
        ARQ_LOG=/tmp/$1_${VT_HOST_LJ}.lst${LOGNAME}

        if [ -f ${ARQ_LOG}  ]
        then
                  grep "" ${ARQ_LOG} | grep "ORA-" >/dev/null 2>/dev/null
                  if [ $? = 0 ]
                        then
                                VT_LJ_ERR="${VT_LJ_ERR} $file"
                        fi
        else
                                VT_LJ_ERR="${VT_LJ_ERR} $file"
        fi

done

#Lojas com erro
if [ ! -z "${VT_LJ_ERR}" ]
then
                echo "##############################  LOJAS COM ERRO  ################################"
                echo ""                                                         
                echo "${VT_LJ_ERR}"
                echo ""
                echo "################################################################################"
else
   echo "Todas as Lojas: Concluido com sucesso"
fi

CORRENTE=`date +%d%m20%y`
cd /tmp
cat difven_MAKRO*t_wmarvyn > /home/t_wmarvyn/DIFVEN/Dif_$CORRENTE
