/*------------------------------------------------------------------------
  Procedure.: grz_rel_kpi_venda
  Empresa...: Grazziotin S/A
  Finalidade: Gravar dados para a consulta do KPI Venda.

  Autor   Data     Operacao  Descricao
  Daniele ???/???? Criacao
  Antonio MAI/2021 Alteracao Formatacao do codigo-fonte.
  Antonio JUN/2021 Alteracao Modificado o CURSOR para selecionar a quantidade
                             seguro; inclusao de SQL para selecionar a 
                             quantidade de elegiveis; calculo da conversao
                             de seguro (CRE) e gravacao dos campos na tabela de
                             KPI VENDAS.
  Jaisson JUN/2021 Alteracao SQL´s e regras para selecionar valores de seguro e
                             elegiveis CRE
  Antonio JUN/2021 Alteracao Conversao CPP: Criação de campos na tabela GRZ_KPI_VENDAS;
                             criação de colunas de percentual de conversao de 
                             seguro CPP em cada período do relatório;
                             modificacao da procedure GRZ_REL_KPI_VENDAS
                             para selecionar os valores (seguro e elegiveis)
                             para calcular conversao do seguro.
  Antonio JUL/2021 Alteracao Correcao do SQL de quebra por grupo, deixando fixo
  Jaisson                    o grupo 71070
  Antonio          Alteracao Performace: Retirada da funcao to_date() dos campos
                             data (originados de tabelas ou cursores)

  Parametros
  pi_Opcao - Parametros da insercao de dados.
  Parametros: Empresa#DataInicial#DataFinal#UnidadeInicial#UnidadeFinal#
------------------------------------------------------------------------*/
create or replace procedure grz_rel_kpi_venda (pi_opcao in varchar2)
is
begin
     declare
            -- Parametros de entrada
            v_result            integer;
            v_cur               integer;

            pi_empresa          number;
            pi_dta_ini          date;
            pi_dta_fim          date;
            pi_unidadeini       number;
            pi_unidadefim       number;

            wi                  number;
            wf                  number;
            wdia                number(2);
            wmes                number(2);
            wano                number(4);
            wdes_quebra         varchar2(50);
            wcod_grupo_macro    number;
            wdes_grupo_macro    varchar2(50);
            wdes_rede           varchar2(50);
            wcontrole           number;
            wcontroleunidade    number;
            wticket_medio       number(18,2);
            wperc_whats         number(18,2);
            wperc_demost        number(18,2);
            wperc_vd_prazo      number(18,2);
            wperc_acresc        number(18,2);
            wperc_seguro        number(18,2);
            wqtdcpp             number;
            wvlrcpp             number(18,2);
            wqtd_vp_elegiveis   number(12,0);
            wperc_conversao     number(18,2);
            -- variaveis para calculo da CONVERSAO seguro CPP
            wqtd_elegiveis_cpp  number(12,0);
            wqtd_seguro_cpp     number(12,0);
            wperc_conversao_cpp number(18,2);
            wVlrAcrescimo       number(18,2);
            wgztstorerede       number;
            wgztstoreunidade    number;
            wgztstoreunidadede  number;
            wcodunidade         number;
            wcodrede            number;
            wcod_regiao         number;
            wcod_regiaonova     number;
            wcod_unidadenova    number;

            -- Declaracao do CURSOR
            cursor c_venda is
                   select a.dta_emissao dta_movimento
                          ,gu.cod_grupo
                          ,gu.cod_quebra cod_regiao
                          ,a.cod_unidade cod_unidade
                          ,decode(g.cod_nivel2,810,'10',830,'30',840,'40',850,'50','870','70') cod_rede
                          ,decode(g.cod_nivel2,810,'GRZ',830,'PRM',840,'FRG',850,'TOT','GZT') des_rede
                          ,g1.des_cidade des_cidade
                          ,g1.cod_uf des_uf
                          ,count(distinct(decode(notas.cod_oper,302,a.num_seq,300,a.num_seq))) qtd_negocio
                          ,sum(decode(notas.cod_oper,6100,0,nvl(notas.vlr_operacao,0))) vlr_venda
                          ,sum(nvl(venda_whats.vlr_vda_whats,0)) vlr_venda_whats
                          ,sum(nvl(venda_demo.vlr_vda_demo,0) )vlr_demost
                          ,sum(decode(notas.cod_oper,302,(nvl(notas.vlr_operacao,0) -
                                                          nvl(notas.vlr_entrada,0)),0)) vlr_venda_prazo
                          ,sum(decode(notas.cod_oper,302,nvl(notas.vlr_acrescimo,0),0)) vlr_acrescimo
                          ,sum(decode(notas.cod_oper,6100,nvl(notas.vlr_operacao,0),0)) vlr_seguro
                          ,sum(decode(notas.cod_oper,6200,nvl(notas.vlr_operacao,0),0)) vlr_seguro_novo
                          ,count(distinct(decode(notas.cod_oper,6100,notas.num_seq,6200,notas.num_seq))) qtd_vp_seguro
                   from ns_notas a
                        ,(select ns.num_seq,ns.cod_maquina,decode(nso.cod_oper,300,300,4300,300,6100,6100,6200,6200,302) cod_oper
                                 ,sum(nvl(nso.vlr_acrescimo,0) + nvl(nso.vlr_acrescimo_cob,0)) vlr_acrescimo
                                 ,sum(nvl(nso.vlr_operacao,0)) vlr_operacao
                                 ,sum(nvl(nso.vlr_entrada,0)) vlr_entrada
                          from ns_notas ns
                               ,ns_notas_operacoes nso
                          where nso.num_seq = ns.num_seq
                          and nso.cod_maquina = ns.cod_maquina
                          and nso.cod_oper in (300,302,305,4300,4302,4305,6100,6200)
                          and ns.cod_emp = 1
                          and ns.dta_emissao >= pi_dta_ini
                          and ns.dta_emissao <= pi_dta_fim
                          and ns.tip_nota in (2,3)
                          and ns.ind_status = 1
                          group by ns.num_seq,ns.cod_maquina,
                                   decode(nso.cod_oper,300,300,4300,300,6100,6100,6200,6200,302)) notas
                        ,(select nsw.num_seq,nsw.cod_maquina
                                 ,sum(nvl(nsow.vlr_operacao,0)) vlr_vda_whats
                          from ns_notas nsw
                               ,ns_notas_operacoes nsow
                               ,(select sislog.cod_unidade,
                                        sislog.num_cupom,
                                        sislog.num_equipamento,
                                        sislog.dta_lancamento,
                                        sum(sislog.vlr_total) vlr_total
                                 from grz_lojas_cupom_itens sislog
                                 where sislog.dta_lancamento >= pi_dta_ini
                                 and sislog.dta_lancamento <= pi_dta_fim
                                 and nvl(sislog.ind_venda_whatsapp,0) = 1
                                 and sislog.ind_cancelado = 0
                                 and sislog.ind_cancelado_item = 0
                                 group by sislog.cod_unidade,
                                          sislog.num_cupom,
                                          sislog.num_equipamento,
                                          sislog.dta_lancamento) vda_whats
                          where vda_whats.cod_unidade = nsw.cod_unidade
                          and vda_whats.num_cupom = nsw.num_nota
                          and vda_whats.dta_lancamento = nsw.dta_emissao
                          and vda_whats.num_equipamento = nsw.num_equipamento
                          and nsow.num_seq = nsw.num_seq
                          and nsow.cod_maquina = nsw.cod_maquina
                          and nsow.cod_oper in (300,302,305,4300,4302,4305)
                          and nsw.cod_emp = pi_empresa
                          and nsw.dta_emissao >= pi_dta_ini
                          and nsw.dta_emissao <= pi_dta_fim
                          and nsw.tip_nota in (2,3)
                          and nsw.ind_status = 1
                          group by nsw.num_seq,nsw.cod_maquina) venda_whats
                        ,(select nsd.num_seq,
                                 nsd.cod_maquina,
                                 decode(nsod.cod_oper,300,300,4300,300,302) cod_oper
                                 ,sum(nvl(nsod.vlr_operacao,0)) vlr_vda_demo
                          from ns_notas nsd
                               ,ns_notas_operacoes nsod
                          where exists (select 1
                                        from ne_notas ne
                                             ,ne_notas_operacoes neo
                                        where neo.num_seq      = ne.num_seq
                                        and neo.cod_maquina    = ne.cod_maquina
                                        and neo.cod_oper       = 150
                                        and ne.ind_status      = 1
                                        and ne.cod_emp         = nsd.cod_emp
                                        and ne.cod_unidade     = nsd.cod_unidade
                                        and ne.dta_recebimento = nsd.dta_emissao
                                        and ne.cod_pessoa_forn = nsd.cod_cliente)
                                        and nsod.num_seq = nsd.num_seq
                                        and nsod.cod_maquina = nsd.cod_maquina
                                        and nsod.cod_oper in (300,302,305,4300,4302,4305)
                                        and nsd.cod_emp = 1
                                        and nsd.dta_emissao >= pi_dta_ini
                                        and nsd.dta_emissao <= pi_dta_fim
                                        and nsd.tip_nota in (2,3)
                                        and nsd.ind_status = 1
                          group by nsd.num_seq,
                                   nsd.cod_maquina,
                                   decode(nsod.cod_oper,300,300,4300,300,302)) venda_demo
                        ,ge_grupos_unidades gu
                        ,ge_grupos ge
                        ,ps_pessoas p
                        ,g1_cidades g1
                        ,ge_unidades g
                   where g.cod_unidade = a.cod_unidade
                   and g1.cod_cidade = p.cod_cidade
                   and p.cod_pessoa = a.cod_unidade
                   and ge.cod_grupo = gu.cod_grupo
                   and gu.cod_unidade = a.cod_unidade
                   and gu.cod_emp = pi_empresa
                   and gu.cod_grupo in (71010,71030,71040,71050,71070)
                   and gu.cod_unidade >= pi_UnidadeIni
                   and gu.cod_unidade <= pi_UnidadeFim
                   --and gu.cod_quebra <9999
                   and venda_demo.num_seq(+) = a.num_seq
                   and venda_demo.cod_maquina(+) = a.cod_maquina
                   and venda_whats.num_seq(+) = a.num_seq
                   and venda_whats.cod_maquina(+) = a.cod_maquina
                   and notas.num_seq = a.num_seq
                   and notas.cod_maquina = a.cod_maquina
                   and a.cod_emp = 1
                   and a.dta_emissao >= pi_dta_ini
                   and a.dta_emissao <= pi_dta_fim
                   and a.tip_nota in (2,3)
                   and a.ind_status = 1
                   /*and exists (select 1 from  ge_grupos_unidades  c
                                 where c.cod_unidade = a.cod_unidade
                                 and c.cod_grupo in (1912,1932,1942,1952,1972))*/
                   having sum(nvl(notas.vlr_operacao,0)) > 0
                   group by a.dta_emissao
                            ,gu.cod_grupo
                            ,gu.cod_quebra
                            ,a.cod_unidade
                            ,decode(g.cod_nivel2,810,'10',830,'30',840,'40',850,'50','870','70')
                            ,decode(g.cod_nivel2,810,'GRZ',830,'PRM',840,'FRG',850,'TOT','GZT')
                            ,g1.des_cidade
                            ,g1.cod_uf
                   order by 4,1;
            r_venda c_venda%rowtype;

     /* Inicio da procedure principal */
     begin
          v_cur := dbms_sql.open_cursor;
          dbms_sql.parse(v_cur,'alter session set nls_date_format= "dd/mm/rrrr"',dbms_sql.native);
          v_result := dbms_sql.execute(v_cur);
          dbms_sql.close_cursor(v_cur);

          v_cur := dbms_sql.open_cursor;
          dbms_sql.parse(v_cur,'alter session set nls_numeric_characters = '',.''',dbms_sql.native);
          v_result := dbms_sql.execute(v_cur);
          dbms_sql.close_cursor(v_cur);

          wi := instr(pi_opcao, '#', 1, 1);
          pi_empresa := to_number(substr(pi_opcao, 1,(wi-1)));
          wf := instr(pi_opcao, '#', 1, 2);
          pi_dta_ini := substr(pi_opcao,(wi+1),(wf-wi-1));
          wi := wf;
          wf := instr(pi_opcao, '#', 1, 3);
          pi_dta_fim := substr(pi_opcao,(wi+1),(wf-wi-1));
          wi := wf;
          wf := instr(pi_opcao, '#', 1, 4);
          pi_unidadeini := substr(pi_opcao,(wi+1),(wf-wi-1));
          wi := wf;
          wf := instr(pi_opcao, '#', 1, 5);
          pi_unidadefim := substr(pi_opcao,(wi+1),(wf-wi-1));

          wcontrole := 0;
          wcontroleunidade := 0;

          begin
               delete from grz_kpi_vendas
               where dta_movimento >= pi_dta_ini
               and dta_movimento <= pi_dta_fim
               and cod_unidade between pi_UnidadeIni and pi_UnidadeFim;
          end;

          open c_venda;
          fetch c_venda into r_venda;
          while c_venda%found loop
          begin
               wdia        := to_char(r_venda.dta_movimento ,'dd');
               wmes        := to_char(r_venda.dta_movimento ,'mm');
               wano        := to_char(r_venda.dta_movimento ,'yyyy');
               wcodunidade := r_venda.cod_unidade;
               wcod_regiao := r_venda.cod_regiao;

               -- Seleciona a quantidade e valor CPP
               begin
                    select count((nsod.cod_oper))
                           ,nvl(sum(nvl(nsod.vlr_operacao,0)),0)
                    into wqtdcpp
                         ,wvlrcpp
                    from ns_notas nsd
                         ,ns_notas_operacoes nsod
                    where  nsod.num_seq = nsd.num_seq
                    and nsod.cod_maquina = nsd.cod_maquina
                    and nsod.cod_oper in (3000,3050)
                    and nsd.cod_emp = 1
                    and nsd.ind_status = 1
                    and nsd.cod_unidade = r_venda.cod_unidade
                    and nsd.dta_emissao >= r_venda.dta_movimento
                    and nsd.dta_emissao <= r_venda.dta_movimento;
                    exception
                             when no_data_found then
                                  wqtdcpp := 0;
                                  wvlrcpp := 0;
               end;

               -- Seleciona a quantidade de elegiveis CRE (para calculo da conversao)
               begin
                    select count(distinct a.num_seq) qtd_venda_elegiveis
                    into wqtd_vp_elegiveis
                    from (select sum(nvl(e.vlr_operacao,0)) vlr_operacao,
                                 sum(nvl(e.vlr_entrada,0)) vlr_entrada,
                                 e.num_seq, e.cod_maquina,
                                 e.cod_oper
                          from ns_notas_operacoes e
                          where e.cod_oper in (302,305,4302,4305)
                          group by e.num_seq, e.cod_maquina, e.cod_oper) a,
                          ns_notas b,
                          ps_fisicas f
                    where a.num_seq = b.num_seq
                    and a.cod_maquina = b.cod_maquina
                    and b.cod_emp     = pi_empresa
                    and b.ind_status  = 1
                    and b.cod_cliente = f.cod_pessoa
                    --and trunc((months_between(b.dta_emissao, to_date(f.dta_nasc,'dd/mm/yyyy')))/12) >= 18
                    --and trunc((months_between(b.dta_emissao, to_date(f.dta_nasc,'dd/mm/yyyy')))/12) <= 69
                    and ((months_between(b.dta_emissao, f.dta_nasc))/12) >= 18
                    and ((months_between(b.dta_emissao, f.dta_nasc))/12) <= 69
                    and b.cod_unidade = wcodunidade
                    --and b.dta_emissao >= to_date(r_venda.dta_movimento,'dd/mm/yyyy')
                    --and b.dta_emissao <= to_date(r_venda.dta_movimento,'dd/mm/yyyy')
                    and b.dta_emissao >= r_venda.dta_movimento
                    and b.dta_emissao <= r_venda.dta_movimento
                    and b.cod_cliente_milhagem is null
                    and exists (select 1 from cr_notas_origem cr
                                where b.num_seq   = cr.num_nota
                                and b.cod_maquina = cr.cod_maquina
                                and cr.num_parcela > 2);
                    exception
                             when no_data_found then
                                  wqtd_vp_elegiveis := 0;
               end;

               -- Calculo do % conversao do seguro CRE
               if (wqtd_vp_elegiveis = 0) or (wqtd_vp_elegiveis is null) then
                  wperc_conversao := 0; --ERRO: elegiveis ZERADO
               else
                   wperc_conversao := r_venda.qtd_vp_seguro / wqtd_vp_elegiveis * 100;
               end if;

               -- Seleciona a quantidade de SEGURO CPP (para calculo da conversao)
               begin
                    select count((nsod.cod_oper)) qtd_seguro
                    into wqtd_seguro_cpp
                    from ns_notas nsd
                         ,ns_notas_operacoes nsod
                    where  nsod.num_seq = nsd.num_seq
                    and nsod.cod_maquina = nsd.cod_maquina
                    and nsod.cod_oper in (6110)
                    and nsd.cod_emp = 1
                    and nsd.ind_status = 1
                    and nsd.cod_unidade = r_venda.cod_unidade
                    --and to_date(nsd.dta_emissao,'dd/mm/yyyy') >= to_date(r_venda.dta_movimento,'dd/mm/yyyy')
                    --and to_date(nsd.dta_emissao,'dd/mm/yyyy') <= to_date(r_venda.dta_movimento,'dd/mm/yyyy');
                    and nsd.dta_emissao >= r_venda.dta_movimento
                    and nsd.dta_emissao <= r_venda.dta_movimento;
                    exception
                             when no_data_found then
                                  wqtd_seguro_cpp := 0;
               end;

               -- Seleciona a quantidade de elegiveis CPP (para calculo da conversao)
               begin
                    select count(distinct a.num_seq) qtd_venda_elegiveis
                    into wqtd_elegiveis_cpp
                    from (select sum(nvl(e.vlr_operacao,0)) vlr_operacao,
                                 sum(nvl(e.vlr_entrada,0)) vlr_entrada,
                                 e.num_seq, e.cod_maquina,
                                 e.cod_oper
                          from ns_notas_operacoes e
                          where e.cod_oper in (3000,3050,6110)
                          group by e.num_seq,
                                   e.cod_maquina,
                                   e.cod_oper) a,
                         ns_notas b,
                         ge_grupos_unidades c,
                         ps_fisicas f
                    where a.num_seq   = b.num_seq
                    and a.cod_maquina = b.cod_maquina
                    and b.cod_emp     = 1
                    and b.ind_status  = 1
                    and b.num_modelo  = '90'
                    and b.cod_cliente = f.cod_pessoa
                    --and trunc((months_between(b.dta_emissao, to_date(f.dta_nasc,'dd/mm/yyyy')))/12) >= 18
                    --and trunc((months_between(b.dta_emissao, to_date(f.dta_nasc,'dd/mm/yyyy')))/12) <= 69
                    and trunc(months_between(b.dta_emissao, f.dta_nasc)/12) >= 18
                    and trunc(months_between(b.dta_emissao, f.dta_nasc)/12) <= 69
                    and b.cod_unidade = c.cod_unidade
                    and b.cod_unidade = r_venda.cod_unidade
                    --and b.dta_emissao >= to_date(r_venda.dta_movimento,'dd/mm/yyyy')
                    --and b.dta_emissao <= to_date(r_venda.dta_movimento,'dd/mm/yyyy');
                    and b.dta_emissao >= r_venda.dta_movimento
                    and b.dta_emissao <= r_venda.dta_movimento;
                    exception
                             when no_data_found then
                                  wqtd_elegiveis_cpp := 0;
               end;

               -- Calculo do % conversao do seguro CPP
               if (wqtd_elegiveis_cpp = 0) or (wqtd_elegiveis_cpp is null) then
                  wperc_conversao_cpp := 0; --ERRO: elegiveis ZERADO
               else
                   wperc_conversao_cpp := wqtd_seguro_cpp / wqtd_elegiveis_cpp * 100;
               end if;

               if r_venda.vlr_venda > 0 or r_venda.qtd_negocio > 0 then
                  wticket_medio := (r_venda.vlr_venda/r_venda.qtd_negocio);
               else
                   wticket_medio := 0;
               end if;

               if r_venda.vlr_venda_whats > 0 or r_venda.vlr_venda > 0 then
                  wperc_whats := ((r_venda.vlr_venda_whats*100)/r_venda.vlr_venda);
               else
                   wperc_whats :=0;
               end if;

               if r_venda.vlr_demost > 0 or r_venda.vlr_venda > 0 then
                  wperc_demost := ((r_venda.vlr_demost*100)/r_venda.vlr_venda);
               else
                   wperc_demost :=0;
               end if;

               if r_venda.vlr_venda_prazo > 0 or r_venda.vlr_venda > 0 then
                  wperc_vd_prazo := ((r_venda.vlr_venda_prazo*100)/r_venda.vlr_venda);
               else
                   wperc_vd_prazo :=0;
               end if;

               wVlrAcrescimo := r_venda.vlr_acrescimo - r_venda.vlr_seguro_novo;
               if wVlrAcrescimo < 0 then
                  wVlrAcrescimo := 0;
               end if;

               if wVlrAcrescimo > 0 or r_venda.vlr_venda_prazo > 0 then
                  wperc_acresc := ((wVlrAcrescimo*100)/r_venda.vlr_venda_prazo);
               else
                   wperc_acresc :=0;
               end if;

               if r_venda.vlr_seguro > 0 or r_venda.vlr_venda_prazo > 0 then
                  wperc_seguro := ((r_venda.vlr_seguro*100)/r_venda.vlr_venda_prazo);
               else
                   wperc_seguro :=0;
               end if;

               wcodrede           := r_venda.cod_rede;
               wgztstorerede      := 0;
               wgztstoreunidade   := 0;
               wgztstoreunidadede := 0;

               begin
                    select cod_rede_para
                           ,cod_unidade_para
                           ,cod_unidade_de
                    into wgztstorerede
                         ,wgztstoreunidade
                         ,wgztstoreunidadede
                    from grazz.grz_lojas_gzt_store a
                    where a.cod_unidade_de = r_venda.cod_unidade;
                    exception
                             when no_data_found then
                                  wgztstorerede := 0;
                                  wgztstoreunidade := 0;
                                  wgztstoreunidadede := 0;
               end;

               if wcodunidade = wgztstoreunidadede then
                  wcodunidade := wgztstoreunidade;
                  wcodrede := wgztstorerede;
                  wDes_Rede := 'GZT';
               else
                   wcodunidade := r_venda.cod_unidade;
                   wcodrede := r_venda.cod_rede;
                   wdes_rede := r_venda.des_rede;
               end if;

               if wcod_regiao = 9999 then
                  begin
                       select cod_unidade_para
                       into wcod_unidadenova
                       from grazz.grz_lojas_gzt_store
                       where cod_unidade_de = r_venda.cod_unidade;
                       exception
                                when no_data_found then
                                     wcod_unidadenova := 0;
                  end;

                  begin
                       select cod_regiao
                       into wcod_regiaonova
                       from grazz.grz_lojas
                       where cod_loja = wcod_unidadenova;
                       exception
                                when no_data_found then
                                     wcod_regiaonova := 0;
                  end;

                  begin
                       select des_quebra
                       into wdes_quebra
                       from ge_grupos_quebra
                       where cod_emp    = 1
                       --and cod_grupo  = r_venda.cod_grupo
                       and cod_grupo in (71070)
                       and cod_quebra = wcod_regiaonova
                       group by des_quebra;
                       exception
                                when no_data_found then
                                     wdes_quebra := 'Quebra grupo unidades n¿o cadastrado';
                  end;
                  wCod_Regiao := wCod_RegiaoNova;
               else
                   begin
                        select des_quebra
                        into wdes_quebra
                        from ge_grupos_quebra
                        where cod_emp    = 1
                        --and cod_grupo  = r_venda.cod_grupo
                        and cod_grupo in (71070)
                        and cod_quebra = wcod_regiao;
                        exception
                                 when no_data_found then
                                      wdes_quebra := 'Quebra grupo unidades nao cadastrado';
                   end;
               end if;

               if wcontroleunidade <> r_venda.cod_unidade then
                  begin
                       select cod_grupo
                       into wcod_grupo_macro
                       from ge_grupos_unidades ge
                       where cod_unidade = wcodunidade
                       and cod_grupo in (1739,1740,1741);
                       exception
                                when no_data_found then
                                     wcod_grupo_macro := 0;
                  end;

                  begin
                       select des_grupo
                       into wdes_grupo_macro
                       from ge_grupos
                       where cod_emp = 1
                       and cod_grupo = wcod_grupo_macro;
                       exception
                       when no_data_found then
                            wdes_grupo_macro := 'Quebra grupo unidades nao cadastrado';
                  end;
               end if;

               wcontrole:= r_venda.cod_regiao;
               wcontroleunidade := r_venda.cod_unidade;

               insert into grz_kpi_vendas (dta_movimento,dia,mes,
                                           ano,cod_rede,des_rede,
                                           cod_unidade,cod_regiao,des_regiao,
                                           des_cidade,des_uf,qtd_negocio,
                                           vlr_vd,ticket_medio,vlr_vd_whats,
                                           perc_whats,vlr_demost,perc_demost,
                                           vlr_vd_prazo,perc_vd_prazo,vlr_acresc,
                                           perc_acresc,vlr_seguro,perc_seguro,
                                           ind_nivel,cod_grupo_macro,des_grupo_macro,
                                           qtd_cpp,vlr_cpp,
                                           qtd_vp_elegiveis,qtd_vp_seguro,perc_conversao,
                                           qtd_elegiveis_cpp,qtd_seguro_cpp,perc_conversao_cpp)
               values (r_venda.dta_movimento,wdia,wmes,
                       wano,wcodrede, --r_venda.cod_rede
                       wdes_rede, --r_venda.des_rede
                       wcodunidade, --r_venda.cod_unidade
                       wcod_regiao, --r_venda.cod_regiao
                       wdes_quebra,r_venda.des_cidade,r_venda.des_uf,
                       r_venda.qtd_negocio,r_venda.vlr_venda,wticket_medio,
                       r_venda.vlr_venda_whats,wperc_whats,r_venda.vlr_demost,
                       wperc_demost,r_venda.vlr_venda_prazo,wperc_vd_prazo,
                       wVlrAcrescimo,wperc_acresc,r_venda.vlr_seguro+nvl(r_venda.vlr_seguro_novo,0),
                       wperc_seguro,1,wcod_grupo_macro,
                       wdes_grupo_macro,wqtdcpp,wvlrcpp,
                       wqtd_vp_elegiveis,r_venda.qtd_vp_seguro,wperc_conversao,
                       wqtd_elegiveis_cpp,wqtd_seguro_cpp,wperc_conversao_cpp);
               exception
                        when dup_val_on_index then
                             update grz_kpi_vendas
                             set qtd_negocio         = qtd_negocio + r_venda.qtd_negocio
                                 ,vlr_vd             = vlr_vd + r_venda.vlr_venda
                                 --,ticket_medio     = ((vlr_vd + r_venda.vlr_venda)/(iif((qtd_negocio+r_venda.qtd_negocio = 0),1,qtd_negocio+r_venda.qtd_negocio)))
                                 ,ticket_medio       = ((vlr_vd + r_venda.vlr_venda)/(decode(qtd_negocio+r_venda.qtd_negocio,0,1,qtd_negocio+r_venda.qtd_negocio)))
                                 ,vlr_vd_whats       = vlr_vd_whats+ r_venda.vlr_venda_whats
                                 --,perc_whats       = (((vlr_vd_whats + r_venda.vlr_venda_whats)*100)/(vlr_vd+r_venda.vlr_venda))
                                 ,perc_whats         = (((vlr_vd_whats + r_venda.vlr_venda_whats)*100)/(decode(vlr_vd+r_venda.vlr_venda,0,1,vlr_vd+r_venda.vlr_venda)))
                                 ,vlr_demost         = vlr_demost+ r_venda.vlr_demost
                                 --,perc_demost      = (((vlr_demost+r_venda.vlr_demost)*100)/(vlr_vd+r_venda.vlr_venda))
                                 ,perc_demost        = (((vlr_demost+r_venda.vlr_demost)*100)/(decode(vlr_vd+r_venda.vlr_venda,0,1,vlr_vd+r_venda.vlr_venda)))
                                 ,vlr_vd_prazo       = vlr_vd_prazo+ r_venda.vlr_venda_prazo
                                 --,perc_vd_prazo    = (((vlr_vd_prazo+r_venda.vlr_venda_prazo)*100)/(vlr_vd+r_venda.vlr_venda))
                                 ,perc_vd_prazo      = (((vlr_vd_prazo+r_venda.vlr_venda_prazo)*100)/(decode(vlr_vd+r_venda.vlr_venda,0,1,vlr_vd+r_venda.vlr_venda)))
                                 ,vlr_acresc         = vlr_acresc+ wVlrAcrescimo
                                 --,perc_acresc      = (((vlr_acresc+r_venda.vlr_acrescimo)*100)/(vlr_vd_prazo+r_venda.vlr_venda_prazo))
                                 ,perc_acresc        = (((vlr_acresc+r_venda.vlr_acrescimo)*100)/(decode(vlr_vd_prazo+r_venda.vlr_venda_prazo,0,1,vlr_vd_prazo+r_venda.vlr_venda_prazo)))
                                 ,vlr_seguro         = vlr_seguro +r_venda.vlr_seguro + nvl(r_venda.vlr_seguro_novo,0)
                                 --,perc_seguro      = (((vlr_seguro+r_venda.vlr_seguro)*100)/(vlr_vd_prazo+r_venda.vlr_venda_prazo))
                                 ,perc_seguro        = (((vlr_seguro+r_venda.vlr_seguro)*100)/(decode(vlr_vd_prazo+r_venda.vlr_venda_prazo,0,1,vlr_vd_prazo+r_venda.vlr_venda_prazo)))
                                 ,ind_nivel          = 1
                                 ,qtd_cpp            = qtd_cpp + wqtdcpp
                                 ,vlr_cpp            = vlr_cpp + wvlrcpp
                                 ,qtd_vp_elegiveis   = wqtd_vp_elegiveis
                                 ,qtd_vp_seguro      = r_venda.qtd_vp_seguro
                                 ,perc_conversao     = wperc_conversao
                                 ,qtd_elegiveis_cpp  = wqtd_elegiveis_cpp
                                 ,qtd_seguro_cpp     = wqtd_seguro_cpp
                                 ,perc_conversao_cpp = wperc_conversao_cpp
                             where cod_rede = wcodrede
                             and cod_unidade = wcodunidade
                             and dta_movimento = r_venda.dta_movimento ;
          end; -- c_venda%found loop
          fetch c_venda into r_venda;
          end loop;
          close c_venda;

          commit;
     end;
end grz_rel_kpi_venda;
