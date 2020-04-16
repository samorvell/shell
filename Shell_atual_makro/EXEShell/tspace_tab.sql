set heading off
set pagesize 5000
set feedback off
spool /home/operator/tspace_tab.file
select table_name,','
from sys.dba_tables
where tablespace_name ='STOREDAT08'
order by table_name; 
spool off 
exit
