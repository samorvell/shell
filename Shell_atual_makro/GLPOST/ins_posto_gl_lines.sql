/*---------------------------------------------------------------------------*/
/*                       ins_posto_gl_lines.sql                              */
/*---------------------------------------------------------------------------*/
/*                                                                           */
/* Contabilizar as informações das Vendas de Postos para o sistema General   */
/* Ledger. Gerar tabela a ser gravada no MBS-HO, com a movimentação de venda */
/* dos Postos, geradas a partir do processamento dos dados originados de     */
/* base em SQL Server, sendo processadas via rotina do HONIGHT.              */
/*                                                                           */
/* Versão 1.00 - 05/09/2011  Alcenir (3CON) - Demanda: 028242 UC 01          */
/*---------------------------------------------------------------------------*/

SET SERVEROUTPUT  ON
WHENEVER SQLERROR EXIT SQL.SQLCODE;

SET ECHO      OFF
SET TERMOUT   ON
SET FEEDBACK  ON
SET VERIFY    OFF
SET SERVEROUT ON


BEGIN 
DELETE gl_interface_conecto_carga WHERE ESTABELECIMENTO = 'POSTO';
COMMIT;
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
ROLLBACK;

DECLARE
ret integer;
c integer;
BEGIN
c := DBMS_HS_PASSTHROUGH.OPEN_CURSOR@posto;
DBMS_HS_PASSTHROUGH.PARSE@posto(c, 'SET SESSION SQL_MODE=''ANSI_QUOTES'';');
ret := DBMS_HS_PASSTHROUGH.EXECUTE_NON_QUERY@posto(c);
dbms_output.put_line(ret ||' passthrough output');
DBMS_HS_PASSTHROUGH.CLOSE_CURSOR@posto(c);
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
ROLLBACK;
BEGIN
INSERT INTO gl_interface_conecto_carga
SELECT V_SALE_CONT_AUT.ESTABELECIMENTO,
           V_SALE_CONT_AUT.ID_FINALIZADORA , 
           TO_DATE(V_SALE_CONT_AUT.DATA,'DD-MM-YYYY') DATA,
           V_SALE_CONT_AUT.LOJA,
           GL_INTERFACE_CONECTO.TRANS_CD,
           GL_INTERFACE_CONECTO.REP_GRP_NO,
           GL_INTERFACE_CONECTO.FIELD,
           GL_INTERFACE_CONECTO.ID_D_C,
           SUM(TO_NUMBER(REPLACE(V_SALE_CONT_AUT.VENDA_LIQUIDA,',','.'))) VENDA_LIQUIDA
      FROM V_SALE_CONT_AUT@POSTO,
           GL_INTERFACE_CONECTO
     WHERE V_SALE_CONT_AUT.ID_FINALIZADORA             = GL_INTERFACE_CONECTO.ID_FINALIZADORA
       AND V_SALE_CONT_AUT.ESTABELECIMENTO             = GL_INTERFACE_CONECTO.TP_MOVTO
       AND V_SALE_CONT_AUT.ESTABELECIMENTO             = 'POSTO'
       AND TO_DATE(V_SALE_CONT_AUT.DATA,'DD-MM-YYYY') <= sysdate       
     GROUP BY
           V_SALE_CONT_AUT.ESTABELECIMENTO,
           V_SALE_CONT_AUT.ID_FINALIZADORA,           
           V_SALE_CONT_AUT.DATA,
           V_SALE_CONT_AUT.LOJA,
           GL_INTERFACE_CONECTO.TRANS_CD,
           GL_INTERFACE_CONECTO.REP_GRP_NO,
           GL_INTERFACE_CONECTO.FIELD,
           GL_INTERFACE_CONECTO.ID_D_C;
COMMIT;
END;           
/
-- ---------------------------
-- DECLARACAO DE VARIAVEIS  --
-- ---------------------------
DECLARE

 W_MSG_ERRO              VARCHAR2(2000)  := ' ';
  V_MSG                   VARCHAR2(250)   := NULL;
  V_COD_RETORNO           NUMBER(1)       := NULL; -- LOG (1 Processo finalizado com sucesso.) (2 Processo finalizado com ERRO.)
  W_COD_ERRO              NUMBER(09)      := 0;
  P_COD_RETORNO           NUMBER;
  P_MSG_RETORNO           VARCHAR2(250);
  V_ACCOUNT_DATE          VARCHAR2(8);
  /* O processo abaixo faz busca dos dados a partir do ambiente SQL SERVER, para a tabela
     v_SALE_CONT_AUT através do dblink @POSTO, relacionando as informações para busca de
     dados referentes a parametrização pra conta contábil na tabela GL_INTERFACE_CONECTO.
  */
  CURSOR C0001 IS
    SELECT V_SALE_CONT_AUT.ESTABELECIMENTO,
           TO_CHAR(V_SALE_CONT_AUT.DATA,'YYYYMMDD') DATA,
           V_SALE_CONT_AUT.LOJA,
           GL_INTERFACE_CONECTO.TRANS_CD,
           GL_INTERFACE_CONECTO.REP_GRP_NO,
           GL_INTERFACE_CONECTO.FIELD,
           GL_INTERFACE_CONECTO.ID_D_C,
           SUM(NVL(V_SALE_CONT_AUT.VENDA_LIQUIDA,0) ) VENDA_LIQUIDA
      FROM gl_interface_conecto_carga V_SALE_CONT_AUT,
           GL_INTERFACE_CONECTO
     WHERE V_SALE_CONT_AUT.ID_FINALIZADORA      = GL_INTERFACE_CONECTO.ID_FINALIZADORA
       AND V_SALE_CONT_AUT.ESTABELECIMENTO      = GL_INTERFACE_CONECTO.TP_MOVTO
       AND V_SALE_CONT_AUT.ESTABELECIMENTO      = 'POSTO'
       AND V_SALE_CONT_AUT.DATA                 = TO_DATE('&1','YYYYMMDD')
       AND V_SALE_CONT_AUT.id_d_c =GL_INTERFACE_CONECTO.id_d_c 
       AND V_SALE_CONT_AUT.field =GL_INTERFACE_CONECTO.field
     GROUP BY
           V_SALE_CONT_AUT.ESTABELECIMENTO,
           V_SALE_CONT_AUT.DATA,
           V_SALE_CONT_AUT.LOJA,
           GL_INTERFACE_CONECTO.TRANS_CD,
           GL_INTERFACE_CONECTO.REP_GRP_NO,
           GL_INTERFACE_CONECTO.FIELD,
           GL_INTERFACE_CONECTO.ID_D_C
     ORDER BY
           V_SALE_CONT_AUT.DATA,
           V_SALE_CONT_AUT.LOJA,
           GL_INTERFACE_CONECTO.TRANS_CD,
           GL_INTERFACE_CONECTO.REP_GRP_NO,
           GL_INTERFACE_CONECTO.FIELD;

  V0001 C0001%ROWTYPE;

BEGIN
--DBMS_OUTPUT.put_line('OPEN = '||&1);
   OPEN C0001;
   LOOP
     FETCH C0001 INTO V0001;
     EXIT WHEN C0001%NOTFOUND;
     /* 
     Executa o procedimento que insere dados para serem contabilizados passando como parametros oa valores 
     resultantes do cursor c0001, referentes a todos os registros identificados pela finalizadora.
     */
     BEGIN
--     	DBMS_OUTPUT.put_line(V0001.FIELD);
        PRC$INS_POSTO_GL_LINES(V0001.LOJA,
                               V0001.TRANS_CD,
                               V0001.REP_GRP_NO,
                               V0001.FIELD,
                               V0001.VENDA_LIQUIDA,
                               V0001.ID_D_C,
                               V0001.DATA);
  
    EXCEPTION
      WHEN OTHERS THEN NULL;
        V_MSG         := ('* PRC$INS_POSTO_GL_LINES - ERRO AO TENTAR EFETUAR INSERT NA TABLE: GL_INTERFACE. ' || SUBSTR(SQLERRM,1,200));
        V_COD_RETORNO := 2;
        P_COD_RETORNO := V_COD_RETORNO;
        P_MSG_RETORNO := V_MSG;
        ROLLBACK;
    END;

    COMMIT;

   END LOOP;
   COMMIT;
   CLOSE C0001;
   IF  V_COD_RETORNO <> 2 THEN
     P_COD_RETORNO := 1;
     P_MSG_RETORNO := 'PROCESSO FINALIZADO COM SUCESSO.';
     DBMS_OUTPUT.PUT_LINE('PROCESSO FINALIZADO COM SUCESSO.');
   END IF;
   --
   COMMIT;
   --
END;
/
EXIT;
/
