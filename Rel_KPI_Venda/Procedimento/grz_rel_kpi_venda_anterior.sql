create or replace procedure grz_rel_kpi_venda (pi_opcao in varchar2)
is
begin
     declare
            wi                 number;
            wf                 number;

            pi_empresa         number;
            pi_dta_ini         date;
            pi_dta_fim         date;
            pi_unidadeini      number;
            pi_unidadefim      number;
            wdia               number(2);
            wmes               number(2);
            wano               number(4);
            wdes_quebra        varchar2(50);
            wdes_grupo         varchar2(50);
            wcod_unidade       number;
            wcod_grupo_macro   number;
            wdes_grupo_macro   varchar2(50);
            wdes_rede          varchar2(50);
            wdes_cidade        varchar2(50);
            wdes_uf            varchar2(50);
            wcontrole          number;
            wcontroleunidade   number;
            wticket_medio      number(18,2);
            wperc_whats        number(18,2);
            wperc_demost       number(18,2);
            wperc_vd_prazo     number(18,2);
            wperc_acresc       number(18,2);
            wperc_seguro       number(18,2);
            wqtdcpp            number;
            wvlrcpp            number(18,2);
            wgztstorerede      number;
            wgztstoreunidade   number;
            wgztstoreunidadede number;
            wcodunidade        number;
            wcodrede           number;
            wcod_regiao        number;
            wcod_regiaonova    number;
            wcod_unidadenova   number;

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
                   ,sum(decode(notas.cod_oper,302,(nvl(notas.vlr_operacao,0) - nvl(notas.vlr_entrada,0)),0)) vlr_venda_prazo
                   ,sum(decode(notas.cod_oper,302,nvl(notas.vlr_acrescimo,0),0)) vlr_acrescimo
                   ,sum(decode(notas.cod_oper,6100,nvl(notas.vlr_operacao,0),0)) vlr_seguro
            from ns_notas a
                 ,(select ns.num_seq,ns.cod_maquina,decode(nso.cod_oper,300,300,4300,300,6100,6100,302) cod_oper
                          ,sum(nvl(nso.vlr_acrescimo,0) + nvl(nso.vlr_acrescimo_cob,0)) vlr_acrescimo
                          ,sum(nvl(nso.vlr_operacao,0)) vlr_operacao
                          ,sum(nvl(nso.vlr_entrada,0)) vlr_entrada
                   from ns_notas ns
                        ,ns_notas_operacoes nso
                   where nso.num_seq = ns.num_seq
                   and nso.cod_maquina = ns.cod_maquina
                   and nso.cod_oper in (300,302,305,4300,4302,4305,6100)
                   and ns.cod_emp = 1
                   and ns.dta_emissao >= pi_dta_ini
                   and ns.dta_emissao <= pi_dta_fim
                   and ns.tip_nota in (2,3)
                   and ns.ind_status = 1
                   group by ns.num_seq,ns.cod_maquina,decode(nso.cod_oper,300,300,4300,300,6100,6100,302) ) notas
                 ,(select nsw.num_seq,nsw.cod_maquina
                          ,sum(nvl(nsow.vlr_operacao,0)) vlr_vda_whats
                   from ns_notas nsw
                        ,ns_notas_operacoes nsow
                        ,(select sislog.cod_unidade,
                                 sislog.num_cupom,
                                 sislog.num_equipamento,
                                 sislog.dta_lancamento
                                 ,sum(sislog.vlr_total) vlr_total
                          from grz_lojas_cupom_itens sislog
                          where sislog.dta_lancamento >= pi_dta_ini
                          and sislog.dta_lancamento <= pi_dta_fim
                          and nvl(sislog.ind_venda_whatsapp,0) = 1
                          and sislog.ind_cancelado = 0
                          and sislog.ind_cancelado_item = 0
                          group by sislog.cod_unidade,
                                   sislog.num_cupom,
                                   sislog.num_equipamento,
                                   sislog.dta_lancamento ) vda_whats
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
                   group by nsw.num_seq,nsw.cod_maquina ) venda_whats
                 ,(select nsd.num_seq,nsd.cod_maquina,decode(nsod.cod_oper,300,300,4300,300,302) cod_oper
                         ,sum(nvl(nsod.vlr_operacao,0)) vlr_vda_demo
                   from ns_notas nsd
                        ,ns_notas_operacoes nsod
                   where exists (select 1 
                                 from ne_notas ne
                                      ,ne_notas_operacoes neo
							 where neo.num_seq        = ne.num_seq
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
			       group by nsd.num_seq,nsd.cod_maquina,decode(nsod.cod_oper,300,300,4300,300,302) ) venda_demo
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
			and gu.cod_emp    = pi_empresa
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
			and a.dta_emissao>= pi_dta_ini
			and a.dta_emissao<=pi_dta_fim
			and a.tip_nota in (2,3)
			and a.ind_status = 1
			/*and  exists (select 1 from  ge_grupos_unidades  c
							where c.cod_unidade = a.cod_unidade
                            and c.cod_grupo in (1912,1932,1942,1952,1972)
									 )*/
			having sum(nvl(notas.vlr_operacao,0)) > 0
				group by  a.dta_emissao,
            gu.cod_grupo
			,gu.cod_quebra
			,a.cod_unidade
			,decode(g.cod_nivel2,810,'10',830,'30',840,'40',850,'50','870','70')
			,decode(g.cod_nivel2,810,'GRZ',830,'PRM',840,'FRG',850,'TOT','GZT')
			,g1.des_cidade
			,g1.cod_uf
			order by 4,1;

       r_venda c_venda%ROWTYPE;


          /**** Inicio da procedure principal ****/
  BEGIN

           wi := INSTR(pi_opcao, '#', 1, 1);
	       pi_empresa := TO_NUMBER(SUBSTR(pi_opcao, 1,(wi-1)));
	       wf := INSTR(pi_opcao, '#', 1, 2);
   	       pi_dta_ini := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));
           wi := wf;
	       wf := INSTR(pi_opcao, '#', 1, 3);
   	       pi_dta_fim := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));
           wi := wf;
	       wf := INSTR(pi_opcao, '#', 1, 4);
   	       pi_UnidadeIni := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));
           wi := wf;
		   wf := INSTR(pi_opcao, '#', 1, 5);
           pi_UnidadeFim := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));

       wControle := 0;
	   wControleUnidade := 0;

            begin
    Delete from GRZ_KPI_VENDAS
         where dta_movimento >= pi_dta_ini
         and dta_movimento <= pi_dta_fim;
           end;


     OPEN c_venda;
      FETCH c_venda INTO r_venda;
       WHILE c_venda%FOUND LOOP

      BEGIN

            wDia := to_char(r_venda.dta_movimento ,'DD');
            wMes      := to_char(r_venda.dta_movimento ,'MM');
	        wAno      := to_char(r_venda.dta_movimento ,'YYYY');
			wCodUnidade := r_venda.cod_unidade;
			wCod_Regiao := r_venda.cod_regiao;





			   Begin
                select count((nsod.cod_oper))
					  ,nvl(sum(nvl(nsod.vlr_operacao,0)),0)
					  Into wQtdCPP
					      ,wVlrCPP
		     	   from ns_notas nsd
				   ,ns_notas_operacoes nsod
                	where  nsod.num_seq = nsd.num_seq
			                   and nsod.cod_maquina = nsd.cod_maquina
							   and nsod.cod_oper in (3000,3050)
							   and nsd.cod_emp = 1
                               and nsd.cod_unidade = r_venda.cod_unidade
							   and nsd.dta_emissao >= r_venda.dta_movimento
							   and nsd.dta_emissao <= r_venda.dta_movimento ;
                 EXCEPTION
                 WHEN NO_DATA_FOUND THEN

				  wQtdCPP := 0;
                  wVlrCPP := 0;
                end;





			  if r_venda.vlr_venda > 0 or r_venda.qtd_negocio > 0 then
			   wTicket_medio := (r_venda.vlr_venda/r_venda.qtd_negocio);
		      else
 	       	    wTicket_medio :=0;
		    end if;

			  if r_venda.vlr_venda_whats > 0 or r_venda.vlr_venda > 0 then
			   wPerc_whats := ((r_venda.vlr_venda_whats*100)/r_venda.vlr_venda);
		      else
 	       	    wPerc_whats :=0;
		    end if;

			  if r_venda.vlr_demost > 0 or r_venda.vlr_venda > 0 then
			  wPerc_demost := ((r_venda.vlr_demost*100)/r_venda.vlr_venda);
		      else
 	       	    wPerc_demost :=0;
		    end if;

			 if r_venda.vlr_venda_prazo > 0 or r_venda.vlr_venda > 0 then
			  wPerc_vd_prazo := ((r_venda.vlr_venda_prazo*100)/r_venda.vlr_venda);
		      else
 	       	    wPerc_vd_prazo :=0;
		    end if;

			if r_venda.vlr_acrescimo > 0 or r_venda.vlr_venda_prazo > 0 then
			 wPerc_acresc := ((r_venda.vlr_acrescimo*100)/r_venda.vlr_venda_prazo);
		      else
 	       	    wPerc_acresc :=0;
		    end if;

				if r_venda.vlr_seguro > 0 or r_venda.vlr_venda_prazo > 0 then
			wPerc_seguro	 := ((r_venda.vlr_seguro*100)/r_venda.vlr_venda_prazo);
		      else
 	       	    wPerc_seguro :=0;
		    end if;



             wCodRede	:= r_venda.cod_rede;



		  wGztStoreRede      := 0;
		  wGztStoreUnidade   := 0;
		  wGztStoreUnidadeDe := 0;

			begin

		     select cod_rede_para
			      ,cod_unidade_para
				  ,cod_unidade_DE
				  into wGztStoreRede
				      ,wGztStoreUnidade
					  ,wGztStoreUnidadeDe
		     from grazz.grz_lojas_gzt_store a
			 where a.cod_unidade_de = r_venda.cod_unidade;
              EXCEPTION
	            WHEN NO_DATA_FOUND THEN
				  wGztStoreRede := 0;
				  wGztStoreUnidade := 0;
				  wGztStoreUnidadeDe := 0;

			end;


		  if  wCodUnidade  =  wGztStoreUnidadeDe  then
			    wCodUnidade := wGztStoreUnidade;
				wCodRede := wGztStoreRede;
				wDes_Rede := 'GZT';
		      else
 	       	   wCodUnidade := r_venda.cod_unidade;
			   wCodRede := r_venda.cod_rede;
			   wDes_Rede := r_venda.des_rede;
		    end if;



			if  wCod_Regiao = 9999  then



			     Begin
                 select cod_unidade_para
                  into wCod_UnidadeNova
                 from grazz.grz_lojas_gzt_store
				 where cod_unidade_de = r_venda.cod_unidade;
                 EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                 wCod_UnidadeNova  := 0;
                end;

				Begin
                 select cod_regiao
				 into wCod_RegiaoNova
				 from grazz.grz_lojas
				 where cod_loja = wCod_UnidadeNova;
                 EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                 wCod_RegiaoNova  := 0;
                end;


			    Begin
                  select des_quebra
                  into wDes_Quebra
                 from ge_grupos_quebra
                  where cod_emp    = 1
                   --and cod_grupo  = r_venda.cod_grupo
                   and cod_quebra = wCod_RegiaoNova
				    group by des_quebra;
                 EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                 wDes_Quebra  := 'Quebra grupo unidades n¿o cadastrado';


                end;
				 wCod_Regiao := wCod_RegiaoNova;

		      else

			     Begin
                 select des_quebra
                  into wDes_Quebra
                 from ge_grupos_quebra
                  where cod_emp    = 1
                   --and cod_grupo  = r_venda.cod_grupo
                   and cod_quebra = wCod_Regiao
				    group by des_quebra;
                 EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                 wDes_Quebra  := 'Quebra grupo unidades n¿o cadastrado';

                end;



		    end if;




			 if  wControleUnidade <> r_venda.cod_unidade	 then

                Begin
                select cod_grupo
                  into wCod_grupo_macro
                 from ge_grupos_unidades ge
                  where  cod_unidade = wCodUnidade
                    and cod_grupo in (1739,1740,1741);
                 EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                 wCod_grupo_macro  := 0;
                end;


		       Begin
                select des_grupo
                  into wDes_grupo_macro
                 from ge_grupos
                  where  cod_emp = 1
                    and cod_grupo = wCod_grupo_macro;
                 EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                 wDes_grupo_macro  := 'Quebra grupo unidades n¿o cadastrado';
                end;

           end if;


          wControle:= r_venda.cod_regiao;
          wControleUnidade	:= r_venda.cod_unidade;

	      insert into GRZ_KPI_VENDAS (
			          DTA_MOVIMENTO
					 ,DIA
					 ,MES
					 ,ANO
					 ,COD_REDE
					 ,DES_REDE
					 ,COD_UNIDADE
					 ,COD_REGIAO
					 ,DES_REGIAO
					 ,DES_CIDADE
					 ,DES_UF
					 ,QTD_NEGOCIO
					 ,VLR_VD
					 ,TICKET_MEDIO
					 ,VLR_VD_WHATS
					 ,PERC_WHATS
					 ,VLR_DEMOST
					 ,PERC_DEMOST
					 ,VLR_VD_PRAZO
					 ,PERC_VD_PRAZO
					 ,VLR_ACRESC
					 ,PERC_ACRESC
					 ,VLR_SEGURO
					 ,PERC_SEGURO
					 ,IND_NIVEL
                     ,COD_GRUPO_MACRO
                     ,DES_GRUPO_MACRO
                     ,QTD_CPP
                     ,VLR_CPP
				 )
                values ( r_venda.dta_movimento
                         ,wDia
                         ,wMes
	                     ,wAno
						 ,wCodRede --r_venda.cod_rede
                         ,wDes_Rede --r_venda.des_rede
						 ,wCodUnidade -- r_venda.cod_unidade
						   ,wCod_Regiao --r_venda.cod_regiao
						 ,wDes_Quebra
							,r_venda.des_cidade
							,r_venda.des_uf
							,r_venda.qtd_negocio
							,r_venda.vlr_venda
							,wTicket_medio
							,r_venda.vlr_venda_whats
							,wPerc_whats
							,r_venda.vlr_demost
							,wPerc_demost
							,r_venda.vlr_venda_prazo
							,wPerc_vd_prazo
							,r_venda.vlr_acrescimo
							,wPerc_acresc
							,r_venda.vlr_seguro
							,wPerc_seguro
                           ,1
                           ,wCod_grupo_macro
                           ,wDes_grupo_macro
                           ,wQtdCPP
						   ,wVlrCPP

				        );
	                EXCEPTION
		             WHEN dup_val_on_index THEN
		     UPDATE GRZ_KPI_VENDAS
                     set  QTD_NEGOCIO  = QTD_NEGOCIO + r_venda.qtd_negocio
					    , VLR_VD    =  VLR_VD  + r_venda.vlr_venda
					    , TICKET_MEDIO  =  ((VLR_VD + r_venda.vlr_venda)/(QTD_NEGOCIO +r_venda.qtd_negocio))
					    , VLR_VD_WHATS  = VLR_VD_WHATS+ r_venda.vlr_venda_whats
                        , PERC_WHATS   =  (((VLR_VD_WHATS + r_venda.vlr_venda_whats)*100)/(VLR_VD+r_venda.vlr_venda))
                        , VLR_DEMOST   =  VLR_DEMOST+ r_venda.vlr_demost
					    , PERC_DEMOST  =   (((VLR_DEMOST+r_venda.vlr_demost)*100)/(VLR_VD+r_venda.vlr_venda))
					    , VLR_VD_PRAZO   =  VLR_VD_PRAZO+ r_venda.vlr_venda_prazo
					    , PERC_VD_PRAZO =    (((VLR_VD_PRAZO+r_venda.vlr_venda_prazo)*100)/(VLR_VD+r_venda.vlr_venda))
					    , VLR_ACRESC  =  VLR_ACRESC+ r_venda.vlr_acrescimo
					    , PERC_ACRESC   =     (((VLR_ACRESC+r_venda.vlr_acrescimo)*100)/(VLR_VD_PRAZO+r_venda.vlr_venda_prazo))
					    , VLR_SEGURO   = VLR_SEGURO +r_venda.vlr_seguro
					    , PERC_SEGURO  =       (((VLR_SEGURO+r_venda.vlr_seguro)*100)/(VLR_VD_PRAZO+r_venda.vlr_venda_prazo))
					    , IND_NIVEL = 1
                        , QTD_CPP =  QTD_CPP + wQtdCPP
                        , VLR_CPP = VLR_CPP + wVlrCPP
				    WHERE COD_REDE = wCodRede
					  AND COD_UNIDADE = wCodUnidade
					  AND DTA_MOVIMENTO = r_venda.dta_movimento ;



   END;
	      FETCH c_venda INTO r_venda;
	    END LOOP;
	CLOSE c_venda;

    COMMIT;

    END;
  END GRZ_REL_KPI_VENDA;
