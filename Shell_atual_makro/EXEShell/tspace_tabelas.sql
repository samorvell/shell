set heading off
set pagesize 5000
set feedback off
spool /home/operator/HHH.lst
select 'REVOKE ALL ON OPS$STOREP.'||table_name||' FROM PUBLIC;'
from sys.dba_tables
where tablespace_name ='STOREDAT08'
order by table_name; 
select 'DROP PUBLIC SYNONYM ',table_name,';' 
from sys.dba_tables
where tablespace_name ='STOREDAT08'
order by table_name; 
select 'DROP TABLE ',table_name,';'
from sys.dba_tables
where tablespace_name ='STOREDAT08'
order by table_name; 
spool off 
exit
