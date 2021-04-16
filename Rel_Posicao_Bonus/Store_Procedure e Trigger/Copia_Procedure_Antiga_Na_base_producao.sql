CREATE OR REPLACE PROCEDURE GRZ_GERA_BONUS_ANIVERSARIO_SP
  IS
  BEGIN
  DECLARE

            wi		      NUMBER;
            wf		      NUMBER;
            wCOD_EMP          GRZ_CONTROLE_BONUS.COD_EMP%Type;
            wCOD_BONUS        GRZ_CONTROLE_BONUS.COD_BONUS%Type;
            wIND_STATUS       GRZ_CONTROLE_BONUS.IND_STATUS%Type;
            wCOD_LOTE         GRZ_CONTROLE_BONUS.COD_LOTE%Type;
            wCOD_CLIENTE      GRZ_CONTROLE_BONUS.COD_CLIENTE%Type;
            wNUM_CPF_CNPJ     GRZ_CONTROLE_BONUS.NUM_CPF_CNPJ%Type;
            wDTA_VALIDADE_RET GRZ_CONTROLE_BONUS.DTA_VALIDADE_RET%Type;
            wVLR_BONUS        GRZ_CONTROLE_BONUS.VLR_BONUS%Type;
            wDTA_SISTEMA      GRZ_CONTROLE_BONUS.DTA_SISTEMA%Type;


            -- variaveis para selecionar clientes
            wMDA             NUMBER;
            wQtdCompras      NUMBER;
            wAtrasAtual      NUMBER;
            wDataAniversario DATE;
            wQtdBonusParaCliente Number;
            wControle        Number;




	    SAIDA                   EXCEPTION;


        CURSOR c_unidades IS
        SELECT distinct (a.cod_grupo) cod_grupo from ge_grupos_unidades a
         where a.cod_emp = 1
           and a.cod_grupo in (1912,1932,1942,1952)
         order by a.cod_grupo;
        r_unidades c_unidades%ROWTYPE;

        CURSOR c_pessoas IS
        Select distinct PSFIS.DTA_NASC, PSFIS.NUM_CPF
          FROM PS_PERFIS PSPER, PS_MASCARAS PSMAS, PS_PESSOAS PSPES,
               PS_CARTOES PSCAR, PS_CLIENTES PSCLI, PS_FISICAS PSFIS
         WHERE PSMAS.COD_PESSOA = PSPER.COD_PESSOA
           AND PSPES.COD_PESSOA = PSPER.COD_PESSOA
           AND PSCAR.COD_PESSOA = PSPER.COD_PESSOA
           AND PSCLI.COD_PESSOA = PSPER.COD_PESSOA
           --AND CVTO.COD_PESSOA = PSPER.COD_PESSOA
           AND PSFIS.COD_PESSOA = PSPER.COD_PESSOA
           AND PSPER.COD_PESSOA IS NOT NULL
           AND PSMAS.COD_MASCARA = 50
           AND PSMAS.COD_NIV1 = wCOD_EMP
           AND PSPES.IND_INATIVO = 0
           --AND NVL(PSPES.COD_DEVOLUCAO,0) = 0
           AND NOT EXISTS(SELECT 1 FROM PS_FISICAS A,
                                        PS_PESSOAS B
                                  WHERE PSPES.COD_PESSOA = A.COD_PESSOA
                                    AND A.NUM_CPF = B.DES_EMAIL_CEL
                                    AND B.COD_ATIVIDADE = 99
                                    AND B.DTA_AFASTAMENTO IS NULL)
           AND NOT EXISTS (select 1 from v_dados_pessoa@grzfolha a
                            where cpf = PSFIS.Num_Cpf
                              and dta_demissao is null)
           AND NVL(PSPES.COD_BLOQ,0) < 10
           AND PSCAR.COD_SITUACAO < 4
           --AND PSCLI.COD_CLASSE_VENDA = 10
           AND NVL(QTD_COMPRAS_PRAZO,0) >= wQtdCompras
           AND PSPER.DTA_ULT_COMPRA >= TO_DATE(ADD_MONTHS(SYSDATE,-12))
           --AND CVTO.DTA_MVTO >= TO_DATE('01/01/2000','DD/MM/YYYY')
           AND EXISTS(SELECT 1 FROM GE_GRUPOS_UNIDADES GE
                       WHERE PSCLI.COD_UNIDADE=GE.COD_UNIDADE
                         AND GE.COD_EMP=1
                         AND GE.COD_GRUPO=r_unidades.cod_grupo)
           AND NVL(PSPER.VLR_PAGO_MDA,0) > 0
           AND PSPER.VLR_PAGO_REF_MDA/PSPER.VLR_PAGO_MDA <= wMDA
           AND PSPER.QTD_MAIOR_ATRASO_ATUAL = wAtrasAtual
           AND TO_CHAR(PSFIS.DTA_NASC,'DD') = to_number(to_char(wDataAniversario,'DD'))
           AND TO_CHAR(PSFIS.DTA_NASC,'MM') = to_number(to_char(wDataAniversario,'MM'));
           --and rownum <= 10;
        r_pessoas c_pessoas%ROWTYPE;

        CURSOR c_pessoas_cia IS
        Select  distinct PSFIS.DTA_NASC, PSFIS.NUM_CPF
          FROM PS_PERFIS PSPER, /*PS_MASCARAS PSMAS ,*/ PS_PESSOAS PSPES,
               PS_CARTOES PSCAR, PS_CLIENTES PSCLI, PS_FISICAS PSFIS
         WHERE --PSMAS.COD_PESSOA = PSPER.COD_PESSOA
               PSPES.COD_PESSOA = PSPER.COD_PESSOA
           AND PSCAR.COD_PESSOA = PSPER.COD_PESSOA
           AND PSCLI.COD_PESSOA = PSPER.COD_PESSOA
           --AND CVTO.COD_PESSOA = PSPER.COD_PESSOA
           AND PSFIS.COD_PESSOA = PSPER.COD_PESSOA
           AND PSPER.COD_PESSOA IS NOT NULL
           AND PSPER.DTA_ULT_COMPRA >= TO_DATE(ADD_MONTHS(SYSDATE,-12))
           --AND PSMAS.COD_MASCARA = 50
           --AND PSMAS.COD_NIV1 = wCOD_EMP
           AND PSPES.IND_INATIVO = 0
           --AND NVL(PSPES.COD_DEVOLUCAO,0) = 0
           AND NOT EXISTS(SELECT 1 FROM PS_FISICAS A,
                                        PS_PESSOAS B
                                  WHERE PSPES.COD_PESSOA = A.COD_PESSOA
                                    AND A.NUM_CPF = B.DES_EMAIL_CEL
                                    AND B.COD_ATIVIDADE = 99
                                    AND B.DTA_AFASTAMENTO IS NULL)
           AND NOT EXISTS (select 1 from v_dados_pessoa@grzfolha a
                            where cpf = PSFIS.Num_Cpf
                              and dta_demissao is null)
           AND NVL(PSPES.COD_BLOQ,0) < 10
           AND PSCAR.COD_SITUACAO < 4
           AND PSCLI.COD_CLASSE_VENDA = 10
           AND NVL(QTD_COMPRAS_PRAZO,0) >= wQtdCompras
           --AND CVTO.DTA_MVTO >= TO_DATE('01/01/2000','DD/MM/YYYY')
           AND EXISTS(SELECT 1 FROM GE_GRUPOS_UNIDADES GE
                       WHERE PSCLI.COD_UNIDADE=GE.COD_UNIDADE
                         AND GE.COD_EMP=1
                         AND GE.COD_GRUPO=970)
           AND NVL(PSPER.VLR_PAGO_MDA,0) > 0
           AND PSPER.VLR_PAGO_REF_MDA/PSPER.VLR_PAGO_MDA <= wMDA
           AND PSPER.QTD_MAIOR_ATRASO_ATUAL = wAtrasAtual
           AND TO_CHAR(PSFIS.DTA_NASC,'DD') = to_number(to_char(wDataAniversario,'DD'))
           AND TO_CHAR(PSFIS.DTA_NASC,'MM') = to_number(to_char(wDataAniversario,'MM'));
           --and rownum <= 10;
        r_pessoas_cia c_pessoas_cia%ROWTYPE;

          /**** Inicio da procedure principal ****/
          BEGIN
          	-- variaveis para todas as redes
          	wMDA         := 10;
                wQtdCompras  := 1;
                wAtrasAtual  := 0;
                wDataAniversario := trunc(sysdate + 7);

	         OPEN c_unidades;
	         FETCH c_unidades INTO r_unidades;
	         WHILE c_unidades%FOUND LOOP
	         BEGIN
	             wDTA_SISTEMA := sysdate;
	             wIND_STATUS  := 1;

	             if r_unidades.cod_grupo = 1912 then
	               -- variaveis por rede
          	        wCOD_EMP     := 10;
                        wCOD_LOTE    := 9910;
                        wVLR_BONUS   := 10;
                        wQtdBonusParaCliente := 1;
                     elsif r_unidades.cod_grupo = 1932 then
          	        wCOD_EMP     := 30;
                        wCOD_LOTE    := 9930;
                        wVLR_BONUS   := 5;
                        wQtdBonusParaCliente := 2;
                     elsif r_unidades.cod_grupo = 1942 then
          	        wCOD_EMP     := 40;
                        wCOD_LOTE    := 9940;
                        wVLR_BONUS   := 50;
                        wQtdBonusParaCliente := 1;
                     elsif r_unidades.cod_grupo = 1952 then
          	        wCOD_EMP     := 50;
                        wCOD_LOTE    := 9950;
                        wVLR_BONUS   := 10;
                        wQtdBonusParaCliente := 1;
                     end if;

                     OPEN c_pessoas;
	             FETCH c_pessoas INTO r_pessoas;
	             WHILE c_pessoas%FOUND LOOP
	             BEGIN
                         wCOD_CLIENTE := r_pessoas.num_cpf;
                         wNUM_CPF_CNPJ := r_pessoas.num_cpf;
                         --wDTA_VALIDADE_RET := add_months(to_char(r_pessoas.dta_nasc,'DD/MM/')||to_char(wDataAniversario,'YYYY'),1); -- um mês de validade
                         wDTA_VALIDADE_RET := trunc(add_months(wDataAniversario,1));  -- um mês de validade
                         wControle := 1;


                         while wControle <= wQtdBonusParaCliente loop -- while pq a pormenos gera dois bônus por cliente
                         begin
                              begin
                                  SELECT nvl(MAX(COD_BONUS),0) + 1
                                    Into wCOD_BONUS
                                    FROM GRZ_CONTROLE_BONUS
                                   WHERE COD_EMP  = wCOD_EMP
                                     AND COD_LOTE = wCOD_LOTE;
	      	               EXCEPTION
		  	          WHEN NO_DATA_FOUND THEN
	                                 wCOD_BONUS := 0;
                              end;


                              if wCOD_BONUS > 0 then
                              begin
                                  insert into GRZ_CONTROLE_BONUS (COD_EMP, COD_BONUS, IND_STATUS, COD_LOTE, COD_CLIENTE, NUM_CPF_CNPJ, DTA_VALIDADE_RET, VLR_BONUS, DTA_SISTEMA)
                              	                          VALUES (wCOD_EMP, wCOD_BONUS, wIND_STATUS, wCOD_LOTE, wCOD_CLIENTE, wNUM_CPF_CNPJ, wDTA_VALIDADE_RET, wVLR_BONUS, wDTA_SISTEMA);
                              end;
                              end if;

                              wControle := wControle + 1;
                        end;
                        end loop;


                     END;
                     FETCH c_pessoas INTO r_pessoas;
                     END LOOP;
                     CLOSE c_pessoas;

                 commit;
                 END;
                 FETCH c_unidades INTO r_unidades;
                 END LOOP;
                 CLOSE c_unidades;


                 wCOD_EMP     := 70;
                 wCOD_LOTE    := 9970;
                 wVLR_BONUS   := 10;
                 -- execução da cia separada pq o cliente ganha um bônus apenas
	         OPEN c_pessoas_cia;
	         FETCH c_pessoas_cia INTO r_pessoas_cia;
	         WHILE c_pessoas_cia%FOUND LOOP
	         BEGIN
                     wCOD_CLIENTE := r_pessoas_cia.num_cpf;
                     wNUM_CPF_CNPJ := r_pessoas_cia.num_cpf;
                     wDTA_VALIDADE_RET := trunc(add_months(wDataAniversario,1));  -- um mês de validade

                     begin
                         SELECT nvl(MAX(COD_BONUS),0) + 1
                           Into wCOD_BONUS
                           FROM GRZ_CONTROLE_BONUS
                          WHERE COD_EMP  = wCOD_EMP
                            AND COD_LOTE = wCOD_LOTE;
	      	      EXCEPTION
		           WHEN NO_DATA_FOUND THEN
	                        wCOD_BONUS := 0;
                     end;


                     if wCOD_BONUS > 0 then
                     begin
                     	 insert into GRZ_CONTROLE_BONUS (COD_EMP, COD_BONUS, IND_STATUS, COD_LOTE, COD_CLIENTE, NUM_CPF_CNPJ, DTA_VALIDADE_RET, VLR_BONUS, DTA_SISTEMA)
                     	                         VALUES (wCOD_EMP, wCOD_BONUS, wIND_STATUS, wCOD_LOTE, wCOD_CLIENTE, wNUM_CPF_CNPJ, wDTA_VALIDADE_RET, wVLR_BONUS, wDTA_SISTEMA);
                     end;
                     end if;


                 END;
                 FETCH c_pessoas_cia INTO r_pessoas_cia;
                 END LOOP;
                 CLOSE c_pessoas_cia;

               commit;

               EXCEPTION
                   WHEN SAIDA THEN
                       NULL;

END;
END GRZ_GERA_BONUS_ANIVERSARIO_SP;


