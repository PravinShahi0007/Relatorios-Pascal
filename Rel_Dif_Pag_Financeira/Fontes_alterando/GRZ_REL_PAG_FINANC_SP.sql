CREATE OR REPLACE PROCEDURE GRZ_REL_PAG_FINANC_SP
  (PI_OPCAO IN VARCHAR2, PO_RETORNO OUT VARCHAR2)
  IS
  BEGIN
  DECLARE
		  /**** Parametros de entrada ****/
		  pi_emp		  	NUMBER;
		  pi_grupo         	        NUMBER;
		  pi_uni_ini              	NUMBER;
	  	  pi_uni_fim              	NUMBER;
          	  pi_data_ini             	DATE;
	          pi_data_fim		  	DATE;
	          pi_cod_produto                VARCHAR2(15);
	          pi_usuario              	VARCHAR2(50);

	          /**** Variaveis de trabalho ****/
                  wi		                NUMBER;
                  wf		          	NUMBER;
                  wDes_Nome_Rede                VARCHAR2(50);
                  wDes_Unidade                  VARCHAR2(50);
                  wTip_Titulo_ini               NUMBER;
                  wTip_Titulo_fim               NUMBER;
                  wCod_Grupo                    NUMBER;
                  wDia_Util                     NUMBER;
                  wDta_Util                     DATE;
                  wDta_Vcto                     DATE;
                  wCod_Produto                  NUMBER;
                  v_cur                         INTEGER;
                  v_result                      INTEGER;


                  SAIDA                         EXCEPTION;


         /* Cursor da tabela CR_TITULOS para FINANCIAMENTO */
           CURSOR c_fin_cr_titulos is
            /* select tit.cod_emp
                   ,tit.cod_unidade
                   ,tit.dta_vencimento
                   ,sum(nvl(tit.vlr_cdc,0)) vlr_cr
                   ,sum(nvl(tit.vlr_cdc,0)) vlr_cr_total
             from cr_titulos tit
             where tit.cod_emp         = pi_emp
               and tit.cod_unidade    >= pi_uni_ini
               and tit.cod_unidade    <= pi_uni_fim
               and tit.dta_vencimento >= pi_data_ini
               and tit.dta_vencimento <= pi_data_fim
               and tit.tip_titulo in (wTip_Titulo_ini,wTip_Titulo_fim)
               and exists (select 1 from ge_grupos_unidades ge
                            where tit.cod_unidade = ge.cod_unidade
                              and ge.cod_grupo    = pi_grupo
                              and ge.cod_emp      = pi_emp)
		       and  exists (select 1 from es_0124_cr_cdc_apro es
                       where tit.cod_emp = es.cod_emp
                       and tit.cod_unidade = es.cod_unidade
                       and tit.cod_pessoa = es.cod_pessoa
                       and tit.num_titulo = es.num_titulo
                       and tit.num_parcela = es.num_parcela
                       and tit.cod_compl = es.cod_compl
                       and es.tip_apro = 0
                       )
             group by tit.cod_emp
                     ,tit.cod_unidade
                     ,tit.dta_vencimento
             order by tit.cod_emp
                     ,tit.cod_unidade
                     ,tit.dta_vencimento; */
            select his.cod_emp
                   ,his.cod_unidade
                   ,his.dta_contabil dta_vencimento
                   ,sum(nvl(his.vlr_lancamento,0)) vlr_cr
                   ,sum(nvl(his.vlr_lancamento,0))+sum(nvl(vlr_juro_cobr,0))+sum(nvl(vlr_desp_cobr,0))-sum(nvl(vlr_desconto,0)) vlr_cr_total

			 from cr_historicos his
                 ,cr_titulos tit
             where his.cod_pessoa     = tit.cod_pessoa
               and his.cod_emp        = tit.cod_emp
               and his.cod_unidade    = tit.cod_unidade
               and his.num_titulo     = tit.num_titulo
               and his.cod_compl      = tit.cod_compl
               and his.num_parcela    = tit.num_parcela
               and tit.dta_vencimento>= '01/07/2021'
               and his.cod_emp        = pi_emp
               and his.cod_unidade   >= pi_uni_ini
               and his.cod_unidade   <= pi_uni_fim
               and his.cod_lancamento in (SELECT cod_lancamento FROM  t4_cod_lctos_quebras
										   where cod_grupo = 300)
               and his.dta_contabil  >= pi_data_ini
               and his.dta_contabil  <= pi_data_fim
               and tit.tip_titulo in (wTip_Titulo_ini,wTip_Titulo_fim)
               and his.cod_portador_atu in (1000)
			    and  exists (select 1 from es_0124_cr_cdc_apro es
                       where tit.cod_emp = es.cod_emp
                       and tit.cod_unidade = es.cod_unidade
                       and tit.cod_pessoa = es.cod_pessoa
                       and tit.num_titulo = es.num_titulo
                       and tit.num_parcela = es.num_parcela
                       and tit.cod_compl = es.cod_compl
                       and es.tip_apro = 0
                       )
               and exists (select 1 from ge_grupos_unidades ge
                            where his.cod_unidade = ge.cod_unidade
                              and ge.cod_grupo    = pi_grupo
                              and ge.cod_emp      = pi_emp)
             group by his.cod_emp
                     ,his.cod_unidade
                     ,his.dta_contabil
             order by his.cod_emp
                     ,his.cod_unidade
                     ,his.dta_contabil;

           r_fin_cr_titulos c_fin_cr_titulos%ROWTYPE;


         /* Cursor da tabela CR_TITULOS para EMPRESTIMO */
           CURSOR c_emp_cr_titulos is
             select his.cod_emp
                   ,his.cod_unidade
                   ,his.dta_contabil
                   ,sum(nvl(his.vlr_lancamento,0)) vlr_cr
                   ,sum(nvl(his.vlr_lancamento,0))+sum(nvl(vlr_juro_cobr,0))+sum(nvl(vlr_desp_cobr,0))-sum(nvl(vlr_desconto,0)) vlr_cr_total

			 from cr_historicos his
                 ,cr_titulos tit
             where his.cod_pessoa     = tit.cod_pessoa
               and his.cod_emp        = tit.cod_emp
               and his.cod_unidade    = tit.cod_unidade
               and his.num_titulo     = tit.num_titulo
               and his.cod_compl      = tit.cod_compl
               and his.num_parcela    = tit.num_parcela
               and his.cod_emp        = pi_emp
               and his.cod_unidade   >= pi_uni_ini
               and his.cod_unidade   <= pi_uni_fim
               and his.cod_lancamento in (SELECT cod_lancamento FROM  t4_cod_lctos_quebras
										   where cod_grupo = 300)
               and his.dta_contabil  >= pi_data_ini
               and his.dta_contabil  <= pi_data_fim
               and tit.tip_titulo in (wTip_Titulo_ini,wTip_Titulo_fim)
               --and his.cod_portador_atu in (1000)
			    and  exists (select 1 from es_0124_cr_cdc_apro es
                       where tit.cod_emp = es.cod_emp
                       and tit.cod_unidade = es.cod_unidade
                       and tit.cod_pessoa = es.cod_pessoa
                       and tit.num_titulo = es.num_titulo
                       and tit.num_parcela = es.num_parcela
                       and tit.cod_compl = es.cod_compl
                       and es.tip_apro = 0
                       )
               and exists (select 1 from ge_grupos_unidades ge
                            where his.cod_unidade = ge.cod_unidade
                              and ge.cod_grupo    = pi_grupo
                              and ge.cod_emp      = pi_emp)
             group by his.cod_emp
                     ,his.cod_unidade
                     ,his.dta_contabil
             order by his.cod_emp
                     ,his.cod_unidade
                     ,his.dta_contabil;

           r_emp_cr_titulos c_emp_cr_titulos%ROWTYPE;


         /* Cursor da tabela ES_0124_CR_CDC_APRO para FINANCIAMENTO E EMPRESTIMO */
           CURSOR c_cdc_apro is
	     select esapro.cod_emp
                   ,esapro.cod_unidade
                   ,esapro.dta_apro
                   ,sum(nvl(esapro.vlr_total,0)) vlr_apro
                   ,sum(nvl(esapro.vlr_liquido,0)) vlr_apro_total
				   , (sum(nvl(esapro.vlr_liquido,0))) -  (sum(nvl(esapro.vlr_total,0)))  AS JUROS
             from es_0124_cr_cdc_apro esapro
             where esapro.cod_emp      = pi_emp
               and esapro.cod_unidade >= pi_uni_ini
               and esapro.cod_unidade <= pi_uni_fim
               and esapro.dta_apro    >= pi_data_ini
               and esapro.dta_apro    <= pi_data_fim
               and esapro.tip_apro     = 1
               and esapro.cod_produto  = pi_cod_produto
               and esapro.tip_titulo in (wTip_Titulo_ini,wTip_Titulo_fim)
               and exists (select 1 from ge_grupos_unidades ge
                            where esapro.cod_unidade = ge.cod_unidade
                              and ge.cod_grupo       = pi_grupo
                              and ge.cod_emp         = pi_emp)
             group by esapro.cod_emp
                     ,esapro.cod_unidade
                     ,esapro.dta_apro
             order by esapro.cod_emp
                     ,esapro.cod_unidade
                     ,esapro.dta_apro;

           r_cdc_apro c_cdc_apro%ROWTYPE;



             /**** Inicio da procedure principal ****/
              BEGIN
               v_cur := dbms_sql.open_cursor;
               dbms_sql.parse(v_cur,'alter session set nls_date_format= "dd/mm/rrrr"',dbms_sql.native);
               v_result := dbms_sql.execute(v_cur);
               dbms_sql.close_cursor(v_cur);


	           /**** Desmembra a opcao recebida ****/
	           wi := INSTR(pi_opcao, '#', 1, 1);
                   pi_emp := TO_NUMBER(SUBSTR(pi_opcao, 1,(wi-1)));
   	           wf := INSTR(pi_opcao, '#', 1, 2);
	           pi_grupo := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	           wi := wf;
	           wf := INSTR(pi_opcao, '#', 1, 3);
	           pi_uni_ini := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	           wi := wf;
	           wf := INSTR(pi_opcao, '#', 1, 4);
   	           pi_uni_fim := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
                   wi := wf;
	           wf := INSTR(pi_opcao, '#', 1, 5);
	           pi_data_ini := TO_DATE(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	           wi := wf;
	           wf := INSTR(pi_opcao, '#', 1, 6);
	           pi_data_fim := TO_DATE(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	           wi := wf;
	           wf := INSTR(pi_opcao, '#', 1, 7);
	           pi_cod_produto := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));
	           wi := wf;
	           wf := INSTR(pi_opcao, '#', 1, 8);
	           pi_usuario := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));


                   delete from GRZ_REL_PAG_FINANC
                   where upper(des_usuario) = upper(pi_usuario);
                   commit;

                   if pi_cod_produto = 'FINANCIAMENTO' then
                      wTip_Titulo_ini := 70;
                      wTip_Titulo_fim := 71;
                      wCod_Produto    := 1;
                   else
                      wTip_Titulo_ini := 72;
                      wTip_Titulo_fim := 73;
                      wCod_Produto    := 0;
                   end if;


                   /* Ele verifica qual o tipo de titulo selecionado e abre o cursor do mesmo */
                   /* Fazendo a soma dos pagamentos dos titulos definidos por Tipo de Titulo por Loja e grava na tabela GRZ_REL_PAG_FINANC */

               if wCod_Produto = 1 then

                  /* Abre o cursor do Financiamento que seleciona os pagamentos da CR_TITULOS */
	           OPEN c_fin_cr_titulos;
	           FETCH c_fin_cr_titulos INTO r_fin_cr_titulos;
	           WHILE c_fin_cr_titulos%FOUND LOOP
	           BEGIN

                             /* busca nome da unidade */
                         begin
                              SELECT des_nome
                                    ,cod_nivel2
                               INTO wDes_Unidade
                                   ,wCod_Grupo
                               FROM GE_UNIDADES
                               WHERE COD_UNIDADE = r_fin_cr_titulos.cod_unidade;
                               EXCEPTION
                                 WHEN NO_DATA_FOUND THEN
                                     wDes_Unidade  := 'Unidade nao Cadastrada';
                                     wCod_Grupo    := 0;
                         end;

                             /* nome da rede */
                             if wCod_Grupo = 810 then
                                wDes_Nome_Rede := 'Rede Grazziotin';
                             elsif wCod_Grupo = 830 then
                                wDes_Nome_Rede := 'Rede PorMenos';
                             elsif wCod_Grupo = 840 then
                                wDes_Nome_Rede := 'Rede Franco Giorgi';
                             elsif wCod_Grupo = 850 then
                                wDes_Nome_Rede := 'Rede Tottal';
                             else
                                wDes_Nome_Rede := 'Rede nao Cadastrada';
                             end if;

           	       /* localiza os vencimentos que n?o est?o em dia util e forca-os para o proximo dia util */
          	        wDia_Util       := 0;
          	        wDta_Util       := r_fin_cr_titulos.dta_vencimento;
          	        wDta_Vcto       := r_fin_cr_titulos.dta_vencimento;
          	        while wDia_Util  = 0 loop
          	           begin
	  		        select dta_calendario
	  		             ,per_util
	  		         into wDta_Util
	  		             ,wDia_Util
	  		         from ge_datas_calendario
	  		         where cod_calendario = 10
	  		           and dta_calendario  = wDta_Vcto;
	  		         exception
	                           when NO_DATA_FOUND then
	                             wDia_Util := 0;
	                             wDta_Util := wDta_Vcto;
	  	           end;
	  	           wDta_Vcto := wDta_Vcto + 1;
	  	        end loop;
	  	        r_fin_cr_titulos.dta_vencimento := wDta_Util;

                           begin
               	                  insert into GRZ_REL_PAG_FINANC  (DES_USUARIO
           	              	   			          ,DES_REDE
           	              				          ,COD_UNIDADE
           	              				          ,DES_UNIDADE
           	              				          ,DTA_CONTABIL
           	              				          ,VLR_CR
           	              				          ,VLR_CDC_APRO
           	              				          ,VLR_CR_TOTAL
           	              				          ,VLR_CDC_APRO_TOTAL)
           	              			            VALUES(pi_usuario
           	              			                  ,wDes_Nome_Rede
           	              			                  ,r_fin_cr_titulos.cod_unidade
           	              			                  ,wDes_Unidade
           	              			                  ,r_fin_cr_titulos.dta_vencimento
           	              			                  ,r_fin_cr_titulos.vlr_cr
           	              			                  ,0
           	              			                  ,r_fin_cr_titulos.vlr_cr_total
           	              			                  ,0
           	              			                  );
                           end;
                   END;
	           FETCH c_fin_cr_titulos INTO r_fin_cr_titulos;
                   END LOOP;
                   CLOSE c_fin_cr_titulos;
                   COMMIT;

              else

                   /* Abre o cursor do Emprestimo que seleciona os pagamentos da CR_TITULOS */
	           OPEN c_emp_cr_titulos;
	           FETCH c_emp_cr_titulos INTO r_emp_cr_titulos;
	           WHILE c_emp_cr_titulos%FOUND LOOP
	           BEGIN

                             /* busca nome da unidade */
                         begin
                              SELECT des_nome
                                    ,cod_nivel2
                               INTO wDes_Unidade
                                   ,wCod_Grupo
                               FROM GE_UNIDADES
                               WHERE COD_UNIDADE = r_emp_cr_titulos.cod_unidade;
                               EXCEPTION
                                 WHEN NO_DATA_FOUND THEN
                                     wDes_Unidade  := 'Unidade nao Cadastrada';
                                     wCod_Grupo    := 0;
                         end;

                             /* nome da rede */
                             if wCod_Grupo = 810 then
                                wDes_Nome_Rede := 'Rede Grazziotin';
                             elsif wCod_Grupo = 830 then
                                wDes_Nome_Rede := 'Rede PorMenos';
                             elsif wCod_Grupo = 840 then
                                wDes_Nome_Rede := 'Rede Franco Giorgi';
                             elsif wCod_Grupo = 850 then
                                wDes_Nome_Rede := 'Rede Tottal';
                             else
                                wDes_Nome_Rede := 'Rede nao Cadastrada';
                             end if;

                           begin
               	                  insert into GRZ_REL_PAG_FINANC  (DES_USUARIO
           	              	   			          ,DES_REDE
           	              				          ,COD_UNIDADE
           	              				          ,DES_UNIDADE
           	              				          ,DTA_CONTABIL
           	              				          ,VLR_CR
           	              				          ,VLR_CDC_APRO
           	              				          ,VLR_CR_TOTAL
           	              				          ,VLR_CDC_APRO_TOTAL)
           	              			            VALUES(pi_usuario
           	              			                  ,wDes_Nome_Rede
           	              			                  ,r_emp_cr_titulos.cod_unidade
           	              			                  ,wDes_Unidade
           	              			                  ,r_emp_cr_titulos.dta_contabil
           	              			                  ,r_emp_cr_titulos.vlr_cr
           	              			                  ,0
           	              			                  ,r_emp_cr_titulos.vlr_cr_total
           	              			                  ,0
           	              			                  );
                           end;
                   END;
	           FETCH c_emp_cr_titulos INTO r_emp_cr_titulos;
                   END LOOP;
                   CLOSE c_emp_cr_titulos;
                   COMMIT;

               end if;


                   /**** Abre o cursor da ES_0124_CR_CDC_APRO ****/
                   /***    para FINANCIAMENTO E EMPRESTIMO    ***/
                   /* Ele faz a soma dos pagamentos da Apro definido por Tipo de Titulo por Loja e grava na tabela GRZ_REL_PAG_FINANC */

	           OPEN c_cdc_apro;
	           FETCH c_cdc_apro INTO r_cdc_apro;
	           WHILE c_cdc_apro%FOUND LOOP
	           BEGIN
                            /* busca nome da unidade */
                             begin
                                  SELECT des_nome
                                        ,cod_nivel2
                                   INTO wDes_Unidade
                                       ,wCod_Grupo
                                   FROM GE_UNIDADES
                                   WHERE COD_UNIDADE = r_cdc_apro.cod_unidade;
                                   EXCEPTION
                                    WHEN NO_DATA_FOUND THEN
                                       wDes_Unidade  := 'Unidade nao Cadastrada';
                                       wCod_Grupo    := 0;
                             end;

                            /* nome da rede */
                             if wCod_Grupo = 810 then
                                wDes_Nome_Rede := 'Rede Grazziotin';
                             elsif wCod_Grupo = 830 then
                                wDes_Nome_Rede := 'Rede PorMenos';
                             elsif wCod_Grupo = 840 then
                                wDes_Nome_Rede := 'Rede Franco Giorgi';
                             elsif wCod_Grupo = 850 then
                                wDes_Nome_Rede := 'Rede Tottal';
                             else
                                wDes_Nome_Rede := 'Rede nao Cadastrada';
                             end if;

                           begin
           	                insert into GRZ_REL_PAG_FINANC (DES_USUARIO
           	               				       ,DES_REDE
           	              				       ,COD_UNIDADE
           	              				       ,DES_UNIDADE
           	              				       ,DTA_CONTABIL
           	              				       ,VLR_CR
           	              				       ,VLR_CDC_APRO
           	              				       ,VLR_CR_TOTAL
           	              				       ,VLR_CDC_APRO_TOTAL,
											   VLR_JUROS)
           	              			         VALUES(pi_usuario
           	              			               ,wDes_Nome_Rede
           	              			               ,r_cdc_apro.cod_unidade
           	              			               ,wDes_Unidade
           	              			               ,r_cdc_apro.dta_apro
           	              			               ,0
           	              			               ,r_cdc_apro.vlr_apro
           	              			               ,0
           	              			               ,r_cdc_apro.vlr_apro_total
												   ,r_cdc_apro.juros
           	              			               );
                           end;

                   END;
	           FETCH c_cdc_apro INTO r_cdc_apro;
                   END LOOP;
                   CLOSE c_cdc_apro;
                   COMMIT;

              EXCEPTION
                WHEN SAIDA THEN
                    NULL;
              END;

   END GRZ_REL_PAG_FINANC_SP;


