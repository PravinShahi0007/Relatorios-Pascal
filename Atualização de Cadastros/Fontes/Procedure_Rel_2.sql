CREATE OR REPLACE PROCEDURE GRZ_ATUA_CADASTRAIS_REL_II (PI_OPCAO IN VARCHAR2)
 IS
  BEGIN
       DECLARE
		PI_EMPRESA                  NUMBER(02);
		PI_GRUPO                    NUMBER(04);
		PI_UNIDADE_INI				NUMBER(18);
		PI_UNIDADE_FIM		        NUMBER(18);
		PI_DTA_INI                  DATE;
		PI_DTA_FIM	                DATE;
		PI_PERFIL_INI				NUMBER(10);
		PI_PERFIL_FIM    			NUMBER(10);
		PI_USUARIO                  VARCHAR2(50);

		WI                          NUMBER;
		WF                          NUMBER;
		WDES_GRUPO                  VARCHAR2(50);
		WREGIAO                     NUMBER(04);
		WCOD_COMPLETO_INI           NUMBER(11);
		WCOD_COMPLETO_FIM           NUMBER(11);
		wDtaAnoMesAntIni			DATE;
		wDtaAnoMesAntFim    		DATE;
		wDtaMesAntIni				DATE;
		wDtaMesAntFim				DATE;
		wtemAtualizacao	    		NUMBER(18);
		SAIDA			EXCEPTION;


				/* CURSOR PARA PEGAR ATUALIZACOES DE CADASTROS DO MES ATUAL*/

		CURSOR c_cliComprasAtual IS
		SELECT GE.COD_QUEBRA
			,A.COD_UNIDADE
			,A.COD_CLIENTE
	     ,NVL(C.COD_CLASSIFICACAO_ATU,0) as codPerf
         ,LAST_DAY(A.DTA_EMISSAO) DTA_EMISSAO
         ,COUNT(DISTINCT A.NUM_SEQ) QTD_NEGOCIOS
		FROM NS_NOTAS A
		,PS_MASCARAS B
		,PS_PERFIS C
		,(SELECT NSO.NUM_SEQ,NSO.COD_MAQUINA,SUM(NVL(NSO.VLR_OPERACAO,0)) VLR_OPERACAO
          FROM NS_NOTAS_OPERACOES NSO
         WHERE NSO.COD_OPER IN (302,305)
         GROUP BY NSO.NUM_SEQ,NSO.COD_MAQUINA) OPER
				,GE_GRUPOS_UNIDADES GE
		WHERE A.COD_CLIENTE  = B.COD_PESSOA
   AND B.COD_PESSOA   = C.COD_PESSOA
   AND B.COD_MASCARA  = 50
   AND A.NUM_SEQ      = OPER.NUM_SEQ
   AND A.COD_MAQUINA  = OPER.COD_MAQUINA
   AND A.COD_UNIDADE = GE.COD_UNIDADE
   AND NVL(C.COD_CLASSIFICACAO_ATU,0) BETWEEN PI_PERFIL_INI AND PI_PERFIL_FIM
   AND GE.COD_EMP = 1
   AND GE.COD_GRUPO = PI_GRUPO
   AND NVL(A.IND_STATUS,0) = 1
   and (a.tip_nota    = 3
   OR (a.tip_nota    = 2 AND
     a.num_modelo  = 65))
   AND A.COD_CLIENTE = c.cod_pessoa
   AND NVL(A.COD_UNIDADE,0) = GE.COD_UNIDADE
   AND GE.COD_UNIDADE BETWEEN PI_UNIDADE_INI AND PI_UNIDADE_FIM
   AND A.DTA_EMISSAO BETWEEN PI_DTA_INI AND PI_DTA_FIM
 GROUP BY GE.COD_QUEBRA, NVL(C.COD_CLASSIFICACAO_ATU,0),A.COD_CLIENTE, A.COD_UNIDADE,LAST_DAY(A.DTA_EMISSAO);
r_cliComprasAtual c_cliComprasAtual%ROWTYPE;

          /* CURSOR PARA PEGAR ATUALIZACOES DE CADASTROS DO MES ANTERIOR*/

 CURSOR  c_cliComprasMes IS
  SELECT GE.COD_QUEBRA
	         ,A.COD_UNIDADE
	   	     ,A.COD_CLIENTE
	         ,NVL(C.COD_CLASSIFICACAO_ATU,0) as codPerf
             ,LAST_DAY(A.DTA_EMISSAO) DTA_EMISSAO
             ,COUNT(DISTINCT A.NUM_SEQ) QTD_NEGOCIOS
  FROM NS_NOTAS A
      ,PS_MASCARAS B
	  ,PS_PERFIS C
      ,(SELECT NSO.NUM_SEQ,NSO.COD_MAQUINA,SUM(NVL(NSO.VLR_OPERACAO,0)) VLR_OPERACAO
          FROM NS_NOTAS_OPERACOES NSO
         WHERE NSO.COD_OPER IN (302,305)
         GROUP BY NSO.NUM_SEQ,NSO.COD_MAQUINA) OPER
       ,GE_GRUPOS_UNIDADES GE
 WHERE A.COD_CLIENTE  = B.COD_PESSOA
   AND B.COD_PESSOA   = C.COD_PESSOA
   AND B.COD_MASCARA  = 50
   AND A.NUM_SEQ      = OPER.NUM_SEQ
   AND A.COD_MAQUINA  = OPER.COD_MAQUINA
   AND A.COD_UNIDADE = GE.COD_UNIDADE
   AND NVL(C.COD_CLASSIFICACAO_ATU,0) BETWEEN PI_PERFIL_INI AND PI_PERFIL_FIM
   AND GE.COD_EMP = 1
   AND GE.COD_GRUPO = PI_GRUPO
   AND NVL(A.IND_STATUS,0) = 1
   and (a.tip_nota    = 3
   OR (a.tip_nota    = 2 AND
     a.num_modelo  = 65))
   AND A.COD_CLIENTE = c.cod_pessoa
   AND NVL(A.COD_UNIDADE,0) = GE.COD_UNIDADE
   AND GE.COD_UNIDADE BETWEEN PI_UNIDADE_INI AND PI_UNIDADE_FIM
   AND A.DTA_EMISSAO BETWEEN wDtaMesAntIni AND wDtaMesAntFim
 GROUP BY GE.COD_QUEBRA, NVL(C.COD_CLASSIFICACAO_ATU,0),A.COD_CLIENTE,A.COD_UNIDADE,LAST_DAY(A.DTA_EMISSAO);
 r_cliComprasMes c_cliComprasMes%ROWTYPE;

				/* CURSOR PARA PEGAR ATUALIZACOES DE CADASTROS DO ANO ANTERIOR*/

 CURSOR  c_cliComprasAno IS
  SELECT GE.COD_QUEBRA
	         ,A.COD_UNIDADE
	   	     ,A.COD_CLIENTE
	         ,NVL(C.COD_CLASSIFICACAO_ATU,0) as codPerf
             ,LAST_DAY(A.DTA_EMISSAO) DTA_EMISSAO
             ,COUNT(DISTINCT A.NUM_SEQ) QTD_NEGOCIOS
  FROM NS_NOTAS A
      ,PS_MASCARAS B
	  ,PS_PERFIS C
      ,(SELECT NSO.NUM_SEQ,NSO.COD_MAQUINA,SUM(NVL(NSO.VLR_OPERACAO,0)) VLR_OPERACAO
          FROM NS_NOTAS_OPERACOES NSO
         WHERE NSO.COD_OPER IN (302,305)
         GROUP BY NSO.NUM_SEQ,NSO.COD_MAQUINA) OPER
       ,GE_GRUPOS_UNIDADES GE
 WHERE A.COD_CLIENTE  = B.COD_PESSOA
   AND B.COD_PESSOA   = C.COD_PESSOA
   AND B.COD_MASCARA  = 50
   AND A.NUM_SEQ      = OPER.NUM_SEQ
   AND A.COD_MAQUINA  = OPER.COD_MAQUINA
   AND A.COD_UNIDADE = GE.COD_UNIDADE
   AND NVL(C.COD_CLASSIFICACAO_ATU,0) BETWEEN PI_PERFIL_INI AND PI_PERFIL_FIM
   AND GE.COD_EMP = 1
   AND GE.COD_GRUPO = PI_GRUPO
   AND NVL(A.IND_STATUS,0) = 1
   and (a.tip_nota    = 3
   OR (a.tip_nota    = 2 AND
     a.num_modelo  = 65))
   AND A.COD_CLIENTE = c.cod_pessoa
   AND NVL(A.COD_UNIDADE,0) = GE.COD_UNIDADE
   AND GE.COD_UNIDADE BETWEEN PI_UNIDADE_INI AND PI_UNIDADE_FIM
   AND A.DTA_EMISSAO BETWEEN wDtaAnoMesAntIni AND wDtaAnoMesAntFim
 GROUP BY GE.COD_QUEBRA, NVL(C.COD_CLASSIFICACAO_ATU,0),A.COD_UNIDADE,A.COD_CLIENTE ,LAST_DAY(A.DTA_EMISSAO);
 r_cliComprasAno c_cliComprasAno%ROWTYPE;

						/* Parametros de entrada */
BEGIN

           wi := INSTR(pi_opcao, '#', 1, 1);
	       pi_empresa := TO_NUMBER(SUBSTR(pi_opcao, 1,(wi-1)));
	       wf := INSTR(pi_opcao, '#', 1, 2);
	       pi_grupo := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	       wi := wf;
		   wf := INSTR(pi_opcao, '#', 1, 3);
	       PI_UNIDADE_INI := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	       wi := wf;
		   wf := INSTR(pi_opcao, '#', 1, 4);
	       PI_UNIDADE_FIM := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	       wi := wf;
	       wf := INSTR(pi_opcao, '#', 1, 5);
	       pi_dta_ini := TO_DATE(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	       wi := wf;
	       wf := INSTR(pi_opcao, '#', 1, 6);
	       pi_dta_fim := TO_DATE(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	       wi := wf;
		   wf := INSTR(pi_opcao, '#', 1, 7);
	       PI_PERFIL_INI := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	       wi := wf;
		   wf := INSTR(pi_opcao, '#', 1, 8);
	       PI_PERFIL_FIM := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	       wi := wf;
	       wf := INSTR(pi_opcao, '#', 1, 9);
   	       pi_usuario := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));


                   /* Limpa a tabela temporaria */

DELETE FROM GRZW_ATUA_CADASTRAIS_REL_II
	        WHERE DES_USUARIO = pi_usuario;
	       COMMIT;


                   /* Variaveis para pegar data atual - 12 meses e 1 mes */

	wDtaAnoMesAntIni := ADD_MONTHS(PI_DTA_INI,-12);
	wDtaAnoMesAntFim := ADD_MONTHS(PI_DTA_FIM,-12);
	 wDtaMesAntIni := ADD_MONTHS(PI_DTA_INI,-1);
	 wDtaMesAntFim := ADD_MONTHS(PI_DTA_FIM,-1);

	OPEN c_cliComprasAtual;
    FETCH c_cliComprasAtual INTO r_cliComprasAtual;
    WHILE c_cliComprasAtual%FOUND LOOP

					 /* Select para selecionar os Clientes que atualizaram o cadastro no Mes Atual */

	BEGIN
        SELECT COUNT(DISTINCT A.COD_CLIENTE)
          into wTemAtualizacao
          FROM GRZ_LOJAS_CLIENTES_SISLOG A
              ,PS_MASCARAS B
			  ,GE_GRUPOS_UNIDADES GE
         WHERE B.COD_PESSOA = r_cliComprasAtual.COD_CLIENTE
           AND A.NUM_LOJA = r_cliComprasAtual.cod_unidade
           AND A.NUM_REDE   = B.COD_NIV1
           AND A.COD_CLIENTE = B.COD_NIV2
           AND A.DTA_MVTO BETWEEN PI_DTA_INI AND PI_DTA_FIM
           AND B.COD_MASCARA = 50
		   AND GE.COD_UNIDADE BETWEEN PI_UNIDADE_INI AND PI_UNIDADE_FIM;


     EXCEPTION
		      WHEN NO_DATA_FOUND THEN
               wtemAtualizacao := 0;
	end;

	if wtemAtualizacao > 0 then
	   wtemAtualizacao := 1;
	   else
	   wtemAtualizacao := 0;
	end if;

							/* Inserir dados na tabela */

	INSERT INTO GRZW_ATUA_CADASTRAIS_REL_II(
                                DES_USUARIO,
								COD_QUEBRA,
								COD_UNIDADE,
								COD_PERFIL,
								CLI_COMPRAS,
								CAD_ATUALIZADOS,
								DTA_EMISSAO,
								QTD_NEGOCIOS,
								IND_STATUS
							   )
                         VALUES(PI_USUARIO
							   ,r_cliComprasAtual.COD_QUEBRA
						       ,r_cliComprasAtual.COD_UNIDADE
                               ,r_cliComprasAtual.codPerf
							   ,r_cliComprasAtual.cod_cliente
							   ,wtemAtualizacao
                               ,r_cliComprasAtual.DTA_EMISSAO
							   ,r_cliComprasAtual.QTD_NEGOCIOS
							   ,1
							   );


	   FETCH c_cliComprasAtual INTO r_cliComprasAtual;
    END LOOP;
    CLOSE c_cliComprasAtual;
	COMMIT;


	OPEN c_cliComprasMes;
    FETCH c_cliComprasMes INTO r_cliComprasMes;
    WHILE c_cliComprasMes%FOUND LOOP
	begin

						/* Select para selecionar os Clientes que atualizaram o cadastro no Mes Anterior */

	    BEGIN
            SELECT COUNT(DISTINCT A.COD_CLIENTE)
              into wtemAtualizacao
              FROM GRZ_LOJAS_CLIENTES_SISLOG A
              ,PS_MASCARAS B
			  ,GE_GRUPOS_UNIDADES GE
         WHERE B.COD_PESSOA = r_cliComprasMes.COD_CLIENTE
           AND A.NUM_LOJA = r_cliComprasMes.cod_unidade
           AND A.NUM_REDE   = B.COD_NIV1
           AND A.COD_CLIENTE = B.COD_NIV2
           AND A.DTA_MVTO BETWEEN wDtaMesAntIni AND wDtaMesAntFim
           AND B.COD_MASCARA = 50
		   AND GE.COD_UNIDADE BETWEEN PI_UNIDADE_INI AND PI_UNIDADE_FIM;
         EXCEPTION
		      WHEN NO_DATA_FOUND THEN
               wtemAtualizacao := 0;
	    end;

	if wtemAtualizacao > 0 then
	   wtemAtualizacao := 1;
	else
	   wtemAtualizacao := 0;
	end if;

	INSERT INTO GRZW_ATUA_CADASTRAIS_REL_II(
                                DES_USUARIO,
								COD_QUEBRA,
								COD_UNIDADE,
								COD_PERFIL,
								CLI_COMPRAS,
                                CAD_ATUALIZADOS,
								CAD_ATUALIZADOSMES,
								DTA_EMISSAO,
								QTD_NEGOCIOS,
								IND_STATUS
							   )
                         VALUES(PI_USUARIO
							   ,r_cliComprasMes.COD_QUEBRA
						       ,r_cliComprasMes.COD_UNIDADE
                               ,r_cliComprasMes.codPerf
							   ,r_cliComprasMes.cod_cliente
							   ,0
							   ,wtemAtualizacao
                               ,r_cliComprasMes.DTA_EMISSAO
							   ,r_cliComprasMes.QTD_NEGOCIOS
							   ,2
							   );

end;
    FETCH c_cliComprasMes INTO r_cliComprasMes;
    END LOOP;
    CLOSE c_cliComprasMes;
	COMMIT;


	OPEN c_cliComprasAno;
   FETCH c_cliComprasAno INTO r_cliComprasAno;
    WHILE c_cliComprasAno%FOUND LOOP
	begin

									/* Select para selecionar os Clientes que atualizaram o cadastro no Ano Atual */

	BEGIN
        SELECT COUNT(DISTINCT A.COD_CLIENTE)
          into wtemAtualizacao
          FROM GRZ_LOJAS_CLIENTES_SISLOG A
              ,PS_MASCARAS B
			  ,GE_GRUPOS_UNIDADES GE
         WHERE B.COD_PESSOA = r_cliComprasAno.COD_CLIENTE
           AND A.NUM_LOJA = r_cliComprasAno.cod_unidade
           AND A.NUM_REDE   = B.COD_NIV1
           AND A.COD_CLIENTE = B.COD_NIV2
           AND A.DTA_MVTO BETWEEN wDtaAnoMesAntIni AND wDtaAnoMesAntFim
           AND B.COD_MASCARA = 50
		   AND GE.COD_UNIDADE BETWEEN PI_UNIDADE_INI AND PI_UNIDADE_FIM;
     EXCEPTION
		      WHEN NO_DATA_FOUND THEN
               wtemAtualizacao := 0;
	end;

	if wtemAtualizacao > 0 then
	   wtemAtualizacao := 1;
	   else
	   wtemAtualizacao := 0;
	end if;


	INSERT INTO GRZW_ATUA_CADASTRAIS_REL_II(
                                DES_USUARIO,
								COD_QUEBRA,
								COD_UNIDADE,
								COD_PERFIL,
								CLI_COMPRAS,
                                CAD_ATUALIZADOS,
								CAD_ATUALIZADOSANO,
								DTA_EMISSAO,
								QTD_NEGOCIOS,
								IND_STATUS
							   )
                         VALUES(PI_USUARIO
							   ,r_cliComprasAno.COD_QUEBRA
						       ,r_cliComprasAno.COD_UNIDADE
                               ,r_cliComprasAno.codPerf
							   ,r_cliComprasAno.cod_cliente
							   ,0
							   ,wtemAtualizacao
                               ,r_cliComprasAno.DTA_EMISSAO
							   ,r_cliComprasAno.QTD_NEGOCIOS
							   ,3
							   );

end;
	FETCH c_cliComprasAno INTO r_cliComprasAno;
    END LOOP;
    CLOSE c_cliComprasAno;
	COMMIT;


 End;
end GRZ_ATUA_CADASTRAIS_REL_II;




