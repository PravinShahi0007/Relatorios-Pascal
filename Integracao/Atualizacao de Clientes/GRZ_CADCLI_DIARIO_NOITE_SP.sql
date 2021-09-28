create or replace procedure grz_cadcli_diario_noite_sp
--create or replace procedure grzcadclidiarionoitesp_teste
is
begin
     declare icount                  number;
             v_result                integer;
             v_cur                   integer;

             wcod_reduzido           number;
             werro                   number;
             wdata                   varchar2(20);
             wdta_mvto               date;
             wtabela                 varchar2(50);
             wsqlcode                varchar2(2000);
             wpi_where               varchar2(100);
             wpi_opcao               varchar2(200);
             wpo_erro                varchar2(100);
             wtodasredes             varchar2(15);
             wdta_nasc_nl            varchar2(100);
             wnum_cpf_nl             varchar2(100);
             wdes_mae_nl             varchar2(100);
             wnum_cgc_nl             varchar2(100);
             wdta_fundacao_nl        varchar2(100);
             wnum_insc_est_nl        varchar2(100);
             watividade_cli          varchar2(04);
             wlimite_cli             number;
             wcod_unidade_cli_nl     number;
             wdtaafastamentolj       varchar2(10);
             wind_emite_cartao       number; -- variavel de controle de cart¿es
             wnum_reemissao_cartao   number;
             wtem_cartao_adic        number;
             wtemobsloja             number;
             wexistefone             number;
             wdia_da_semana          number;

             --registro ai_ps_pessoas - 10
             wnum_rede               varchar2(100);
             --wcod_pesso            varchar2(100);
             wdes_pessoa             varchar2(100);
             wcod_regiao             varchar2(100);
             wcod_atividade          varchar2(100);
             wdes_fantasia           varchar2(100);
             wdes_endereco           varchar2(100);
             wdes_ponto_referencia   varchar2(100);
             wdes_bairro             varchar2(100);
             wnum_cep                varchar2(100);
             wdes_email              varchar2(100);
             wcod_negativacao        varchar2(100);
             wcod_negativacao_serasa varchar2(100);
             wdes_pessoa_nl          varchar2(100);

             --registro ai_ps_clientes - 20
             wcod_classe_venda       varchar2(100);
             wcod_cond_pgto          varchar2(100);

             --registro ai_ps_fisicas - 30
             wdta_nasc               varchar2(100);
             wnum_cpf                varchar2(100);
             wvlr_aluguel            varchar2(100);
             wvlr_renda              varchar2(100);
             wdes_conjuge            varchar2(100);
             wdes_pai                varchar2(100);
             wdes_mae                varchar2(100);

             --registro ai_ps_juridicas - 35
             wnum_insc_est           varchar2(100);
             wnum_cgc                varchar2(100);
             wdta_fundacao           varchar2(100);

             --registro ai_ps_telefones - 50
             wnum_seq                varchar2(100);
             wnum_fone               varchar2(100);
             wdes_fone               varchar2(100);

             --registro ai_ps_prof_clientes - 65
             wdes_emp                varchar2(100);
             wvlr_salario            varchar2(100);
             wcod_funcao             varchar2(100);
             wcompl_endereco         varchar2(100);
             wcod_cidade_empresa     varchar2(100);
             wnum_end_empresa        varchar2(100);
             wtip_funcao             varchar2(100);

             --registro ai_ps_ref_clientes - 70
             wdes_ref                varchar2(100);

             --registro ai_ps_cartoes - 75
             wdes_imp                varchar2(100);
             wnum_reemissao          varchar2(100);
             wind_emite              varchar2(100);
             wdta_nasc_cartao        varchar2(100);
             wdta_validade           varchar2(100);
             wdta_fechamento         varchar2(100);
             wcod_situacao           varchar2(100);
             wcod_cartao             varchar2(100);
             wcod_tipo_cartao        varchar2(100);
             wdta_solicitacao        varchar2(100);
             wdta_remessa_cartao     varchar2(100);

             --registro ai_ps_cartoes_adicionais - 80
             wnum_adic               varchar2(100);
             wdes_parentesco         varchar2(100);
             wnome_adicional         varchar2(50);

             --registro ai_ps_observacoes - 85
             wcod_obs                varchar2(100);
             wdta_obs                varchar2(100);
             wdes_resp               varchar2(100);
             wtxt_obs                varchar2(100);

             --registro ai_ps_colunas - 90
             wseq_coluna             varchar2(100);
             wvlr_coluna             varchar2(100);

             --registro ai_ps_comentarios - 95
             wseq_comentario         varchar2(100);
             wdes_comentario         varchar2(100);

             --registro ai_ps_mascaras - 110
             wcod_completo           varchar2(100);
             wcod_editado            varchar2(100);
             wcod_niv1               varchar2(100);
             wcod_niv2               varchar2(100);

             --registro ai_ps_pessoas_r900 - 900 
             wcodemp                varchar2(100);  
             wind_valida_unidade    varchar2(100);  
             wind_atualiza_bloqueio varchar2(100);
             wind_inc_controle      varchar2(100);

     -- rotina diaria que roda os clientes novos seta 
     -- o ind_processado para 4 para saber que o cliente ja
     -- existia, entao precisamos buscar este cliente tbm
     cursor c_clientes_diario is
            select *
            from grz_lojas_clientes_diario a
            where a.num_rede  >= 00
            and a.num_rede    <= 99
            and a.num_rede    <> 70
            and a.num_loja    >= 0
            and a.num_loja    <= 9999
            --and (a.num_loja in (53,44,97,158)
            --or a.num_rede   in (40,50,10))
            and a.dta_mvto    = trunc(sysdate)
            --and a.cod_cliente in (96995890000)
            and (a.ind_processado is null 
            or a.ind_processado = 4)
            and not exists (select 1
                            from grz_lojas_clientes_controle b
                            where a.num_rede  = b.num_rede
                            and a.num_loja    = b.num_loja
                            and a.cod_cliente = b.cod_cliente
                            and a.dta_mvto    = b.dta_mvto)
            --and rownum <= 500
            order by a.num_rede, a.num_loja;
     r_clientes_diario c_clientes_diario%rowtype;

     cursor c_verifica_pessoa is
            select t.cod_pessoa
                   ,m.cod_completo
             from ps_clientes t
                   ,ps_mascaras m
                   ,ps_pessoas p
             where t.cod_pessoa = m.cod_pessoa
             and m.cod_pessoa = p.cod_pessoa
             and m.cod_mascara = 50
             and (instr(','||wtodasredes||',' , ','||m.cod_niv1||',') > 0)
             and (exists (select 1
                          from ps_fisicas f
                          where t.cod_pessoa = f.cod_pessoa
                          and f.num_cpf = r_clientes_diario.num_cpf_cnpj)
                  or exists (select 1
                             from ps_juridicas j
                             where t.cod_pessoa = j.cod_pessoa
                             and j.num_cgc = r_clientes_diario.num_cpf_cnpj))
             order by t.cod_classe_venda, p.dta_afastamento desc;
     r_verifica_pessoa c_verifica_pessoa%rowtype;

     cursor c_geracao_fisicas is
            select * from ai_ps_fisicas a
            where a.dta_transacao = wdta_mvto
            and a.num_cpf = r_clientes_diario.num_cpf_cnpj
            and a.tip_status_transacao = 1;
     r_geracao_fisicas c_geracao_fisicas%rowtype;

     cursor c_geracao_juridicas is
            select * from ai_ps_juridicas a
            where a.dta_transacao = wdta_mvto
            and a.num_cgc = r_clientes_diario.num_cpf_cnpj
            and a.tip_status_transacao = 1;
     r_geracao_juridicas c_geracao_juridicas%rowtype;	  

BEGIN
     v_cur := dbms_sql.open_cursor;
     dbms_sql.parse(v_cur,'alter session set nls_date_format= "dd/mm/rrrr"',dbms_sql.native);
     v_result := dbms_sql.execute(v_cur);
     dbms_sql.close_cursor(v_cur);

     v_cur := dbms_sql.open_cursor;
     dbms_sql.parse(v_cur,'alter session set nls_numeric_characters = '',.''',dbms_sql.native);
     v_result := dbms_sql.execute(v_cur);
     dbms_sql.close_cursor(v_cur);

     --- busca clientes novos - sislog
     open c_clientes_diario;
     fetch c_clientes_diario into r_clientes_diario;
     while c_clientes_diario%found loop
     begin
          wNum_Cgc := '';
          wNum_cpf := '';

          if (r_clientes_diario.num_rede = 70) then
             wNum_rede := lPad(to_char(r_clientes_diario.cod_emp_cadastro),2,'0');
          else
              wNum_rede := lPad(to_char(r_clientes_diario.num_rede),2,'0');
          end if;
          --wCod_Completo := lpad(wNum_rede,2,'0')||lpad(to_char(r_clientes_diario.cod_cliente),8,'0');
          wCod_Completo := lpad(wNum_rede,2,'0')||lpad(to_char(r_clientes_diario.cod_cartao_cliente),12,'0');

          wCod_Reduzido := '';
          wTabela := '';
          wsqlcode := '';

          /*begin
                 select cod_pessoa
                        into wcod_reduzido
                        from ps_mascaras
                        where cod_mascara  = 50
                        and cod_completo = wcod_completo;
                 exception
                          when no_data_found then
                               wcod_reduzido := '';
          end;*/

          if r_clientes_diario.num_rede = 70 then
             wtodasredes := '10,30,40,50';
          else
              wtodasredes := r_clientes_diario.num_rede;
          end if;

          if (r_clientes_diario.cod_pessoa is not null) and (r_clientes_diario.num_rede = 70) then
          begin
               select t.cod_pessoa
                      ,a.cod_completo
               into wcod_reduzido
                    ,wcod_completo
               from ps_clientes t, ps_mascaras a
               where t.cod_pessoa = a.cod_pessoa
               and a.cod_mascara = 50
               and t.cod_pessoa = r_clientes_diario.cod_pessoa
               and (exists (select 1 from ps_fisicas f
                            where t.cod_pessoa = f.cod_pessoa
                            and f.num_cpf = r_clientes_diario.num_cpf_cnpj)
                            or  exists (select 1 from ps_juridicas j
                                        where t.cod_pessoa = j.cod_pessoa
                                        and j.num_cgc    = r_clientes_diario.num_cpf_cnpj))
               and rownum = 1;
               exception
                        when no_data_found then
                             wcod_reduzido := '';
          end;
          elsif (r_clientes_diario.cod_pessoa is not null) then
          begin
               select t.cod_pessoa
                      ,a.cod_completo
               into wcod_reduzido
                    ,wcod_completo
               from ps_clientes t, ps_mascaras a
               where t.cod_pessoa = a.cod_pessoa
               and a.cod_mascara = 50
               and a.cod_niv1 = r_clientes_diario.num_rede
               and t.cod_pessoa = r_clientes_diario.cod_pessoa
               and (exists (select 1 from ps_fisicas f
                            where t.cod_pessoa = f.cod_pessoa
                            and f.num_cpf = r_clientes_diario.num_cpf_cnpj)
                            or  exists (select 1 from ps_juridicas j
                                        where t.cod_pessoa = j.cod_pessoa
                                        and j.num_cgc    = r_clientes_diario.num_cpf_cnpj));
               exception
                        when no_data_found then
                             wcod_reduzido := '';
          end;
          end if;

              if (wCod_Reduzido is null) then
              begin
                  OPEN c_verifica_pessoa;
                  FETCH c_verifica_pessoa INTO r_verifica_pessoa;
                  IF c_verifica_pessoa%FOUND THEN
                  BEGIN
                      wCod_Reduzido := r_verifica_pessoa.cod_pessoa;
                      wCod_Completo  := r_verifica_pessoa.cod_completo;
                    END;
                    END IF;
                    CLOSE c_verifica_pessoa;
              end;
              end if;


              wAtividade_Cli := '300';
              if (wCod_Reduzido is not null) then
              begin
                  SELECT COD_ATIVIDADE
                    INTO wAtividade_Cli
                    FROM PS_PESSOAS
                   WHERE COD_PESSOA = wCod_Reduzido;
               EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                         wAtividade_Cli := '300';
              end;
              end if;

              wLimite_Cli := 0;
              wCod_Unidade_Cli_NL := r_clientes_diario.num_loja;
              if (wCod_Reduzido is not null) then
              begin
                  select nvl(vlr_lim_geral,0) limite
                    into wLimite_Cli
                    from lc_limites
                   where cod_pessoa = wCod_Reduzido;
               exception
                    when NO_DATA_FOUND then
                         wLimite_Cli := 0;
              end;


              if (wLimite_Cli > 0) then
                begin
                     SELECT COD_UNIDADE
                       INTO wCod_Unidade_Cli_NL
                       FROM PS_CLIENTES
                      WHERE COD_PESSOA = wCod_Reduzido;
                  EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                            wCod_Unidade_Cli_NL := r_clientes_diario.cod_unidade;
                end;

                begin
                    SELECT DTA_AFASTAMENTO
                      INTO wDtaAfastamentoLj
                      FROM PS_PESSOAS
                     WHERE COD_PESSOA = wCod_Unidade_Cli_NL;
                 EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                           wDtaAfastamentoLj := '';
                end;

                if wDtaAfastamentoLj is not null then
                   wCod_Unidade_Cli_NL := r_clientes_diario.num_loja;
                   begin
                       UPDATE PS_CLIENTES
                          SET COD_UNIDADE = wCod_Unidade_Cli_NL
                        WHERE COD_PESSOA = wCod_Reduzido;

                       commit;
                   end;
                end if;
              else
                begin
                    UPDATE PS_CLIENTES
                       SET COD_UNIDADE = wCod_Unidade_Cli_NL
                     WHERE COD_PESSOA = wCod_Reduzido;

                    commit;
                end;
              end if;
              end if;

			 /* begin
              	  SELECT to_char(sysdate,'d') dia_da_semana
              	    Into wDia_Da_Semana
              	    from dual;
	          EXCEPTION
		           WHEN NO_DATA_FOUND THEN
		                wDia_Da_Semana := 99;
              end; */

              -- indica que o cliente j¿ possui cadastro / no momento atualizar apenas clientes novos ou transformados a vista
             /* if ((nvl(wCod_Reduzido,0) > 0) and (wAtividade_Cli = '300')) then
              begin
                   update grz_lojas_clientes_diario
                      set ind_processado = 4
                         ,txt_erro       = 'Cadastro j¿ existe para o Codigo: '||wCod_Completo||
                                           ' CPF/CNPJ: '||to_char(r_clientes_diario.num_cpf_cnpj)
                    where num_rede    = r_clientes_diario.num_rede
                      and num_loja    = r_clientes_diario.num_loja
                      and cod_cliente = r_clientes_diario.cod_cliente
                      and dta_mvto    = r_clientes_diario.dta_mvto;
                exception
                     when NO_DATA_FOUND then
                          wErro := 1;
               end;

               COMMIT;
               end if; */

     -- se o cliente possuir cod_pessoa e atividade for diferente de a prazo 300 /  se o cliente n¿o possuir cod_pessoa ¿ cliente novo
     --if ((nvl(wCod_Reduzido,0) > 0) and (wAtividade_Cli = '315')) or (nvl(wCod_Reduzido,0) = 0) then
       if (nvl(wCod_Completo,0) > 99) then --and (wDia_Da_Semana = 1) then

      --###########################
      --ai_ps_pessoas
      --###########################
            wDes_pessoa           := replace(r_clientes_diario.des_cliente,chr(39),'');
            wData                 := to_char(r_clientes_diario.dta_mvto,'yyyymmdd')||lPad(replace(nvl(r_clientes_diario.hor_alteracao,0),':',''),6,'0');
            --wData                 := to_char('21/01/2020');
            wDta_mvto             := to_date(r_clientes_diario.dta_mvto,'dd/mm/yyyy');

            if r_clientes_diario.tip_cliente = 2 then
               wCod_regiao       := '300';
               wCod_atividade    := '300';
            else
               wCod_regiao       := '315';
               wCod_atividade    := '315';
            end if;
            wDes_fantasia         := replace(r_clientes_diario.des_fantasia,chr(39),'');
            wDes_endereco         := replace(r_clientes_diario.des_endereco,chr(39),'');
            wDes_ponto_referencia := replace(r_clientes_diario.des_pto_refer,chr(39),'');
            wDes_bairro           := replace(r_clientes_diario.des_bairro,chr(39),'');
            wNum_cep              := replace(r_clientes_diario.num_cep,chr(39),'');
            wDes_email            := replace(r_clientes_diario.des_email,chr(39),'');

            wErro    := 0;
            wTabela  := '';
            wSqlcode := '';

            wDes_pessoa_nl        := wDes_pessoa;

			if (wCod_Reduzido is not null) and
			   (wAtividade_Cli <> 315) then
          	            begin
	  		         SELECT DES_PESSOA
	  		               ,COD_NEGATIVACAO
	  		               ,COD_NEGATIVACAO_SERASA
	  	  	           INTO wDes_pessoa
	  	  	               ,wCod_Negativacao
	  	  	               ,wCod_Negativacao_Serasa
	  	  	           FROM PS_PESSOAS
	  	 	          WHERE COD_PESSOA = wCod_Reduzido;
	                         EXCEPTION
	           	            WHEN NO_DATA_FOUND THEN
	                              wDes_pessoa := wDes_pessoa_nl;
	                              wCod_Negativacao := '';
	  	  	              wCod_Negativacao_Serasa := '';
	  	            end;
	  	        end if;


           /*begin
          -- INSERT INTO jaisson VALUES ('AI_PS_CLI'||'cod_comp '||to_char(wCod_Completo)||'Dta_movi '||to_char(wDta_mvto)||' des_pes '||to_char(wDes_pessoa)||' tip_end '||to_char(r_clientes_diario.tip_endereco));

           INSERT INTO jaisson VALUES('1'||','||TO_CHAR(wCod_Completo)||','||TO_CHAR(wDta_mvto)||','||TO_CHAR(wDes_pessoa)||','||
                                      '3'||','||TO_CHAR(r_clientes_diario.tip_endereco)||','||'1'||','||
                                      '0'||','||TO_CHAR(r_clientes_diario.ind_inativo)||','||'0'||','||'1'||','||
                                      '1'||','||TO_CHAR(wCod_classe_venda)||','||TO_CHAR(wCod_cond_pgto)||','||
                                      TO_CHAR(r_clientes_diario.cod_unidade)||','||TO_CHAR(r_clientes_diario.cod_unidade));


          commit;

        end; */


       BEGIN
                  INSERT INTO AI_PS_PESSOAS (COD_GU,COD_PESSOA,DTA_TRANSACAO,DES_PESSOA,COD_REGIAO,
                                             COD_CIDADE,COD_ATIVIDADE,TIP_PESSOA,DTA_CADASTRO,
                                             IND_MALA_DIRETA,IND_INATIVO,TIP_TRANSACAO,TIP_STATUS_TRANSACAO,
                                             DES_FANTASIA,DES_ENDERECO,DES_PONTO_REFERENCIA,DES_BAIRRO,
                                             NUM_CEP,NUM_CAIXA_POSTAL,DES_EMAIL,
                                             DTA_AFASTAMENTO,COD_COMPROVANTE_END,DTA_ULT_ALTERACAO,
                                             COD_PESSOA_APROVA,COD_DEVOLUCAO,COD_UNIDADE_REG,COD_NEGATIVACAO,COD_NEGATIVACAO_SERASA)
                                     VALUES (1,wCod_Completo,wDta_mvto,wDes_pessoa,wCod_regiao,
                                             r_clientes_diario.cod_cidade,wCod_atividade,r_clientes_diario.tip_pessoa,r_clientes_diario.dta_cadastro,
                                             nvl(r_clientes_diario.ind_aceitou_novidades,1),r_clientes_diario.ind_inativo,1,1,
                                             wDes_fantasia,wDes_endereco,wDes_ponto_referencia,wDes_bairro,
                                             wNum_cep,r_clientes_diario.num_caixa_postal,wDes_email,
                                             r_clientes_diario.dta_alteracao,r_clientes_diario.cod_comprov_ender,r_clientes_diario.dta_alteracao,
                                             r_clientes_diario.cod_pes_aprov_cad,r_clientes_diario.ind_correio,wCod_Unidade_Cli_NL,wCod_Negativacao,wCod_Negativacao_Serasa);
                          EXCEPTION
                               WHEN OTHERS THEN
                                    wErro    := 1;
                                    wTabela  := 'AI_PS_PESSOAS';
                                    wSqlcode := SQLCODE||'-'||substr(SQLERRM,1,2000);
       END;

       if wErro = 0 then
        --###########################
        --ai_ps_clientes
        --###########################
        if r_clientes_diario.tip_cliente = 2 then
            wCod_classe_venda := '10';
            wCod_cond_pgto    := '10';
        else
            wCod_classe_venda := '15';
            wCod_cond_pgto    := '1';
        end if;


        BEGIN
          INSERT INTO AI_PS_CLIENTES (COD_GU,COD_PESSOA,DTA_TRANSACAO,DES_PESSOA,
                                      TIP_ABC,TIP_END_CORRESP,IND_FAT_PARCIAL,
                                      TIP_ACEITE_ENTR,IND_INATIVO,IND_ISSQN,TIP_TRANSACAO,
                                      TIP_STATUS_TRANSACAO,COD_CLASSE_VENDA,COD_COND_PGTO,
                                      COD_UNIDADE,COD_UNIDADE_REG,IND_RETIDO,NUM_DIA_VCTO)
                              VALUES (1,wCod_Completo,wDta_mvto,wDes_pessoa,
                                      3,r_clientes_diario.tip_endereco,1,
                                      0,r_clientes_diario.ind_inativo,0,1,
                                      1,wCod_classe_venda,wCod_cond_pgto,
                                      wCod_Unidade_Cli_NL,wCod_Unidade_Cli_NL,0,r_clientes_diario.dia_recebimento);
                            EXCEPTION
                               WHEN OTHERS THEN
                               wErro    := 1;
                               wTabela  := 'AI_PS_CLIENTES';
                               wSqlcode := SQLCODE||'-'||substr(SQLERRM,1,2000);
                          END;

        if wErro = 0 then
          if r_clientes_diario.tip_pessoa = 2 then
            --###########################
            --ai_ps_juridicas
            --###########################
            wNum_cgc                    := to_char(r_clientes_diario.num_cpf_cnpj);
            wDta_fundacao               := to_char(r_clientes_diario.dta_nascto,'dd/mm/yyyy');
            wNum_insc_est               := replace(r_clientes_diario.num_insc_est,chr(39),'');

            wNum_cgc_nl                 := wNum_cgc;
            wDta_fundacao_nl            := wDta_fundacao;
            wNum_insc_est_nl            := wNum_insc_est;
            if (wCod_Reduzido is not null) and
               (wAtividade_Cli <> 315) then
               begin
                   SELECT TO_CHAR(DTA_FUNDACAO,'DD/MM/YYYY')
                         ,TO_CHAR(NUM_CGC)
                         ,NUM_INSC_EST
                     INTO wDta_fundacao
                         ,wNum_cgc
                         ,wNum_insc_est
                     FROM PS_JURIDICAS
                    WHERE COD_PESSOA = wCod_Reduzido;
                EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                          wDta_fundacao := wDta_fundacao_nl;
                          wNum_cgc      := wNum_cgc_nl;
                          wNum_insc_est := wNum_insc_est_nl;
               end;

               if to_number(nvl(wNum_cgc,0)) = 0 then
                  wNum_cgc := wNum_cgc_nl;
               elsif wDta_fundacao = '11/11/1111' then
                  wDta_fundacao := wDta_fundacao_nl;
               elsif lTrim(rTrim(wNum_insc_est)) is null then
                  wNum_insc_est := wNum_insc_est_nl;
               end if;
            end if;

            BEGIN
              INSERT INTO AI_PS_JURIDICAS (COD_PESSOA,DTA_TRANSACAO,TIP_TRANSACAO,
                                           TIP_STATUS_TRANSACAO,NUM_CGC,DTA_FUNDACAO,
                                           NUM_INSC_EST,COD_UNIDADE_REG)
                                   VALUES (wCod_Completo,wDta_mvto,1,
                                           1,wNum_cgc,wDta_fundacao,
                                           wNum_insc_est,wCod_Unidade_Cli_NL);
                                EXCEPTION
                                   WHEN OTHERS THEN
                                   wErro    := 1;
                                   wTabela  := 'AI_PS_JURIDICAS';
                                   wSqlcode := SQLCODE||'-'||substr(SQLERRM,1,2000);
                              END;
          else
            --###########################
            --ai_ps_fisicas
            --###########################
          wDta_nasc            := to_char(r_clientes_diario.dta_nascto,'dd/mm/yyyy');
          wNum_cpf             := to_char(r_clientes_diario.num_cpf_cnpj);
          wVlr_aluguel         := to_char(r_clientes_diario.vlr_aluguel);
          wVlr_renda           := to_char(r_clientes_diario.vlr_outras_rendas);
          wDes_conjuge         := replace(r_clientes_diario.des_pessoa_raux,chr(39),'');
          wDes_pai             := replace(r_clientes_diario.des_pai,chr(39),'');
          wDes_mae             := replace(r_clientes_diario.des_mae,chr(39),'');

          wDta_nasc_nl         := wDta_nasc;
          wNum_cpf_nl          := wNum_cpf;
          wDes_mae_nl          := wDes_mae;
          if (wCod_Reduzido is not null) and
             (wAtividade_Cli <> 315) then
             begin
                SELECT TO_CHAR(DTA_NASC,'DD/MM/YYYY')
                      ,TO_CHAR(NUM_CPF)
                      ,DES_MAE
                  INTO wDta_nasc
                      ,wNum_cpf
                      ,wDes_mae
                  FROM PS_FISICAS
                 WHERE COD_PESSOA = wCod_Reduzido;
             EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                       wDta_nasc := wDta_nasc_nl;
                       wNum_cpf  := wNum_cpf_nl;
                       wDes_mae  := wDes_mae_nl;
             end;

             if to_number(nvl(wNum_cpf,0)) = 0 then
                wNum_cpf  := wNum_cpf_nl;
             elsif lTrim(rTrim(wDes_mae)) is null then
                wDes_mae  := wDes_mae_nl;
             elsif wDta_nasc = '11/11/1111' then
                wDta_nasc := wDta_nasc_nl;
             end if;
          end if;



            BEGIN
              INSERT INTO AI_PS_FISICAS (COD_PESSOA,DTA_TRANSACAO,TIP_TRANSACAO,TIP_STATUS_TRANSACAO,
                                         DTA_NASC,NUM_CPF,NUM_RG,DTA_EXP_RG,DES_ORG_EXP_RG,
                                         TIP_SEXO,TIP_CIVIL,DES_CONJUGE,DES_PAI,DES_MAE,TIP_RESIDENCIA,
                                         VLR_ALUGUEL,VLR_RENDA,DES_RENDA,COD_COMPROV_RENDA,COD_CID_NASC,
                                         DTA_CASAMENTO,NUM_CPF_CONJUGE,NUM_RG_CONJUGE,DTA_EXP_RG_CONJUGE,
                                         DES_ORG_RG_CONJUGE,DTA_NASC_CONJUGE,DTA_INI_RESIDENCIA,IND_SEXO,
                                         COD_PARENTESCO,COD_UNIDADE_REG)
                                 VALUES (wCod_Completo,wDta_mvto,1,1,
                                         wDta_nasc,wNum_cpf,r_clientes_diario.NUM_RG,r_clientes_diario.DTA_EXP_RG,r_clientes_diario.DES_ORG_EXP_RG,
                                         r_clientes_diario.tip_sexo,r_clientes_diario.tip_est_civil,wDes_conjuge,wDes_pai,wDes_mae,r_clientes_diario.tip_residencia,
                                         wVlr_aluguel,wVlr_renda,r_clientes_diario.des_outras_rendas,nvl(r_clientes_diario.ind_compr_renda,0),r_clientes_diario.cod_cidade_nasc,
                                         r_clientes_diario.dta_casamento,r_clientes_diario.num_cpf_cnpj_raux,r_clientes_diario.num_rg_raux,r_clientes_diario.dta_exp_rg_raux,
                                         r_clientes_diario.des_org_exp_rg_raux,r_clientes_diario.dta_nascto_raux,r_clientes_diario.dta_resid_atual,nvl(r_clientes_diario.tip_sexo_raux,0),
                                         r_clientes_diario.cod_parentesco_raux,wCod_Unidade_Cli_NL);
                               EXCEPTION
                                    WHEN OTHERS THEN
                                         wErro    := 1;
                                         wTabela  := 'AI_PS_FISICAS';
                                         wSqlcode := SQLCODE||'-'||substr(SQLERRM,1,2000);
            END;
          end if;

          if wErro = 0 then
            --###########################
            --ai_ps_mascaras
            --###########################
             --wCod_completo        := wCod_pessoa;
             wCod_editado         := substr(wCod_completo,1,2)||'.'||substr(wCod_completo,3,12);
             wCod_niv1            := lPad(wNum_rede,2,'0');
             wCod_niv2            := substr(wCod_completo,3,12);

             BEGIN
                 INSERT INTO AI_PS_MASCARAS (COD_MASCARA,COD_PESSOA,COD_COMPLETO,
                                             DTA_TRANSACAO,COD_NIV0,TIP_TRANSACAO,
                                             TIP_STATUS_TRANSACAO,COD_EDITADO,COD_NIV1,
                                             COD_NIV2,COD_UNIDADE_REG)
                                     VALUES (50,wCod_completo,wCod_completo,
                                             wDta_mvto,'1',1,
                                             1,wCod_editado,wCod_niv1,
                                             wCod_niv2,wCod_Unidade_Cli_NL);
                                EXCEPTION
                                     WHEN OTHERS THEN
                                          wErro    := 1;
                                          wTabela  := 'AI_PS_MASCARAS';
                                          wSqlcode := SQLCODE||'-'||substr(SQLERRM,1,2000);
             END;

             if wErro = 0 then
              --###########################
              --ai_ps_telefones
              --###########################
              iCount := 0;
              while iCount < 11 loop
                 iCount := iCount + 1;
                 wNum_fone := '';

                 if iCount = 1 then
                      wNum_seq           := 1;
                      wNum_fone          := r_clientes_diario.des_fone_resid;
                      if to_number(nvl(wNum_fone,0)) = 0 then
                          wNum_fone :='';
                      end if;
                      wDes_fone          := 'RESIDENCIAL';
                 elsif iCount = 2 then
                      wNum_seq           := 10;
                      wNum_fone          := r_clientes_diario.des_fone_comerc;
                      if to_number(nvl(wNum_fone,0)) = 0 then
                          wNum_fone :='';
                      end if;
                      wDes_fone          := 'COMERCIAL';
                 elsif iCount = 3 then
                      wNum_seq           := 11;
                      wNum_fone          := r_clientes_diario.des_ramal_comerc;
                      if to_number(nvl(wNum_fone,0)) = 0 then
                          wNum_fone :='';
                      end if;
                      wDes_fone          := 'RAMAL FONE COMERCIAL';
                 elsif iCount = 4 then
                      wNum_seq           := 15;
                      wNum_fone          := r_clientes_diario.des_fone_celular;
                      if to_number(nvl(wNum_fone,0)) = 0 then
                          wNum_fone :='';
                      end if;
                      wDes_fone          := 'CELULAR';
                 elsif iCount = 5 then
                      wNum_seq           := 16;
                      wNum_fone          := r_clientes_diario.des_fone_celular2;
                      if to_number(nvl(wNum_fone,0)) = 0 then
                          wNum_fone :='';
                      end if;
                      wDes_fone          := 'CELULAR2';
                 elsif iCount = 6 then
                      wNum_seq           := 20;
                      wNum_fone          := r_clientes_diario.des_telefone_raux;
                      if to_number(nvl(wNum_fone,0)) = 0 then
                          wNum_fone :='';
                      end if;
                      wDes_fone          := 'AUTORIZADO';
                 elsif iCount = 7 then
                      wNum_seq           := 95;
                      wNum_fone          := r_clientes_diario.des_celular1_ant;
                      if to_number(nvl(wNum_fone,0)) = 0 then
                          wNum_fone :='';
                      end if;
                      wDes_fone          := 'CELULAR ANT';
                 elsif iCount = 8 then
                      wNum_seq           := 96;
                      wNum_fone          := r_clientes_diario.des_celular2_ant;
                      if to_number(nvl(wNum_fone,0)) = 0 then
                          wNum_fone :='';
                      end if;
                      wDes_fone          := 'CELULAR2 ANT';
                 elsif iCount = 9 then
                      wNum_seq           := 97;
                      wNum_fone          := r_clientes_diario.des_residencial_ant;
                      if to_number(nvl(wNum_fone,0)) = 0 then
                          wNum_fone :='';
                      end if;
                      wDes_fone          := 'RESIDENCIAL ANT';
                 elsif iCount = 10 then
                      wNum_seq           := 98;
                      wNum_fone          := r_clientes_diario.des_fone_comerc_adic;
                      if to_number(nvl(wNum_fone,0)) = 0 then
                          wNum_fone :='';
                      end if;
                      wDes_fone          := 'COMERCIAL ADIC';
                 elsif iCount = 11 then
                      wNum_seq           := 99;
                      wNum_fone          := r_clientes_diario.des_ramal_comerc_adic;
                      if to_number(nvl(wNum_fone,0)) = 0 then
                          wNum_fone :='';
                      end if;
                      wDes_fone          := 'RAMAL COMERCIAL ADIC';
                 end if;

                 if (wNum_fone is null) and
                    (wCod_Reduzido is not null) then
                     begin
                         SELECT 1
                           INTO wExisteFone
                           FROM PS_TELEFONES
                          WHERE COD_PESSOA = wCod_Reduzido
                            AND NUM_SEQ = wNum_Seq;
                      EXCEPTION
                           WHEN NO_DATA_FOUND THEN
                                wExisteFone := 0;
                     end;

                     if (wExisteFone = 1) then
                         wNum_fone := '0';
                     end if;
                 end if;

                 if (wNum_fone is not null) then
                 BEGIN
                     INSERT INTO AI_PS_TELEFONES (COD_PESSOA,NUM_SEQ,DTA_TRANSACAO,NUM_FONE,
                                                  DES_FONE,TIP_TRANSACAO,TIP_STATUS_TRANSACAO,COD_UNIDADE_REG)
                                          VALUES (wCod_Completo,wNum_seq,wDta_mvto,wNum_fone,
                                                  wDes_fone,1,1,wCod_Unidade_Cli_NL);
                                       EXCEPTION
                                            WHEN OTHERS THEN
                                                 wErro    := 1;
                                                 wTabela  := 'AI_PS_TELEFONES';
                                                 wSqlcode := SQLCODE||'-'||substr(SQLERRM,1,2000);
                 END;
                 end if;
              end loop;

              if r_clientes_diario.tip_cliente = 2 then

			          --###########################
					  --ai_ps_consentimentos
					  --###########################
					  if	r_clientes_diario.ind_aceitou_contrato = 1 then

					      begin
					          insert into ai_ps_consentimentos (cod_pessoa,dta_transacao,cod_consentimento,seq_versao,tip_transacao,tip_status_transacao,dta_ini_validade,ind_aprova_externa,cod_unidade_reg) values
							  (wCod_Completo,wDta_Mvto,3,replace(r_clientes_diario.versao_termo_contrato,'.',''), 1,1, wDta_Mvto,1, wCod_Unidade_Cli_NL );
				          exception
						       WHEN OTHERS THEN
					              wErro    := 1;
                                  wTabela  := 'ai_ps_consentimentos';
                                  wSqlcode := SQLCODE||'-'||substr(SQLERRM,1,2000);
					      end;

						  begin
					          insert into ai_ps_consentimentos (cod_pessoa,dta_transacao,cod_consentimento,seq_versao,tip_transacao,tip_status_transacao,dta_ini_validade,ind_aprova_externa,cod_unidade_reg) values
							  (wCod_Completo,wDta_Mvto,1,replace(r_clientes_diario.versao_termo_politica,'.',''), 1,1, wDta_Mvto,1, wCod_Unidade_Cli_NL );
				          exception
						      WHEN OTHERS THEN
					              wErro    := 1;
                                  wTabela  := 'ai_ps_consentimentos';
                                  wSqlcode := SQLCODE||'-'||substr(SQLERRM,1,2000);
					      end;
					  end if;


					      begin
					          insert into ai_ps_consentimentos (cod_pessoa,dta_transacao,cod_consentimento,seq_versao,tip_transacao,tip_status_transacao,dta_ini_validade,ind_aprova_externa,cod_unidade_reg) values
							  (wCod_Completo,wDta_Mvto,5,nvl(r_clientes_diario.ind_aceitou_novidades,1), 1,1, wDta_Mvto,1, wCod_Unidade_Cli_NL );
				          exception
						       WHEN OTHERS THEN
					              wErro    := 1;
                                  wTabela  := 'ai_ps_consentimentos';
                                  wSqlcode := SQLCODE||'-'||substr(SQLERRM,1,2000);
					      end;




                --###########################
                --ai_ps_prof_clientes
                --###########################

                 iCount := 0;
                 while iCount < 2 loop
                    iCount := iCount + 1;
                    if iCount = 1 then
                       if r_clientes_diario.des_empr_trab is not null then
                          wDes_emp         := r_clientes_diario.des_empr_trab;
                       else
                          wDes_emp         := 'A';
                       end if;

                       wVlr_salario         := to_char(r_clientes_diario.vlr_renda);
                       wNum_fone            := r_clientes_diario.des_fone_comerc;
                       if to_number(nvl(wNum_fone,0)) = 0 then
                          wNum_fone :='';
                       end if;


					 wDes_bairro          := to_char(substr(r_clientes_diario.des_bairro_end_empresa,1,20));
		             wDes_endereco      := to_char(r_clientes_diario.des_rua_end_empresa);
		             wNum_cep             := to_char(r_clientes_diario.num_cep_end_empresa);
					 wCompl_endereco   := to_char(r_clientes_diario.des_compl_end_empresa);
		             wCod_cidade_empresa := to_char(r_clientes_diario.cod_cidade_end_empresa);
					 wNum_end_empresa := to_char(r_clientes_diario.des_num_end_empresa);
			         wTip_Funcao := to_char(r_clientes_diario.ind_profissao);

					 if nvl(wCod_cidade_empresa,'0') = '0' then
					 wDes_bairro:= '';
					 wDes_endereco :='';
					 wCompl_endereco :='';
					 wNum_end_empresa :='';
					 wCod_cidade_empresa := r_clientes_diario.Cod_Cidade;
					 end if;

                       if wDes_emp is not null then
                       begin
                           INSERT INTO AI_PS_PROF_CLIENTES (COD_PESSOA, TIP_INF_PROF, DES_EMP, DTA_TRANSACAO, COD_COMPROV, COD_CIDADE,
                                                            COD_FUNCAO, VLR_SALARIO, TIP_TRANSACAO, TIP_STATUS_TRANSACAO, NUM_FONE,
                                                            DES_ENDERECO, DES_BAIRRO,NUM_CEP, NUM_CNPJ_EMPREGADOR, DTA_ADMISSAO, COD_UNIDADE_REG,
															TIP_FUNCAO,NUM_LOGRADOURO,DES_COMPL_LOGRADOURO)
                                                    VALUES (wCod_Completo, 1, wDes_emp, wDta_Mvto, nvl(r_clientes_diario.cod_comprov_renda,0), wCod_cidade_empresa,
                                                            nvl(r_clientes_diario.cod_profissao,0),wVlr_salario, 1, 1, wNum_fone,
                                                            wDes_endereco, wDes_bairro, wNum_cep, r_clientes_diario.num_cnpj_empr_trab,r_clientes_diario.dta_admissao_trab, wCod_unidade_Cli_NL,
															wTip_Funcao,wNum_end_empresa,wCompl_endereco);
                                                 EXCEPTION
                                                      WHEN OTHERS THEN
                                                           wErro    := 1;
                                                           wTabela  := 'AI_PS_PROF_CLIENTES';
                                                           wSqlcode := SQLCODE||'-'||substr(SQLERRM,1,2000);

                       end;
                       end if;
                    elsif iCount = 2 then
                          if (r_clientes_diario.des_pessoa_raux is not null) or
                             (nvl(r_clientes_diario.cod_profissao_raux,0) > 0) or
                             (nvl(r_clientes_diario.vlr_outras_rendas,0) > 0) or
                             (to_number(nvl(r_clientes_diario.des_telefone_raux,0)) > 0) then

                              if r_clientes_diario.des_empr_trab_adic is not null then
                                 wDes_emp         := r_clientes_diario.des_empr_trab_adic;
                              else
                                 wDes_emp         := 'A';
                              end if;

                              if r_clientes_diario.vlr_outras_rendas is not null then
                                 wVlr_salario         := to_char(nvl(r_clientes_diario.vlr_outras_rendas,0));
                              else
                                 wVlr_salario         := '0';
                              end if;

                              wNum_fone            := r_clientes_diario.des_fone_comerc_adic;
                              if to_number(nvl(wNum_fone,0)) = 0 then
                                 wNum_fone :='';
                              end if;

                              if (to_number(nvl(r_clientes_diario.des_fone_comerc_adic,0)) > 0) and
                                 (to_number(nvl(r_clientes_diario.des_ramal_comerc_adic,0)) > 0) then
                                  wNum_fone := wNum_fone||' R:'||r_clientes_diario.des_ramal_comerc_adic;
                              end if;

                              if wDes_emp is not null then
                              begin
                                  INSERT INTO AI_PS_PROF_CLIENTES (COD_PESSOA, TIP_INF_PROF, DES_EMP, DTA_TRANSACAO, COD_COMPROV, COD_CIDADE,
                                                                   COD_FUNCAO, VLR_SALARIO, TIP_TRANSACAO, TIP_STATUS_TRANSACAO, NUM_FONE,
                                                                   DES_BAIRRO, NUM_CNPJ_EMPREGADOR, DTA_ADMISSAO, COD_UNIDADE_REG)
                                                           VALUES (wCod_Completo, 3, wDes_emp, wDta_Mvto, nvl(r_clientes_diario.ind_compr_renda,0), r_clientes_diario.Cod_Cidade,
                                                                   nvl(r_clientes_diario.cod_profissao_adic,113),wVlr_salario, 1, 1, wNum_fone,
                                                                   r_clientes_diario.ind_profissao_adic, r_clientes_diario.num_cnpj_empr_trab_adic,r_clientes_diario.dta_admissao_trab_adic, wCod_unidade_Cli_NL);
                                                        EXCEPTION
                                                      WHEN OTHERS THEN
                                                           wErro    := 1;
                                                           wTabela  := 'AI_PS_PROF_CLIENTES';
                                                           wSqlcode := SQLCODE||'-'||substr(SQLERRM,1,2000);

                              end;
                              end if;
                          end if;
                    end if;
                 end loop;

                 --###########################
                 --ai_ps_ref_clientes
                 --###########################
                 wDes_ref             := r_clientes_diario.des_pessoa_refer;
                 wNum_fone            := r_clientes_diario.des_fone_pes_refer;
                 if to_number(nvl(wNum_fone,0)) = 0 then
                    wNum_fone :='';
                 end if;
                 --wTip_referencia      := to_char(r_clientes_diario.cod_parentesco);

                 if wDes_Ref is not null then
                 begin -- REFERENCIA 1
                     INSERT INTO AI_PS_REF_CLIENTES (COD_PESSOA, NUM_SEQ_REF, DES_REF, DTA_TRANSACAO,
                                                     COD_CIDADE, TIP_TRANSACAO, TIP_STATUS_TRANSACAO,
                                                     NUM_FONE, TIP_REFERENCIA, COD_UNIDADE_REG)
                                             VALUES (wCod_Completo, 1, wDes_Ref, wDta_Mvto,
                                                     r_clientes_diario.cod_cidade, 1, 1,
                                                     wNum_Fone, r_clientes_diario.cod_parentesco, wCod_unidade_Cli_NL);
                                          EXCEPTION
                                               WHEN OTHERS THEN
                                                    wTabela  := 'AI_PS_REF_CLIENTES';
                                                     wSqlcode := SQLCODE||'-'||substr(SQLERRM,1,2000);
                 end;
                 end if;
                             ----grava registro do contato para recado----
                 wDes_ref             := r_clientes_diario.des_recado;
                 -- wTip_referencia      := '10';
                 if wDes_Ref is not null then
                 begin -- REFERENCIA 10
                     INSERT INTO AI_PS_REF_CLIENTES (COD_PESSOA, NUM_SEQ_REF, DES_REF, DTA_TRANSACAO,
                                                     COD_CIDADE, TIP_TRANSACAO, TIP_STATUS_TRANSACAO,
                                                     NUM_FONE, TIP_REFERENCIA, COD_UNIDADE_REG)
                                             VALUES (wCod_Completo, 10, wDes_Ref, wDta_Mvto,
                                                     r_clientes_diario.cod_cidade, 1, 1,
                                                     wNum_Fone, 10, wCod_unidade_Cli_NL);
                                          EXCEPTION
                                               WHEN OTHERS THEN
                                                    wErro    := 1;
                                                    wTabela  := 'AI_PS_REF_CLIENTES';
                                                     wSqlcode := SQLCODE||'-'||substr(SQLERRM,1,2000);
                 end;
                 end if;

                 --grava registro para segunda pessoa de referencia-------

                 wDes_ref             := r_clientes_diario.des_pessoa_refer2;
                 wNum_fone            := r_clientes_diario.des_fone_pes_refer2;
                 if to_number(nvl(wNum_fone,0)) = 0 then
                     wNum_fone :='';
                 end if;

                 --wTip_referencia      := to_char(r_clientes_diario.cod_parentesco_ref2);

                 if wDes_Ref is not null then
                 begin -- REFERENCIA 5
                     INSERT INTO AI_PS_REF_CLIENTES (COD_PESSOA, NUM_SEQ_REF, DES_REF, DTA_TRANSACAO,
                                                     COD_CIDADE, TIP_TRANSACAO, TIP_STATUS_TRANSACAO,
                                                     NUM_FONE, TIP_REFERENCIA, COD_UNIDADE_REG)
                                             VALUES (wCod_Completo, 5, wDes_Ref, wDta_Mvto,
                                                     r_clientes_diario.cod_cidade, 1, 1,
                                                     wNum_Fone, r_clientes_diario.cod_parentesco_ref2, wCod_unidade_Cli_NL);
                                          EXCEPTION
                                               WHEN OTHERS THEN
                                                    wErro    := 1;
                                                    wTabela  := 'AI_PS_REF_CLIENTES';
                                                     wSqlcode := SQLCODE||'-'||substr(SQLERRM,1,2000);
                 end;
                 end if;


                --###########################
                --ai_ps_cartoes
                --###########################

                 wNum_reemissao       := substr(lpad(r_clientes_diario.cod_cartao,3,'0'),1,2);
                 wInd_emite           := '0';
                 wDta_Solicitacao     := '';
                 wInd_Emite_Cartao    := 0;
                 wDta_Remessa_Cartao  := '';
                 if wCod_Reduzido is not null then
                     wInd_emite  := '0';
                     wCod_Cartao := to_char(wCod_Reduzido);
                     begin
                            SELECT TO_CHAR(DTA_SOLICITACAO,'DDMMYYYY')
                                  ,IND_EMITE
                                  ,NUM_REEMISSAO
                                  ,DES_IMP
                                  ,TO_CHAR(DTA_REMESSA,'DDMMYYYY')
                              INTO wDta_Solicitacao
                                  ,wInd_Emite_Cartao
                                  ,wNum_Reemissao_Cartao
                                  ,wDes_Imp
                                  ,wDta_Remessa_Cartao
                              FROM PS_CARTOES
                             WHERE COD_PESSOA = wCod_Reduzido
                               AND COD_CARTAO = wCod_Reduzido;
                         EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                   wDta_Solicitacao   := wDta_Mvto;
                                   wInd_emite         := '1';
                                   wNum_reemissao     := '0';
                                   wInd_Emite_Cartao  := 0;
                                   wDes_imp           := replace(nvl(r_clientes_diario.des_nome_impr_cartao,substr(wDes_Pessoa,1,30)),chr(39),'');
                                   wDta_Remessa_Cartao:= '';
                     end;
                     if wInd_Emite_Cartao = 1 then
                        wInd_emite     := to_char(nvl(wInd_Emite_Cartao,0));
                        wNum_reemissao := to_char(nvl(wNum_Reemissao_Cartao,0));
                        --alteracao 14/09/2011
                        -- alterado em 03/11/2014
                     elsif (nvl(r_clientes_diario.ind_reem_cart_tit,0) = 1) and
                        --  (to_date(nvl(wDta_Solicitacao,'01011001'),'dd/mm/yyyy') < trunc(sysdate - 730)) and
                           (to_date(nvl(wDta_Solicitacao,'01011001'),'dd/mm/yyyy') < trunc(sysdate - 60)) and
                           (r_clientes_diario.dta_solic_reem_tit >= (r_clientes_diario.dta_alteracao - 5)) then -- adicionado este teste dia 28/05/2014
                            wInd_emite     := to_char(nvl(r_clientes_diario.ind_reem_cart_tit,0));
                            wNum_reemissao := to_char(nvl(wNum_Reemissao_Cartao,0));
                            wDta_Solicitacao := to_char(r_clientes_diario.dta_solic_reem_tit,'DDMMYYYY');
                     end if;
                 else
                     wInd_emite       := '1';
                     wNum_reemissao   := '0';
                     wCod_Cartao      := '';
                     wDta_Solicitacao := wDta_Mvto;
                     wDes_imp         := replace(nvl(r_clientes_diario.des_nome_impr_cartao,substr(wDes_Pessoa,1,30)),chr(39),'');
                 end if;
                 wDta_validade        := '';
                 wDta_fechamento      := '';
                 wCod_Tipo_Cartao     := '';
                 wCod_situacao        := substr(lpad(r_clientes_diario.cod_cartao,3,'0'),3,1);

                --wNum_reemissao := substr(lpad(r_clientes_diario.cod_cartao,3,'0'),1,2);
                --wCod_situacao  := substr(lpad(r_clientes_diario.cod_cartao,3,'0'),3,1);

                 if (r_clientes_diario.num_dia_vcto is not null) then
                 BEGIN
                     INSERT INTO AI_PS_CARTOES (COD_PESSOA, DTA_TRANSACAO, NUM_DIA_VENC, TIP_DOC_COBR,
                                                DES_IMP, NUM_REEMISSAO, IND_EMITE, TIP_TRANSACAO, TIP_STATUS_TRANSACAO,
                                                COD_SITUACAO, COD_UNIDADE_REG, COD_CARTAO, DTA_SOLICITACAO, DTA_REMESSA)
                                        VALUES (wCod_Completo,wDta_mvto,r_clientes_diario.num_dia_vcto, 2,
                                                wDes_imp, wNum_reemissao, wInd_Emite_Cartao, 1, 1,
                                                wCod_situacao,wCod_unidade_Cli_NL, wCod_Cartao, wDta_Solicitacao, wDta_Remessa_Cartao);
                                     EXCEPTION
                                          WHEN OTHERS THEN
                                               wErro    := 1;
                                               wTabela  := 'AI_PS_CARTOES';
                                               wSqlcode := SQLCODE||'-'||substr(SQLERRM,1,2000);
                 END;
                 end if;


                 if wErro = 0 then
                  --###########################
                  --ai_ps_cartoes_adicionais
                  --###########################
                    -- aqui teste do adicional para excluir
                   wNome_Adicional := '';
                   if (r_clientes_diario.ind_deletar_adic = '1') then
                     begin
                         select des_imp
                           into wNome_Adicional
                           from ps_cartoes_adicionais
                           where cod_pessoa = r_clientes_diario.cod_pessoa
                             and num_adic = 10;
                       EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                 wNome_Adicional:='A';
                     end;

                     if wNome_Adicional <> 'A' then
                      begin
                          delete from nl.ps_cartoes_adicionais a
                           where a.cod_pessoa = r_clientes_diario.cod_pessoa
                             and a.num_adic = 10;
                      end;

                      --commit;
                     end if;
                   end if;

                   iCount := 0;
                   while iCount < 2 loop
                         iCount := iCount + 1;
                         if iCount = 1 then
                            wNum_adic       := '0';
                            wDes_parentesco := 'TITULAR';
                            wDta_nasc_cartao   := wDta_nasc;
                            wCod_funcao     := to_char(r_clientes_diario.cod_profissao);
                         elsif iCount = 2 then
                               wNum_adic             := '10';
                               wDes_imp               := nvl(r_clientes_diario.des_nome_impr_cartao_adic,substr(r_clientes_diario.des_pessoa_raux,1,30));
                               wNum_reemissao        := substr(lpad(nvl(r_clientes_diario.cod_cartao_adic,'0'),3,'0'),1,2);
                               wTem_Cartao_Adic      := 0;
                               wDta_Solicitacao      := '';
                               wNum_Reemissao_Cartao := 0;
                               wInd_Emite_Cartao     := 0;
                               wDta_Remessa_Cartao   := '';
                               if wCod_Reduzido is not null then
                               begin
                                   SELECT NUM_REEMISSAO
                                         ,TO_CHAR(DTA_SOLICITACAO,'DDMMYYYY')
                                         ,IND_EMITE
                                         ,1
                                         ,TO_CHAR(DTA_REMESSA,'DDMMYYYY')
                                     INTO wNum_Reemissao_Cartao
                                         ,wDta_Solicitacao
                                         ,wInd_Emite_Cartao
                                         ,wTem_Cartao_Adic
                                         ,wDta_Remessa_Cartao
                                     FROM PS_CARTOES_ADICIONAIS
                                    WHERE COD_PESSOA = wCod_Reduzido
                                      AND NUM_ADIC   = 10
                                      AND COD_CARTAO = wCod_Reduzido;
                                EXCEPTION
                                     WHEN NO_DATA_FOUND THEN
                                          wNum_Reemissao_Cartao := 0;
                                          wDta_Solicitacao      := '';
                                          wInd_Emite_Cartao     := 0;
                                          wTem_Cartao_Adic      := 0;
                                          wDta_Remessa_Cartao   := '';
                               end;

                                 if r_clientes_diario.des_pessoa_raux is null then
                                    if wTem_Cartao_Adic = 1 then
                                       if wInd_Emite_Cartao = 1 then
                                          wDes_imp         := '';
                                       elsif wNum_Reemissao_Cartao > 0 then
                                          wDes_imp         := '';
                                       else
                                          wInd_emite       := '0';
                                          wNum_reemissao   := '0';
                                          wDta_Solicitacao := '';
                                      end if;
                                    else
                                      wInd_emite       := '0';
                                      wNum_reemissao   := '0';
                                      wDta_Solicitacao := '';
                                    end if;
                                 elsif to_number(nvl(r_clientes_diario.cod_cartao_adic,'0')) = 0 then
                                    if wTem_Cartao_Adic = 1 then
                                       if wInd_Emite_Cartao = 1 then
                                          wDes_imp         := '';
                                       elsif wNum_Reemissao_Cartao > 0 then
                                          wDes_imp         := '';
                                       else
                                          wInd_emite       := '0';
                                          wNum_reemissao   := '0';
                                          wDta_Solicitacao := '';
                                       end if;
                                    else
                                       wInd_emite       := '0';
                                       wNum_reemissao   := '0';
                                       wDta_Solicitacao := '';
                                    end if;
                                 elsif to_number(nvl(r_clientes_diario.cod_cartao_adic,'0')) <> 101 then
                                    if wTem_Cartao_Adic = 1 then
                                       if wInd_Emite_Cartao = 1 then
                                          wInd_emite       := to_char(nvl(wInd_Emite_Cartao,0));
                                          wNum_reemissao   := to_char(nvl(wNum_Reemissao_Cartao,0));
                                           --alteracao 14/09/2011
                                           -- alterado em 03/11/2014
                                       elsif (nvl(r_clientes_diario.ind_reem_cart_raux,0)) = 1 and
                                           --  (to_date(nvl(wDta_Solicitacao,'01011001'),'dd/mm/yyyy') < trunc(sysdate - 730)) and
                                             (to_date(nvl(wDta_Solicitacao,'01011001'),'dd/mm/yyyy') < trunc(sysdate - 60)) and
                                             (r_clientes_diario.dta_solic_reem_raux >= (r_clientes_diario.dta_alteracao - 5)) then -- adicionado este teste dia 28/05/2014
                                              wInd_emite     := to_char(nvl(r_clientes_diario.ind_reem_cart_raux,0));
                                              wNum_reemissao := to_char(nvl(wNum_Reemissao_Cartao,0));
                                              wDta_Solicitacao := to_char(r_clientes_diario.dta_solic_reem_raux,'DDMMYYYY');
                                       elsif wNum_Reemissao_Cartao > 0 then
                                             wInd_emite       := to_char(nvl(wInd_Emite_Cartao,0));
                                             wNum_reemissao   := to_char(nvl(wNum_Reemissao_Cartao,0));
                                       else
                                          wInd_emite       := '0';
                                          wNum_reemissao   := '0';
                                          wDta_Solicitacao := '';
                                       end if;
                                    else
                                       wInd_emite       := '0';
                                       wNum_reemissao   := '0';
                                       wDta_Solicitacao := '';
                                    end if;
                                 elsif nvl(wNum_Reemissao_Cartao,0) = to_number(nvl(wNum_reemissao,0)) then
                                    if wTem_Cartao_Adic = 1 then
                                       if wInd_Emite_Cartao = 1 then
                                          wInd_emite       := to_char(nvl(wInd_Emite_Cartao,0));
                                          wNum_reemissao   := to_char(nvl(wNum_Reemissao_Cartao,0));
                                          --alteracao 14/09/2011
                                       elsif (nvl(r_clientes_diario.ind_reem_cart_raux,0)) = 1 and
                                             --(to_date(nvl(wDta_Solicitacao,'01011001'),'dd/mm/yyyy') < trunc(sysdate - 730)) and
                                             (to_date(nvl(wDta_Solicitacao,'01011001'),'dd/mm/yyyy') < trunc(sysdate - 60)) and
                                             (r_clientes_diario.dta_solic_reem_raux >= (r_clientes_diario.dta_alteracao - 5)) then -- adicionado este teste dia 28/05/2014
                                              wInd_emite     := to_char(nvl(r_clientes_diario.ind_reem_cart_raux,0));
                                              wNum_reemissao := to_char(nvl(wNum_Reemissao_Cartao,0));
                                              wDta_Solicitacao := to_char(r_clientes_diario.dta_solic_reem_raux,'DDMMYYYY');
                                       elsif wNum_Reemissao_Cartao > 0 then
                                             wInd_emite       := to_char(nvl(wInd_Emite_Cartao,0));
                                             wNum_reemissao   := to_char(nvl(wNum_Reemissao_Cartao,0));
                                       else
                                          wInd_emite       := '0';
                                          wNum_reemissao   := '0';
                                          wDta_Solicitacao := '';
                                       end if;
                                    else
                                       wInd_emite       := '0';
                                       wNum_reemissao   := '0';
                                       wDta_Solicitacao := '';
                                    end if;
                                 elsif to_number(nvl(r_clientes_diario.cod_cartao_adic,'0')) = 101 then
                                    if wTem_Cartao_Adic = 1 then
                                       if wInd_Emite_Cartao = 1 then
                                          wInd_emite       := to_char(nvl(wInd_Emite_Cartao,0));
                                          wNum_reemissao   := to_char(nvl(wNum_Reemissao_Cartao,0));
                                          --alteracao 14/09/2011
                                       elsif (nvl(r_clientes_diario.ind_reem_cart_raux,0)) = 1 and
                                             --(to_date(nvl(wDta_Solicitacao,'01011001'),'dd/mm/yyyy') < trunc(sysdate - 730)) and
                                             (to_date(nvl(wDta_Solicitacao,'01011001'),'dd/mm/yyyy') < trunc(sysdate - 60)) and
                                             (r_clientes_diario.dta_solic_reem_raux >= (r_clientes_diario.dta_alteracao - 5)) then -- adicionado este teste dia 28/05/2014
                                              wInd_emite     := to_char(nvl(r_clientes_diario.ind_reem_cart_raux,0));
                                              wNum_reemissao := to_char(nvl(wNum_Reemissao_Cartao,0));
                                              wDta_Solicitacao := to_char(r_clientes_diario.dta_solic_reem_raux,'DDMMYYYY');
                                       elsif wNum_Reemissao_Cartao > 0 then
                                             wInd_emite       := to_char(nvl(wInd_Emite_Cartao,0));
                                             wNum_reemissao   := to_char(nvl(wNum_Reemissao_Cartao,0));
                                       else
                                          wInd_emite       := '1';
                                          wNum_reemissao   := '0';
                                          wDta_Solicitacao := wDta_Mvto;
                                       end if;
                                    else
                                       wInd_emite       := '1';
                                       wNum_reemissao   := '0';
                                       wDta_Solicitacao := wDta_Mvto;
                                    end if;
                                 else
                                    if wTem_Cartao_Adic = 1 then
                                       if wInd_Emite_Cartao = 1 then
                                          wInd_emite       := to_char(nvl(wInd_Emite_Cartao,0));
                                          wNum_reemissao   := to_char(nvl(wNum_Reemissao_Cartao,0));
                                          --alteracao 14/09/2011
                                       elsif (nvl(r_clientes_diario.ind_reem_cart_raux,0)) = 1 and
                                              --(to_date(nvl(wDta_Solicitacao,'01011001'),'dd/mm/yyyy') < trunc(sysdate - 730)) and
                                             (to_date(nvl(wDta_Solicitacao,'01011001'),'dd/mm/yyyy') < trunc(sysdate - 60)) and
                                             (r_clientes_diario.dta_solic_reem_raux >= (r_clientes_diario.dta_alteracao - 5)) then -- adicionado este teste dia 28/05/2014
                                              wInd_emite     := to_char(nvl(r_clientes_diario.ind_reem_cart_raux,0));
                                              wNum_reemissao := to_char(nvl(wNum_Reemissao_Cartao,0));
                                              wDta_Solicitacao := to_char(r_clientes_diario.dta_solic_reem_raux,'DDMMYYYY');
                                       elsif wNum_Reemissao_Cartao > 0 then
                                             wInd_emite       := to_char(nvl(wInd_Emite_Cartao,0));
                                             wNum_reemissao   := to_char(nvl(wNum_Reemissao_Cartao,0));
                                       else
                                           wInd_emite       := '0';
                                           wNum_reemissao   := '0';
                                           wDta_Solicitacao := '';
                                       end if;
                                    else
                                       wInd_emite       := '0';
                                       wNum_reemissao   := '0';
                                       wDta_Solicitacao := '';
                                    end if;
                                 end if;
                               elsif to_number(nvl(r_clientes_diario.cod_cartao_adic,0)) = 101 then
                                     wInd_emite       := 1;
                                     wNum_reemissao   := '0';
                                     wDta_Solicitacao := wDta_Mvto;
                                     wDes_Imp         := nvl(r_clientes_diario.des_nome_impr_cartao_adic,substr(r_clientes_diario.des_pessoa_raux,1,30));
                               else
                                  wInd_emite       := '0';
                                  wNum_reemissao   := '0';
                                  wDta_Solicitacao := '';
                                  wDes_Imp         := '';
                               end if;

                               if nvl(r_clientes_diario.cod_parentesco_raux,0) = 0 then
                                  wDes_parentesco := 'SEM PARENTESCO';
                               elsif nvl(r_clientes_diario.cod_parentesco_raux,0) = 1 then
                                  wDes_parentesco := 'CONJUGE';
                               elsif nvl(r_clientes_diario.cod_parentesco_raux,0) = 2 then
                                  wDes_parentesco := 'PAIS';
                               elsif nvl(r_clientes_diario.cod_parentesco_raux,0) = 3 then
                                  wDes_parentesco := 'FILHO';
                               elsif nvl(r_clientes_diario.cod_parentesco_raux,0) = 4 then
                                  wDes_parentesco := 'IRMAO';
                               elsif nvl(r_clientes_diario.cod_parentesco_raux,0) = 5 then
                                  wDes_parentesco := 'AVOS';
                               else
                                  wDes_parentesco := 'SEM PARENTESCO';
                               end if;

                               wDta_nasc_cartao   := to_char(r_clientes_diario.dta_nascto_raux,'ddmmyyyy');
                               wCod_situacao   := substr(lpad(r_clientes_diario.cod_cartao_adic,3,'0'),3,1);
                               wCod_funcao     := to_char(r_clientes_diario.cod_profissao_raux);
                         end if;

                         if wDes_imp is not null then
                         begin
                             INSERT INTO AI_PS_CARTOES_ADICIONAIS (COD_PESSOA, NUM_ADIC, DTA_TRANSACAO, DES_IMP, NUM_REEMISSAO,
                                                                   IND_EMITE, DES_PARENTESCO, TIP_TRANSACAO, TIP_STATUS_TRANSACAO,
                                                                   DTA_NASC, COD_SITUACAO, COD_FUNCAO, COD_UNIDADE_REG,
                                                                   COD_CARTAO, DTA_SOLICITACAO, DTA_REMESSA, COD_UNIDADE_SOLICITANTE)
                                                           VALUES (wCod_Completo, wNum_Adic, wDta_Mvto, wDes_Imp, wNum_reemissao,
                                                                   wInd_Emite, wDes_parentesco, 1 , 1,
                                                                   wDta_nasc_cartao, wCod_situacao, wCod_funcao, wCod_Unidade_Cli_NL,
                                                                   wCod_Cartao, wDta_solicitacao, wDta_Remessa_Cartao, r_clientes_diario.num_loja);

                                                        EXCEPTION
                                                             WHEN OTHERS THEN
                                                                  wErro    := 1;
                                                                  wTabela  := 'AI_PS_CARTOES_ADICIONAIS';
                                                                  wSqlcode := SQLCODE||'-'||substr(SQLERRM,1,2000);

                         end;
                         end if;
                   end loop;

                   if wErro = 0 then
                       --###########################
                       --ai_ps_observacoes
                       --###########################
                       iCount := 0;
                       while iCount < 1 loop
                             iCount := iCount + 1;
                             wDta_obs  := '01/01/2004';
                             if iCount = 1 then
                                wCod_obs     := '10';
                                wDes_resp    := 'LOJA';
                                wTxt_obs     := replace(r_clientes_diario.des_observacao,chr(39),'');
                             end if;
                             if (rtrim(ltrim(wTxt_obs)) is null) then
                                 if wCod_Reduzido is not null then
                                    wTemObsLoja := 0;
                                    begin
                                        SELECT COUNT(1)
                                          INTO wTemObsLoja
                                          FROM PS_OBSERVACOES
                                         WHERE NUM_MAQ = 0
                                           AND COD_PESSOA = wCod_Reduzido
                                           AND COD_OBS = 10
                                           AND DTA_OBS = TO_DATE('01/01/2004','DD/MM/YYYY')
                                           AND NUM_SEQ_OBS = 1;
                                     EXCEPTION
                                          WHEN NO_DATA_FOUND THEN
                                               wTemObsLoja := 0;
                                    end;

                                    if wTemObsLoja <> 0 then
                                       wTxt_obs := '*';
                                    end if;
                                 end if;
                             end if;

                             if (rtrim(ltrim(wTxt_obs))) is not null then
                             begin
                                 INSERT INTO AI_PS_OBSERVACOES (NUM_MAQ, COD_PESSOA, COD_OBS, DTA_OBS,
                                                                NUM_SEQ_OBS, DTA_TRANSACAO, DES_RESP, TXT_OBS,
                                                                TIP_TRANSACAO, TIP_STATUS_TRANSACAO, COD_UNIDADE_REG)
                                                        VALUES (0, wCod_Completo, wCod_obs, wDta_obs,
                                                                1, wDta_Mvto, wDes_resp, wTxt_obs,
                                                                1, 1, wCod_Unidade_Cli_NL);
                                                     EXCEPTION
                                                          WHEN OTHERS THEN
                                                               wErro    := 1;
                                                               wTabela  := 'AI_PS_CARTOES_ADICIONAIS';
                                                               wSqlcode := SQLCODE||'-'||substr(SQLERRM,1,2000);
                             end;
                             end if;

                       end loop;

                       --###########################
                       --ai_ps_colunas
                       --###########################
                       iCount := 0;
                       while iCount < 27 loop
                             iCount := iCount + 1;
                             wVlr_coluna := '';
                             if iCount = 1 then
                                 wVlr_coluna := r_clientes_diario.ind_conceito_ender;
                             elsif iCount = 2 then
                                 wVlr_coluna := r_clientes_diario.tip_telefone;
                             elsif iCount = 3 then
                                 wVlr_coluna := r_clientes_diario.des_cid_nasc;
                             elsif iCount = 4 then
                                 wVlr_coluna := r_clientes_diario.cod_uf_nasc;
                             elsif iCount = 5 then
                                 wVlr_Coluna := substr(lpad(r_clientes_diario.cod_cartao_adic,3,'0'),3,1);
                                 if (wVlr_Coluna <> '8') then
                                     wVlr_Coluna := '1';
                                 end if;
                             elsif iCount = 6 then
                                 wVlr_coluna := r_clientes_diario.ind_talao_cheques;
                             elsif iCount = 7 then
                                 wVlr_coluna := to_char(r_clientes_diario.dta_abertura_conta,'dd/mm/yyyy');
                             elsif iCount = 8 then
                                 wVlr_coluna := to_char(r_clientes_diario.cod_banco);
                             elsif iCount = 9 then
                                 wVlr_coluna := r_clientes_diario.ind_cartao_cred;
                             elsif iCount = 10 then
                                 wVlr_coluna := to_char(r_clientes_diario.ind_automovel);
                             elsif iCount = 11 then
                                 wVlr_coluna := to_char(r_clientes_diario.ind_spc);
                             elsif iCount = 12 then
                                 wVlr_coluna := r_clientes_diario.ind_funcionario;
                             elsif iCount = 13 then
                                 wVlr_coluna := r_clientes_diario.des_mae_raux;
                             elsif iCount = 14 then
                                 wVlr_coluna := to_number(r_clientes_diario.ind_spc_raux);
                             elsif iCount = 15 then
                                 wVlr_coluna := r_clientes_diario.des_setor_trab;
                             elsif iCount = 16 then
                                 wVlr_coluna := to_char(r_clientes_diario.cod_pes_aprov_cad);
                             elsif iCount = 17 then
                                 wVlr_coluna := '';
                             elsif iCount = 18 then
                                 wVlr_coluna := to_char(r_clientes_diario.cod_pes_digit_cad);
                             elsif iCount = 19 then
                                 wVlr_coluna := '';
                             elsif iCount = 20 then
                                 wVlr_coluna := '0';
                             elsif iCount = 21 then
                                 wVlr_coluna := to_char(r_clientes_diario.ind_novo_cadastro);
                             elsif iCount = 22 then
                                 wVlr_coluna := to_char(r_clientes_diario.ind_automovel_finan);
                             elsif iCount = 23 then
                                 wVlr_coluna := to_char(r_clientes_diario.des_setor_trab_adic);
                             elsif iCount = 24 then
                                 wVlr_coluna := to_char(wNome_Adicional);
					 		 elsif iCount = 25 then
			                     wVlr_coluna := to_char(r_clientes_diario.IND_POLITICAMENTE_EXPOSTA);
							 elsif iCount = 26 then
			                     wVlr_coluna := to_char(r_clientes_diario.vlr_liq_patrimonio,'FM9999999999990D00');
                             end if;
                             wSeq_coluna := to_char(iCount);

                             if iCount = 21 then
                                 wSeq_coluna := '24';
                             elsif iCount = 22 then
                                 wSeq_coluna := '30';
                             elsif iCount = 23 then
                                 wSeq_coluna := '44';
                             elsif iCount = 24 then
                                 wSeq_coluna := '45';
						  	 elsif iCount = 25 then
			                     wSeq_coluna := '210';
							 elsif iCount = 26 then
			                     wSeq_coluna := '50';
                             end if;

                             if wVlr_coluna is not null then
                             begin
                                INSERT INTO AI_PS_COLUNAS (COD_PESSOA, SEQ_COLUNA, DTA_TRANSACAO,
                                                           TIP_TRANSACAO, TIP_STATUS_TRANSACAO, VLR_COLUNA, COD_UNIDADE_REG)
                                                   VALUES (wCod_Completo, wSeq_Coluna, wDta_Mvto,
                                                           1, 1, wVlr_Coluna, wCod_Unidade_Cli_NL);
                                                EXCEPTION
                                                     WHEN OTHERS THEN
                                                          wErro    := 1;
                                                          wTabela  := 'AI_PS_COLUNAS';
                                                          wSqlcode := SQLCODE||'-'||substr(SQLERRM,1,2000);
                             end;
                             end if;
                      end loop;


                      --###########################
                      --ai_ps_comentarios
                      --###########################

                      if nvl(r_clientes_diario.des_comentario,'0') <> '0' then
                         wSeq_comentario := '10';
                         wDes_comentario := replace(r_clientes_diario.des_comentario,chr(39),'');
                      else
                         wSeq_comentario := '10';
                         wDes_comentario := '';
                      end if;

                      if (rtrim(ltrim(wDes_comentario)) is null) then
                          if wCod_Reduzido is not null then
                             wTemObsLoja := 0;
                             begin
                                 SELECT COUNT(1)
                                   INTO wTemObsLoja
                                   FROM PS_COMENTARIOS
                                  WHERE COD_GU = 1
                                    AND COD_PESSOA = wCod_Reduzido
                                    AND SEQ_COMENTARIO = 10;
                              EXCEPTION
                                   WHEN NO_DATA_FOUND THEN
                                        wTemObsLoja := 0;
                             end;

                             if wTemObsLoja <> 0 then
                             begin
                                 DELETE FROM nl.PS_COMENTARIOS
                                  WHERE COD_GU = 1
                                    AND COD_PESSOA = wCod_Reduzido
                                    AND SEQ_COMENTARIO = 10;
                             end;
                             end if;
                          end if;
                      end if;

                      if (rtrim(ltrim(wDes_comentario)) is not null) then
                      begin
                          INSERT INTO AI_PS_COMENTARIOS (COD_GU, COD_PESSOA, SEQ_COMENTARIO, DTA_TRANSACAO,
                                                         DES_COMENTARIO, TIP_TRANSACAO, TIP_STATUS_TRANSACAO, COD_UNIDADE_REG)
                                                 VALUES (1, wCod_completo, wSeq_comentario, wDta_Mvto,
                                                         wDes_Comentario, 1, 1, wCod_Unidade_Cli_NL);
                                              EXCEPTION
                                                   WHEN OTHERS THEN
                                                        wErro    := 1;
                                                        wTabela  := 'AI_PS_COLUNAS';
                                                        wSqlcode := SQLCODE||'-'||substr(SQLERRM,1,2000);
                      end;
                      end if;


                      --###########################
                      --ai_lc_limites
                      --###########################

                      -- Antonio - Funcao para "Alterar" os Limites de Creditos (31/05/2021)
                      --if (r_clientes_diario.num_loja = 159) or (r_clientes_diario.num_loja = 53) then
                      begin
                           r_clientes_diario.vlr_limite :=
                                 sislogweb.grz_retorna_valor_limite_sp(r_clientes_diario.tip_pessoa,
                                                                       wCod_completo,
                                                                       r_clientes_diario.num_cpf_cnpj,
                                                                       r_clientes_diario.vlr_limite,
                                                                       r_clientes_diario.vlr_creditscoring);
                      end;
                      --end if;

                      BEGIN
                          INSERT INTO AI_LC_LIMITES (COD_PESSOA, DTA_TRANSACAO, VLR_LIM_MENSAL, VLR_LIM_GERAL,
                                                     TIP_TRANSACAO, TIP_STATUS_TRANSACAO, QTD_PONTOS, VLR_LIM_MENSAL_ORIG,
                                                     VLR_LIM_GERAL_ORIG, DTA_PONTOS, COD_UNIDADE_REG, DTA_LIMITE)
                                             VALUES (wCod_completo,wDta_mvto,nvl(r_clientes_diario.vlr_limite,0),nvl(r_clientes_diario.vlr_limite,0),
                                                     1, 1, r_clientes_diario.qtd_ptos_creditscoring, nvl(r_clientes_diario.vlr_creditscoring,0),
                                                     nvl(r_clientes_diario.vlr_creditscoring,0), r_clientes_diario.dta_ult_creditscoring, wCod_unidade_Cli_NL, r_clientes_diario.dta_alt_limite);
                                          EXCEPTION
                                               WHEN OTHERS THEN
                                                    wErro    := 1;
                                                    wTabela  := 'AI_LC_LIMITES';
                                                    wSqlcode := SQLCODE||'-'||substr(SQLERRM,1,2000);
                      END;


                      if (nvl(r_clientes_diario.cod_cidade,0) = 44) then
				          wCodEmp                := '1';
                          wIND_VALIDA_UNIDADE    := '0'; 
                          wIND_ATUALIZA_BLOQUEIO := '1'; -- 0 ou 1
                          wIND_INC_CONTROLE      := '0';
                          
				          	
                          INSERT INTO nl.ai_ps_pessoas_r900 (COD_EMP,COD_PESSOA,DTA_TRANSACAO,IND_VALIDA_UNIDADE,IND_ATUALIZA_BLOQUEIO
                                                         ,COD_GU,COD_MASCARA,NUM_CPF,NUM_CNPJ,IND_INC_CONTROLE)
											      VALUES (wCodEmp,wCod_completo,wDta_Mvto,wIND_VALIDA_UNIDADE,wIND_ATUALIZA_BLOQUEIO
												         ,1,50,wNum_Cpf, wNum_Cgc, wIND_INC_CONTROLE);
			          end if;					  


                   end if;
                end if; -- end if erro cartoes adicionais
              end if; -- end if tip_cliente = 2
             end if;
          end if;
         end if;
        end if;
      else
         wErro := 1;
         wSqlcode := 'Cliente sem c¿digo da m¿scara 50.';
      end if; -- wCod_Completo >99

        if wErro = 0 then
           begin
               update grz_lojas_clientes_diario
                  set ind_processado = 2
                     ,txt_erro       = wTabela||wSqlcode
                where num_rede    = r_clientes_diario.num_rede
                  and num_loja    = r_clientes_diario.num_loja
                  and cod_cliente = r_clientes_diario.cod_cliente
                  and dta_mvto    = r_clientes_diario.dta_mvto;
           end;

		  wPI_WHERE := '';
          wPI_OPCAO := '50#'||wCod_Completo||'#'||wCod_Completo||'#'||to_char(wDta_mvto,'dd/mm/yyyy')||'#'||to_char(wDta_mvto,'dd/mm/yyyy')||'#'||'0#0#1#0#0';
          wPO_ERRO  := '';

           begin
               INSERT INTO GRZ_LOJAS_CLIENTES_CONTROLE (NUM_REDE,NUM_LOJA,COD_CLIENTE,DTA_MVTO)
                                                values (r_clientes_diario.num_rede,r_clientes_diario.num_loja,r_clientes_diario.cod_cliente,to_char(r_clientes_diario.dta_mvto,'dd/mm/yyyy')) ;

           end;

           begin
              nl.AI_PS_IMP_TABELA_SP(wPI_WHERE,wPI_OPCAO,wPO_ERRO);
           end;
           --insert INTO jaisson VALUES ('Erro: Tabela '||wTabela||' '||wCod_Completo||' '||wSqlcode);
           COMMIT;
		   
	     -- chama a geracao de outros codigos de mascara da mesma pessoa 
         if r_clientes_diario.tip_pessoa = 1 then
		 OPEN c_geracao_fisicas;
         FETCH c_geracao_fisicas INTO r_geracao_fisicas;
         WHILE c_geracao_fisicas%FOUND LOOP
         BEGIN
	         wPI_WHERE := '';
             wPI_OPCAO := '50#'||r_geracao_fisicas.cod_pessoa||'#'||r_geracao_fisicas.cod_pessoa||'#'||to_char(wDta_mvto,'dd/mm/yyyy')||'#'||to_char(wDta_mvto,'dd/mm/yyyy')||'#'||'0#0#1#0#0';
             wPO_ERRO  := '';
	     
	         begin
                  nl.AI_PS_IMP_TABELA_SP(wPI_WHERE,wPI_OPCAO,wPO_ERRO);
             end;
		     
		     insert INTO jaisson VALUES (wPI_OPCAO|| '   ERRO = '||wPO_ERRO);
	     
	     
         END;
         FETCH c_geracao_fisicas INTO r_geracao_fisicas;
         END LOOP;
         CLOSE c_geracao_fisicas;
         
	     else
	     OPEN c_geracao_juridicas;
         FETCH c_geracao_juridicas INTO r_geracao_juridicas;
         WHILE c_geracao_juridicas%FOUND LOOP
         BEGIN
	         wPI_WHERE := '';
             wPI_OPCAO := '50#'||r_geracao_juridicas.cod_pessoa||'#'||r_geracao_juridicas.cod_pessoa||'#'||to_char(wDta_mvto,'dd/mm/yyyy')||'#'||to_char(wDta_mvto,'dd/mm/yyyy')||'#'||'0#0#1#0#0';
             wPO_ERRO  := '';
                
	         begin
                 nl.AI_PS_IMP_TABELA_SP(wPI_WHERE,wPI_OPCAO,wPO_ERRO);
             end;
		     
		     --insert INTO jaisson VALUES (wPI_OPCAO|| '   ERRO = '||wPO_ERRO);
	     
         END;
         FETCH c_geracao_juridicas INTO r_geracao_juridicas;
         END LOOP;
         CLOSE c_geracao_juridicas;		   
         end if;
		 
	     COMMIT;
		   
		   
        else
           ROLLBACK;
           begin
               update grz_lojas_clientes_diario
                  set ind_processado = 3
                     ,txt_erro       = 'Erro: Tabela '||wTabela||' Cliente: '||wCod_Completo||
                                       ' SQLCODE: '||wSqlcode
                where num_rede    = r_clientes_diario.num_rede
                  and num_loja    = r_clientes_diario.num_loja
                  and cod_cliente = r_clientes_diario.cod_cliente
                  and dta_mvto    = r_clientes_diario.dta_mvto;
           end;


           COMMIT;

        end if;

      --end if; -- end if se j¿ possui cadastro, n¿o atualiza neste momento

      END;
      FETCH c_clientes_diario INTO r_clientes_diario;
      END LOOP;
      CLOSE c_clientes_diario;



      END;
END GRZ_CADCLI_DIARIO_NOITE_SP;
--END GRZCADCLIDIARIONOITESP_TESTE;