CREATE OR REPLACE PROCEDURE GRZ_REL_OPER_FINANC_SP
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
          wDes_Produto                  VARCHAR2(15);
          wTip_Titulo_ini               NUMBER;
          wTip_Titulo_fim               NUMBER;
          wCod_Oper_ini                 NUMBER;
          wCod_Oper_fim                 NUMBER;
          wCod_Grupo                    NUMBER;

          SAIDA                         EXCEPTION;


       /* Cursor da tabela CR_TITULOS */
       CURSOR c_cr_titulos is
        select tit.cod_emp
              ,tit.cod_unidade
              ,tit.dta_emissao
              ,tit.tip_titulo
              ,sum(nvl(tit.vlr_cdc,0)) vlr_cr
         from cr_titulos tit
         where tit.cod_emp      = pi_emp
  	   and tit.cod_unidade >= pi_uni_ini
  	   and tit.cod_unidade <= pi_uni_fim
           and tit.dta_emissao >= pi_data_ini
           and tit.dta_emissao <= pi_data_fim
           and tit.tip_titulo in (wTip_Titulo_ini,wTip_Titulo_fim)
           and exists (select 1 from ge_grupos_unidades ge
                        where tit.cod_unidade = ge.cod_unidade
                          and ge.cod_grupo = pi_grupo
                          and ge.cod_emp = pi_emp)
         group by tit.cod_emp
                 ,tit.cod_unidade
                 ,tit.dta_emissao
                 ,tit.tip_titulo
         order by tit.cod_emp
                 ,tit.cod_unidade
                 ,tit.dta_emissao
                 ,tit.tip_titulo;

       r_cr_titulos c_cr_titulos%ROWTYPE;


       /* Cursor das Tabelas NS_NOTAS e NS_NOTAS_OPERACOES */
       CURSOR c_ns_notas is
	select nsno.cod_emp
              ,nsno.cod_unidade
              ,nsno.dta_emissao
              ,nsoper.cod_oper
              ,sum(nvl(nsoper.vlr_operacao,0)-nvl(nsoper.vlr_entrada,0)) + sum(nvl(nsoper.vlr_acrescimo_cob,0)) Valor_Nota
         from ns_notas nsno
             ,ns_notas_operacoes nsoper
         where nsno.num_seq     = nsoper.num_seq
           and nsno.cod_maquina = nsoper.cod_maquina
           and nsoper.cod_oper in (wCod_Oper_ini,wCod_Oper_fim)
           and nsno.cod_emp      = pi_emp
           and nsno.cod_unidade >= pi_uni_ini
           and nsno.cod_unidade <= pi_uni_fim
           and nsno.dta_emissao >= pi_data_ini
           and nsno.dta_emissao <= pi_data_fim
           and (nsno.tip_nota = 3
            or (nsno.tip_nota = 2
           and nsno.num_modelo = 65))
           and nsno.ind_status = 1
           and exists (select 1 from ge_grupos_unidades ge
                        where nsno.cod_unidade = ge.cod_unidade
                          and ge.cod_grupo = pi_grupo
                          and ge.cod_emp = pi_emp)
         group by nsno.cod_emp
                 ,nsno.cod_unidade
                 ,nsno.dta_emissao
                 ,nsoper.cod_oper
         order by nsno.cod_emp
                 ,nsno.cod_unidade
                 ,nsno.dta_emissao
                 ,nsoper.cod_oper;

       r_ns_notas c_ns_notas%ROWTYPE;


       /* Cursor da tabela ES_0124_CR_CDC_APRO */
       CURSOR c_cdc_apro is
	select esapro.cod_emp
              ,esapro.cod_unidade
              ,tit.dta_emissao
              ,esapro.tip_titulo
              ,sum(esapro.vlr_total) Valor_CDC_Apro
         from cr_titulos tit
             ,es_0124_cr_cdc_apro esapro
         where tit.cod_emp = esapro.cod_emp
           and tit.cod_unidade = esapro.cod_unidade
           and tit.cod_pessoa = esapro.cod_pessoa
           and tit.num_titulo = esapro.num_titulo
           and tit.cod_compl = esapro.cod_compl
           and tit.num_parcela = esapro.num_parcela
	   and esapro.tip_apro = 0
	   and tit.cod_emp = pi_emp
           and tit.cod_unidade >= pi_uni_ini
           and tit.cod_unidade <= pi_uni_fim
           and tit.dta_emissao >= pi_data_ini
	   and tit.dta_emissao <= pi_data_fim
	   and tit.tip_titulo in (wTip_Titulo_ini,wTip_Titulo_fim)
           and exists (select 1 from ge_grupos_unidades ge
                        where esapro.cod_unidade = ge.cod_unidade
                          and ge.cod_grupo = pi_grupo
                          and ge.cod_emp = pi_emp)
	 group by esapro.cod_emp
	         ,esapro.cod_unidade
	         ,tit.dta_emissao
	         ,esapro.tip_titulo
         order by esapro.cod_emp
                 ,esapro.cod_unidade
                 ,tit.dta_emissao
                 ,esapro.tip_titulo;

	r_cdc_apro c_cdc_apro%ROWTYPE;



          /**** Inicio da procedure principal ****/
          BEGIN
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


               delete from GRZ_REL_OPER_FINANC
               where upper(des_usuario) = upper(pi_usuario);
               commit;

               if (pi_cod_produto = 'FINANCIAMENTO') then
                  if pi_grupo = 970 then
                     wTip_Titulo_ini := 70;
                     wTip_Titulo_fim := 70;
                     wCod_Oper_ini := 4305;
                     wCod_Oper_fim := 4305;
                  else
                     wTip_Titulo_ini := 70;
                     wTip_Titulo_fim := 70;
                     wCod_Oper_ini := 305;
                     wCod_Oper_fim := 305;
                  end if;
               else
                  wTip_Titulo_ini := 72;
                  wTip_Titulo_fim := 73;
                  wCod_Oper_ini := 3000;
                  wCod_Oper_fim := 3050;
               end if;

               /**** Abre o cursor dos Titulos ****/
               /* Ele faz a soma dos titulos definidos por Tipo de Titulo por Loja e grava na tabela GRZ_REL_OPER_FINANC */
	       OPEN c_cr_titulos;
	       FETCH c_cr_titulos INTO r_cr_titulos;
	       WHILE c_cr_titulos%FOUND LOOP
	       BEGIN

                         /* busca nome da unidade */
                         begin
                              SELECT des_nome
                                    ,cod_nivel2
                                INTO wDes_Unidade
                                    ,wCod_Grupo
                                FROM GE_UNIDADES
                               WHERE COD_UNIDADE = r_cr_titulos.cod_unidade;
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
                         elsif wCod_Grupo = 850 then
                             wDes_Nome_Rede := 'Rede Cia';
                         else
                             wDes_Nome_Rede := 'Rede nao Cadastrada';
                         end if;


                         begin
           	              insert into GRZ_REL_OPER_FINANC (DES_USUARIO
           	              				      ,DES_REDE
           	              				      ,COD_UNIDADE
           	              				      ,DES_UNIDADE
           	              				      ,DTA_MOVIMENTO
           	              				      ,VLR_NS
           	              				      ,VLR_CR
           	              				      ,VLR_CDC_APRO)
           	              			        VALUES(pi_usuario
           	              			              ,wDes_Nome_Rede
           	              			              ,r_cr_titulos.cod_unidade
           	              			              ,wDes_Unidade
           	              			              ,r_cr_titulos.dta_emissao
           	              			              ,0
           	              			              ,r_cr_titulos.vlr_cr
           	              			              ,0
           	              			              );
                        end;
               END;
	       FETCH c_cr_titulos INTO r_cr_titulos;
               END LOOP;
               CLOSE c_cr_titulos;


               /**** Abre o cursor das Notas ****/
               /* Ele faz a soma das Notas definidas por Tipo de Operac?o por Loja e grava na tabela GRZ_REL_OPER_FINANC */
	       OPEN c_ns_notas;
	       FETCH c_ns_notas INTO r_ns_notas;
	       WHILE c_ns_notas%FOUND LOOP
	       BEGIN

                         /* busca nome da unidade */
                         begin
                              SELECT des_nome
                                    ,cod_nivel2
                                INTO wDes_Unidade
                                    ,wCod_Grupo
                                FROM GE_UNIDADES
                               WHERE COD_UNIDADE = r_ns_notas.cod_unidade;
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
                         elsif wCod_Grupo = 870 then
                             wDes_Nome_Rede := 'Rede Cia';
                         else
                             wDes_Nome_Rede := 'Rede nao Cadastrada';
                         end if;


                         begin
           	              insert into GRZ_REL_OPER_FINANC (DES_USUARIO
           	              				      ,DES_REDE
           	              				      ,COD_UNIDADE
           	              				      ,DES_UNIDADE
           	              				      ,DTA_MOVIMENTO
           	              				      ,VLR_NS
           	              				      ,VLR_CR
           	              				      ,VLR_CDC_APRO)
           	              			        VALUES(pi_usuario
           	              			              ,wDes_Nome_Rede
           	              			              ,r_ns_notas.cod_unidade
           	              			              ,wDes_Unidade
           	              			              ,r_ns_notas.dta_emissao
           	              			              ,r_ns_notas.Valor_Nota
           	              			              ,0
           	              			              ,0
           	              			              );
                        end;
               END;
	       FETCH c_ns_notas INTO r_ns_notas;
               END LOOP;
               CLOSE c_ns_notas;


               /**** Abre o cursor da ES_0124_CR_CDC_APRO ****/
               /* Ele faz a soma do Valor Total da Apro definido por Tipo de Titulo por Loja e grava na tabela GRZ_REL_OPER_FINANC */
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
                         elsif wCod_Grupo = 850 then
                             wDes_Nome_Rede := 'Rede Cia';
                         else
                             wDes_Nome_Rede := 'Rede nao Cadastrada';
                         end if;


                         begin
           	              insert into GRZ_REL_OPER_FINANC (DES_USUARIO
           	              				      ,DES_REDE
           	              				      ,COD_UNIDADE
           	              				      ,DES_UNIDADE
           	              				      ,DTA_MOVIMENTO
           	              				      ,VLR_NS
           	              				      ,VLR_CR
           	              				      ,VLR_CDC_APRO)
           	              			        VALUES(pi_usuario
           	              			              ,wDes_Nome_Rede
           	              			              ,r_cdc_apro.cod_unidade
           	              			              ,wDes_Unidade
           	              			              ,r_cdc_apro.dta_emissao
           	              			              ,0
           	              			              ,0
           	              			              ,r_cdc_apro.Valor_CDC_Apro
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
         end;

   END GRZ_REL_OPER_FINANC_SP;




