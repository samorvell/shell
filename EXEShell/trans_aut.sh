chmod 777 /etc/uucp/*
rm /etc/uucp/Systems
cp /etc/uucp/Systems.aut /etc/uucp/Systems
chown uucp /etc/uucp/*
chgrp uucp /etc/uucp/*
chmod 444 /etc/uucp/*
echo "DISCAGEM AUTOMATICA HABILITADA"
