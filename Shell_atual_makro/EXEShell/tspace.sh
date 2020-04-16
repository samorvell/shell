### 
REORG=/home/reorg
export REORG
OPERATOR=/home/operator
export OPERATOR
ORACLE_HOME=/home/app/oracle/product/7.3.2
export ORACLE_HOME
INSTALL=/home/store/install
export INSTALL
#
  clear;
  echo " TABLESPACES DISPONIVEIS:"
  echo "set heading off"                              > tspace_file.sql
  echo "set pagesize 5000"                           >> tspace_file.sql
  echo "set feedback off"                            >> tspace_file.sql
  echo "spool $OPERATOR/tspace.file"                 >> tspace_file.sql
  echo "select distinct substr(tablespace_name,9,2)" >> tspace_file.sql
  echo "       from sys.dba_tables"                  >> tspace_file.sql
  echo "       where owner='OPS\$STOREP';"           >> tspace_file.sql
  echo "spool off"                                   >> tspace_file.sql
  echo "exit"                                        >> tspace_file.sql
  $ORACLE_HOME/bin/sqlplus -s ops\$storep/ops\$storep @$OPERATOR/tspace_file.sql
  echo;echo -n "DIGITE O NUMERO DA TABLESPACE A SER REORGANIZADA==> " ; read TSPACE
  if test `grep -c $TSPACE tspace.file` = 0      
    then
      echo;echo "NUMERO DE TABLESPACE INVALIDO" 
#     opc=ERRO
      exit
    else
      echo;echo    
      echo "TABELAS A SEREM EXPORTADAS:" 
      echo "set heading off"                           > tspace_tab.sql
      echo "set pagesize 5000"                        >> tspace_tab.sql
      echo "set feedback off"                         >> tspace_tab.sql
      echo "spool $OPERATOR/tspace_tab.file"          >> tspace_tab.sql
      echo "select table_name,','"                    >> tspace_tab.sql
      echo "from sys.dba_tables"                      >> tspace_tab.sql
      echo "where tablespace_name ='STOREDAT$TSPACE'" >> tspace_tab.sql
      echo "order by table_name; "                    >> tspace_tab.sql
      echo "spool off "                               >> tspace_tab.sql
      echo "exit"                                     >> tspace_tab.sql
      $ORACLE_HOME/bin/sqlplus -s ops\$storep/ops\$storep @$OPERATOR/tspace_tab.sql
      echo "tables=("   > ZZZ     
      cat ZZZ tspace_tab.file                > tspace_temp
      echo "TESTE )"    > YYY     
      cat tspace_temp     YYY                > tspace_exp.par
      echo "buffer=32768"                   >> tspace_exp.par 
      echo "grants=n"                       >> tspace_exp.par 
      echo "indexes=n"                      >> tspace_exp.par 
      echo "rows=y"                         >> tspace_exp.par 
      echo "constraints=n"                  >> tspace_exp.par 
      echo "compress=y"                     >> tspace_exp.par 
      echo "userid=ops$storep/ops$storep"   >> tspace_exp.par
      echo "file=/work/tspace_tab.dmp"      >> tspace_exp.par
      echo;echo
      echo " FAZENDO EXPORT DAS TABELAS ACIMA, AGUARDE..."   
      $ORACLE_HOME/bin/exp parfile=tspace_exp.par 2> $OPERATOR/tspace_exp.log
      echo " TERMINOU EXPORT DAS TABELAS..."   
  fi; 
#
  echo;echo    
  echo "CRIANDO ARQUIVO PARA DROP INDEX..."
  echo "set heading off"                             > tspace_indices.sql
  echo "set pagesize 5000"                          >> tspace_indices.sql
  echo "set feedback off"                           >> tspace_indices.sql
  echo "spool $OPERATOR/GGG.lst"                    >> tspace_indices.sql
  echo "select 'drop index ',index_name,';'"        >> tspace_indices.sql
  echo "from sys.dba_indexes"                       >> tspace_indices.sql
  echo "where tablespace_name ='STOREIDX$TSPACE'"   >> tspace_indices.sql
  echo "order by index_name; "                      >> tspace_indices.sql
  echo "spool off "                                 >> tspace_indices.sql
  echo "exit"                                       >> tspace_indices.sql
  $ORACLE_HOME/bin/sqlplus -s ops\$storep/ops\$storep @$OPERATOR/tspace_indices.sql
  echo "exit" > $OPERATOR/XXX
  cat $OPERATOR/GGG.lst $OPERATOR/XXX > $OPERATOR/tspace_drop_indices.sql
#
  echo;echo    
  echo "CRIANDO ARQUIVO PARA DROP TABLE..."
  echo "set heading off"                           > tspace_tabelas.sql
  echo "set pagesize 5000"                        >> tspace_tabelas.sql
  echo "set feedback off"                         >> tspace_tabelas.sql
  echo "spool $OPERATOR/HHH.lst"                  >> tspace_tabelas.sql
  echo "select 'REVOKE ALL ON OPS\$STOREP.'||table_name||' FROM PUBLIC;'" >> tspace_tabelas.sql
  echo "from sys.dba_tables"                      >> tspace_tabelas.sql
  echo "where tablespace_name ='STOREDAT$TSPACE'" >> tspace_tabelas.sql
  echo "order by table_name; "                    >> tspace_tabelas.sql
  echo "select 'DROP PUBLIC SYNONYM ',table_name,';' " >> tspace_tabelas.sql
  echo "from sys.dba_tables"                      >> tspace_tabelas.sql
  echo "where tablespace_name ='STOREDAT$TSPACE'" >> tspace_tabelas.sql
  echo "order by table_name; "                    >> tspace_tabelas.sql
  echo "select 'DROP TABLE ',table_name,';'"      >> tspace_tabelas.sql
  echo "from sys.dba_tables"                      >> tspace_tabelas.sql
  echo "where tablespace_name ='STOREDAT$TSPACE'" >> tspace_tabelas.sql
  echo "order by table_name; "                    >> tspace_tabelas.sql
  echo "spool off "                               >> tspace_tabelas.sql
  echo "exit"                                     >> tspace_tabelas.sql
  $ORACLE_HOME/bin/sqlplus -s ops\$storep/ops\$storep @$OPERATOR/tspace_tabelas.sql
  echo "exit" > $OPERATOR/JJJ
  cat $OPERATOR/HHH.lst $OPERATOR/JJJ > $OPERATOR/tspace_drop_tabelas.sql
#
  echo;echo
  echo "CRIANDO ARQUIVO PARA CREATE TABLE..."                       
  echo "set heading off"                             > tspace_tab_CT.sql
  echo "set pagesize 5000"                          >> tspace_tab_CT.sql
  echo "set feedback off"                           >> tspace_tab_CT.sql
  echo "spool $OPERATOR/tspace_cria_tabelas.sql" >> tspace_tab_CT.sql
  echo "select '$ORACLE_HOME/bin/sqlplus -s ops\$storep/ops\$storep @$REORG/'||table_name||'_CT.sql' " >> tspace_tab_CT.sql
  echo "from sys.dba_tables"                        >> tspace_tab_CT.sql
  echo "where tablespace_name ='STOREDAT$TSPACE'"   >> tspace_tab_CT.sql
  echo "order by table_name; "                      >> tspace_tab_CT.sql
  echo "spool off "                                 >> tspace_tab_CT.sql
  echo "exit"                                       >> tspace_tab_CT.sql
  $ORACLE_HOME/bin/sqlplus -s ops\$storep/ops\$storep @$OPERATOR/tspace_tab_CT.sql
#
  echo;echo
  echo "CRIANDO ARQUIVO PARA IMPORT..."                       
  echo "tables=("                                    > ZZZ     
  cat ZZZ tspace_tab.file                            > tspace_temp
  echo "TESTE )"                                     > YYY     
  cat tspace_temp     YYY                            > tspace_imp.par
  echo "buffer=32768"                               >> tspace_imp.par
  echo "file=/work/tspace_tab.dmp"                  >> tspace_imp.par
  echo "grants=n"                                   >> tspace_imp.par
  echo "commit=y"                                   >> tspace_imp.par
  echo "indexes=n"                                  >> tspace_imp.par
  echo "rows=y"                                     >> tspace_imp.par
  echo "ignore=y"                                   >> tspace_imp.par
  echo "fromuser=ops$storep"                        >> tspace_imp.par
  echo "touser=ops$storep"                          >> tspace_imp.par
#
  echo;echo
  echo "CRIANDO ARQUIVO PARA CREATE INDEX..."                       
  echo "set heading off"                             > tspace_ind_CI.sql
  echo "set pagesize 5000"                          >> tspace_ind_CI.sql
  echo "set feedback off"                           >> tspace_ind_CI.sql
  echo "spool $OPERATOR/tspace_cria_indices.sql" >> tspace_ind_CI.sql
  echo "select '$ORACLE_HOME/bin/sqlplus -s ops\$storep/ops\$storep @$REORG/'||table_name||'_CI.sql' " >> tspace_ind_CI.sql
  echo "from sys.dba_tables"                        >> tspace_ind_CI.sql
  echo "where tablespace_name ='STOREDAT$TSPACE'"   >> tspace_ind_CI.sql
  echo "order by table_name; "                      >> tspace_ind_CI.sql
  echo "spool off "                                 >> tspace_ind_CI.sql
  echo "exit"                                       >> tspace_ind_CI.sql
  $ORACLE_HOME/bin/sqlplus -s ops\$storep/ops\$storep @$OPERATOR/tspace_ind_CI.sql
#
  echo;echo
  $ORACLE_HOME/bin/sqlplus -s ops\$storep/ops\$storep @$OPERATOR/tspace_drop_indices.sql
  $ORACLE_HOME/bin/sqlplus -s ops\$storep/ops\$storep @$OPERATOR/tspace_drop_tabelas.sql
  echo;echo
  echo "FAZENDO DROP E CREATE STOREDAT$TSPACE e STOREIDX$TSPACE..."
  echo "svrmgrl << !!"                     > tspace_drop_tspaces.sh 
  echo "CONNECT INTERNAL"                 >> tspace_drop_tspaces.sh 
  echo "DROP TABLESPACE STOREDAT$TSPACE;" >> tspace_drop_tspaces.sh 
  echo "DROP TABLESPACE STOREIDX$TSPACE;" >> tspace_drop_tspaces.sh 
  echo "DISCONNECT"                       >> tspace_drop_tspaces.sh 
  echo "EXIT"                             >> tspace_drop_tspaces.sh 
  echo "!!"                               >> tspace_drop_tspaces.sh 
#
  echo "set heading off"                          > tspace_rm_data_files.sql
  echo "set pagesize 5000"                       >> tspace_rm_data_files.sql
  echo "set feedback off"                        >> tspace_rm_data_files.sql
  echo "spool $OPERATOR/tspace_rm_data_files.sh" >> tspace_rm_data_files.sql
  echo "select 'rm '||file_name   "              >> tspace_rm_data_files.sql
  echo "       from sys.dba_data_files "         >> tspace_rm_data_files.sql
  echo "       where tablespace_name "           >> tspace_rm_data_files.sql
  echo "       ='STOREDAT$TSPACE' or "           >> tspace_rm_data_files.sql
  echo "       tablespace_name "                 >> tspace_rm_data_files.sql
  echo "       ='STOREIDX$TSPACE'  "             >> tspace_rm_data_files.sql
  echo "       order by file_name; "             >> tspace_rm_data_files.sql
  echo "spool off "                              >> tspace_rm_data_files.sql
  echo "exit"                                    >> tspace_rm_data_files.sql
#
  $ORACLE_HOME/bin/sqlplus -s ops\$storep/ops\$storep @$OPERATOR/tspace_rm_data_files.sql
#
  sh $OPERATOR/tspace_drop_tspaces.sh
#
# sh $OPERATOR/tspace_rm_data_files.sh
#
# sh $INSTALL/cr_ts_storedat$TSPACE 
# sh $INSTALL/cr_ts_storeidx$TSPACE 
#
# echo "TERMINOU DROP E CREATE STOREDAT$TSPACE e STOREIDX$TSPACE..."
#
# $ORACLE_HOME/bin/sqlplus -s ops\$storep/ops\$storep @$OPERATOR/tspace_cria_tabelas.sql
# echo;echo
# echo " FAZENDO IMPORT DAS TABELAS, AGUARDE..."   
# $ORACLE_HOME/bin/imp parfile=tspace_imp.par 2> $OPERATOR/tspace_imp.log
# echo " TERMINOU IMPORT DAS TABELAS..."   
#
# echo " CRIANDO INDICES, AGUARDE..."   
# $ORACLE_HOME/bin/sqlplus -s ops\$storep/ops\$storep @$OPERATOR/tspace_cria_indices.sql
exit;         
###     
