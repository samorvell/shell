#!/bin/bash
#
#$1 = arquivo com os dados ja formatados
#
# Sera gerado um arquivo 'arquivo.SQL' com os comandos sql
#
IFS=:

while read ID NOME_FILME NOME_ORIGINAL ANO_DE_LANCAMENTO DURACAO DIRETOR GENERO ORIGEM SINOPSE QUALIDADE TAMANHO_ARQUIVO;do
	echo "INSERT INTO FILMES VALUES ('$ID','$NOME_FILME','$NOME_ORIGINAL','$ANO_DE_LANCAMENTO','$DURACAO','$DIRETOR','$GENERO','$ORIGEM','$SINOPSE','$QUALIDADE','$TAMANHO_ARQUIVO');" >> arquivo.SQL
done < $1
