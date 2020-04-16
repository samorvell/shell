#! /bin/bash
sql0="INSERT INTO tab_cliente (val_limite_credito, cod_cliente, des_cliente) VALUES ("


echo "'$1', '$2', '$3', '$4', '$5')" >> INSERT_CLIENTES.sql < PRODUTOS.TXT

