# lock nas contas de usuarios do sistema #
for user in daemon bin sys adm lp smtp listen sync sysadm odmadmin odmusr vmsys oasys inet PElogin
do
   echo $user
   passwd -x 30  $user
   passwd -l $user
done
# Deleta arquivos temporarios no sistema
find /home/store1/log -type f -ctime +7 -exec rm -f {} \; >/dev/null 2>&1
find /home/store/admin -name "storenet*" -type f -ctime +1 -exec rm -f {} \; >/dev/null 2>&1
find /tmp -name "storenet*" -type f -ctime +1 -exec rm -f {} \; >/dev/null 2>&1
find /home/rxtx/loja?? -name ".profile" -prune -o -mtime +2 -exec rm -f {} \; >/dev/null 2>&1
find /home/store1 -name list -prune -o -type f -ctime +15 -exec rm -f {} \; >/dev/null 2>&1
find /home/gerali -name ".profile" -prune -o -type f -exec rm -f {} \; >/dev/null 2>&1
find /home/gernal -name ".profile" -prune -o -type f -exec rm -f {} \; >/dev/null 2>&1
#find /home/tlv -name ".profile" -prune -o -type f -exec rm -f {} \; >/dev/null 2>&1
find /home/alc -name ".profile" -prune -o -type f -exec rm -f {} \; >/dev/null 2>&1
find /home/cfi -name ".profile" -prune -o -type f -exec rm -f {} \; >/dev/null 2>&1
find /home/rcp -name ".profile" -prune -o -type f -exec rm -f {} \; >/dev/null 2>&1
find /home/storeprod -name ".profile" -prune -o -type f -exec rm -f {} \; >/dev/null 2>&1
find /home/rm -name ".profile" -prune -o -type f -exec rm -f {} \; >/dev/null 2>&1
find /home/mb -name ".profile" -prune -o -type f -exec rm -f {} \; >/dev/null 2>&1
find $ORACLE_HOME/rdbms/audit -name "ora_???.aud" -prune -o -mtime +7 -exec rm -f {} \; >/dev/null 2>&1
find /var/mail -name "noboru" -prune -o -type f -exec rm -f {} \; >/dev/null 2>&1
tail -500 /var/cron/log >/var/cron/log.new
mv /var/cron/log.new /var/cron/log
tail -500 /var/adm/utmp >/var/adm/utmp.new
mv /var/adm/utmp.new /var/adm/utmp
tail -500 /var/adm/utmpx >/var/adm/utmpx.new
mv /var/adm/utmpx.new /var/adm/utmpx
tail -500 /var/adm/wtmp >/var/adm/wtmp.new
mv /var/adm/wtmp.new /var/adm/wtmp
tail -500 /var/adm/wtmpx >/var/adm/wtmpx.new
mv /var/adm/wtmpx.new /var/adm/wtmpx
tail -500 /var/adm/Owtmp >/var/adm/Owtmp.new
mv /var/adm/Owtmp.new /var/adm/Owtmp
tail -500 /var/adm/Owtmpx >/var/adm/Owtmpx.new
mv /var/adm/Owtmpx.new /var/adm/Owtmpx

