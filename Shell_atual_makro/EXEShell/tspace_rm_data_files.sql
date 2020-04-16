set heading off
set pagesize 5000
set feedback off
spool /home/operator/tspace_rm_data_files.sh
select 'rm '||file_name   
       from sys.dba_data_files 
       where tablespace_name 
       ='STOREDAT08' or 
       tablespace_name 
       ='STOREIDX08'  
       order by file_name; 
spool off 
exit
