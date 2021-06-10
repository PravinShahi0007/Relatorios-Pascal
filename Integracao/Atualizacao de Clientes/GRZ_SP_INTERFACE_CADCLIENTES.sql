--CREATE OR REPLACE PROCEDURE GRZINTERFACECADCLIENTES_TESTE
create or replace procedure grz_sp_interface_cadclientes (pi_opcao in varchar2)
is
  begin
  declare
         pi_rede_ini             number;
         pi_rede_fim             number;
         pi_data_ini             varchar2(19);
         pi_data_fim             varchar2(19);
         pi_uni_ini              number;
         pi_uni_fim              number;
         pi_diretorio            varchar2(150);

         wi                      number;
         wf                      number;
         icount                  number;
         wdtaini                 date;
         wdtafim                 date;

         wdes_cidade             varchar2(100);
         wdes_uf                 varchar2(100);
         wgeraacao               varchar2(01);
         wind_negativado         number;
         wdta_negativacao        date;
         wdta_reabilitacao       date;
         wdta_hoje               date := trunc(sysdate);
         wcod_reduzido           number;
         wcod_pessoa_sislog      number;
         wcartaoadic             number;
         wind_emite_cartao       number;
         wnum_reemissao_cartao   number;
         wtem_cartao_adic        number;
         watividade_cli          varchar2(04);
         wexistefone             number;
         wtemobsloja             number;
         wvlr_negativado         number(18,2);
         wdta_atraso_spc         date;
         wdes_pessoa_nl          varchar2(100);
         wtip_pessoa_nl          varchar2(100);
         wdta_nasc_nl            varchar2(100);
         wnum_cpf_nl             varchar2(100);
         wdes_mae_nl             varchar2(100);
         wnum_cgc_nl             varchar2(100);
         wdta_fundacao_nl        varchar2(100);
         wnum_insc_est_nl        varchar2(100);
         wnum_cpf_cnpj_cli_nl    number;
         wcod_unidade_cli_nl     number;
         wlimite_cli             number;
         wtem_alt_unidade        number;
         wgravou                 number;
         wdata                   varchar2(20);
         wdta_mvto               date;
         wcadastro_loja          number(4);
         wnome_adicional         varchar2(50);
         wtodasredes             varchar2(15);
         wgerarmascara50         number(1);
         wgerarmascara50grz      number(1);
         wgerarmascara50prm      number(1);
         wgerarmascara50frg      number(1);
         wgerarmascara50tot      number(1);
         wcodclassevenda         number(2);
         wpossuicadastronarede   varchar2(100);
         wdtaafastamentolj       varchar2(10);
         wlojamigrada            number;
         windinativopessoa       number;

         --registro ai_ps_pessoas - 10
         wtip_lin_registro       varchar2(100);
         wcod_gu                 varchar2(100);
         wnum_rede               varchar2(100);
         wcod_pessoa             varchar2(100);
         wdta_transacao          varchar2(100);
         wdes_pessoa             varchar2(100);
         wcod_regiao             varchar2(100);
         wcod_cidade             varchar2(100);
         wcod_atividade          varchar2(100);
         wtip_pessoa             varchar2(100);
         wdta_cadastro           varchar2(100);
         wind_mala_direta        varchar2(100);
         wind_inativo            varchar2(100);
         wtip_transacao          varchar2(100);
         wtip_status_transacao   varchar2(100);
         wdig_pessoa             varchar2(100);
         wdes_fantasia           varchar2(100);
         wdes_endereco           varchar2(100);
         wdes_ponto_referencia   varchar2(100);
         wdes_bairro             varchar2(100);
         wnum_cep                varchar2(100);
         wnum_caixa_postal       varchar2(100);
         wdes_email              varchar2(100);
         wdes_home_page          varchar2(100);
         wcod_bloq               varchar2(100);
         wdta_bloq               varchar2(100);
         wdes_imagem             varchar2(100);
         wdta_afastamento        varchar2(100);
         wcod_pessoa_off         varchar2(100);
         wind_cadastro_off       varchar2(100);
         wcod_repres_off         varchar2(100);
         wdes_email_cel          varchar2(100);
         wcod_comprovante_end    varchar2(100);
         wdta_ult_alteracao      varchar2(100);
         wcod_pessoa_aprova      varchar2(100);
         wcod_devolucao          varchar2(100);
         wtxt_erro               varchar2(100);
         wcod_unidade_reg        varchar2(100);
         wdes_descricao_end      varchar2(100);
         wcod_negativacao        varchar2(100);
         wcod_negativacao_serasa varchar2(100);

         --registro ai_ps_clientes - 20
         wtip_abc                varchar2(100);
         wtip_end_corresp        varchar2(100);
         wind_fat_parcial        varchar2(100);
         wtip_aceite_entr        varchar2(100);
         wind_issqn              varchar2(100);
         wper_dcto_esp           varchar2(100);
         wnum_suframa            varchar2(100);
         wnum_sequencia_rota     varchar2(100);
         wcod_venc               varchar2(100);
         wcod_rota               varchar2(100);
         wcod_classe_venda       varchar2(100);
         wcod_transp             varchar2(100);
         wcod_cond_pgto          varchar2(100);
         wcod_oper               varchar2(100);
         wcod_localidade         varchar2(100);
         wper_dcto_fin           varchar2(100);
         wcod_unidade            varchar2(100);
         wdta_validade_suframa   varchar2(100);
         wcod_redespacho         varchar2(100);
         wind_retido             varchar2(100);
         wdia_recebimento        varchar2(100);

         --registro ai_ps_fisicas - 30
         wdta_nasc               varchar2(100);
         wnum_cpf                varchar2(100);
         wnum_rg                 varchar2(100);
         wdta_exp_rg             varchar2(100);
         wdes_org_exp_rg         varchar2(100);
         wtip_sexo               varchar2(100);
         wtip_civil              varchar2(100);
         wdes_conjuge            varchar2(100);
         wnum_ser_ctps           varchar2(100);
         wnum_ctps               varchar2(100);
         wdes_pai                varchar2(100);
         wdes_mae                varchar2(100);
         wdes_endereco_pai       varchar2(100);
         wdes_bairro_pai         varchar2(100);
         wnum_cep_pai            varchar2(100);
         wtip_residencia         varchar2(100);
         wvlr_aluguel            varchar2(100);
         wqtd_mes_residencia     varchar2(100);
         wvlr_renda              varchar2(100);
         wdes_renda              varchar2(100);
         wcod_comprov_renda      varchar2(100);
         wcod_pais               varchar2(100);
         wcod_uf                 varchar2(100);
         wcod_cidade_pais        varchar2(100);
         wcod_cid_nasc           varchar2(100);
         wdes_nacionalidade      varchar2(100);
         wdta_casamento          varchar2(100);
         wnum_cpf_conjuge        varchar2(100);
         wnum_rg_conjuge         varchar2(100);
         wdta_exp_rg_conjuge     varchar2(100);
         wdes_org_rg_conjuge     varchar2(100);
         wdta_nasc_conjuge       varchar2(100);
         wnum_pis                varchar2(100);
         wnum_insc_est           varchar2(100);
         wdta_ini_residencia     varchar2(100);
         wind_sexo               varchar2(100);
         wcod_parentesco         varchar2(100);

         --registro ai_ps_juridicas - 35
         wnum_cgc                    varchar2(100);
         wvlr_capital_social         varchar2(100);
         wdta_fundacao               varchar2(100);
         wqtd_funcionarios           varchar2(100);
         wnum_cert_qualidade         varchar2(100);
         wcod_ean                    varchar2(100);
         wdta_ult_alt_capital_social varchar2(100);
         wcod_reg_ibama              varchar2(100);
         wnum_aut_ibama              varchar2(100);
         wnum_contrato_social        varchar2(100);
         wnum_insc_mun               varchar2(100);
         windnaocontribuinte         varchar2(2);

         --registro ai_ps_telefones - 50
         wnum_seq                varchar2(100);
         wnum_fone               varchar2(100);
         wdes_fone               varchar2(100);
         wind_uso_ddd            varchar2(100);
         wtip_endereco           varchar2(100);

         --registro ai_ps_prof_clientes - 65
        wTip_inf_prof           VARCHAR2(100);
        wDes_emp                VARCHAR2(100);
        wCod_comprov            VARCHAR2(100);
        wCod_funcao             VARCHAR2(100);
        wVlr_salario            VARCHAR2(100);
        wNum_cnpj_empregador    VARCHAR2(100);
        wDta_admissao           VARCHAR2(100);
        wCompl_endereco   VARCHAR2(100);
        wCod_cidade_empresa VARCHAR2(100);
        wNum_end_empresa VARCHAR2(100);
        wTip_Funcao VARCHAR2(100);

                --registro ai_ps_ref_clientes - 70
        wNum_seq_ref            VARCHAR2(100);
        wDes_ref                VARCHAR2(100);
        wTip_referencia         VARCHAR2(100);

                --registro ai_ps_cartoes - 75
        wNum_dia_venc           VARCHAR2(100);
        wTip_doc_cobr           VARCHAR2(100);
        wDes_imp                VARCHAR2(100);
        wNum_reemissao          VARCHAR2(100);
        wInd_emite              VARCHAR2(100);
        wDta_nasc_cartao        VARCHAR2(100);
        wDta_validade           VARCHAR2(100);
        wDta_fechamento         VARCHAR2(100);
        wCod_situacao           VARCHAR2(100);
        wCod_Cartao             VARCHAR2(100);
        wCod_Tipo_Cartao        VARCHAR2(100);
        wDta_Solicitacao        VARCHAR2(100);
        wDta_Remessa_Cartao     VARCHAR2(100);

                --registro ai_ps_cartoes_adicionais - 80
        wNum_adic               VARCHAR2(100);
        wDes_parentesco         VARCHAR2(100);

                --registro ai_ps_observacoes - 85
        wNum_maq                VARCHAR2(100);
        wCod_obs                VARCHAR2(100);
        wDta_obs                VARCHAR2(100);
        wNum_seq_obs            VARCHAR2(100);
        wDes_resp               VARCHAR2(100);
        wTxt_obs                VARCHAR2(100);

                --registro ai_ps_colunas - 90
        wSeq_coluna             VARCHAR2(100);
        wVlr_coluna             VARCHAR2(100);

                --registro ai_ps_comentarios - 95
        wSeq_comentario         VARCHAR2(100);
        wDes_comentario         VARCHAR2(100);

                --registro ai_ps_mascaras - 110
        wCod_mascara            VARCHAR2(100);
        wCod_completo           VARCHAR2(100);
        wCod_niv0               VARCHAR2(100);
        wCod_editado            VARCHAR2(100);
        wCod_niv1               VARCHAR2(100);
        wCod_niv2               VARCHAR2(100);
        wCod_niv3               VARCHAR2(100);
        wCod_niv4               VARCHAR2(100);
        wCod_niv5               VARCHAR2(100);
        wCod_niv6               VARCHAR2(100);
        wCod_niv7               VARCHAR2(100);
        wCod_niv8               VARCHAR2(100);
        wCod_niv9               VARCHAR2(100);

        --registro ai_lc_limites - 115
        wVlr_lim_mensal         VARCHAR2(100);
        wVlr_lim_geral          VARCHAR2(100);
        wQtd_pontos             VARCHAR2(100);
        wCod_moeda              VARCHAR2(100);
        wVlr_lim_mensal_orig    VARCHAR2(100);
        wVlr_lim_geral_orig     VARCHAR2(100);
        wDta_venc               VARCHAR2(100);
        wDta_pontos             VARCHAR2(100);
        wDta_limite             VARCHAR2(100);

        --registro ai_cr_acoes_cobranca - 70
                wCod_unidade_Tit        VARCHAR2(100);
                wNum_titulo             VARCHAR2(100);
                wCod_compl              VARCHAR2(100);
                wNum_parcela            VARCHAR2(100);
        wNum_acao               VARCHAR2(100);
            wDta_acao               VARCHAR2(100);
        wDta_remessa            VARCHAR2(100);
        wDta_retorno_spc        VARCHAR2(100);
        wInd_telefonema         VARCHAR2(100);
        wNum_sessao             VARCHAR2(100);
        wInd_acao               VARCHAR2(100);
        wDta_carta_cobr         VARCHAR2(100);
        wIndAprovaExterno     VARCHAR2(100);
        wCodConsentimento    varchar2(100);
        wVersaoTextoAprovado VARCHAR2(100);
        
        --- registro AI_PS_PESSOAS_R900 - 900 
        wCodEmp                VARCHAR2(100);  
        wIND_VALIDA_UNIDADE    VARCHAR2(100);  
        wIND_ATUALIZA_BLOQUEIO VARCHAR2(100);    
        wCOD_APLICACAO         VARCHAR2(100);
        wIND_INC_CONTROLE      VARCHAR2(100);
        wDES_USO_RESTRITO      VARCHAR2(100);
        
        
      cursor c_cr_titulos_acao_n is
          select a.cod_unidade
                ,a.num_titulo
                ,a.cod_compl
                ,a.num_parcela
                ,a.dta_vencimento
            from cr_titulos a
           where a.ind_pago       = 0
             and a.cod_emp+0      = 1
             and a.cod_unidade    = wCod_unidade_Tit
             and a.cod_pessoa     = wCod_Reduzido
             and a.num_titulo     = wNum_titulo
           order by a.dta_vencimento;
      r_cr_titulos_acao_n c_cr_titulos_acao_n%rowtype;

      cursor c_cr_titulos_dt_n is
          select a.cod_unidade
                ,a.num_titulo
                ,a.cod_compl
                ,a.num_parcela
                ,a.dta_vencimento
            from cr_titulos a
           where a.dta_vencimento = wdta_atraso_spc
             and a.ind_pago       = 0
             and a.cod_emp+0      = 1
             and a.cod_pessoa     = wCod_Reduzido;
      r_cr_titulos_dt_n c_cr_titulos_dt_n%rowtype;

      cursor c_cr_titulos_vlr_n is
          select /*+ index (a crtit_pk) */
                 a.cod_unidade
                ,a.num_titulo
                ,a.cod_compl
                ,a.num_parcela
                ,a.dta_vencimento
            from cr_titulos    a
                ,cr_historicos b
           where a.cod_emp        = b.cod_emp
             and a.cod_unidade    = b.cod_unidade
             and a.cod_pessoa     = b.cod_pessoa
             and a.num_titulo     = b.num_titulo
             and a.cod_compl      = b.cod_compl
             and a.num_parcela    = b.num_parcela
             and b.vlr_lancamento = wvlr_negativado
             and a.ind_pago       = 0
             and a.cod_emp+0      = 1
             and a.cod_pessoa     = wCod_Reduzido
          order by a.dta_vencimento;
      r_cr_titulos_vlr_n c_cr_titulos_vlr_n%rowtype;

      cursor c_cr_titulos_dt_min_n is
          select a.cod_unidade
                ,a.num_titulo
                ,a.cod_compl
                ,a.num_parcela
                ,a.dta_vencimento
            from cr_titulos a
           where a.ind_pago    = 0
             and a.cod_emp+0   = 1
             and a.cod_pessoa  = wCod_Reduzido
           order by a.dta_vencimento;
      r_cr_titulos_dt_min_n c_cr_titulos_dt_min_n%rowtype;

      cursor c_cr_titulos_acao_r is
          select a.cod_unidade
                ,a.num_titulo
                ,a.cod_compl
                ,a.num_parcela
                ,a.dta_vencimento
            from cr_titulos a
           where a.ind_pago       = 1
             and a.cod_emp+0      = 1
             and a.cod_unidade    = wCod_unidade_Tit
             and a.cod_pessoa     = wCod_Reduzido
             and a.num_titulo     = wNum_titulo
           order by a.dta_vencimento;
      r_cr_titulos_acao_r c_cr_titulos_acao_r%rowtype;

      cursor c_cr_titulos_dt_r is
          select a.cod_unidade
                ,a.num_titulo
                ,a.cod_compl
                ,a.num_parcela
                ,a.dta_vencimento
            from cr_titulos a
           where a.dta_vencimento = wdta_atraso_spc
             and a.ind_pago       = 1
             and a.cod_emp+0      = 1
             and a.cod_pessoa     = wCod_Reduzido;
      r_cr_titulos_dt_r c_cr_titulos_dt_r%rowtype;

      cursor c_cr_titulos_vlr_r is
          select /*+ index (a crtit_pk) */
                 a.cod_unidade
                ,a.num_titulo
                ,a.cod_compl
                ,a.num_parcela
                ,a.dta_vencimento
            from cr_titulos    a
                ,cr_historicos b
           where a.cod_emp        = b.cod_emp
             and a.cod_unidade    = b.cod_unidade
             and a.cod_pessoa     = b.cod_pessoa
             and a.num_titulo     = b.num_titulo
             and a.cod_compl      = b.cod_compl
             and a.num_parcela    = b.num_parcela
             and b.vlr_lancamento = wvlr_negativado
             and a.ind_pago       = 1
             and a.cod_emp+0      = 1
             and a.cod_pessoa     = wCod_Reduzido
          order by a.dta_vencimento;
      r_cr_titulos_vlr_r c_cr_titulos_vlr_r%rowtype;

      cursor c_cr_titulos_dt_min_r is
          select a.cod_unidade
                ,a.num_titulo
                ,a.cod_compl
                ,a.num_parcela
                ,a.dta_vencimento
            from cr_titulos a
           where a.ind_pago    = 1
             and a.cod_emp+0   = 1
             and a.cod_pessoa  = wCod_Reduzido
           order by a.dta_vencimento;
      r_cr_titulos_dt_min_r c_cr_titulos_dt_min_r%rowtype;

      CURSOR c_clientes_sislog IS
               select *
                   from grz_lojas_clientes_sislog a
                  where a.num_rede       >= pi_rede_ini
                    and a.num_rede       <= pi_rede_fim
                    and a.cod_unidade    >= pi_uni_ini
                    and a.cod_unidade    <= pi_uni_fim
                    and a.dta_importacao >= to_date(pi_data_ini,'dd/mm/yyyy hh24:mi:ss')
                    and a.dta_importacao <= to_date(pi_data_fim,'dd/mm/yyyy hh24:mi:ss')
                    --and a.num_loja       not in (25)
                    --and a.cod_cliente     = 0
                    -- and a.cod_cliente in (1801028001)
                    and not exists (select 1 from grz_lojas_clientes_controle b
                                      where a.num_rede     = b.num_rede
                                        and a.num_loja       = b.num_loja
                                        and a.cod_cliente = b.cod_cliente
                                        and a.dta_mvto  = b.dta_mvto);
       r_clientes_sislog c_clientes_sislog%ROWTYPE;

      CURSOR c_clivv_sislog IS
               select *
                   from grz_lojas_clientesvv_sislog a
                  where a.num_rede       >= pi_rede_ini
                    and a.num_rede       <= pi_rede_fim
                    and a.cod_unidade    >= pi_uni_ini
                    and a.cod_unidade    <= pi_uni_fim
                    --and a.cod_cliente     = 74146122015
                    and a.dta_importacao >= to_date(pi_data_ini,'dd/mm/yyyy hh24:mi:ss')
                    and a.dta_importacao <= to_date(pi_data_fim,'dd/mm/yyyy hh24:mi:ss')
                    and not exists (select 1 from grz_lojas_clientes_sislog b
                                      where a.num_rede    = b.num_rede
                                        and a.num_loja    = b.num_loja
                                        and a.cod_cliente = b.cod_cliente
                                        and a.dta_mvto    = b.dta_mvto);
       r_clivv_sislog c_clivv_sislog%ROWTYPE;

      CURSOR c_spc_sislog IS
               select *
                   from grz_lojas_acoes_cobranca
                  where num_rede       >= pi_rede_ini
                    and num_rede       <= pi_rede_fim
                    and cod_unidade    >= pi_uni_ini
                    and cod_unidade    <= pi_uni_fim
                    and dta_importacao >= to_date(pi_data_ini,'dd/mm/yyyy hh24:mi:ss')
                    and dta_importacao <= to_date(pi_data_fim,'dd/mm/yyyy hh24:mi:ss');

       r_spc_sislog c_spc_sislog%ROWTYPE;


      CURSOR c_clientes_cartoes IS
              select *
                from grz_lojas_clientes_cartoes
                  where num_rede       >= pi_rede_ini
                    and num_rede       <= pi_rede_fim
                    and num_loja       >= pi_uni_ini
                    and num_loja       <= pi_uni_fim
                    and dta_lancamento >= trunc(to_date(pi_data_ini,'dd/mm/yyyy hh24:mi:ss'))
                    and dta_lancamento <= trunc(to_date(pi_data_fim,'dd/mm/yyyy hh24:mi:ss'))
                  order by num_loja, cod_cliente;
          r_clientes_cartoes c_clientes_cartoes%ROWTYPE;

          CURSOR c_verifica_pessoa IS
                   SELECT T.COD_PESSOA
                         ,M.COD_COMPLETO
              FROM PS_CLIENTES T
                 ,PS_MASCARAS M
                 ,PS_PESSOAS P
                      WHERE T.COD_PESSOA = M.COD_PESSOA
                        AND M.COD_PESSOA = P.COD_PESSOA
                        AND M.COD_MASCARA = 50
                        and (INSTR(','||wTodasRedes||',' , ','||M.cod_niv1||',') > 0)
                        AND (EXISTS (SELECT 1 FROM PS_FISICAS F
                                      WHERE T.COD_PESSOA = F.COD_PESSOA
                                        AND F.NUM_CPF = R_CLIENTES_SISLOG.NUM_CPF_CNPJ)
                         OR  EXISTS (SELECT 1 FROM PS_JURIDICAS J
                                      WHERE T.COD_PESSOA = J.COD_PESSOA
                                        AND J.NUM_CGC    = R_CLIENTES_SISLOG.NUM_CPF_CNPJ))
                     ORDER BY T.COD_CLASSE_VENDA, P.DTA_AFASTAMENTO DESC;
          r_verifica_pessoa c_verifica_pessoa%ROWTYPE;

          CURSOR c_verifica_mascara IS
               SELECT *
               FROM PS_MASCARAS M
                  WHERE M.COD_MASCARA = 50
                    AND (EXISTS (SELECT 1 FROM PS_FISICAS F
                                  WHERE M.COD_PESSOA = F.COD_PESSOA
                                    AND F.NUM_CPF = R_CLIENTES_SISLOG.NUM_CPF_CNPJ)
                     OR  EXISTS (SELECT 1 FROM PS_JURIDICAS J
                                  WHERE M.COD_PESSOA = J.COD_PESSOA
                                    AND J.NUM_CGC    = R_CLIENTES_SISLOG.NUM_CPF_CNPJ))
                  ORDER BY M.COD_NIV1;
          r_verifica_mascara c_verifica_mascara%ROWTYPE;


         file_handle1 UTL_FILE.FILE_TYPE;
         file_handle2 UTL_FILE.FILE_TYPE;
         file_handle3 UTL_FILE.FILE_TYPE;

          nome_arq1   VARCHAR2(50);
          nome_arq2   VARCHAR2(50);
          nome_arq3   VARCHAR2(50);

          BEGIN
           wi := INSTR(pi_opcao, '#', 1, 1);
           pi_rede_ini := TO_NUMBER(SUBSTR(pi_opcao, 1,(wi-1)));
           wf := INSTR(pi_opcao, '#', 1, 2);
           pi_rede_fim := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
           wi := wf;
           wf := INSTR(pi_opcao, '#', 1, 3);
           pi_Data_Ini := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));
           wi := wf;
           wf := INSTR(pi_opcao, '#', 1, 4);
              pi_Data_Fim := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));
               wi := wf;
           wf := INSTR(pi_opcao, '#', 1, 5);
              pi_uni_ini := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
               wi := wf;
           wf := INSTR(pi_opcao, '#', 1, 6);
           pi_uni_fim := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
           wi := wf;
           wf := INSTR(pi_opcao, '#', 1, 7);
               pi_Diretorio := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));
-- 10#10#14/05/2021 00:00:00#14/05/2021 23:59:59#19#19#/mnt/nlgestao/nlcomum/INTERFAC#


               if pi_rede_ini = pi_rede_fim then
                    if pi_rede_ini = 10 then
                           nome_arq1 := 'G';
                       elsif pi_rede_ini = 20 then
                             nome_arq1 := 'B';
                         elsif pi_rede_ini = 30 then
                               nome_arq1 := 'P';
                    elsif pi_rede_ini = 40 then
                                  nome_arq1 := 'F';
                               elsif pi_rede_ini = 50 then
                                     nome_arq1 := 'T';
                                  elsif pi_rede_ini = 55 then
                                       nome_arq1 := 'V';
                                     elsif pi_rede_ini = 70 then
                                          nome_arq1 := 'C';

            else
                nome_arq1 := 'Z';
            end if;
           else
               nome_arq1 := 'Z';
               end if;
               nome_arq2 := nome_arq1||'SPC'||to_char(to_Date(pi_Data_fim,'dd/mm/yyyy hh24:mi:ss'),'ddmmyyyy')||'.TXT';
           nome_arq3 := nome_arq1||'CLI'||to_char(to_Date(pi_Data_fim,'dd/mm/yyyy hh24:mi:ss'),'ddmmyyyy')||'.TXT';
           nome_arq1 := nome_arq1||'CLI50'||to_char(to_Date(pi_Data_fim,'dd/mm/yyyy hh24:mi:ss'),'ddmmyyyy')||'.TXT';


           file_handle1 := UTL_FILE.FOPEN(pi_Diretorio,nome_arq1,'W');
           file_handle2 := UTL_FILE.FOPEN(pi_Diretorio,nome_arq2,'W');
           file_handle3 := UTL_FILE.FOPEN(pi_Diretorio,nome_arq3,'W');

           ----file_handle := UTL_FILE.FOPEN('F:\NLGESTAO\INTERFAC',nome_arq,'W');

           wDtaIni := to_date(to_Date(pi_Data_Ini,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy');
           wDtaFim := to_date(to_Date(pi_Data_fim,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy');


               -- exclui clientes das AI que entrarm no diario e foram alterados apos o envio para a ADM
               GRZ_CADCLI_EXCLUI_AI_SP(pi_rede_ini, pi_rede_fim, wDtaIni, wDtaFim);


             --- busca clientes credi¿¿¿rio do novo sislog
           OPEN c_clientes_sislog;
           FETCH c_clientes_sislog INTO r_clientes_sislog;
           WHILE c_clientes_sislog%FOUND LOOP
           BEGIN
                wNum_Cgc := '';
                wNum_cpf := '';
                
                if (r_clientes_sislog.num_rede = 70) then
                    wNum_rede := lPad(to_char(r_clientes_sislog.cod_emp_cadastro),2,'0');
                else
                    wNum_rede := lPad(to_char(r_clientes_sislog.num_rede),2,'0');
                end if;

                     /*wLojaMigrada := 0;
                begin
                   select cod_unidade
                     Into wLojaMigrada
                     from grz_lojas_migracao_sislog
                    where cod_unidade = r_clientes_sislog.num_loja;
                 exception
                     when no_data_found then
                          wLojaMigrada := 0;
                end; */

            --###########################
            --ai_ps_pessoas
            --###########################
            wTip_lin_registro     := '10';
            wCod_gu               := '1';
            -- mudado para gerar pelo cod_pessoa, n¿o mais pela m¿scara quando o cliente j¿ existe
            --wCod_pessoa           := lpad(wNum_rede,2,'0')||lpad(to_char(r_clientes_sislog.cod_cliente),12,'0');

                --if r_clientes_sislog.cod_pessoa is null then
                 --  if (R_CLIENTES_SISLOG.NUM_REDE <> 70) and (R_CLIENTES_SISLOG.NUM_REDE <> 40) and (wLojaMigrada = 0) then
                    --    wCod_pessoa           := lpad(wNum_rede,2,'0')||lpad(to_char(r_clientes_sislog.cod_cliente),12,'0');
                   --  else
                   wCod_pessoa           := lpad(wNum_rede,2,'0')||lpad(to_char(r_clientes_sislog.cod_cartao_cliente),12,'0');
                  --      wCod_pessoa           := lpad(r_clientes_sislog.cod_emp_cadastro,2,'0')||lpad(to_char(r_clientes_sislog.cod_cartao_cliente),12,'0');
                  --   end if;
                  --else
            --   wCod_pessoa := r_clientes_sislog.cod_pessoa;
                --end if;
            wDta_transacao        := to_char(r_clientes_sislog.dta_mvto,'ddmmyyyy');
            wDes_pessoa           := replace(r_clientes_sislog.des_cliente,chr(39),'');
            wCod_regiao           := '300';
                      wCod_Pessoa_SisLog    := r_clientes_sislog.cod_pessoa;
                      wData                 := to_char(r_clientes_sislog.dta_mvto,'yyyymmdd')||
                                               lPad(replace(nvl(r_clientes_sislog.hor_alteracao,0),':',''),6,'0');
                      wDta_mvto             := to_date(wData,'yyyy/mm/dd hh24:mi:ss');

                      wCod_Reduzido         := '';
                      -- comentado aqui para n¿o buscar mais pelo c¿digo reduzido
                      /* begin
                   SELECT COD_PESSOA
                       INTO wCod_Reduzido
                       FROM PS_MASCARAS
                     WHERE COD_MASCARA  = 50
                         AND COD_COMPLETO = wCod_pessoa;
                         EXCEPTION
                           WHEN NO_DATA_FOUND THEN
                              wCod_Reduzido := '';
                  end; */

                  if R_CLIENTES_SISLOG.NUM_REDE = 70 then
                     wTodasRedes := '10,30,40,50';
                  else
                     wTodasRedes := R_CLIENTES_SISLOG.NUM_REDE;
                  end if;

                  if (R_CLIENTES_SISLOG.COD_PESSOA is not null) and (R_CLIENTES_SISLOG.NUM_REDE = 70) then
                   begin
                       SELECT T.COD_PESSOA
                             ,A.COD_COMPLETO
                         INTO wCod_Reduzido
                             ,wCod_pessoa
                         FROM PS_CLIENTES T, PS_MASCARAS A
                              WHERE T.COD_PESSOA = A.COD_PESSOA
                                AND A.COD_MASCARA = 50
                                  AND T.COD_PESSOA = R_CLIENTES_SISLOG.COD_PESSOA
                                AND (EXISTS (SELECT 1 FROM PS_FISICAS F
                                              WHERE T.COD_PESSOA = F.COD_PESSOA
                                                AND F.NUM_CPF = R_CLIENTES_SISLOG.NUM_CPF_CNPJ)
                                 OR  EXISTS (SELECT 1 FROM PS_JURIDICAS J
                                              WHERE T.COD_PESSOA = J.COD_PESSOA
                                                AND J.NUM_CGC    = R_CLIENTES_SISLOG.NUM_CPF_CNPJ))
                                AND ROWNUM = 1;
                       exception
                           WHEN NO_DATA_FOUND THEN
                                 wCod_Reduzido := '';
                  end;
                  elsif (R_CLIENTES_SISLOG.COD_PESSOA is not null) then
                   begin
                       SELECT T.COD_PESSOA
                             ,A.COD_COMPLETO
                         INTO wCod_Reduzido
                             ,wCod_pessoa
                         FROM PS_CLIENTES T, PS_MASCARAS A
                              WHERE T.COD_PESSOA = A.COD_PESSOA
                                AND A.COD_MASCARA = 50
                                AND A.COD_NIV1 = R_CLIENTES_SISLOG.NUM_REDE
                                  AND T.COD_PESSOA = R_CLIENTES_SISLOG.COD_PESSOA
                                AND (EXISTS (SELECT 1 FROM PS_FISICAS F
                                              WHERE T.COD_PESSOA = F.COD_PESSOA
                                                AND F.NUM_CPF = R_CLIENTES_SISLOG.NUM_CPF_CNPJ)
                                 OR  EXISTS (SELECT 1 FROM PS_JURIDICAS J
                                              WHERE T.COD_PESSOA = J.COD_PESSOA
                                                AND J.NUM_CGC    = R_CLIENTES_SISLOG.NUM_CPF_CNPJ));
                       exception
                           WHEN NO_DATA_FOUND THEN
                                 wCod_Reduzido := '';
                  end;
                  end if;

                  if (wCod_Reduzido is null) then
                  begin
                        OPEN c_verifica_pessoa;
                        FETCH c_verifica_pessoa INTO r_verifica_pessoa;
                        IF c_verifica_pessoa%FOUND THEN
                        BEGIN
                      wCod_Reduzido := r_verifica_pessoa.cod_pessoa;
                      wCod_pessoa  := r_verifica_pessoa.cod_completo;
                            END;
                            END IF;
                            CLOSE c_verifica_pessoa;
                  end;
                  end if;

                  --if (wCod_Reduzido is null) then
                      wGerarMascara50 := 1;
                  --else
                  --    wGerarMascara50 := 0;
                      --wCod_pessoa     := wCod_Reduzido;
                  --end if;



                      /*
                      if wCod_Pessoa_SisLog > 0 then
                          if wCod_Reduzido > 0 then
                              if wCod_Pessoa_SisLog <> wCod_Reduzido then
                                  salva_wpesquisa('CadClientes',777,'Codigo SisLog: '||lpad(to_char(wCod_Pessoa_SisLog),7,'0')||' C¿¿¿digo NL: '||lpad(to_char(wCod_Reduzido),7,'0'),wCod_Reduzido);
                              end if;
                          else
                              salva_wpesquisa('CadClientes',776,'C¿¿¿digo SisLog: '||lpad(to_char(wCod_Pessoa_SisLog),7,'0')||' C¿¿¿digo NL: '||lpad(to_char(nvl(wCod_Reduzido,0)),7,'0'),wCod_Pessoa_SisLog);
                          end if;
                      elsif wCod_Reduzido > 0 then
                              salva_wpesquisa('CadClientes',778,'C¿¿¿digo SisLog: '||lpad(to_char(nvl(wCod_Pessoa_SisLog,0)),7,'0')||' C¿¿¿digo NL: '||lpad(to_char(wCod_Reduzido),7,'0'),wCod_Reduzido);
                      end if;
                      */

                      /*
                      if (wCod_Reduzido is null) and
                         (nvl(r_clientes_sislog.cod_pessoa,0) > 0) then
                        begin
                   SELECT COD_PESSOA
                       INTO wCod_Reduzido
                       FROM PS_MASCARAS
                     WHERE COD_MASCARA = 50
                         AND COD_PESSOA  = r_clientes_sislog.cod_pessoa;
                         EXCEPTION
                           WHEN NO_DATA_FOUND THEN
                              wCod_Reduzido := '';
                    end;
                  end if;
                  */

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
                      wCod_Unidade_Cli_NL := r_clientes_sislog.num_loja;
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
                                    wCod_Unidade_Cli_NL := r_clientes_sislog.cod_unidade;
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
                           wCod_Unidade_Cli_NL := r_clientes_sislog.num_loja;
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

                  wIndInativoPessoa := 0;

                  -- verifica se o cliente est¿ inativo
                  begin
                      SELECT T.Ind_Inativo
                        Into wIndInativoPessoa
                        FROM PS_CLIENTES T, PS_MASCARAS A, PS_PESSOAS P
                             WHERE T.COD_PESSOA = A.COD_PESSOA
                               AND A.Cod_Pessoa = P.COD_PESSOA
                               AND A.COD_MASCARA = 50
                               AND A.COD_NIV1    = wNum_rede
                               AND T.IND_INATIVO = 1
                               AND P.COD_PESSOA  = wCod_Reduzido;
                   EXCEPTION
                         WHEN NO_DATA_FOUND THEN
                               wIndInativoPessoa := 0;
                  end;

                  -- se estiver inativo, ativa o cliente - realizado em 14/05/2019
                  if wIndInativoPessoa = 1 then
                  begin
                      update ps_pessoas
                         set ind_inativo = 0
                       where cod_pessoa  = wCod_Reduzido;
                  end;

                  COMMIT;
                  end if;

            wNum_cpf_cnpj_Cli_NL := 0;
            ---if (wCod_Reduzido is not null) and
            --- (wAtividade_Cli <> 315) then
            if (wCod_Reduzido is not null) then
                if r_clientes_sislog.tip_pessoa <> 2 then
                            begin
                         SELECT NVL(NUM_CPF,0)
                             INTO wNum_cpf_cnpj_Cli_NL
                             FROM PS_FISICAS
                           WHERE COD_PESSOA = wCod_Reduzido;
                               EXCEPTION
                                 WHEN NO_DATA_FOUND THEN
                                      wNum_cpf_cnpj_Cli_NL := 0;
                        end;
                            if wNum_cpf_cnpj_Cli_NL <> 0 then
                                if wNum_cpf_cnpj_Cli_NL <> r_clientes_sislog.num_cpf_cnpj then
                                    salva_wpesquisa('CadClientes',777,to_char(wAtividade_Cli)||' Codigo SisLog: '||lpad(to_char(wCod_Pessoa_SisLog),7,'0')||' Codigo NL: '||lpad(to_char(wCod_Reduzido),7,'0')||
                                                    ' CPF SisLog: '||lpad(to_char(r_clientes_sislog.num_cpf_cnpj),11,'0')||' CPF NL: '||lpad(to_char(wNum_cpf_cnpj_Cli_NL),11,'0'),wCod_Reduzido);
                            end if;
                        end if;
                      else
                            begin
                         SELECT NVL(NUM_CGC,0)
                             INTO wNum_cpf_cnpj_Cli_NL
                             FROM PS_JURIDICAS
                           WHERE COD_PESSOA = wCod_Reduzido;
                               EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                     wNum_cpf_cnpj_Cli_NL := 0;
                        end;
                            if wNum_cpf_cnpj_Cli_NL <> 0 then
                                if wNum_cpf_cnpj_Cli_NL <> r_clientes_sislog.num_cpf_cnpj then
                                    salva_wpesquisa('CadClientes',777,to_char(wAtividade_Cli)||' Codigo SisLog: '||lpad(to_char(wCod_Pessoa_SisLog),7,'0')||' Codigo NL: '||lpad(to_char(wCod_Reduzido),7,'0')||
                                                    ' CNPJ SisLog: '||lpad(to_char(r_clientes_sislog.num_cpf_cnpj),14,'0')||' CNPJ NL: '||lpad(to_char(wNum_cpf_cnpj_Cli_NL),14,'0'),wCod_Reduzido);
                            end if;
                        end if;
                      end if;
                  end if;

            wDes_cidade           := r_clientes_sislog.des_cidade;
            wDes_uf               := r_clientes_sislog.cod_uf;
            wCod_cidade           := to_char(r_clientes_sislog.cod_cidade);
            wCod_atividade        := '300';
            wTip_pessoa           := to_char(r_clientes_sislog.tip_pessoa);
            wDta_cadastro         := to_char(r_clientes_sislog.dta_cadastro,'ddmmyyyy');
        --    wInd_mala_direta      := to_char(r_clientes_sislog.ind_mala_direta);
            wInd_mala_direta      := to_char(nvl(r_clientes_sislog.ind_aceitou_novidades,1));
            wInd_inativo          := '0'; --to_char(r_clientes_sislog.ind_inativo);
            wTip_transacao        := '1';
            wTip_status_transacao := '1';
            wDig_pessoa           := '';
            wDes_fantasia         := r_clientes_sislog.des_fantasia;
            wDes_endereco         := replace(r_clientes_sislog.des_endereco,chr(39),'');
            wDes_ponto_referencia := r_clientes_sislog.des_pto_refer;
            wDes_bairro           := replace(r_clientes_sislog.des_bairro,chr(39),'');
            wNum_cep              := replace(r_clientes_sislog.num_cep,chr(39),'');
            wNum_caixa_postal     := to_char(r_clientes_sislog.num_caixa_postal);
            wDes_email            := lower(replace(r_clientes_sislog.des_email,chr(39),''));
            wDes_home_page        := '';
            wCod_bloq             := '';
            wDta_bloq             := '';
            wDes_imagem           := '';
            wDta_afastamento      := to_char(r_clientes_sislog.dta_alteracao,'ddmmyyyy');
            wCod_pessoa_off       := '';
            wInd_cadastro_off     := '';
            wCod_repres_off       := '';
            wDes_email_cel        := '';
            wCod_comprovante_end  := to_char(r_clientes_sislog.cod_comprov_ender);
            wDta_ult_alteracao    := to_char(r_clientes_sislog.dta_alteracao,'ddmmyyyy');
            wCod_pessoa_aprova    := to_char(r_clientes_sislog.cod_pes_aprov_cad);
            wCod_devolucao        := to_char(r_clientes_sislog.ind_correio);
            wTxt_erro             := '';
            wCod_unidade_reg      := to_char(r_clientes_sislog.num_loja);
            wDes_descricao_end    := '';

                    wDes_pessoa_nl        := wDes_pessoa;
                    wTip_pessoa_nl        := wTip_pessoa;
            if (wCod_Reduzido is not null) and
               (wAtividade_Cli <> 315) then
                          begin
                       SELECT DES_PESSOA
                             ,TO_CHAR(TIP_PESSOA)
                             ,COD_NEGATIVACAO
                             ,COD_NEGATIVACAO_SERASA
                           INTO wDes_pessoa
                               ,wTip_pessoa
                               ,wCod_Negativacao
                               ,wCod_Negativacao_Serasa
                           FROM PS_PESSOAS
                         WHERE COD_PESSOA = wCod_Reduzido;
                             EXCEPTION
                               WHEN NO_DATA_FOUND THEN
                                  wDes_pessoa := wDes_pessoa_nl;
                                  wTip_pessoa := wTip_pessoa_nl;
                                  wCod_Negativacao := '';
                              wCod_Negativacao_Serasa := '';
                      end;
                  end if;
                        wTem_Alt_Unidade := 0;
                        if (wCod_Reduzido > 0) and
                           (wAtividade_Cli not in ( 1, 99, 100)) and -- teste para solicitacao da Mara Erro na importacao de clientes
                           (wCod_Unidade_Cli_NL <> r_clientes_sislog.num_loja) and
                           (wLimite_Cli > 0) and
                           (wNum_cpf_cnpj_Cli_NL = r_clientes_sislog.num_cpf_cnpj) and
                           (wNum_cpf_cnpj_Cli_NL > 0)  then
                            wCod_unidade_reg  := to_char(wCod_Unidade_Cli_NL);
--                            wTem_Alt_Unidade  := 1;

                        wGravou           := 0;
                        GRZ_SALVA_CADCLI_ALTERADO_SP(wCod_Reduzido, 1, wDta_mvto, wGravou);

                        insert into grz_cad_clientes_alterados
                                       (num_seq,dta_mvto,ind_mvto,cod_gu,cod_pessoa,dig_pessoa
                                       ,des_pessoa,des_fantasia,des_endereco,cod_regiao,des_ponto_referencia
                                       ,des_bairro,num_cep,cod_cidade,num_caixa_postal,des_email
                                       ,des_home_page,cod_atividade,tip_pessoa,dta_cadastro
                                       ,ind_mala_direta,cod_bloq,dta_bloq,des_imagem,ind_inativo
                                       ,dta_afastamento,cod_pessoa_off,ind_cadastro_off,cod_repres_off
                                       ,des_email_cel,cod_comprovante_end,dta_ult_alteracao,cod_pessoa_aprova
                                       ,cod_devolucao,des_descricao_end,cod_unidade,num_fone_residencial
                                       ,num_fone_comercial,num_fone_celular,num_fone_ramal
                                       ,txt_obs_loja,des_comentario_loja,num_cpf_cnpj,hor_alteracao
                                       ,cod_usuario_alt,cod_unidade_reg,num_rede,cod_cliente)
                                 values
                                      (grz_cad_cli_alt_seq.nextval,wDta_mvto,2,wCod_gu,wCod_Reduzido,wDig_pessoa
                                      ,wDes_pessoa,wDes_fantasia,wDes_endereco,wCod_regiao,wDes_ponto_referencia
                                      ,wDes_bairro,wNum_cep,wCod_cidade,wNum_caixa_postal,wDes_email
                                      ,wDes_home_page,wCod_atividade,wTip_pessoa,wDta_cadastro
                                      ,wInd_mala_direta,wCod_bloq,wDta_bloq,wDes_imagem,wInd_inativo
                                      ,wDta_afastamento,wCod_pessoa_off,wInd_cadastro_off,wCod_repres_off
                                      ,wDes_email_cel,wCod_comprovante_end,wDta_ult_alteracao,wCod_pessoa_aprova
                                      ,wCod_devolucao,wDes_descricao_end,r_clientes_sislog.Cod_unidade,r_clientes_sislog.des_fone_resid
                                      ,r_clientes_sislog.des_fone_comerc,r_clientes_sislog.des_fone_celular,r_clientes_sislog.des_ramal_comerc
                                      ,r_clientes_sislog.des_observacao,r_clientes_sislog.des_comentario,r_clientes_sislog.num_cpf_cnpj,r_clientes_sislog.hor_alteracao
                                      ,r_clientes_sislog.cod_usuario_alt,r_clientes_sislog.num_loja,r_clientes_sislog.num_rede,r_clientes_sislog.cod_cliente);
                        end if;

                        if wGerarMascara50 = 0 then
                        UTL_FILE.PUT_LINE(file_handle1,wTip_lin_registro||'^'||wCod_gu||'^'||
                                                   wCod_pessoa||'^'||wDta_transacao||'^'||wDes_pessoa||'^'||wCod_regiao||'^'||
                                                   wCod_cidade||'^'||wCod_atividade||'^'||wTip_pessoa||'^'||wDta_cadastro||'^'||
                                                   wInd_mala_direta||'^'||wInd_inativo||'^'||wTip_transacao||'^'||wTip_status_transacao||'^'||
                                                   wDig_pessoa||'^'||wDes_fantasia||'^'||wDes_endereco||'^'||wDes_ponto_referencia||'^'||
                                                   wDes_bairro||'^'||wNum_cep||'^'||wNum_caixa_postal||'^'||wDes_email||'^'||wDes_home_page||'^'||
                                                   wCod_bloq||'^'||wDta_bloq||'^'||wDes_imagem||'^'||wDta_afastamento||'^'||wCod_pessoa_off||'^'||
                                                   wInd_cadastro_off||'^'||wCod_repres_off||'^'||wDes_email_cel||'^'||wCod_comprovante_end||'^'||
                                                   wDta_ult_alteracao||'^'||wCod_pessoa_aprova||'^'||wCod_devolucao||'^'||wTxt_erro||'^'||
                                                   wCod_unidade_reg||'^'||'^'||wCod_Negativacao||'^'||'^'||'^'||'^'||'^'||wCod_Negativacao_Serasa);
                     else
                         UTL_FILE.PUT_LINE(file_handle3,wTip_lin_registro||'^'||wCod_gu||'^'||
                                                   wCod_pessoa||'^'||wDta_transacao||'^'||wDes_pessoa||'^'||wCod_regiao||'^'||
                                                   wCod_cidade||'^'||wCod_atividade||'^'||wTip_pessoa||'^'||wDta_cadastro||'^'||
                                                   wInd_mala_direta||'^'||wInd_inativo||'^'||wTip_transacao||'^'||wTip_status_transacao||'^'||
                                                   wDig_pessoa||'^'||wDes_fantasia||'^'||wDes_endereco||'^'||wDes_ponto_referencia||'^'||
                                                   wDes_bairro||'^'||wNum_cep||'^'||wNum_caixa_postal||'^'||wDes_email||'^'||wDes_home_page||'^'||
                                                   wCod_bloq||'^'||wDta_bloq||'^'||wDes_imagem||'^'||wDta_afastamento||'^'||wCod_pessoa_off||'^'||
                                                   wInd_cadastro_off||'^'||wCod_repres_off||'^'||wDes_email_cel||'^'||wCod_comprovante_end||'^'||
                                                   wDta_ult_alteracao||'^'||wCod_pessoa_aprova||'^'||wCod_devolucao||'^'||wTxt_erro||'^'||
                                                   wCod_unidade_reg||'^'||'^'||wCod_Negativacao||'^'||'^'||'^'||'^'||'^'||wCod_Negativacao_Serasa);
                     end if;

              if wTem_Alt_Unidade = 0 then
            --###########################
            --ai_ps_clientes
            --###########################
            wTip_lin_registro     := '20';
            wTip_abc              := '3';
            wTip_end_corresp      := to_char(r_clientes_sislog.tip_endereco);
            wInd_fat_parcial      := '1';
            wTip_aceite_entr      := '0';
            wInd_issqn            := '0';
            wPer_dcto_esp         := '';
            wNum_suframa          := '';
            wNum_sequencia_rota   := '';
            wCod_venc             := '';
            wCod_rota             := '';
            wCod_classe_venda     := '10';
            wCod_transp           := '';
            wCod_cond_pgto        := '10';
            wCod_oper             := '';
            wCod_localidade       := '';
            wPer_dcto_fin         := '';
            wCod_unidade          := to_char(wCod_Unidade_Cli_NL);
            wDta_validade_suframa := '';
            wCod_redespacho       := '';
            wInd_Retido           := '0';
            wDia_Recebimento      := to_char(r_clientes_sislog.dia_recebimento);

                if wGerarMascara50 = 0 then
                   UTL_FILE.PUT_LINE(file_handle1,wTip_Lin_Registro||'^'||wCod_gu||'^'||wCod_pessoa||'^'||wDta_transacao||'^'||
                                          wDes_pessoa||'^'||wTip_abc||'^'||wTip_end_corresp||'^'||wInd_fat_parcial||'^'||
                                          wTip_aceite_entr||'^'||wInd_inativo||'^'||wInd_issqn||'^'||wTip_transacao||'^'||
                                          wTip_status_transacao||'^'||wDig_pessoa||'^'||wPer_dcto_esp||'^'||wNum_suframa||'^'||
                                          wNum_sequencia_rota||'^'||wCod_venc||'^'||wCod_rota||'^'||wCod_classe_venda||'^'||
                                          wCod_transp||'^'||wCod_cond_pgto||'^'||wCod_oper||'^'||wCod_localidade||'^'||
                                          wPer_dcto_fin||'^'||wCod_unidade||'^'||wDta_validade_suframa||'^'||wCod_redespacho||'^'||
                                          wTxt_erro||'^'||wCod_unidade_reg||'^'||wInd_Retido||'^'||'^'||'^'||'^'||'^'||'^'||'^'||'^'||'^'||wDia_Recebimento||'^');
                else
                   UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_gu||'^'||wCod_pessoa||'^'||wDta_transacao||'^'||
                                          wDes_pessoa||'^'||wTip_abc||'^'||wTip_end_corresp||'^'||wInd_fat_parcial||'^'||
                                          wTip_aceite_entr||'^'||wInd_inativo||'^'||wInd_issqn||'^'||wTip_transacao||'^'||
                                          wTip_status_transacao||'^'||wDig_pessoa||'^'||wPer_dcto_esp||'^'||wNum_suframa||'^'||
                                          wNum_sequencia_rota||'^'||wCod_venc||'^'||wCod_rota||'^'||wCod_classe_venda||'^'||
                                          wCod_transp||'^'||wCod_cond_pgto||'^'||wCod_oper||'^'||wCod_localidade||'^'||
                                          wPer_dcto_fin||'^'||wCod_unidade||'^'||wDta_validade_suframa||'^'||wCod_redespacho||'^'||
                                          wTxt_erro||'^'||wCod_unidade_reg||'^'||wInd_Retido||'^'||'^'||'^'||'^'||'^'||'^'||'^'||'^'||'^'||wDia_Recebimento||'^');
                end if;

            -----if r_clientes_sislog.tip_pessoa <> 2 then
            if wTip_pessoa <> 2 then
                --###########################
                --ai_ps_fisicas
                --###########################
                wTip_lin_registro    := '30';
                ---if r_clientes_sislog.dta_nascto > wDta_Hoje then
                ---    wDta_nasc        := to_char(add_months(r_clientes_sislog.dta_nascto,-1200),'ddmmyyyy');
                ---else
                ---    wDta_nasc        := to_char(r_clientes_sislog.dta_nascto,'ddmmyyyy');
                ---end if;
                wDta_nasc            := to_char(r_clientes_sislog.dta_nascto,'ddmmyyyy');
                wNum_cpf             := to_char(r_clientes_sislog.num_cpf_cnpj);
                wNum_rg              := rtrim(ltrim(r_clientes_sislog.num_rg));
                wDta_exp_rg          := to_char(r_clientes_sislog.dta_exp_rg,'ddmmyyyy');
                wDes_org_exp_rg      := r_clientes_sislog.des_org_exp_rg;
                wTip_sexo            := to_char(r_clientes_sislog.tip_sexo);
                wTip_civil           := to_char(r_clientes_sislog.tip_est_civil);
                wDes_conjuge         := replace(r_clientes_sislog.des_pessoa_raux,chr(39),'');
                wNum_ser_ctps        := '';
                wNum_ctps            := '';
                wDes_pai             := replace(r_clientes_sislog.des_pai,chr(39),'');
                wDes_mae             := replace(r_clientes_sislog.des_mae,chr(39),'');
                wDes_endereco_pai    := '';
                wDes_bairro_pai      := '';
                wNum_cep_pai         := '';
                wTip_residencia      := to_char(r_clientes_sislog.tip_residencia);
                wVlr_aluguel         := replace(to_char(r_clientes_sislog.vlr_aluguel),',','.');
                wQtd_mes_residencia  := '';
                wVlr_renda           := replace(to_char(r_clientes_sislog.vlr_outras_rendas),',','.');
                wDes_renda           := r_clientes_sislog.des_outras_rendas;
                ----wCod_comprov_renda   := to_char(r_clientes_sislog.cod_comprov_renda);
                wCod_comprov_renda   := to_char(nvl(r_clientes_sislog.ind_compr_renda,0));
                wCod_pais            := '';
                wCod_uf              := '';
                wCod_cidade_pais     := '';

                wDes_cidade          := r_clientes_sislog.des_cid_nasc;
                wDes_uf              := r_clientes_sislog.cod_uf_nasc;
                            wCod_cid_nasc        := to_char(r_clientes_sislog.cod_cidade_nasc);
                    wDes_nacionalidade   := '';
                wDta_casamento       := to_char(r_clientes_sislog.dta_casamento,'ddmmyyyy');
                wNum_cpf_conjuge     := to_char(r_clientes_sislog.num_cpf_cnpj_raux);
                wNum_rg_conjuge      := rtrim(ltrim(r_clientes_sislog.num_rg_raux));
                wDta_exp_rg_conjuge  := to_char(r_clientes_sislog.dta_exp_rg_raux,'ddmmyyyy');
                wDes_org_rg_conjuge  := r_clientes_sislog.des_org_exp_rg_raux;
                ---if r_clientes_sislog.dta_nascto_raux > wDta_Hoje then
                ---    wDta_nasc_conjuge := to_char(add_months(r_clientes_sislog.dta_nascto_raux,-1200),'ddmmyyyy');
                ---else
                ---    wDta_nasc_conjuge := to_char(r_clientes_sislog.dta_nascto_raux,'ddmmyyyy');
                ---end if;
                wDta_nasc_conjuge    := to_char(r_clientes_sislog.dta_nascto_raux,'ddmmyyyy');
                wNum_pis             := '';
                wNum_insc_est        := '';
                wDta_ini_residencia  := to_char(r_clientes_sislog.dta_resid_atual,'ddmmyyyy');
                if (nvl(r_clientes_sislog.tip_sexo_raux,0) > 0) and
                   (nvl(r_clientes_sislog.tip_sexo_raux,0) < 3) then
                      wInd_sexo      := to_char(r_clientes_sislog.tip_sexo_raux);
                else
                    wInd_sexo        := '';
                end if;
                wCod_parentesco      := to_char(r_clientes_sislog.cod_parentesco_raux);

                            wDta_nasc_nl         := wDta_nasc;
                            wNum_cpf_nl          := wNum_cpf;
                            wDes_mae_nl          := wDes_mae;
                    if (wCod_Reduzido is not null) and
                       (wAtividade_Cli <> 315) then
                                begin
                           SELECT TO_CHAR(DTA_NASC,'DDMMYYYY')
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
                            elsif wDta_nasc = '11111111' then
                                  wDta_nasc := wDta_nasc_nl;
                            end if;
                          end if;

                                if wGerarMascara50 = 0 then
                   UTL_FILE.PUT_LINE(file_handle1,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wDta_transacao||'^'||
                                              wTip_transacao||'^'||wTip_status_transacao||'^'||wDta_nasc||'^'||
                                              wNum_cpf||'^'||wNum_rg||'^'||wDta_exp_rg||'^'||wDes_org_exp_rg||'^'||
                                              wTip_sexo||'^'||wTip_civil||'^'||wDes_conjuge||'^'||wNum_ser_ctps||'^'||
                                              wNum_ctps||'^'||wDes_pai||'^'||wDes_mae||'^'||wDes_endereco_pai||'^'||
                                              wDes_bairro_pai||'^'||wNum_cep_pai||'^'||wTip_residencia||'^'||wVlr_aluguel||'^'||
                                              wQtd_mes_residencia||'^'||wVlr_renda||'^'||wDes_renda||'^'||wCod_comprov_renda||'^'||
                                              wCod_pais||'^'||wCod_uf||'^'||wCod_cidade_pais||'^'||wCod_cid_nasc||'^'||wDes_nacionalidade||'^'||
                                              wDta_casamento||'^'||wNum_cpf_conjuge||'^'||wNum_rg_conjuge||'^'||wDta_exp_rg_conjuge||'^'||
                                              wDes_org_rg_conjuge||'^'||wDta_nasc_conjuge||'^'||wNum_pis||'^'||wNum_insc_est||'^'||
                                              wDta_ini_residencia||'^'||wInd_sexo||'^'||wCod_parentesco||'^'||wTxt_erro||'^'||
                                              wCod_unidade_reg||'^');
                    else
                                   UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wDta_transacao||'^'||
                                              wTip_transacao||'^'||wTip_status_transacao||'^'||wDta_nasc||'^'||
                                              wNum_cpf||'^'||wNum_rg||'^'||wDta_exp_rg||'^'||wDes_org_exp_rg||'^'||
                                              wTip_sexo||'^'||wTip_civil||'^'||wDes_conjuge||'^'||wNum_ser_ctps||'^'||
                                              wNum_ctps||'^'||wDes_pai||'^'||wDes_mae||'^'||wDes_endereco_pai||'^'||
                                              wDes_bairro_pai||'^'||wNum_cep_pai||'^'||wTip_residencia||'^'||wVlr_aluguel||'^'||
                                              wQtd_mes_residencia||'^'||wVlr_renda||'^'||wDes_renda||'^'||wCod_comprov_renda||'^'||
                                              wCod_pais||'^'||wCod_uf||'^'||wCod_cidade_pais||'^'||wCod_cid_nasc||'^'||wDes_nacionalidade||'^'||
                                              wDta_casamento||'^'||wNum_cpf_conjuge||'^'||wNum_rg_conjuge||'^'||wDta_exp_rg_conjuge||'^'||
                                              wDes_org_rg_conjuge||'^'||wDta_nasc_conjuge||'^'||wNum_pis||'^'||wNum_insc_est||'^'||
                                              wDta_ini_residencia||'^'||wInd_sexo||'^'||wCod_parentesco||'^'||wTxt_erro||'^'||
                                              wCod_unidade_reg||'^');
                    end if;
            else
                --###########################
                --ai_ps_juridicas
                --###########################
                wTip_lin_registro           := '35';
                wNum_cgc                    := to_char(r_clientes_sislog.num_cpf_cnpj);
                wVlr_capital_social         := '';
                ---if r_clientes_sislog.dta_nascto > wDta_Hoje then
                ---    wDta_fundacao           := to_char(add_months(r_clientes_sislog.dta_nascto,-1200),'ddmmyyyy');
                ---else
                ---    wDta_fundacao           := to_char(r_clientes_sislog.dta_nascto,'ddmmyyyy');
                ---end if;
                wDta_fundacao               := to_char(r_clientes_sislog.dta_nascto,'ddmmyyyy');
                wNum_insc_est               := replace(r_clientes_sislog.num_insc_est,chr(39),'');
                wQtd_funcionarios           := '';
                wNum_cert_qualidade         := '';
                wCod_ean                    := '';
                wDta_ult_alt_capital_social := '';
                wCod_reg_ibama              := '';
                wNum_aut_ibama              := '';
                wNum_contrato_social        := '';
                wNum_insc_mun               := '';
                wIndNaoContribuinte         := '0';

                            wNum_cgc_nl                 := wNum_cgc;
                            wDta_fundacao_nl            := wDta_fundacao;
                            wNum_insc_est_nl            := wNum_insc_est;
                    if (wCod_Reduzido is not null) and
                       (wAtividade_Cli <> 315) then
                                begin
                           SELECT TO_CHAR(DTA_FUNDACAO,'DDMMYYYY')
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
                            elsif wDta_fundacao = '11111111' then
                                  wDta_fundacao := wDta_fundacao_nl;
                            elsif lTrim(rTrim(wNum_insc_est)) is null then
                                  wNum_insc_est := wNum_insc_est_nl;
                            end if;
                          end if;

                          if wGerarMascara50 = 0 then
                   UTL_FILE.PUT_LINE(file_handle1,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wDta_transacao||'^'||wTip_transacao||'^'||
                                              wTip_status_transacao||'^'||wNum_cgc||'^'||wVlr_capital_social||'^'||wDta_fundacao||'^'||
                                              wNum_insc_est||'^'||wQtd_funcionarios||'^'||wNum_cert_qualidade||'^'||wCod_ean||'^'||
                                              wDta_ult_alt_capital_social||'^'||wCod_reg_ibama||'^'||wNum_aut_ibama||'^'||wNum_contrato_social||'^'||
                                              wNum_insc_mun||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^'||wIndNaoContribuinte||'^');
                    else
                                   UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wDta_transacao||'^'||wTip_transacao||'^'||
                                              wTip_status_transacao||'^'||wNum_cgc||'^'||wVlr_capital_social||'^'||wDta_fundacao||'^'||
                                              wNum_insc_est||'^'||wQtd_funcionarios||'^'||wNum_cert_qualidade||'^'||wCod_ean||'^'||
                                              wDta_ult_alt_capital_social||'^'||wCod_reg_ibama||'^'||wNum_aut_ibama||'^'||wNum_contrato_social||'^'||
                                              wNum_insc_mun||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^'||wIndNaoContribuinte||'^');
                    end if;

            end if;
              end if;
            --###########################
            --ai_ps_telefones
            --###########################
            wTip_lin_registro  := '50';
            iCount := 0;
            while iCount < 11 loop
                    iCount := iCount + 1;
                    wNum_fone := '';
                    if iCount = 1 then
                     wNum_seq           := 1;
                     wNum_fone          := r_clientes_sislog.des_fone_resid;
                     if to_number(nvl(wNum_fone,0)) = 0 then
                         wNum_fone :='';
                     end if;
                     wDes_fone          := 'RESIDENCIAL';
                elsif iCount = 2 then
                     wNum_seq           := 10;
                     wNum_fone          := r_clientes_sislog.des_fone_comerc;
                     if to_number(nvl(wNum_fone,0)) = 0 then
                         wNum_fone :='';
                     end if;
                     wDes_fone          := 'COMERCIAL';
                elsif iCount = 3 then
                     wNum_seq           := 11;
                     wNum_fone          := r_clientes_sislog.des_ramal_comerc;
                     if to_number(nvl(wNum_fone,0)) = 0 then
                         wNum_fone :='';
                     end if;
                     wDes_fone          := 'RAMAL FONE COMERCIAL';
                    elsif iCount = 4 then
                     wNum_seq           := 15;
                     wNum_fone          := r_clientes_sislog.des_fone_celular;
                     if to_number(nvl(wNum_fone,0)) = 0 then
                         wNum_fone :='';
                     end if;
                     wDes_fone          := 'CELULAR';
                    elsif iCount = 5 then
                     wNum_seq           := 16;
                     wNum_fone          := r_clientes_sislog.des_fone_celular2;
                     if to_number(nvl(wNum_fone,0)) = 0 then
                         wNum_fone :='';
                     end if;
                     wDes_fone          := 'CELULAR2';
                elsif iCount = 6 then
                     wNum_seq           := 20;
                     wNum_fone          := r_clientes_sislog.des_telefone_raux;
                     if to_number(nvl(wNum_fone,0)) = 0 then
                         wNum_fone :='';
                     end if;
                     wDes_fone          := 'AUTORIZADO';
                elsif iCount = 7 then
                     wNum_seq           := 95;
                     wNum_fone          := r_clientes_sislog.des_celular1_ant;
                     if to_number(nvl(wNum_fone,0)) = 0 then
                         wNum_fone :='';
                     end if;
                     wDes_fone          := 'CELULAR ANT';
                elsif iCount = 8 then
                     wNum_seq           := 96;
                     wNum_fone          := r_clientes_sislog.des_celular2_ant;
                     if to_number(nvl(wNum_fone,0)) = 0 then
                         wNum_fone :='';
                     end if;
                     wDes_fone          := 'CELULAR2 ANT';
                elsif iCount = 9 then
                     wNum_seq           := 97;
                     wNum_fone          := r_clientes_sislog.des_residencial_ant;
                     if to_number(nvl(wNum_fone,0)) = 0 then
                         wNum_fone :='';
                     end if;
                     wDes_fone          := 'RESIDENCIAL ANT';
                elsif iCount = 10 then
                     wNum_seq           := 98;
                     wNum_fone          := r_clientes_sislog.des_fone_comerc_adic;
                     if to_number(nvl(wNum_fone,0)) = 0 then
                         wNum_fone :='';
                     end if;
                     wDes_fone          := 'COMERCIAL ADIC';
                elsif iCount = 11 then
                     wNum_seq           := 99;
                     wNum_fone          := r_clientes_sislog.des_ramal_comerc_adic;
                     if to_number(nvl(wNum_fone,0)) = 0 then
                         wNum_fone :='';
                     end if;
                     wDes_fone          := 'RAMAL COMERCIAL ADIC';
                end if;
                wInd_uso_ddd       := '';
                wTip_endereco      := '';
                wExisteFone        := 0;
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
                  --- (wExisteFone = 1) then
                       if wGerarMascara50 = 0 then
                       UTL_FILE.PUT_LINE(file_handle1,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wNum_seq||'^'||
                                                  wDta_transacao||'^'||wNum_fone||'^'||wDes_fone||'^'||
                                                  wTip_transacao||'^'||wTip_status_transacao||'^'||wInd_uso_ddd||'^'||
                                                  wTip_endereco||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');
                       else
                       UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wNum_seq||'^'||
                                                  wDta_transacao||'^'||wNum_fone||'^'||wDes_fone||'^'||
                                                  wTip_transacao||'^'||wTip_status_transacao||'^'||wInd_uso_ddd||'^'||
                                                  wTip_endereco||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');
                       end if;
                end if;
                end loop;
              if wTem_Alt_Unidade = 0 then
            --###########################
            --ai_ps_prof_clientes
            --###########################
            wTip_lin_registro    := '65';
            iCount := 0;
            while iCount < 2 loop
                    iCount := iCount + 1;
                    if iCount = 1 then
                     wTip_inf_prof        := '1';
                     if r_clientes_sislog.des_empr_trab is not null then
                         wDes_emp         := r_clientes_sislog.des_empr_trab;
                     else
                         wDes_emp         := 'A';
                     end if;
                     wCod_comprov         := to_char(nvl(r_clientes_sislog.cod_comprov_renda,0));
                     --wCod_cidade        := vem da ps_pessoas
                     wCod_funcao          := to_char(r_clientes_sislog.cod_profissao);
                     wVlr_salario         := replace(to_char(r_clientes_sislog.vlr_renda),',','.');
                     wNum_fone            := r_clientes_sislog.des_fone_comerc;
                     if to_number(nvl(wNum_fone,0)) = 0 then
                         wNum_fone :='';
                     end if;
                     wNum_cnpj_empregador := to_char(r_clientes_sislog.num_cnpj_empr_trab);
                     wDta_admissao        := to_char(r_clientes_sislog.dta_admissao_trab,'ddmmyyyy');
                     ----salva ind_profissao do cliente at¿¿¿ a cria¿¿¿¿¿¿o do campo novo na tabela---
                     wDes_bairro          := to_char(substr(r_clientes_sislog.des_bairro_end_empresa,1,20));
                     wDes_endereco      := to_char(r_clientes_sislog.des_rua_end_empresa);
                     wNum_cep             := to_char(r_clientes_sislog.num_cep_end_empresa);
                     wCompl_endereco   := to_char(r_clientes_sislog.des_compl_end_empresa);
                     wCod_cidade_empresa := to_char(r_clientes_sislog.cod_cidade_end_empresa);
                     wNum_end_empresa := to_char(r_clientes_sislog.des_num_end_empresa);
                     wTip_Funcao := to_char(r_clientes_sislog.ind_profissao);

                      if nvl(wCod_cidade_empresa,'0') = '0' then
                     wDes_bairro:= '';
                     wDes_endereco :='';
                     wCompl_endereco :='';
                     wNum_end_empresa :='';
                     wCod_cidade_empresa := wCod_cidade;
                     end if;






                     if wDes_emp is not null then
                        if wGerarMascara50 = 0 then
                       UTL_FILE.PUT_LINE(file_handle1,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wTip_inf_prof||'^'||
                                                   wDes_emp||'^'||wDta_transacao||'^'||wCod_comprov||'^'||wCod_cidade_empresa||'^'||
                                                   wCod_funcao||'^'||wVlr_salario||'^'||wTip_transacao||'^'||wTip_status_transacao||'^'||
                                                   wNum_fone||'^'||wDes_endereco||'^'||wDes_bairro||'^'||wNum_cep||'^'||wNum_cnpj_empregador||'^'||
                                                   wDta_admissao||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^'||wTip_Funcao||'^'||'^'||'^'||'^'||'^'||'^'||wNum_end_empresa||'^'||wCompl_endereco||'^');
                        else
                       UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wTip_inf_prof||'^'||
                                                   wDes_emp||'^'||wDta_transacao||'^'||wCod_comprov||'^'||wCod_cidade_empresa||'^'||
                                                   wCod_funcao||'^'||wVlr_salario||'^'||wTip_transacao||'^'||wTip_status_transacao||'^'||
                                                   wNum_fone||'^'||wDes_endereco||'^'||wDes_bairro||'^'||wNum_cep||'^'||wNum_cnpj_empregador||'^'||
                                                   wDta_admissao||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^'||wTip_Funcao||'^'||'^'||'^'||'^'||'^'||'^'||wNum_end_empresa||'^'||wCompl_endereco||'^');
                        end if;

                     end if;
                elsif iCount = 2 then
                     if (r_clientes_sislog.des_pessoa_raux is not null) or
                        (nvl(r_clientes_sislog.cod_profissao_raux,0) > 0) or
                        (nvl(r_clientes_sislog.vlr_outras_rendas,0) > 0) or
                        (to_number(nvl(r_clientes_sislog.des_telefone_raux,0)) > 0) then
                         wTip_inf_prof        := '3';
                         if r_clientes_sislog.des_empr_trab_adic is not null then
                             wDes_emp         := r_clientes_sislog.des_empr_trab_adic;
                         else
                             wDes_emp         := 'A';
                         end if;
                         wCod_comprov         := to_char(nvl(r_clientes_sislog.ind_compr_renda,0));
                         --wCod_cidade        := vem da ps_pessoas;
                         wCod_funcao          := to_char(nvl(r_clientes_sislog.cod_profissao_adic,113));
                        if r_clientes_sislog.vlr_outras_rendas is not null then
                           wVlr_salario         := replace(to_char(nvl(r_clientes_sislog.vlr_outras_rendas,0)),',','.');
                         else
                           wVlr_salario         := '0';
                         end if;

                         wNum_fone            := r_clientes_sislog.des_fone_comerc_adic;
                         if to_number(nvl(wNum_fone,0)) = 0 then
                             wNum_fone :='';
                         end if;
                         if (to_number(nvl(r_clientes_sislog.des_fone_comerc_adic,0)) > 0) and
                            (to_number(nvl(r_clientes_sislog.des_ramal_comerc_adic,0)) > 0) then
                              wNum_fone := wNum_fone||' R:'||r_clientes_sislog.des_ramal_comerc_adic;
                         end if;
                         wNum_cnpj_empregador := '';
                     wNum_cnpj_empregador := to_char(r_clientes_sislog.num_cnpj_empr_trab);
                         wDta_admissao        := to_char(r_clientes_sislog.dta_admissao_trab_adic,'ddmmyyyy');
                         ----salva ind_profissao da renda auxiliar ate a criacao do campo novo na tabela---
                         wDes_bairro          := '';

                         wDes_endereco        := '';
                         -----wDes_bairro          := '';
                         wNum_cep             := '';
                         wTip_Funcao := to_char(r_clientes_sislog.ind_profissao);

                         if wDes_emp is not null then
                            if wGerarMascara50 = 0 then
                               UTL_FILE.PUT_LINE(file_handle1,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wTip_inf_prof||'^'||
                                                           wDes_emp||'^'||wDta_transacao||'^'||wCod_comprov||'^'||wCod_cidade||'^'||
                                                           wCod_funcao||'^'||wVlr_salario||'^'||wTip_transacao||'^'||wTip_status_transacao||'^'||
                                                           wNum_fone||'^'||wDes_endereco||'^'||wDes_bairro||'^'||wNum_cep||'^'||wNum_cnpj_empregador||'^'||
                                                           wDta_admissao||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');
                            else
                               UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wTip_inf_prof||'^'||
                                                           wDes_emp||'^'||wDta_transacao||'^'||wCod_comprov||'^'||wCod_cidade||'^'||
                                                           wCod_funcao||'^'||wVlr_salario||'^'||wTip_transacao||'^'||wTip_status_transacao||'^'||
                                                           wNum_fone||'^'||wDes_endereco||'^'||wDes_bairro||'^'||wNum_cep||'^'||wNum_cnpj_empregador||'^'||
                                                           wDta_admissao||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');
                            end if;
                         end if;
                     else
                         wDes_emp             := '';
                     end if;
                end if;

                ----wDes_endereco        := '';
                -----wDes_bairro          := '';
                ---wNum_cep             := '';
                ---if wDes_emp is not null then
                ---    UTL_FILE.PUT_LINE(file_handle1,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wTip_inf_prof||'^'||
                ---                                   wDes_emp||'^'||wDta_transacao||'^'||wCod_comprov||'^'||wCod_cidade||'^'||
                ---                                   wCod_funcao||'^'||wVlr_salario||'^'||wTip_transacao||'^'||wTip_status_transacao||'^'||
                ---                                   wNum_fone||'^'||wDes_endereco||'^'||wDes_bairro||'^'||wNum_cep||'^'||wNum_cnpj_empregador||'^'||
                ---                                   wDta_admissao||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');
                ---end if;
            end loop;
            --###########################
            --ai_ps_ref_clientes
            --###########################
            wTip_lin_registro    := '70';
            wNum_seq_ref         := '1';
            wDes_ref             := r_clientes_sislog.des_pessoa_refer;
            --wCod_cidade          := vem da ps_pessoas;
            wNum_fone            := r_clientes_sislog.des_fone_pes_refer;
                if to_number(nvl(wNum_fone,0)) = 0 then
                wNum_fone :='';
            end if;
            wDes_endereco        := '';
            wNum_cep             := '';
            wDes_bairro          := '';
            wTip_referencia      := to_char(r_clientes_sislog.cod_parentesco);
            if wDes_Ref is not null then
                   if wGerarMascara50 = 0 then
                  UTL_FILE.PUT_LINE(file_handle1,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wNum_seq_ref||'^'||
                                               wDes_ref||'^'||wDta_transacao||'^'||wCod_cidade||'^'||wTip_transacao||'^'||
                                               wTip_status_transacao||'^'||wNum_fone||'^'||wDes_endereco||'^'||wNum_cep||'^'||
                                               wDes_bairro||'^'||wTip_referencia||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');
               else
                  UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wNum_seq_ref||'^'||
                                               wDes_ref||'^'||wDta_transacao||'^'||wCod_cidade||'^'||wTip_transacao||'^'||
                                               wTip_status_transacao||'^'||wNum_fone||'^'||wDes_endereco||'^'||wNum_cep||'^'||
                                               wDes_bairro||'^'||wTip_referencia||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');
               end if;
            end if;
                    ----grava registro do contato para recado----
            wNum_seq_ref         := '10';
            wDes_ref             := r_clientes_sislog.des_recado;
            wTip_referencia      := '10';
            if wDes_Ref is not null then
               if wGerarMascara50 = 0 then
                  UTL_FILE.PUT_LINE(file_handle1,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wNum_seq_ref||'^'||
                                               wDes_ref||'^'||wDta_transacao||'^'||wCod_cidade||'^'||wTip_transacao||'^'||
                                               wTip_status_transacao||'^'||wNum_fone||'^'||wDes_endereco||'^'||wNum_cep||'^'||
                                               wDes_bairro||'^'||wTip_referencia||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');
               else
                  UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wNum_seq_ref||'^'||
                                               wDes_ref||'^'||wDta_transacao||'^'||wCod_cidade||'^'||wTip_transacao||'^'||
                                               wTip_status_transacao||'^'||wNum_fone||'^'||wDes_endereco||'^'||wNum_cep||'^'||
                                               wDes_bairro||'^'||wTip_referencia||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');
               end if;
            end if;

            --grava registro para segunda pessoa de referencia-------

            wNum_seq_ref         := '5';
            wDes_ref             := r_clientes_sislog.des_pessoa_refer2;
            wNum_fone            := r_clientes_sislog.des_fone_pes_refer2;
                if to_number(nvl(wNum_fone,0)) = 0 then
                wNum_fone :='';
            end if;

            wTip_referencia      := to_char(r_clientes_sislog.cod_parentesco_ref2);
            if wDes_Ref is not null then
                   if wGerarMascara50 = 0 then
                  UTL_FILE.PUT_LINE(file_handle1,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wNum_seq_ref||'^'||
                                               wDes_ref||'^'||wDta_transacao||'^'||wCod_cidade||'^'||wTip_transacao||'^'||
                                               wTip_status_transacao||'^'||wNum_fone||'^'||wDes_endereco||'^'||wNum_cep||'^'||
                                               wDes_bairro||'^'||wTip_referencia||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');
               else
                  UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wNum_seq_ref||'^'||
                                               wDes_ref||'^'||wDta_transacao||'^'||wCod_cidade||'^'||wTip_transacao||'^'||
                                               wTip_status_transacao||'^'||wNum_fone||'^'||wDes_endereco||'^'||wNum_cep||'^'||
                                               wDes_bairro||'^'||wTip_referencia||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');

               end if;
            end if;

            --###########################
            --ai_ps_cartoes
            --###########################
            wTip_lin_registro    := '75';
            wNum_dia_venc        := to_char(r_clientes_sislog.num_dia_vcto);
            wTip_doc_cobr        := '2';
            ---wDes_imp             := wDes_pessoa;
            wNum_reemissao       := substr(lpad(r_clientes_sislog.cod_cartao,3,'0'),1,2);
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
                                  wDta_Solicitacao   := wDta_transacao;
                                  wInd_emite         := '1';
                                  wNum_reemissao     := '0';
                                  wInd_Emite_Cartao  := 0;
                          wDes_imp           := replace(nvl(r_clientes_sislog.des_nome_impr_cartao,substr(wDes_Pessoa,1,30)),chr(39),'');
                          wDta_Remessa_Cartao:= '';
                      end;
                      if wInd_Emite_Cartao = 1 then
                            wInd_emite     := to_char(nvl(wInd_Emite_Cartao,0));
                            wNum_reemissao := to_char(nvl(wNum_Reemissao_Cartao,0));
                      --alteracao 14/09/2011
                      -- alterado em 03/11/2014
                      elsif (nvl(r_clientes_sislog.ind_reem_cart_tit,0) = 1) and
                          --  (to_date(nvl(wDta_Solicitacao,'01011001'),'dd/mm/yyyy') < trunc(sysdate - 730)) and
                            (to_date(nvl(wDta_Solicitacao,'01011001'),'dd/mm/yyyy') < trunc(sysdate - 60)) and
                            (r_clientes_sislog.dta_solic_reem_tit >= (r_clientes_sislog.dta_alteracao - 5)) then -- adicionado este teste dia 28/05/2014
                            wInd_emite     := to_char(nvl(r_clientes_sislog.ind_reem_cart_tit,0));
                            wNum_reemissao := to_char(nvl(wNum_Reemissao_Cartao,0));
                            wDta_Solicitacao := to_char(r_clientes_sislog.dta_solic_reem_tit,'DDMMYYYY');
                      end if;
             else
                wInd_emite       := '1';
                wNum_reemissao   := '0';
                wCod_Cartao      := '';
                wDta_Solicitacao := wDta_transacao;
                wDes_imp         := replace(nvl(r_clientes_sislog.des_nome_impr_cartao,substr(wDes_Pessoa,1,30)),chr(39),'');
            end if;
            wDta_validade        := '';
            wDta_fechamento      := '';
            wCod_Tipo_Cartao     := '';
            wCod_situacao        := substr(lpad(r_clientes_sislog.cod_cartao,3,'0'),3,1);
            ---if (wCod_Situacao = '7') or
            ---   (wCod_Situacao = '8') then
            ---    wCod_situacao    := '1';
            ---end if;
                if wGerarMascara50 = 0 then
               UTL_FILE.PUT_LINE(file_handle1,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wDta_transacao||'^'||
                                          wNum_dia_venc||'^'||wTip_doc_cobr||'^'||wDes_imp||'^'||wNum_reemissao||'^'||
                                          wInd_emite||'^'||wTip_transacao||'^'||wTip_status_transacao||'^'||wDta_validade||'^'||
                                          wDta_fechamento||'^'||wCod_situacao||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^'||
                                          wCod_Cartao||'^'||wCod_Tipo_Cartao||'^'||wDta_Solicitacao||'^'||wDta_Remessa_Cartao||'^'||'^'||'^'||'^'||'^'||'^');
                        else
               UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wDta_transacao||'^'||
                                          wNum_dia_venc||'^'||wTip_doc_cobr||'^'||wDes_imp||'^'||wNum_reemissao||'^'||
                                          wInd_emite||'^'||wTip_transacao||'^'||wTip_status_transacao||'^'||wDta_validade||'^'||
                                          wDta_fechamento||'^'||wCod_situacao||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^'||
                                          wCod_Cartao||'^'||wCod_Tipo_Cartao||'^'||wDta_Solicitacao||'^'||wDta_Remessa_Cartao||'^'||'^'||'^'||'^'||'^'||'^');
                        end if;
            --###########################
            --ai_ps_cartoes_adicionais
            --###########################
            -- aqui teste do adicional para excluir
            wNome_Adicional := '';
                if (r_clientes_sislog.ind_deletar_adic = '1') then

               begin
                   select des_imp
                 into wNome_Adicional
                     from ps_cartoes_adicionais
                    where cod_pessoa = r_clientes_sislog.cod_pessoa
                  and num_adic = 10;
                EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                   wNome_Adicional:='A';
                   end;

                           begin
                  delete from ps_cartoes_adicionais a
                   where a.cod_pessoa = r_clientes_sislog.cod_pessoa
                 and a.num_adic = 10;
                   end;

                   commit;

                     end if;




            wTip_lin_registro    := '80';
            iCount := 0;
            while iCount < 2 loop
                    iCount := iCount + 1;
                    if iCount = 1 then
                        wNum_adic       := '0';
                    ---wDes_imp        := wDes_pessoa;
                    ---wNum_reemissao  := substr(lpad(r_clientes_sislog.cod_cartao,3,'0'),1,2);
                    ---if wCod_Reduzido is not null then
                    ---    wInd_emite  := '0';
                    ---else
                    ---    wInd_emite  := '1';
                    ---    wNum_reemissao := '0';
                    ---end if;
                    wDes_parentesco := 'TITULAR';
                    ---if r_clientes_sislog.dta_nascto > wDta_Hoje then
                    ---    wDta_nasc   := to_char(add_months(r_clientes_sislog.dta_nascto,-1200),'ddmmyyyy');
                    ---else
                    ---    wDta_nasc   := to_char(r_clientes_sislog.dta_nascto,'ddmmyyyy');
                    ---end if;
                    wDta_nasc_cartao   := wDta_nasc;
                    ---wCod_situacao   := substr(lpad(r_clientes_sislog.cod_cartao,3,'0'),3,1);
                        ---if (wCod_situacao = '7') or
                        ---   (wCod_situacao = '8') then
                        ---    wCod_situacao := '1';
                        ---end if;
                        wCod_funcao     := to_char(r_clientes_sislog.cod_profissao);
                    elsif iCount = 2 then
                        wNum_adic             := '10';
                    ---wDes_imp              := r_clientes_sislog.des_pessoa_raux;
                    wDes_imp               := nvl(r_clientes_sislog.des_nome_impr_cartao_adic,substr(r_clientes_sislog.des_pessoa_raux,1,30));
                    wNum_reemissao        := substr(lpad(nvl(r_clientes_sislog.cod_cartao_adic,'0'),3,'0'),1,2);
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
                                        -- ,DES_IMP
                                         ,TO_CHAR(DTA_REMESSA,'DDMMYYYY')
                                       INTO wNum_Reemissao_Cartao
                                           ,wDta_Solicitacao
                                           ,wInd_Emite_Cartao
                                           ,wTem_Cartao_Adic
                                          -- ,wDes_Imp
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
                                              --   wDes_Imp              := nvl(r_clientes_sislog.des_nome_impr_cartao_adic,substr(r_clientes_sislog.des_pessoa_raux,1,30));
                                                 wDta_Remessa_Cartao   := '';
                                  end;

                        if r_clientes_sislog.des_pessoa_raux is null then
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
                        elsif to_number(nvl(r_clientes_sislog.cod_cartao_adic,'0')) = 0 then
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
                        elsif to_number(nvl(r_clientes_sislog.cod_cartao_adic,'0')) <> 101 then
                            if wTem_Cartao_Adic = 1 then
                                if wInd_Emite_Cartao = 1 then
                                    wInd_emite       := to_char(nvl(wInd_Emite_Cartao,0));
                                    wNum_reemissao   := to_char(nvl(wNum_Reemissao_Cartao,0));
                                                --alteracao 14/09/2011
                                                -- alterado em 03/11/2014
                                          elsif (nvl(r_clientes_sislog.ind_reem_cart_raux,0)) = 1 and
                                              --  (to_date(nvl(wDta_Solicitacao,'01011001'),'dd/mm/yyyy') < trunc(sysdate - 730)) and
                                                (to_date(nvl(wDta_Solicitacao,'01011001'),'dd/mm/yyyy') < trunc(sysdate - 60)) and
                                                (r_clientes_sislog.dta_solic_reem_raux >= (r_clientes_sislog.dta_alteracao - 5)) then -- adicionado este teste dia 28/05/2014
                                                wInd_emite     := to_char(nvl(r_clientes_sislog.ind_reem_cart_raux,0));
                                                wNum_reemissao := to_char(nvl(wNum_Reemissao_Cartao,0));
                                                wDta_Solicitacao := to_char(r_clientes_sislog.dta_solic_reem_raux,'DDMMYYYY');
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
                                          elsif (nvl(r_clientes_sislog.ind_reem_cart_raux,0)) = 1 and
                                                --(to_date(nvl(wDta_Solicitacao,'01011001'),'dd/mm/yyyy') < trunc(sysdate - 730)) and
                                                (to_date(nvl(wDta_Solicitacao,'01011001'),'dd/mm/yyyy') < trunc(sysdate - 60)) and
                                                (r_clientes_sislog.dta_solic_reem_raux >= (r_clientes_sislog.dta_alteracao - 5)) then -- adicionado este teste dia 28/05/2014
                                                wInd_emite     := to_char(nvl(r_clientes_sislog.ind_reem_cart_raux,0));
                                                wNum_reemissao := to_char(nvl(wNum_Reemissao_Cartao,0));
                                                wDta_Solicitacao := to_char(r_clientes_sislog.dta_solic_reem_raux,'DDMMYYYY');
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
                        elsif to_number(nvl(r_clientes_sislog.cod_cartao_adic,'0')) = 101 then
                            if wTem_Cartao_Adic = 1 then
                                if wInd_Emite_Cartao = 1 then
                                    wInd_emite       := to_char(nvl(wInd_Emite_Cartao,0));
                                    wNum_reemissao   := to_char(nvl(wNum_Reemissao_Cartao,0));
                                                --alteracao 14/09/2011
                                          elsif (nvl(r_clientes_sislog.ind_reem_cart_raux,0)) = 1 and
                                                --(to_date(nvl(wDta_Solicitacao,'01011001'),'dd/mm/yyyy') < trunc(sysdate - 730)) and
                                                (to_date(nvl(wDta_Solicitacao,'01011001'),'dd/mm/yyyy') < trunc(sysdate - 60)) and
                                                (r_clientes_sislog.dta_solic_reem_raux >= (r_clientes_sislog.dta_alteracao - 5)) then -- adicionado este teste dia 28/05/2014
                                                wInd_emite     := to_char(nvl(r_clientes_sislog.ind_reem_cart_raux,0));
                                                wNum_reemissao := to_char(nvl(wNum_Reemissao_Cartao,0));
                                                wDta_Solicitacao := to_char(r_clientes_sislog.dta_solic_reem_raux,'DDMMYYYY');
                                elsif wNum_Reemissao_Cartao > 0 then
                                    wInd_emite       := to_char(nvl(wInd_Emite_Cartao,0));
                                    wNum_reemissao   := to_char(nvl(wNum_Reemissao_Cartao,0));
                                else
                                    wInd_emite       := '1';
                                    wNum_reemissao   := '0';
                                    wDta_Solicitacao := wDta_transacao;
                                end if;
                            else
                                wInd_emite       := '1';
                                wNum_reemissao   := '0';
                                wDta_Solicitacao := wDta_transacao;
                            end if;
                        else
                            if wTem_Cartao_Adic = 1 then
                                if wInd_Emite_Cartao = 1 then
                                    wInd_emite       := to_char(nvl(wInd_Emite_Cartao,0));
                                    wNum_reemissao   := to_char(nvl(wNum_Reemissao_Cartao,0));
                                                --alteracao 14/09/2011
                                          elsif (nvl(r_clientes_sislog.ind_reem_cart_raux,0)) = 1 and
                                                --(to_date(nvl(wDta_Solicitacao,'01011001'),'dd/mm/yyyy') < trunc(sysdate - 730)) and
                                                (to_date(nvl(wDta_Solicitacao,'01011001'),'dd/mm/yyyy') < trunc(sysdate - 60)) and
                                                (r_clientes_sislog.dta_solic_reem_raux >= (r_clientes_sislog.dta_alteracao - 5)) then -- adicionado este teste dia 28/05/2014
                                                wInd_emite     := to_char(nvl(r_clientes_sislog.ind_reem_cart_raux,0));
                                                wNum_reemissao := to_char(nvl(wNum_Reemissao_Cartao,0));
                                                wDta_Solicitacao := to_char(r_clientes_sislog.dta_solic_reem_raux,'DDMMYYYY');
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
                    elsif to_number(nvl(r_clientes_sislog.cod_cartao_adic,0)) = 101 then
                        wInd_emite       := 1;
                        wNum_reemissao   := '0';
                        wDta_Solicitacao := wDta_transacao;
                                    wDes_Imp         := nvl(r_clientes_sislog.des_nome_impr_cartao_adic,substr(r_clientes_sislog.des_pessoa_raux,1,30));
                    else
                        wInd_emite       := '0';
                        wNum_reemissao   := '0';
                        wDta_Solicitacao := '';
                                    wDes_Imp         := '';
                    end if;
                    if nvl(r_clientes_sislog.cod_parentesco_raux,0) = 0 then
                         wDes_parentesco := 'SEM PARENTESCO';
                    elsif nvl(r_clientes_sislog.cod_parentesco_raux,0) = 1 then
                         wDes_parentesco := 'CONJUGE';
                    elsif nvl(r_clientes_sislog.cod_parentesco_raux,0) = 2 then
                         wDes_parentesco := 'PAIS';
                    elsif nvl(r_clientes_sislog.cod_parentesco_raux,0) = 3 then
                         wDes_parentesco := 'FILHO';
                    elsif nvl(r_clientes_sislog.cod_parentesco_raux,0) = 4 then
                         wDes_parentesco := 'IRMAO';
                    elsif nvl(r_clientes_sislog.cod_parentesco_raux,0) = 5 then
                         wDes_parentesco := 'AVOS';
                    else
                         wDes_parentesco := 'SEM PARENTESCO';
                    end if;
                    --wDes_parentesco := decode(to_char(r_clientes_sislog.cod_parentesco_raux),'0','SEM PARENTESCO','1','CONJUGE','2','PAIS','3','FILHO','4','IRMAO','5','AVOS','SEM PARENTESCO');
                    ---if r_clientes_sislog.dta_nascto_raux > wDta_Hoje then
                    ---    wDta_nasc   := to_char(add_months(r_clientes_sislog.dta_nascto_raux,-1200),'ddmmyyyy');
                    ---else
                    ---    wDta_nasc   := to_char(r_clientes_sislog.dta_nascto_raux,'ddmmyyyy');
                    ---end if;
                    wDta_nasc_cartao   := to_char(r_clientes_sislog.dta_nascto_raux,'ddmmyyyy');
                    wCod_situacao   := substr(lpad(r_clientes_sislog.cod_cartao_adic,3,'0'),3,1);
                        ---if (wCod_situacao = '7') or
                        ---   (wCod_situacao = '8') then
                        ---    wCod_situacao := '1';
                        ---end if;
                        wCod_funcao     := to_char(r_clientes_sislog.cod_profissao_raux);
                    end if;

                if wDes_imp is not null then
                       if wGerarMascara50 = 0 then
                      UTL_FILE.PUT_LINE(file_handle1,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wNum_adic||'^'||
                                                   wDta_transacao||'^'||wDes_imp||'^'||wNum_reemissao||'^'||
                                                   wInd_emite||'^'||wDes_parentesco||'^'||wTip_transacao||'^'||
                                                   wTip_status_transacao||'^'||wDta_nasc_cartao||'^'||wCod_situacao||'^'||
                                                   wCod_funcao||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^'||
                                                   wCod_Cartao||'^'||wCod_Tipo_Cartao||'^'||wDta_Solicitacao||'^'||'^'||wDta_Remessa_Cartao||'^'||'^'||'^'||'^'||'^'||'^');
                   else
                      UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wNum_adic||'^'||
                                                   wDta_transacao||'^'||wDes_imp||'^'||wNum_reemissao||'^'||
                                                   wInd_emite||'^'||wDes_parentesco||'^'||wTip_transacao||'^'||
                                                   wTip_status_transacao||'^'||wDta_nasc_cartao||'^'||wCod_situacao||'^'||
                                                   wCod_funcao||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^'||
                                                   wCod_Cartao||'^'||wCod_Tipo_Cartao||'^'||wDta_Solicitacao||'^'||'^'||wDta_Remessa_Cartao||'^'||'^'||'^'||'^'||'^'||'^');
                   end if;
                end if;
            end loop;
              end if;
            --###########################
            --ai_ps_observacoes
            --###########################
            wTip_lin_registro    := '85';
            iCount := 0;
            while iCount < 1 loop
                    iCount := iCount + 1;
                wNum_maq  := '0';
                wDta_obs  := '01012004';
                    if iCount = 1 then
                    wCod_obs     := '10';
                        wNum_seq_obs := '1';
                        wDes_resp    := 'LOJA';
                        wTxt_obs     := replace(r_clientes_sislog.des_observacao,chr(39),'');
                end if;
                if (rtrim(ltrim(wTxt_obs)) is null) or
                   (rtrim(ltrim(wTxt_obs)) = '') then
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
                        if wGerarMascara50 = 0 then
                                       UTL_FILE.PUT_LINE(file_handle1,wTip_Lin_Registro||'^'||wNum_maq||'^'||wCod_pessoa||'^'||
                                                          wCod_obs||'^'||wDta_obs||'^'||wNum_seq_obs||'^'||wDta_transacao||'^'||
                                                          wDes_resp||'^'||wTxt_obs||'^'||wTip_transacao||'^'||wTip_status_transacao||'^'||
                                                          wTxt_erro||'^'||wCod_unidade_reg||'^');
                                else
                                       UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wNum_maq||'^'||wCod_pessoa||'^'||
                                                          wCod_obs||'^'||wDta_obs||'^'||wNum_seq_obs||'^'||wDta_transacao||'^'||
                                                          wDes_resp||'^'||wTxt_obs||'^'||wTip_transacao||'^'||wTip_status_transacao||'^'||
                                                          wTxt_erro||'^'||wCod_unidade_reg||'^');
                                end if;
                            end if;

                        end loop;
              if wTem_Alt_Unidade = 0 then
            --###########################
            --ai_ps_colunas
            --###########################
            wTip_lin_registro    := '90';
            iCount := 0;
            while iCount < 27 loop
                   iCount := iCount + 1;
                   wVlr_coluna := '';
                   if iCount = 1 then
                       wVlr_coluna := r_clientes_sislog.ind_conceito_ender;
                   elsif iCount = 2 then
                       wVlr_coluna := r_clientes_sislog.tip_telefone;
                   elsif iCount = 3 then
                       wVlr_coluna := r_clientes_sislog.des_cid_nasc;
                   elsif iCount = 4 then
                       wVlr_coluna := r_clientes_sislog.cod_uf_nasc;
                   elsif iCount = 5 then
                   wVlr_Coluna := substr(lpad(r_clientes_sislog.cod_cartao_adic,3,'0'),3,1);
                       if (wVlr_Coluna <> '8') then
                           wVlr_Coluna := '1';
                       end if;
                   elsif iCount = 6 then
                               wVlr_coluna := r_clientes_sislog.ind_talao_cheques;
                           elsif iCount = 7 then
                       wVlr_coluna := to_char(r_clientes_sislog.dta_abertura_conta,'dd/mm/yyyy');
                   elsif iCount = 8 then
                       wVlr_coluna := to_char(r_clientes_sislog.cod_banco);
                   elsif iCount = 9 then
                       wVlr_coluna := r_clientes_sislog.ind_cartao_cred;
                   elsif iCount = 10 then
                       wVlr_coluna := to_char(r_clientes_sislog.ind_automovel);
                   elsif iCount = 11 then
                       wVlr_coluna := to_char(r_clientes_sislog.ind_spc);
                   elsif iCount = 12 then
                       wVlr_coluna := r_clientes_sislog.ind_funcionario;
                   elsif iCount = 13 then
                       wVlr_coluna := r_clientes_sislog.des_mae_raux;
                   elsif iCount = 14 then
                       wVlr_coluna := to_number(r_clientes_sislog.ind_spc_raux);
                   elsif iCount = 15 then
                       wVlr_coluna := r_clientes_sislog.des_setor_trab;
                   elsif iCount = 16 then
                       wVlr_coluna := to_char(r_clientes_sislog.cod_pes_aprov_cad);
                   elsif iCount = 17 then
                       wVlr_coluna := '';
                   elsif iCount = 18 then
                       wVlr_coluna := to_char(r_clientes_sislog.cod_pes_digit_cad);
                   elsif iCount = 19 then
                       wVlr_coluna := '';
                   elsif iCount = 20 then
                       wVlr_coluna := '0';
                   elsif iCount = 21 then
                       wVlr_coluna := to_char(r_clientes_sislog.ind_novo_cadastro);
                   elsif iCount = 22 then
                       wVlr_coluna := to_char(r_clientes_sislog.ind_automovel_finan);
                   elsif iCount = 23 then
                       wVlr_coluna := to_char(r_clientes_sislog.des_setor_trab_adic);
                   elsif iCount = 24 then
                       wVlr_coluna := to_char(wNome_Adicional);
                   elsif iCount = 25 then
                       wVlr_coluna := to_char(r_clientes_sislog.IND_POLITICAMENTE_EXPOSTA);
                   elsif iCount = 26 then
                       wVlr_coluna := to_char(r_clientes_sislog.vlr_liq_patrimonio,'FM9999999999990D00');
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
                         if wGerarMascara50 = 0 then
                               UTL_FILE.PUT_LINE(file_handle1,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wSeq_coluna||'^'||
                                                             wDta_transacao||'^'||wTip_transacao||'^'||wTip_status_transacao||'^'||
                                                             wVlr_coluna||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');
                          else
                               UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wSeq_coluna||'^'||
                                                             wDta_transacao||'^'||wTip_transacao||'^'||wTip_status_transacao||'^'||
                                                             wVlr_coluna||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');

                          end if;
                       end if;
                        end loop;
              end if;
            --###########################
            --ai_ps_comentarios
            --###########################
            wTip_lin_registro    := '95';
            if nvl(r_clientes_sislog.des_comentario,'0') <> '0' then
                 wSeq_comentario := '10';
                 wDes_comentario :=    replace(r_clientes_sislog.des_comentario,chr(39),'');
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
                            DELETE FROM PS_COMENTARIOS
                            WHERE COD_GU = 1
                              AND COD_PESSOA = wCod_Reduzido
                              AND SEQ_COMENTARIO = 10;
                           end;
                         end if;
                end if;
            end if;

            if (rtrim(ltrim(wDes_comentario)) is not null) then
                if wGerarMascara50 = 0 then
                            UTL_FILE.PUT_LINE(file_handle1,wTip_Lin_Registro||'^'||wCod_gu||'^'||wCod_pessoa||'^'||
                                                          wSeq_comentario||'^'||wDta_transacao||'^'||wDes_comentario||'^'||
                                                          wTip_transacao||'^'||wTip_status_transacao||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');
                        else
                            UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_gu||'^'||wCod_pessoa||'^'||
                                                          wSeq_comentario||'^'||wDta_transacao||'^'||wDes_comentario||'^'||
                                                          wTip_transacao||'^'||wTip_status_transacao||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');
                        end if;
                    end if;
               if wTem_Alt_Unidade = 0 then
             --###########################
            --ai_ps_mascaras
            --###########################

                if r_clientes_sislog.num_rede = 70 then
                   if (r_clientes_sislog.cod_cartao_cliente is not null) then
                   begin
                               wGerarMascara50Grz := 0;
                         wGerarMascara50Prm := 0;
                               wGerarMascara50Frg := 0;
                               wGerarMascara50Tot := 0;

                               if r_clientes_sislog.cod_emp_cadastro = 10 then
                                  wGerarMascara50Grz := 1;
                               elsif r_clientes_sislog.cod_emp_cadastro = 30 then
                               wGerarMascara50Prm := 1;
                         elsif r_clientes_sislog.cod_emp_cadastro = 40 then
                               wGerarMascara50Frg := 1;
                         elsif r_clientes_sislog.cod_emp_cadastro = 50 then
                               wGerarMascara50Tot := 1;
                         end if;

                      /* if wGerarMascara50 <> 1 then
                               OPEN c_verifica_mascara;
                               FETCH c_verifica_mascara INTO r_verifica_mascara;
                               WHILE c_verifica_mascara%FOUND LOOP
                               BEGIN
                             if r_verifica_mascara.COD_NIV1 = '10' then
                                wGerarMascara50Grz := 0;
                             elsif r_verifica_mascara.COD_NIV1 = '30' then
                                   wGerarMascara50Prm := 0;
                             elsif r_verifica_mascara.COD_NIV1 = '40' then
                                   wGerarMascara50Frg := 0;
                             elsif r_verifica_mascara.COD_NIV1 = '50' then
                                   wGerarMascara50Tot := 0;
                             end if;
                                   END;
                                   FETCH c_verifica_mascara INTO r_verifica_mascara;
                                   END LOOP;
                                   CLOSE c_verifica_mascara;
                                */
                                   wTip_lin_registro    := '110';
                       wCod_mascara         := '50';
                       --wCod_completo        := lPad(wNum_rede,2,'0')||lpad(to_char(r_clientes_sislog.cod_cliente),12,'0');
                       wCod_niv0            := '1';
                       --wCod_editado         := lPad(wNum_rede,2,'0')||'.'||lpad(to_char(r_clientes_sislog.cod_cliente),12,'0');
                       --wCod_niv1            := lPad(wNum_rede,2,'0');
                       --wCod_niv2            := lpad(to_char(r_clientes_sislog.cod_cartao_cliente),12,'0');
                       wCod_niv2            := substr(wCod_pessoa,3,12);
                       wCod_niv3            := '';
                       wCod_niv4            := '';
                       wCod_niv5            := '';
                       wCod_niv6            := '';
                       wCod_niv7            := '';
                       wCod_niv8            := '';
                       wCod_niv9            := '';

                                   if wGerarMascara50Grz = 1 then
                                      --wNum_rede := '10';
                                      wNum_rede := substr(wCod_pessoa,1,2);
                                      --wCod_completo        := lPad(wNum_rede,2,'0')||lpad(to_char(r_clientes_sislog.cod_cartao_cliente),12,'0');
                          --wCod_editado         := lPad(wNum_rede,2,'0')||'.'||lpad(to_char(r_clientes_sislog.cod_cartao_cliente),12,'0');
                          wCod_completo        := wCod_pessoa;
                          wCod_editado         := substr(wCod_pessoa,1,2)||'.'||substr(wCod_pessoa,3,12);
                          wCod_niv1            := lPad(wNum_rede,2,'0');

                                      UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_mascara||'^'||wCod_pessoa||'^'||
                                                        wCod_completo||'^'||wDta_transacao||'^'||wCod_niv0||'^'||
                                                        wTip_transacao||'^'||wTip_status_transacao||'^'||wCod_editado||'^'||
                                                        wCod_niv1||'^'||wCod_niv2||'^'||wCod_niv3||'^'||wCod_niv4||'^'||
                                                        wCod_niv5||'^'||wCod_niv6||'^'||wCod_niv7||'^'||wCod_niv8||'^'||
                                                        wCod_niv9||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');
                                    end if;

                                    if wGerarMascara50Prm = 1 then
                                          --wNum_rede := '30';
                                          wNum_rede := substr(wCod_pessoa,1,2);
                                          --wCod_completo        := lPad(wNum_rede,2,'0')||lpad(to_char(r_clientes_sislog.cod_cartao_cliente),12,'0');
                              --wCod_editado         := lPad(wNum_rede,2,'0')||'.'||lpad(to_char(r_clientes_sislog.cod_cartao_cliente),12,'0');
                                          wCod_completo        := wCod_pessoa;
                              wCod_editado         := substr(wCod_pessoa,1,2)||'.'||substr(wCod_pessoa,3,12);
                              wCod_niv1            := lPad(wNum_rede,2,'0');

                                          UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_mascara||'^'||wCod_pessoa||'^'||
                                                            wCod_completo||'^'||wDta_transacao||'^'||wCod_niv0||'^'||
                                                            wTip_transacao||'^'||wTip_status_transacao||'^'||wCod_editado||'^'||
                                                            wCod_niv1||'^'||wCod_niv2||'^'||wCod_niv3||'^'||wCod_niv4||'^'||
                                                            wCod_niv5||'^'||wCod_niv6||'^'||wCod_niv7||'^'||wCod_niv8||'^'||
                                                            wCod_niv9||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');
                          end if;

                          if wGerarMascara50Frg = 1 then
                                          --wNum_rede := '40';
                                          wNum_rede := substr(wCod_pessoa,1,2);
                                          --wCod_completo        := lPad(wNum_rede,2,'0')||lpad(to_char(r_clientes_sislog.cod_cartao_cliente),12,'0');
                              --wCod_editado         := lPad(wNum_rede,2,'0')||'.'||lpad(to_char(r_clientes_sislog.cod_cartao_cliente),12,'0');
                              wCod_completo        := wCod_pessoa;
                              wCod_editado         := substr(wCod_pessoa,1,2)||'.'||substr(wCod_pessoa,3,12);
                              wCod_niv1            := lPad(wNum_rede,2,'0');

                                          UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_mascara||'^'||wCod_pessoa||'^'||
                                                            wCod_completo||'^'||wDta_transacao||'^'||wCod_niv0||'^'||
                                                            wTip_transacao||'^'||wTip_status_transacao||'^'||wCod_editado||'^'||
                                                            wCod_niv1||'^'||wCod_niv2||'^'||wCod_niv3||'^'||wCod_niv4||'^'||
                                                            wCod_niv5||'^'||wCod_niv6||'^'||wCod_niv7||'^'||wCod_niv8||'^'||
                                                            wCod_niv9||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');
                          end if;

                          if wGerarMascara50Tot = 1 then
                                          --wNum_rede := '50';
                                          wNum_rede := substr(wCod_pessoa,1,2);
                                          --wCod_completo        := lPad(wNum_rede,2,'0')||lpad(to_char(r_clientes_sislog.cod_cartao_cliente),12,'0');
                              --wCod_editado         := lPad(wNum_rede,2,'0')||'.'||lpad(to_char(r_clientes_sislog.cod_cartao_cliente),12,'0');
                              wCod_completo        := wCod_pessoa;
                              wCod_editado         := substr(wCod_pessoa,1,2)||'.'||substr(wCod_pessoa,3,12);
                              wCod_niv1            := lPad(wNum_rede,2,'0');

                                          UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_mascara||'^'||wCod_pessoa||'^'||
                                                            wCod_completo||'^'||wDta_transacao||'^'||wCod_niv0||'^'||
                                                            wTip_transacao||'^'||wTip_status_transacao||'^'||wCod_editado||'^'||
                                                            wCod_niv1||'^'||wCod_niv2||'^'||wCod_niv3||'^'||wCod_niv4||'^'||
                                                            wCod_niv5||'^'||wCod_niv6||'^'||wCod_niv7||'^'||wCod_niv8||'^'||
                                                            wCod_niv9||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');
                                    end if;
                               --else
                                  -- se cair aqui, deve gerar a mascara para as 4 redes

                               /*    wNum_rede := '10'; -- gera mascara Grazziotin
                                   wTip_lin_registro    := '110';
                       wCod_mascara         := '50';
                       wCod_completo        := lPad(wNum_rede,2,'0')||lpad(to_char(r_clientes_sislog.cod_cartao_cliente),12,'0');
                       wCod_niv0            := '1';
                       wCod_editado         := lPad(wNum_rede,2,'0')||'.'||lpad(to_char(r_clientes_sislog.cod_cartao_cliente),12,'0');
                       wCod_niv1            := lPad(wNum_rede,2,'0');
                       wCod_niv2            := lpad(to_char(r_clientes_sislog.cod_cartao_cliente),12,'0');
                       wCod_niv3            := '';
                       wCod_niv4            := '';
                       wCod_niv5            := '';
                       wCod_niv6            := '';
                       wCod_niv7            := '';
                       wCod_niv8            := '';
                       wCod_niv9            := '';

                                   UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_mascara||'^'||wCod_pessoa||'^'||
                                                                 wCod_completo||'^'||wDta_transacao||'^'||wCod_niv0||'^'||
                                                                 wTip_transacao||'^'||wTip_status_transacao||'^'||wCod_editado||'^'||
                                                                 wCod_niv1||'^'||wCod_niv2||'^'||wCod_niv3||'^'||wCod_niv4||'^'||
                                                                 wCod_niv5||'^'||wCod_niv6||'^'||wCod_niv7||'^'||wCod_niv8||'^'||
                                                                 wCod_niv9||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');

                                   wNum_rede := '30'; -- gera mascara Pormenos
                                   wTip_lin_registro    := '110';
                       wCod_mascara         := '50';
                       wCod_completo        := lPad(wNum_rede,2,'0')||lpad(to_char(r_clientes_sislog.cod_cartao_cliente),12,'0');
                       wCod_niv0            := '1';
                       wCod_editado         := lPad(wNum_rede,2,'0')||'.'||lpad(to_char(r_clientes_sislog.cod_cartao_cliente),12,'0');
                       wCod_niv1            := lPad(wNum_rede,2,'0');
                       wCod_niv2            := lpad(to_char(r_clientes_sislog.cod_cartao_cliente),12,'0');
                       wCod_niv3            := '';
                       wCod_niv4            := '';
                       wCod_niv5            := '';
                       wCod_niv6            := '';
                       wCod_niv7            := '';
                       wCod_niv8            := '';
                       wCod_niv9            := '';

                                   UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_mascara||'^'||wCod_pessoa||'^'||
                                                                 wCod_completo||'^'||wDta_transacao||'^'||wCod_niv0||'^'||
                                                                 wTip_transacao||'^'||wTip_status_transacao||'^'||wCod_editado||'^'||
                                                                 wCod_niv1||'^'||wCod_niv2||'^'||wCod_niv3||'^'||wCod_niv4||'^'||
                                                                 wCod_niv5||'^'||wCod_niv6||'^'||wCod_niv7||'^'||wCod_niv8||'^'||
                                                                 wCod_niv9||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');

                                   wNum_rede := '40'; -- gera mascara Franco
                                   wTip_lin_registro    := '110';
                       wCod_mascara         := '50';
                       wCod_completo        := lPad(wNum_rede,2,'0')||lpad(to_char(r_clientes_sislog.cod_cartao_cliente),12,'0');
                       wCod_niv0            := '1';
                       wCod_editado         := lPad(wNum_rede,2,'0')||'.'||lpad(to_char(r_clientes_sislog.cod_cartao_cliente),12,'0');
                       wCod_niv1            := lPad(wNum_rede,2,'0');
                       wCod_niv2            := lpad(to_char(r_clientes_sislog.cod_cartao_cliente),12,'0');
                       wCod_niv3            := '';
                       wCod_niv4            := '';
                       wCod_niv5            := '';
                       wCod_niv6            := '';
                       wCod_niv7            := '';
                       wCod_niv8            := '';
                       wCod_niv9            := '';

                                   UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_mascara||'^'||wCod_pessoa||'^'||
                                                                 wCod_completo||'^'||wDta_transacao||'^'||wCod_niv0||'^'||
                                                                 wTip_transacao||'^'||wTip_status_transacao||'^'||wCod_editado||'^'||
                                                                 wCod_niv1||'^'||wCod_niv2||'^'||wCod_niv3||'^'||wCod_niv4||'^'||
                                                                 wCod_niv5||'^'||wCod_niv6||'^'||wCod_niv7||'^'||wCod_niv8||'^'||
                                                                 wCod_niv9||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');

                                   wNum_rede := '50'; -- gera mascara Tottal
                                   wTip_lin_registro    := '110';
                       wCod_mascara         := '50';
                       wCod_completo        := lPad(wNum_rede,2,'0')||lpad(to_char(r_clientes_sislog.cod_cartao_cliente),12,'0');
                       wCod_niv0            := '1';
                       wCod_editado         := lPad(wNum_rede,2,'0')||'.'||lpad(to_char(r_clientes_sislog.cod_cartao_cliente),12,'0');
                       wCod_niv1            := lPad(wNum_rede,2,'0');
                       wCod_niv2            := lpad(to_char(r_clientes_sislog.cod_cartao_cliente),12,'0');
                       wCod_niv3            := '';
                       wCod_niv4            := '';
                       wCod_niv5            := '';
                       wCod_niv6            := '';
                       wCod_niv7            := '';
                       wCod_niv8            := '';
                       wCod_niv9            := '';

                                   UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_mascara||'^'||wCod_pessoa||'^'||
                                                                 wCod_completo||'^'||wDta_transacao||'^'||wCod_niv0||'^'||
                                                                 wTip_transacao||'^'||wTip_status_transacao||'^'||wCod_editado||'^'||
                                                                 wCod_niv1||'^'||wCod_niv2||'^'||wCod_niv3||'^'||wCod_niv4||'^'||
                                                                 wCod_niv5||'^'||wCod_niv6||'^'||wCod_niv7||'^'||wCod_niv8||'^'||
                                                                 wCod_niv9||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');

                               end if; */
                   end; -- if do cod_cartao_cliente is not null -- se cair aqui n¿o gera nada
                   end if;
                else -- else da rede 70

               wTip_lin_registro    := '110';
               wCod_mascara         := '50';

                           if wCod_pessoa is not null then
                                -- wNum_rede            := substr(wCod_pessoa,1,2);
                                 wCod_completo        := wCod_pessoa;
                                 wCod_niv0            := '1';
                                 wCod_editado         := substr(wCod_pessoa,1,2)||'.'||substr(wCod_pessoa,3,12);
                                 wCod_niv1            := lPad(wNum_rede,2,'0');
                                 wCod_niv2            := substr(wCod_pessoa,3,12);
                           else
                  wCod_completo        := lPad(wNum_rede,2,'0')||lpad(to_char(r_clientes_sislog.cod_cliente),12,'0');
                  wCod_niv0            := '1';
                  wCod_editado         := lPad(wNum_rede,2,'0')||'.'||lpad(to_char(r_clientes_sislog.cod_cliente),12,'0');
                  wCod_niv1            := lPad(wNum_rede,2,'0');
                  wCod_niv2            := lpad(to_char(r_clientes_sislog.cod_cliente),12,'0');
               end if;
               /*else
                  wCod_completo        := wCod_pessoa;
                  wCod_niv0            := '1';
                  wCod_editado         := substr(wCod_pessoa,1,2)||'.'||substr(wCod_pessoa,3,12);
                  wCod_niv1            := lPad(wNum_rede,2,'0');
                  wCod_niv2            := substr(wCod_pessoa,3,12);
               end if; */ -- bloco comentado em 21/02/2019

               wCod_niv3            := '';
               wCod_niv4            := '';
               wCod_niv5            := '';
               wCod_niv6            := '';
               wCod_niv7            := '';
               wCod_niv8            := '';
               wCod_niv9            := '';

                           if wGerarMascara50 = 0 then
                              UTL_FILE.PUT_LINE(file_handle1,wTip_Lin_Registro||'^'||wCod_mascara||'^'||wCod_pessoa||'^'||
                                                         wCod_completo||'^'||wDta_transacao||'^'||wCod_niv0||'^'||
                                                         wTip_transacao||'^'||wTip_status_transacao||'^'||wCod_editado||'^'||
                                                         wCod_niv1||'^'||wCod_niv2||'^'||wCod_niv3||'^'||wCod_niv4||'^'||
                                                         wCod_niv5||'^'||wCod_niv6||'^'||wCod_niv7||'^'||wCod_niv8||'^'||
                                                         wCod_niv9||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');
                           else
                              UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_mascara||'^'||wCod_pessoa||'^'||
                                                         wCod_completo||'^'||wDta_transacao||'^'||wCod_niv0||'^'||
                                                         wTip_transacao||'^'||wTip_status_transacao||'^'||wCod_editado||'^'||
                                                         wCod_niv1||'^'||wCod_niv2||'^'||wCod_niv3||'^'||wCod_niv4||'^'||
                                                         wCod_niv5||'^'||wCod_niv6||'^'||wCod_niv7||'^'||wCod_niv8||'^'||
                                                         wCod_niv9||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');
                           end if;
                        end if; -- end if rede 70

            --###########################
            --ai_lc_limites
            --###########################
            
            -- Antonio - Funcao para "Alterar" os Limites de Creditos (31/05/2021)
            --if (r_clientes_sislog.cod_unidade = 159) or (r_clientes_sislog.cod_unidade = 53) then
            begin
                 r_clientes_sislog.vlr_limite :=
                      sislogweb.grz_retorna_valor_limite_sp(r_clientes_sislog.tip_pessoa,
                                                            wCod_pessoa,
                                                            r_clientes_sislog.num_cpf_cnpj,
                                                            r_clientes_sislog.vlr_limite,
                                                            r_clientes_sislog.vlr_creditscoring);
            end;
            --end if;

            wTip_lin_registro    := '115';
            wVlr_lim_mensal      := replace(to_char(r_clientes_sislog.vlr_limite),',','.');
            wVlr_lim_geral       := replace(to_char(r_clientes_sislog.vlr_limite),',','.');
            wQtd_pontos          := to_char(r_clientes_sislog.qtd_ptos_creditscoring);
            wCod_moeda           := '';
            wVlr_lim_mensal_orig := replace(to_char(r_clientes_sislog.vlr_creditscoring),',','.');
            wVlr_lim_geral_orig  := replace(to_char(r_clientes_sislog.vlr_creditscoring),',','.');
            wDta_venc            := '';
            wDta_pontos          := to_char(r_clientes_sislog.dta_ult_creditscoring,'ddmmyyyy');
            wDta_limite          := to_char(r_clientes_sislog.dta_alt_limite,'ddmmyyyy');

                if wGerarMascara50 = 0 then
                           UTL_FILE.PUT_LINE(file_handle1,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wDta_transacao||'^'||
                                                      wVlr_lim_mensal||'^'||wVlr_lim_geral||'^'||wTip_transacao||'^'||
                                                      wTip_status_transacao||'^'||wQtd_pontos||'^'||wCod_moeda||'^'||
                                                      wVlr_lim_mensal_orig||'^'||wVlr_lim_geral_orig||'^'||wDta_venc||'^'||
                                                      wDta_pontos||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^'||wDta_limite||'^');
                        else
                           UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wDta_transacao||'^'||
                                                      wVlr_lim_mensal||'^'||wVlr_lim_geral||'^'||wTip_transacao||'^'||
                                                      wTip_status_transacao||'^'||wQtd_pontos||'^'||wCod_moeda||'^'||
                                                      wVlr_lim_mensal_orig||'^'||wVlr_lim_geral_orig||'^'||wDta_venc||'^'||
                                                      wDta_pontos||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^'||wDta_limite||'^');

                        end if;
                      end if;



            --###########################
            --ai_ps_consentimentos
            --###########################

               if r_clientes_sislog.ind_aceitou_contrato = 1 then
                    wTip_Lin_Registro := '135';
                    wIndAprovaExterno := '1';

                    wCodConsentimento := '3';
                    wVersaoTextoAprovado := replace(r_clientes_sislog.versao_termo_contrato,'.','');

                   UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wDta_transacao||'^'||
                                     wCodConsentimento||'^'||wVersaoTextoAprovado||'^'||wTip_transacao||'^'||wTip_status_transacao||'^'||
                                     wTxt_erro||'^'||wDta_transacao||'^'||'^'||'^'||'^'||wIndAprovaExterno||'^'||wCod_unidade_reg||'^');


                  wCodConsentimento := '1';
                  wVersaoTextoAprovado := replace(r_clientes_sislog.versao_termo_politica,'.','');

                 UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wDta_transacao||'^'||
                                                      wCodConsentimento||'^'||wVersaoTextoAprovado||'^'||wTip_transacao||'^'||wTip_status_transacao||'^'||
                                                      wTxt_erro||'^'||wDta_transacao||'^'||'^'||'^'||'^'||wIndAprovaExterno||'^'||wCod_unidade_reg||'^');

               end if;




                wTip_Lin_Registro := '135';
                wIndAprovaExterno := '1';
                wCodConsentimento := '5';
                wVersaoTextoAprovado := nvl(r_clientes_sislog.ind_aceitou_novidades,1);
                UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wDta_transacao||'^'||
                                                      wCodConsentimento||'^'||wVersaoTextoAprovado||'^'||wTip_transacao||'^'||wTip_status_transacao||'^'||
                                                      wTxt_erro||'^'||wDta_transacao||'^'||'^'||'^'||'^'||wIndAprovaExterno||'^'||wCod_unidade_reg||'^');



                if (to_number(nvl(wCod_cidade,0)) = 44) then
                wCodEmp                := '1';
                wTip_Lin_Registro      := '900';
                wIND_VALIDA_UNIDADE    := '0'; 
                wIND_ATUALIZA_BLOQUEIO := '1'; -- 0 ou 1
                wCOD_APLICACAO         := '';
                wNUM_SEQ               := '';
                wIND_INC_CONTROLE      := '0';
                wDES_USO_RESTRITO      := '';
                
                    
                UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCodEmp||'^'||wCod_pessoa||'^'||wDta_transacao||'^'||wIND_VALIDA_UNIDADE||'^'||
                                               wIND_ATUALIZA_BLOQUEIO||'^'||wCOD_APLICACAO||'^'||wNUM_SEQ||'^'||wCod_gu||'^'||
                                               wCod_mascara||'^'||wNum_cpf||'^'||wNum_Cgc||'^'||wIND_INC_CONTROLE||'^'||wDES_USO_RESTRITO||'^');
                end if;

               END;
               FETCH c_clientes_sislog INTO r_clientes_sislog;
               END LOOP;
               CLOSE c_clientes_sislog;


             --- busca clientes venda a vista do novo sislog
           OPEN c_clivv_sislog;
           FETCH c_clivv_sislog INTO r_clivv_sislog;
           WHILE c_clivv_sislog%FOUND LOOP
           BEGIN
                    if r_clivv_sislog.num_rede = 55 then
                        wNum_rede := '60';
                    else
                        if (r_clivv_sislog.num_rede = 70) then
                           wNum_rede := lPad(to_char(r_clivv_sislog.cod_emp_cadastro),2,'0');
                        else
                           wNum_rede := lPad(to_char(r_clivv_sislog.num_rede),2,'0');
                        end if;
                    end if;

                    /* wLojaMigrada := 0;
                begin
                   select cod_unidade
                     Into wLojaMigrada
                     from grz_lojas_migracao_sislog
                    where cod_unidade = r_clivv_sislog.cod_unidade;
                 exception
                     when no_data_found then
                          wLojaMigrada := 0;
                end;    */

            --###########################
            --ai_ps_pessoas
            --###########################
            wTip_lin_registro     := '10';
            wCod_gu               := '1';
                --if (r_clivv_sislog.NUM_REDE = 70) or (r_clivv_sislog.NUM_REDE = 40) or (wLojaMigrada <> 0) then
                if r_clivv_sislog.COD_CARTAO_CLIENTE is null then
                   wCod_pessoa           := '';
                else
               wCod_pessoa           := lpad(wNum_rede,2,'0')||lpad(to_char(r_clivv_sislog.COD_CARTAO_CLIENTE),12,'0');
            end if;
                --else
            --   wCod_pessoa           := lpad(wNum_rede,2,'0')||lpad(to_char(r_clivv_sislog.cod_cliente),12,'0');
            --end if;
            wDta_transacao        := to_char(r_clivv_sislog.dta_mvto,'ddmmyyyy');
            wDes_pessoa           := replace(NVL(r_clivv_sislog.des_cliente,'A'),chr(39),'');
            wCod_regiao           := '315';
                      wCod_Reduzido         := '';

                      wIndInativoPessoa := 0;

                      if wNum_Rede is null then
                      begin
                           if r_clivv_sislog.tip_pessoa = 1 then
                               begin
                           SELECT P.COD_COMPLETO
                             Into wCod_pessoa
                             FROM PS_CLIENTES T, PS_FISICAS F, PS_MASCARAS P
                                  WHERE T.COD_PESSOA = F.COD_PESSOA
                                    AND T.COD_PESSOA = P.COD_PESSOA
                                    AND P.COD_MASCARA = 50
                                    AND F.NUM_CPF = r_clivv_sislog.NUM_CPF_CNPJ
                                    AND T.COD_CLASSE_VENDA = 15
                                    AND ROWNUM = 1;
                          EXCEPTION
                               WHEN NO_DATA_FOUND THEN
                                  wCod_pessoa := '';
                         end;
                     else
                         begin
                           SELECT P.COD_COMPLETO
                             Into wCod_pessoa
                             FROM PS_CLIENTES T, PS_JURIDICAS J, PS_MASCARAS P
                                  WHERE T.COD_PESSOA = J.COD_PESSOA
                                    AND T.COD_PESSOA = P.COD_PESSOA
                                    AND P.COD_MASCARA = 50
                                    AND J.NUM_CGC = r_clivv_sislog.NUM_CPF_CNPJ
                                    AND T.COD_CLASSE_VENDA = 15
                                    AND ROWNUM = 1;
                           EXCEPTION
                               WHEN NO_DATA_FOUND THEN
                                  wCod_pessoa := '';
                         end;

                     end if;
                      end;
                      end if;

                  begin
                SELECT COD_PESSOA
                    INTO wCod_Reduzido
                    FROM PS_MASCARAS
                  WHERE COD_MASCARA  = 50
                      AND COD_COMPLETO = wCod_pessoa;
                      EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                           wCod_Reduzido := '';
                  end;

                       /*
                       if (wCod_Reduzido is null) and
                          (nvl(r_clivv_sislog_sislog.cod_pessoa,0) > 0) then
                         begin
                    SELECT COD_PESSOA
                        INTO wCod_Reduzido
                        FROM PS_MASCARAS
                      WHERE COD_MASCARA = 50
                          AND COD_PESSOA  = r_clivv_sislog_sislog.cod_pessoa;
                          EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                               wCod_Reduzido := '';
                     end;
                   end if;
                         */

                       wAtividade_Cli := '315';
                       if (wCod_Reduzido is not null) then
                         begin
                    SELECT COD_ATIVIDADE
                        INTO wAtividade_Cli
                        FROM PS_PESSOAS
                      WHERE COD_PESSOA = wCod_Reduzido;
                          EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                               wAtividade_Cli := '315';
                     end;
                   end if;



                      if (wCod_Reduzido is null) then

                           if (r_clivv_sislog.NUM_REDE <> 70) then
                           begin
                               if r_clivv_sislog.tip_pessoa = 1 then

                                   begin
                               SELECT DISTINCT T.COD_CLASSE_VENDA, T.COD_PESSOA
                                 Into wCodClasseVenda, wCod_Reduzido
                                 FROM PS_CLIENTES T, PS_FISICAS F, PS_MASCARAS A
                                      WHERE T.COD_PESSOA = F.COD_PESSOA
                                        AND T.COD_PESSOA = A.COD_PESSOA
                                        AND A.COD_MASCARA = 50
                                        AND A.COD_NIV1    = r_clivv_sislog.NUM_REDE
                                        AND F.NUM_CPF = r_clivv_sislog.NUM_CPF_CNPJ
                                        AND T.COD_CLASSE_VENDA = 10;
                              EXCEPTION
                                   WHEN NO_DATA_FOUND THEN
                                      wCodClasseVenda := 0;
                                      wCod_Reduzido   := '';
                             end;
                         else
                             begin
                               SELECT DISTINCT T.COD_CLASSE_VENDA, T.COD_PESSOA
                                 Into wCodClasseVenda, wCod_Reduzido
                                 FROM PS_CLIENTES T, PS_JURIDICAS J, PS_MASCARAS A
                                      WHERE T.COD_PESSOA = J.COD_PESSOA
                                        AND T.COD_PESSOA = A.COD_PESSOA
                                        AND A.COD_MASCARA = 50
                                        AND A.COD_NIV1    = r_clivv_sislog.NUM_REDE
                                        AND J.NUM_CGC = r_clivv_sislog.NUM_CPF_CNPJ
                                        AND T.COD_CLASSE_VENDA = 10;
                               EXCEPTION
                                   WHEN NO_DATA_FOUND THEN
                                      wCodClasseVenda := 0;
                                      wCod_Reduzido   := '';
                             end;
                         end if;
                     end;
                     else
                     begin
                               if r_clivv_sislog.tip_pessoa = 1 then

                                   begin
                               SELECT DISTINCT T.COD_CLASSE_VENDA, T.COD_PESSOA
                                 Into wCodClasseVenda, wCod_Reduzido
                                 FROM PS_CLIENTES T, PS_FISICAS F
                                      WHERE T.COD_PESSOA = F.COD_PESSOA
                                        AND F.NUM_CPF = r_clivv_sislog.NUM_CPF_CNPJ
                                        AND T.COD_CLASSE_VENDA = 10
                                        AND ROWNUM = 1;
                              EXCEPTION
                                   WHEN NO_DATA_FOUND THEN
                                      wCodClasseVenda := 0;
                                      wCod_Reduzido   := '';
                             end;
                         else
                             begin
                               SELECT DISTINCT T.COD_CLASSE_VENDA, T.COD_PESSOA
                                 Into wCodClasseVenda, wCod_Reduzido
                                 FROM PS_CLIENTES T, PS_JURIDICAS J
                                      WHERE T.COD_PESSOA = J.COD_PESSOA
                                        AND J.NUM_CGC = r_clivv_sislog.NUM_CPF_CNPJ
                                        AND T.COD_CLASSE_VENDA = 10
                                        AND ROWNUM = 1;
                               EXCEPTION
                                   WHEN NO_DATA_FOUND THEN
                                      wCodClasseVenda := 0;
                                      wCod_Reduzido   := '';
                             end;
                         end if;

                     end;
                     end if;

                     -- seta a atividade para n¿o gerar a pessoa porque existe um cadastro venda a prazo
                     if wCodClasseVenda = 10 then
                        wAtividade_Cli := '310';
                        -- verifica se o cliente est¿ inativo
                        begin
                              SELECT T.Ind_Inativo
                                Into wIndInativoPessoa
                              FROM PS_CLIENTES T, PS_MASCARAS A, PS_PESSOAS P
                                   WHERE T.COD_PESSOA = A.COD_PESSOA
                                     AND A.Cod_Pessoa = P.COD_PESSOA
                                     AND A.COD_MASCARA = 50
                                     AND A.COD_NIV1    = wNum_rede
                                     AND T.IND_INATIVO = 1
                                     AND P.COD_PESSOA  = wCod_Reduzido;
                         EXCEPTION
                               WHEN NO_DATA_FOUND THEN
                                     wIndInativoPessoa := 0;
                        end;

                        -- se estiver inativo, ativa o cliente e reduz o limite - realizado em 14/05/2019
                        if wIndInativoPessoa = 1 then
                        begin
                              update ps_pessoas
                                 set ind_inativo = 0
                               where cod_pessoa  = wCod_Reduzido;
                        end;

                        begin
                              update lc_limites
                                 set vlr_lim_mensal = 1
                               where cod_pessoa     = wCod_Reduzido;
                        end;

                        COMMIT;
                        end if;

                     else
                       if (r_clivv_sislog.NUM_REDE <> 70) then
                       begin
                              SELECT M.COD_COMPLETO
                                Into wPossuiCadastroNaRede
                                FROM PS_MASCARAS M
                                   WHERE M.COD_MASCARA = 50
                                     AND M.COD_NIV1 = r_clivv_sislog.NUM_REDE
                                     AND (EXISTS (SELECT 1 FROM PS_FISICAS F
                                                   WHERE M.COD_PESSOA = F.COD_PESSOA
                                                     AND F.NUM_CPF = r_clivv_sislog.NUM_CPF_CNPJ)
                                      OR  EXISTS (SELECT 1 FROM PS_JURIDICAS J
                                                   WHERE M.COD_PESSOA = J.COD_PESSOA
                                                     AND J.NUM_CGC    = r_clivv_sislog.NUM_CPF_CNPJ))
                                     AND ROWNUM = 1;
                           EXCEPTION
                               WHEN NO_DATA_FOUND THEN
                                     wPossuiCadastroNaRede := '0';
                         end;
                       else
                       begin
                              SELECT M.COD_COMPLETO
                                Into wPossuiCadastroNaRede
                                FROM PS_MASCARAS M
                                   WHERE M.COD_MASCARA = 50
                                     AND M.COD_NIV1 = r_clivv_sislog.cod_emp_cadastro
                                     AND (EXISTS (SELECT 1 FROM PS_FISICAS F
                                                   WHERE M.COD_PESSOA = F.COD_PESSOA
                                                     AND F.NUM_CPF = r_clivv_sislog.NUM_CPF_CNPJ)
                                      OR  EXISTS (SELECT 1 FROM PS_JURIDICAS J
                                                   WHERE M.COD_PESSOA = J.COD_PESSOA
                                                     AND J.NUM_CGC    = r_clivv_sislog.NUM_CPF_CNPJ))
                                     AND ROWNUM = 1;
                           EXCEPTION
                               WHEN NO_DATA_FOUND THEN
                                     wPossuiCadastroNaRede := '0';
                         end;
                         end if;

                         if wPossuiCadastroNaRede <> '0' then -- para n¿o gerar cadastro
                          wCod_Reduzido := wPossuiCadastroNaRede;
                       end if;
                     end if;
                 else -- else do classe venda
                        -- verifica se o cliente est¿ inativo
                        begin
                              SELECT T.Ind_Inativo
                                Into wIndInativoPessoa
                              FROM PS_CLIENTES T, PS_MASCARAS A, PS_PESSOAS P
                                   WHERE T.COD_PESSOA = A.COD_PESSOA
                                     AND A.Cod_Pessoa = P.COD_PESSOA
                                     AND A.COD_MASCARA = 50
                                     AND A.COD_NIV1    = wNum_rede
                                     AND T.IND_INATIVO = 1
                                     AND P.COD_PESSOA  = wCod_Reduzido;
                         EXCEPTION
                               WHEN NO_DATA_FOUND THEN
                                     wIndInativoPessoa := 0;
                        end;

                        -- se estiver inativo, ativa o cliente e reduz o limite - realizado em 14/05/2019
                        if wIndInativoPessoa = 1 then
                        begin
                              update ps_pessoas
                                 set ind_inativo = 0
                               where cod_pessoa  = wCod_Reduzido;
                        end;
                      end if;

              end if;


                /* teste para verificar se o cadastro ¿ para uma filial
                     n¿o importa os dados de cliente
                    */
                if r_clivv_sislog.tip_pessoa = 2 then
                begin
                         SELECT COD_PESSOA
                           INTO wCadastro_Loja
                      FROM ps_juridicas
                    WHERE cod_pessoa = r_clivv_sislog.num_loja
                     AND num_cgc    = r_clivv_sislog.num_cpf_cnpj;
                         EXCEPTION
                           WHEN NO_DATA_FOUND THEN
                                 wCadastro_Loja := 0;
                end;
                else
                   wCadastro_Loja := 0;

                end if;


              if (wCod_pessoa is not null) and ((wAtividade_Cli = '315') and (wCadastro_Loja = 0) and (substr(r_clivv_sislog.num_cpf_cnpj,1,8) <> '92012467')) then
            wDes_cidade           := r_clivv_sislog.des_cidade;
            wDes_uf               := r_clivv_sislog.cod_uf;
            wCod_cidade           := to_char(r_clivv_sislog.cod_cidade);
            wCod_atividade        := '315';
            wTip_pessoa           := to_char(r_clivv_sislog.tip_pessoa);
            wDta_cadastro         := to_char(r_clivv_sislog.dta_cadastro,'ddmmyyyy');
            wInd_mala_direta      := to_char(r_clivv_sislog.ind_mala_direta);
            wInd_inativo          := to_char(r_clivv_sislog.ind_inativo);
            wTip_transacao        := '1';
            wTip_status_transacao := '1';
            wDig_pessoa           := '';
            wDes_fantasia         := r_clivv_sislog.des_fantasia;
            wDes_endereco         := replace(r_clivv_sislog.des_endereco,chr(39),'');
            wDes_ponto_referencia := r_clivv_sislog.des_pto_refer;
            wDes_bairro           := replace(r_clivv_sislog.des_bairro,chr(39),'');
            wNum_cep              := replace(r_clivv_sislog.num_cep,chr(39),'');
            wNum_caixa_postal     := to_char(r_clivv_sislog.num_caixa_postal);
            wDes_email            := lower(replace(r_clivv_sislog.des_email,chr(39),''));
            wDes_home_page        := '';
            wCod_bloq             := '';
            wDta_bloq             := '';
            wDes_imagem           := '';
            wDta_afastamento      := to_char(r_clivv_sislog.dta_alteracao,'ddmmyyyy');
            wCod_pessoa_off       := '';
            wInd_cadastro_off     := '';
            wCod_repres_off       := '';
            wDes_email_cel        := '';
            wCod_comprovante_end  := '';
            wDta_ult_alteracao    := to_char(r_clivv_sislog.dta_alteracao,'ddmmyyyy');
            wCod_pessoa_aprova    := '';
            wCod_devolucao        := to_char(r_clivv_sislog.ind_correio);
            wTxt_erro             := '';
            wCod_unidade_reg      := to_char(r_clivv_sislog.num_loja);
            if (wCod_Reduzido is not null) then
                            begin
                          SELECT COD_UNIDADE
                           INTO wCod_unidade_reg
                           FROM PS_CLIENTES
                         WHERE COD_PESSOA = wCod_Reduzido;
                             EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                    wCod_unidade_reg := r_clivv_sislog.num_loja;
                        end;

                        begin
                          SELECT DTA_AFASTAMENTO
                           INTO wDtaAfastamentoLj
                           FROM PS_PESSOAS
                         WHERE COD_PESSOA = wCod_unidade_reg;
                             EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                    wDtaAfastamentoLj := '';
                        end;

                        if wDtaAfastamentoLj is not null then
                           wCod_Unidade_Cli_NL := r_clivv_sislog.num_loja;
                           begin
                                     UPDATE PS_CLIENTES
                                        SET COD_UNIDADE = wCod_unidade_reg
                                      WHERE COD_PESSOA = wCod_Reduzido;
                                     commit;
                           end;
                        end if;
                  end if;


                     UTL_FILE.PUT_LINE(file_handle3,wTip_lin_registro||'^'||wCod_gu||'^'||
                                                   wCod_pessoa||'^'||wDta_transacao||'^'||wDes_pessoa||'^'||wCod_regiao||'^'||
                                                   wCod_cidade||'^'||wCod_atividade||'^'||wTip_pessoa||'^'||wDta_cadastro||'^'||
                                                   wInd_mala_direta||'^'||wInd_inativo||'^'||wTip_transacao||'^'||wTip_status_transacao||'^'||
                                                   wDig_pessoa||'^'||wDes_fantasia||'^'||wDes_endereco||'^'||wDes_ponto_referencia||'^'||
                                                   wDes_bairro||'^'||wNum_cep||'^'||wNum_caixa_postal||'^'||wDes_email||'^'||wDes_home_page||'^'||
                                                   wCod_bloq||'^'||wDta_bloq||'^'||wDes_imagem||'^'||wDta_afastamento||'^'||wCod_pessoa_off||'^'||
                                                   wInd_cadastro_off||'^'||wCod_repres_off||'^'||wDes_email_cel||'^'||wCod_comprovante_end||'^'||
                                                   wDta_ult_alteracao||'^'||wCod_pessoa_aprova||'^'||wCod_devolucao||'^'||wTxt_erro||'^'||
                                                   wCod_unidade_reg||'^');
            --###########################
            --ai_ps_clientes
            --###########################
            wTip_lin_registro     := '20';
            wTip_abc              := '3';
            wTip_end_corresp      := '0';
            wInd_fat_parcial      := '1';
            wTip_aceite_entr      := '0';
            wInd_issqn            := '0';
            wPer_dcto_esp         := '';
            wNum_suframa          := '';
            wNum_sequencia_rota   := '';
            wCod_venc             := '';
            wCod_rota             := '';
            wCod_classe_venda     := '15';
            wCod_transp           := '';
            wCod_cond_pgto        := '1';
            wCod_oper             := '';
            wCod_localidade       := '';
            wPer_dcto_fin         := '';
            wCod_unidade          := to_char(r_clivv_sislog.cod_unidade);
            wDta_validade_suframa := '';
            wCod_redespacho       := '';
            wInd_Retido           := '0';
            UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_gu||'^'||wCod_pessoa||'^'||wDta_transacao||'^'||
                                          wDes_pessoa||'^'||wTip_abc||'^'||wTip_end_corresp||'^'||wInd_fat_parcial||'^'||
                                          wTip_aceite_entr||'^'||wInd_inativo||'^'||wInd_issqn||'^'||wTip_transacao||'^'||
                                          wTip_status_transacao||'^'||wDig_pessoa||'^'||wPer_dcto_esp||'^'||wNum_suframa||'^'||
                                          wNum_sequencia_rota||'^'||wCod_venc||'^'||wCod_rota||'^'||wCod_classe_venda||'^'||
                                          wCod_transp||'^'||wCod_cond_pgto||'^'||wCod_oper||'^'||wCod_localidade||'^'||
                                          wPer_dcto_fin||'^'||wCod_unidade||'^'||wDta_validade_suframa||'^'||wCod_redespacho||'^'||
                                          wTxt_erro||'^'||wCod_unidade_reg||'^'||wInd_Retido||'^');

            if r_clivv_sislog.tip_pessoa <> 2 then
                --###########################
                --ai_ps_fisicas
                --###########################
                wTip_lin_registro    := '30';
                ---if r_clivv_sislog.dta_nascto > wDta_Hoje then
                ---    wDta_nasc        := to_char(add_months(r_clivv_sislog.dta_nascto,-1200),'ddmmyyyy');
                ---else
                ---    wDta_nasc        := to_char(r_clivv_sislog.dta_nascto,'ddmmyyyy');
                ---end if;
                wDta_nasc            := to_char(r_clivv_sislog.dta_nascto,'ddmmyyyy');
                wNum_cpf             := to_char(r_clivv_sislog.num_cpf_cnpj);
                wNum_rg              := '';
                wNum_rg              := '';
                wDta_exp_rg          := '';
                wDes_org_exp_rg      := '';
                wTip_sexo            := to_char(r_clivv_sislog.tip_sexo);
                wTip_civil           := '';
                wDes_conjuge         := '';
                wNum_ser_ctps        := '';
                wNum_ctps            := '';
                wDes_pai             := '';
                wDes_mae             := '';
                wDes_endereco_pai    := '';
                wDes_bairro_pai      := '';
                wNum_cep_pai         := '';
                wTip_residencia      := '1';
                wVlr_aluguel         := '';
                wQtd_mes_residencia  := '';
                wVlr_renda           := '';
                wDes_renda           := '';
                wCod_comprov_renda   := '';
                wCod_pais            := '';
                wCod_uf              := '';
                wCod_cidade_pais     := '';
                wDes_cidade          := '';
                wDes_uf              := '';
                wCod_cid_nasc        := '';
                    wDes_nacionalidade   := '';
                wDta_casamento       := '';
                wNum_cpf_conjuge     := '';
                wNum_rg_conjuge      := '';
                wNum_rg_conjuge      := '';
                wDta_exp_rg_conjuge  := '';
                wDes_org_rg_conjuge  := '';
                wDta_nasc_conjuge    := '';
                wNum_pis             := '';
                wNum_insc_est        := '';
                wDta_ini_residencia  := '';
                wInd_sexo            := '';

                UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wDta_transacao||'^'||
                                              wTip_transacao||'^'||wTip_status_transacao||'^'||wDta_nasc||'^'||
                                              wNum_cpf||'^'||wNum_rg||'^'||wDta_exp_rg||'^'||wDes_org_exp_rg||'^'||
                                              wTip_sexo||'^'||wTip_civil||'^'||wDes_conjuge||'^'||wNum_ser_ctps||'^'||
                                              wNum_ctps||'^'||wDes_pai||'^'||wDes_mae||'^'||wDes_endereco_pai||'^'||
                                              wDes_bairro_pai||'^'||wNum_cep_pai||'^'||wTip_residencia||'^'||wVlr_aluguel||'^'||
                                              wQtd_mes_residencia||'^'||wVlr_renda||'^'||wDes_renda||'^'||wCod_comprov_renda||'^'||
                                              wCod_pais||'^'||wCod_uf||'^'||wCod_cidade_pais||'^'||wCod_cid_nasc||'^'||wDes_nacionalidade||'^'||
                                              wDta_casamento||'^'||wNum_cpf_conjuge||'^'||wNum_rg_conjuge||'^'||wDta_exp_rg_conjuge||'^'||
                                              wDes_org_rg_conjuge||'^'||wDta_nasc_conjuge||'^'||wNum_pis||'^'||wNum_insc_est||'^'||
                                              wDta_ini_residencia||'^'||wInd_sexo||'^'||wCod_parentesco||'^'||wTxt_erro||'^'||
                                              wCod_unidade_reg||'^');
            else
                --###########################
                --ai_ps_juridicas
                --###########################
                wTip_lin_registro           := '35';
                wNum_cgc                    := to_char(r_clivv_sislog.num_cpf_cnpj);
                wVlr_capital_social         := '';
                ---if r_clivv_sislog.dta_nascto > wDta_Hoje then
                ---    wDta_fundacao           := to_char(add_months(r_clivv_sislog.dta_nascto,-1200),'ddmmyyyy');
                ---else
                ---    wDta_fundacao           := to_char(r_clivv_sislog.dta_nascto,'ddmmyyyy');
                ---end if;
                wDta_fundacao               := to_char(r_clivv_sislog.dta_nascto,'ddmmyyyy');
                wNum_insc_est               := replace(r_clivv_sislog.num_insc_est,chr(39),'');
                wQtd_funcionarios           := '';
                wNum_cert_qualidade         := '';
                wCod_ean                    := '';
                wDta_ult_alt_capital_social := '';
                wCod_reg_ibama              := '';
                wNum_aut_ibama              := '';
                wNum_contrato_social        := '';
                wNum_insc_mun               := '';
                wIndNaoContribuinte         := '0';

                UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wDta_transacao||'^'||wTip_transacao||'^'||
                                              wTip_status_transacao||'^'||wNum_cgc||'^'||wVlr_capital_social||'^'||wDta_fundacao||'^'||
                                              wNum_insc_est||'^'||wQtd_funcionarios||'^'||wNum_cert_qualidade||'^'||wCod_ean||'^'||
                                              wDta_ult_alt_capital_social||'^'||wCod_reg_ibama||'^'||wNum_aut_ibama||'^'||wNum_contrato_social||'^'||
                                              wNum_insc_mun||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^'||wIndNaoContribuinte||'^');
            end if;
            --###########################
            --ai_ps_telefones
            --###########################
            wTip_lin_registro  := '50';
            iCount := 0;
            while iCount < 2 loop
                    iCount := iCount + 1;
                    wNum_fone := '';
                    if iCount = 1 then
                     wNum_seq           := 1;
                     wNum_fone          := r_clivv_sislog.des_telefone;
                     if wNum_fone = '000000000000' then
                         wNum_fone :='';
                     end if;
                     wDes_fone          := 'RESIDENCIAL';
                elsif iCount = 2 then
                     wNum_seq           := 15;
                     wNum_fone          := r_clivv_sislog.des_celular;
                     if wNum_fone = '000000000000' then
                         wNum_fone :='';
                     end if;
                     wDes_fone          := 'CELULAR';
                end if;
                wInd_uso_ddd       := '';
                wTip_endereco      := '';
                wExisteFone        := 0;
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
                  --- (wExisteFone = 1) then
                    UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wNum_seq||'^'||
                                                  wDta_transacao||'^'||wNum_fone||'^'||wDes_fone||'^'||
                                                  wTip_transacao||'^'||wTip_status_transacao||'^'||wInd_uso_ddd||'^'||
                                                  wTip_endereco||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');
                end if;
                end loop;
            --###########################
            --ai_ps_prof_clientes
            --###########################
            wTip_lin_registro    := '65';
            wTip_inf_prof        := '1';
            wDes_emp             := 'VENDA A VISTA';
            wCod_comprov         := '0';
            wCod_funcao          := to_char(r_clivv_sislog.cod_profissao);
            wVlr_salario         := '0';
            wNum_fone            := '';
            wNum_cnpj_empregador := '';
            wDta_admissao        := '';
            wDes_endereco        := '';
            wDes_bairro          := '';
            wNum_cep             := '';
            if wDes_emp is not null then
                UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_pessoa||'^'||wTip_inf_prof||'^'||
                                                   wDes_emp||'^'||wDta_transacao||'^'||wCod_comprov||'^'||wCod_cidade||'^'||
                                                   wCod_funcao||'^'||wVlr_salario||'^'||wTip_transacao||'^'||wTip_status_transacao||'^'||
                                                   wNum_fone||'^'||wDes_endereco||'^'||wDes_bairro||'^'||wNum_cep||'^'||wNum_cnpj_empregador||'^'||
                                                   wDta_admissao||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');
            end if;
             --###########################
            --ai_ps_mascaras
            --###########################
                        wTip_lin_registro    := '110';
            wCod_mascara         := '50';
            --if (r_clivv_sislog.num_rede = 70) or (r_clivv_sislog.num_rede = 40) or (wLojaMigrada <> 0) then
               IF not (r_clivv_sislog.cod_cartao_cliente is null) then
                   wCod_completo        := lPad(wNum_rede,2,'0')||lpad(to_char(r_clivv_sislog.cod_cartao_cliente),12,'0');
                   wCod_editado         := lPad(wNum_rede,2,'0')||'.'||lpad(to_char(r_clivv_sislog.cod_cartao_cliente),12,'0');
                   wCod_niv1            := lPad(wNum_rede,2,'0');
                   wCod_niv2            := lpad(to_char(r_clivv_sislog.cod_cartao_cliente),12,'0');
               else
                               wCod_completo        := substr(wCod_pessoa,1,2)||substr(wCod_pessoa,3,12);
                   wCod_editado         := substr(wCod_pessoa,1,2)||'.'||substr(wCod_pessoa,3,12);
                   wCod_niv1            := substr(wCod_pessoa,1,2);
                   wCod_niv2            := substr(wCod_pessoa,3,12);
               end if;
            /*else
               wCod_completo        := lPad(wNum_rede,2,'0')||lpad(to_char(r_clivv_sislog.cod_cliente),12,'0');
               wCod_editado         := lPad(wNum_rede,2,'0')||'.'||lpad(to_char(r_clivv_sislog.cod_cliente),12,'0');
               wCod_niv1            := lPad(wNum_rede,2,'0');
               wCod_niv2            := lpad(to_char(r_clivv_sislog.cod_cliente),12,'0');
            end if; */
            wCod_niv0            := '1';


            wCod_niv3            := '';
            wCod_niv4            := '';
            wCod_niv5            := '';
            wCod_niv6            := '';
            wCod_niv7            := '';
            wCod_niv8            := '';
            wCod_niv9            := '';

                        UTL_FILE.PUT_LINE(file_handle3,wTip_Lin_Registro||'^'||wCod_mascara||'^'||wCod_pessoa||'^'||
                                                      wCod_completo||'^'||wDta_transacao||'^'||wCod_niv0||'^'||
                                                      wTip_transacao||'^'||wTip_status_transacao||'^'||wCod_editado||'^'||
                                                      wCod_niv1||'^'||wCod_niv2||'^'||wCod_niv3||'^'||wCod_niv4||'^'||
                                                      wCod_niv5||'^'||wCod_niv6||'^'||wCod_niv7||'^'||wCod_niv8||'^'||
                                                      wCod_niv9||'^'||wTxt_erro||'^'||wCod_unidade_reg||'^');
                      end if;
               END;
               FETCH c_clivv_sislog INTO r_clivv_sislog;
               END LOOP;
               CLOSE c_clivv_sislog;

             --- busca registro de leitura e entrega de cart¿es de clientes
             -- foi separado o processo dos cart¿es
         /*  OPEN c_clientes_cartoes;
           FETCH c_clientes_cartoes INTO r_clientes_cartoes;
           WHILE c_clientes_cartoes%FOUND LOOP
           BEGIN
               --###########################
           --ai_ps_observacoes
               --###########################
           wTip_lin_registro    := '85';
               wNum_maq  := '0';
           wDta_obs  := to_char(r_clientes_cartoes.dta_lancamento,'ddmmyyyy');
           wDta_transacao := to_char(r_clientes_cartoes.dta_lancamento,'ddmmyyyy');
           wCod_unidade_reg := r_clientes_cartoes.num_loja;

                   wCod_pessoa           := lpad(wNum_rede,2,'0')||lpad(to_char(r_clientes_cartoes.cod_cliente),8,'0');


                   wTxt_erro    := '';
                   wDes_resp    := 'LOJA';
                   if r_clientes_cartoes.ind_status = 1 then -- na loja
              wCod_obs     := '9010';
                  wNum_seq_obs := r_clientes_cartoes.cod_adicional;
              wTxt_obs     := 'Cart¿o dispon¿vel em '||r_clientes_cartoes.dta_lancamento||' - LOJA: '||r_clientes_cartoes.num_loja;
                   elsif r_clientes_cartoes.ind_status = 2 then -- entregue
              wCod_obs     := '9015';
                  wNum_seq_obs := r_clientes_cartoes.cod_adicional;
              wTxt_obs     := 'Cart¿o novo bloqueado em '||r_clientes_cartoes.dta_lancamento||' - LOJA: '||r_clientes_cartoes.num_loja;
                   elsif r_clientes_cartoes.ind_status = 3 then --descarte
              wCod_obs     := '9100';
                  wNum_seq_obs := r_clientes_cartoes.cod_adicional;
              wTxt_obs     := 'Cart¿o Descartado em '||r_clientes_cartoes.dta_lancamento||' - LOJA: '||r_clientes_cartoes.num_loja;
                   elsif r_clientes_cartoes.ind_status = 4 then -- defeito
              wCod_obs     := '9030';
                  wNum_seq_obs := r_clientes_cartoes.cod_adicional;
              wTxt_obs     := 'Cart¿o com defeito em '||r_clientes_cartoes.dta_lancamento||' - LOJA: '||r_clientes_cartoes.num_loja;
                   elsif r_clientes_cartoes.ind_status = 5 then -- desbloqueado
              wCod_obs     := '9020';
                  wNum_seq_obs := r_clientes_cartoes.cod_adicional;
              wTxt_obs     := 'Cart¿o novo desbloqueado em '||r_clientes_cartoes.dta_lancamento||' - LOJA: '||r_clientes_cartoes.num_loja;
           end if;

                    UTL_FILE.PUT_LINE(file_handle1,wTip_Lin_Registro||'^'||wNum_maq||'^'||wCod_pessoa||'^'||
                                                  wCod_obs||'^'||wDta_obs||'^'||wNum_seq_obs||'^'||wDta_transacao||'^'||
                                                  wDes_resp||'^'||wTxt_obs||'^'||wTip_transacao||'^'||wTip_status_transacao||'^'||
                                                  wTxt_erro||'^'||wCod_unidade_reg||'^');


               END;
               FETCH c_clientes_cartoes INTO r_clientes_cartoes;
               END LOOP;
               CLOSE c_clientes_cartoes; */


             --- busca clientes com acoes de cobranca do novo sislog
           OPEN c_spc_sislog;
           FETCH c_spc_sislog INTO r_spc_sislog;
           WHILE c_spc_sislog%FOUND LOOP
           BEGIN
                    if r_spc_sislog.num_rede = 55 then
                        wNum_rede := '60';
                    else
                        wNum_rede := lPad(to_char(r_spc_sislog.num_rede),2,'0');
                    end if;

            wCod_gu               := '1';
            wCod_pessoa           := lpad(wNum_rede,2,'0')||lpad(to_char(r_spc_sislog.cod_cliente),12,'0');
            wDta_transacao        := to_char(r_spc_sislog.dta_mvto,'ddmmyyyy');
                      wCod_Reduzido         := '';
                      begin
                   SELECT COD_PESSOA
                       INTO wCod_Reduzido
                       FROM PS_MASCARAS
                     WHERE COD_MASCARA  = 50
                         AND COD_COMPLETO = wCod_pessoa;
                         EXCEPTION
                           WHEN NO_DATA_FOUND THEN
                              wCod_Reduzido := '';
                  end;

            --###########################
            --ai_cr_acoes_cobranca
            --###########################
                      if nvl(wCod_Reduzido,0) > 0 then
                         begin
                     SELECT IND_NEGATIVADO,
                            DTA_NEGATIVACAO,
                            DTA_REABILITACAO
                         INTO wInd_Negativado,
                              wDta_Negativacao,
                              wDta_Reabilitacao
                         FROM PS_PERFIS
                       WHERE COD_GU     = 1
                           AND COD_PESSOA = wCod_Reduzido;
                           EXCEPTION
                             WHEN NO_DATA_FOUND THEN
                                wInd_Negativado   := '';
                              wDta_Negativacao  := '';
                              wDta_Reabilitacao := '';
                     end;
                           if (nvl(wInd_Negativado,0) = 1) and
                              (nvl(r_spc_sislog.ind_negativado,9) = 1) and
                              (r_spc_sislog.dta_negativacao is not null) and
                              (wDta_Negativacao is null) then
                                wGeraAcao := 'S';
                           elsif (nvl(wInd_Negativado,0) = 1) and
                                 (nvl(r_spc_sislog.ind_negativado,9) = 1) and
                                 (r_spc_sislog.dta_negativacao is not null) and
                                 (nvl(wDta_Negativacao,r_spc_sislog.dta_negativacao) < nvl(r_spc_sislog.dta_negativacao,wDta_Hoje)) then
                                   wGeraAcao := 'S';
                           elsif (nvl(wInd_Negativado,0) = 1) and
                                 (nvl(r_spc_sislog.ind_negativado,9) <> 1) and
                                 (r_spc_sislog.dta_reabilitacao is not null) and
                                 (wDta_Reabilitacao is null) then
                                   wGeraAcao := 'S';
                           elsif (nvl(wInd_Negativado,0) = 1) and
                                 (nvl(r_spc_sislog.ind_negativado,9) <> 1) and
                                 (r_spc_sislog.dta_reabilitacao is not null) and
                                 (nvl(wDta_Reabilitacao,r_spc_sislog.dta_reabilitacao) < nvl(r_spc_sislog.dta_reabilitacao,wDta_Hoje)) then
                                   wGeraAcao := 'S';
                           elsif (nvl(wInd_Negativado,0) = 0) and
                                 (nvl(r_spc_sislog.ind_negativado,9) = 1) and
                                 (r_spc_sislog.dta_negativacao is not null) then
                                   wGeraAcao := 'S';
               elsif (nvl(wInd_Negativado,0) = 0) and
                                 (nvl(r_spc_sislog.ind_negativado,9) = 0) and
                                 (r_spc_sislog.dta_reabilitacao is not null) and
                                 (nvl(wDta_Reabilitacao,r_spc_sislog.dta_reabilitacao) < nvl(r_spc_sislog.dta_reabilitacao,wDta_Hoje)) then
                                   wGeraAcao := 'S';
                           else
                               wGeraAcao := 'N';
                           end if;

                          if wGeraAcao = 'S' then
                            wTip_lin_registro    := '70';
                            --wCod_gu
                            if (nvl(r_spc_sislog.cod_uni_titulo,0) = 0) then
                                wCod_unidade_Tit := 0;
                            else
                                wCod_unidade_Tit := r_spc_sislog.cod_uni_titulo;
                            end if;
                            --wCod_pessoa
                            if (nvl(r_spc_sislog.num_titulo,0) = 0) then
                                wNum_titulo := 0;
                            else
                                wNum_titulo := r_spc_sislog.num_titulo;
                            end if;
                            if (nvl(r_spc_sislog.num_parcela,0) = 0) then
                                wNum_parcela := 0;
                            else
                                wNum_parcela := r_spc_sislog.num_parcela;
                            end if;
                            if (r_spc_sislog.dta_parcela is null) then
                                wdta_atraso_spc := NULL;
                            else
                                wdta_atraso_spc := r_spc_sislog.dta_parcela;
                            end if;
                            if (nvl(r_spc_sislog.vlr_negativado,0) = 0) then
                                wvlr_negativado := 0;
                            else
                                wvlr_negativado := r_spc_sislog.vlr_negativado;
                            end if;
                  if nvl(r_spc_sislog.ind_negativado,9) = 1 then
                    open c_cr_titulos_acao_n;
                  fetch c_cr_titulos_acao_n into r_cr_titulos_acao_n;
                  if c_cr_titulos_acao_n%found then
                    wCod_unidade_Tit := to_char(r_cr_titulos_acao_n.cod_unidade);
                    wNum_titulo  := to_char(r_cr_titulos_acao_n.num_titulo);
                    wCod_compl   := r_cr_titulos_acao_n.cod_compl;
                    wNum_parcela := to_char(r_cr_titulos_acao_n.num_parcela);
                  else
                      open c_cr_titulos_dt_n;
                    fetch c_cr_titulos_dt_n into r_cr_titulos_dt_n;
                    if c_cr_titulos_dt_n%found then
                      wCod_unidade_Tit := to_char(r_cr_titulos_dt_n.cod_unidade);
                      wNum_titulo  := to_char(r_cr_titulos_dt_n.num_titulo);
                      wCod_compl   := r_cr_titulos_dt_n.cod_compl;
                      wNum_parcela := to_char(r_cr_titulos_dt_n.num_parcela);
                    else
                      open c_cr_titulos_vlr_n;
                      fetch c_cr_titulos_vlr_n into r_cr_titulos_vlr_n;
                      if c_cr_titulos_vlr_n%found then
                      wCod_unidade_Tit := to_char(r_cr_titulos_vlr_n.cod_unidade);
                    wNum_titulo  := to_char(r_cr_titulos_vlr_n.num_titulo);
                    wCod_compl   := r_cr_titulos_vlr_n.cod_compl;
                    wNum_parcela := to_char(r_cr_titulos_vlr_n.num_parcela);
                      else
                        open c_cr_titulos_dt_min_n;
                        fetch c_cr_titulos_dt_min_n into r_cr_titulos_dt_min_n;
                        if c_cr_titulos_dt_min_n%found then
                        wCod_unidade_Tit := to_char(r_cr_titulos_dt_min_n.cod_unidade);
                        wNum_titulo  := to_char(r_cr_titulos_dt_min_n.num_titulo);
                        wCod_compl   := r_cr_titulos_dt_min_n.cod_compl;
                        wNum_parcela := to_char(r_cr_titulos_dt_min_n.num_parcela);
                    else
                           wNum_titulo  := '';
                       wCod_compl   := '';
                       wNum_parcela := '';
                                       begin
                                            update ps_perfis
                                               set ind_negativado  = 1,
                                                   dta_negativacao = r_spc_sislog.dta_negativacao,
                                                   vlr_negativado  = r_spc_sislog.vlr_negativado
                                             where cod_gu     = 1
                                        and cod_pessoa = wCod_Reduzido;
                                     exception when others then
                                        wCod_compl   := '';
                                end;
                                begin
                                            update ps_perfis_ano
                                               set ind_negativado  = 1,
                                                   dta_negativacao = r_spc_sislog.dta_negativacao,
                                                   vlr_negativado  = r_spc_sislog.vlr_negativado
                                             where cod_gu     = 1
                                        and cod_pessoa = wCod_Reduzido;
                                    exception when others then
                                        wCod_compl   := '';
                                end;
                    end if;
                    close c_cr_titulos_dt_min_n;
                      end if;
                      close c_cr_titulos_vlr_n;
                    end if;
                    close c_cr_titulos_dt_n;
                  end if;
                  close c_cr_titulos_acao_n;
                            else
                    if nvl(r_spc_sislog.ind_negativado,9) = 0 then
                      open c_cr_titulos_acao_r;
                    fetch c_cr_titulos_acao_r into r_cr_titulos_acao_r;
                    if c_cr_titulos_acao_r%found then
                      wCod_unidade_Tit := to_char(r_cr_titulos_acao_r.cod_unidade);
                      wNum_titulo  := to_char(r_cr_titulos_acao_r.num_titulo);
                      wCod_compl   := r_cr_titulos_acao_r.cod_compl;
                      wNum_parcela := to_char(r_cr_titulos_acao_r.num_parcela);
                    else
                        open c_cr_titulos_dt_r;
                      fetch c_cr_titulos_dt_r into r_cr_titulos_dt_r;
                      if c_cr_titulos_dt_r%found then
                        wCod_unidade_Tit := to_char(r_cr_titulos_dt_r.cod_unidade);
                        wNum_titulo  := to_char(r_cr_titulos_dt_r.num_titulo);
                        wCod_compl   := r_cr_titulos_dt_r.cod_compl;
                        wNum_parcela := to_char(r_cr_titulos_dt_r.num_parcela);
                      else
                        open c_cr_titulos_vlr_r;
                        fetch c_cr_titulos_vlr_r into r_cr_titulos_vlr_r;
                        if c_cr_titulos_vlr_r%found then
                      wCod_unidade_Tit := to_char(r_cr_titulos_vlr_r.cod_unidade);
                      wNum_titulo  := to_char(r_cr_titulos_vlr_r.num_titulo);
                      wCod_compl   := r_cr_titulos_vlr_r.cod_compl;
                      wNum_parcela := to_char(r_cr_titulos_vlr_r.num_parcela);
                        else
                          open c_cr_titulos_dt_min_r;
                          fetch c_cr_titulos_dt_min_r into r_cr_titulos_dt_min_r;
                          if c_cr_titulos_dt_min_r%found then
                        wCod_unidade_Tit := to_char(r_cr_titulos_dt_min_r.cod_unidade);
                        wNum_titulo  := to_char(r_cr_titulos_dt_min_r.num_titulo);
                        wCod_compl   := r_cr_titulos_dt_min_r.cod_compl;
                        wNum_parcela := to_char(r_cr_titulos_dt_min_r.num_parcela);
                      else
                            wNum_titulo  := '';
                        wCod_compl   := '';
                        wNum_parcela := '';
                                        begin
                                             update ps_perfis
                                                set ind_negativado = 0,
                                                    dta_reabilitacao = r_spc_sislog.dta_reabilitacao
                                              where cod_gu     = 1
                                         and cod_pessoa = wCod_Reduzido;
                                      exception when others then
                                         wCod_compl   := '';
                                 end;
                                 begin
                                             update ps_perfis_ano
                                                set ind_negativado = 0,
                                                    dta_reabilitacao = r_spc_sislog.dta_reabilitacao
                                              where cod_gu     = 1
                                         and cod_pessoa = wCod_Reduzido;
                                      exception when others then
                                         wCod_compl   := '';
                                 end;
                                      end if;
                      close c_cr_titulos_dt_min_r;
                        end if;
                        close c_cr_titulos_vlr_r;
                      end if;
                      close c_cr_titulos_dt_r;
                    end if;
                    close c_cr_titulos_acao_r;
                              end if;
                            end if;
                            wNum_acao := '15';
                            if nvl(r_spc_sislog.ind_negativado,9) = 1 then
                              wDta_acao        := to_char(r_spc_sislog.dta_negativacao,'ddmmyyyy');
                              wDta_remessa     := to_char(r_spc_sislog.dta_negativacao,'ddmmyyyy');
                              wDta_retorno_spc := '';
                            elsif nvl(r_spc_sislog.ind_negativado,9) = 0 then
                              wDta_acao        := to_char(r_spc_sislog.dta_reabilitacao,'ddmmyyyy');
                              if (r_spc_sislog.dta_negativacao is not null) then
                                  wDta_remessa := to_char(r_spc_sislog.dta_negativacao,'ddmmyyyy');
                              else
                                  wDta_remessa := '';
                              end if;
                              wDta_retorno_spc := to_char(r_spc_sislog.dta_reabilitacao,'ddmmyyyy');
                            end if;
                wInd_telefonema     := '0';
                wNum_sessao         := '';
                wInd_acao           := '2';
                wTxt_obs            := r_spc_sislog.txt_observacao;
                wDta_carta_cobr     := '';
                            UTL_FILE.PUT_LINE(file_handle2,wTip_Lin_Registro||'^'||wCod_gu||'^'||wCod_Unidade_Tit||'^'||
                                                           wCod_pessoa||'^'||wNum_titulo||'^'||wCod_compl||'^'||
                                                           wNum_parcela||'^'||wNum_acao||'^'||wDta_acao||'^'||
                                                           wDta_transacao||'^'||wTip_transacao||'^'||wTip_status_transacao||'^'||
                                                           wDta_remessa||'^'||wDta_retorno_spc||'^'||wInd_telefonema||'^'||
                                                           wNum_sessao||'^'||wInd_acao||'^'||wTxt_obs||'^'||wDta_carta_cobr||'^'||wTxt_erro||'^');
                          end if;
                        end if;
               END;
               FETCH c_spc_sislog INTO r_spc_sislog;
               END LOOP;
               CLOSE c_spc_sislog;


               UTL_FILE.FCLOSE(file_handle1);
               UTL_FILE.FCLOSE(file_handle2);
               UTL_FILE.FCLOSE(file_handle3);

               commit;
             END;
END GRZ_SP_INTERFACE_CADCLIENTES;
--END GRZINTERFACECADCLIENTES_TESTE;

