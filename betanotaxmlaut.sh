#! /bin/bash
clear
read -p  "Informe o numero da LJ: " LJ
read -p  "Informe a serie da nota 00 " SERIE
read -p  "Informe os numeros de notas separado por espacos: " NOTAS
for file in $NOTAS ; do 
ATUANFE=/tmp/${LOGNAME}_NFE_roda.sql
cat > $ATUANFE << end_sql
		insert into VW86_NFE_AUTXML_BCK@NFE_P.MAKRO.COM.BR
		select * from VW86_NFE_AUTXML@NFE_P.MAKRO.COM.BR
		where CFG_UN=$LJ
		and CFG_NUMERO_NF = $file
		and CFG_SERIE_NF = $SERIE
		 


/
end_sql
		sqlplus $ORAID @$ATUANFE

cat > $ATUANFE << end_sql
		delete from VW86_NFE_AUTXML@NFE_P.MAKRO.COM.BR
		where CFG_UN=$LJ
		and CFG_NUMERO_NF = $file
		and CFG_SERIE_NF = $SERIE
		commit;

/
end_sql
		sqlplus $ORAID @$ATUANFE
		
done