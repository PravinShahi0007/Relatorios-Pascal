create or replace procedure grz_venda_seguro_sp(pi_opcao in varchar2)
is
begin
     declare
            pi_empresa                  number;
            pi_grupo                    number;
            pi_dta_ini                  date;
            pi_dta_fim                  date;
            pi_dta_iniano               date;
            pi_dta_fimano               date;
            pi_dta_inimes               date;
            pi_dta_fimmes               date;
            pi_usuario                  varchar2(30);
            pi_cpp                      varchar2(5);
            wi                          number;
            wf                          number;
            v_result                    integer;
            v_cur                       integer;
            wdes_grupo                  varchar2(50);
            wdes_quebra                 varchar2(50);
            wdes_unidade                varchar2(50);
            --Periodo informado
            wvlr_venda_cm_seguro        number(18,2);
            wvenda_elegiveis            number(18,2);
            wqtd_venda                  number;
            wqtd_venda_elegiveis        number;
            wvlr_venda_seguro           number(18,2);
            wqtd_seguro                 number;
            wvlr_cancelamento           number(18,2);
            wqtd_cancelados             number;
            wconversao                  number(18,2);
            wperseguro                  number(18,2);
            wmediaseguro                number(18,2);
            --Mes Anterior
            wconversaomesanterior       number(18,2);
            wperseguromesanterior       number(18,2);
            wvendamesant                number(18,2);
            wvenda_elegiveis_mesant     number(18,2);
            wqtd_venda_elegiveis_mesant number;
            wqtdvendamesant             number;
            wvlrseguromesant            number(18,2);
            wqtdseguromesant            number;
            wvlr_cancelamentomesant     number(18,2);
            wqtd_canceladosmesant       number;
            --Ano Anterior
            wconversaoanoanterior       number(18,2);
            wperseguroanoanterior       number(18,2);
            wvendaanoant                number(18,2);
            wqtdvendaanoant             number;
            wvlrseguroanoant            number(18,2);
            wqtdseguroanoant            number;
            wvlr_cancelamentoanoant     number(18,2);
            wqtd_canceladosanoant       number;
            wvenda_elegiveis_anoant     number(18,2);
            wqtd_venda_elegiveis_anoant number;

     cursor c_seguro is
            select c.cod_grupo -- Select Dani Cre
                   ,c.cod_quebra
                   ,b.cod_unidade
                   ,sum(decode(a.cod_oper,300,0,4300,0,6100,0,6200,0,nvl(a.vlr_operacao,0) - nvl(a.VLR_ENTRADA,0))) vlr_venda
                   ,count(distinct (decode(a.cod_oper,302,a.num_seq,305,a.num_seq,4302,a.num_seq,4305,a.num_seq))) qtd_venda
                   ,nvl(sum(decode(a.cod_oper,6100,nvl(a.vlr_operacao,0),6200,nvl(a.vlr_operacao,0),0)),0)  vlr_seguro
                   ,count(distinct (decode(a.cod_oper,6100,a.num_seq,6200,a.num_seq))) qtd_seguro
            from ns_notas_operacoes a,
                 ns_notas b,
                 ge_grupos_unidades c
            where a.num_seq = b.num_seq
            and b.cod_cliente_milhagem is null
            and b.cod_cliente_milhagem is null
            and b.cod_emp     = 1
            and (b.tip_nota   = 3
            or ((b.tip_nota   = 2
            and b.num_modelo  = 65)
            or (b.tip_nota    = 2
            and b.num_modelo  = 90)))
            and b.ind_status  = 1
            and b.cod_unidade = c.cod_unidade
            and c.cod_grupo   = pi_grupo
            and b.cod_unidade >= 0
            and b.cod_unidade <= 9999
            and b.dta_emissao >= pi_dta_ini
            and b.dta_emissao <= pi_dta_fim
            and not exists (select 1 from  grz_lojas_unificadas_cia  c
                            where  b.cod_emp = c.cod_emp
                            and b.COD_UNIDADE =c.COD_UNIDADE_PARA)
            and 'CRE' = pi_cpp
            group by c.cod_grupo,c.cod_quebra, b.cod_unidade

            UNION

            select c.cod_grupo -- Select CPP Jaisson
                   ,c.cod_quebra
                   ,b.cod_unidade
                   ,sum(decode(a.cod_oper,6110,0,6210,0,nvl(a.vlr_operacao,0) - nvl(a.VLR_ENTRADA,0))) vlr_venda
                   ,count(distinct (decode(a.cod_oper,3000,a.num_seq,3050,a.num_seq))) qtd_venda
                   ,nvl(sum(decode(a.cod_oper,6110,nvl(a.vlr_operacao,0),6210,nvl(a.vlr_operacao,0),0)),0)  vlr_seguro
                   ,count(distinct (decode(a.cod_oper,6110,a.num_seq,6210,a.num_seq))) qtd_seguro
            from ns_notas_operacoes a,
                 ns_notas b,
                 ge_grupos_unidades c
            where a.num_seq = b.num_seq
            and b.cod_cliente_milhagem is null
            and a.cod_maquina = b.cod_maquina
            and a.cod_oper in (3000,3050,6110,6210)
            and b.cod_emp     = 1
            and (b.tip_nota   = 3
            or (b.tip_nota    = 2
            and b.num_modelo  = 90))
            and b.ind_status  = 1
            and b.cod_unidade = c.cod_unidade
            and c.cod_grupo   = pi_grupo
            and b.cod_unidade >= 0
            and b.cod_unidade <= 9999
            and b.dta_emissao >= pi_dta_ini
            and b.dta_emissao <= pi_dta_fim
            and not exists (select 1 from  grz_lojas_unificadas_cia  c
                            where  b.cod_emp = c.cod_emp
                            and b.COD_UNIDADE =c.COD_UNIDADE_PARA)
            and 'CPP' = pi_cpp
            group by c.cod_grupo,c.cod_quebra, b.cod_unidade;
     r_seguro c_seguro%rowtype;

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
     pi_grupo := to_number(substr(pi_opcao,(wi+1),(wf-wi-1)));
     wi := wf;
     wf := instr(pi_opcao, '#', 1, 3);
     pi_dta_ini := substr(pi_opcao,(wi+1),(wf-wi-1));
     wi := wf;
     wf := instr(pi_opcao, '#', 1, 4);
     pi_dta_fim := substr(pi_opcao,(wi+1),(wf-wi-1));
     wi := wf;
     wf := instr(pi_opcao, '#', 1, 5);
     pi_dta_iniano := substr(pi_opcao,(wi+1),(wf-wi-1));
     wi := wf;
     wf := instr(pi_opcao, '#', 1, 6);
     pi_dta_fimano := substr(pi_opcao,(wi+1),(wf-wi-1));
     wi := wf;
     wf := instr(pi_opcao, '#', 1, 7);
     pi_dta_inimes := substr(pi_opcao,(wi+1),(wf-wi-1));
     wi := wf;
     wf := instr(pi_opcao, '#', 1, 8);
     pi_dta_fimmes := substr(pi_opcao,(wi+1),(wf-wi-1));
     wi := wf;
     wf := instr(pi_opcao, '#', 1, 9);
     pi_usuario := substr(pi_opcao,(wi+1),(wf-wi-1));
     wi := wf;
     wf := instr(pi_opcao, '#', 1, 10);
     pi_cpp := substr(pi_opcao,(wi+1),(wf-wi-1));

     /* Limpa a tabela temporaria */
     delete from grzw_rel_seguro
     where upper(des_usuario) = upper(pi_usuario);
     commit;

     begin
          select des_grupo
          into wdes_grupo
          from ge_grupos
          where cod_emp   = pi_empresa
          and cod_grupo = pi_grupo;
          exception
                   when no_data_found then
                        wdes_grupo := 'Grupo unidades nÃ£o cadastrado';
     end;

     open c_seguro;
     fetch c_seguro into r_seguro;
     while c_seguro%found loop
     begin
          wvlr_venda_cm_seguro := r_seguro.vlr_venda;
          wqtd_venda           := r_seguro.qtd_venda;
          wvlr_venda_seguro    := r_seguro.vlr_seguro;
          wqtd_seguro          := r_seguro.qtd_seguro;
          begin
               select des_fantasia
               into wdes_unidade
               from ps_pessoas
               where cod_pessoa = r_seguro.cod_unidade;
               exception
                        when no_data_found then
                             wdes_unidade := 'Unidade nÃ£o cadastrada';
          end;

          begin
               select des_quebra
               into wdes_quebra
               from ge_grupos_quebra
               where cod_emp    = pi_empresa
               and cod_grupo  = r_seguro.cod_grupo
               and cod_quebra = r_seguro.cod_quebra;
               exception
                        when no_data_found then
                             wdes_quebra := 'Quebra grupo unidades nÃ£o cadastrado';
          end;

          --Alterado
          if pi_CPP = 'CPP' then
          begin
               select nvl(sum(nvl(nc.vlr_ressarcido,0)),0) vlr_cancelamento
                      ,count(distinct nc.num_seq) qtd_cancelados
               into wvlr_cancelamento
                    ,wqtd_cancelados
               from ns_notas_certificados nc, ns_notas t, ns_notas_operacoes op
               where nc.num_seq = t.num_seq
               and nc.cod_maquina = t.cod_maquina
               and nc.dta_emissao = t.dta_emissao
               and op.num_seq = t.num_seq
               and op.cod_maquina = t.cod_maquina
               and op.cod_oper in (6110,6210)
               and nc.num_apolice = 0000100
               and t.cod_unidade = r_seguro.cod_unidade
               and dta_cancelamento >= pi_dta_ini
               and dta_cancelamento < pi_dta_fim +1;
               exception
                        when no_data_found then
                             wvlr_cancelamento  := 0;
                             wqtd_cancelados    := 0;
          end;
          elsif pi_CPP = 'CRE' then
          begin
               select nvl(sum(nvl(nc.vlr_ressarcido,0)),0)vlr_cancelamento
                      ,count(distinct nc.num_seq) qtd_cancelados
               into wvlr_cancelamento
                    ,wqtd_cancelados
               from ns_notas_certificados nc, ns_notas t, ns_notas_operacoes op
               where nc.num_seq = t.num_seq
               and nc.cod_maquina = t.cod_maquina
               and nc.dta_emissao = t.dta_emissao
               and op.num_seq = t.num_seq
               and op.cod_maquina = t.cod_maquina
               and op.cod_oper in (6100,6200)
               and t.cod_unidade =	 r_seguro.cod_unidade
               and dta_cancelamento >= pi_dta_ini
               and dta_cancelamento < pi_dta_fim+1;
               exception
                        when no_data_found then
                             wvlr_cancelamento  := 0;
                             wqtd_cancelados    := 0;
          end;
          end if;

          if pi_CPP = 'CPP' then -- vlr venda elegiveis e qtd elegiveis
          begin
                select nvl(sum(nvl(a.vlr_operacao,0)) - sum(nvl(a.vlr_entrada,0)),0) vlr_venda_elegiveis
                       ,count(distinct a.num_seq) qtd_venda_elegiveis
                into wvenda_elegiveis,
                     wqtd_venda_elegiveis
                from (select sum(nvl(e.vlr_operacao,0)) vlr_operacao
                             ,sum(nvl(e.vlr_entrada,0)) vlr_entrada
                             ,e.num_seq, e.cod_maquina, e.cod_oper
                      from ns_notas_operacoes e
                      where e.cod_oper in (3000,3050)
                      group by e.num_seq, e.cod_maquina, e.cod_oper) a,
                     ns_notas b,
                     ge_grupos_unidades c,
                     ps_fisicas f
                where a.num_seq   = b.num_seq
                and a.cod_maquina = b.cod_maquina
                and b.cod_emp     = 1
                and b.ind_status  = 1
                and b.tip_nota    = 3
                and b.cod_cliente = f.cod_pessoa
                and trunc((months_between(b.dta_emissao, to_date(f.dta_nasc,'dd/mm/yyyy')))/12) >= 18
                and trunc((months_between(b.dta_emissao, to_date(f.dta_nasc,'dd/mm/yyyy')))/12) <= 69
                and b.cod_unidade = c.cod_unidade
                and c.cod_grupo   = pi_grupo
                and b.cod_unidade = r_seguro.cod_unidade
                and b.dta_emissao >= pi_dta_ini
                and b.dta_emissao <= pi_dta_fim;
                --and exists (select 1 from cr_notas_origem cr  --alterado
                --where b.num_seq   = cr.num_nota
                --and b.cod_maquina = cr.cod_maquina
                --and cr.num_parcela > 2);
                exception
                         when no_data_found then
                              wvenda_elegiveis := 0;
                              wqtd_venda_elegiveis := 0;
          end;
          elsif pi_cpp = 'CRE' then
          begin
		       select nvl(sum(nvl(a.vlr_operacao,0)) - sum(nvl(a.VLR_ENTRADA,0)),0) vlr_venda_elegiveis
               ,count(distinct a.num_seq) qtd_venda_elegiveis
                   into wVenda_Elegiveis,
				         wQtd_Venda_Elegiveis
               from (select sum(nvl(e.vlr_operacao,0)) vlr_operacao, sum(nvl(e.vlr_entrada,0)) vlr_entrada, e.num_seq, e.cod_maquina, e.cod_oper
			          from ns_notas_operacoes e
                     where e.cod_oper in (302,305,4302,4305)
                     group by e.num_seq, e.cod_maquina, e.cod_oper) a,
                 ns_notas b,
                 ge_grupos_unidades c,
                 ps_fisicas f
				where a.num_seq      = b.num_seq
				 and a.cod_maquina  = b.cod_maquina
				 and b.cod_emp      = 1
				and b.ind_status   = 1
				 and b.cod_cliente  = f.cod_pessoa
				 and trunc((months_between(b.dta_emissao, to_date(f.DTA_NASC,'dd/mm/yyyy')))/12) >= 18
				 and trunc((months_between(b.dta_emissao, to_date(f.DTA_NASC,'dd/mm/yyyy')))/12) <= 69
				 and b.cod_unidade  = c.cod_unidade
				 and c.cod_grupo    = pi_grupo
				 and b.cod_unidade = r_seguro.cod_unidade
				 and b.dta_emissao >= pi_dta_ini
				 and b.dta_emissao <= pi_dta_fim
				 and exists (select 1 from cr_notas_origem cr
							   where b.num_seq      = cr.num_nota
								   and b.cod_maquina  = cr.cod_maquina
								   and cr.num_parcela > 2);
			   EXCEPTION
                 WHEN NO_DATA_FOUND THEN

				  wVenda_Elegiveis := 0;
				  wQtd_Venda_Elegiveis := 0;
            end;


		end if;

            if wVlr_cancelamento > 0 then
					wVlr_Venda_Seguro := (wVlr_Venda_Seguro - wVlr_cancelamento);
					wVlr_Venda_Cm_Seguro := (wVlr_Venda_Cm_Seguro - wVlr_cancelamento);
					wQtd_Seguro	:= 	(wQtd_Seguro	- wQtd_cancelados);
		        else
 	       	       wVlr_Venda_Cm_Seguro := r_seguro.vlr_venda;
		           wVlr_Venda_Seguro    := r_seguro.vlr_seguro;
		           wQtd_Seguro          := r_seguro.qtd_seguro;
		    end if;

            if wQtd_Seguro > 0 or wQtd_Venda_Elegiveis > 0 then
					wConversao := ((wQtd_Seguro*100)/wQtd_Venda_Elegiveis    );
		        else
 	       	      wConversao :=0;
		    end if;

            if wVlr_Venda_Seguro > 0 or wVlr_Venda_Cm_Seguro > 0 then
				wPerSeguro := ((wVlr_Venda_Seguro*100)/wVlr_Venda_Cm_Seguro);
		     else
 	       	    wPerSeguro :=0;
		    end if;


			  if wVlr_Venda_Seguro > 0 and wQtd_Seguro > 0 then
				wMediaSeguro := (((wVlr_Venda_Seguro*100) /wQtd_Seguro) /100);
		     else
 	       	    wMediaSeguro :=0;
		    end if;


             --Valores MÃªs Anterior
	if pi_CPP = 'CPP' then
	   begin
			select sum(decode(a.cod_oper,6110,0,6210,0,nvl(a.vlr_operacao,0) - nvl(a.VLR_ENTRADA,0))) vlr_venda
              ,count(distinct (decode(a.cod_oper,3000,a.num_seq,3050,a.num_seq))) qtd_venda
              ,nvl(sum(decode(a.cod_oper,6110,nvl(a.vlr_operacao,0),6210,nvl(a.vlr_operacao,0),0)),0)  vlr_seguro
              ,count(distinct (decode(a.cod_oper,3050,a.num_seq))) qtd_seguro
			  --,count(distinct (decode(a.cod_oper,6110,a.num_seq,6210,a.num_seq))) qtd_seguro
			  into wVendaMesAnt
			     ,wQtdVendaMesAnt
				 ,wVlrSeguroMesAnt
				 ,wQtdSeguroMesAnt
              from ns_notas_operacoes a,
                 ns_notas b,
                 ge_grupos_unidades c
            where a.num_seq      = b.num_seq
             and a.cod_maquina  = b.cod_maquina
             and b.cod_emp      = 1
             and (b.tip_nota     = 3
             or ((b.tip_nota     = 2
             and b.num_modelo    = 90)
             or (b.tip_nota     = 2
             and b.num_modelo   = 90)))
             and b.ind_status   = 1
             and b.cod_unidade  = c.cod_unidade
             and c.cod_grupo    = pi_grupo
             and b.cod_unidade= r_seguro.cod_unidade
             and b.dta_emissao >= pi_dta_iniMes
             and b.dta_emissao <= pi_dta_fimMes
			 and not exists (select 1 from  grz_lojas_unificadas_cia  c
									 where  b.cod_emp = c.cod_emp
                                    and b.COD_UNIDADE =c.COD_UNIDADE_PARA
									 )

             group by c.cod_grupo,c.cod_quebra, b.cod_unidade;
			EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                 wVendaMesAnt     := 0;
				 wQtdVendaMesAnt  := 0;
				 wVlrSeguroMesAnt := 0;
				 wQtdSeguroMesAnt := 0;
        end;
	elsif pi_CPP = 'CRE' then
		 begin
			select sum(decode(a.cod_oper,300,0,4300,0,6100,0,6200,0,nvl(a.vlr_operacao,0) - nvl(a.VLR_ENTRADA,0))) vlr_venda
              ,count(distinct (decode(a.cod_oper,302,a.num_seq,305,a.num_seq,4302,a.num_seq,4305,a.num_seq))) qtd_venda
              ,nvl(sum(decode(a.cod_oper,6100,nvl(a.vlr_operacao,0),6200,nvl(a.vlr_operacao,0),0)),0)  vlr_seguro
              ,count(distinct (decode(a.cod_oper,6100,a.num_seq,6200,a.num_seq))) qtd_seguro
			  into wVendaMesAnt
			     ,wQtdVendaMesAnt
				 ,wVlrSeguroMesAnt
				 ,wQtdSeguroMesAnt
              from ns_notas_operacoes a,
                 ns_notas b,
                 ge_grupos_unidades c
            where a.num_seq      = b.num_seq
             and a.cod_maquina  = b.cod_maquina
             and b.cod_emp      = 1
             and (b.tip_nota     = 3
             or ((b.tip_nota     = 2
             and b.num_modelo    = 65)
             or (b.tip_nota     = 2
             and b.num_modelo   = 90)))
             and b.ind_status   = 1
             and b.cod_unidade  = c.cod_unidade
              and c.cod_grupo    = pi_grupo
             and b.cod_unidade= r_seguro.cod_unidade
             and b.dta_emissao >= pi_dta_iniMes
             and b.dta_emissao <= pi_dta_fimMes
			 and not exists (select 1 from  grz_lojas_unificadas_cia  c
									 where  b.cod_emp = c.cod_emp
                                    and b.COD_UNIDADE =c.COD_UNIDADE_PARA
									 )

             group by c.cod_grupo,c.cod_quebra, b.cod_unidade;
			EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                 wVendaMesAnt  := 0;
				 wQtdVendaMesAnt    := 0;
				 wVlrSeguroMesAnt := 0;
				 wQtdSeguroMesAnt := 0;
        end;
	end if;

   --Alterado
		if pi_CPP = 'CPP' then
			begin
                Select nvl(sum(nvl(nc.vlr_ressarcido,0)),0) vlr_cancelamento
				      ,count(distinct nc.num_seq) qtd_cancelados

				 into wVlr_cancelamentoMesAnt
				     ,wQtd_canceladosMesAnt
					from ns_notas_certificados nc, ns_notas t, ns_notas_operacoes op
					where nc.num_seq = t.num_seq
					and nc.cod_maquina = t.cod_maquina
					and nc.dta_emissao = t.dta_emissao
					and op.num_seq = t.num_seq
					and op.cod_maquina = t.cod_maquina
                    and op.cod_oper  IN (6110,6210)
					and nc.num_apolice = 0000100
                     and t.cod_unidade =	 r_seguro.cod_unidade
 					and dta_cancelamento >= pi_dta_iniMes
					and dta_cancelamento < pi_dta_fimMes+1;
			  EXCEPTION
                 WHEN NO_DATA_FOUND THEN
					 wVlr_cancelamentoMesAnt  := 0;
					 wQtd_canceladosMesAnt    := 0;

            end;
		elsif pi_CPP = 'CRE' then
			 begin
                Select nvl(sum(nvl(nc.vlr_ressarcido,0)),0) vlr_cancelamento
				      ,count(distinct nc.num_seq) qtd_cancelados

				 into wVlr_cancelamentoMesAnt
				     ,wQtd_canceladosMesAnt
					from ns_notas_certificados nc, ns_notas t, ns_notas_operacoes op
					where nc.num_seq = t.num_seq
					and nc.cod_maquina = t.cod_maquina
					and nc.dta_emissao = t.dta_emissao
					and op.num_seq = t.num_seq
					and op.cod_maquina = t.cod_maquina
                    and op.cod_oper in (6100,6200)
                     and t.cod_unidade =	 r_seguro.cod_unidade
 					and dta_cancelamento >= pi_dta_iniMes
					and dta_cancelamento < pi_dta_fimMes+1;
			  EXCEPTION
                 WHEN NO_DATA_FOUND THEN
					 wVlr_cancelamentoMesAnt  := 0;
					 wQtd_canceladosMesAnt    := 0;

            end;


		end if;
                -- vlr venda elegiveis e qtd elegiveis
		if pi_CPP = 'CPP' then
            begin
			          select nvl(sum(nvl(a.vlr_operacao,0)) - sum(nvl(a.VLR_ENTRADA,0)),0) vlr_venda_elegiveis
               ,count(distinct a.num_seq) qtd_venda_elegiveis
                   into wVenda_Elegiveis_MesAnt,
				         wQtd_Venda_Elegiveis_MesAnt
               from (select sum(nvl(e.vlr_operacao,0)) vlr_operacao, sum(nvl(e.vlr_entrada,0)) vlr_entrada, e.num_seq, e.cod_maquina, e.cod_oper
			          from ns_notas_operacoes e
                     where e.cod_oper in (3000,3050) --Se colocar so cod_oper do cpp da erro
    				 --where e.cod_oper in (302,305,4302,4305,3000,3050,6110) --Se colocar so cod_oper do cpp da erro
                     group by e.num_seq, e.cod_maquina, e.cod_oper) a,
                 ns_notas b,
                 ge_grupos_unidades c,
                 ps_fisicas f
				where a.num_seq      = b.num_seq
				 and a.cod_maquina  = b.cod_maquina
                 and b.tip_nota     = 3
				 and b.cod_emp      = 1
				and b.ind_status   = 1
				 and b.cod_cliente  = f.cod_pessoa
			     and trunc((months_between(b.dta_emissao, to_date(f.DTA_NASC,'dd/mm/yyyy')))/12) >= 18
				 and trunc((months_between(b.dta_emissao, to_date(f.DTA_NASC,'dd/mm/yyyy')))/12) <= 69
				 and b.cod_unidade  = c.cod_unidade
				 and c.cod_grupo    = pi_grupo
				 and b.cod_unidade = r_seguro.cod_unidade
				 and b.dta_emissao >= pi_dta_iniMes
				 and b.dta_emissao <= pi_dta_fimMes;

			   EXCEPTION
                 WHEN NO_DATA_FOUND THEN

				  wVenda_Elegiveis_MesAnt := 0;
				  wQtd_Venda_Elegiveis_MesAnt := 0;
            end;
		elsif pi_CPP = 'CRE' then
			begin
			          select nvl(sum(nvl(a.vlr_operacao,0)) - sum(nvl(a.VLR_ENTRADA,0)),0) vlr_venda_elegiveis
               ,count(distinct a.num_seq) qtd_venda_elegiveis
                   into wVenda_Elegiveis_MesAnt,
				         wQtd_Venda_Elegiveis_MesAnt
               from (select sum(nvl(e.vlr_operacao,0)) vlr_operacao, sum(nvl(e.vlr_entrada,0)) vlr_entrada, e.num_seq, e.cod_maquina, e.cod_oper
			          from ns_notas_operacoes e
                     where e.cod_oper in (302,305,4302,4305)
                     group by e.num_seq, e.cod_maquina, e.cod_oper) a,
                 ns_notas b,
                 ge_grupos_unidades c,
                 ps_fisicas f
				where a.num_seq      = b.num_seq
				 and a.cod_maquina  = b.cod_maquina
				 and b.cod_emp      = 1
				and b.ind_status   = 1
				 and b.cod_cliente  = f.cod_pessoa
			     and trunc((months_between(b.dta_emissao, to_date(f.DTA_NASC,'dd/mm/yyyy')))/12) >= 18
				 and trunc((months_between(b.dta_emissao, to_date(f.DTA_NASC,'dd/mm/yyyy')))/12) <= 69
				 and b.cod_unidade  = c.cod_unidade
				 and c.cod_grupo    = pi_grupo
				 and b.cod_unidade = r_seguro.cod_unidade
				 and b.dta_emissao >= pi_dta_iniMes
				 and b.dta_emissao <= pi_dta_fimMes
				 and exists (select 1 from cr_notas_origem cr
							   where b.num_seq      = cr.num_nota
								   and b.cod_maquina  = cr.cod_maquina
								   and cr.num_parcela > 2);
			   EXCEPTION
                 WHEN NO_DATA_FOUND THEN

				  wVenda_Elegiveis_MesAnt := 0;
				  wQtd_Venda_Elegiveis_MesAnt := 0;
            end;


		end if;


            if wQtd_canceladosMesAnt > 0 then
			   wVlrSeguroMesAnt   := (wVlrSeguroMesAnt - wVlr_cancelamentoMesAnt);
			   wVendaMesAnt := (wVendaMesAnt - wVlr_cancelamentoMesAnt);
			   wQtdSeguroMesAnt   := (wQtdSeguroMesAnt	- wQtd_canceladosMesAnt);
		     else
 	       	      wVendaMesAnt := wVendaMesAnt;
			      wVlrSeguroMesAnt := wVlrSeguroMesAnt;
				  wQtdSeguroMesAnt := wQtdSeguroMesAnt ;
		    end if;



            if wQtdSeguroMesAnt > 0 and wQtd_Venda_Elegiveis_MesAnt > 0 then
				wConversaoMesAnterior := ((wQtdSeguroMesAnt*100)/wQtd_Venda_Elegiveis_MesAnt);
		    else
 	       	    wConversaoMesAnterior :=0;
		    end if;


            if wVlrSeguroMesAnt > 0 or wVendaMesAnt > 0 then
				wPerSeguroMesAnterior := ((wVlrSeguroMesAnt*100)/wVendaMesAnt);
		    else
 	       	    wPerSeguroMesAnterior :=0;
		    end if;


			--Valores Ano Anterior

			if pi_CPP = 'CPP' then
           begin
                 select sum(decode(a.cod_oper,6110,0,6210,0,nvl(a.vlr_operacao,0) - nvl(a.VLR_ENTRADA,0))) vlr_venda
              ,count(distinct (decode(a.cod_oper,3000,a.num_seq,3050,a.num_seq))) qtd_venda
              ,nvl(sum(decode(a.cod_oper,6110,nvl(a.vlr_operacao,0),6210,nvl(a.vlr_operacao,0),0)),0)  vlr_seguro
              ,count(distinct (decode(a.cod_oper,6110,a.num_seq,6210,a.num_seq))) qtd_seguro
			  into wVendaAnoAnt
			     ,wQtdVendaAnoAnt
				, wVlrSeguroAnoAnt
				 ,wQtdSeguroAnoAnt
              from ns_notas_operacoes a,
                 ns_notas b,
                 ge_grupos_unidades c
            where a.num_seq      = b.num_seq
             and a.cod_maquina  = b.cod_maquina
             and b.cod_emp      = 1
             and (b.tip_nota     = 3
             or ((b.tip_nota     = 2
             and b.num_modelo    = 90)
             or (b.tip_nota     = 2
             and b.num_modelo   = 90)))
             and b.ind_status   = 1
             and b.cod_unidade  = c.cod_unidade
               and c.cod_grupo    = pi_grupo
             and b.cod_unidade= r_seguro.cod_unidade
             and b.dta_emissao >= pi_dta_iniAno
             and b.dta_emissao <= pi_dta_fimAno
			 and not exists (select 1 from  grz_lojas_unificadas_cia  c
									 where  b.cod_emp = c.cod_emp
                   and b.COD_UNIDADE =c.COD_UNIDADE_PARA
									 )

             group by c.cod_grupo,c.cod_quebra, b.cod_unidade;
             EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                 wVendaAnoAnt  := 0;
				 wQtdVendaAnoAnt   := 0;
				 wVlrSeguroAnoAnt := 0.0;
				 wQtdSeguroAnoAnt := 0;

            end;

	elsif pi_CPP = 'CRE' then
           begin
                 select sum(decode(a.cod_oper,300,0,4300,0,6100,0,6200,0,nvl(a.vlr_operacao,0) - nvl(a.VLR_ENTRADA,0))) vlr_venda
              ,count(distinct (decode(a.cod_oper,302,a.num_seq,305,a.num_seq,4302,a.num_seq,4305,a.num_seq))) qtd_venda
              ,nvl(sum(decode(a.cod_oper,6100,nvl(a.vlr_operacao,0),6200,nvl(a.vlr_operacao,0),0)),0)  vlr_seguro
              ,count(distinct (decode(a.cod_oper,6100,a.num_seq,6200,a.num_seq))) qtd_seguro
			  into wVendaAnoAnt
			     ,wQtdVendaAnoAnt
				, wVlrSeguroAnoAnt
				 ,wQtdSeguroAnoAnt
              from ns_notas_operacoes a,
                 ns_notas b,
                 ge_grupos_unidades c
            where a.num_seq      = b.num_seq
             and a.cod_maquina  = b.cod_maquina
             and b.cod_emp      = 1
             and (b.tip_nota     = 3
             or ((b.tip_nota     = 2
             and b.num_modelo    = 65)
             or (b.tip_nota     = 2
             and b.num_modelo   = 90)))
             and b.ind_status   = 1
             and b.cod_unidade  = c.cod_unidade
               and c.cod_grupo    = pi_grupo
             and b.cod_unidade= r_seguro.cod_unidade
             and b.dta_emissao >= pi_dta_iniAno
             and b.dta_emissao <= pi_dta_fimAno
			 and not exists (select 1 from  grz_lojas_unificadas_cia  c
									 where  b.cod_emp = c.cod_emp
                   and b.COD_UNIDADE =c.COD_UNIDADE_PARA
									 )

             group by c.cod_grupo,c.cod_quebra, b.cod_unidade;
             EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                 wVendaAnoAnt  := 0;
				 wQtdVendaAnoAnt   := 0;
				 wVlrSeguroAnoAnt := 0.0;
				 wQtdSeguroAnoAnt := 0;

            end;
		end if;

		if pi_CPP = 'CPP' then
	--Alterado
    --ns_notas_certificados num_apolice = 0000100  -- CPP
            begin
                Select nvl(sum(nvl(nc.vlr_ressarcido,0)),0) vlr_cancelamento
				      ,count(distinct nc.num_seq) qtd_cancelados
				 into wVlr_cancelamentoAnoAnt
				     ,wQtd_canceladosAnoAnt
					from ns_notas_certificados nc, ns_notas t, ns_notas_operacoes op
					where nc.num_seq = t.num_seq
					and nc.cod_maquina = t.cod_maquina
					and nc.dta_emissao = t.dta_emissao
					and op.num_seq = t.num_seq
					and op.cod_maquina = t.cod_maquina
                    and op.cod_oper in (6110,6210)
					and nc.num_apolice = 0000100
                    and t.cod_unidade =	 r_seguro.cod_unidade
					and dta_cancelamento >= pi_dta_iniAno
					and dta_cancelamento < pi_dta_fimAno+1
				 group by t.cod_unidade;
				EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                 wVlr_cancelamentoAnoAnt  := 0;
				 wQtd_canceladosAnoAnt    := 0;

            end;
		elsif pi_CPP = 'CRE' then
		 begin
                Select nvl(sum(nvl(nc.vlr_ressarcido,0)),0) vlr_cancelamento
				      ,count(distinct nc.num_seq) qtd_cancelados
				 into wVlr_cancelamentoAnoAnt
				     ,wQtd_canceladosAnoAnt
					from ns_notas_certificados nc, ns_notas t, ns_notas_operacoes op
					where nc.num_seq = t.num_seq
					and nc.cod_maquina = t.cod_maquina
					and nc.dta_emissao = t.dta_emissao
					and op.num_seq = t.num_seq
					and op.cod_maquina = t.cod_maquina
                    and op.cod_oper in (6100,6200)
                    and t.cod_unidade =	 r_seguro.cod_unidade
					and dta_cancelamento >= pi_dta_iniAno
					and dta_cancelamento < pi_dta_fimAno+1
				 group by t.cod_unidade;
				EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                 wVlr_cancelamentoAnoAnt  := 0;
				 wQtd_canceladosAnoAnt    := 0;

            end;

		end if;


			if wQtd_canceladosAnoAnt > 0 then
				wVlrSeguroAnoAnt   := (wVlrSeguroAnoAnt - wVlr_cancelamentoAnoAnt);
				wVendaAnoAnt := (wVendaAnoAnt - wVlr_cancelamentoAnoAnt);
				wQtdSeguroAnoAnt   := (wQtdSeguroAnoAnt	- wQtd_canceladosAnoAnt);
			 else
				wVendaAnoAnt := wVendaAnoAnt;
				wVlrSeguroAnoAnt := wVlrSeguroAnoAnt;
				wQtdSeguroAnoAnt := wQtdSeguroAnoAnt ;
			end if;

		if pi_CPP = 'CPP' then
            -- vlr venda elegiveis e qtd elegiveis
            begin
			      select nvl(sum(nvl(a.vlr_operacao,0)) - sum(nvl(a.VLR_ENTRADA,0)),0) vlr_venda_elegiveis
               ,count(distinct a.num_seq) qtd_venda_elegiveis
                   into wVenda_Elegiveis_AnoAnt,
				         wQtd_Venda_Elegiveis_AnoAnt
               from (select sum(nvl(e.vlr_operacao,0)) vlr_operacao, sum(nvl(e.vlr_entrada,0)) vlr_entrada, e.num_seq, e.cod_maquina, e.cod_oper
			          from ns_notas_operacoes e
                     where e.cod_oper in (3000,3050)
                     group by e.num_seq, e.cod_maquina, e.cod_oper) a,
                 ns_notas b,
                 ge_grupos_unidades c,
                 ps_fisicas f
				where a.num_seq      = b.num_seq
				 and a.cod_maquina  = b.cod_maquina
                 and b.tip_nota     = 3
				 and b.cod_emp      = 1
				and b.ind_status   = 1
				 and b.cod_cliente  = f.cod_pessoa
				and trunc((months_between(b.dta_emissao, to_date(f.DTA_NASC,'dd/mm/yyyy')))/12) >= 18
				 and trunc((months_between(b.dta_emissao, to_date(f.DTA_NASC,'dd/mm/yyyy')))/12) <= 69
				 and b.cod_unidade  = c.cod_unidade
				 and c.cod_grupo    = pi_grupo
				 and b.cod_unidade = r_seguro.cod_unidade
				 and b.dta_emissao >= pi_dta_iniAno
				 and b.dta_emissao <= pi_dta_fimAno;

			   EXCEPTION
                 WHEN NO_DATA_FOUND THEN

				  wVenda_Elegiveis_AnoAnt := 0;
				  wQtd_Venda_Elegiveis_AnoAnt := 0;
            end;
		elsif pi_CPP = 'CRE' then

		 begin
			      select nvl(sum(nvl(a.vlr_operacao,0)) - sum(nvl(a.VLR_ENTRADA,0)),0) vlr_venda_elegiveis
               ,count(distinct a.num_seq) qtd_venda_elegiveis
                   into wVenda_Elegiveis_AnoAnt,
				         wQtd_Venda_Elegiveis_AnoAnt
               from (select sum(nvl(e.vlr_operacao,0)) vlr_operacao, sum(nvl(e.vlr_entrada,0)) vlr_entrada, e.num_seq, e.cod_maquina, e.cod_oper
			          from ns_notas_operacoes e
                     where e.cod_oper in (302,305,4302,4305)
                     group by e.num_seq, e.cod_maquina, e.cod_oper) a,
                 ns_notas b,
                 ge_grupos_unidades c,
                 ps_fisicas f
				where a.num_seq      = b.num_seq
				 and a.cod_maquina  = b.cod_maquina
                 and b.tip_nota     = 3
				 and b.cod_emp      = 1
				and b.ind_status   = 1
				 and b.cod_cliente  = f.cod_pessoa
				and trunc((months_between(b.dta_emissao, to_date(f.DTA_NASC,'dd/mm/yyyy')))/12) >= 18
				 and trunc((months_between(b.dta_emissao, to_date(f.DTA_NASC,'dd/mm/yyyy')))/12) <= 69
				 and b.cod_unidade  = c.cod_unidade
				 and c.cod_grupo    = pi_grupo
				 and b.cod_unidade = r_seguro.cod_unidade
				 and b.dta_emissao >= pi_dta_iniAno
				 and b.dta_emissao <= pi_dta_fimAno
				 and exists (select 1 from cr_notas_origem cr
							   where b.num_seq      = cr.num_nota
								   and b.cod_maquina  = cr.cod_maquina
								   and cr.num_parcela > 2);
			   EXCEPTION
                 WHEN NO_DATA_FOUND THEN

				  wVenda_Elegiveis_AnoAnt := 0;
				  wQtd_Venda_Elegiveis_AnoAnt := 0;
            end;

		end if;

		if wQtdSeguroAnoAnt > 0 and wQtd_Venda_Elegiveis_AnoAnt > 0  then
			   wConversaoAnoAnterior := ((wQtdSeguroAnoAnt*100)/wQtd_Venda_Elegiveis_AnoAnt);
		      else
 	       	    wConversaoAnoAnterior :=0;
		    end if;

           if wVlrSeguroAnoAnt > 0 and wVendaAnoAnt > 0 then
			  wPerSeguroAnoAnterior := ((wVlrSeguroAnoAnt*100)/wVendaAnoAnt);
             else
 	       	  wPerSeguroAnoAnterior :=0;
		    end if;


	      insert into GRZW_REL_SEGURO
			    ( DES_USUARIO
				 ,COD_GRUPO
				 ,DES_GRUPO
				 ,COD_QUEBRA
				 ,DES_QUEBRA
				 ,COD_UNIDADE
				 ,DES_UNIDADE
				 ,VLR_VENDA
				 ,QTD_VENDA
				 ,VLR_SEGURO
				 ,QTD_SEGURO
				 ,VLR_CANCELAMENTO
				 ,QTD_CANCELADOS
				 ,PERC_CONVERSAO
				 ,PERC_SEGURO
				 ,VLR_VENDA_MESANT
				 ,QTD_VENDA_MESANT
				 ,VLR_SEGURO_MESANT
				 ,QTD_SEGURO_MESANT
				 ,VLR_CANCELAMENTO_MESANT
				 ,QTD_CANCELAMENTO_MESANT
				 ,PER_CONVERSAO_MESANT
				 ,PERC_SEGURO_MESANT
				 ,VLR_VENDA_ANOANT
				 ,QTD_VENDA_ANOANT
				 ,VLR_SEGURO_ANOANT
				 ,QTD_SEGURO_ANOANT
				 ,VLR_CANCELAMENTO_ANOANT
				 ,QTD_CANCELAMENTO_ANOANT
				 ,PER_CONVERSAO_ANOANT
				 ,PERC_SEGURO_ANOANT
				 ,MEDIA_SEGURO
                 ,VLR_VENDA_ELEGIVEIS
                 ,QTD_VENDA_ELEGIVEIS
				 ,VLR_VENDA_ELEGIVEIS_MESANT
                 ,QTD_VENDA_ELEGIVEIS_MESANT
				 ,VLR_VENDA_ELEGIVEIS_ANOANT
				 ,QTD_VENDA_ELEGIVEIS_ANOANT
				 )
                values (upper(pi_usuario)
                            ,r_seguro.cod_grupo
							,wDes_Grupo
							,r_seguro.cod_quebra
							,wDes_Quebra
							,r_seguro.cod_unidade
							,wDes_Unidade
							,wVlr_Venda_Cm_Seguro
							,wQtd_Venda
							,wVlr_Venda_Seguro
							,wQtd_Seguro
							,wVlr_cancelamento
							,wQtd_cancelados
							,wConversao
							,wPerSeguro
							,wVendaMesAnt
							,wQtdVendaMesAnt
							,wVlrSeguroMesAnt
							,wQtdSeguroMesAnt
							,wVlr_cancelamentoMesAnt
							,wQtd_canceladosMesAnt
							,wConversaoMesAnterior
							,wPerSeguroMesAnterior
							,wVendaAnoAnt
							,wQtdVendaAnoAnt
							,wVlrSeguroAnoAnt
							,wQtdSeguroAnoAnt
							,wVlr_cancelamentoAnoAnt
							,wQtd_canceladosAnoAnt
							,wConversaoAnoAnterior
							,wPerSeguroAnoAnterior
							,wMediaSeguro
							,wVenda_Elegiveis
				            ,wQtd_Venda_Elegiveis
				            ,wVenda_Elegiveis_MesAnt
				            ,wQtd_Venda_Elegiveis_MesAnt
				            ,wVenda_Elegiveis_AnoAnt
				            ,wQtd_Venda_Elegiveis_AnoAnt
				        );


   END;
	      FETCH c_seguro INTO r_seguro;
	    END LOOP;
	CLOSE c_seguro;

    COMMIT;

    END;
  END GRZ_VENDA_SEGURO_SP;
