/*------------------------------------------------------------------------
  Procedure.: grz_insere_vendas_ecommerce_sp
  Empresa...: Grazziotin S/A
  Finalidade: Inserir os valores da venda do e-commerce na tabela de
              vendas diarias

  Autor   Data     Operacao  Descricao
  Antonio MAR/2021 Criacao

  Parametros
  pDataInicial - Data inicial da selecao de dados
  pDataFinal   - Data final da selecao de dados, compoem o periodo da
                 selecao de dados
------------------------------------------------------------------------*/
create or replace procedure grz_insere_vendas_ecommerce_sp(pdatainicial in varchar2,
                                                           pdatafinal in varchar2)
is
begin
     declare
            --v_result       integer;
            --v_cur          integer;
            v_data_inicial varchar2(10);
            v_data_final   varchar2(10);
            type R_ECOMMERCE is record -- definicao do registro de dados para gravacao da VENDA DIARIA
                 (cod_loja        number(4), -- numero da loja / unidade
                  cod_rede        number(2), -- codigo de rede, equivale ao codigo da empresa
                  cod_regiao      number(4),
                  dt_mvto         date,
                  cod_mp_resumo   number(9),
                  cod_ecf         number(9), -- numero do CAIXA, criar um numero, sugestao: 666
                  gt_inicial      number(18),
                  gt_atual        number(18),
                  venda_bruta_dia number(13,2),
                  total_liq_dia   number(13,2),
                  dt_alteracao    varchar2(10));
            ECOMMERCE R_ECOMMERCE;

            cursor cursor_lojas_ecommerce is
                   select nl.grz_moovin_config_rede.cod_emp,
                          nl.grz_moovin_config_rede.num_loja,
                          grazz.grz_lojas.cod_regiao
                   from nl.grz_moovin_config_rede, grazz.grz_lojas
                   where nl.grz_moovin_config_rede.cod_emp = grazz.grz_lojas.cod_rede 
                   and grazz.grz_lojas.cod_loja = nl.grz_moovin_config_rede.num_loja
                   --and nl.grz_moovin_config_rede.num_loja = 4549
                   order by nl.grz_moovin_config_rede.num_loja;
            reg_lojas_ecommerce cursor_lojas_ecommerce%rowtype; -- definicao do registro de dados

            /* Cursor para ler os valores de E-Commerce, com parametros:
               pCodLoja: codigo da loja
               pDataInicio: data inicial da leitura dos valores 
               pDataFinal: data final da leitura dos valores */
            cursor cursor_le_valores_ecommerce (pCodLoja NUMBER, pDataInicial VARCHAR2, pDataFinal VARCHAR2) is
                   select nl.ns_notas.dta_emissao,
                          sum(nvl(nl.ns_notas_operacoes.vlr_operacao,0)) as vlr_operacao
                   from nl.ns_notas, nl.ns_notas_operacoes
                   where nl.ns_notas.num_seq = nl.ns_notas_operacoes.num_seq
                   and nl.ns_notas.cod_maquina = nl.ns_notas_operacoes.cod_maquina 
                   and nl.ns_notas.cod_unidade = pCodLoja
                   and nl.ns_notas.dta_emissao between to_date(pDataInicial,'dd/mm/yyyy') and
                                                       to_date(pDataFinal,'dd/mm/yyyy') 
                   and nl.ns_notas_operacoes.cod_oper = 3301 
                   and nl.ns_notas.tip_nota = 2 
                   and nl.ns_notas.ind_status = 1
                   group by nl.ns_notas.dta_emissao;
            reg_le_valores_ecommerce cursor_le_valores_ecommerce%rowtype; -- definicao do registro de dados

     begin
          --v_cur := dbms_sql.open_cursor;
          --dbms_sql.parse(v_cur,'alter session set nls_date_format= "dd/mm/rrrr"',dbms_sql.native);
          --v_result := dbms_sql.execute(v_cur);
          --dbms_sql.close_cursor(v_cur);     

          v_data_inicial := pdatainicial;
          v_data_final := pdatafinal;

          ECOMMERCE.cod_mp_resumo := 0;
          ECOMMERCE.cod_ecf := 666;
          ECOMMERCE.gt_inicial := 0;
          ECOMMERCE.gt_atual := 0;
          ECOMMERCE.dt_alteracao := v_data_inicial; --to_date(v_data_inicial,'dd/mm/yyyy'); --sysdate;

          open cursor_lojas_ecommerce;
          fetch cursor_lojas_ecommerce into reg_lojas_ecommerce;
          while cursor_lojas_ecommerce%found loop
                ECOMMERCE.cod_loja := reg_lojas_ecommerce.num_loja;
                ECOMMERCE.cod_rede := reg_lojas_ecommerce.cod_emp;
                ECOMMERCE.cod_regiao := reg_lojas_ecommerce.cod_regiao;

                begin
                     /* Cursor: Seleciona vendas diarias por loja/unidade */
                     open cursor_le_valores_ecommerce(ECOMMERCE.cod_loja,v_data_inicial,v_data_final);
                     --open cursor_le_valores_ecommerce(549,v_data_inicial,v_data_final);
                     loop
                         fetch cursor_le_valores_ecommerce into reg_le_valores_ecommerce;
                         exit when cursor_le_valores_ecommerce%notfound;

                         ECOMMERCE.dt_mvto := reg_le_valores_ecommerce.dta_emissao;
                         ECOMMERCE.venda_bruta_dia := reg_le_valores_ecommerce.vlr_operacao;
                         if ECOMMERCE.dt_mvto is null then
                            ECOMMERCE.dt_mvto := to_date(v_data_inicial,'dd/mm/yyyy');
                         end if;
                         ECOMMERCE.total_liq_dia := ECOMMERCE.venda_bruta_dia;

                         /* Grava vendas na tabela venda diaria (vda_venda_diaria) */
                         begin
                              insert into grazz.vda_venda_diaria
                                         (cod_loja,
                                          cod_rede,
                                          cod_regiao,
                                          dt_mvto,
                                          cod_mp_resum,
                                          cod_ecf,
                                          gt_inicial,
                                          gt_atual,
                                          venda_bruta_dia,
                                          total_liq_dia,
                                          dt_alteracao)
                              values (ECOMMERCE.cod_loja,
                                      ECOMMERCE.cod_rede,
                                      ECOMMERCE.cod_regiao,
                                      to_date(ECOMMERCE.dt_mvto,'dd/mm/yyyy'),
                                      ECOMMERCE.cod_mp_resumo,
                                      ECOMMERCE.cod_ecf,
                                      ECOMMERCE.gt_inicial,
                                      ECOMMERCE.gt_atual,
                                      ECOMMERCE.venda_bruta_dia,
                                      ECOMMERCE.total_liq_dia,
                                      to_date(ECOMMERCE.dt_alteracao,'dd/mm/yyyy'));
                              exception
                                       when dup_val_on_index then
                                            update grazz.vda_venda_diaria
                                            set venda_bruta_dia = ECOMMERCE.venda_bruta_dia,
                                                total_liq_dia = ECOMMERCE.total_liq_dia
                                            where (cod_loja = ECOMMERCE.cod_loja)
                                            and (cod_rede = ECOMMERCE.cod_rede)
                                            and (cod_regiao = ECOMMERCE.cod_regiao)
                                            and (to_date(dt_mvto,'dd/mm/yyyy') = to_date(ECOMMERCE.dt_mvto,'dd/mm/yyyy'))
                                            and (cod_mp_resum = ECOMMERCE.cod_mp_resumo)
                                            and (cod_ecf = ECOMMERCE.cod_ecf)
                                            and (gt_inicial = ECOMMERCE.gt_inicial)
                                            and (gt_atual = ECOMMERCE.gt_atual);
                         end;
                         commit;
                     end loop; -- cursor_le_valores_ecommerce%notfound;
                     close cursor_le_valores_ecommerce;
                end;
                fetch cursor_lojas_ecommerce into reg_lojas_ecommerce;
          end loop; -- cursor_lojas_ecommerce%found loop
          close cursor_lojas_ecommerce;
     end;
end grz_insere_vendas_ecommerce_sp;