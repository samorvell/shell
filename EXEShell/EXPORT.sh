$ORACLE_HOME/bin/exp ops\$storep/ops\$storep tables=$TABELA buffer=32768 file=$MS_ARQUIVOS/$TABELA.dmp log=$OPERATOR/tmp/$TABELA\_EXPORT.sh.log
VT_RETORNO=$?
export VT_RETORNO
exit $VT_RETORNO
