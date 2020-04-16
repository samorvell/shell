set heading off
set pagesize 5000
set feedback off
spool /home/operator/GGG.lst
select 'drop index ',index_name,';'
from sys.dba_indexes
where tablespace_name ='STOREIDX08'
order by index_name; 
spool off 
exit
