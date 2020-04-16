set heading off
set pagesize 5000
set feedback off
spool /home/operator/tspace_cria_indices.sql
select '/home/app/oracle/product/7.3.2/bin/sqlplus -s ops$storep/ops$storep @/home/reorg/'||table_name||'_CI.sql' 
from sys.dba_tables
where tablespace_name ='STOREDAT08'
order by table_name; 
spool off 
exit
