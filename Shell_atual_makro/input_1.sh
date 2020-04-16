#!/bin/bash
#
#$1 = arquivos com os dados ja formatados
#

IFS=:
while read nome fone mail aniver;do
	echo
	echo "Nome:		$nome"
	echo "Telefone:		$fone"
	echo "mail: 		$mail"
	echo "Aniversario: 	$aniver"

	mysql -u Samuel -e \
"INSERT INTO agenda VALUES('$nome','$fone','$mail','$aniver')" mysql_bash
	[  "$?" = "0" ] && echo "Operacao OK!" || echo "ERRO!"
done < $1
