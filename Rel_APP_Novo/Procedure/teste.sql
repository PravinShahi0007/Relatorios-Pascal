create or replace procedure teste_sp (pdatainicial in varchar2,
                                      pdatafinal in varchar2)
is
begin
     declare
            v_data_inicial            varchar2(10);
            v_data_final              varchar2(10);
            v_qtd_pgto_debito_loja    number(8);
            v_vlr_pgto_debito_loja    number(18,2);
            v_qtd_pgto_credito_loja   number(8);
            v_vlr_pgto_credito_loja   number(18,2);


     begin
          v_data_inicial := pdatainicial;
          v_data_final := pdatafinal;

          /* Valor e quantidade de débito e credito na LOJA */
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
                                           grz_tef_transacao_servidor.dta_movimento = c.dta_movimento and
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

          /* Grava dados do relatorio de vendas */
          begin
               insert into grzw_rel_pgtos_appxloja (dta_mes,
                                                    qtd_pgto_debito_loja,
                                                    vlr_pgto_debito_loja,
                                                    qtd_pgto_credito_loja,
                                                    vlr_pgto_credito_loja)
               values (to_date(v_data_inicial,'dd/mm/yyyy'),
                       v_qtd_pgto_debito_loja,
                       v_vlr_pgto_debito_loja,
                       v_qtd_pgto_credito_loja,
                       v_vlr_pgto_credito_loja);
          exception
                   when dup_val_on_index then
                        update grzw_rel_pgtos_appxloja
                        set qtd_pgto_debito_loja = v_qtd_pgto_debito_loja,
                            vlr_pgto_debito_loja = v_vlr_pgto_debito_loja,
                            qtd_pgto_credito_loja = v_qtd_pgto_credito_loja,
                            vlr_pgto_credito_loja = v_vlr_pgto_credito_loja
                        where (to_date(dta_mes,'dd/mm/yyyy') = to_date(v_data_inicial,'dd/mm/yyyy'));
          end;

          commit;
     end;
end teste_sp;