spool /tmp/log
whenever sqlerror exit sql.sqlcode;
REVOKE ALL ON OPS$STOREP.WILSON FROM PUBLIC;
DROP PUBLIC SYNONYM WILSON;
drop table WILSON;
spool off
exit
