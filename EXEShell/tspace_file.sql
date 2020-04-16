set heading off
set pagesize 5000
set feedback off
spool /home/operator/tspace.file
select distinct substr(tablespace_name,9,2)
       from sys.dba_tables
       where owner='OPS$STOREP';
spool off
exit
