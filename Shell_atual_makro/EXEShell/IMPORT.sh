$ORACLE_HOME/bin/imp ops\$storep/ops\$storep tables=$TABELA grants=N commit=N indexes=N ignore=Y buffer=32768 file=$MS_ARQUIVOS/$TABELA.dmp log=$OPERATOR/tmp/$TABELA\_IMPORT.sh.log
if test `cat $OPERATOR/tmp/$TABELA\_IMPORT.sh.log | grep -c "ORACLE error"` = 0
   then
      VT_RETORNO=0
   else
       VT_RETORNO=1
fi
export VT_RETORNO
exit $VT_RETORNO 
