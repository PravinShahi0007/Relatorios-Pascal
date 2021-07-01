/*------------------------------------------------------------------------
  Procedure.: grz_rel_cancelamentos_sp
  Empresa...: Grazziotin S/A
  Finalidade: Gravacao e geracao de dados para o relatorio de estatistuica de
              cancelamentos

  Autor   Data     Operacao  Descricao
  Daniele ???/???? Criacao
  Antonio JUN/2021 Alteracao Formatacao do codigo-fonte. Ajuste de acordo
                             com a alteracao do codigo de item de 3 para 
                             4 posicoes

  Parametros
  pi_Opcao - Parametros da insercao de dados.
  Parametros: Empresa#Grupo#DataInicial#DataFinal#Usuario#
------------------------------------------------------------------------*/
create or replace procedure grz_rel_cancelamentos_sp(pi_opcao in varchar2)
is
begin
declare
       -- variaveis de configuracao
       v_result                   integer;
       v_cur                      integer;
       -- variaveis da procedure
       pi_empresa                 number(02);
       pi_grupo                   number(04);
       pi_dta_ini                 date;
       pi_dta_fim                 date;
       pi_usuario                 varchar2(50);
       wi                         number;
       wf                         number;
       wregiao                    number(4);
       wcod_unidade               number(4);
       wdes_fantasia              varchar2(20);
       wqtd_cancelamentos_z       number(12);
       wvlr_cancel_cupons_z       number(18,2);
       wvlr_vlr_venda             number(18,2);
       wqtd_cupons                number(12);
       wqtd_cupons_cancel         number(12);
       wqtd_itens_cancel          number(12);
       wqtd_itens                 number(12);
       wvlr_itens_cancel          number(18,2);
       wvlr_cupons_cancelados     number(18,2);
       wqtd_cupom_canc_meio_venda number(12);
       wvlr_cupom_canc_meio_venda number(18,2);
       wqtd_itens_canc_meio_venda number(12);
       wvlr_itens_canc_meio_venda number(18,2);
       saida                      exception;

       -- Deficao de cursores
       -- Cursor seleciona os qtd totais de cupons e valor venda bruta
       cursor c_cupons is
              select ge.cod_quebra regiao
                     ,a.cod_unidade
                     ,d.des_fantasia
                     ,count(distinct a.num_seq) qtde_cupons
                     ,sum(oper.vlr_operacao) valor_venda_loja
              from ns_notas a
                   ,ns_notas_operacoes oper
                   ,ge_grupos_unidades ge
                   ,ps_pessoas d
              where a.num_seq=oper.num_seq
              and a.cod_maquina = oper.cod_maquina
              and oper.cod_oper in (300,302,305,4300,4302,4305)
              and a.cod_unidade = ge.cod_unidade
              and ge.cod_grupo  = pi_grupo
              and ge.cod_emp    = pi_empresa
              and a.cod_unidade = d.cod_pessoa
              and a.ind_status  = 1
              and (a.tip_nota   = 3
              or (a.tip_nota    = 2
              and a.num_modelo  = 65))
              and a.dta_emissao between pi_dta_ini and pi_dta_fim
              group by ge.cod_quebra,a.cod_unidade,d.des_fantasia;
       r_cupons c_cupons%ROWTYPE;

       begin -- Inicio da PROCEDURE
            v_cur := dbms_sql.open_cursor;
            dbms_sql.parse(v_cur,'alter session set nls_date_format= "dd/mm/rrrr"',dbms_sql.native);
            v_result := dbms_sql.execute(v_cur);
            dbms_sql.close_cursor(v_cur);

            v_cur := dbms_sql.open_cursor;
            dbms_sql.parse(v_cur,'alter session set nls_numeric_characters = '',.''',dbms_sql.native);
            v_result := dbms_sql.execute(v_cur);
            dbms_sql.close_cursor(v_cur);

            wi := INSTR(pi_opcao, '#', 1, 1);
            pi_empresa := TO_NUMBER(SUBSTR(pi_opcao, 1,(wi-1)));
            wf := INSTR(pi_opcao, '#', 1, 2);
            pi_grupo := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
            wi := wf;
            wf := INSTR(pi_opcao, '#', 1, 3);
            pi_dta_ini := TO_DATE(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
            wi := wf;
            wf := INSTR(pi_opcao, '#', 1, 4);
            pi_dta_fim := TO_DATE(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
            wi := wf;
            wf := INSTR(pi_opcao, '#', 1, 5);
            pi_usuario := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));

            -- Limpa a tabela temporaria
            delete from grzw_rel_cancelados
            where upper(des_usuario) = upper(pi_usuario);
            commit;

            open c_cupons;
            fetch c_cupons into r_cupons;
            while c_cupons%found loop
            begin
                 wRegiao        := nvl(r_cupons.regiao,0);
                 wCod_unidade   := nvl(r_cupons.cod_unidade,0);
                 wDes_fantasia  := nvl(r_cupons.des_fantasia,0);
                 wQtd_Cupons    := nvl(r_cupons.qtde_cupons,0);
                 wVlr_Vlr_Venda := nvl(r_cupons.valor_venda_loja,0);

                 begin
                      select sum(c.qtd_cancelamentos)
                             ,sum(c.vlr_cancel_cupons)
                      into wqtd_cancelamentos_z
                           ,wvlr_cancel_cupons_z
                      from grz_lojas_reducoesz c
                      where c.cod_unidade = wcod_unidade
                      and c.dta_movimento between pi_dta_ini and pi_dta_fim;
                      exception
                               when no_data_found then
                                    wqtd_cancelamentos_z := 0;
                                    wvlr_cancel_cupons_z := 0;
                 end;

                 begin
                      select sum(decode(a.ind_cancelado,1,0,decode(a.ind_cancelado_item,1,1,0)))
                             ,sum(decode(a.seq_item,1,decode(a.ind_cancelado,1,1,0,0)))
                             ,sum(decode(a.ind_cancelado,1,0,decode(a.ind_cancelado_item,1,(nvl(a.vlr_total,0) + nvl(a.vlr_desconto,0) + nvl(a.vlr_desconto_item,0)),0)))
                             ,sum(decode(a.ind_cancelado,1,(nvl(a.vlr_total,0) + nvl(a.vlr_desconto,0) + nvl(a.vlr_desconto_item,0)),0))
                      into wqtd_itens_cancel
                           ,wqtd_cupons_cancel
                           ,wvlr_itens_cancel
                           ,wvlr_cupons_cancelados
                      from grz_lojas_cupom_itens a
                      where (a.ind_cancelado = 1 or a.ind_cancelado_item = 1)
                            and a.cod_unidade = wcod_unidade
                            and a.dta_lancamento between pi_dta_ini and pi_dta_fim;
                      exception
                               when no_data_found then
                                    wqtd_itens_cancel := 0;
                                    wqtd_cupons_cancel := 0;
                                    wvlr_itens_cancel := 0;
                                   wvlr_cupons_cancelados := 0;
                 end;

                 begin
                      select count(a.cod_item)
                      into wqtd_itens
                      from grz_lojas_cupom_itens a
                      where a.ind_cancelado = 0
                      and a.cod_unidade = wcod_unidade
                      and a.dta_lancamento between pi_dta_ini and pi_dta_fim;
                 end;

                 -- SQL para pegar os cupons e itens cancelados no meio da venda ****/
                 begin
                      select count(num_cupom), sum(vlr_cupom)
                      into wqtd_cupom_canc_meio_venda, wvlr_cupom_canc_meio_venda
                      from grz_lojas_cupom_cancelados
                      where cod_unidade = wcod_unidade
                      and dta_movimento between pi_dta_ini and pi_dta_fim;
                      exception
                               when no_data_found then
                                    wqtd_cupom_canc_meio_venda := 0;
                                    wvlr_cupom_canc_meio_venda := 0;
                 end;

                 insert into grzw_rel_cancelados(des_usuario
                                                 ,cod_unidade
                                                 ,des_fantasia
                                                 ,cod_regiao
                                                 ,qtd_cupons_canc_redz
                                                 ,vlr_cancelados_redz
                                                 ,qtd_itens_cancel
                                                 ,vlr_itens_cancel
                                                 ,vlr_cupom_cancel
                                                 ,vlr_venda_loja
                                                 ,qtd_cupons
                                                 ,qtd_cupons_cancel
                                                 ,qtd_itens)
                 values(pi_usuario
                        ,wcod_unidade
                        ,wdes_fantasia
                        ,wregiao
                        ,nvl(wqtd_cancelamentos_z,0)
                        ,nvl(wvlr_cancel_cupons_z,0)
                        ,nvl(wqtd_itens_cancel,0) --+ nvl(wqtd_itens_canc_meio_venda,0)
                        ,nvl(wvlr_itens_cancel,0) --+ nvl(wvlr_itens_canc_meio_venda,0)
                        ,nvl(wvlr_cupons_cancelados,0) + nvl(wvlr_cupom_canc_meio_venda,0)
                        ,nvl(wvlr_vlr_venda,0)
                        ,nvl(wqtd_cupons,0)
                        ,nvl(wqtd_cupons_cancel,0) + nvl(wqtd_cupom_canc_meio_venda,0)
                        ,nvl(wqtd_itens,0));
            end;
            fetch c_cupons into r_cupons;
            end loop;
            close c_cupons;
            commit;
       end;
end grz_rel_cancelamentos_sp;
