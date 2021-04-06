/*------------------------------------------------------------------------
  Procedure.: grz_rel_pgto_appxloja_sp
  Empresa...: Grazziotin S/A
  Finalidade: "Acumular" valores para relatorio demostrativo de "VENDAS"

  Autor   Data     Operacao  Descricao
  Antonio JAN/2021 Criacao   Estruturacao, criacao e testes da PROCEDURE
  Jaisson JAN/2021 Criacao   Criacao dos SQL's
  Antonio MAR/2021 Alteracao Acumular o campo TOT_CLI_CADASTRADOS, desde
                             marco de 2020
  Jaisson MAR/2021 Alteracao Ajuste na quantidade de pagamentos na loja e
                             alteracao na verificacao dos titulos de 
                             pagamentos

  Parametros
  pDataInicial - Data inicial da selecao de dados
  pDataFinal   - Data final da selecao de dados, compoem o periodo da
                 selecao de dados
------------------------------------------------------------------------*/
create or replace procedure grz_rel_pgto_appxloja_sp (pdatainicial in varchar2,
                                                      pdatafinal in varchar2)
is
begin
     declare
            v_data_inicial            varchar2(10);
            v_data_final              varchar2(10);
            v_tot_cli_cadastrados     number(8);
            v_qtd_tot_cli_app         number(8);
            v_qtd_new_cli_app         number(8);
            v_qtd_cli_grazziotin      number(8);
            v_qtd_new_cli_app_aprov   number(8);
            v_qtd_cli_novos_pendentes number(8);
            v_qtd_parcelas_areceber   number(8);
            v_vlr_parcelas_areceber   number(18,2);
            v_tot_cli_pgto_app        number(8);
            v_qtd_parcelas_pgto_cia   number(8);
            v_vlr_parcelas_pgto_cia   number(18,2);
            v_qtd_parcelas_pgto_decre number(8);
            v_vlr_parcelas_pgto_decre number(18,2);
            v_qtd_parcelas_pgto_app   number(8);
            v_qtd_parcelas_pgto_0800  number(8);
            v_vlr_parcelas_pgto_app   number(18,2);
            v_vlr_parcelas_pgto_0800  number(18,2);
            v_qtd_pgto_boleto_app     number(8);
            v_vlr_pgto_boleto_app     number(18,2);
            v_qtd_pgto_credito_app    number(8);
            v_vlr_pgto_credito_app    number(18,2);
            v_qtd_pgto_debito_app     number(8);
            v_vlr_pgto_debito_app     number(18,2);
            v_qtd_pgto_boleto_decre   number(8);
            v_vlr_pgto_boleto_decre   number(18,2);
            v_qtd_pgto_debito_loja    number(8);
            v_vlr_pgto_debito_loja    number(18,2);
            v_qtd_pgto_credito_loja   number(8);
            v_vlr_pgto_credito_loja   number(18,2);
            v_qtd_pgto_loja           number(8);
            v_vlr_pgto_loja           number(18,2);
            v_tot_cli_pgto_cia        number(18,2);
            v_valor_seguro_areceber   number(18,2);

     begin
          v_data_inicial := pdatainicial;
          v_data_final := pdatafinal;
          /* Seleciona a quantidade de clientes cadastrados do APP */
          begin
               select count(1) as cli_cadastro
               into v_qtd_tot_cli_app
               from appgrz.grz_api_ps_pessoas, appgrz.grz_api_user
               where to_number(appgrz.grz_api_user."cpf") = appgrz.grz_api_ps_pessoas.num_cpf and
                     (trunc(appgrz.grz_api_user."created_at") between
                            to_date(v_data_inicial,'dd/mm/yyyy') and
                            to_date(v_data_final,'dd/mm/yyyy'));
               exception
                        when no_data_found then
                             v_qtd_tot_cli_app := 0;
          end;
          /* Seleciona a quantidade de NOVOS clientes cadastrados do APP */
          begin
               select count(1) as cli_novos 
               into v_qtd_new_cli_app
               from appgrz.grz_api_ps_pessoas, appgrz.grz_api_user
               where appgrz.grz_api_user."cpf" = appgrz.grz_api_ps_pessoas.num_cpf and
                     nvl(appgrz.grz_api_ps_pessoas.ind_cliente,0) = 0 and
                     (trunc(appgrz.grz_api_user."created_at") between
                      to_date(v_data_inicial,'dd/mm/yyyy') and
                      to_date(v_data_final,'dd/mm/yyyy'));
               exception
                        when no_data_found then
                             v_qtd_new_cli_app := 0;
          end;
          /* Ja sao clientes */
          begin
               select count(1) as cli_antigos
               into v_qtd_cli_grazziotin
               from appgrz.grz_api_ps_pessoas, appgrz.grz_api_user
               where appgrz.grz_api_user."cpf" = appgrz.grz_api_ps_pessoas.num_cpf and
                     nvl(appgrz.grz_api_ps_pessoas.ind_cliente,0) = 1 and
                     (trunc(appgrz.grz_api_user."created_at") between 
                           to_date(v_data_inicial,'dd/mm/yyyy') and
                           to_date(v_data_final,'dd/mm/yyyy'));
              exception
                       when no_data_found then
                            v_qtd_cli_grazziotin := 0;
          end;
          /* Numero de cadastros novos aprovados */
          begin
               select count(1) as cli_aprovados
               into v_qtd_new_cli_app_aprov
               from appgrz.grz_api_ps_pessoas,appgrz.grz_api_user
               where appgrz.grz_api_user."cpf" = appgrz.grz_api_ps_pessoas.num_cpf and 
                    appgrz.grz_api_user."credit_status" = 'approve' and 
                    nvl(appgrz.grz_api_ps_pessoas.ind_cliente,0) = 0 and 
                    (trunc(appgrz.grz_api_user."created_at") between 
                          to_date(v_data_inicial,'dd/mm/yyyy') and
                          to_date(v_data_final,'dd/mm/yyyy'));
              exception
                       when no_data_found then
                            v_qtd_new_cli_app_aprov := 0;
          end;
          /* Clientes pendentes de aprovacao */
          begin
               select count(1) as cli_pend_aprov 
               into v_qtd_cli_novos_pendentes
               from appgrz.grz_api_ps_pessoas, appgrz.grz_api_user
               where appgrz.grz_api_user."cpf" = appgrz.grz_api_ps_pessoas.num_cpf and 
                     appgrz.grz_api_user."credit_status" = 'analyze' and 
                     nvl(appgrz.grz_api_ps_pessoas.ind_cliente,0) = 0 and 
                     (trunc(appgrz.grz_api_user."created_at") between to_date(v_data_inicial,'dd/mm/yyyy') and 
                                                                      to_date(v_data_final,'dd/mm/yyyy')); 
              exception
                       when no_data_found then
                            v_qtd_cli_novos_pendentes := 0;
          end;
          /* Quantidade e valor de parcelas A RECEBER */
          begin
               select count(1) as qtd_pagamentos_a_receber,
                      sum(nvl(cr_titulos.vlr_cdc,0)) as vlr_tot_a_receber
               into v_qtd_parcelas_areceber, v_vlr_parcelas_areceber
               from cr_titulos, ge_grupos_unidades
               where cr_titulos.tip_titulo in (1,50,70,72,73) and
                     cr_titulos.dta_vencimento between to_date(v_data_inicial,'dd/mm/yyyy') and
                                                       to_date(v_data_final,'dd/mm/yyyy') and
                     cr_titulos.ind_dc = 1 and
                     cr_titulos.cod_unidade = ge_grupos_unidades.cod_unidade and
                     ge_grupos_unidades.cod_grupo in (71010,71030,71040,71050,71070) and
                     ge_grupos_unidades.cod_emp = 1;
               exception
                        when no_data_found then
                        begin
                             v_qtd_parcelas_areceber := 0;
                             v_vlr_parcelas_areceber := 0;
                        end;
          end;
          /* Seleciona valor do seguro, posteriormente sera somado ao valor das parcelas a receber */
          begin
               select sum(nvl(cr_titulos.vlr_cdc,0)) as vlr_tot_a_receber_seguro
               into v_valor_seguro_areceber
               from cr_titulos, ge_grupos_unidades
               where cr_titulos.tip_titulo in (55,57) and
                     cr_titulos.dta_vencimento between to_date(v_data_inicial,'dd/mm/yyyy') and 
                                                       to_date(v_data_final, 'dd/mm/yyyy') and  
                     cr_titulos.ind_dc = 1 and                     
                     cr_titulos.cod_unidade = ge_grupos_unidades.cod_unidade and
                     ge_grupos_unidades.cod_grupo in (71010,71030,71040,71050,71070) and
                     ge_grupos_unidades.cod_emp = 1;  
               exception
                        when no_data_found then
                        begin
                             v_valor_seguro_areceber := 0;
                        end;
               /* Soma o valor do segura a receber no valor das parcelas a receber */
               v_vlr_parcelas_areceber := v_vlr_parcelas_areceber + v_valor_seguro_areceber;
          end;
          /* Clientes que efetuaram o pagamento pelo APP */
          begin
               select count(distinct appgrz.grz_api_ps_pessoas.num_cpf) as pgto_app 
               into v_tot_cli_pgto_app
               from appgrz.grz_api_ps_pessoas, ps_fisicas
               where appgrz.grz_api_ps_pessoas.num_cpf = ps_fisicas.num_cpf and 
                     exists (select 1
                             from cr_historicos
                             where ps_fisicas.cod_pessoa = cr_historicos.cod_pessoa and 
                                  cr_historicos.cod_unidade_pgto = 702 and 
                                  (cr_historicos.dta_pagamento between 
                                                 to_date(v_data_inicial,'dd/mm/yyyy') and
                                                 to_date(v_data_final,'dd/mm/yyyy')));
              exception
                       when no_data_found then
                            v_tot_cli_pgto_app := 0;
          end;
          /* Total de pagamento e quantidade de parcelas CIA */
          begin
               select sum(decode(cr_titulos.tip_titulo,1,1,70,1,50,1,72,1,73,1,0)) as qtd_pagamentos_cia,
                      sum(nvl(cr_historicos.vlr_lancamento,0) +
                      nvl(cr_historicos.vlr_juro_cobr,0) +
                      nvl(cr_historicos.vlr_desp_cobr,0)) vlr_tot_cia
               into v_qtd_parcelas_pgto_cia,v_vlr_parcelas_pgto_cia
               from cr_titulos,
                    cr_historicos, ge_grupos_unidades       
               where cr_historicos.cod_pessoa = cr_titulos.cod_pessoa and
                     cr_historicos.cod_emp = cr_titulos.cod_emp and
                     cr_historicos.cod_unidade = cr_titulos.cod_unidade and
                     cr_historicos.num_titulo = cr_titulos.num_titulo and
                     cr_historicos.cod_compl = cr_titulos.cod_compl and
                     cr_historicos.num_parcela = cr_titulos.num_parcela and
                     cr_titulos.ind_pago = 1 and
                     cr_historicos.ind_dc = 2 and
                     cr_historicos.cod_lancamento in (100,101,20,65,103) and
                     cr_titulos.cod_unidade = ge_grupos_unidades.cod_unidade and
                     ge_grupos_unidades.cod_grupo in (71010,71030,71040,71050,71070) and
                     ge_grupos_unidades.cod_emp = 1 and
                     (cr_historicos.dta_pagamento between 
                                    to_date(v_data_inicial,'dd/mm/yyyy') and
                                    to_date(v_data_final,'dd/mm/yyyy'));
              exception
                       when no_data_found then
                       begin
                            v_qtd_parcelas_pgto_cia := 0;
                            v_vlr_parcelas_pgto_cia := 0;
                       end;
          end;
          /* Pagamento parcelas e valor DECRE */
          begin
               select count(1) as qtd_parcelas,
                      sum(nvl(appgrz.grz_api_cr_historicos.vlr_pago,0) + 
                          nvl(appgrz.grz_api_cr_historicos.vlr_multa,0) + 
                          nvl(appgrz.grz_api_cr_historicos.vlr_juros,0)) as valor_pago 
               into v_qtd_parcelas_pgto_decre,v_vlr_parcelas_pgto_decre
               from appgrz.grz_api_orders, appgrz.grz_api_cr_historicos
               where appgrz.grz_api_cr_historicos.order_id = appgrz.grz_api_orders."id" and 
                     appgrz.grz_api_orders."user_id" is not null and 
                     appgrz.grz_api_orders."status" = 2 and 
                     appgrz.grz_api_cr_historicos.canal in (1,2) and
                     (trunc(appgrz.grz_api_orders."captured_at") between 
                            to_date(v_data_inicial,'dd/mm/yyyy') and 
                            to_date(v_data_final,'dd/mm/yyyy'));
               exception
                        when no_data_found then
                        begin
                             v_qtd_parcelas_pgto_decre := 0;
                             v_vlr_parcelas_pgto_decre := 0;
                        end;
          end;
          /* Quantidade e valor pagamento parcelas pelo APP e 0800 */
          begin
               select sum(decode(cr_historicos.cod_unidade_pgto,702,
                          decode(cr_titulos.tip_titulo,1,1,70,1,50,1,72,1,73,1,0),0)) as qtd_app,               
                      sum(case 
                              when (cr_historicos.cod_unidade_pgto = 701) or 
                                   (cr_historicos.cod_lancamento = 103) then 
                                   decode(cr_titulos.tip_titulo,1,1,70,1,50,1,72,1,73,1,0)
                              else 0
                          end) as qtd_0800,
                      sum(decode(cr_historicos.cod_unidade_pgto,702,(nvl(cr_historicos.vlr_lancamento,0) +
                          nvl(cr_historicos.vlr_juro_cobr,0) +
                          nvl(cr_historicos.vlr_desp_cobr,0)),0)) vlr_app,
                      sum(case 
                              when (cr_historicos.cod_unidade_pgto = 701) or 
                                   (cr_historicos.cod_lancamento = 103) then    
                                   (nvl(cr_historicos.vlr_lancamento,0) +
                                    nvl(cr_historicos.vlr_juro_cobr,0) +
                                    nvl(cr_historicos.vlr_desp_cobr,0)) 
                              else 0 
                          end) as vlr_0800
               into v_qtd_parcelas_pgto_app,v_qtd_parcelas_pgto_0800,
                    v_vlr_parcelas_pgto_app,v_vlr_parcelas_pgto_0800
               from cr_titulos,cr_historicos
               where cr_historicos.cod_pessoa = cr_titulos.cod_pessoa and
                     cr_historicos.cod_emp = cr_titulos.cod_emp and
                     cr_historicos.cod_unidade = cr_titulos.cod_unidade and
                     cr_historicos.num_titulo = cr_titulos.num_titulo and
                     cr_historicos.cod_compl = cr_titulos.cod_compl and
                     cr_historicos.num_parcela = cr_titulos.num_parcela and
                     cr_historicos.cod_lancamento in (100,101,20,65,75,103) and 
                     (cr_historicos.dta_pagamento between 
                                    to_date(v_data_inicial,'dd/mm/yyyy') and
                                    to_date(v_data_final,'dd/mm/yyyy'));
               exception
                        when no_data_found then
                        begin
                             v_qtd_parcelas_pgto_app  := 0;
                             v_qtd_parcelas_pgto_0800 := 0;
                             v_vlr_parcelas_pgto_app  := 0;
                             v_vlr_parcelas_pgto_0800 := 0;
                        end;
          end;
          /* Quantidade e valor de boleto APP */
          begin
               select sum("amount") vlr_boleto_app,
                      count(1) qtd_boleto_app
               into v_vlr_pgto_boleto_app,v_qtd_pgto_boleto_app
               from appgrz.grz_api_orders
               where "type" in ('Boleto') and
                     "status" = 2 and
                     "user_id" is null and
                     trunc("captured_at") between 
                           to_date(v_data_inicial,'dd/mm/yyyy') and
                           to_date(v_data_final,'dd/mm/yyyy');
               exception
                        when no_data_found then
                        begin
                             v_vlr_pgto_boleto_app := 0;
                             v_qtd_pgto_boleto_app := 0;
                        end;
          end;
          /* Quantidade e valor de credito APP */
          begin
               select sum("amount") vlr_credito_app,
                      count(1) qtd_credito_app
               into v_vlr_pgto_credito_app,v_qtd_pgto_credito_app
               from appgrz.grz_api_orders
               where "type" in ('CreditCard') and
                     "status" = 2 and
                     "user_id" is null and
                     trunc("captured_at") between 
                           to_date(v_data_inicial,'dd/mm/yyyy') and
                           to_date(v_data_final,'dd/mm/yyyy');
               exception
                        when no_data_found then
                        begin
                             v_vlr_pgto_credito_app := 0;
                             v_qtd_pgto_credito_app := 0;
                        end;
          end;
          /* Quantidade e valor de debito APP */
          begin
               select sum("amount") vlr_debito_app,
                      count(1) qtd_debito_app
               into v_vlr_pgto_debito_app,v_qtd_pgto_debito_app
               from appgrz.grz_api_orders
               where "type" in ('DebitCard') and
                     "status" = 2 and
                     "user_id" is null and
                     trunc("captured_at") between 
                           to_date(v_data_inicial,'dd/mm/yyyy') and
                           to_date(v_data_final,'dd/mm/yyyy');
               exception
                        when no_data_found then
                        begin
                             v_vlr_pgto_debito_app := 0;
                             v_qtd_pgto_debito_app := 0;
                        end;
          end;
          /* Valor e quantidade boleto DECRE */
          begin
               select nvl(sum("amount"),0) vlr_boleto_decre,
                      count(1) qtd_boleto_decre
               into v_vlr_pgto_boleto_decre,v_qtd_pgto_boleto_decre
               from appgrz.grz_api_orders
               where "type" in ('Boleto') and 
               "status" = 2 and 
               "user_id" is not null and 
               trunc("captured_at") between 
                     to_date(v_data_inicial,'dd/mm/yyyy') and
                     to_date(v_data_final,'dd/mm/yyyy');
               exception
                        when no_data_found then
                        begin
                             v_vlr_pgto_boleto_decre := 0;
                             v_qtd_pgto_boleto_decre := 0;
                        end;
          end;
          /* Valor e quantidade de debito e credito na LOJA */
          begin
               v_qtd_pgto_debito_loja  := 0;
               v_vlr_pgto_debito_loja  := 0;
               v_qtd_pgto_credito_loja := 0;
               v_vlr_pgto_credito_loja := 0;
               declare
                      cursor cur_loja
                      is
                        select grz_tef_transacao_lojas.ind_deb_cred, 
                               count(1) qtd_loja, 
                               sum(nvl(grz_tef_transacao_servidor.vlr_lcto,0)) vlr_loja
                        from grz_tef_transacao_servidor, grz_tef_transacao_lojas
                        where grz_tef_transacao_lojas.cod_emp =
                              grz_tef_transacao_servidor.cod_emp and
                              grz_tef_transacao_lojas.cod_unidade =
                              grz_tef_transacao_servidor.cod_unidade and
                              grz_tef_transacao_lojas.dta_movimento =
                              grz_tef_transacao_servidor.dta_movimento and
                              to_number(grz_tef_transacao_servidor.num_nsusitef) =
                              to_number(grz_tef_transacao_lojas.num_nsusitef) and
                              grz_tef_transacao_lojas.ind_cancelado = 0 and
                              grz_tef_transacao_lojas.tip_origem    = 4 and
                              grz_tef_transacao_servidor.dta_movimento =
                              grz_tef_transacao_lojas.dta_movimento and
                              grz_tef_transacao_servidor.cod_resposta  = '00' and
                              grz_tef_transacao_servidor.ind_cancelado = 0 and
                              grz_tef_transacao_servidor.des_operacao not like '%CANC%' and
                              grz_tef_transacao_servidor.dta_movimento between 
                                      to_date(v_data_inicial,'dd/mm/yyyy') and
                                      to_date(v_data_final,'dd/mm/yyyy') and 
                              not exists (select 1 
                                          from grz_tef_transacao_servidor c
                                          where grz_tef_transacao_servidor.cod_emp = c.cod_emp and
                                                grz_tef_transacao_servidor.cod_unidade = c.cod_unidade and
                                                grz_tef_transacao_servidor.dta_movimento =
                                                     c. dta_movimento and
                                                to_number(grz_tef_transacao_servidor.num_nsuhost) =
                                                to_number(c.nsu_host_cancel) and
                                                grz_tef_transacao_servidor.des_rede = c.des_rede and
                                                c.cod_resposta  = '00') and
                              exists (select 1
                                      from grz_lojas_recebimentos
                                      where grz_tef_transacao_lojas.cod_unidade =
                                            grz_lojas_recebimentos.cod_unidade and
                                            grz_tef_transacao_lojas.num_equipamento =
                                            grz_lojas_recebimentos.num_equipamento and
                                            grz_tef_transacao_lojas.dta_movimento =
                                            grz_lojas_recebimentos.dta_mvto and
                                            grz_tef_transacao_lojas.num_nsusitef =
                                            grz_lojas_recebimentos.num_nsusitef)
                        group by grz_tef_transacao_lojas.ind_deb_cred;
                      begin
                           for reg_loja in cur_loja loop
                               if (reg_loja.ind_deb_cred = 1) then -- = 1, débito
                                  v_qtd_pgto_debito_loja := reg_loja.qtd_loja;
                                  v_vlr_pgto_debito_loja := reg_loja.vlr_loja;
                               else -- = 2, crédito
                                  v_qtd_pgto_credito_loja := reg_loja.qtd_loja;
                                  v_vlr_pgto_credito_loja := reg_loja.vlr_loja;
                               end if;
                           end loop;
                      end;
          end;
          /* Quantidade e valor pagamento na loja */
          begin
               select sum(decode(cr_titulos.tip_titulo,1,1,70,1,50,1,72,1,73,1,0)) as qtd_pagamentos_lojas,
                      sum(nvl(cr_historicos.vlr_lancamento,0) +
                      nvl(cr_historicos.vlr_juro_cobr,0) +
                      nvl(cr_historicos.vlr_desp_cobr,0) - nvl(cr_historicos.vlr_desconto,0)) as vlr_tot_lojas
               into v_qtd_pgto_loja, v_vlr_pgto_loja
               from cr_titulos, cr_historicos, ge_grupos_unidades
               where cr_historicos.cod_pessoa = cr_titulos.cod_pessoa and
                     cr_historicos.cod_emp = cr_titulos.cod_emp and
                     cr_historicos.cod_unidade = cr_titulos.cod_unidade and
                     cr_historicos.num_titulo = cr_titulos.num_titulo and
                     cr_historicos.cod_compl = cr_titulos.cod_compl and
                     cr_historicos.num_parcela = cr_titulos.num_parcela and
                     cr_historicos.ind_dc = 2 and
                     cr_historicos.cod_lancamento in (100,20,75) and
                     cr_titulos.cod_unidade = ge_grupos_unidades.cod_unidade and
                     ge_grupos_unidades.cod_grupo in (71010,71030,71040,71050,71070) and
                     cr_historicos.cod_unidade_pgto not in (701,702,703) and
                     ge_grupos_unidades.cod_emp = 1 and
                     cr_historicos.dta_pagamento between
                                                 to_date(v_data_inicial,'dd/mm/yyyy') and
                                                 to_date(v_data_final,'dd/mm/yyyy');
               exception
                        when no_data_found then
                        begin
                             v_qtd_pgto_loja := 0;
                             v_vlr_pgto_loja := 0;
                        end;
          end;
          /* Total de valores pagos na CIA */
          begin
               select count(distinct ps_fisicas.num_cpf) qtd_clientes_pagaram_cia
               into v_tot_cli_pgto_cia
               from ps_fisicas, cr_titulos, cr_historicos, ge_grupos_unidades
               where cr_titulos.cod_pessoa = ps_fisicas.cod_pessoa and
                     cr_historicos.cod_pessoa = cr_titulos.cod_pessoa and
                     cr_historicos.cod_emp = cr_titulos.cod_emp and
                     cr_historicos.cod_unidade = cr_titulos.cod_unidade and
                     cr_historicos.num_titulo = cr_titulos.num_titulo and
                     cr_historicos.cod_compl = cr_titulos.cod_compl and
                     cr_historicos.num_parcela = cr_titulos.num_parcela and
                     cr_titulos.ind_pago = 1 and
                     cr_historicos.ind_dc = 2 and
                     cr_historicos.cod_lancamento in (100,101,20,65,103,75) and
                     cr_titulos.cod_unidade = ge_grupos_unidades.cod_unidade and
                     ge_grupos_unidades.cod_grupo in (71010,71030,71040,71050,71070) and
                     ge_grupos_unidades.cod_emp = 1 and
                     cr_historicos.dta_pagamento between 
                                                 to_date(v_data_inicial,'dd/mm/yyyy') and
                                                 to_date(v_data_final,'dd/mm/yyyy');
               exception
                        when no_data_found then
                        begin
                             v_tot_cli_pgto_cia := 0;
                        end;
          end;

          /* Grava dados do relatorio de vendas */
          begin
               insert into grzw_rel_pgtos_appxloja (dta_mes,
                                                    qtd_tot_cli_app,
                                                    qtd_new_cli_app,
                                                    qtd_cli_grazziotin,
                                                    qtd_new_cli_app_aprov,
                                                    qtd_cli_novos_pendentes,
                                                    tot_cli_pgto_app,
                                                    qtd_parcelas_pgto_cia,
                                                    vlr_parcelas_pgto_cia,
                                                    qtd_parcelas_pgto_decre,
                                                    vlr_parcelas_pgto_decre,
                                                    qtd_parcelas_pgto_app,
                                                    qtd_parcelas_pgto_0800,
                                                    vlr_parcelas_pgto_app,
                                                    vlr_parcelas_pgto_0800,
                                                    vlr_pgto_boleto_app,
                                                    qtd_pgto_boleto_app,
                                                    vlr_pgto_credito_app,
                                                    qtd_pgto_credito_app,
                                                    vlr_pgto_debito_app,
                                                    qtd_pgto_debito_app,
                                                    vlr_pgto_boleto_decre,
                                                    qtd_pgto_boleto_decre,
                                                    qtd_pgto_debito_loja,
                                                    vlr_pgto_debito_loja,
                                                    qtd_pgto_credito_loja,
                                                    vlr_pgto_credito_loja,
                                                    qtd_pgto_loja,
                                                    vlr_pgto_loja,
                                                    tot_cli_pgto_cia,
                                                    qtd_parcelas_areceber,
                                                    vlr_parcelas_areceber)
               values (to_date(v_data_inicial,'dd/mm/yyyy'),
                       v_qtd_tot_cli_app,
                       v_qtd_new_cli_app,
                       v_qtd_cli_grazziotin,
                       v_qtd_new_cli_app_aprov,
                       v_qtd_cli_novos_pendentes,
                       v_tot_cli_pgto_app,
                       v_qtd_parcelas_pgto_cia,
                       v_vlr_parcelas_pgto_cia,
                       v_qtd_parcelas_pgto_decre,
                       v_vlr_parcelas_pgto_decre,
                       v_qtd_parcelas_pgto_app,
                       v_qtd_parcelas_pgto_0800,
                       v_vlr_parcelas_pgto_app,
                       v_vlr_parcelas_pgto_0800,
                       v_vlr_pgto_boleto_app,
                       v_qtd_pgto_boleto_app,
                       v_vlr_pgto_credito_app,
                       v_qtd_pgto_credito_app,
                       v_vlr_pgto_debito_app,
                       v_qtd_pgto_debito_app,
                       v_vlr_pgto_boleto_decre,
                       v_qtd_pgto_boleto_decre,
                       v_qtd_pgto_debito_loja,
                       v_vlr_pgto_debito_loja,
                       v_qtd_pgto_credito_loja,
                       v_vlr_pgto_credito_loja,
                       v_qtd_pgto_loja,
                       v_vlr_pgto_loja,
                       v_tot_cli_pgto_cia,
                       v_qtd_parcelas_areceber,
                       v_vlr_parcelas_areceber);
          exception
                   when dup_val_on_index then
                        update grzw_rel_pgtos_appxloja
                        set qtd_tot_cli_app = v_qtd_tot_cli_app,
                            qtd_new_cli_app = v_qtd_new_cli_app,
                            qtd_cli_grazziotin = v_qtd_cli_grazziotin,
                            qtd_new_cli_app_aprov = v_qtd_new_cli_app_aprov,
                            qtd_cli_novos_pendentes = v_qtd_cli_novos_pendentes,
                            tot_cli_pgto_app = v_tot_cli_pgto_app,
                            qtd_parcelas_pgto_cia = v_qtd_parcelas_pgto_cia,
                            vlr_parcelas_pgto_cia = v_vlr_parcelas_pgto_cia,
                            qtd_parcelas_pgto_decre = v_qtd_parcelas_pgto_decre,
                            vlr_parcelas_pgto_decre = v_vlr_parcelas_pgto_decre,
                            qtd_parcelas_pgto_app = v_qtd_parcelas_pgto_app,
                            qtd_parcelas_pgto_0800 = v_qtd_parcelas_pgto_0800,
                            vlr_parcelas_pgto_app = v_vlr_parcelas_pgto_app,
                            vlr_parcelas_pgto_0800 = v_vlr_parcelas_pgto_0800,
                            vlr_pgto_boleto_app = v_vlr_pgto_boleto_app,
                            qtd_pgto_boleto_app = v_qtd_pgto_boleto_app,
                            vlr_pgto_credito_app = v_vlr_pgto_credito_app,
                            qtd_pgto_credito_app = v_qtd_pgto_credito_app,
                            vlr_pgto_debito_app = v_vlr_pgto_debito_app,
                            qtd_pgto_debito_app = v_qtd_pgto_debito_app,
                            vlr_pgto_boleto_decre = v_vlr_pgto_boleto_decre,
                            qtd_pgto_boleto_decre = v_qtd_pgto_boleto_decre,
                            qtd_pgto_debito_loja = v_qtd_pgto_debito_loja,
                            vlr_pgto_debito_loja = v_vlr_pgto_debito_loja,
                            qtd_pgto_credito_loja = v_qtd_pgto_credito_loja,
                            vlr_pgto_credito_loja = v_vlr_pgto_credito_loja,
                            qtd_pgto_loja = v_qtd_pgto_loja,
                            vlr_pgto_loja = v_vlr_pgto_loja,
                            tot_cli_pgto_cia = v_tot_cli_pgto_cia,
                            qtd_parcelas_areceber = v_qtd_parcelas_areceber,
                            vlr_parcelas_areceber = v_vlr_parcelas_areceber
                        where (to_date(dta_mes,'dd/mm/yyyy') = to_date(v_data_inicial,'dd/mm/yyyy'));
          end;

          commit;

          /* Acumula / atualiza os totais de clientes cadastrados */
          begin
               v_tot_cli_cadastrados := 0;
               /* Acumula clientes cadastrados */
               select sum(qtd_tot_cli_app)
               into v_tot_cli_cadastrados
               from grzw_rel_pgtos_appxloja
               where (dta_mes between to_date('01/01/2020','dd/mm/yyyy') and
                                      to_date(v_data_inicial,'dd/mm/yyyy'));
               exception
                        when no_data_found then
                        begin
                             v_tot_cli_cadastrados := 0;
                        end;
          end;

          begin
               /* Atualiza clientes cadastrados */
               update grzw_rel_pgtos_appxloja
               set tot_cli_cadastrados = v_tot_cli_cadastrados
               where (dta_mes = to_date(v_data_inicial,'dd/mm/yyyy'));
          end;

          commit;
     end;
end grz_rel_pgto_appxloja_sp;