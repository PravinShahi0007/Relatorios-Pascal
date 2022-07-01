CREATE OR REPLACE PROCEDURE GRZ_CRE_ANALITICO_SP
  (PI_OPCAO IN VARCHAR2)
  IS
  BEGIN
  DECLARE
        pi_emp                        number;
        pi_grupo                        number;
        pi_uni_ini          number;
        pi_uni_fim          number;
        pi_data_ini          date;
        pi_data_fim          date;
        pi_produto          number;

                wi            number;
                wf                  number;
                wPri_Vez                  number;
                wProduto_Ant                    varchar2(50);
                wDta_Inicial                    date;

          saida                           exception;

  cursor c_apropriacao is

              SELECT A.DTA_APRO DTA_APROPRIACAO
                                ,A.TIP_APRO TIPO
                ,A.COD_UNIDADE LOJA
                ,B.COD_COMPLETO CLIENTE
                ,A.COD_COMPL PRODUTO
                ,A.NUM_TITULO CONTRATO
                ,A.NUM_PARCELA PARCELA
                ,A.VLR_APRO VLR_APROPRIADO
              FROM ES_0124_CR_CDC_APRO A
                ,PS_MASCARAS B
                ,GE_GRUPOS_UNIDADES C
              WHERE A.COD_PESSOA=B.COD_PESSOA
              AND A.COD_UNIDADE=C.COD_UNIDADE
              AND C.COD_GRUPO = pi_grupo
              AND C.COD_EMP=1
              AND A.COD_PRODUTO='FINANCIAMENTO'
              AND A.DTA_APRO BETWEEN pi_data_ini AND pi_data_fim
              AND A.TIP_APRO IN(1,2)
              AND NVL(A.VLR_APRO,0) > 0
              AND B.COD_MASCARA=50
              AND B.COD_NIV1= pi_emp
              ORDER BY A.DTA_APRO,A.TIP_APRO,A.COD_UNIDADE,B.COD_COMPLETO,
              A.COD_COMPL,A.NUM_TITULO,A.NUM_PARCELA;




  r_apropriacao c_apropriacao%rowtype;


      file_handle UTL_FILE.FILE_TYPE;
          nome_arq    VARCHAR2(100);
      AUXILIAR    VARCHAR2(10);
	  AUXILIAR2    VARCHAR2(20);
      wRede      VARCHAR2(15);


          BEGIN
         wi := INSTR(pi_opcao, '#', 1, 1);
         pi_emp    := TO_NUMBER(SUBSTR(pi_opcao, 1,(wi-1)));
         wf := INSTR(pi_opcao, '#', 1, 2);
            pi_grupo  := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
               wi := wf;
         wf := INSTR(pi_opcao, '#', 1, 3);
         pi_uni_ini   := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
               wi := wf;
         wf := INSTR(pi_opcao, '#', 1, 4);
         pi_uni_fim   := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
               wi := wf;
         wf := INSTR(pi_opcao, '#', 1, 5);
         pi_data_ini  := to_date(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
               wi := wf;
         wf := INSTR(pi_opcao, '#', 1, 6);
         pi_data_fim  := to_date(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
               wi := wf;
         wf := INSTR(pi_opcao, '#', 1, 7);
         pi_produto  := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));

         AUXILIAR := SUBSTR(pi_data_ini,4,2);

        if (SUBSTR(pi_grupo,2,2) = 10) then

        wRede :='GRZ';

        end if;

      if (SUBSTR(pi_grupo,2,2) = 30) then

        wRede :='PRM';

        end if;

      if (SUBSTR(pi_grupo,2,2) = 40) then

        wRede :='FRG';

        end if;

      if (SUBSTR(pi_grupo,2,2)= 50) then

        wRede :='TOT';

        end if;

      if(wRede = '') then

        wRede := to_char(pi_grupo);
      end if;


         nome_arq := 'RENDAS_CRE_ANALITICO_'||AUXILIAR||'_'||wRede||'.txt';
         file_handle := UTL_FILE.FOPEN('/sisgraz/TechBox',nome_arq,'W');
         -----file_handle := UTL_FILE.FOPEN('/nlcomum/financeira',nome_arq,'W');

         wProduto_Ant := '';
         wPri_Vez     := 0;

         OPEN c_apropriacao;
         FETCH c_apropriacao INTO r_apropriacao;
         WHILE c_apropriacao%FOUND LOOP
         BEGIN
              /*
                if (wPri_Vez = 0) or
                   (wProduto_Ant <> r_apropriacao.cod_produto) then
              wDta_Inicial := r_apropriacao.dta_oper;
              wPri_Vez     := 1;
              wProduto_Ant := r_apropriacao.cod_produto;
          end if;
          while wDta_Inicial < r_apropriacao.dta_oper loop
            UTL_FILE.PUT_LINE(file_handle,r_apropriacao.cod_produto||';'
            ||to_char(wDta_Inicial,'dd/mm/yyyy')||';'
            ||'0;');
                        wDta_Inicial := wDta_Inicial + 1;
          end loop;
       */
				 AUXILIAR2 :=to_char(r_apropriacao.VLR_APROPRIADO);
				 
			if (SUBSTR(AUXILIAR2,1,1) = ',') then
			
			AUXILIAR2 := '0'||AUXILIAR2;
			end if;
				 
              -- grava na linha do arquivo
            UTL_FILE.PUT_LINE(file_handle,to_char(r_apropriacao.DTA_APROPRIACAO)||';'
            ||to_char(r_apropriacao.TIPO)||';'
            ||to_char(r_apropriacao.LOJA)||';'
            ||to_char(r_apropriacao.CLIENTE)||';'
            ||to_char(r_apropriacao.PRODUTO)||';'
            ||to_char(r_apropriacao.CONTRATO)||';'
            ||to_char(r_apropriacao.PARCELA)||';'
            ||AUXILIAR2||';');

        ----wDta_Inicial := wDta_Inicial + 1;
               END;
               FETCH c_apropriacao INTO r_apropriacao;
               END LOOP;
               CLOSE c_apropriacao;

               UTL_FILE.FCLOSE(file_handle);

               EXCEPTION
                   WHEN SAIDA THEN
                       NULL;
           END;
  END GRZ_CRE_ANALITICO_SP;
