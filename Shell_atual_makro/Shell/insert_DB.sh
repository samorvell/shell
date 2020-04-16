#!/bin/bash
#
#Repare que a data para o Mysql e aaaa-mm-dd
#

#Testa se a data recebida, no formato do MySQL, e valida ou nao
checa_data(){
[ $(echo "$1" | sed 's,[12][0-9]\{3\}/\(0[1-9]\|1[012]\)/\(0[1-9]\|[12][0-9]\|3[01]\),,') ] &&
  return 1 || return 0
  }

echo "Informe as solicitacoes a seguir:"
echo
#read -p "ID 						: " ID
read -p "Filme						: " NOME_FILME
read -p "Nome original 					: " NOME_ORIGINAL
read -p "DURACAO					: " DURACAO
read -p "Diretor					: " DIRETOR
read -p "Genero 					: " GENERO
read -p "Origem 					: " ORIGEM
read -p "Sinopse (100 caractere)			: " SINOPSE
read -p "Qualidade          				: " QUALIDADE
read -p "Tamanho do arquivo 				: " TAMANHO_ARQUIVO
read -p "Tipo do arquivo 				: " TP_ARQUIVO
read -n2 -p "Ano de gravacao (dia/mes/ano): " dia
read -n2 -p "/" mes
read -n4 -p "/" ano
echo
#Colocamos na variavel aniver a data no formado MYSQL
ANO_DE_LANCAMENTO="$ano/$mes/$dia"

#Se a data nao for nula
if [ "$ano" -o "$mes" -o "$dia" ]; then
	#testa se a data e valida
	checa_data "$ANO_GRAVACAO" || { echo "ERRO: Data de aniversario invalida:"; exit;}
fi
#nao aceitamos nomes nulos
[ "$NOME_FILME" ] || { echo "ERRO: Nome invalido";exit; }

echo "Deseja incluir? (s/n)?"
read REPLY 
if [ "$REPLY" = "s" ] ;then
	mysql -u root -p123456 -e\
	"INSERT INTO FILMES Values (   'NULL','$NOME_FILME','$NOME_ORIGINAL','$ANO_DE_LANCAMENTO','$DURACAO','$DIRETOR',
					'$GENERO','$ORIGEM','$SINOPSE','$QUALIDADE','$TAMANHO_ARQUIVO')" Filmes
	[ "$?" = "0" ] && echo "Operacao bem sucedida!" || echo "ERRO! Na operacao!"
fi
