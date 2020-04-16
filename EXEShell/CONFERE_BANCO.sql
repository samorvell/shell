SET LINESIZE 180
spool /tmp/arq.txt
 
-- NOTAS FISCAIS DO DIA
SELECT store.store_no LOJA, decode( COUNT(*) ,0, 'Nao deve exitir nenhuma NF apos fechamento: ', 'Erro exitem Notas apos Fechamento: ')||COUNT(*) "QTD Notas no sistema" 
  FROM INVOICE, STORE
 GROUP BY STORE.STORE_NO;  
    
  
-- VENDA DE FEVEREIRO 
SELECT TO_CHAR(SUM(TOT_NM_FOOD),'999G999G999D99') "VENDA DO MES"
  FROM HIST_INVOICE
 WHERE TO_CHAR(INVOICE_DATE,'mmyyyy')=022011 -- MES E ANO  
   AND PROC_IND = 1;
   
 
-- VALOR ESTOQUE DA LOJA  
SELECT TO_CHAR( SUM(NVL(STOCK,0) * NVL(VCCUSULT,0)) ,'999G999G999D999') "Estoque da Loja"
  FROM ARTICLE
  WHERE NVL(STOCK,0) <>0;
  
  
--CALENDARIO LOJA
SELECT CAL_DATE, DECODE(IND_OPEN,0,'NAO ABRE',1,'ABERTA',2,'EXECUTOU FECHAMENTO' ) STATUS
  FROM CALENDAR
 WHERE CAL_DATE BETWEEN TO_DATE('10022011','ddmmyyyy') AND TO_DATE('15022011','ddmmyyyy');    
 
spool off;
exit;
