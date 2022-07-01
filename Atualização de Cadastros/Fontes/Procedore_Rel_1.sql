CREATE OR REPLACE PROCEDURE GRZ_ATUA_CADASTRAIS_REL_I(PI_OPCAO IN VARCHAR2)
 IS
  BEGIN
       DECLARE
        PI_EMPRESA                  NUMBER(02);
 	    PI_GRUPO                    NUMBER(04);
 	    PI_DTA_INI                  DATE;
        PI_DTA_FIM	                DATE;
 	    pi_usuario                  VARCHAR2(50);

     	WI                          NUMBER;
  	    WF                          NUMBER;
     	WDES_GRUPO                  VARCHAR2(50);
     	WREGIAO                     NUMBER(04);
 	    WCOD_COMPLETO_INI           NUMBER(11);
        WCOD_COMPLETO_FIM           NUMBER(11);
        CliComp                     NUMBER(18,2);
        Tot                         NUMBER(18,2);
		wtemAtualizacao	    		NUMBER(18);

        SAIDA			EXCEPTION;





   /****CURSOR PARA PEGAR ATUALIZAÇOES DE CADASTROS DE TODAS AS LOJAS DA REDE****/

    CURSOR  c_cliCompras IS
SELECT ge.cod_quebra
       ,A.COD_UNIDADE
	   ,C.DES_FANTASIA
       ,A.COD_CLIENTE
      ,LAST_DAY(A.DTA_EMISSAO) DTA_EMISSAO
      ,COUNT(DISTINCT A.NUM_SEQ) QTD_NEGOCIOS
  FROM NS_NOTAS A
      ,PS_MASCARAS B
	  ,PS_PESSOAS C
      ,(SELECT NSO.NUM_SEQ,NSO.COD_MAQUINA,SUM(NVL(NSO.VLR_OPERACAO,0)) VLR_OPERACAO
          FROM NS_NOTAS_OPERACOES NSO
         WHERE NSO.COD_OPER IN (302,305)
         GROUP BY NSO.NUM_SEQ,NSO.COD_MAQUINA) OPER
      ,GE_GRUPOS_UNIDADES GE
 WHERE A.COD_CLIENTE  = B.COD_PESSOA
   AND B.COD_MASCARA  = 50
   AND A.NUM_SEQ      = OPER.NUM_SEQ
   AND A.COD_MAQUINA  = OPER.COD_MAQUINA
   AND A.COD_UNIDADE = GE.COD_UNIDADE
   AND A.COD_UNIDADE=C.COD_PESSOA
   AND GE.COD_EMP = 1
   AND GE.COD_GRUPO = 940
   AND NVL(A.IND_STATUS,0) = 1
   AND A.TIP_NOTA = 3
   AND A.DTA_EMISSAO BETWEEN PI_DTA_INI AND PI_DTA_FIM
 GROUP BY ge.cod_quebra, A.COD_CLIENTE, c.des_fantasia, A.COD_UNIDADE,LAST_DAY(A.DTA_EMISSAO);
r_cliCompras c_cliCompras%ROWTYPE;

/**** segundo cursor ****/


BEGIN

           wi := INSTR(pi_opcao, '#', 1, 1);
	       pi_empresa := TO_NUMBER(SUBSTR(pi_opcao, 1,(wi-1)));
	       wf := INSTR(pi_opcao, '#', 1, 2);
	       pi_grupo := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	       wi := wf;
	       wf := INSTR(pi_opcao, '#', 1, 3);
	       pi_dta_ini := TO_DATE(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	       wi := wf;
	       wf := INSTR(pi_opcao, '#', 1, 4);
	       pi_dta_fim := TO_DATE(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	       wi := wf;
	       wf := INSTR(pi_opcao, '#', 1, 5);
   	       pi_usuario := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));

		   
/**** Limpa a tabela temporaria ****/
DELETE FROM GRZW_ATUA_CADASTRAIS_REL_I
	        WHERE DES_USUARIO = pi_usuario;
	       COMMIT;

/**** inser campos do primeiro cursor na tabela ****/

	OPEN c_cliCompras;
    FETCH c_cliCompras INTO r_cliCompras;
    WHILE c_cliCompras%FOUND LOOP
	BEGIN
	
	SELECT COUNT(DISTINCT A.COD_CLIENTE)
          into wTemAtualizacao
          FROM GRZ_LOJAS_CLIENTES_SISLOG A
              ,PS_MASCARAS B
			  ,GE_GRUPOS_UNIDADES GE
         WHERE B.COD_PESSOA = r_cliCompras.COD_CLIENTE
           AND A.NUM_LOJA = r_cliCompras.cod_unidade
           AND A.NUM_REDE   = B.COD_NIV1
           AND A.COD_CLIENTE = B.COD_NIV2
           AND A.DTA_MVTO BETWEEN PI_DTA_INI AND PI_DTA_FIM
           AND B.COD_MASCARA = 50;
	

	INSERT INTO GRZW_ATUA_CADASTRAIS_REL_I(
                           DES_USUARIO
						  ,COD_QUEBRA
                          ,COD_UNIDADE
                          ,DES_FANTASIA
                          ,CLI_COMPRAS
                          ,CAD_ATUALIZADOS)
                        VALUES(PI_USUARIO
						      ,r_cliCompras.COD_QUEBRA
                              ,r_cliCompras.COD_UNIDADE
                              ,r_cliCompras.DES_FANTASIA
                              ,r_cliCompras.COD_CLIENTE
                              ,wTemAtualizacao
                              );

	

	END;
      FETCH c_cliCompras INTO r_cliCompras;
    END LOOP;
    CLOSE c_cliCompras;
	COMMIT;



END;
end GRZ_ATUA_CADASTRAIS_REL_I;


