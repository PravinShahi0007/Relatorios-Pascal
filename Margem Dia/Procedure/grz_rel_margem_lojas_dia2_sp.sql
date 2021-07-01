/*---------------------------------------------------------------------------------
  Procedure.: grz_rel_margem_lojas_dia2_sp
  Empresa...: Grazziotin S/A
  Finalidade: Gravar e gerar dados para o relatorio de margem dia

  Autor   Data     Operacao  Descricao
  ??????? ???/???? Criacao
  Antonio JUN/2021 Alteracao Aumento das posicoes das variaveis pi_codigo_ini e 
                             pi_codigo_fim, de 11 para 12 posicoes, devido a 
                             alteracao no item de 3 para 4 posicoes.
  Parametros
  pi_Opcao - Parametros da geracao de dados.
  Parametros: 
----------------------------------------------------------------------------------*/
create or replace procedure grz_rel_margem_lojas_dia2_sp (pi_opcao in varchar2)
is
begin
declare
       v_result                  integer;
       v_cur                     integer;
       pi_empresa                number;
       pi_grupo                  number;
       pi_dta_ini                varchar2(10);
       pi_dta_fim                varchar2(10);
       pi_dta_comp_ini           varchar2(10);
       pi_dta_comp_fim           varchar2(10);
       pi_mascara                number;
       pi_rede                   varchar2(02);
       pi_codigo_ini             varchar2(12);
       pi_codigo_fim             varchar2(12);
       pi_nivel_mascara          number;
       pi_lista_unidade          number;
       pi_desc_devolucao         number;
       pi_totais                 number;
       pi_usuario                varchar2(30);
       pi_unidade_ini            number;
       pi_unidade_fim            number;

       wi                        number;
       wf                        number;
       wcompleto                 varchar2(20);
       wcompleto_ant             varchar2(20);
       weditado                  varchar2(20);
       wcod_anteriores           varchar2(20);
       wcod_nivel                varchar2(20);
       wdes_nivel                varchar2(50);
       wdes_grupo                varchar2(50);
       wdes_quebra               varchar2(50);
       wdes_unidade              varchar2(50);
       woper_devolucoes          varchar2(50);
       wcod_quebra               number;
       wqtd_casas                number;
       wqtd_casas1               number;
       wqtd_casas2               number;
       wseq_nivel                number;
       wnivel                    number;
       wnivel_t                  number;
       wmargem                   number(18,2);
       wvlr_venda_liq            number(18,2);
       wvlr_venda_liq_ant        number(18,2);
       wcresc_qtd                number(10,2);
       wcresc_venda              number(10,2);
       wcresc_venda_liq          number(10,2);
       wtot_qtd_venda_rede       number(18,2);
       wtot_vlr_venda_rede       number(18,2);
       wtot_vlr_venda_liq_rede   number(18,2);
       wpart_qtd_venda_nivel     number(5,2);
       wpart_vlr_venda_nivel     number(15,2);
       wpart_vlr_venda_liq_nivel number(5,2);
       wpart_qtd_venda_rede      number(5,2);
       wpart_vlr_venda_rede      number(5,2);
       wpart_vlr_venda_liq_rede  number(5,2);
       wpart_qtd_venda_geral     number(5,2);
       wpart_vlr_venda_geral     number(5,2);
       wpart_vlr_venda_liq_geral number(5,2);
       wdta_ref                  varchar2(10);
       wcod_grupo                number;
       wvlrtestador              number(20,2);
       saida                     exception;

       -- cursor pega os valores
       cursor c_itens is
              select substr(c.cod_completo,1,wqtd_casas) cod_completo
                     ,substr(c.cod_editado,1,wqtd_casas1) cod_editado
                     ,decode(pi_lista_unidade,1,a.cod_unidade,pi_grupo) cod_unidade
                     ,decode(pi_totais,0,a.dta_lancamento,1,trunc(sysdate),a.dta_lancamento) dta_lancamento
                     ,sum(decode(a.tip_lancamento,2,nvl(a.qtd_lancamento,0),1,(nvl(a.qtd_lancamento,0) * -1),0)) qtd_venda
                     ,sum(decode(a.tip_lancamento,2,nvl(a.vlr_presente,0),1,((nvl(a.vlr_total,0)) * -1),0)) vlr_venda
                     ,sum(decode(a.tip_lancamento,2,nvl(a.vlr_icms,0),1,(nvl(a.vlr_icms,0) * -1),0)) vlr_icms
                     ,sum(decode(a.tip_lancamento,2,nvl(d.vlr_pis,0),1,(nvl(a.vlr_pis,0) * -1),0)) vlr_pis
                     ,sum(decode(a.tip_lancamento,2,nvl(d.vlr_cofins,0),1,(nvl(a.vlr_cofins,0) * -1),0)) vlr_cofins
                     ,sum(decode(a.tip_lancamento,2,nvl(a.vlr_medio_emp,0),1,(nvl(a.vlr_medio_emp,0) * -1),0)) vlr_custo
                     ,sum(decode(es.ind_saldo,'s',decode(a.tip_lancamento,2,nvl(a.vlr_presente,0),1,((nvl(a.vlr_total,0)) * -1),0),0)) vlr_venda_saldo
              from ce_diarios a
                   ,ie_mascaras c
                   ,ns_itens d
                   ,t6_oper_quebras o
                   ,ne_itens e
                   ,es_0124_ce_estmedio es
                   ,grz_lojas_unificadas_cia t
              where a.cod_item     = c.cod_item
              and c.cod_mascara    = pi_mascara
              and c.cod_completo   >= pi_codigo_ini
              and c.cod_completo   <= pi_codigo_fim
              and a.num_seq        = d.num_seq_ce(+)
              and a.cod_maquina    = d.cod_maq_ce(+)
              and a.num_seq        = e.num_seq_ce(+)
              and a.cod_maquina    = e.cod_maq_ce(+)
              and a.cod_unidade    = t.cod_unidade_de(+)
              and a.cod_oper       = o.cod_oper
              and o.cod_grupo_oper in (7300,to_number(woper_devolucoes))
              and a.dta_lancamento >= pi_dta_ini
              and a.dta_lancamento <= pi_dta_fim
              and a.cod_emp        = es.cod_emp
              and a.cod_item       = es.cod_item
              and decode(a.cod_unidade,t.cod_unidade_de,t.cod_unidade_para,a.cod_unidade) = es.cod_unidade
              and es.dta_mvto      = to_date('01/'||to_char(a.dta_lancamento,'mm/yyyy'),'dd/mm/yyyy')
              and exists (select 1 from ge_grupos_unidades ge
                          where a.cod_unidade = ge.cod_unidade
                          and ge.cod_grupo  = pi_grupo
                          and ge.cod_emp    = pi_empresa
                          and ge.cod_unidade between pi_unidade_ini and pi_unidade_fim)
              group by substr(c.cod_completo,1,wqtd_casas)
                       ,substr(c.cod_editado,1,wqtd_casas1)
                       ,decode(pi_lista_unidade,1,a.cod_unidade,pi_grupo)
                       ,decode(pi_totais,0,a.dta_lancamento,1,trunc(sysdate),a.dta_lancamento);
       r_itens c_iten s%rowtype;

       -- cursor pega totais dos niveis
       cursor c_niveis is
              select substr(cod_nivel,1,wqtd_casas) cod_nivel
                     ,substr(cod_editado,1,wqtd_casas1) cod_editado
                     ,dta_ref
                     ,cod_grupo
                     ,cod_quebra
                     ,cod_unidade
                     ,des_grupo
                     ,des_quebra
                     ,des_unidade
                     ,sum(vlr_venda) vlr_venda
                     ,sum(vlr_venda_liq) vlr_venda_liq
                     ,sum(vlr_custo) vlr_custo
                     ,sum(vlr_desconto) vlr_desconto
                     ,sum(qtd_venda) qtd_venda
                     ,sum(vlr_venda_saldo) vlr_venda_saldo
              from grzw_rel_descontos_lojas_nl
              where upper(des_usuario) = upper(pi_usuario)
              and seq_nivel = wseq_nivel
              group by substr(cod_nivel,1,wqtd_casas)
                      ,substr(cod_editado,1,wqtd_casas1)
                      ,dta_ref
                      ,cod_grupo
                      ,cod_quebra
                      ,cod_unidade
                      ,des_grupo
                      ,des_quebra
                      ,des_unidade;
       r_niveis c_niveis%rowtype;

       cursor c_cresc is
              select substr(c.cod_completo,1,wqtd_casas) cod_completo
                     ,substr(c.cod_editado,1,wqtd_casas1) cod_editado
                     ,decode(pi_lista_unidade,1,a.cod_unidade,pi_grupo) cod_unidade
                     ,f.qtd_venda qtd_venda
                     ,f.vlr_venda vlr_venda
                     ,f.vlr_venda_liq vlr_venda_liq
                     ,sum(decode(a.tip_lancamento,2,nvl(a.qtd_lancamento,0),1,(nvl(a.qtd_lancamento,0) * -1),0)) qtd_venda_ant
                     ,sum(decode(a.tip_lancamento,2,nvl(a.vlr_presente,0),1,((nvl(a.vlr_total,0)) * -1),0)) vlr_venda_ant
                     ,sum(decode(a.tip_lancamento,2,nvl(a.vlr_icms,0),1,(nvl(a.vlr_icms,0) * -1),0)) vlr_icms_ant
                     ,sum(decode(a.tip_lancamento,2,nvl(d.vlr_pis,0),1,(nvl(a.vlr_pis,0) * -1),0)) vlr_pis_ant
                     ,sum(decode(a.tip_lancamento,2,nvl(d.vlr_cofins,0),1,(nvl(a.vlr_cofins,0) * -1),0)) vlr_cofins_ant
                     ,sum(decode(a.tip_lancamento,2,nvl(a.vlr_medio_emp,0),1,(nvl(a.vlr_medio_emp,0) * -1),0)) vlr_custo_ant
              from ce_diarios a
                   ,ie_mascaras c
                   ,ns_itens d
                   ,t6_oper_quebras o
                   ,ne_itens e
                   ,grzw_rel_descontos_lojas_nl f
              where a.cod_item     = c.cod_item
              and c.cod_mascara    = pi_mascara
              and c.cod_completo  >= pi_codigo_ini
              and c.cod_completo  <= pi_codigo_fim
              and a.num_seq        = d.num_seq_ce(+)
              and a.cod_maquina    = d.cod_maq_ce(+)
              and a.num_seq        = e.num_seq_ce(+)
              and a.cod_maquina    = e.cod_maq_ce(+)
              and a.cod_oper       = o.cod_oper
              and o.cod_grupo_oper in (7300,to_number(woper_devolucoes))
              and a.dta_lancamento >= pi_dta_comp_ini
              and a.dta_lancamento <= pi_dta_comp_fim
              and upper(f.des_usuario) = upper(pi_usuario)
              and f.seq_nivel = wnivel
              and f.cod_unidade = decode(pi_lista_unidade,1,a.cod_unidade,pi_grupo)
              and f.cod_nivel = substr(c.cod_completo,1,wqtd_casas)
              and f.cod_editado = substr(c.cod_editado,1,wqtd_casas1)
              and exists (select 1 from ge_grupos_unidades ge
                          where a.cod_unidade = ge.cod_unidade
                          and ge.cod_grupo  = pi_grupo
                          and ge.cod_emp    = pi_empresa
                          and ge.cod_unidade between pi_unidade_ini and pi_unidade_fim)
              group by substr(c.cod_completo,1,wqtd_casas)
                       ,substr(c.cod_editado,1,wqtd_casas1)
                       ,decode(pi_lista_unidade,1,a.cod_unidade,pi_grupo)
                       ,f.qtd_venda
                       ,f.vlr_venda
                       ,f.vlr_venda_liq;
       r_cresc c_cresc%rowtype;

       cursor c_tot_nivel is
              /*select substr(c.cod_completo,1,wQtd_Casas) cod_nivel
                       ,pi_grupo cod_grupo
                       ,decode(pi_Totais,0,a.dta_lancamento,1,trunc(sysdate),a.dta_lancamento) dta_ref
                       ,sum(decode(a.tip_lancamento,2,nvl(a.vlr_presente,0),1,((nvl(a.vlr_total,0)) * -1),0)) vlr_venda_nivel
                       -- ,decode(pi_lista_unidade,1,a.cod_unidade,pi_grupo) cod_unidade
                       -- ,ge.cod_quebra
              from ce_diarios a
                   ,ie_mascaras c
                   ,ns_itens d
                   ,t6_oper_quebras o
                   ,ne_itens e
                   ,es_0124_ce_estmedio es
                   ,ge_grupos_unidades ge
              where a.cod_item       = c.cod_item
              and c.cod_mascara    = pi_mascara
              and c.cod_completo  >= pi_codigo_ini
              and c.cod_completo  <= pi_codigo_fim
              and a.num_seq        = d.num_seq_ce(+)
              and a.cod_maquina    = d.cod_maq_ce(+)
              and a.num_seq        = e.num_seq_ce(+)
              and a.cod_maquina    = e.cod_maq_ce(+)
              and a.cod_oper       = o.cod_oper
              and o.cod_grupo_oper in (300,to_number(wOper_Devolucoes))
              and a.dta_lancamento>= pi_Dta_Ini
              and a.dta_lancamento<= pi_Dta_Fim
              and a.cod_emp        = es.cod_emp
              and a.cod_item       = es.cod_item
              and a.cod_unidade    = es.cod_unidade
              and es.dta_mvto      = to_date( '01/'||to_char(a.dta_lancamento, 'mm/yyyy'), 'dd/mm/yyyy')
              and a.cod_unidade = ge.cod_unidade
              and ge.cod_grupo  = pi_grupo
              and ge.cod_emp    = pi_empresa
              --and ge.cod_unidade between pi_unidade_ini and pi_unidade_fim
              group by substr(c.cod_completo,1,wQtd_Casas)
                       ,decode(pi_Totais,0,a.dta_lancamento,1,trunc(sysdate),a.dta_lancamento);
                       --,decode(pi_lista_unidade,1,a.cod_unidade,pi_grupo);
                       --,ge.cod_quebra;*/
              select cod_nivel
                     ,dta_ref
                     ,cod_grupo
                     ,cod_quebra
                     ,sum(nvl(vlr_venda,0)) vlr_venda_nivel
              from grzw_rel_descontos_lojas_nl
              where upper(des_usuario) = upper(pi_usuario)
              and seq_nivel = wNivel
              group by cod_nivel
                       ,dta_ref
                       ,cod_grupo
                      ,cod_quebra;
       r_tot_nivel c_tot_nivel%ROWTYPE;

       cursor c_tot_nivel_dta is
              /*select substr(c.cod_completo,1,wQtd_Casas) cod_nivel
                       --,decode(pi_lista_unidade,1,a.cod_unidade,pi_grupo) cod_unidade
                       ,pi_grupo cod_grupo
                       --,decode(pi_Totais,0,a.dta_lancamento,1,trunc(sysdate),a.dta_lancamento) dta_ref
                       ,sum(decode(a.tip_lancamento,2,nvl(a.vlr_presente,0),1,((nvl(a.vlr_total,0)) * -1),0)) vlr_venda_nivel_dta
                       ,ge.cod_quebra
                from ce_diarios a
                     ,ie_mascaras c
                     ,ns_itens d
                     ,t6_oper_quebras o
                     ,ne_itens e
                     ,es_0124_ce_estmedio es
                     ,ge_grupos_unidades ge
                where a.cod_item       = c.cod_item
                and c.cod_mascara    = pi_mascara
                and c.cod_completo  >= pi_codigo_ini
                and c.cod_completo  <= pi_codigo_fim
                and a.num_seq        = d.num_seq_ce(+)
                and a.cod_maquina    = d.cod_maq_ce(+)
                and a.num_seq        = e.num_seq_ce(+)
                and a.cod_maquina    = e.cod_maq_ce(+)
                and a.cod_oper       = o.cod_oper
                and o.cod_grupo_oper in (300,to_number(wOper_Devolucoes))
                and a.dta_lancamento>= pi_Dta_Ini
                and a.dta_lancamento<= pi_Dta_Fim
                and a.cod_emp        = es.cod_emp
                and a.cod_item       = es.cod_item
                and a.cod_unidade    = es.cod_unidade
                and es.dta_mvto      = to_date( '01/'||to_char(a.dta_lancamento, 'mm/yyyy'), 'dd/mm/yyyy')
                and a.cod_unidade    = ge.cod_unidade
                and ge.cod_grupo     = pi_grupo
                and ge.cod_emp    = pi_empresa
                --and ge.cod_unidade between 44 and 44
                group by substr(c.cod_completo,1,wQtd_Casas)
                         --,decode(pi_lista_unidade,1,a.cod_unidade,pi_grupo)
                         --,decode(pi_Totais,0,a.dta_lancamento,1,trunc(sysdate),a.dta_lancamento)
                         ,ge.cod_quebra;*/
              select cod_nivel
                     ,cod_grupo
                     ,cod_quebra
                     ,sum(nvl(vlr_venda,0)) vlr_venda_nivel_dta
              from grzw_rel_descontos_lojas_nl
              where upper(des_usuario) = upper(pi_usuario)
              and seq_nivel = wNivel
              group by cod_nivel,cod_grupo,cod_quebra;
       r_tot_nivel_dta c_tot_nivel_dta%rowtype;

       cursor c_tot_rede is
              /*select substr(c.cod_completo,1,wQtd_Casas) cod_nivel
                       ,pi_grupo cod_grupo
                       ,decode(pi_Totais,0,a.dta_lancamento,1,trunc(sysdate),a.dta_lancamento) dta_ref
                       ,sum(decode(a.tip_lancamento,2,nvl(a.vlr_presente,0),1,((nvl(a.vlr_total,0)) * -1),0)) vlr_venda_rede
                       --,ge.cod_quebra
              from ce_diarios a
                   ,ie_mascaras c
                   ,ns_itens d
                   ,t6_oper_quebras o
                   ,ne_itens e
                   ,es_0124_ce_estmedio es
                   ,ge_grupos_unidades ge
              where a.cod_item     = c.cod_item
              and c.cod_mascara    = pi_mascara
              and c.cod_completo   >= pi_codigo_ini
              and c.cod_completo   <= pi_codigo_fim
              and a.num_seq        = d.num_seq_ce(+)
              and a.cod_maquina    = d.cod_maq_ce(+)
              and a.num_seq        = e.num_seq_ce(+)
              and a.cod_maquina    = e.cod_maq_ce(+)
              and a.cod_oper       = o.cod_oper
              and o.cod_grupo_oper in (300,to_number(wOper_Devolucoes))
              and a.dta_lancamento >= pi_Dta_Ini
              and a.dta_lancamento <= pi_Dta_Fim
              and a.cod_emp        = es.cod_emp
              and a.cod_item       = es.cod_item
              and a.cod_unidade    = es.cod_unidade
              and es.dta_mvto      = to_date( '01/'||to_char(a.dta_lancamento, 'mm/yyyy'), 'dd/mm/yyyy')
              and a.cod_unidade    = ge.cod_unidade
              and ge.cod_grupo     = pi_grupo
              and ge.cod_emp       = pi_empresa
              --and ge.cod_unidade between 44 and 44
              group by substr(c.cod_completo,1,wQtd_Casas)
                       ,decode(pi_Totais,0,a.dta_lancamento,1,trunc(sysdate),a.dta_lancamento);
                       --,ge.cod_quebra;*/
              select cod_nivel
                     ,dta_ref
                     ,cod_grupo
                     ,sum(nvl(vlr_venda,0)) vlr_venda_rede
              from grzw_rel_descontos_lojas_nl
              where upper(des_usuario) = upper(pi_usuario)
              and seq_nivel = wNivel
              group by cod_nivel,dta_ref,cod_grupo;
       r_tot_rede c_tot_rede%rowtype;

       cursor c_tot_rede_dta is
              /*select substr(c.cod_completo,1,wQtd_Casas) cod_nivel
                       --,decode(pi_lista_unidade,1,a.cod_unidade,pi_grupo) cod_unidade
                       ,pi_grupo cod_grupo
                       --,decode(pi_Totais,0,a.dta_lancamento,1,trunc(sysdate),a.dta_lancamento) dta_ref
                       ,sum(decode(a.tip_lancamento,2,nvl(a.vlr_presente,0),1,((nvl(a.vlr_total,0)) * -1),0)) vlr_venda_rede_dta
                       --,ge.cod_quebra
              from ce_diarios a
                   ,ie_mascaras c
                   ,ns_itens d
                   ,t6_oper_quebras o
                   ,ne_itens e
                   ,es_0124_ce_estmedio es
                   ,ge_grupos_unidades ge
              where a.cod_item     = c.cod_item
              and c.cod_mascara    = pi_mascara
              and c.cod_completo  >= pi_codigo_ini
              and c.cod_completo  <= pi_codigo_fim
              and a.num_seq        = d.num_seq_ce(+)
              and a.cod_maquina    = d.cod_maq_ce(+)
              and a.num_seq        = e.num_seq_ce(+)
              and a.cod_maquina    = e.cod_maq_ce(+)
              and a.cod_oper       = o.cod_oper
              and o.cod_grupo_oper in (300,to_number(wOper_Devolucoes))
              and a.dta_lancamento>= pi_Dta_Ini
              and a.dta_lancamento<= pi_Dta_Fim
              and a.cod_emp        = es.cod_emp
              and a.cod_item       = es.cod_item
              and a.cod_unidade    = es.cod_unidade
              and es.dta_mvto      = to_date( '01/'||to_char(a.dta_lancamento, 'mm/yyyy'), 'dd/mm/yyyy')
              and a.cod_unidade    = ge.cod_unidade
              and ge.cod_grupo     = pi_grupo
              and ge.cod_emp       = pi_empresa
              --and ge.cod_unidade between 44 and 44
              group by substr(c.cod_completo,1,wQtd_Casas);
                       -- ,decode(pi_lista_unidade,1,a.cod_unidade,pi_grupo)
                       --,decode(pi_Totais,0,a.dta_lancamento,1,trunc(sysdate),a.dta_lancamento)
                       --,ge.cod_quebra;*/
              select cod_nivel
                     ,cod_grupo
                     ,sum(nvl(vlr_venda,0)) vlr_venda_rede_dta
              from grzw_rel_descontos_lojas_nl
              where upper(des_usuario) = upper(pi_usuario)
              and seq_nivel = wNivel
              group by cod_nivel
                       ,cod_grupo;
       r_tot_rede_dta c_tot_rede_dta%rowtype;

       cursor c_tot_geral is
              /*select substr(c.cod_completo,1,wQtd_Casas) cod_nivel
                       ,decode(pi_lista_unidade,1,a.cod_unidade,pi_grupo) cod_unidade
                       ,pi_grupo cod_grupo
                       ,decode(pi_Totais,0,a.dta_lancamento,1,trunc(sysdate),a.dta_lancamento) dta_ref
                       ,sum(decode(a.tip_lancamento,2,nvl(a.vlr_presente,0),1,((nvl(a.vlr_total,0)) * -1),0)) vlr_venda_geral
                       ,ge.cod_quebra
              from ce_diarios a
                   ,ie_mascaras c
                   ,ns_itens d
                   ,t6_oper_quebras o
                   ,ne_itens e
                   ,es_0124_ce_estmedio es
                   ,ge_grupos_unidades ge
              where a.cod_item       = c.cod_item
              and c.cod_mascara    = pi_mascara
              and c.cod_completo  >= pi_codigo_ini
              and c.cod_completo  <= pi_codigo_fim
              and a.num_seq        = d.num_seq_ce(+)
              and a.cod_maquina    = d.cod_maq_ce(+)
              and a.num_seq        = e.num_seq_ce(+)
              and a.cod_maquina    = e.cod_maq_ce(+)
              and a.cod_oper       = o.cod_oper
              and o.cod_grupo_oper in (300,to_number(wOper_Devolucoes))
              and a.dta_lancamento>= pi_Dta_Ini
              and a.dta_lancamento<= pi_Dta_Fim
              and a.cod_emp        = es.cod_emp
              and a.cod_item       = es.cod_item
              and a.cod_unidade    = es.cod_unidade
              and es.dta_mvto      = to_date( '01/'||to_char(a.dta_lancamento, 'mm/yyyy'), 'dd/mm/yyyy')
              and a.cod_unidade    = ge.cod_unidade
              and ge.cod_grupo     = pi_grupo
              and ge.cod_emp       = pi_empresa
              --and ge.cod_unidade between 44 and 44
              group by substr(c.cod_completo,1,wQtd_Casas)
                       ,decode(pi_lista_unidade,1,a.cod_unidade,pi_grupo)
                       ,decode(pi_Totais,0,a.dta_lancamento,1,trunc(sysdate),a.dta_lancamento)
                      ,ge.cod_quebra;*/
              select cod_nivel
                    ,dta_ref
                    ,cod_grupo
                    ,cod_quebra
                    ,cod_unidade
                    ,sum(nvl(vlr_venda,0)) vlr_venda_geral
              from grzw_rel_descontos_lojas_nl
              where upper(des_usuario) = upper(pi_usuario)
              and seq_nivel = wNivel_T
              group by cod_nivel
                       ,dta_ref
                       ,cod_grupo
                       ,cod_quebra
                       ,cod_unidade;
       r_tot_geral c_tot_geral%rowtype;

       cursor c_tot_geral_grupo is
		 /*   select substr(c.cod_completo,1,wQtd_Casas) cod_nivel
		     -- ,decode(pi_lista_unidade,1,a.cod_unidade,pi_grupo) cod_unidade
              ,pi_grupo cod_grupo
              ,decode(pi_Totais,0,a.dta_lancamento,1,trunc(sysdate),a.dta_lancamento) dta_ref
              ,sum(decode(a.tip_lancamento,2,nvl(a.vlr_presente,0),1,((nvl(a.vlr_total,0)) * -1),0)) vlr_venda_geral_grupo
              ,ge.cod_quebra
          from ce_diarios a
              ,ie_mascaras c
              ,ns_itens d
              ,t6_oper_quebras o
              ,ne_itens e
              ,es_0124_ce_estmedio es
              ,ge_grupos_unidades ge
         where a.cod_item       = c.cod_item
           and c.cod_mascara    = pi_mascara
	   and c.cod_completo  >= pi_codigo_ini
	   and c.cod_completo  <= pi_codigo_fim
	   and a.num_seq        = d.num_seq_ce(+)
	   and a.cod_maquina    = d.cod_maq_ce(+)
	   and a.num_seq        = e.num_seq_ce(+)
	   and a.cod_maquina    = e.cod_maq_ce(+)
           and a.cod_oper       = o.cod_oper
           and o.cod_grupo_oper in (300,to_number(wOper_Devolucoes))
           and a.dta_lancamento>= pi_Dta_Ini
           and a.dta_lancamento<= pi_Dta_Fim
           and a.cod_emp        = es.cod_emp
           and a.cod_item       = es.cod_item
           and a.cod_unidade    = es.cod_unidade
           and es.dta_mvto      = to_date( '01/'||to_char(a.dta_lancamento, 'mm/yyyy'), 'dd/mm/yyyy')
           and a.cod_unidade = ge.cod_unidade
                          and ge.cod_grupo  = pi_grupo
                          and ge.cod_emp    = pi_empresa
                   --       and ge.cod_unidade between 44 and 44
         group by substr(c.cod_completo,1,wQtd_Casas)
		         --,decode(pi_lista_unidade,1,a.cod_unidade,pi_grupo)
                 ,decode(pi_Totais,0,a.dta_lancamento,1,trunc(sysdate),a.dta_lancamento)
                 ,ge.cod_quebra;
				 */


        select cod_nivel
              ,dta_ref
              ,cod_grupo
              ,cod_quebra
              ,sum(nvl(vlr_venda,0)) vlr_venda_geral_grupo
          from grzw_rel_descontos_lojas_nl
         where upper(des_usuario) = upper(pi_usuario)
           and seq_nivel = wNivel_T
         group by cod_nivel
                 ,dta_ref
                 ,cod_grupo
                 ,cod_quebra;

        r_tot_geral_grupo c_tot_geral_grupo%ROWTYPE;


        CURSOR c_tot_geral_dta is
		  /*  select substr(c.cod_completo,1,wQtd_Casas) cod_nivel
		      ,decode(pi_lista_unidade,1,a.cod_unidade,pi_grupo) cod_unidade
              ,pi_grupo cod_grupo
            --  ,decode(pi_Totais,0,a.dta_lancamento,1,trunc(sysdate),a.dta_lancamento) dta_ref
              ,sum(decode(a.tip_lancamento,2,nvl(a.vlr_presente,0),1,((nvl(a.vlr_total,0)) * -1),0)) vlr_venda_geral_dta
              ,ge.cod_quebra
          from ce_diarios a
              ,ie_mascaras c
              ,ns_itens d
              ,t6_oper_quebras o
              ,ne_itens e
              ,es_0124_ce_estmedio es
              ,ge_grupos_unidades ge
         where a.cod_item       = c.cod_item
           and c.cod_mascara    = pi_mascara
	   and c.cod_completo  >= pi_codigo_ini
	   and c.cod_completo  <= pi_codigo_fim
	   and a.num_seq        = d.num_seq_ce(+)
	   and a.cod_maquina    = d.cod_maq_ce(+)
	   and a.num_seq        = e.num_seq_ce(+)
	   and a.cod_maquina    = e.cod_maq_ce(+)
           and a.cod_oper       = o.cod_oper
           and o.cod_grupo_oper in (300,to_number(wOper_Devolucoes))
           and a.dta_lancamento>= pi_Dta_Ini
           and a.dta_lancamento<= pi_Dta_Fim
           and a.cod_emp        = es.cod_emp
           and a.cod_item       = es.cod_item
           and a.cod_unidade    = es.cod_unidade
           and es.dta_mvto      = to_date( '01/'||to_char(a.dta_lancamento, 'mm/yyyy'), 'dd/mm/yyyy')
           and a.cod_unidade = ge.cod_unidade
                          and ge.cod_grupo  = pi_grupo
                          and ge.cod_emp    = pi_empresa
                   --       and ge.cod_unidade between 44 and 44
         group by substr(c.cod_completo,1,wQtd_Casas)
		         ,decode(pi_lista_unidade,1,a.cod_unidade,pi_grupo)
                -- ,decode(pi_Totais,0,a.dta_lancamento,1,trunc(sysdate),a.dta_lancamento)
                 ,ge.cod_quebra;
				 */


        select cod_nivel
              ,cod_grupo
              ,cod_quebra
              ,cod_unidade
              ,sum(nvl(vlr_venda,0)) vlr_venda_geral_dta
          from grzw_rel_descontos_lojas_nl
         where upper(des_usuario) = upper(pi_usuario)
           and seq_nivel = wNivel_T
         group by cod_nivel
                 ,cod_grupo
                 ,cod_quebra
                 ,cod_unidade;
        r_tot_geral_dta c_tot_geral_dta%ROWTYPE;


        CURSOR c_tot_geral_grupo_dta is
		  /* select substr(c.cod_completo,1,wQtd_Casas) cod_nivel
		     -- ,decode(pi_lista_unidade,1,a.cod_unidade,pi_grupo) cod_unidade
              ,pi_grupo cod_grupo
            --  ,decode(pi_Totais,0,a.dta_lancamento,1,trunc(sysdate),a.dta_lancamento) dta_ref
              ,sum(decode(a.tip_lancamento,2,nvl(a.vlr_presente,0),1,((nvl(a.vlr_total,0)) * -1),0)) vlr_venda_geral_grupo_dta
              ,ge.cod_quebra
          from ce_diarios a
              ,ie_mascaras c
              ,ns_itens d
              ,t6_oper_quebras o
              ,ne_itens e
              ,es_0124_ce_estmedio es
              ,ge_grupos_unidades ge
         where a.cod_item       = c.cod_item
           and c.cod_mascara    = pi_mascara
	   and c.cod_completo  >= pi_codigo_ini
	   and c.cod_completo  <= pi_codigo_fim
	   and a.num_seq        = d.num_seq_ce(+)
	   and a.cod_maquina    = d.cod_maq_ce(+)
	   and a.num_seq        = e.num_seq_ce(+)
	   and a.cod_maquina    = e.cod_maq_ce(+)
           and a.cod_oper       = o.cod_oper
           and o.cod_grupo_oper in (300,to_number(wOper_Devolucoes))
           and a.dta_lancamento>= pi_Dta_Ini
           and a.dta_lancamento<= pi_Dta_Fim
           and a.cod_emp        = es.cod_emp
           and a.cod_item       = es.cod_item
           and a.cod_unidade    = es.cod_unidade
           and es.dta_mvto      = to_date( '01/'||to_char(a.dta_lancamento, 'mm/yyyy'), 'dd/mm/yyyy')
           and a.cod_unidade = ge.cod_unidade
                          and ge.cod_grupo  = pi_grupo
                          and ge.cod_emp    = pi_empresa
                   --       and ge.cod_unidade between 44 and 44
         group by substr(c.cod_completo,1,wQtd_Casas)
		       --  ,decode(pi_lista_unidade,1,a.cod_unidade,pi_grupo)
               --  ,decode(pi_Totais,0,a.dta_lancamento,1,trunc(sysdate),a.dta_lancamento)
                 ,ge.cod_quebra;
		*/



        select cod_nivel
              ,cod_grupo
              ,cod_quebra
              ,sum(nvl(vlr_venda,0)) vlr_venda_geral_grupo_dta
          from grzw_rel_descontos_lojas_nl
         where upper(des_usuario) = upper(pi_usuario)
           and seq_nivel = wNivel_T
         group by cod_nivel
                 ,cod_grupo
                 ,cod_quebra;
        r_tot_geral_grupo_dta c_tot_geral_grupo_dta%ROWTYPE;


        CURSOR c_tot_geral_total is
		  /*  select substr(c.cod_completo,1,wQtd_Casas) cod_nivel
		     -- ,decode(pi_lista_unidade,1,a.cod_unidade,pi_grupo) cod_unidade
              ,pi_grupo cod_grupo
             -- ,decode(pi_Totais,0,a.dta_lancamento,1,trunc(sysdate),a.dta_lancamento) dta_ref
              ,sum(decode(a.tip_lancamento,2,nvl(a.vlr_presente,0),1,((nvl(a.vlr_total,0)) * -1),0)) vlr_venda_geral_total
             -- ,ge.cod_quebra
          from ce_diarios a
              ,ie_mascaras c
              ,ns_itens d
              ,t6_oper_quebras o
              ,ne_itens e
              ,es_0124_ce_estmedio es
              ,ge_grupos_unidades ge
         where a.cod_item       = c.cod_item
           and c.cod_mascara    = pi_mascara
	   and c.cod_completo  >= pi_codigo_ini
	   and c.cod_completo  <= pi_codigo_fim
	   and a.num_seq        = d.num_seq_ce(+)
	   and a.cod_maquina    = d.cod_maq_ce(+)
	   and a.num_seq        = e.num_seq_ce(+)
	   and a.cod_maquina    = e.cod_maq_ce(+)
           and a.cod_oper       = o.cod_oper
           and o.cod_grupo_oper in (300,to_number(wOper_Devolucoes))
           and a.dta_lancamento>= pi_Dta_Ini
           and a.dta_lancamento<= pi_Dta_Fim
           and a.cod_emp        = es.cod_emp
           and a.cod_item       = es.cod_item
           and a.cod_unidade    = es.cod_unidade
           and es.dta_mvto      = to_date( '01/'||to_char(a.dta_lancamento, 'mm/yyyy'), 'dd/mm/yyyy')
           and a.cod_unidade = ge.cod_unidade
                          and ge.cod_grupo  = pi_grupo
                          and ge.cod_emp    = pi_empresa
                   --       and ge.cod_unidade between 44 and 44
         group by substr(c.cod_completo,1,wQtd_Casas);
		        -- ,decode(pi_lista_unidade,1,a.cod_unidade,pi_grupo)
                -- ,decode(pi_Totais,0,a.dta_lancamento,1,trunc(sysdate),a.dta_lancamento)
                -- ,ge.cod_quebra;
		*/

        select cod_nivel
              ,cod_grupo
              ,sum(nvl(vlr_venda,0)) vlr_venda_geral_total
          from grzw_rel_descontos_lojas_nl
         where upper(des_usuario) = upper(pi_usuario)
           and seq_nivel = wNivel_T
         group by cod_nivel
                 ,cod_grupo;
        r_tot_geral_total c_tot_geral_total%ROWTYPE;


			CURSOR c_tot_total is
			 /*  select substr(c.cod_completo,1,wQtd_Casas) cod_nivel
		     -- ,decode(pi_lista_unidade,1,a.cod_unidade,pi_grupo) cod_unidade
              ,pi_grupo cod_grupo
            --  ,decode(pi_Totais,0,a.dta_lancamento,1,trunc(sysdate),a.dta_lancamento) dta_ref
              ,sum(decode(a.tip_lancamento,2,nvl(a.vlr_presente,0),1,((nvl(a.vlr_total,0)) * -1),0)) vlr_venda_total
            --  ,ge.cod_quebra
          from ce_diarios a
              ,ie_mascaras c
              ,ns_itens d
              ,t6_oper_quebras o
              ,ne_itens e
              ,es_0124_ce_estmedio es
              ,ge_grupos_unidades ge
         where a.cod_item       = c.cod_item
           and c.cod_mascara    = pi_mascara
	   and c.cod_completo  >= pi_codigo_ini
	   and c.cod_completo  <= pi_codigo_fim
	   and a.num_seq        = d.num_seq_ce(+)
	   and a.cod_maquina    = d.cod_maq_ce(+)
	   and a.num_seq        = e.num_seq_ce(+)
	   and a.cod_maquina    = e.cod_maq_ce(+)
           and a.cod_oper       = o.cod_oper
           and o.cod_grupo_oper in (300,to_number(wOper_Devolucoes))
           and a.dta_lancamento>= pi_Dta_Ini
           and a.dta_lancamento<= pi_Dta_Fim
           and a.cod_emp        = es.cod_emp
           and a.cod_item       = es.cod_item
           and a.cod_unidade    = es.cod_unidade
           and es.dta_mvto      = to_date( '01/'||to_char(a.dta_lancamento, 'mm/yyyy'), 'dd/mm/yyyy')
           and a.cod_unidade = ge.cod_unidade
                          and ge.cod_grupo  = pi_grupo
                          and ge.cod_emp    = pi_empresa
                   --       and ge.cod_unidade between 44 and 44
         group by substr(c.cod_completo,1,wQtd_Casas);
		        -- ,decode(pi_lista_unidade,1,a.cod_unidade,pi_grupo)
                -- ,decode(pi_Totais,0,a.dta_lancamento,1,trunc(sysdate),a.dta_lancamento)
                -- ,ge.cod_quebra;
				*/

			select cod_nivel
				  ,cod_grupo
				  ,sum(nvl(vlr_venda,0)) vlr_venda_total
			  from grzw_rel_descontos_lojas_nl
			 where upper(des_usuario) = upper(pi_usuario)
			   and seq_nivel = wNivel_T
			 group by cod_nivel
					 ,cod_grupo;
			r_tot_total c_tot_total%ROWTYPE;



        CURSOR c_part is
        select cod_nivel
              ,dta_ref
              ,seq_nivel
              ,cod_grupo
              ,cod_quebra
              ,cod_unidade
              ,nvl(qtd_venda,0) qtd_venda
              ,nvl(vlr_venda,0) vlr_venda
              ,nvl(vlr_venda_liq,0) vlr_venda_liq
              ,nvl(qtd_tot_venda_nivel,0) qtd_tot_venda_nivel
              ,nvl(vlr_tot_venda_nivel,0) vlr_tot_venda_nivel
              ,nvl(vlr_tot_venda_liq_nivel,0) vlr_tot_venda_liq_nivel
              ,nvl(qtd_tot_venda_rede,0) qtd_tot_venda_rede
              ,nvl(vlr_tot_venda_rede,0) vlr_tot_venda_rede
              ,nvl(vlr_tot_venda_liq_rede,0) vlr_tot_venda_liq_rede
              ,nvl(qtd_tot_venda_geral,0) qtd_tot_venda_geral
              ,nvl(vlr_tot_venda_geral,0) vlr_tot_venda_geral
              ,nvl(vlr_tot_venda_liq_geral,0) vlr_tot_venda_liq_geral
          from grzw_rel_descontos_lojas_nl
         where upper(des_usuario) = upper(pi_usuario);
        r_part c_part%ROWTYPE;

           /*1#910#20/03/2016#20/03/2016#20/03/2015#20/03/2015#150#10#00#99#3#0#0#1#385882#*/
           BEGIN
                v_cur := dbms_sql.open_cursor;
                dbms_sql.parse(v_cur,'alter session set nls_date_format= "dd/mm/rrrr"',dbms_sql.native);
                v_result := dbms_sql.execute(v_cur);
                dbms_sql.close_cursor(v_cur);

                v_cur := dbms_sql.open_cursor;
                dbms_sql.parse(v_cur,'alter session set NLS_NUMERIC_CHARACTERS = '',.''',dbms_sql.native);
                v_result := dbms_sql.execute(v_cur);
                dbms_sql.close_cursor(v_cur);

	       wi := INSTR(pi_opcao, '#', 1, 1);
	       pi_empresa := TO_NUMBER(SUBSTR(pi_opcao, 1,(wi-1)));
	       wf := INSTR(pi_opcao, '#', 1, 2);
   	       pi_grupo := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	       wi := wf;
	       wf := INSTR(pi_opcao, '#', 1, 3);
	       pi_dta_ini := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));
	       wi := wf;
	       wf := INSTR(pi_opcao, '#', 1, 4);
   	       pi_dta_fim := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));
	       wi := wf;
	       wf := INSTR(pi_opcao, '#', 1, 5);
	       pi_dta_comp_ini := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));
	       wi := wf;
	       wf := INSTR(pi_opcao, '#', 1, 6);
   	       pi_dta_comp_fim := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));
	       wi := wf;
	       wf := INSTR(pi_opcao, '#', 1, 7);
   	       pi_mascara := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	       wi := wf;
	       wf := INSTR(pi_opcao, '#', 1, 8);
	       pi_rede := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));
	       wi := wf;
	       wf := INSTR(pi_opcao, '#', 1, 9);
   	       pi_codigo_ini := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));
	       wi := wf;
	       wf := INSTR(pi_opcao, '#', 1, 10);
   	       pi_codigo_fim := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));
   	       wi := wf;
	       wf := INSTR(pi_opcao, '#', 1, 11);
	       pi_nivel_mascara := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
   	       wi := wf;
	       wf := INSTR(pi_opcao, '#', 1, 12);
	       pi_lista_unidade := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
   	       wi := wf;
	       wf := INSTR(pi_opcao, '#', 1, 13);
	       pi_Desc_Devolucao := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	       wi := wf;
	       wf := INSTR(pi_opcao, '#', 1, 14);
	       pi_Totais := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
   	       wi := wf;
	       wf := INSTR(pi_opcao, '#', 1, 15);
   	       pi_usuario := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));
		   wi := wf;
	       wf := INSTR(pi_opcao, '#', 1, 16);
	       pi_unidade_ini := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
		   wi := wf;
	       wf := INSTR(pi_opcao, '#', 1, 17);
	       pi_unidade_fim := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));



   	       /**** Limpa a tabela temporaria ****/
	       DELETE FROM GRZW_REL_DESCONTOS_LOJAS_NL
	       WHERE upper(Des_Usuario) = upper(pi_Usuario);
	       COMMIT;

 		Begin
     	            select des_grupo
     	       	      into wDes_Grupo
		      from ge_grupos
		     Where cod_emp = pi_empresa
		       and cod_grupo = pi_grupo;
      	           EXCEPTION
		      WHEN NO_DATA_FOUND THEN
                       	wDes_Grupo := 'GRUPO DE UNIDADES NAO CADASTRADO';
		end;

	      /****  1=REDE   2=SETOR   3=GRUPO   4=SUBGRUPO 5=ITEM  ****/
		if (pi_nivel_mascara = 1) then
			wQtd_Casas  := 2;
			wQtd_Casas1 := 2;
			wQtd_Casas2 := 0;
		elsif (pi_nivel_mascara = 2) then
			wQtd_Casas  := 4;
			wQtd_Casas1 := 5;
			wQtd_Casas2 := 2;
		elsif (pi_nivel_mascara = 3) then
			wQtd_Casas  := 6;
			wQtd_Casas1 := 8;
			wQtd_Casas2 := 4;
        elsif (pi_nivel_mascara = 4) then
			wQtd_Casas  := 8;
			wQtd_Casas1 := 11;
			wQtd_Casas2 := 6;
			else
			wQtd_Casas  := 11;
			wQtd_Casas1 := 15;
			wQtd_Casas2 := 8;

		end if;

		wOper_Devolucoes := '';

		if (pi_Desc_Devolucao = 1) then
	            wOper_Devolucoes := '7106';
	    end if;

	        wCompleto_Ant := '00';

	       open c_itens;
               fetch c_itens into r_itens;
               while c_itens%found loop
               begin


 	       	    wCompleto := substr(r_itens.COD_COMPLETO,1,wQtd_Casas);
 	       	    wEditado  := substr(r_itens.COD_EDITADO,1,wQtd_Casas1);

		    if (wCompleto <> wCompleto_Ant) then
		        if (pi_nivel_mascara = 1) then
 	       	            wCod_Anteriores := '0';
 	       	            wCod_Nivel      := substr(r_itens.COD_COMPLETO,1,2);
		        else
 	       	            wCod_Anteriores := substr(r_itens.COD_COMPLETO,1,wQtd_Casas2);
 	       	            wCod_Nivel      := substr(r_itens.COD_COMPLETO,(wQtd_Casas2 + 1),2);
		        end if;

		        if (pi_nivel_mascara = 5) then
		        BEGIN
 		            select nvl(a.des_item,'X') des_nivel
		              into wDes_nivel
		              from ie_itens a, ie_mascaras b
                             where a.cod_item = b.cod_item
                               and a.cod_gu = 1
                               and b.cod_mascara = pi_mascara
                               and b.cod_completo = r_itens.COD_COMPLETO;
		      	     EXCEPTION
			      	  WHEN NO_DATA_FOUND THEN
			       	   	wDes_nivel := 'SEM DESCRICAO';
		        end;
                        else
     	       	        begin
     	       	            select nvl(des_nivel,'X') des_nivel
     	       	     	      into wDes_nivel
			      from g3_niveis_cadastro
		             Where cod_mascara = pi_mascara
			       and cod_formato = '1'
			       and seq_nivel   = pi_nivel_mascara
      			       and cod_anteriores = wCod_Anteriores
      			       and cod_nivel = wCod_Nivel;
      			    EXCEPTION
			         WHEN NO_DATA_FOUND THEN
			              wDes_nivel := 'SEM DESCRICAO';

      	      	        end;
      	      	        end if;

		        wCompleto_Ant := wCompleto;
		    end if;

		   if pi_lista_unidade = 1 then
 		        Begin
     	       		   select des_fantasia
     	       		     into wDes_Unidade
			     from ps_pessoas
			    Where cod_pessoa = r_itens.cod_unidade;
      	         	  EXCEPTION
		             WHEN NO_DATA_FOUND THEN
                        	wDes_Unidade := 'UNIDADE NAO CADASTRADA';
		        end;

 		        Begin
     	       		   select a.cod_quebra
     	       		         ,b.des_quebra
     	       		     into wCod_Quebra
     	       		         ,wDes_Quebra
			     from ge_grupos_unidades a
			         ,ge_grupos_quebra b
			    Where a.cod_emp = b.cod_emp
			      and a.cod_grupo = b.cod_grupo
			      and a.cod_quebra = b.cod_quebra
			      and a.cod_unidade = r_itens.cod_unidade
			      and a.cod_grupo = pi_grupo
			      and a.cod_emp = pi_empresa;
      	         	  EXCEPTION
		             WHEN NO_DATA_FOUND THEN
                        	wCod_Quebra := 0;
                        	wDes_Quebra := 'DESCRICAO QUEBRA NAO CADASTRADA';
		        end;
                    else
		        wCod_Quebra  := 0;
		        wDes_Quebra  := '';
		        wDes_Unidade := '';
                    end if;

               /* REV comentado pois n¿o precisara colocar neste relatorio
                   if ((pi_lista_unidade = 1) and (pi_nivel_mascara = 1)) then
                    begin
                    	select sum(nvl(es.VLR_ESTOQUE_ANT,0)) vlr_est_ant
                              ,sum(nvl(es.VLR_MEDIO_EMP,0)) vlr_medio_emp
                              ,sum(nvl(es.vlr_custo,0)) vlr_custo_rev
                          Into wVLR_ESTOQUE_ANT
                              ,wVLR_MEDIO_EMP
                              ,wVLR_CUSTO_REV
                          from ie_mascaras c
                              ,es_0124_ce_estmedio es
                         where es.cod_item      = c.cod_item
                           and c.cod_mascara    = pi_mascara
	                   and c.cod_completo  >= pi_codigo_ini
	                   and c.cod_completo  <= pi_codigo_fim
                           and es.cod_unidade   = r_itens.cod_unidade
                           and es.dta_mvto      = to_date( '01/'||substr(pi_Dta_Ini,4,7) , 'dd/mm/yyyy');
                     EXCEPTION
		          WHEN NO_DATA_FOUND THEN
                               wVLR_ESTOQUE_ANT := 0;
                               wVLR_MEDIO_EMP   := 0;
                               wVLR_CUSTO_REV   := 0;
                    end;
                   elsif (pi_lista_unidade = 1) then
                    begin
                    	select sum(nvl(es.VLR_ESTOQUE_ANT,0)) vlr_est_ant
                              ,sum(nvl(es.VLR_MEDIO_EMP,0)) vlr_medio_emp
                              ,sum(nvl(es.vlr_custo,0)) vlr_custo_rev
                          Into wVLR_ESTOQUE_ANT
                              ,wVLR_MEDIO_EMP
                              ,wVLR_CUSTO_REV
                          from ie_mascaras c
                              ,es_0124_ce_estmedio es
                         where es.cod_item      = c.cod_item
                           and c.cod_mascara    = pi_mascara
	                   and c.cod_completo  >= to_char(rpad(r_itens.COD_COMPLETO,11,'0'))
	                   and c.cod_completo  <= to_char(rpad(r_itens.COD_COMPLETO,11,'9'))
                           and es.cod_unidade   = r_itens.cod_unidade
                           and es.dta_mvto      = to_date( '01/'||substr(pi_Dta_Ini,4,7) , 'dd/mm/yyyy');
                     EXCEPTION
		          WHEN NO_DATA_FOUND THEN
                               wVLR_ESTOQUE_ANT := 0;
                               wVLR_MEDIO_EMP   := 0;
                               wVLR_CUSTO_REV   := 0;
                    end;
                   end if; */

        	    wVlr_Venda_Liq := nvl(r_itens.vlr_venda,0) - nvl(r_itens.vlr_icms,0) - nvl(r_itens.vlr_pis,0) - nvl(r_itens.vlr_cofins,0);
		    if nvl(wVlr_Venda_Liq,0) > 0 then
        	        wMargem := Round(((nvl(wVlr_Venda_Liq,0) -
      			           nvl(r_itens.Vlr_Custo,0)) /
                  	           nvl(wVlr_Venda_Liq,0) * 100),1);
                    else
		         wMargem := 0;
		    end if;

                    insert into GRZW_REL_DESCONTOS_LOJAS_NL(DES_USUARIO
                   	                                 ,COD_NIVEL
                   	                                 ,DTA_REF
                   	                                 ,SEQ_NIVEL
                   	                                 ,COD_GRUPO
                   	                                 ,COD_QUEBRA
                   	                                 ,COD_UNIDADE
                   	                                 ,VLR_VENDA
                   	                                 ,VLR_VENDA_LIQ
                   	                                 ,VLR_CUSTO
                   	                                 ,VLR_IMPRESSO_VDA
                   	                                 ,VLR_VENDA_TOTAL
                   	                                 ,VLR_VENDA_LISTA
                   	                                 ,VLR_DESCONTO
                   	                                 ,VLR_DCTO_PRECO
                   	                                 ,VLR_DCTO_TOTAL
                   	                                 ,PER_DESCONTO
                   	                                 ,PER_DCTO_PRECO
                   	                                 ,PER_DCTO_TOTAL
                   	                                 ,VLR_DEVOLUCAO
                   	                                 ,PER_DEVOLUCAO
                   	                                 ,VLR_INVENTARIO
                   	                                 ,PER_INVENTARIO
                   	                                 ,QTD_VENDA
                   	                                 ,QTD_DEVOLUCAO
                   	                                 ,QTD_INVENTARIO
                   	                                 ,COD_EDITADO
                   	                                 ,DES_NIVEL
                   	                                 ,DES_GRUPO
                   	                                 ,DES_QUEBRA
                   	                                 ,DES_UNIDADE
                   	                                 ,VLR_VENDA_SALDO
							)
						values (pi_usuario
                                                  	,wCompleto
                                                  	,r_itens.dta_lancamento
                                                  	,pi_nivel_mascara
                                                  	,pi_grupo
                                                  	,wCod_Quebra
                                                  	,r_itens.cod_unidade
                                                  	,nvl(r_itens.vlr_venda,0)
                                                  	,wVlr_Venda_Liq
                                                  	,nvl(r_itens.vlr_custo,0)
                                                  	,0
                                                  	,0
                                                  	,0
                                                  	,0
                                                  	,0
                                                  	,0
                                                  	,wMargem
                                                  	,0
                                                  	,0
                                                  	,0
                                                  	,0
                                                  	,0
                                                  	,0
                                                  	,nvl(r_itens.qtd_venda,0)
                                                  	,0
                                                  	,0
                                                  	,wEditado
                                                  	,wDes_nivel
                                                  	,wDes_Grupo
                                                  	,wDes_Quebra
                                                  	,wDes_Unidade
                                                  	,nvl(r_itens.vlr_venda_saldo,0)
                                                  	);
        	end;
        	fetch c_itens into r_itens;
        	end loop;
        	close c_itens;
        	commit;


	       wSeq_Nivel := pi_nivel_mascara;
	       wNivel     := pi_nivel_mascara - 1;
	       while wNivel > 0 loop
	       begin
		    if (wNivel = 1) then
			wQtd_Casas  := 2;
			wQtd_Casas1 := 2;
			wQtd_Casas2 := 0;
		    elsif (wNivel = 2) then
			wQtd_Casas  := 4;
			wQtd_Casas1 := 5;
			wQtd_Casas2 := 2;
		    elsif (wNivel = 3) then
			wQtd_Casas  := 6;
			wQtd_Casas1 := 8;
			wQtd_Casas2 := 4;
			elsif (wNivel = 4) then
			wQtd_Casas  := 8;
			wQtd_Casas1 := 11;
			wQtd_Casas2 := 6;
			else
			wQtd_Casas  := 11;
			wQtd_Casas1 := 15;
			wQtd_Casas2 := 8;

			end if;

	            open c_niveis;
                    fetch c_niveis into r_niveis;
                    while c_niveis%found loop
                    begin
		         if (wNivel = 1) then
 	       	             wCod_Anteriores := '0';
 	       	             wCod_Nivel      := substr(r_niveis.COD_NIVEL,1,2);
		         else
 	       	             wCod_Anteriores := substr(r_niveis.COD_NIVEL,1,wQtd_Casas2);
 	       	             wCod_Nivel      := substr(r_niveis.COD_NIVEL,(wQtd_Casas2 + 1),2);
		         end if;
 		         Begin
     	       		      select nvl(des_nivel,'X') des_nivel
     	       		        into wDes_nivel
			        from g3_niveis_cadastro
			       Where cod_mascara = pi_mascara
			         and cod_formato = '1'
			         and seq_nivel   = wNivel
      			         and cod_anteriores = wCod_Anteriores
      			         and cod_nivel = wCod_Nivel;
      	         	   EXCEPTION
		                WHEN NO_DATA_FOUND THEN
						BEGIN
						select nvl(a.des_item,'X') des_nivel
							into wDes_nivel
					from ie_itens a, ie_mascaras b
                    where a.cod_item = b.cod_item
					   and a.cod_gu = 1
                       and b.cod_mascara = pi_mascara
                       and b.cod_completo = r_itens.COD_COMPLETO;
                   EXCEPTION
               WHEN NO_DATA_FOUND THEN
                         wDes_nivel := 'SEM DESCRICAO';
						END;

				end;



        	    wVlr_Venda_Liq := nvl(r_niveis.vlr_venda_liq,0);
		    if nvl(wVlr_Venda_Liq,0) > 0 then
        	        wMargem := Round(((nvl(wVlr_Venda_Liq,0) -
      			           nvl(r_niveis.Vlr_Custo,0)) /
                  	           nvl(wVlr_Venda_Liq,0) * 100),1);
                    else
		         wMargem := 0;
		    end if;

                    insert into GRZW_REL_DESCONTOS_LOJAS_NL(DES_USUARIO
                   	                                 ,COD_NIVEL
                   	                                 ,DTA_REF
                   	                                 ,SEQ_NIVEL
                   	                                 ,COD_GRUPO
                   	                                 ,COD_QUEBRA
                   	                                 ,COD_UNIDADE
                   	                                 ,VLR_VENDA
                   	                                 ,VLR_VENDA_LIQ
                   	                                 ,VLR_CUSTO
                   	                                 ,VLR_IMPRESSO_VDA
                   	                                 ,VLR_VENDA_TOTAL
                   	                                 ,VLR_VENDA_LISTA
                   	                                 ,VLR_DESCONTO
                   	                                 ,VLR_DCTO_PRECO
                   	                                 ,VLR_DCTO_TOTAL
                   	                                 ,PER_DESCONTO
                   	                                 ,PER_DCTO_PRECO
                   	                                 ,PER_DCTO_TOTAL
                   	                                 ,VLR_DEVOLUCAO
                   	                                 ,PER_DEVOLUCAO
                   	                                 ,VLR_INVENTARIO
                   	                                 ,PER_INVENTARIO
                   	                                 ,QTD_VENDA
                   	                                 ,QTD_DEVOLUCAO
                   	                                 ,QTD_INVENTARIO
                   	                                 ,COD_EDITADO
                   	                                 ,DES_NIVEL
                   	                                 ,DES_GRUPO
                   	                                 ,DES_QUEBRA
                   	                                 ,DES_UNIDADE
                   	                                 ,VLR_VENDA_SALDO
							)
						values (pi_usuario
                                                  	,r_niveis.COD_NIVEL
                                                  	,r_niveis.dta_ref
                                                  	,wNivel
                                                  	,r_niveis.cod_grupo
                                                  	,r_niveis.cod_quebra
                                                  	,r_niveis.cod_unidade
                                                  	,r_niveis.vlr_venda
                                                  	,r_niveis.vlr_venda_liq
                                                  	,r_niveis.vlr_custo
                                                  	,0
                                                  	,0
                                                  	,0
                                                  	,r_niveis.vlr_desconto
                                                  	,0
                                                  	,0
                                                  	,wMargem
                                                  	,0
                                                  	,0
                                                  	,0
                                                  	,0
                                                  	,0
                                                  	,0
                                                  	,r_niveis.qtd_venda
                                                  	,0
                                                  	,0
                                                  	,r_niveis.cod_editado
                                                  	,wDes_nivel
                                                  	,r_niveis.des_grupo
                                                  	,r_niveis.des_quebra
                                                  	,r_niveis.des_unidade
                                                  	,r_niveis.vlr_venda_saldo
                                                  	);
                    end;
                    fetch c_niveis into r_niveis;
                    end loop;
                    close c_niveis;
                    commit;

		    wSeq_Nivel := wSeq_Nivel - 1;
		    wNivel     := wNivel - 1;
               end;
               end loop;
               commit;

               wNivel := pi_nivel_mascara;
               while wNivel > 0 loop
               begin
	            open c_tot_nivel;
                    fetch c_tot_nivel into r_tot_nivel;
                    while c_tot_nivel%found loop
                    begin
               	        begin
                            update grzw_rel_descontos_lojas_nl a
                               set vlr_tot_venda_nivel = r_tot_nivel.vlr_venda_nivel
                             where upper(des_usuario) = upper(pi_usuario)
                               and cod_nivel = r_tot_nivel.cod_nivel
                               and dta_ref = r_tot_nivel.dta_ref
                               and seq_nivel = wNivel
                               and cod_grupo = r_tot_nivel.cod_grupo;
                              -- and cod_quebra = r_tot_nivel.cod_quebra;
               	        end;
                    end;
                    fetch c_tot_nivel into r_tot_nivel;
                    end loop;
                    close c_tot_nivel;
                    commit;

	            open c_tot_nivel_dta;
                    fetch c_tot_nivel_dta into r_tot_nivel_dta;
                    while c_tot_nivel_dta%found loop
                    begin
               	        begin
                            update grzw_rel_descontos_lojas_nl a
                               set vlr_tot_venda_nivel_dta = r_tot_nivel_dta.vlr_venda_nivel_dta
                             where upper(des_usuario) = upper(pi_usuario)
                               and cod_nivel = r_tot_nivel_dta.cod_nivel
                               and seq_nivel = wNivel
                               and cod_grupo = r_tot_nivel_dta.cod_grupo
                               and cod_quebra = r_tot_nivel_dta.cod_quebra;
               	        end;
                    end;
                    fetch c_tot_nivel_dta into r_tot_nivel_dta;
                    end loop;
                    close c_tot_nivel_dta;
                    commit;

	            open c_tot_rede;
                    fetch c_tot_rede into r_tot_rede;
                    while c_tot_rede%found loop
                    begin
               	       begin
                           update grzw_rel_descontos_lojas_nl a
                              set vlr_tot_venda_rede = r_tot_rede.vlr_venda_rede
                            where upper(des_usuario) = upper(pi_usuario)
                              and cod_nivel = r_tot_rede.cod_nivel
                              and dta_ref = r_tot_rede.dta_ref
                              and seq_nivel = wNivel
                              and cod_grupo = r_tot_rede.cod_grupo;
               	       end;
                    end;
                    fetch c_tot_rede into r_tot_rede;
                    end loop;
                    close c_tot_rede;
                    commit;

	            open c_tot_rede_dta;
                    fetch c_tot_rede_dta into r_tot_rede_dta;
                    while c_tot_rede_dta%found loop
                    begin
               	       begin
                           update grzw_rel_descontos_lojas_nl a
                              set vlr_tot_venda_rede_dta = r_tot_rede_dta.vlr_venda_rede_dta
                            where upper(des_usuario) = upper(pi_usuario)
                              and cod_nivel = r_tot_rede_dta.cod_nivel
                              and seq_nivel = wNivel
                              and cod_grupo = r_tot_rede_dta.cod_grupo;
               	       end;
                    end;
                    fetch c_tot_rede_dta into r_tot_rede_dta;
                    end loop;
                    close c_tot_rede_dta;
                    commit;


                    wNivel_T := wNivel - 1;
                    if (wNivel_T = 0) then
                    	wNivel_T := 1;
                    end if;

		    if (wNivel_T = 1) then
			wQtd_Casas  := 2;
		    elsif (wNivel_T = 2) then
		        wQtd_Casas  := 4;
		    elsif (wNivel_T = 3) then
		        wQtd_Casas  := 6;
            elsif (wNivel_T = 4) then
		        wQtd_Casas  := 8;
				else
				wQtd_Casas  := 11;
		    end if;

	            open c_tot_geral;
                    fetch c_tot_geral into r_tot_geral;
                    while c_tot_geral%found loop
                    begin
               	       begin
                           update grzw_rel_descontos_lojas_nl a
                              set vlr_tot_venda_geral = r_tot_geral.vlr_venda_geral
                            where upper(des_usuario) = upper(pi_usuario)
                              and substr(cod_nivel,1,wQtd_Casas) = r_tot_geral.cod_nivel
                              and dta_ref = r_tot_geral.dta_ref
                              and seq_nivel = wNivel
                              and cod_grupo = r_tot_geral.cod_grupo
                              and cod_quebra = r_tot_geral.cod_quebra
                              and cod_unidade = r_tot_geral.cod_unidade;
               	       end;
                    end;
                    fetch c_tot_geral into r_tot_geral;
                    end loop;
                    close c_tot_geral;
                    commit;

	            open c_tot_geral_grupo;
                    fetch c_tot_geral_grupo into r_tot_geral_grupo;
                    while c_tot_geral_grupo%found loop
                    begin
               	       begin
                           update grzw_rel_descontos_lojas_nl a
                              set vlr_tot_geral_grupo_venda = r_tot_geral_grupo.vlr_venda_geral_grupo
                            where upper(des_usuario) = upper(pi_usuario)
                              and substr(cod_nivel,1,wQtd_Casas) = r_tot_geral_grupo.cod_nivel
                              and dta_ref = r_tot_geral_grupo.dta_ref
                              and seq_nivel = wNivel
                              and cod_grupo = r_tot_geral_grupo.cod_grupo
                              and cod_quebra = r_tot_geral_grupo.cod_quebra;
               	       end;
                    end;
                    fetch c_tot_geral_grupo into r_tot_geral_grupo;
                    end loop;
                    close c_tot_geral_grupo;
                    commit;

	            open c_tot_geral_dta;
                    fetch c_tot_geral_dta into r_tot_geral_dta;
                    while c_tot_geral_dta%found loop
                    begin
               	       begin
                           update grzw_rel_descontos_lojas_nl a
                              set vlr_tot_venda_geral_dta = r_tot_geral_dta.vlr_venda_geral_dta
                            where upper(des_usuario) = upper(pi_usuario)
                              and substr(cod_nivel,1,wQtd_Casas) = r_tot_geral_dta.cod_nivel
                              and seq_nivel = wNivel
                              and cod_grupo = r_tot_geral_dta.cod_grupo
                              and cod_quebra = r_tot_geral_dta.cod_quebra
                              and cod_unidade = r_tot_geral_dta.cod_unidade;
               	       end;
                    end;
                    fetch c_tot_geral_dta into r_tot_geral_dta;
                    end loop;
                    close c_tot_geral_dta;
                    commit;

	            open c_tot_geral_grupo_dta;
                    fetch c_tot_geral_grupo_dta into r_tot_geral_grupo_dta;
                    while c_tot_geral_grupo_dta%found loop
                    begin
               	       begin
                           update grzw_rel_descontos_lojas_nl a
                              set vlr_venda_geral_grupo_dta = r_tot_geral_grupo_dta.vlr_venda_geral_grupo_dta
                            where upper(des_usuario) = upper(pi_usuario)
                              and substr(cod_nivel,1,wQtd_Casas) = r_tot_geral_grupo_dta.cod_nivel
                              and seq_nivel = wNivel
                              and cod_grupo = r_tot_geral_grupo_dta.cod_grupo
                              and cod_quebra = r_tot_geral_grupo_dta.cod_quebra;
               	       end;
                    end;
                    fetch c_tot_geral_grupo_dta into r_tot_geral_grupo_dta;
                    end loop;
                    close c_tot_geral_grupo_dta;
                    commit;

	            open c_tot_geral_total;
                    fetch c_tot_geral_total into r_tot_geral_total;
                    while c_tot_geral_total%found loop
                    begin
               	       begin
                           update grzw_rel_descontos_lojas_nl a
                              set vlr_geral_total_venda = r_tot_geral_total.vlr_venda_geral_total
                            where upper(des_usuario) = upper(pi_usuario)
                              and substr(cod_nivel,1,wQtd_Casas) = r_tot_geral_total.cod_nivel
                              and seq_nivel = wNivel
                              and cod_grupo = r_tot_geral_total.cod_grupo;
               	       end;
                    end;
                    fetch c_tot_geral_total into r_tot_geral_total;
                    end loop;
                    close c_tot_geral_total;
                    commit;

                    wNivel_T := wNivel - 2;
                    if (wNivel_T <= 0) then
                    	wNivel_T := 1;
                    end if;

		    if (wNivel_T = 1) then
			wQtd_Casas  := 2;
		    elsif (wNivel_T = 2) then
		        wQtd_Casas  := 4;
		    elsif (wNivel_T = 3) then
		        wQtd_Casas  := 6;
            elsif (wNivel_T = 4) then
		        wQtd_Casas  := 8;
				else
				wQtd_Casas  := 11;
		    end if;

	               open c_tot_total;
                    fetch c_tot_total into r_tot_total;
                    while c_tot_total%found loop
                    begin
               	       begin
                           update grzw_rel_descontos_lojas_nl a
                              set vlr_tot_venda_total = r_tot_total.vlr_venda_total
                            where upper(des_usuario) = upper(pi_usuario)
                              and substr(cod_nivel,1,wQtd_Casas) = r_tot_total.cod_nivel
                              and seq_nivel = wNivel
                              and cod_grupo = r_tot_total.cod_grupo;
               	       end;
                    end;
                    fetch c_tot_total into r_tot_total;
                    end loop;
                    close c_tot_total;
                    commit;

               	    wNivel := wNivel - 1;
               end;
               end loop;
               commit;


               if (pi_Totais = 1) then
               begin
	           wNivel := pi_nivel_mascara;
	           while wNivel > 0 loop
	           begin
		        if (wNivel = 1) then
			        wQtd_Casas  := 2;
			        wQtd_Casas1 := 2;
		        elsif (wNivel = 2) then
			        wQtd_Casas  := 4;
			        wQtd_Casas1 := 5;
		        elsif (wNivel = 3) then
			        wQtd_Casas  := 6;
			        wQtd_Casas1 := 8;
                elsif (wNivel = 4) then
			        wQtd_Casas  := 8;
 			        wQtd_Casas1 := 11;
					else
					wQtd_Casas  := 11;
 			        wQtd_Casas1 := 15;

		        end if;




	                open c_cresc;
                        fetch c_cresc into r_cresc;
                        while c_cresc%found loop
                        begin

        	            wVlr_Venda_Liq_Ant := nvl(r_cresc.vlr_venda_ant,0) - nvl(r_cresc.vlr_icms_ant,0) - nvl(r_cresc.vlr_pis_ant,0) - nvl(r_cresc.vlr_cofins_ant,0);

        	            if (nvl(r_cresc.qtd_venda_ant,0) > 0) then
             	               wCresc_Qtd := Round(((nvl(r_cresc.qtd_venda,0) - nvl(r_cresc.qtd_venda_ant,0)) / nvl(r_cresc.qtd_venda_ant,0)) * 100,1);
        	            else
               	               wCresc_Qtd := null;
        	            end if;

        	            if (nvl(r_cresc.vlr_venda_ant,0) > 0) then
        	               wCresc_Venda := Round(((nvl(r_cresc.vlr_venda,0) - nvl(r_cresc.vlr_venda_ant,0)) / nvl(r_cresc.vlr_venda_ant,0)) * 100,1);
        	            else
        	               wCresc_Venda := null;
        	            end if;

        	            if (nvl(wVlr_Venda_Liq_Ant,0) > 0) then
        	               wCresc_Venda_Liq := Round(((nvl(r_cresc.vlr_venda_liq,0) - nvl(wVlr_Venda_Liq_Ant,0)) / nvl(wVlr_Venda_Liq_Ant,0)) * 100,1);
		            else
		               wCresc_Venda_Liq := null;
		            end if;

                            begin
                               update grzw_rel_descontos_lojas_nl
                                  set vlr_venda_ant = r_cresc.vlr_venda_ant
                                     ,vlr_venda_liq_ant = wVlr_Venda_Liq_Ant
                                     ,vlr_custo_ant = r_cresc.vlr_custo_ant
                                     ,qtd_venda_ant = r_cresc.qtd_venda_ant
                                     ,cresc_venda = wCresc_Venda
                                     ,cresc_venda_liq = wCresc_Venda_Liq
                                     ,cresc_qtd_venda = wCresc_Qtd
                                where upper(des_usuario) = upper(pi_usuario)
                                  and cod_nivel = r_cresc.cod_completo
                                  and seq_nivel = wNivel
                                  and cod_unidade = r_cresc.cod_unidade
                                  and cod_editado = r_cresc.cod_editado;
                            end;

                        end;
                        fetch c_cresc into r_cresc;
                        end loop;
                        close c_cresc;
                        commit;

 		        wNivel := wNivel - 1;
                   end;
                   end loop;
                   commit;
               end;
               end if;

	       open c_part;
               fetch c_part into r_part;
               while c_part%found loop
               begin

               	    if nvl(r_part.vlr_tot_venda_nivel,0) > 0 then
                        wVlrTestador  := Round(((r_part.vlr_venda * 100) / r_part.vlr_tot_venda_nivel),2);
                        if wVlrTestador < -999 then
					        wPart_Vlr_Venda_Nivel :=-999;
                        else
                            wPart_Vlr_Venda_Nivel := wVlrTestador;
						end if;
               	    else
               	       wPart_Vlr_Venda_Nivel     := 0;
               	    end if;


               	    if nvl(r_part.vlr_tot_venda_rede,0) > 0 then
               	       wVlrTestador      := Round(((r_part.vlr_venda * 100)  / r_part.vlr_tot_venda_rede),2);
					   if wVlrTestador < -999 then
					        wPart_Vlr_Venda_Rede :=-999;
                        else
                            wPart_Vlr_Venda_Rede := wVlrTestador;
                        end if;
               	    else
               	       wPart_Vlr_Venda_Rede      := 0;
               	    end if;




               	    if nvl(r_part.vlr_tot_venda_geral,0) > 0 then
               	      wVlrTestador := Round(((r_part.vlr_venda * 100)  / r_part.vlr_tot_venda_geral),2);
					  if wVlrTestador < -999 then
					        wPart_Vlr_Venda_Geral :=-999;
                        else
                            wPart_Vlr_Venda_Geral := wVlrTestador;
                        end if;
               	    else
               	       wPart_Vlr_Venda_Geral     := 0;
               	    end if;



                    if wPart_Vlr_Venda_Geral > 99999 then
                       wPart_Vlr_Venda_Geral := 99999;
                    end if;

                    if wPart_Vlr_Venda_Rede > 99999 then
                       wPart_Vlr_Venda_Rede := 99999;
                    end if;

                    if wPart_Vlr_Venda_Nivel > 999.99 then
                       wPart_Vlr_Venda_Nivel := 999.99;
                    end if;

               	    begin

                       update grzw_rel_descontos_lojas_nl
                          set part_venda_nivel = wPart_Vlr_Venda_Nivel
                             ,part_venda_rede = wPart_Vlr_Venda_Rede
                             ,part_venda_geral = wPart_Vlr_Venda_Geral
                        where upper(des_usuario) = upper(pi_usuario)
                          and cod_nivel = r_part.cod_nivel
                          and dta_ref = r_part.dta_ref
                          and seq_nivel = r_part.seq_nivel
                          and cod_grupo = r_part.cod_grupo
                          and cod_quebra = r_part.cod_quebra
                          and cod_unidade = r_part.cod_unidade;
               	    end;
               end;
               fetch c_part into r_part;
               end loop;
               close c_part;
               commit;


		   DELETE FROM GRZW_REL_DESCONTOS_LOJAS_NL
	       WHERE upper(Des_Usuario) = upper(pi_Usuario)
		   and cod_unidade < pi_unidade_ini
		   and cod_unidade > pi_unidade_fim;
	       COMMIT;

  end;
end grz_rel_margem_lojas_dia2_sp;