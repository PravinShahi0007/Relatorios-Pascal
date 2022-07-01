CREATE OR REPLACE PROCEDURE GRZ_APROPRIACAO_FINANCEIRA_SP
  (PI_OPCAO IN VARCHAR2)
  IS
  BEGIN
  DECLARE
	    	pi_emp                      	number;
	    	pi_grupo                        number;
	    	pi_uni_ini		    	number;
	    	pi_uni_fim		    	number;
	    	pi_data_ini		    	date;
	    	pi_data_fim		    	date;
	    	pi_produto		    	number;

            wi	                    number;
            wf		            	number;
            wPri_Vez                number;
            wProduto_Ant            varchar2(50);
            wDta_Inicial            date;
	        v_cur                   INTEGER;
            v_result                INTEGER;


	        saida                           exception;

	cursor c_apropriacao is
                 SELECT A.COD_PRODUTO
                       ,B.DTA_APRO dta_oper
                       ,SUM(NVL(A.VLR_APRO,0)) VLR_APRO
                   FROM ES_0124_CR_CDC_APRO A
                       ,ES_0124_CR_CDC_APRO B
                  WHERE A.COD_EMP=B.COD_EMP
                    AND A.COD_UNIDADE=B.COD_UNIDADE
                    AND A.COD_PESSOA=B.COD_PESSOA
                    AND A.NUM_TITULO=B.NUM_TITULO
                    AND A.COD_COMPL=B.COD_COMPL
                    AND A.NUM_PARCELA=B.NUM_PARCELA
                    AND A.DTA_APRO BETWEEN pi_data_ini AND pi_data_fim
                    AND A.TIP_APRO IN (1,2)
                    AND NVL(A.IND_LP,0) <> 1
                    AND EXISTS (SELECT 1 FROM GE_GRUPOS_UNIDADES GE
                                 WHERE A.COD_UNIDADE=GE.COD_UNIDADE
                                   AND GE.COD_GRUPO=pi_grupo
                                   AND GE.COD_EMP=pi_emp
                                   AND GE.COD_UNIDADE>=pi_uni_ini
                                   AND GE.COD_UNIDADE<=pi_uni_fim)
                    AND B.TIP_APRO=0
                 GROUP BY A.COD_PRODUTO
                          ,B.DTA_APRO
                 ORDER BY A.COD_PRODUTO
                          ,B.DTA_APRO;
	r_apropriacao c_apropriacao%rowtype;


  	  file_handle UTL_FILE.FILE_TYPE;
          nome_arq    VARCHAR2(100);

          BEGIN
	       v_cur := dbms_sql.open_cursor;
           dbms_sql.parse(v_cur,'alter session set nls_date_format= "dd/mm/rrrr"',dbms_sql.native);
           v_result := dbms_sql.execute(v_cur);
           dbms_sql.close_cursor(v_cur);



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


	       nome_arq := 'Apropriacao_'||to_char(pi_grupo)||'.txt';
	       --file_handle := UTL_FILE.FOPEN('/mnt/sisgraz/TechBox',nome_arq,'W');
	       file_handle := UTL_FILE.FOPEN('/mnt/nlgestao/nlcomum/Financeira',nome_arq,'W');

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

		    if pi_produto = 0 then
		        UTL_FILE.PUT_LINE(file_handle,r_apropriacao.cod_produto||';'
						||to_char(r_apropriacao.dta_oper,'dd/mm/yyyy')||';'
						||to_char(r_apropriacao.vlr_apro)||';');
		    elsif pi_produto = 1 then
		        if r_apropriacao.cod_produto = 'FINANCIAMENTO' then
		            UTL_FILE.PUT_LINE(file_handle,r_apropriacao.cod_produto||';'
						||to_char(r_apropriacao.dta_oper,'dd/mm/yyyy')||';'
						||to_char(r_apropriacao.vlr_apro)||';');
			end if;
		    elsif pi_produto = 2 then
		        if r_apropriacao.cod_produto = 'EMPRESTIMO' then
		            UTL_FILE.PUT_LINE(file_handle,r_apropriacao.cod_produto||';'
						||to_char(r_apropriacao.dta_oper,'dd/mm/yyyy')||';'
						||to_char(r_apropriacao.vlr_apro)||';');
			end if;
		    end if;
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
  END GRZ_APROPRIACAO_FINANCEIRA_SP;




