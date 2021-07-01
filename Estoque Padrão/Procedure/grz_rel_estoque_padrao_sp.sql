/*---------------------------------------------------------------------------------
  Procedure.: grz_rel_estoque_padrao_sp
  Empresa...: Grazziotin S/A
  Finalidade: Gravar e gerar dados para o relatorio de ESTOQUE PADRAO

  Autor   Data     Operacao  Descricao
  ??????? ???/???? Criacao
  Antonio JUN/2021 Alteracao Aumento das posicoes das variaveis pi_codigo_ini e 
                             pi_codigo_fim, de 11 para 12 posicoes, devido a 
                             alteracao no item de 3 para 4 posicoes; Formatacao
                             do codigo-fonte
  Parametros
  pi_Opcao - Parametros da geracao de dados.
  Parametros: Empresa#Grupo#PeriodoInicial#PeriodoFinal#DataRefencial#PeriodoDiretaInicial#
              PeriodoDiretaFinal#Mascara#CodigoInicial#CodigoFinal#ListarPor?#
              IncluirDevoluicoes(Fixo em 1)#NFRecebidas?#Usuario#
----------------------------------------------------------------------------------*/
create or replace procedure grz_rel_estoque_padrao_sp(pi_opcao in varchar2)
is
begin
declare
       pi_empresa          number;
       pi_grupo            number;
       pi_dta_ini          date;
       pi_dta_fim          date;
       pi_dta_ref          date;
       pi_direta_ini       date;
       pi_direta_fim       date;
       pi_mascara          number;
       pi_codigo_ini       varchar2(12);
       pi_codigo_fim       varchar2(12);
       pi_nivel_mascara    number;
       pi_lista_unidade    number;
       pi_recebido         number;
       pi_usuario          varchar2(30);
       v_result            integer;
       v_cur               integer;
       wi                  number;
       wf                  number;
       wcompleto_ant       varchar2(11);
       wcod_anteriores     varchar2(20);
       wcod_nivel          varchar2(20);
       wdes_nivel          varchar2(50);
       wdes_unidade        varchar2(50);
       wqtd_casas          number;
       wqtd_casas1         number;
       wqtd_casas2         number;
       wseq_nivel          number;
       wnivel              number;
       wdes_quebra_regiao  varchar2(50);
       wcod_regiao         number;
       wcodgrupo           number;
       saida               exception;

       -- cursor pega os valores
       cursor c_est_venda is
              select substr(c.cod_completo,1,wqtd_casas) cod_completo
                     ,substr(c.cod_editado,1,wqtd_casas1) cod_editado
                     ,decode(pi_lista_unidade,1,ge.cod_unidade,pi_grupo) cod_unidade
                     ,sum(decode(a.tip_lancamento,2,nvl(a.qtd_lancamento,0),1,(nvl(a.qtd_lancamento,0) * -1),0)) qtd_venda
                     ,sum(decode(a.tip_lancamento,2,nvl(a.vlr_medio_emp,0),1,(nvl(a.vlr_medio_emp,0) * -1),0)) vlr_custo
              from ce_diarios a
                   ,ie_mascaras c
                   ,t6_oper_quebras o
                   ,ge_grupos_unidades ge
              where a.cod_item     = c.cod_item
              and c.cod_mascara    = pi_mascara
              and c.cod_niv0       = '1'
              and c.cod_completo  >= pi_codigo_ini
              and c.cod_completo  <= pi_codigo_fim
              and a.cod_oper      = o.cod_oper
              and o.cod_grupo_oper in (7300,7106)
              and a.dta_lancamento>= pi_dta_ini
              and a.dta_lancamento<= pi_dta_fim
              and a.cod_unidade = ge.cod_unidade
              and ge.cod_grupo  = pi_grupo
              and ge.cod_emp    = pi_empresa
              and not exists (select 1 from grz_lojas_unificadas_cia t where a.cod_unidade = t.cod_unidade_para)
              group by substr(c.cod_completo,1,wqtd_casas)
                    ,substr(c.cod_editado,1,wqtd_casas1)
                    ,decode(pi_lista_unidade,1,ge.cod_unidade,pi_grupo);
       r_est_venda c_est_venda%rowtype;

       cursor c_est is
              select substr(b.cod_completo,1,wqtd_casas) cod_completo
                     ,substr(b.cod_editado,1,wqtd_casas1) cod_editado
                     ,decode(pi_lista_unidade,1,decode(ge.cod_unidade,uni.cod_unidade_para,uni.cod_unidade_de,ge.cod_unidade),pi_grupo) cod_unidade
                     ,sum(nvl(a.qtd_estoque,0)) qtd_estoque
                     ,sum(nvl(a.vlr_estoque_med,0)) vlr_estoque
              from es_0124_ce_estmedio a
                   ,ie_mascaras b
                   ,ge_grupos_unidades ge
                   ,grz_lojas_unificadas_cia uni
              where a.cod_item = b.cod_item
              and b.cod_mascara = pi_mascara
              and b.cod_niv0    = '1'
              and b.cod_completo >= pi_codigo_ini
              and b.cod_completo <= pi_codigo_fim
              and ge.cod_unidade = uni.cod_unidade_de(+)
              and decode(ge.cod_unidade,uni.cod_unidade_de,uni.cod_unidade_para,ge.cod_unidade)    = a.cod_unidade
              and a.dta_mvto = pi_dta_ref
              and a.cod_emp = ge.cod_emp
              and ge.cod_grupo = pi_grupo
              and ge.cod_emp = pi_empresa
              and not exists (select 1 from grz_lojas_unificadas_cia t
                              where ge.cod_unidade = t.cod_unidade_para)
              group by substr(b.cod_completo,1,wqtd_casas)
                       ,substr(b.cod_editado,1,wqtd_casas1)
                       ,decode(pi_lista_unidade,1,decode(ge.cod_unidade,uni.cod_unidade_para,uni.cod_unidade_de,ge.cod_unidade),pi_grupo);
       r_est c_est%rowtype;

       cursor c_est_padrao is
              select substr(b.cod_completo,1,wqtd_casas) cod_completo
                     ,substr(b.cod_editado,1,wqtd_casas1) cod_editado
                     ,decode(pi_lista_unidade,1,decode(ge.cod_unidade,uni.cod_unidade_para,uni.cod_unidade_de,ge.cod_unidade),pi_grupo) cod_unidade
                     ,sum(nvl(a.qtd_est_min_i,0)) qtd_estoque_padrao
                     ,sum(nvl(est.vlr_medio_unitario,0) * nvl(a.qtd_est_min_i,0)) vlr_estoque_padrao
              from ce_pars_calculo a
                   ,ie_mascaras b
                   ,ie_itens ie
                   ,ce_estoques est
                   ,ge_grupos_unidades ge
                   ,grz_lojas_unificadas_cia uni
              where a.cod_emp = ie.cod_gu
              and a.cod_item = ie.cod_item
              and a.cod_item = b.cod_item
              and b.cod_mascara = pi_mascara
              and b.cod_niv0    = '1'
              and b.cod_completo >= pi_codigo_ini
              and b.cod_completo <= pi_codigo_fim
              and a.cod_emp = est.cod_emp(+)
              and a.cod_item = est.cod_item(+)
              and nvl(est.cod_unidade,0) = 0
              and upper(ie.des_geral) = 'l'
              and ie.ind_inativo = 0
              and ie.ind_avulso = 0
              and nvl(a.qtd_est_min_i,0) > 0
              and ge.cod_unidade = uni.cod_unidade_de(+)
              and decode(ge.cod_unidade,uni.cod_unidade_de,uni.cod_unidade_para,ge.cod_unidade) = a.cod_unidade
              and a.cod_emp = ge.cod_emp
              and ge.cod_grupo = pi_grupo
              and ge.cod_emp = pi_empresa
              and not exists (select 1 from grz_lojas_unificadas_cia t
                               where ge.cod_unidade = t.cod_unidade_para)
              group by substr(b.cod_completo,1,wqtd_casas)
                       ,substr(b.cod_editado,1,wqtd_casas1)
                       ,decode(pi_lista_unidade,1,decode(ge.cod_unidade,uni.cod_unidade_para,uni.cod_unidade_de,ge.cod_unidade),pi_grupo);
       r_est_padrao c_est_padrao%rowtype;

       cursor c_est_direta is
              select substr(b.cod_completo,1,wQtd_Casas) cod_completo
                     ,substr(b.cod_editado,1,wQtd_Casas1) cod_editado
                     ,decode(pi_lista_unidade,1,decode(ge.cod_unidade,uni.cod_unidade_para,uni.cod_unidade_de,ge.cod_unidade),pi_grupo) cod_unidade
                     ,sum(nvl(d.qtd_distribuir,0)) qtd_diretas
                     ,(sum((nvl(i.qtd_sol_compra,0) * nvl(i.vlr_uni_compra,0))
                            + nvl(i.vlr_ipi,0) + nvl(i.vlr_icms_st,0)
                            - nvl(i.vlr_icms,0) - nvl(i.vlr_pis,0) - nvl(i.vlr_cofins,0)) / sum(nvl(i.qtd_sol_compra,0)))
                     * sum(nvl(d.qtd_distribuir,0)) vlr_diretas
              from ac_distribuicoes d
                   ,ac_ordens_compra o
                   ,ac_itens_oc i
                   ,ie_mascaras b
                   ,ge_grupos_unidades ge
                   ,grz_lojas_unificadas_cia uni
              where exists (select 1
                            from ac_parcs_itens p
                            where p.dta_prev_entr >= pi_direta_ini
                            and p.dta_prev_entr   <= pi_direta_fim
                            and p.num_seq_item    = d.num_seq_item
                            and p.cod_maquina     = d.cod_maquina
                            and p.num_seq         = d.num_seq)
              and (1 = pi_recebido or not exists (select 1
                                                  from ac_recebimentos_oc r
                                                  where r.num_seq_item = d.num_seq_item
                                                  and r.cod_maquina    = d.cod_maquina
                                                  and r.num_seq        = d.num_seq))
              and ge.cod_unidade = uni.cod_unidade_de(+)
              and decode(ge.cod_unidade,uni.cod_unidade_de,uni.cod_unidade_para,ge.cod_unidade) = d.cod_unidade
              and ge.cod_grupo = pi_grupo
              and ge.cod_emp = pi_empresa
              --and o.cod_oper = 104
              and d.cod_maquina = o.cod_maquina
              and d.num_seq = o.num_seq
              and d.num_seq = i.num_seq
              and d.cod_maquina = i.cod_maquina
              and d.num_seq_item = i.num_seq_item
              and b.cod_mascara = pi_mascara
              and i.cod_item = b.cod_item
              and b.Cod_Niv0    = '1'
              and b.cod_completo >= pi_codigo_ini
              and b.cod_completo <= pi_codigo_fim
              and not exists (select 1 from grz_lojas_unificadas_cia t
                              where ge.cod_unidade = t.cod_unidade_para)
              group by substr(b.cod_completo,1,wQtd_Casas)
                       ,substr(b.cod_editado,1,wQtd_Casas1)
                       ,decode(pi_lista_unidade,1,decode(ge.cod_unidade,uni.cod_unidade_para,uni.cod_unidade_de,ge.cod_unidade),pi_grupo)

              union

              select substr(b.cod_completo,1,wQtd_Casas) cod_completo
                     ,substr(b.cod_editado,1,wQtd_Casas1) cod_editado
                     ,decode(pi_lista_unidade,1,decode(ge.cod_unidade,uni.cod_unidade_para,uni.cod_unidade_de,ge.cod_unidade),pi_grupo) cod_unidade
                     ,sum(nvl(i.qtd_sol_compra,0)) qtd_diretas
                     ,(sum((nvl(i.qtd_sol_compra,0) * nvl(i.vlr_uni_compra,0))
                        + nvl(i.vlr_ipi,0) + nvl(i.vlr_icms_st,0)
                        - nvl(i.vlr_icms,0) - nvl(i.vlr_pis,0) - nvl(i.vlr_cofins,0)) / sum(nvl(i.qtd_sol_compra,0)))
                     * sum(nvl(i.qtd_sol_compra,0)) vlr_diretas
              from ac_ordens_compra o
                   ,ac_itens_oc i
                   ,ie_mascaras b
                   ,ge_grupos_unidades ge
                   ,grz_lojas_unificadas_cia uni
              where exists (select 1
                            from ac_parcs_itens p
                            where p.dta_prev_entr >= pi_direta_ini
                            and p.dta_prev_entr <= pi_direta_fim
                            and p.num_seq_item   = i.num_seq_item
                            and p.cod_maquina    = i.cod_maquina
                            and p.num_seq        = i.num_seq)
              and (1 = pi_recebido OR not exists (select 1
                                                  from ac_recebimentos_oc r
                                                  where r.num_seq_item = i.num_seq_item
                                                  and r.cod_maquina  = i.cod_maquina
                                                  and r.num_seq      = i.num_seq))
              --and d.seq_grade is not null
              and ge.cod_unidade = uni.cod_unidade_de(+)
              and decode(ge.cod_unidade,uni.cod_unidade_de,uni.cod_unidade_para,ge.cod_unidade) = o.cod_unidade
              and ge.cod_grupo = pi_grupo
              and ge.cod_emp = pi_empresa
              and exists (select 1 from ge_grupos_unidades ge_lj -- exists para n¿o entrar o cd no select quando pi_grupo = 810, 830 etc
                          where o.cod_unidade=ge_lj.cod_unidade
                          and ge_lj.cod_grupo in (1912,1932,1942,1952,1972)
                          and ge_lj.cod_emp = pi_empresa)
              --and o.cod_oper = 100
              and o.num_seq = i.num_seq
              and o.cod_maquina = i.cod_maquina
              and b.cod_mascara = pi_mascara
              and i.cod_item = b.cod_item
              and b.Cod_Niv0    = '1'
              and b.cod_completo >= pi_codigo_ini
              and b.cod_completo <= pi_codigo_fim
              and not exists (select 1 from grz_lojas_unificadas_cia t
                              where ge.cod_unidade = t.cod_unidade_para)
             group by substr(b.cod_completo,1,wQtd_Casas)
                      ,substr(b.cod_editado,1,wQtd_Casas1)
                      ,decode(pi_lista_unidade,1,decode(ge.cod_unidade,uni.cod_unidade_para,uni.cod_unidade_de,ge.cod_unidade),pi_grupo);
       r_est_direta c_est_direta%ROWTYPE;

       -- cursor pega totais dos niveis
       cursor c_niveis is
              select substr(cod_nivel,1,wqtd_casas) cod_nivel
                     ,substr(cod_editado,1,wqtd_casas1) cod_editado
                     ,dta_ref
                     ,cod_unidade
                     ,des_unidade
                     ,sum(nvl(qtd_venda,0)) qtd_venda
                     ,sum(nvl(vlr_custo,0)) vlr_custo
                     ,sum(nvl(qtd_estoque,0)) qtd_estoque
                     ,sum(nvl(vlr_estoque,0)) vlr_estoque
                     ,sum(nvl(qtd_estoque_padrao,0)) qtd_estoque_padrao
                     ,sum(nvl(vlr_estoque_padrao,0)) vlr_estoque_padrao
                     ,sum(nvl(qtd_diretas,0)) qtd_diretas
                     ,sum(nvl(vlr_diretas,0)) vlr_diretas
              from grzw_rel_estoque_padrao
              where upper(des_usuario) = upper(pi_usuario)
              and seq_nivel = wseq_nivel
              group by substr(cod_nivel,1,wqtd_casas)
                       ,substr(cod_editado,1,wqtd_casas1)
                       ,dta_ref
                       ,cod_unidade
                       ,des_unidade;
       r_niveis c_niveis%rowtype;

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
            pi_grupo := to_number(substr(pi_opcao,(wi+1),(wf-wi-1)));
            wi := wf;
            wf := instr(pi_opcao, '#', 1, 3);
            pi_dta_ini := to_date(substr(pi_opcao,(wi+1),(wf-wi-1)));
            wi := wf;
            wf := instr(pi_opcao, '#', 1, 4);
            pi_dta_fim := to_date(substr(pi_opcao,(wi+1),(wf-wi-1)));
            wi := wf;
            wf := instr(pi_opcao, '#', 1, 5);
            pi_dta_ref := to_date(substr(pi_opcao,(wi+1),(wf-wi-1)));
            wi := wf;
            wf := instr(pi_opcao, '#', 1, 6);
            pi_direta_ini := to_date(substr(pi_opcao,(wi+1),(wf-wi-1)));
            wi := wf;
            wf := instr(pi_opcao, '#', 1, 7);
            pi_direta_fim := to_date(substr(pi_opcao,(wi+1),(wf-wi-1)));
            wi := wf;
            wf := instr(pi_opcao, '#', 1, 8);
            pi_mascara := to_number(substr(pi_opcao,(wi+1),(wf-wi-1)));
            wi := wf;
            wf := instr(pi_opcao, '#', 1, 9);
            pi_codigo_ini := substr(pi_opcao,(wi+1),(wf-wi-1));
            wi := wf;
            wf := instr(pi_opcao, '#', 1, 10);
            pi_codigo_fim := substr(pi_opcao,(wi+1),(wf-wi-1));
            wi := wf;
            wf := instr(pi_opcao, '#', 1, 11);
            pi_nivel_mascara := to_number(substr(pi_opcao,(wi+1),(wf-wi-1)));
            wi := wf;
            wf := instr(pi_opcao, '#', 1, 12);
            pi_lista_unidade := to_number(substr(pi_opcao,(wi+1),(wf-wi-1)));
            wi := wf;
            wf := instr(pi_opcao, '#', 1, 13);
            pi_recebido := to_number(substr(pi_opcao,(wi+1),(wf-wi-1)));
            wi := wf;
            wf := instr(pi_opcao, '#', 1, 14);
            pi_usuario := substr(pi_opcao,(wi+1),(wf-wi-1));

            -- Limpa a tabela temporaria
            delete from grzw_rel_estoque_padrao
            where upper(des_usuario) = upper(pi_usuario);
            commit;

            -- 1=rede 2=setor 3=grupo 4=subgrupo 5=item
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

            wCompleto_Ant := '00';

            open c_est_venda;
            fetch c_est_venda into r_est_venda;
            while c_est_venda%found loop
            begin
                 if (r_est_venda.cod_completo <> wCompleto_Ant) then
                    if (pi_nivel_mascara = 1) then
                       wCod_Anteriores := '0';
                       wCod_Nivel := substr(r_est_venda.cod_completo,1,2);
                    else
                        wCod_Anteriores := substr(r_est_venda.cod_completo,1,wQtd_Casas2);
                        wCod_Nivel      := substr(r_est_venda.COD_COMPLETO,(wQtd_Casas2 + 1),2);
                    end if;

                    if (pi_nivel_mascara = 5) then
                    begin
                         select des_item
                         into wdes_nivel
                         from ie_itens
                         where cod_item = (select cod_item
                                           from ie_mascaras
                                           where cod_mascara = 150
                                          and cod_completo = r_est_venda.cod_completo);
                          exception
                                  when no_data_found then
                                       wDes_nivel := 'SEM DESCRICAO';
                    end;
                    else
                    begin
                         select nvl(des_nivel,'X') des_nivel
                         into wDes_nivel
                         from g3_niveis_cadastro
                          where cod_mascara = pi_mascara
                         and cod_formato = '1'
                         and seq_nivel   = pi_nivel_mascara
                         and cod_anteriores = wCod_Anteriores
                         and cod_nivel = wCod_Nivel;
                         exception
                                  when no_data_found then
                                       wDes_nivel := 'SEM DESCRICAO';
                    end;
                    end if;
                    wCompleto_Ant := r_est_venda.cod_completo;
                 end if;

                 begin
                      select des_fantasia
                      into wdes_unidade
                      from ps_pessoas
                      where cod_pessoa = r_est_venda.cod_unidade;
                      exception
                               when no_data_found then
                                    wDes_Unidade := 'UNIDADE NAO CADASTRADA';
                 end;

                 begin
                      select cod_grupo
                             ,cod_quebra
                      into wcod_regiao
                           ,wcodgrupo
                      from ge_grupos_unidades
                      where cod_emp    = 1
                      and cod_unidade  = r_est_venda.cod_unidade
                      and cod_grupo in (71010,71030,71040,71050,71070);
                      exception
                      when no_data_found then
                           wcod_regiao := 0;
                           wcodgrupo := 0;
                 end;

                 begin
                      select des_quebra
                      into wdes_quebra_regiao
                      from ge_grupos_quebra
                      where cod_emp    = 1
                      and cod_quebra = wcod_regiao
                      and cod_grupo = wcodgrupo
                      group by des_quebra;
                      exception
                               when no_data_found then
                                    wDes_Quebra_Regiao  := 'Quebra grupo unidades nao cadastrado';
                 end;

                 insert into GRZW_REL_ESTOQUE_PADRAO (DES_USUARIO,COD_NIVEL,DES_NIVEL,SEQ_NIVEL
                                                      ,COD_EDITADO,DTA_REF,COD_UNIDADE,DES_UNIDADE
                                                      ,QTD_VENDA,VLR_CUSTO,QTD_ESTOQUE,VLR_ESTOQUE
                                                      ,QTD_ESTOQUE_PADRAO,VLR_ESTOQUE_PADRAO,QTD_DIRETAS
                                                      ,VLR_DIRETAS,COD_REGIAO,DES_REGIAO)
                 values (pi_usuario,r_est_venda.cod_completo,wDes_Nivel,pi_nivel_mascara
                         ,r_est_venda.cod_editado,pi_dta_ref,r_est_venda.cod_unidade
                         ,wDes_Unidade,r_est_venda.qtd_venda,r_est_venda.vlr_custo
                         ,0,0,0,0,0,0,wCod_Regiao,wDes_Quebra_Regiao);
            end;
            fetch c_est_venda into r_est_venda;
            end loop;
            close c_est_venda;
            commit;

	        wCompleto_Ant := '00';
	        open c_est;
                fetch c_est into r_est;
                while c_est%found loop
                begin
		    if (r_est.cod_completo <> wCompleto_Ant) then
		        if (pi_nivel_mascara = 1) then
 	       	            wCod_Anteriores := '0';
 	       	            wCod_Nivel      := substr(r_est.cod_completo,1,2);
		        else
 	       	            wCod_Anteriores := substr(r_est.cod_completo,1,wQtd_Casas2);
 	       	            wCod_Nivel      := substr(r_est.COD_COMPLETO,(wQtd_Casas2 + 1),2);
		        end if;
		        if (pi_nivel_mascara = 5) then
		                begin
				   select des_item
				     into wDes_nivel
				     from ie_itens
				    where cod_item = (select cod_item
				                        from ie_mascaras
				                       where cod_mascara = 150
				                         and cod_completo = r_est.cod_completo);
	      	         	  EXCEPTION
			             WHEN NO_DATA_FOUND THEN
	                        	wDes_nivel := 'SEM DESCRICAO';
		                end;
		        else
	 		        Begin
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
		        wCompleto_Ant := r_est.cod_completo;
		    end if;

 	            Begin
     	               select des_fantasia
     	       	         into wDes_Unidade
		         from ps_pessoas
		        Where cod_pessoa = r_est.cod_unidade;
      	               EXCEPTION
		         WHEN NO_DATA_FOUND THEN
                     	    wDes_Unidade := 'UNIDADE NAO CADASTRADA';
		    end;

			   Begin
              select COD_GRUPO
			        ,COD_QUEBRA
     	       into wCod_Regiao
				   ,wCodGrupo
		        from ge_grupos_unidades
                  where cod_emp    = 1
		        and cod_unidade  = r_est_venda.cod_unidade
				 and cod_grupo in (71010,71030,71040,71050,71070);
      	               EXCEPTION
		         WHEN NO_DATA_FOUND THEN
                     	    wCod_Regiao := 0;
							wCodGrupo := 0;
                end;



              Begin
                select des_quebra
                  into wDes_Quebra_Regiao
                 from ge_grupos_quebra
                  where cod_emp    = 1
                   and cod_quebra = wCod_Regiao
				   and cod_grupo = wCodGrupo
				   group by des_quebra;
                 EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                 wDes_Quebra_Regiao  := 'Quebra grupo unidades n¿o cadastrado';

                end;

                    insert into GRZW_REL_ESTOQUE_PADRAO (DES_USUARIO
                                                        ,COD_NIVEL
                                                        ,DES_NIVEL
                                                        ,SEQ_NIVEL
                                                        ,COD_EDITADO
                                                        ,DTA_REF
                                                        ,COD_UNIDADE
                                                        ,DES_UNIDADE
                                                        ,QTD_VENDA
                                                        ,VLR_CUSTO
                                                        ,QTD_ESTOQUE
                                                        ,VLR_ESTOQUE
                                                        ,QTD_ESTOQUE_PADRAO
                                                        ,VLR_ESTOQUE_PADRAO
                                                        ,QTD_DIRETAS
                                                        ,VLR_DIRETAS
														,COD_REGIAO
															 ,DES_REGIAO)
                                                 values (pi_usuario
                                                        ,r_est.cod_completo
                                                        ,wDes_Nivel
                                                        ,pi_nivel_mascara
                                                        ,r_est.cod_editado
                                                        ,pi_dta_ref
                                                        ,r_est.cod_unidade
                                                        ,wDes_Unidade
                                                        ,0
                                                        ,0
                                                        ,r_est.qtd_estoque
                                                        ,r_est.vlr_estoque
                                                        ,0
                                                        ,0
                                                        ,0
                                                        ,0
														 ,wCod_Regiao
				                                       ,wDes_Quebra_Regiao);
        	end;
        	fetch c_est into r_est;
        	end loop;
        	close c_est;
        	commit;




	        wCompleto_Ant := '00';
	        open c_est_padrao;
                fetch c_est_padrao into r_est_padrao;
                while c_est_padrao%found loop
                begin
		    if (r_est_padrao.cod_completo <> wCompleto_Ant) then
		        if (pi_nivel_mascara = 1) then
 	       	            wCod_Anteriores := '0';
 	       	            wCod_Nivel      := substr(r_est_padrao.cod_completo,1,2);
		        else
 	       	            wCod_Anteriores := substr(r_est_padrao.cod_completo,1,wQtd_Casas2);
 	       	            wCod_Nivel      := substr(r_est_padrao.COD_COMPLETO,(wQtd_Casas2 + 1),2);
		        end if;
		        if (pi_nivel_mascara = 5) then
		                begin
				   select des_item
				     into wDes_nivel
				     from ie_itens
				    where cod_item = (select cod_item
				                        from ie_mascaras
				                       where cod_mascara = 150
				                         and cod_completo = r_est_padrao.cod_completo);
	      	         	  EXCEPTION
			             WHEN NO_DATA_FOUND THEN
	                        	wDes_nivel := 'SEM DESCRICAO';
		                end;
		        else
	 		        Begin
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
		        wCompleto_Ant := r_est_padrao.cod_completo;
		    end if;

 	            Begin
     	               select des_fantasia
     	       	         into wDes_Unidade
		         from ps_pessoas
		        Where cod_pessoa = r_est_padrao.cod_unidade;
      	               EXCEPTION
		         WHEN NO_DATA_FOUND THEN
                     	    wDes_Unidade := 'UNIDADE NAO CADASTRADA';
		    end;

		    Begin
              select COD_GRUPO
			        ,COD_QUEBRA
     	       into wCod_Regiao
				   ,wCodGrupo
		        from ge_grupos_unidades
                  where cod_emp    = 1
		        and cod_unidade  = r_est_venda.cod_unidade
				 and cod_grupo in (71010,71030,71040,71050,71070);
      	               EXCEPTION
		         WHEN NO_DATA_FOUND THEN
                     	    wCod_Regiao := 0;
							wCodGrupo := 0;
                end;



              Begin
                select des_quebra
                  into wDes_Quebra_Regiao
                 from ge_grupos_quebra
                  where cod_emp    = 1
                   and cod_quebra = wCod_Regiao
				   and cod_grupo = wCodGrupo
				   group by des_quebra;
                 EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                 wDes_Quebra_Regiao  := 'Quebra grupo unidades n¿o cadastrado';

                end;

                    insert into GRZW_REL_ESTOQUE_PADRAO (DES_USUARIO
                                                        ,COD_NIVEL
                                                        ,DES_NIVEL
                                                        ,SEQ_NIVEL
                                                        ,COD_EDITADO
                                                        ,DTA_REF
                                                        ,COD_UNIDADE
                                                        ,DES_UNIDADE
                                                        ,QTD_VENDA
                                                        ,VLR_CUSTO
                                                        ,QTD_ESTOQUE
                                                        ,VLR_ESTOQUE
                                                        ,QTD_ESTOQUE_PADRAO
                                                        ,VLR_ESTOQUE_PADRAO
                                                        ,QTD_DIRETAS
                                                        ,VLR_DIRETAS
														,COD_REGIAO
															 ,DES_REGIAO)
                                                 values (pi_usuario
                                                        ,r_est_padrao.cod_completo
                                                        ,wDes_Nivel
                                                        ,pi_nivel_mascara
                                                        ,r_est_padrao.cod_editado
                                                        ,pi_dta_ref
                                                        ,r_est_padrao.cod_unidade
                                                        ,wDes_Unidade
                                                        ,0
                                                        ,0
                                                        ,0
                                                        ,0
                                                        ,r_est_padrao.qtd_estoque_padrao
                                                        ,r_est_padrao.vlr_estoque_padrao
                                                        ,0
                                                        ,0
														,wCod_Regiao
				                                         ,wDes_Quebra_Regiao);
        	end;
        	fetch c_est_padrao into r_est_padrao;
        	end loop;
        	close c_est_padrao;
        	commit;


	        wCompleto_Ant := '00';
	        open c_est_direta;
                fetch c_est_direta into r_est_direta;
                while c_est_direta%found loop
                begin
		    if (r_est_direta.cod_completo <> wCompleto_Ant) then
		        if (pi_nivel_mascara = 1) then
 	       	            wCod_Anteriores := '0';
 	       	            wCod_Nivel      := substr(r_est_direta.cod_completo,1,2);
		        else
 	       	            wCod_Anteriores := substr(r_est_direta.cod_completo,1,wQtd_Casas2);
 	       	            wCod_Nivel      := substr(r_est_direta.COD_COMPLETO,(wQtd_Casas2 + 1),2);
		        end if;
		        if (pi_nivel_mascara = 5) then
		                begin
				   select des_item
				     into wDes_nivel
				     from ie_itens
				    where cod_item = (select cod_item
				                        from ie_mascaras
				                       where cod_mascara = 150
				                         and cod_completo = r_est_direta.cod_completo);
	      	         	  EXCEPTION
			             WHEN NO_DATA_FOUND THEN
	                        	wDes_nivel := 'SEM DESCRICAO';
		                end;
		        else
	 		        Begin
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
		        wCompleto_Ant := r_est_direta.cod_completo;
		    end if;

 	            Begin
     	               select des_fantasia
     	       	         into wDes_Unidade
		         from ps_pessoas
		        Where cod_pessoa = r_est_direta.cod_unidade;
      	               EXCEPTION
		         WHEN NO_DATA_FOUND THEN
                     	    wDes_Unidade := 'UNIDADE NAO CADASTRADA';
		    end;

		    Begin
              select COD_GRUPO
			        ,COD_QUEBRA
     	       into wCod_Regiao
				   ,wCodGrupo
		        from ge_grupos_unidades
                  where cod_emp    = 1
		        and cod_unidade  = r_est_venda.cod_unidade
				 and cod_grupo in (71010,71030,71040,71050,71070);
      	               EXCEPTION
		         WHEN NO_DATA_FOUND THEN
                     	    wCod_Regiao := 0;
							wCodGrupo := 0;
                end;



              Begin
                select des_quebra
                  into wDes_Quebra_Regiao
                 from ge_grupos_quebra
                  where cod_emp    = 1
                   and cod_quebra = wCod_Regiao
				   and cod_grupo = wCodGrupo
				   group by des_quebra;
                 EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                 wDes_Quebra_Regiao  := 'Quebra grupo unidades n¿o cadastrado';

                end;

                    insert into GRZW_REL_ESTOQUE_PADRAO (DES_USUARIO
                                                        ,COD_NIVEL
                                                        ,DES_NIVEL
                                                        ,SEQ_NIVEL
                                                        ,COD_EDITADO
                                                        ,DTA_REF
                                                        ,COD_UNIDADE
                                                        ,DES_UNIDADE
                                                        ,QTD_VENDA
                                                        ,VLR_CUSTO
                                                        ,QTD_ESTOQUE
                                                        ,VLR_ESTOQUE
                                                        ,QTD_ESTOQUE_PADRAO
                                                        ,VLR_ESTOQUE_PADRAO
                                                        ,QTD_DIRETAS
                                                        ,VLR_DIRETAS
														,COD_REGIAO
															 ,DES_REGIAO)
                                                 values (pi_usuario
                                                        ,r_est_direta.cod_completo
                                                        ,wDes_Nivel
                                                        ,pi_nivel_mascara
                                                        ,r_est_direta.cod_editado
                                                        ,pi_dta_ref
                                                        ,r_est_direta.cod_unidade
                                                        ,wDes_Unidade
                                                        ,0
                                                        ,0
                                                        ,0
                                                        ,0
                                                        ,0
                                                        ,0
                                                        ,r_est_direta.qtd_diretas
                                                        ,r_est_direta.vlr_diretas
														,wCod_Regiao
				                                        ,wDes_Quebra_Regiao);
        	end;
        	fetch c_est_direta into r_est_direta;
        	end loop;
        	close c_est_direta;
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
		    else
		    	wQtd_Casas  := 8;
		    	wQtd_Casas1 := 11;
		    	wQtd_Casas2 := 6;
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
                        	    wDes_nivel := 'SEM DESCRICAO';
		         end;



                    Begin
              select COD_GRUPO
			        ,COD_QUEBRA
     	       into wCod_Regiao
				   ,wCodGrupo
		        from ge_grupos_unidades
                  where cod_emp    = 1
		        and cod_unidade  = r_est_venda.cod_unidade
				 and cod_grupo in (71010,71030,71040,71050,71070);
      	               EXCEPTION
		         WHEN NO_DATA_FOUND THEN
                     	    wCod_Regiao := 0;
							wCodGrupo := 0;
                end;



              Begin
                select des_quebra
                  into wDes_Quebra_Regiao
                 from ge_grupos_quebra
                  where cod_emp    = 1
                   and cod_quebra = wCod_Regiao
				   and cod_grupo = wCodGrupo
				   group by des_quebra;
                 EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                 wDes_Quebra_Regiao  := 'Quebra grupo unidades nao cadastrado';

                end;


                         insert into GRZW_REL_ESTOQUE_PADRAO (DES_USUARIO
                                                             ,COD_NIVEL
                                                             ,DES_NIVEL
                                                             ,SEQ_NIVEL
                                                             ,COD_EDITADO
                                                             ,DTA_REF
                                                             ,COD_UNIDADE
                                                             ,DES_UNIDADE
                                                             ,QTD_VENDA
                                                             ,VLR_CUSTO
                                                             ,QTD_ESTOQUE
                                                             ,VLR_ESTOQUE
                                                             ,QTD_ESTOQUE_PADRAO
                                                             ,VLR_ESTOQUE_PADRAO
                                                             ,QTD_DIRETAS
                                                             ,VLR_DIRETAS
															 ,COD_REGIAO
															 ,DES_REGIAO)
                                                      values (pi_usuario
                                                             ,r_niveis.COD_NIVEL
                                                             ,wDes_Nivel
                                                             ,wNivel
                                                             ,r_niveis.cod_editado
                                                             ,r_niveis.DTA_REF
                                                             ,r_niveis.cod_unidade
                                                             ,r_niveis.DES_UNIDADE
                                                             ,r_niveis.QTD_VENDA
                                                             ,r_niveis.VLR_CUSTO
                                                             ,r_niveis.QTD_ESTOQUE
                                                             ,r_niveis.VLR_ESTOQUE
                                                             ,r_niveis.QTD_ESTOQUE_PADRAO
                                                             ,r_niveis.VLR_ESTOQUE_PADRAO
                                                             ,r_niveis.QTD_DIRETAS
                                                             ,r_niveis.VLR_DIRETAS
															 ,wCod_Regiao
				                                             ,wDes_Quebra_Regiao);
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

  END;
END GRZ_REL_ESTOQUE_PADRAO_SP;
