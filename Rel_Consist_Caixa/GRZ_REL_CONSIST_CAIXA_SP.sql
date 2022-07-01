CREATE OR REPLACE PROCEDURE GRZ_REL_CONSIST_CAIXA_SP
  (PI_OPCAO IN VARCHAR2, PO_RETORNO OUT VARCHAR2)
  IS
  BEGIN
  DECLARE
	  /* Parametros de entrada ****/
	  v_result                integer;
      v_cur                   integer;

	  pi_rede	                NUMBER;
	  pi_grupo	                NUMBER;
	  pi_uni_ini                    NUMBER;
	  pi_uni_fim                    NUMBER;
	  pi_data_ini                   DATE;
	  pi_data_fim			DATE;
	  pi_usuario                    VARCHAR2(50);

	  /* Variaveis de trabalho */
          wi			        NUMBER;
          wf		                NUMBER;
          wDiferenca            	NUMBER;
          wCod_Grupo                    NUMBER;
          Cod_Grupo                     NUMBER;
          wCod_Rede                     NUMBER;
          wVlr_Cartao                   NUMBER(18,2);
          wDes_Rede                     VARCHAR2(50);
          wDes_Rede_Cartao              VARCHAR2(50);
          wDes_Nome_Rede                VARCHAR2(50);
          wDes_Unidade                  VARCHAR2(50);
          wDes_Origem                   VARCHAR2(20);
          w				NUMBER;
          wRegErro                      NUMBER;
          wAtualizados                  NUMBER;
          wSeqConta                     NUMBER;

	  /* variaveis v.vista e v.entrada*/
          wNum_equipamento		NUMBER;
          wValor_lcto			NUMBER(18,2);


	  pi_conta_cp         		VARCHAR2(50);
	  pi_conta_cb        		VARCHAR2(50);
	  pi_conta_nt			NUMBER;
	  pi_conta_cred                 NUMBER;


          /* Variaveis de trabalho cred_pessoal */
          wDes_Conta                	VARCHAR2(50);
          wConta_Editado    		VARCHAR2(10);
          wValor	    		NUMBER(18,2);
          wValor2	    		NUMBER(18,2);
          vlr_cartao                    NUMBER(18,2);

          SAIDA             		EXCEPTION;


       /* Cursor da tabela GRZ_TEF_TRANSACAO_SERVIDOR */
       CURSOR c_tef_servidor IS
         select a.cod_emp
               ,a.cod_unidade
               ,a.dta_movimento
               ,a.num_nsusitef
               ,a.des_rede
               ,a.num_equipamento
               ,a.vlr_lcto
               ,a.hor_movimento
               ,a.num_nsuhost
               ,a.cod_resposta
               ,a.cod_estabelecimento
               ,a.num_sequencia
          from grz_tef_transacao_servidor a
         where a.cod_emp = pi_rede
           and a.cod_unidade >= pi_uni_ini
           and a.cod_unidade <= pi_uni_fim
           and a.dta_movimento >= pi_data_ini
           and a.dta_movimento <= pi_data_fim
           and a.cod_resposta = '00'
           and a.ind_cancelado = 0
           and a.des_operacao not like '%CANC%'
           and not exists (select 1 from grz_tef_transacao_servidor c
                           where a.cod_emp = c.cod_emp
                           and a.cod_unidade = c.cod_unidade
                           and a.dta_movimento = c.dta_movimento
                           and trim(a.num_nsuhost) = trim(c.nsu_host_cancel)
                           and c.cod_resposta = '00');

       r_tef_servidor c_tef_servidor%ROWTYPE;


       /* Cursor da tabela CX_MOVIMENTOS */
       CURSOR c_tef_caixas IS
         select a.cod_emp
               ,a.cod_caixa
               ,a.dta_mvto_caixa
               ,a.cod_conta_cb
               ,sum(nvl(a.vlr_entrada,0)) vlr_entrada
               ,sum(nvl(a.vlr_saida,0)) vlr_saida
          from cx_movimentos a
         where a.cod_emp = 1
           and a.cod_caixa >= pi_uni_ini
           and a.cod_caixa <= pi_uni_fim
           and a.dta_mvto_caixa >= pi_data_ini
           and a.dta_mvto_caixa <= pi_data_fim
           and (a.cod_operacao <> 216
                and cod_operacao <> 217)
           and ((instr(','||pi_conta_cb||',', ','||a.cod_conta_cb||',') > 0)
		    or (a.cod_conta_cb = 7 and trim(a.des_hist1) = 'PIX'))
           and exists (select 1 from ge_grupos_unidades ge
                        where a.cod_caixa = ge.cod_unidade
                          and ge.cod_grupo = pi_grupo  /*wCod_Grupo*/
                          and ge.cod_emp = 1)
       group by a.cod_emp,a.cod_caixa,a.dta_mvto_caixa,a.cod_conta_cb;

       r_tef_caixas c_tef_caixas%ROWTYPE;


       /* Cursor da tabela CX_MOVIMENTOS */
       CURSOR c_caixas_mvto IS
         select a.cod_emp
               ,a.cod_caixa
               ,a.dta_mvto_caixa
               ,a.cod_conta_cb
               ,nvl(a.vlr_saida,0) vlr_saida
               ,nvl(a.vlr_entrada,0) vlr_entrada
          from cx_movimentos a
         where a.cod_emp = 1
           and a.cod_caixa >= pi_uni_ini
           and a.cod_caixa <= pi_uni_fim
           and a.dta_mvto_caixa >= pi_data_ini
           and a.dta_mvto_caixa <= pi_data_fim
           and a.cod_conta_cb in (pi_conta_cred,229,220,221,223,469,325)/*430,431,432,433*/
           and exists (select 1 from ge_grupos_unidades ge
                        where a.cod_caixa = ge.cod_unidade
                          and ge.cod_grupo = pi_grupo
                          and ge.cod_emp = 1
                          and ge.cod_unidade >= pi_uni_ini
                          and ge.cod_unidade <= pi_uni_fim);
       r_caixas_mvto c_caixas_mvto%ROWTYPE;


       /* Cursor da tabela NS_NOTAS cred_pessoal*/
       CURSOR c_notas_mvto IS
         select c.cod_emp
               ,c.cod_unidade
               ,c.dta_emissao
               ,sum(nvl(a.vlr_operacao,0)) vlr_operacao
               ,sum(nvl(a.vlr_acrescimo_cob,0)) vlr_acrescimo
               ,sum(nvl(a.vlr_desconto_cob,0)) vlr_desconto
               ,sum(to_number(nvl(d.vlr_coluna,'0'))) vlr_tac
               ,sum(to_number(nvl(e.vlr_coluna,'0'))) vlr_iof
          from ns_notas c
              ,ns_notas_operacoes a
              ,ns_notas_colunas d
              ,ns_notas_colunas e
         where c.num_seq=a.num_seq
           and c.cod_maquina=a.cod_maquina
           and a.cod_oper in (3000,3050)
           and c.num_seq=d.num_seq(+)
           and c.cod_maquina=d.cod_maquina(+)
           and d.seq_coluna(+)=6
           and c.num_seq=e.num_seq(+)
           and c.cod_maquina=e.cod_maquina(+)
           and e.seq_coluna(+)=5
           and c.cod_unidade >= pi_uni_ini
           and c.cod_unidade <= pi_uni_fim
           and c.dta_emissao >= pi_data_ini
           and c.dta_emissao <= pi_data_fim
           and nvl(c.ind_status,1) = 1
           and exists (select 1 from ge_grupos_unidades ge
                        where c.cod_unidade = ge.cod_unidade
                          and ge.cod_grupo = pi_grupo
                          and ge.cod_emp = 1
                          and ge.cod_unidade >= pi_uni_ini
                          and ge.cod_unidade <= pi_uni_fim)
        group by c.cod_emp,c.cod_unidade,c.dta_emissao;
       r_notas_mvto c_notas_mvto%ROWTYPE;


       /* Cursor da tabela NE_NOTAS  NTF */
       CURSOR c_notas_serv_mvto IS
         select c.cod_emp
               ,c.cod_unidade
               ,c.dta_recebimento
               ,sum(nvl(a.vlr_operacao,0)) vlr_operacao
               ,sum(nvl(a.vlr_despesas_nota,0)) vlr_despesas_nota
          from ne_notas c
              ,ne_notas_operacoes a
         where c.num_seq=a.num_seq
           and c.cod_maquina=a.cod_maquina
           and a.cod_oper in (106,107,4106,4107)
           and c.cod_unidade >= pi_uni_ini
           and c.cod_unidade <= pi_uni_fim
           and c.dta_recebimento >= pi_data_ini
           and c.dta_recebimento <= pi_data_fim
           and nvl(c.ind_status,1) = 1
           and exists (select 1 from ge_grupos_unidades ge
                        where c.cod_unidade   = ge.cod_unidade
                          and ge.cod_grupo    = pi_grupo
                          and ge.cod_emp      = 1
                          and ge.cod_unidade >= pi_uni_ini
                          and ge.cod_unidade <= pi_uni_fim)
         group by c.cod_emp,c.cod_unidade,c.dta_recebimento;

	 r_notas_serv_mvto c_notas_serv_mvto%ROWTYPE;

       /**** cursor valor avista e valor entrada*****/
       cursor c_venda_mvto is
          select a.cod_unidade
                ,a.dta_emissao
                ,a.num_nota
                ,a.cod_portador
                ,a.num_equipamento
                ,b.cod_oper
	            ,sum(b.vlr_entrada) vlr_entrada
                ,sum(b.vlr_operacao) vlr_venda
                ,count(1)
             from ns_notas a
                  ,ns_notas_operacoes b
             where a.num_seq = b.num_seq
                   and a.cod_maquina=b.cod_maquina
                   and a.cod_unidade >= pi_uni_ini
                   and a.cod_unidade <= pi_uni_fim
                   and a.dta_emissao between pi_data_ini and pi_data_fim
                   and nvl(a.ind_status,1) = 1
                   and exists (select 1 from ge_grupos_unidades ge
                       where a.cod_unidade = ge.cod_unidade
                             and ge.cod_grupo = pi_grupo
                             and ge.cod_emp = 1)
             group by a.cod_unidade,a.dta_emissao,a.num_nota,a.cod_portador,a.num_equipamento,b.cod_oper;

         r_venda_mvto c_venda_mvto%ROWTYPE;



         /* cursor valor recebimento e juros */
         cursor C_RECEB_JURO_MVTO IS
         	select a.dta_pagamento,
         	       a.cod_emp,
                       a.cod_unidade_pgto,
                       sum(nvl(a.vlr_lancamento,0)) vlr_parcela,
                       sum(nvl(a.vlr_juro_cobr,0)) + sum(nvl(vlr_desp_cobr,0)) vlr_juros
                   from cr_historicos a
                   where a.cod_emp = 1
                         and (instr(','||'20,75,77,78,100'||',', ','||a.cod_lancamento||',') > 0)
                         and a.dta_pagamento   >= to_date(PI_DATA_INI,'dd/mm/yyyy')
                         and a.dta_pagamento   <= to_date(PI_DATA_FIM,'dd/mm/yyyy')
                         and a.cod_unidade_pgto between pi_uni_ini and pi_uni_fim
                         and exists (select 1 from ge_grupos_unidades ge
                               where a.cod_unidade_pgto = ge.cod_unidade
                                 and ge.cod_grupo = pi_grupo
                                 and ge.cod_emp = 1)
                 group by dta_pagamento, cod_emp, dta_contabil, cod_unidade_pgto, cod_lancamento;

         r_receb_juro_mvto c_receb_juro_mvto%ROWTYPE;


          /* Inicio da procedure principal */
          BEGIN

		       v_cur := dbms_sql.open_cursor;
               dbms_sql.parse(v_cur,'alter session set nls_date_format= "dd/mm/rrrr"',dbms_sql.native);
               v_result := dbms_sql.execute(v_cur);
               dbms_sql.close_cursor(v_cur);

	       /* Desmembra a opcao recebida */

	       wi := INSTR(pi_opcao, '#', 1, 1);
	       pi_rede := TO_NUMBER(SUBSTR(pi_opcao, 1,(wi-1)));
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
               pi_usuario := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));




	       pi_conta_cb := '467,438,439,478,479,556,710,734,754';
	       pi_conta_nt := 229;

               if pi_rede = 10 then
                  pi_conta_cred := 430;
               elsif pi_rede = 50 then
                  pi_conta_cred := 431;
               elsif pi_rede = 30 then
                  pi_conta_cred := 432;
               elsif pi_rede = 40 then
                  pi_conta_cred := 433;
			   elsif pi_rede = 70 then
                  pi_conta_cred := 729;
               end if;

               delete from GRZ_TEF_TRANSACAO_DIVERGENCIAS
               where upper(des_usuario) = upper(pi_usuario);
               commit;


          /* busca nome do grupo de unidades */
          begin
               SELECT des_grupo
                 INTO wDes_Rede
                 FROM GE_GRUPOS
                WHERE COD_GRUPO = pi_grupo;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                      wDes_Rede := 'GRUPO NAO CADASTRADO';
          end;

          wCod_Rede := pi_grupo;

               /* Abre o cursor NL do Tef ****/
	       OPEN c_tef_servidor;
	       FETCH c_tef_servidor INTO r_tef_servidor;
	       WHILE c_tef_servidor%FOUND LOOP
	       BEGIN
                         /* nome da rede */
                         if r_tef_servidor.cod_emp = 10 then
                             wDes_Nome_Rede := 'Rede Grazziotin';
                         elsif r_tef_servidor.cod_emp = 20 then
                             wDes_Nome_Rede := 'Rede Tech Box';
                         elsif r_tef_servidor.cod_emp = 30 then
                             wDes_Nome_Rede := 'Rede PorMenos';
                         elsif r_tef_servidor.cod_emp = 40 then
                             wDes_Nome_Rede := 'Rede Franco Giorgi';
                         elsif r_tef_servidor.cod_emp = 50 then
                             wDes_Nome_Rede := 'Rede Tottal';
					     elsif r_tef_servidor.cod_emp = 70 then
                             wDes_Nome_Rede := 'CIA';
                         else
                             wDes_Nome_Rede := 'Rede nao Cadastrada';
                         end if;

                         /* nome da origem do tef */
                         wDes_Origem := 'TEF';

                         /* busca nome da unidade */
                         begin
                              SELECT des_nome
                                INTO wDes_Unidade
                                FROM GE_UNIDADES
                               WHERE COD_UNIDADE = r_tef_servidor.cod_unidade;
                              EXCEPTION
                                  WHEN NO_DATA_FOUND THEN
                                     wDes_Unidade  := 'Unidade nao Cadastrada';
                         end;

                         /*if pi_ind_rede_orig = 4 then*/
                              wDes_Rede_Cartao := ' ';
                         /*else
                              wDes_Rede_Cartao := r_tef_servidor.des_rede;
                         end if;*/

                 begin
           	        insert into GRZ_TEF_TRANSACAO_DIVERGENCIAS(DES_USUARIO
           	                    ,COD_EMP
           	                    ,COD_UNIDADE
           	                    ,DTA_MOVIMENTO
           	                    ,NUM_NSUSITEF
           	                    ,DES_REDE
           	                    ,DES_BANDEIRA
           	                    ,NUM_EQUIPAMENTO
           	                    ,VLR_LCTO
           	                    ,NUM_CUPOM
           	                    ,HOR_MOVIMENTO
           	                    ,TIP_ORIGEM
           	                    ,NUM_NSUHOST
           	                    ,IND_CANCELADO
           	                    ,HOR_MOVIMENTO_SERV
           	                    ,NUM_EQUIPAMENTO_SERV
           	                    ,NUM_NSUHOST_SERV
           	                    ,VLR_LCTO_SERV
           	                    ,COD_RESPOSTA
           	                    ,COD_ESTABELECIMENTO
				    ,NUM_SEQUENCIA_SERV
           	                    ,DES_ORIGEM
           	                    ,DES_NOME_REDE
           	                    ,DES_UNIDADE
           	                    ,VLR_DIFERENCA)
           	                    VALUES(pi_usuario
           	                           ,r_tef_servidor.cod_emp
           	                           ,r_tef_servidor.cod_unidade
           	                           ,r_tef_servidor.dta_movimento
           	                           ,r_tef_servidor.num_nsusitef
           	                           ,wDes_Rede_Cartao
           	                           ,wDes_Rede_Cartao
           	                           ,70 /* ,r_tef_servidor.num_equipamento */
           	                           ,0 /* VLR_LCTO*/
           	                           ,0
           	                           ,null
           	                           ,0
           	                           ,'0'
           	                           ,0
           	                           ,r_tef_servidor.hor_movimento
           	                           ,r_tef_servidor.num_equipamento
           	                           ,r_tef_servidor.num_nsuhost
           	                           ,r_tef_servidor.vlr_lcto
           	                           ,r_tef_servidor.cod_resposta
           	                           ,r_tef_servidor.cod_estabelecimento
           	                           ,r_tef_servidor.num_sequencia
           	                           ,wDes_Origem
           	                           ,wDes_Nome_Rede
           	                           ,wDes_Unidade
           	                           ,0
           	                           );
           	     end;
               END;
               FETCH c_tef_servidor INTO r_tef_servidor;
               END LOOP;
               CLOSE c_tef_servidor;


               Cod_Grupo := pi_grupo;


               /* Abre o cursor dos Caixas ****/
	       OPEN c_tef_caixas;
	       FETCH c_tef_caixas INTO r_tef_caixas;
	       WHILE c_tef_caixas%FOUND LOOP
	       BEGIN
                         /* nome da origem do tef */
                         wDes_Origem := 'TEF';

                         /* busca nome da unidade */
                         begin
                              SELECT des_nome
                                    ,cod_nivel2
                                INTO wDes_Unidade
                                    ,wCod_Grupo
                                FROM GE_UNIDADES
                               WHERE COD_UNIDADE = r_tef_caixas.cod_caixa;
                              EXCEPTION
                                  WHEN NO_DATA_FOUND THEN
                                     wDes_Unidade  := 'Unidade nao Cadastrada';
                                     wCod_Grupo    := 0;
                         end;

                         /* nome da rede */
                         if wCod_Grupo = 810 then
                             wCod_Rede      := 10;
                             wDes_Nome_Rede := 'Rede Grazziotin';
                         elsif wCod_Grupo = 820 then
                             wCod_Rede      := 20;
                             wDes_Nome_Rede := 'Rede Tech Box';
                         elsif wCod_Grupo = 830 then
                             wCod_Rede      := 30;
                             wDes_Nome_Rede := 'Rede PorMenos';
                         elsif wCod_Grupo = 840 then
                             wCod_Rede      := 40;
                             wDes_Nome_Rede := 'Rede Franco Giorgi';
                         elsif wCod_Grupo = 850 then
                             wCod_Rede      := 50;
                             wDes_Nome_Rede := 'Rede Tottal';
					     elsif wCod_Grupo = 870 then
                             wCod_Rede      := 70;
                             wDes_Nome_Rede := 'CIA';
                         else
                             wCod_Rede      := 0;
                             wDes_Nome_Rede := 'Rede nao Cadastrada';
                         end if;

                         /* busca nome da rede administradora do cartao */
                         /*if r_tef_caixas.cod_conta_cb = 467 then
                             wDes_Rede_Cartao  := 'BANRISUL';
                         elsif (r_tef_caixas.cod_conta_cb = 438) then
                             wDes_Rede_Cartao  := 'VISANET';
                         elsif (r_tef_caixas.cod_conta_cb = 439) then
                             wDes_Rede_Cartao  := 'REDECARD';
                         else
                             wDes_Rede_Cartao  := 'INEXISTENTE';
                         end if;*/

                         /*if pi_ind_rede_orig = 4 then*/
                              wDes_Rede_Cartao := ' ';
                         /*end if;*/

                         begin
           	              wVlr_Cartao := r_tef_caixas.vlr_saida - r_tef_caixas.vlr_entrada;

						  insert into GRZ_TEF_TRANSACAO_DIVERGENCIAS(DES_USUARIO
           	                  		  	                ,COD_EMP
           	                		  	                ,COD_UNIDADE
           	                                                   	,DTA_MOVIMENTO
           	                                                   	,NUM_NSUSITEF
           	                                                   	,DES_REDE
           	                                                   	,DES_BANDEIRA
           	                                                   	,NUM_EQUIPAMENTO
           	                                                   	,VLR_LCTO
           	                                                   	,NUM_CUPOM
           	                                                   	,HOR_MOVIMENTO
           	                                                   	,TIP_ORIGEM
           	                                                   	,NUM_NSUHOST
           	                                                   	,IND_CANCELADO
           	                                                   	,HOR_MOVIMENTO_SERV
           	                                                   	,NUM_EQUIPAMENTO_SERV
           	                                                   	,NUM_NSUHOST_SERV
           	                                                   	,VLR_LCTO_SERV
           	                                                   	,COD_RESPOSTA
           	                                                   	,COD_ESTABELECIMENTO
           	                		  	                ,NUM_SEQUENCIA_SERV
           	                                                   	,DES_ORIGEM
           	                                                   	,DES_NOME_REDE
           	                                                   	,DES_UNIDADE
           	                                                   	,VLR_DIFERENCA)
           	                                                  VALUES(pi_usuario
           	                                                        ,wCod_Rede
           	                                                        ,r_tef_caixas.cod_caixa
           	                                                        ,r_tef_caixas.dta_mvto_caixa
           	                                                        ,NULL
           	                                                        ,wDes_Rede_Cartao
           	                                                        ,wDes_Rede_Cartao
           	                                                        ,70 /*NULL*/
           	                                                        ,wVlr_Cartao
           	                                                        ,NULL
           	                                                        ,NULL
           	                                                        ,0
           	                                                        ,NULL
           	                                                        ,NULL
           	                                                        ,NULL
           	                                                        ,NULL
           	                                                        ,NULL
           	                                                        ,0
           	                                                        ,NULL
           	                                                        ,NULL
           	                                                        ,NULL
           	                                                        ,wDes_Origem
           	                                                        ,wDes_Nome_Rede
           	                                                        ,wDes_Unidade
           	                                                        ,0
           	                                                        );
           	         end;
            END;
            FETCH c_tef_caixas INTO r_tef_caixas;
            END LOOP;
            CLOSE c_tef_caixas;


          /* Cursor com todas as contas dos valores de caixa */
	  OPEN  c_caixas_mvto;
	  FETCH c_caixas_mvto INTO r_caixas_mvto;
	  WHILE c_caixas_mvto%FOUND LOOP
	  BEGIN
             /* busca nome da unidade */
             begin
                SELECT des_nome
                      ,cod_nivel2
                  INTO wDes_Unidade
                      ,wCod_Rede
                  FROM GE_UNIDADES
                 WHERE COD_UNIDADE = r_caixas_mvto.cod_caixa;
                EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                          wDes_Unidade  := 'Unidade nao Cadastrada';
                          wCod_Rede    := 0;
             end;
             /*if r_caixas_mvto.cod_conta_cb = 430 or
                r_caixas_mvto.cod_conta_cb = 431 or
                r_caixas_mvto.cod_conta_cb = 432 or
                r_caixas_mvto.cod_conta_cb = 433 then*/
             if (r_caixas_mvto.cod_conta_cb = pi_conta_cred) then
                  wSeqConta := 80;
             elsif r_caixas_mvto.cod_conta_cb = 229 then
                wSeqConta := 60;
             elsif r_caixas_mvto.cod_conta_cb = 220 then
                wSeqConta := 10;
             elsif r_caixas_mvto.cod_conta_cb = 221 then
                wSeqConta := 20;
             elsif r_caixas_mvto.cod_conta_cb = 223 then
                wSeqConta := 30;
             elsif r_caixas_mvto.cod_conta_cb = 469 then
                wSeqConta := 40;
             elsif r_caixas_mvto.cod_conta_cb = 325 then
                wSeqConta := 50;
             end if;

             wValor:=0;

             if (r_caixas_mvto.cod_conta_cb = 221) then
                wValor := nvl(r_caixas_mvto.vlr_entrada,0);
             elsif (r_caixas_mvto.cod_conta_cb = 229) or
                    (r_caixas_mvto.cod_conta_cb = pi_conta_cred) then
                     /*r_caixas_mvto.cod_conta_cb = 430 or
                     r_caixas_mvto.cod_conta_cb = 431 or
                     r_caixas_mvto.cod_conta_cb = 432 or
                     r_caixas_mvto.cod_conta_cb = 433 then*/
                        wValor :=  nvl(r_caixas_mvto.vlr_saida,0) - nvl(r_caixas_mvto.vlr_entrada,0);
             else
                wValor := nvl(r_caixas_mvto.vlr_entrada,0) - nvl(r_caixas_mvto.vlr_saida,0);
             end if;

             insert into GRZ_TEF_TRANSACAO_DIVERGENCIAS(DES_USUARIO
       	        				   	      ,COD_EMP
                        	                	      ,COD_UNIDADE
       	                                                      ,DTA_MOVIMENTO
                        	                              ,DES_REDE
                        	                              ,NUM_EQUIPAMENTO
		 				              ,VLR_LCTO
                        	                              ,VLR_LCTO_SERV
                        	                              ,VLR_DIFERENCA
                        	                              ,DES_UNIDADE
                        	                              ,COD_AUTORIZACAO
                        	                              ,DES_ORIGEM)
       	                                         VALUES(pi_usuario
                        	                              ,r_caixas_mvto.cod_emp
                        	                              ,r_caixas_mvto.cod_caixa
                        	                              ,r_caixas_mvto.dta_mvto_caixa
                        	                              ,SUBSTR(wDes_Rede,1,20)
                        	                              ,wSeqConta
		 				              ,wValor
                        	                              ,0
                        	                              ,0
                        	                              ,wDes_Unidade
                        	                              ,wConta_Editado
                        	                              ,SUBSTR(wDes_Conta,1,20));
          END;
          FETCH c_caixas_mvto INTO r_caixas_mvto;
          END LOOP;
          CLOSE c_caixas_mvto;


	  /* Valor NL Credito Pessoal */
	  OPEN c_notas_mvto;
	  FETCH c_notas_mvto INTO r_notas_mvto;
	  WHILE c_notas_mvto%FOUND LOOP
	  BEGIN
             /* busca nome da unidade */
             begin
                SELECT des_nome
                      ,cod_nivel2
                  INTO wDes_Unidade
                      ,wCod_Rede
                  FROM GE_UNIDADES
                 WHERE COD_UNIDADE = r_notas_mvto.cod_unidade;
                EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                          wDes_Unidade  := 'Unidade nao Cadastrada';
                          wCod_Rede    := 0;
             end;
            if r_notas_mvto.dta_emissao > to_date('15/01/2008','dd/mm/yyyy') then
                wValor := nvl(r_notas_mvto.vlr_operacao,0) - nvl(r_notas_mvto.vlr_tac,0) - nvl(r_notas_mvto.vlr_iof,0);
            else
                wValor := nvl(r_notas_mvto.vlr_operacao,0) - nvl(r_notas_mvto.vlr_tac,0);
            end if;
            insert into GRZ_TEF_TRANSACAO_DIVERGENCIAS(DES_USUARIO
       	       				   	      ,COD_EMP
                       	                	      ,COD_UNIDADE
       	                                              ,DTA_MOVIMENTO
                       	                              ,DES_REDE
                       	                              ,NUM_EQUIPAMENTO
					              ,VLR_LCTO
                       	                              ,VLR_LCTO_SERV
                       	                              ,VLR_DIFERENCA
                       	                              ,DES_UNIDADE
                       	                              ,COD_AUTORIZACAO
                       	                              ,DES_ORIGEM)
       	                                        VALUES(pi_usuario
                       	                              ,r_notas_mvto.cod_emp
                       	                              ,r_notas_mvto.cod_unidade
                       	                              ,r_notas_mvto.dta_emissao
                       	                              ,SUBSTR(wDes_Rede,1,20)
                       	                              ,80
						      ,0
                       	                              ,wValor
                       	                              ,0
                       	                              ,wDes_Unidade
                       	                              ,wConta_Editado
                       	                              ,SUBSTR(wDes_Conta,1,20));
          END;
          FETCH c_notas_mvto INTO r_notas_mvto;
          END LOOP;
          CLOSE c_notas_mvto;




	  /* Abre o cursor NL das NOTAS  NTF****/
	  OPEN c_notas_serv_mvto;
	  FETCH c_notas_serv_mvto INTO r_notas_serv_mvto;
	  WHILE c_notas_serv_mvto%FOUND LOOP
	  BEGIN
             /* busca nome da unidade */
             begin
                SELECT des_nome
                      ,cod_nivel2
                  INTO wDes_Unidade
                      ,wCod_Rede
                  FROM GE_UNIDADES
                 WHERE COD_UNIDADE = r_notas_serv_mvto.cod_unidade;
                EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                          wDes_Unidade  := 'Unidade nao Cadastrada';
                          wCod_Rede    := 0;
             end;

              insert into GRZ_TEF_TRANSACAO_DIVERGENCIAS(DES_USUARIO
       	                              		              ,COD_EMP
                       	                        	      ,COD_UNIDADE
         	                                              ,DTA_MOVIMENTO
                        	                              ,DES_REDE
                        	                              ,VLR_LCTO
                        	                              ,VLR_LCTO_SERV
                        	                              ,VLR_DIFERENCA
                        	                              ,DES_UNIDADE
                        	                              ,COD_AUTORIZACAO
                        	                              ,DES_ORIGEM
					                      ,NUM_EQUIPAMENTO)
       	                                         VALUES (pi_usuario
                        	                              ,r_notas_serv_mvto.cod_emp
                        	                              ,r_notas_serv_mvto.cod_unidade
                        	                              ,r_notas_serv_mvto.dta_recebimento
                        	                              ,SUBSTR(wDes_Rede,1,20)
                        	                              ,0
                        	                              ,r_notas_serv_mvto.vlr_operacao
                        	                              ,0
                        	                              ,wDes_Unidade
                        	                              ,wConta_Editado
                        	                              ,SUBSTR(wDes_Conta,1,20)
							      ,60);
          END;
          FETCH c_notas_serv_mvto INTO r_notas_serv_mvto;
          END LOOP;
          CLOSE c_notas_serv_mvto;


          /* Abre o cursor valor avista NL****/
          OPEN c_venda_mvto;
          FETCH c_venda_mvto INTO r_venda_mvto;
          WHILE c_venda_mvto%FOUND LOOP
          BEGIN

	     begin
                SELECT des_nome
                      ,cod_nivel2
                  INTO wDes_Unidade
                      ,wCod_Rede
                  FROM GE_UNIDADES
                 WHERE COD_UNIDADE = r_venda_mvto.cod_unidade;
                EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                          wDes_Unidade  := 'Unidade nao Cadastrada';
                          wCod_Rede    := 0;
             end;

	         wValor_lcto := 0;
	         wValor2 := 0;
	         if (r_venda_mvto.cod_oper = 300) or (r_venda_mvto.cod_oper = 4300) then
			 
	        	 wValor_lcto := nvl(r_venda_mvto.vlr_venda,0) - nvl(r_venda_mvto.vlr_entrada,0);
                   begin
				        select sum(nvl(a.vlr_lcto,0)) vlr_lcto
	        	    	  INTO vlr_cartao						
                          from nl.grz_tef_transacao_servidor a
                              ,nl.grz_tef_transacao_lojas l
                         where exists (select 1 from NL.NS_NOTAS NS
                                                    ,NL.NS_NOTAS_OPERACOES NSO
                                        where nso.NUM_SEQ = ns.NUM_SEQ
                                          AND nso.COD_MAQUINA = ns.COD_MAQUINA
                                          AND nso.COD_OPER IN (300,4300)
				                          AND NS.COD_EMP = 1
                                          AND NS.TIP_NOTA IN (2,3)
                                          AND NS.IND_STATUS = 1
				                          AND NS.COD_UNIDADE = L.COD_UNIDADE
				                          AND NS.NUM_NOTA    = L.NUM_CUPOM
                                          AND NS.DTA_EMISSAO = L.DTA_MOVIMENTO
				                          AND NS.NUM_EQUIPAMENTO  = L.NUM_EQUIPAMENTO)
                           and l.cod_emp        = a.cod_emp
                           and l.cod_unidade    = a.cod_unidade
                           and l.dta_movimento  = a.dta_movimento
						   and l.num_cupom       = r_venda_mvto.num_nota
                           and to_number(a.num_nsusitef) = to_number(l.num_nsusitef)
                           and l.ind_cancelado   = 0
                           and l.tip_origem      = 3
                           and a.dta_movimento   = l.dta_movimento
                           and a.cod_resposta    = '00'
                           and a.ind_cancelado   = 0
                           and a.des_operacao not like '%CANC%'
						   and a.cod_emp         = pi_rede
                           and a.cod_unidade     = r_venda_mvto.cod_unidade
	        	    	   and a.num_equipamento = r_venda_mvto.num_equipamento	        	    	   
	        	      	   and a.dta_movimento   = r_venda_mvto.dta_emissao						   
                           and not exists (select 1 from nl.grz_tef_transacao_servidor c
                                            where a.cod_emp       = c.cod_emp
                                              and a.cod_unidade   = c.cod_unidade
                                              and a.dta_movimento = c.dta_movimento
                                              and to_number(a.num_nsuhost) = to_number(c.nsu_host_cancel)
                                              and a.des_rede      = c.des_rede
                                              and c.cod_resposta  = '00');

	        	       wValor2 := nvl(vlr_cartao,0);
	        	  end;
	        	 wNum_equipamento := 10;
	        	 wValor_lcto := nvl(wValor_lcto,0) - nvl(wvalor2,0);
			 
	         elsif r_venda_mvto.cod_oper = 302 or r_venda_mvto.cod_oper = 305 or r_venda_mvto.cod_oper = 4302 or r_venda_mvto.cod_oper = 4305 then
	            wValor_lcto := r_venda_mvto.vlr_entrada;
	            wNum_equipamento := 20;
	         end if;

	        insert into GRZ_TEF_TRANSACAO_DIVERGENCIAS(DES_USUARIO
	        					  ,COD_EMP
	        					  ,COD_UNIDADE
	        					  ,DES_REDE
	        					  ,DES_UNIDADE
	        					  ,DTA_MOVIMENTO
	        					  ,NUM_EQUIPAMENTO
	        					  ,VLR_LCTO
	        					  ,VLR_LCTO_SERV
	        					  ,VLR_DIFERENCA)
	        				   VALUES(pi_usuario
	        					 ,wCod_rede
	        					 ,r_venda_mvto.cod_unidade
	        					 ,SUBSTR(wDes_Rede,1,20)
	        					 ,wdes_Unidade
	        					 ,r_venda_mvto.dta_emissao
	        					 ,wNum_equipamento
	        					 ,0
	        					 ,wValor_lcto
	        					 ,0);

	       insert into GRZ_TEF_TRANSACAO_DIVERGENCIAS(DES_USUARIO
	       						  ,COD_EMP
	        					  ,COD_UNIDADE
	        					  ,DES_REDE
	        					  ,DES_UNIDADE
	        					  ,DTA_MOVIMENTO
	        					  ,NUM_EQUIPAMENTO
	        					  ,VLR_LCTO
	        					  ,VLR_LCTO_SERV
	        					  ,VLR_DIFERENCA)
	        				   VALUES(pi_usuario
	        					 ,wCod_rede
	        					 ,r_venda_mvto.cod_unidade
	        					 ,SUBSTR(wDes_Rede,1,20)
	        					 ,wdes_Unidade
	        					 ,r_venda_mvto.dta_emissao
	        					 ,30
	        					 ,0
	        					 ,wvalor2
	        					 ,0);

	   END;
           FETCH c_venda_mvto INTO r_venda_mvto;
           END LOOP;
           CLOSE c_venda_mvto;

           /**RE CURSOR RECEBIMENTO, JUROS *****/

           OPEN c_receb_juro_mvto;
	   FETCH c_receb_juro_mvto INTO r_receb_juro_mvto;
           WHILE c_receb_juro_mvto%FOUND LOOP
	   BEGIN

             begin
              SELECT des_nome
                     ,cod_nivel2
                  INTO wDes_Unidade
                      ,wCod_Rede
                  FROM GE_UNIDADES
                  WHERE COD_UNIDADE = r_receb_juro_mvto.cod_unidade_pgto;
                EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                          wDes_Unidade  := 'Unidade nao Cadastrada';
                          wCod_Rede    := 0;
              end;

              wValor2  := nvl(r_receb_juro_mvto.vlr_juros,0);
              wValor   := nvl(r_receb_juro_mvto.vlr_parcela,0);

              insert into GRZ_TEF_TRANSACAO_DIVERGENCIAS(DES_USUARIO
              						  ,COD_EMP
              						  ,COD_UNIDADE
              						 ,DES_REDE
              						 ,DES_UNIDADE
              						 ,DTA_MOVIMENTO
              						 ,NUM_EQUIPAMENTO
              						 ,VLR_LCTO
              						 ,VLR_LCTO_SERV
              						 ,VLR_DIFERENCA)
              					   VALUES(pi_usuario
              					          ,Wcod_rede
              					          ,r_receb_juro_mvto.cod_unidade_pgto
              					          ,SUBSTR(wDes_Rede,1,20)
              					          ,wDes_Unidade
              					          ,r_receb_juro_mvto.DTA_PAGAMENTO
              					          ,40
              					          ,0
              					          ,wValor
              					          ,0);

              insert into GRZ_TEF_TRANSACAO_DIVERGENCIAS(DES_USUARIO
              						 ,COD_EMP
              						 ,COD_UNIDADE
              						 ,DES_REDE
              						 ,DES_UNIDADE
              						 ,DTA_MOVIMENTO
              						 ,NUM_EQUIPAMENTO
              						 ,VLR_LCTO
              						 ,VLR_LCTO_SERV
              						 ,VLR_DIFERENCA)
              					   VALUES(pi_usuario
              					          ,Wcod_rede
              					          ,r_receb_juro_mvto.cod_unidade_pgto
              					          ,SUBSTR(wDes_Rede,1,20)
              					          ,wDes_Unidade
              					          ,r_receb_juro_mvto.DTA_PAGAMENTO
              					          ,50
              					          ,0
              					          ,wValor2
              					          ,0);



           END;
           FETCH c_receb_juro_mvto INTO r_receb_juro_mvto;
           END LOOP;
           CLOSE c_receb_juro_mvto;


        COMMIT;
      EXCEPTION
        WHEN SAIDA THEN
             NULL;

       end;

END GRZ_REL_CONSIST_CAIXA_SP;





