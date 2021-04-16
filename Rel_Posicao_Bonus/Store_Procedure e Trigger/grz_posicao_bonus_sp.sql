/*------------------------------------------------------------------------
  Procedure.: grz_posicao_bonus_sp
  Empresa...: Grazziotin S/A
  Finalidade: Inserir os valores do bonus na tabela GRZ_POSICAO_BONUS, sendo
              os valores por rede e por tipo de bonus (Lojas, Aniversario e
              APP Clientes)

  Autor   Data     Operacao  Descricao
  Antonio ABR/2021 Criacao

  Parametros
  pDataInicial - Data inicial da selecao de dados
------------------------------------------------------------------------*/
create or replace procedure grz_posicao_bonus_sp(pdatainicial in varchar2)
is
begin
     declare
            v_data_inicial varchar2(10);
            v_data_final   varchar2(10);
            dt_data_final  date;
            type R_POSICAO_BONUS is record -- definicao do registro de dados para gravacao do BONUS
                 (cod_emp              number(4,0),
                  dta_movimento        date,
                  tip_bonus            number(2,0), -- 0-Loja,1-Aniversario,2-APP Clientes
                  pos_validade         number(3,0), -- em dias: 60 para lojas e app clientes e 37 para aniversario
                  qtd_bonus_disponivel number(10,0),
                  vlr_bonus_disponivel number(18,2),
                  dta_utilizados_ate   date,        -- gerada pela soma de pos_validade em dta_movimento
                  qtd_bonus_utilizado  number(10,0),
                  vlr_bonus_utilizado  number(18,2),
                  perc_qtd_utilizado   number(5,2), -- (qtd_bonus_utilizado * 100) / qtd_bonus_disponivel 
                  perc_vlr_utilizado   number(5,2)); -- (vlr_bonus_utilizado * 100) / vlr_bonus_disponivel
            POSICAO_BONUS R_POSICAO_BONUS;

             /*----------------------------------------------------------------------------------
             /* Declaracao dos cursores 
             /*----------------------------------------------------------------------------------
             /* Cursor para selecao dos dados da tabela grz_posicao_bonus, para calculo dos 
                percentuais; tem como parametro a data inicial; devido ao fato da mesma fazer
                parte da chave-primaria da tabela, em consequencia os percentuais serao calculados
                para todos os registros cuja data seja a mesma passada como parametro */
             cursor cursor_posicao_bonus (pDataInicial varchar2) is
                    select *
                    from grz_posicao_bonus
                    where (dta_movimento = to_date(pDataInicial,'dd/mm/yyyy'));
             reg_posicao_bonus cursor_posicao_bonus%rowtype; -- definicao do registro de dados

             /* Posicao (quantidade e valor) de bonus em lojas, campos qtd_bonus_disponivel e 
                vlr_bonus_disponivel, com parametros:
                pDataInicio: data inicial da leitura dos valores 
                pDataFinal: data final da leitura dos valores */
             cursor cursor_bonus_lojas (pDataInicial varchar2, pDataFinal varchar2) is
                    select grz_mvto_bonus.cod_emp,
                           count(1) as qtd_bonus_disponivel, 
                           sum(grz_mvto_bonus.vlr_bonus) as vlr_bonus_disponivel
                    from grz_mvto_bonus
                    where grz_mvto_bonus.cod_emp in (10,30,40,50,70)
                    and grz_mvto_bonus.cod_bonus > 0
                    and grz_mvto_bonus.cod_unidade in (select cod_unidade 
                                                       from ge_grupos_unidades ge 
                                                       where cod_grupo in (910,930,940,950,970) and cod_emp = 1)
                    and grz_mvto_bonus.dta_validade_bonus between to_date(pDataInicial,'dd/mm/yyyy') and
                                                                  to_date(pDataFinal,'dd/mm/yyyy')
                    and grz_mvto_bonus.tip_movimento = 1
                    and not exists (select 1 from grz_mvto_bonus bonus
                                    where grz_mvto_bonus.cod_bonus = bonus.cod_bonus
                                    and grz_mvto_bonus.cod_lote = bonus.cod_lote
                                    and bonus.tip_movimento = 2
                                    and bonus.dta_movimento < to_date(pDataInicial,'dd/mm/yyyy'))
                    group by grz_mvto_bonus.cod_emp
                    order by grz_mvto_bonus.cod_emp;
             reg_bonus_lojas cursor_bonus_lojas%rowtype; -- definicao do registro de dados

             /* Quantidade e valor de bonus UTILIZADOS em lojas, campos qtd_bonus_utilizado e 
                vlr_bonus_utilizado, com parametros:
                pDataInicio: data inicial da leitura dos valores 
                pDataFinal: data final da leitura dos valores */
             cursor cursor_bonus_utilizados (pDataInicial varchar2, pDataFinal varchar2) is
                    select grz_mvto_bonus.cod_emp,
                           count(1) as qtd_bonus_utilizado,
                           sum(grz_mvto_bonus.vlr_bonus) as vlr_bonus_utilizado
                    from grz_mvto_bonus
                    where grz_mvto_bonus.cod_emp in (10,30,40,50,70)
                    and grz_mvto_bonus.cod_bonus > 0
                    and grz_mvto_bonus.cod_unidade in (select cod_unidade 
                                                       from ge_grupos_unidades
                                                       where cod_grupo in (910,930,940,950,970) and cod_emp = 1)
                    and grz_mvto_bonus.dta_validade_bonus between to_date(pDataInicial,'dd/mm/yyyy') and 
                                                                  to_date(pDataFinal,'dd/mm/yyyy')
                    and grz_mvto_bonus.tip_movimento = 1
                    and exists (select 1 
                                from grz_mvto_bonus bonus
                                where grz_mvto_bonus.cod_bonus = bonus.cod_bonus
                                and grz_mvto_bonus.cod_lote = bonus.cod_lote
                                and bonus.tip_movimento = 2
                                and bonus.dta_movimento between to_date(pDataInicial,'dd/mm/yyyy') and 
                                                        to_date(pDataFinal,'dd/mm/yyyy'))
                    group by grz_mvto_bonus.cod_emp
                    order by grz_mvto_bonus.cod_emp;
             reg_bonus_utilizados cursor_bonus_utilizados%rowtype; -- definicao do registro de dados

             /* Quantidade e valor de bonus A UTILIZAR (disponivel) em virtude de Aniversario, 
                campos qtd_bonus_disponivel e vlr_bonus_disponivel, com parametros:
                pDataInicio: data inicial da leitura dos valores 
                pDataFinal: data final da leitura dos valores */
             cursor cursor_aniversario_disponivel (pDataInicial varchar2, pDataFinal varchar2) is
                    select grz_controle_bonus.cod_emp, 
                           count(1) as qtd_bonus_disponivel, 
                           sum(grz_controle_bonus.vlr_bonus) as vlr_bonus_disponivel
                    from grz_controle_bonus
                    where grz_controle_bonus.cod_emp in (10,30,40,50,70)
                    and grz_controle_bonus.cod_bonus > 0
                    and grz_controle_bonus.cod_lote in (9910,9930,9940,9950,9970)
                    and grz_controle_bonus.dta_validade_ret between to_date(pDataInicial,'dd/mm/yyyy') and
                                                                    to_date(pDataFinal,'dd/mm/yyyy')
                    and not exists (select 1 from grz_mvto_bonus bonus
                                    where grz_controle_bonus.cod_bonus = bonus.cod_bonus
                                    and grz_controle_bonus.cod_lote = bonus.cod_lote
                                    and bonus.tip_movimento = 2
                                    and bonus.dta_movimento < to_date(pDataInicial,'dd/mm/yyyy'))
                    group by grz_controle_bonus.cod_emp
                    order by grz_controle_bonus.cod_emp;
             reg_aniversario_disponivel cursor_aniversario_disponivel%rowtype; -- definicao do registro de dados

             /* Quantidade e valor de bonus GASTO (utilizado) em virtude de Aniversario, 
                campos qtd_bonus_utilizado e vlr_bonus_utilizado, com parametros:
                pDataInicio: data inicial da leitura dos valores 
                pDataFinal: data final da leitura dos valores */
             cursor cursor_aniversario_utilizados (pDataInicial varchar2, pDataFinal varchar2) is
                    select grz_controle_bonus.cod_emp,
                           count(1) as qtd_bonus_utilizado,
                           sum(grz_controle_bonus.vlr_bonus) as vlr_bonus_utilizado
                    from grz_controle_bonus
                    where grz_controle_bonus.cod_emp in (10,30,40,50,70)
                    and grz_controle_bonus.cod_bonus > 0
                    and grz_controle_bonus.cod_lote in (9910,9930,9940,9950,9970)
                    and grz_controle_bonus.dta_validade_ret between to_date(pDataInicial,'dd/mm/yyyy') and
                                                                    to_date(pDataFinal,'dd/mm/yyyy')
                    and exists (select 1 from grz_mvto_bonus bonus
                                where grz_controle_bonus.cod_bonus = bonus.cod_bonus
                                and grz_controle_bonus.cod_lote = bonus.cod_lote
                                and bonus.tip_movimento = 2
                                and bonus.dta_movimento between to_date(pDataInicial,'dd/mm/yyyy') and
                                                                to_date(pDataFinal,'dd/mm/yyyy'))
                    group by grz_controle_bonus.cod_emp
                    order by grz_controle_bonus.cod_emp;
             reg_aniversario_utilizados cursor_aniversario_utilizados%rowtype; -- definicao do registro de dados

             /* Quantidade e valor de bonus para o APP Clientes, campos qtd_bonus_disponivel e 
                vlr_bonus_disponivel, com parametros:
                pDataInicio: data inicial da leitura dos valores 
                pDataFinal: data final da leitura dos valores */
             cursor cursor_app_clientes_disponivel (pDataInicial varchar2, pDataFinal varchar2) is
                    select grz_controle_bonus.cod_emp,
                           count(1) as qtd_bonus_disponivel,
                           sum(grz_controle_bonus.vlr_bonus) as vlr_bonus_disponivel
                    from grz_controle_bonus
                    where grz_controle_bonus.cod_emp > 0
                    and grz_controle_bonus.cod_bonus > 0
                    and grz_controle_bonus.cod_lote = 702
                    and grz_controle_bonus.dta_validade_ret between to_date(pDataInicial,'dd/mm/yyyy') and
                                                                    to_date(pDataFinal,'dd/mm/yyyy')
                    and not exists (select 1 from grz_mvto_bonus bonus
                                    where grz_controle_bonus.cod_bonus = bonus.cod_bonus
                                    and grz_controle_bonus.cod_lote = bonus.cod_lote
                                    and bonus.tip_movimento = 2
                                    and bonus.dta_movimento < to_date(pDataInicial,'dd/mm/yyyy'))
                    group by grz_controle_bonus.cod_emp
                    order by grz_controle_bonus.cod_emp;
             reg_app_clientes_disponivel cursor_app_clientes_disponivel%rowtype; -- definicao do registro de dados

             /* Quantidade e valor de bonus GASTO (utilizado) para APP Clientes, 
                campos qtd_bonus_utilizado e vlr_bonus_utilizado, com parametros:
                pDataInicio: data inicial da leitura dos valores 
                pDataFinal: data final da leitura dos valores */
             cursor cursor_app_clientes_utilizado (pDataInicial varchar2, pDataFinal varchar2) is
                    select grz_controle_bonus.cod_emp,
                           count(1) as qtd_bonus_utilizado,
                           sum(grz_controle_bonus.vlr_bonus) as vlr_bonus_utilizado
                    from grz_controle_bonus
                    where grz_controle_bonus.cod_emp > 0
                    and grz_controle_bonus.cod_bonus > 0
                    and grz_controle_bonus.cod_lote = 702
                    and grz_controle_bonus.dta_validade_ret between to_date(pDataInicial,'dd/mm/yyyy') and
                                                                    to_date(pDataFinal,'dd/mm/yyyy')
                    and exists (select 1 from grz_mvto_bonus bonus
                                where grz_controle_bonus.cod_bonus = bonus.cod_bonus
                                and grz_controle_bonus.cod_lote = bonus.cod_lote
                                and bonus.tip_movimento = 2
                                and bonus.dta_movimento between to_date(pDataInicial,'dd/mm/yyyy') and
                                                                to_date(pDataFinal,'dd/mm/yyyy'))
                    group by grz_controle_bonus.cod_emp
                    order by grz_controle_bonus.cod_emp; 
             reg_app_clientes_utilizado cursor_app_clientes_utilizado%rowtype; -- definicao do registro de dados

     begin -- inicio da store procedure
          v_data_inicial := pdatainicial;
          dt_data_final := to_date(v_data_inicial,'dd/mm/yyyy') + 60; -- 60 dias para o bonus da LOJA
          v_data_final := to_char(dt_data_final,'dd/mm/yyyy'); 

          -- Abre o cursor para selecionar a posicao do bonus em lojas...
          open cursor_bonus_lojas (v_data_inicial,v_data_final);
          loop
              fetch cursor_bonus_lojas into reg_bonus_lojas;
              exit when cursor_bonus_lojas%notfound;

              -- Transfere os valores para o registro para gravacao...
              POSICAO_BONUS.cod_emp       := reg_bonus_lojas.cod_emp;
              POSICAO_BONUS.dta_movimento := v_data_inicial;
              POSICAO_BONUS.tip_bonus     := 0;  -- 0-Loja
              POSICAO_BONUS.pos_validade  := 60; -- em dias: 60 para lojas e app clientes
              POSICAO_BONUS.qtd_bonus_disponivel := reg_bonus_lojas.qtd_bonus_disponivel;
              POSICAO_BONUS.vlr_bonus_disponivel := reg_bonus_lojas.vlr_bonus_disponivel;
              -- dta_utilizados_ate: gerada pela soma de pos_validade em dta_movimento 
              POSICAO_BONUS.dta_utilizados_ate   := POSICAO_BONUS.dta_movimento + POSICAO_BONUS.pos_validade;

              /* Grava bonus na tabela posicao bonus (grz_posicao_bonus) */
              begin
                   insert into nl.grz_posicao_bonus
                               (cod_emp,
                                dta_movimento,
                                tip_bonus,
                                pos_validade,
                                qtd_bonus_disponivel,
                                vlr_bonus_disponivel,
                                dta_utilizados_ate)
                   values (POSICAO_BONUS.cod_emp,
                           to_date(POSICAO_BONUS.dta_movimento,'dd/mm/yyyy'),
                           POSICAO_BONUS.tip_bonus,
                           POSICAO_BONUS.pos_validade,
                           POSICAO_BONUS.qtd_bonus_disponivel,
                           POSICAO_BONUS.vlr_bonus_disponivel,
                           POSICAO_BONUS.dta_utilizados_ate);
                   exception
                            when dup_val_on_index then
                                 update nl.grz_posicao_bonus
                                        set qtd_bonus_disponivel = POSICAO_BONUS.qtd_bonus_disponivel,
                                            vlr_bonus_disponivel = POSICAO_BONUS.vlr_bonus_disponivel,
                                            dta_utilizados_ate   = POSICAO_BONUS.dta_utilizados_ate
                                 where (cod_emp = POSICAO_BONUS.cod_emp)
                                 and (to_date(dta_movimento,'dd/mm/yyyy') =
                                      to_date(POSICAO_BONUS.dta_movimento,'dd/mm/yyyy'))
                                 and (tip_bonus = POSICAO_BONUS.tip_bonus);
              end;
              commit;
          end loop; -- cursor_bonus_lojas%notfound;
          close cursor_bonus_lojas;

          -- Abre o cursor para selecionar os bonus UTILIZADOS lojas...
          open cursor_bonus_utilizados (v_data_inicial,v_data_final);
          loop
              fetch cursor_bonus_utilizados into reg_bonus_utilizados;
              exit when cursor_bonus_utilizados%notfound;

              -- Transfere os valores para o registro para gravacao...
              POSICAO_BONUS.cod_emp       := reg_bonus_utilizados.cod_emp;
              POSICAO_BONUS.dta_movimento := v_data_inicial;
              POSICAO_BONUS.tip_bonus     := 0; -- 0-Loja
              POSICAO_BONUS.qtd_bonus_utilizado := reg_bonus_utilizados.qtd_bonus_utilizado;
              POSICAO_BONUS.vlr_bonus_utilizado := reg_bonus_utilizados.vlr_bonus_utilizado;

              /* Grava bonus na tabela posicao bonus (grz_posicao_bonus) */
              begin
                   insert into nl.grz_posicao_bonus
                               (cod_emp,
                                dta_movimento,
                                tip_bonus,
                                qtd_bonus_utilizado,
                                vlr_bonus_utilizado)
                   values (POSICAO_BONUS.cod_emp,
                           to_date(POSICAO_BONUS.dta_movimento,'dd/mm/yyyy'),
                           POSICAO_BONUS.tip_bonus,
                           POSICAO_BONUS.qtd_bonus_utilizado,
                           POSICAO_BONUS.vlr_bonus_utilizado);
                   exception
                            when dup_val_on_index then
                                 update nl.grz_posicao_bonus
                                        set qtd_bonus_utilizado = POSICAO_BONUS.qtd_bonus_utilizado,
                                            vlr_bonus_utilizado = POSICAO_BONUS.vlr_bonus_utilizado
                                 where (cod_emp = POSICAO_BONUS.cod_emp)
                                 and (to_date(dta_movimento,'dd/mm/yyyy') =
                                      to_date(POSICAO_BONUS.dta_movimento,'dd/mm/yyyy'))
                                 and (tip_bonus = POSICAO_BONUS.tip_bonus);
              end;
              commit;
          end loop; -- cursor_bonus_utilizados%notfound;
          close cursor_bonus_utilizados;

          dt_data_final := to_date(v_data_inicial,'dd/mm/yyyy') + 37; -- 37 dias para o bonus de aniversario
          v_data_final := to_char(dt_data_final,'dd/mm/yyyy'); 

          -- Abre o cursor para selecionar o bonus (disponivel / a utilizar) de ANIVERSARIO...
          open cursor_aniversario_disponivel (v_data_inicial,v_data_final);
          loop
              fetch cursor_aniversario_disponivel into reg_aniversario_disponivel;
              exit when cursor_aniversario_disponivel%notfound;

              -- Transfere os valores para o registro para gravacao...
              POSICAO_BONUS.cod_emp       := reg_aniversario_disponivel.cod_emp;
              POSICAO_BONUS.dta_movimento := v_data_inicial;
              POSICAO_BONUS.tip_bonus     := 1;  -- 1-Aniversario
              POSICAO_BONUS.pos_validade  := 37; -- em dias: 37 para aniversario
              POSICAO_BONUS.qtd_bonus_disponivel := reg_aniversario_disponivel.qtd_bonus_disponivel;
              POSICAO_BONUS.vlr_bonus_disponivel := reg_aniversario_disponivel.vlr_bonus_disponivel;
              -- dta_utilizados_ate: gerada pela soma de pos_validade em dta_movimento 
              POSICAO_BONUS.dta_utilizados_ate   := POSICAO_BONUS.dta_movimento + POSICAO_BONUS.pos_validade;

              /* Grava na tabela, bonus aniversario (grz_posicao_bonus) */
              begin
                   insert into nl.grz_posicao_bonus
                               (cod_emp,
                                dta_movimento,
                                tip_bonus,
                                pos_validade,
                                qtd_bonus_disponivel,
                                vlr_bonus_disponivel,
                                dta_utilizados_ate)
                   values (POSICAO_BONUS.cod_emp,
                           to_date(POSICAO_BONUS.dta_movimento,'dd/mm/yyyy'),
                           POSICAO_BONUS.tip_bonus,
                           POSICAO_BONUS.pos_validade,
                           POSICAO_BONUS.qtd_bonus_disponivel,
                           POSICAO_BONUS.vlr_bonus_disponivel,
                           POSICAO_BONUS.dta_utilizados_ate);
                   exception
                            when dup_val_on_index then
                                 update nl.grz_posicao_bonus
                                        set qtd_bonus_disponivel = POSICAO_BONUS.qtd_bonus_disponivel,
                                            vlr_bonus_disponivel = POSICAO_BONUS.vlr_bonus_disponivel,
                                            dta_utilizados_ate   = POSICAO_BONUS.dta_utilizados_ate
                                 where (cod_emp = POSICAO_BONUS.cod_emp)
                                 and (to_date(dta_movimento,'dd/mm/yyyy') =
                                      to_date(POSICAO_BONUS.dta_movimento,'dd/mm/yyyy'))
                                 and (tip_bonus = POSICAO_BONUS.tip_bonus);
              end;
              commit;
          end loop; -- cursor_aniversario_disponivel%notfound;
          close cursor_aniversario_disponivel;

          -- Abre o cursor para selecionar o bonus GASTO (utilizado) de ANIVERSARIO...
          open cursor_aniversario_utilizados (v_data_inicial,v_data_final);
          loop
              fetch cursor_aniversario_utilizados into reg_aniversario_utilizados;
              exit when cursor_aniversario_utilizados%notfound;

              -- Transfere os valores para o registro para gravacao...
              POSICAO_BONUS.cod_emp       := reg_aniversario_utilizados.cod_emp;
              POSICAO_BONUS.dta_movimento := v_data_inicial;
              POSICAO_BONUS.tip_bonus     := 1; -- 1-Aniversario
              POSICAO_BONUS.qtd_bonus_utilizado := reg_aniversario_utilizados.qtd_bonus_utilizado;
              POSICAO_BONUS.vlr_bonus_utilizado := reg_aniversario_utilizados.vlr_bonus_utilizado;

              /* Grava na tabela, bonus GASTO (utilizado) de aniversario (grz_posicao_bonus) */
              begin
                   insert into nl.grz_posicao_bonus
                               (cod_emp,
                                dta_movimento,
                                tip_bonus,
                                qtd_bonus_utilizado,
                                vlr_bonus_utilizado)
                   values (POSICAO_BONUS.cod_emp,
                           to_date(POSICAO_BONUS.dta_movimento,'dd/mm/yyyy'),
                           POSICAO_BONUS.tip_bonus,
                           POSICAO_BONUS.qtd_bonus_utilizado,
                           POSICAO_BONUS.vlr_bonus_utilizado);
                   exception
                            when dup_val_on_index then
                                 update nl.grz_posicao_bonus
                                        set qtd_bonus_utilizado = POSICAO_BONUS.qtd_bonus_utilizado,
                                            vlr_bonus_utilizado = POSICAO_BONUS.vlr_bonus_utilizado
                                 where (cod_emp = POSICAO_BONUS.cod_emp)
                                 and (to_date(dta_movimento,'dd/mm/yyyy') =
                                      to_date(POSICAO_BONUS.dta_movimento,'dd/mm/yyyy'))
                                 and (tip_bonus = POSICAO_BONUS.tip_bonus);
              end;
              commit;
          end loop; -- cursor_aniversario_utilizados%notfound;
          close cursor_aniversario_utilizados;

          dt_data_final := to_date(v_data_inicial,'dd/mm/yyyy') + 60; -- 60 dias para APP Clientes
          v_data_final := to_char(dt_data_final,'dd/mm/yyyy'); 

          -- Abre o cursor para selecionar quantidade e valor disponiveis para APP Clientes...
          open cursor_app_clientes_disponivel (v_data_inicial,v_data_final);
          loop
              fetch cursor_app_clientes_disponivel into reg_app_clientes_disponivel;
              exit when cursor_app_clientes_disponivel%notfound;

              -- Transfere os valores para o registro para gravacao...
              POSICAO_BONUS.cod_emp       := reg_app_clientes_disponivel.cod_emp;
              POSICAO_BONUS.dta_movimento := v_data_inicial;
              POSICAO_BONUS.tip_bonus     := 2;  -- 2-APP Clientes
              POSICAO_BONUS.pos_validade  := 60; -- em dias: 60 para lojas e app clientes
              POSICAO_BONUS.qtd_bonus_disponivel := reg_app_clientes_disponivel.qtd_bonus_disponivel;
              POSICAO_BONUS.vlr_bonus_disponivel := reg_app_clientes_disponivel.vlr_bonus_disponivel;
              -- dta_utilizados_ate: gerada pela soma de pos_validade em dta_movimento 
              POSICAO_BONUS.dta_utilizados_ate   := POSICAO_BONUS.dta_movimento + POSICAO_BONUS.pos_validade;

              /* Grava na tabela posicao bonus (grz_posicao_bonus) quantidade e valores 
                 disponiveis para APP Clientes */
              begin
                   insert into nl.grz_posicao_bonus
                               (cod_emp,
                                dta_movimento,
                                tip_bonus,
                                pos_validade,
                                qtd_bonus_disponivel,
                                vlr_bonus_disponivel,
                                dta_utilizados_ate)
                   values (POSICAO_BONUS.cod_emp,
                           to_date(POSICAO_BONUS.dta_movimento,'dd/mm/yyyy'),
                           POSICAO_BONUS.tip_bonus,
                           POSICAO_BONUS.pos_validade,
                           POSICAO_BONUS.qtd_bonus_disponivel,
                           POSICAO_BONUS.vlr_bonus_disponivel,
                           POSICAO_BONUS.dta_utilizados_ate);
                   exception
                            when dup_val_on_index then
                                 update nl.grz_posicao_bonus
                                        set qtd_bonus_disponivel = POSICAO_BONUS.qtd_bonus_disponivel,
                                            vlr_bonus_disponivel = POSICAO_BONUS.vlr_bonus_disponivel,
                                            dta_utilizados_ate   = POSICAO_BONUS.dta_utilizados_ate
                                 where (cod_emp = POSICAO_BONUS.cod_emp)
                                 and (to_date(dta_movimento,'dd/mm/yyyy') =
                                      to_date(POSICAO_BONUS.dta_movimento,'dd/mm/yyyy'))
                                 and (tip_bonus = POSICAO_BONUS.tip_bonus);
              end;

              commit;
          end loop; -- cursor_app_clientes_disponivel%notfound;
          close cursor_app_clientes_disponivel;

          -- Abre o cursor para selecionar quantidade e valor gastos/utilizados para APP Clientes...
          open cursor_app_clientes_utilizado (v_data_inicial,v_data_final);
          loop
              fetch cursor_app_clientes_utilizado into reg_app_clientes_utilizado;
              exit when cursor_app_clientes_utilizado%notfound;

              -- Transfere os valores para o registro para gravacao...
              POSICAO_BONUS.cod_emp       := reg_app_clientes_utilizado.cod_emp;
              POSICAO_BONUS.dta_movimento := v_data_inicial;
              POSICAO_BONUS.tip_bonus     := 2; -- 2-APP Clientes
              POSICAO_BONUS.qtd_bonus_utilizado := reg_app_clientes_utilizado.qtd_bonus_utilizado;
              POSICAO_BONUS.vlr_bonus_utilizado := reg_app_clientes_utilizado.vlr_bonus_utilizado;

              /* Grava na tabela, bonus GASTO (utilizado) para APP Clientes (grz_posicao_bonus) */
              begin
                   insert into nl.grz_posicao_bonus
                               (cod_emp,
                                dta_movimento,
                                tip_bonus,
                                qtd_bonus_utilizado,
                                vlr_bonus_utilizado)
                   values (POSICAO_BONUS.cod_emp,
                           to_date(POSICAO_BONUS.dta_movimento,'dd/mm/yyyy'),
                           POSICAO_BONUS.tip_bonus,
                           POSICAO_BONUS.qtd_bonus_utilizado,
                           POSICAO_BONUS.vlr_bonus_utilizado);
                   exception
                            when dup_val_on_index then
                                 update nl.grz_posicao_bonus
                                        set qtd_bonus_utilizado = POSICAO_BONUS.qtd_bonus_utilizado,
                                            vlr_bonus_utilizado = POSICAO_BONUS.vlr_bonus_utilizado
                                 where (cod_emp = POSICAO_BONUS.cod_emp)
                                 and (to_date(dta_movimento,'dd/mm/yyyy') =
                                      to_date(POSICAO_BONUS.dta_movimento,'dd/mm/yyyy'))
                                 and (tip_bonus = POSICAO_BONUS.tip_bonus);
              end;
              commit;
          end loop; -- cursor_app_clientes_utilizado%notfound;
          close cursor_app_clientes_utilizado;

          -- Abre o cursor para selecionar calcular os percentuais de quantidades e valores...
          open cursor_posicao_bonus (v_data_inicial);
          loop
              fetch cursor_posicao_bonus into reg_posicao_bonus;
              exit when cursor_posicao_bonus%notfound;

              -- Transfere os valores para o registro para gravacao...
              POSICAO_BONUS.cod_emp       := reg_posicao_bonus.cod_emp;
              POSICAO_BONUS.dta_movimento := reg_posicao_bonus.dta_movimento;
              POSICAO_BONUS.tip_bonus     := reg_posicao_bonus.tip_bonus;
              POSICAO_BONUS.qtd_bonus_disponivel := reg_posicao_bonus.qtd_bonus_disponivel;
              POSICAO_BONUS.vlr_bonus_disponivel := reg_posicao_bonus.vlr_bonus_disponivel;
              POSICAO_BONUS.qtd_bonus_utilizado  := reg_posicao_bonus.qtd_bonus_utilizado;
              POSICAO_BONUS.vlr_bonus_utilizado  := reg_posicao_bonus.vlr_bonus_utilizado;

              -- Calcula percentuais dos bonus...
              POSICAO_BONUS.perc_qtd_utilizado := (POSICAO_BONUS.qtd_bonus_utilizado * 100) /
                                                  POSICAO_BONUS.qtd_bonus_disponivel;
              POSICAO_BONUS.perc_vlr_utilizado := (POSICAO_BONUS.vlr_bonus_utilizado * 100) /
                                                  POSICAO_BONUS.vlr_bonus_disponivel;

              /* Atualiza, na tabela grz_posicao_bonus, os percentuais calculados */
              begin
                   update nl.grz_posicao_bonus
                   set perc_qtd_utilizado = POSICAO_BONUS.perc_qtd_utilizado,
                       perc_vlr_utilizado = POSICAO_BONUS.perc_vlr_utilizado
                   where (cod_emp = POSICAO_BONUS.cod_emp)
                   and (to_date(dta_movimento,'dd/mm/yyyy') = 
                        to_date(POSICAO_BONUS.dta_movimento,'dd/mm/yyyy'))
                   and (tip_bonus = POSICAO_BONUS.tip_bonus);
              end;
              commit;
          end loop; -- cursor_posicao_bonus%notfound;
          close cursor_posicao_bonus;
     end; -- inicio da store procedure
end grz_posicao_bonus_sp;