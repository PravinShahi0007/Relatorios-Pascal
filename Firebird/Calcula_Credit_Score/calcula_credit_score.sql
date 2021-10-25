commit work;
set autoddl off;
set term ^ ;

create or alter procedure calcula_credit_score
(
 ipi_cod_emp                  numeric(4,0),
 ipi_cod_unidade              numeric(4,0),
 ipi_cpf_cnpj_cli             numeric(14,0),
 iidade                       numeric(4,0),
 ipi_cod_estado_civil         numeric(4,0),
 ipi_cod_profissao            numeric(4,0),
 ipi_tipo_profissao           numeric(4,0),
 ipi_cod_conceito_endereco    numeric(4,0),
 ipi_cod_tipo_residencia      numeric(4,0),
 ipi_qtd_dependentes          numeric(4,0),
 ipi_cod_telefone_autorizado  numeric(4,0),
 ipi_possui_cartao_credito    numeric(4,0),
 iind_possui_fone_residencial numeric(4,0),
 iind_possui_fone_comercial   numeric(4,0),
 iind_possui_fone_cel1        numeric(4,0),
 iind_possui_fone_cel2        numeric(4,0),
 iind_possui_fone_recado      numeric(4,0),
 ipi_ind_renda_comprovada     numeric(4,0),
 ipi_vlr_renda_principal      numeric(15,2),
 ipi_ind_out_renda_comprov    numeric(15,2),
 ipi_vlr_outras_rendas        numeric(15,2),
 idias_casamento              numeric(8,0),
 idias_servico                numeric(8,0),
 idias_tempo_residencia       numeric(8,0),
 igravar_mvto                 numeric(8,0),
 ipi_ind_conceito_gerente     numeric(1,0)
)
returns
(
 po_vlr_limite      numeric(15,2),
 po_qtd_pontos      numeric(4,0),
 po_perfil          numeric(4,0),
 po_mda             numeric(4,0),
 po_iqtd_prestacoes numeric(4,0),
 po_vlr_creditscore numeric(15,2)
)
as
  declare variable iperfil                       numeric(8);
  declare variable imda                          numeric(8);
  declare variable iqtd_pontos_estado_civil      numeric(8);
  declare variable iqtd_pontos_profissao         numeric(8);
  declare variable iqtd_pontos_tempo_servico     numeric(8);
  declare variable inum_seq                      numeric(8);
  declare variable iqtd_pontos_idade             numeric(8);
  declare variable iqtd_pontos_conceito_endereco numeric(8);
  declare variable iqtd_pontos_tempo_residencia  numeric(8);
  declare variable iqtd_pontos_tipo_residencia   numeric(8);
  declare variable iqtd_pontos_fone_residencial  numeric(8);
  declare variable iqtd_pontos_fone_comercial    numeric(8);
  declare variable iqtd_pontos_fone_cel1         numeric(8);
  declare variable iqtd_pontos_fone_cel2         numeric(8);
  declare variable iqtd_pontos_fone_recado       numeric(8);
  declare variable iqtd_pontos_tipo_telefone     numeric(8);
  declare variable iqtd_pontos_dependentes       numeric(8);
  declare variable iqtd_pontos_telef_autorizado  numeric(8);
  declare variable iqtd_pontos_cartao_credito    numeric(8);
  declare variable iqtd_pontos_mda               numeric(8);
  declare variable ipercentual_outras_rendas     numeric(15,2);
  declare variable ivlr_calc_outra_renda         numeric(15,2);
  declare variable iqtd_pontos_perfil            numeric(8);
  declare variable ivlr_renda_presumida          numeric(15,2);
  declare variable ivlr_renda_principal          numeric(15,2);
  declare variable ivlr_renda_liquida            numeric(15,2);
  declare variable ivlr_aluguel                  numeric(15,2);
  declare variable iind_profissao_risco          numeric(8);
  declare variable ilimite_cliente               numeric(15,2);
  declare variable ilimite                       numeric(15,2);
  declare variable iperc_parametrizacao_cs       numeric(15,2);
  declare variable iqtd_prestacoes               numeric(8);
  declare variable imultiplicador_limite         numeric(8);
  declare variable iqtd_pontos_geral             numeric(8);
  declare variable iqtd_pontos_conceito_gerente  numeric(8);
  declare variable itipo_telefone                varchar(80);
begin
     select max(distinct num_seq)
     from cre_credit_score_mvto
     where cod_emp = :ipi_cod_emp
     and cod_unidade = :ipi_cod_unidade
     and cod_cliente = :ipi_cpf_cnpj_cli
     and dta_mvto = current_date
     into inum_seq;

     if (inum_seq is null) then
        inum_seq = 1;
     else
         inum_seq = :inum_seq + 1;

     select num_mda,cod_perfil_cli
     from cre_saldos_cli
     where cod_cliente = :ipi_cpf_cnpj_cli
     into imda,iperfil;

     if (imda is null) then
        imda = 0;
     else
         imda= imda;

     if (iperfil is null) then
        iperfil = 0;
     else
         iperfil = iperfil;

     -- Idade
     select qtd_pontos
     from cre_credit_score_calculo
     where cod_calculo = 1
     and :iidade between param_ini and param_fim
     into iqtd_pontos_idade;

     if (igravar_mvto = 1) then
     begin
          insert into cre_credit_score_mvto (cod_emp,
                                             cod_unidade,
                                             cod_cliente,
                                             dta_mvto,
                                             num_seq,
                                             cod_calculo,
                                             qtd_pontos,
                                             param_entr)
          values (:ipi_cod_emp,
                  :ipi_cod_unidade,
                  :ipi_cpf_cnpj_cli,
                  current_timestamp ,
                  :inum_seq,
                  1,
                  :iqtd_pontos_idade,
                  :iidade);
     end

     -- Estado Civil
     select qtd_pontos
     from cre_credit_score_calculo
     where cod_calculo = 2
     and :ipi_cod_estado_civil between param_ini and param_fim
     and :idias_casamento between coalesce (teste_adicional_ini,0)
     and coalesce (teste_adicional_fim,0)
     into iqtd_pontos_estado_civil;

     if (iqtd_pontos_estado_civil = null) then
     begin
          iqtd_pontos_estado_civil = 0;
     end

     if (igravar_mvto = 1) then
     begin
          insert into cre_credit_score_mvto (cod_emp,
                                             cod_unidade,
                                             cod_cliente,
                                             dta_mvto,
                                             num_seq,
                                             cod_calculo,
                                             qtd_pontos,
                                             param_entrada)
          values (:ipi_cod_emp,
                  :ipi_cod_unidade,
                  :ipi_cpf_cnpj_cli,
                  current_timestamp ,
                  :inum_seq,
                  2,
                  :iqtd_pontos_estado_civil,
                  :idias_casamento);
     end

     -- Profissao
     select qtd_pontos_prof
     from ger_profissoes
     where cod_profissao = :ipi_cod_profissao
     into iqtd_pontos_profissao;

     if (igravar_mvto = 1) then
     begin
          insert into cre_credit_score_mvto (cod_emp,
                                             cod_unidade,
                                             cod_cliente,
                                             dta_mvto,
                                             num_seq,
                                             cod_calculo,
                                             qtd_pontos,
                                             param_entrada)
          values (:ipi_cod_emp,
                  :ipi_cod_unidade,
                  :ipi_cpf_cnpj_cli,
                  current_timestamp ,
                  :inum_seq,
                  3,
                  :iqtd_pontos_profissao,
                  :ipi_cod_profissao);
     end

     -- Tempo de Servico
     if (ipi_cod_profissao <> 3) then
     begin
          select qtd_pontos
          from cre_credit_score_calculo
          where cod_calculo = 4
          and :idias_servico between param_ini and param_fim
          into iqtd_pontos_tempo_servico;
     end
     else
     begin
          iqtd_pontos_tempo_servico = 0;
     end

     if (igravar_mvto = 1) then
     begin
          insert into cre_credit_score_mvto (cod_emp,
                                             cod_unidade,
                                             cod_cliente,
                                             dta_mvto,
                                             num_seq,
                                             cod_calculo,
                                             qtd_pontos,
                                             param_entrada)
          values (:ipi_cod_emp,
                  :ipi_cod_unidade,
                  :ipi_cpf_cnpj_cli,
                  current_timestamp ,
                  :inum_seq,
                  4,
                  :iqtd_pontos_tempo_servico,
                  :idias_servico);
     end

     -- Conceito de Endereco (endereco comprovado)
     select qtd_pontos
     from cre_credit_score_calculo
     where cod_calculo = 5
     and :ipi_cod_conceito_endereco between param_ini and param_fim
     into iqtd_pontos_conceito_endereco;

     if (igravar_mvto = 1) then
     begin
          insert into cre_credit_score_mvto (cod_emp,
                                             cod_unidade,
                                             cod_cliente,
                                             dta_mvto,
                                             num_seq,
                                             cod_calculo,
                                             qtd_pontos,
                                             param_entrada)
          values (:ipi_cod_emp,
                  :ipi_cod_unidade,
                  :ipi_cpf_cnpj_cli,
                  current_timestamp ,
                  :inum_seq,
                  5,
                  :iqtd_pontos_conceito_endereco,
                  :ipi_cod_conceito_endereco);
     end

     -- Tempo de Residencia
     select qtd_pontos
     from cre_credit_score_calculo
     where cod_calculo = 6
     and :idias_tempo_residencia between param_ini and param_fim
     into iqtd_pontos_tempo_residencia;

     if (igravar_mvto = 1) then
     begin
          insert into cre_credit_score_mvto (cod_emp,
                                             cod_unidade,
                                             cod_cliente,
                                             dta_mvto,
                                             num_seq,
                                             cod_calculo,
                                             qtd_pontos,
                                             param_entrada)
          values (:ipi_cod_emp,
                  :ipi_cod_unidade,
                  :ipi_cpf_cnpj_cli,
                  current_timestamp ,
                  :inum_seq,
                  6,
                  :iqtd_pontos_tempo_residencia,
                  :idias_tempo_residencia);
     end

     -- Tipo de Residencia
     select qtd_pontos
     from cre_credit_score_calculo
     where cod_calculo = 7
     and :ipi_cod_tipo_residencia between param_ini and param_fim
     into iqtd_pontos_tipo_residencia;

     if (igravar_mvto = 1) then
     begin
          insert into cre_credit_score_mvto (cod_emp,
                                             cod_unidade,
                                             cod_cliente,
                                             dta_mvto,
                                             num_seq,
                                             cod_calculo,
                                             qtd_pontos,
                                             param_entrada)
          values (:ipi_cod_emp,
                  :ipi_cod_unidade,
                  :ipi_cpf_cnpj_cli,
                  current_timestamp ,
                  :inum_seq,
                  7,
                  :iqtd_pontos_tipo_residencia,
                  :ipi_cod_tipo_residencia);
     end

     -- Telefone
     iqtd_pontos_fone_residencial = 0;
     iqtd_pontos_fone_comercial = 0;
     iqtd_pontos_fone_cel1 = 0;
     iqtd_pontos_fone_cel2 = 0;
     iqtd_pontos_fone_recado = 0;
     itipo_telefone = '';

     ------------------------------------------------------------
     if (iind_possui_fone_cel1 > 0) then
     begin
          itipo_telefone = itipo_telefone || '1 - Whatsapp';
     end

     if (iind_possui_fone_cel2 > 0) then
     begin
          if (itipo_telefone = '') then
          begin
               itipo_telefone = itipo_telefone || '2 - Celular';
          end
          else
              itipo_telefone = itipo_telefone || ', 2 - Celular';
     end

     if (iind_possui_fone_recado > 0) then
     begin
          if (itipo_telefone = '') then
          begin
               itipo_telefone = itipo_telefone || '3 - Recado';
          end
          else
              itipo_telefone = itipo_telefone || ', 3 - Recado';
     end

     if (iind_possui_fone_residencial > 0) then
     begin
          if (itipo_telefone = '') then
          begin
              itipo_telefone = itipo_telefone || '4 - Residencial';
          end
          else
              itipo_telefone = itipo_telefone || ', 4 - Residencial';
     end

     if (iind_possui_fone_comercial > 0) then
     begin
          if (itipo_telefone = '') then
          begin
               itipo_telefone = itipo_telefone || '5 - Trabalho';
          end
          else
              itipo_telefone = itipo_telefone || ', 5 - Trabalho';
     end

     ------------------------------------------------------------
     if (iind_possui_fone_residencial > 0) then
     begin
          select qtd_pontos
          from cre_credit_score_calculo
          where cod_calculo = 8
          and 4 between param_ini and param_fim
          into iqtd_pontos_fone_residencial;
     end

     if (iind_possui_fone_comercial > 0) then
     begin
          select qtd_pontos
          from cre_credit_score_calculo
          where cod_calculo = 8
          and 5 between param_ini and param_fim
          into iqtd_pontos_fone_comercial;
     end

     if (iind_possui_fone_cel1 > 0) then
     begin
          select qtd_pontos
          from cre_credit_score_calculo
          where cod_calculo = 8
          and 1 between param_ini and param_fim
          into iqtd_pontos_fone_cel1;
     end

     if (iind_possui_fone_cel2 > 0) then
     begin
         select qtd_pontos
         from cre_credit_score_calculo
             where cod_calculo = 8
             and 2 between param_ini and param_fim
         into iqtd_pontos_fone_cel2;
     end

     if  (iind_possui_fone_recado > 0) then
     begin
          select qtd_pontos
          from cre_credit_score_calculo
          where cod_calculo = 8
          and 3 between param_ini and param_fim
          into iqtd_pontos_fone_recado;
     end

     iqtd_pontos_tipo_telefone = iqtd_pontos_fone_residencial +
                                 iqtd_pontos_fone_comercial +
                                 iqtd_pontos_fone_cel1 +
                                 iqtd_pontos_fone_cel2 +
                                 iqtd_pontos_fone_recado;

     if (igravar_mvto = 1) then
     begin
          insert into cre_credit_score_mvto (cod_emp,
                                             cod_unidade,
                                             cod_cliente,
                                             dta_mvto,
                                             num_seq,
                                             cod_calculo,
                                             qtd_pontos,
                                             param_entrada)
          values (:ipi_cod_emp,
                  :ipi_cod_unidade,
                  :ipi_cpf_cnpj_cli,
                  current_timestamp ,
                  :inum_seq,
                  8,
                  :iqtd_pontos_tipo_telefone,
                  :itipo_telefone);
     end

     -- Dependentes - ok
     select qtd_pontos
     from cre_credit_score_calculo
     where cod_calculo = 9
     and :ipi_qtd_dependentes between param_ini and param_fim
     into iqtd_pontos_dependentes;

     iqtd_pontos_dependentes = ipi_qtd_dependentes * iqtd_pontos_dependentes;

     if (igravar_mvto = 1) then
     begin
          insert into cre_credit_score_mvto (cod_emp,
                                             cod_unidade,
                                             cod_cliente,
                                             dta_mvto,
                                             num_seq,
                                             cod_calculo,
                                             qtd_pontos,
                                             param_entrada)
          values (:ipi_cod_emp,
                  :ipi_cod_unidade,
                  :ipi_cpf_cnpj_cli,
                  current_timestamp ,
                  :inum_seq,
                  9,
                  :iqtd_pontos_dependentes,
                  :ipi_qtd_dependentes);
     end

     -- Telefone Autorizado - ok
     select qtd_pontos
     from cre_credit_score_calculo
     where cod_calculo = 10
     and :ipi_cod_telefone_autorizado between param_ini and param_fim
     into iqtd_pontos_telef_autorizado;

     if (igravar_mvto = 1) then
     begin
          insert into cre_credit_score_mvto (cod_emp,
                                             cod_unidade,
                                             cod_cliente,
                                             dta_mvto,
                                             num_seq,
                                             cod_calculo,
                                             qtd_pontos,
                                             param_entrada)
          values (:ipi_cod_emp,
                  :ipi_cod_unidade,
                  :ipi_cpf_cnpj_cli,
                  current_timestamp ,
                  :inum_seq,
                  10,
                  :iqtd_pontos_telef_autorizado,
                  :ipi_cod_telefone_autorizado);
     end

     -- Cartao de Credito - ok
     select qtd_pontos
     from cre_credit_score_calculo
     where cod_calculo = 12
     and :ipi_possui_cartao_credito between param_ini and param_fim
     into iqtd_pontos_cartao_credito;

     if (igravar_mvto = 1) then
     begin
          insert into cre_credit_score_mvto (cod_emp,
                                             cod_unidade,
                                             cod_cliente,
                                             dta_mvto,
                                             num_seq,
                                             cod_calculo,
                                             qtd_pontos,
                                             param_entrada)
          values (:ipi_cod_emp,
                  :ipi_cod_unidade,
                  :ipi_cpf_cnpj_cli,
                  current_timestamp ,
                  :inum_seq,
                  12,
                  :iqtd_pontos_cartao_credito,
                  :ipi_possui_cartao_credito);
     end

     -- MDA - ok
     select qtd_pontos
     from cre_credit_score_calculo
     where cod_calculo = 15
     and :imda between param_ini and param_fim
     into iqtd_pontos_mda;

     if (igravar_mvto = 1) then
     begin
          insert into cre_credit_score_mvto (cod_emp,
                                             cod_unidade,
                                             cod_cliente,
                                             dta_mvto,
                                             num_seq,
                                             cod_calculo,
                                             qtd_pontos,
                                             param_entrada)
          values (:ipi_cod_emp,
                  :ipi_cod_unidade,
                  :ipi_cpf_cnpj_cli,
                  current_timestamp ,
                  :inum_seq,
                  15,
                  :iqtd_pontos_mda,
                  :imda);
     end

     -- Outras Rendas - ok
     if (ipi_vlr_outras_rendas > 0) then
     begin
          select qtd_pontos
          from cre_credit_score_calculo
          where cod_calculo = 16
          and :ipi_ind_out_renda_comprov between param_ini and param_fim
          into ipercentual_outras_rendas;

          ivlr_calc_outra_renda = (ipi_vlr_outras_rendas * (ipercentual_outras_rendas/100));
     end
     else
     begin
          ivlr_calc_outra_renda = 1;
     end

     -- Conceito Gerente - ok
     select qtd_pontos
     from cre_credit_score_calculo
     where cod_calculo = 20
     and :ipi_ind_conceito_gerente between param_ini and param_fim
     into iqtd_pontos_conceito_gerente;

     if (iqtd_pontos_conceito_gerente is null) then
     begin
          iqtd_pontos_conceito_gerente = 0;
     end

     if (igravar_mvto = 1) then
     begin
          insert into cre_credit_score_mvto (cod_emp,
                                             cod_unidade,
                                             cod_cliente,
                                             dta_mvto,
                                             num_seq,
                                             cod_calculo,
                                             qtd_pontos,
                                             param_entrada)
          values (:ipi_cod_emp,
                  :ipi_cod_unidade,
                  :ipi_cpf_cnpj_cli,
                  current_timestamp ,
                  :inum_seq,
                  20,
                  :iqtd_pontos_conceito_gerente,
                  :ipi_ind_conceito_gerente);
     end

     -- Perfil - ok
     select qtd_pontos
     from cre_credit_score_calculo
     where cod_calculo = 18
     and :iperfil between param_ini and param_fim
     into iqtd_pontos_perfil;

     if (igravar_mvto = 1) then
     begin
          insert into cre_credit_score_mvto (cod_emp,
                                             cod_unidade,
                                             cod_cliente,
                                             dta_mvto,
                                             num_seq,
                                             cod_calculo,
                                             qtd_pontos,
                                             param_entrada)
          values (:ipi_cod_emp,
                  :ipi_cod_unidade,
                  :ipi_cpf_cnpj_cli,
                  current_timestamp ,
                  :inum_seq,
                  18,
                  :iqtd_pontos_perfil,
                  :iperfil);
     end

     -- Pega o valor da renda presumida
     select ind_profissao_risco
     from ger_profissoes
     where cod_profissao = :ipi_cod_profissao
     into iind_profissao_risco;

     select vlr_renda_presumida
     from ger_profissoes
     where cod_profissao = :ipi_cod_profissao
     into ivlr_renda_presumida;

     if (ipi_tipo_profissao = 1) then -- empregado
     begin
          -- comprovacao renda principal
          if (ipi_ind_renda_comprovada = 1) then -- comprovou
          begin
               ivlr_renda_principal = ipi_vlr_renda_principal;
          end
          else -- nao comprovou
          begin
               if (ipi_vlr_renda_principal <  ivlr_renda_presumida) then
               begin
                    ivlr_renda_principal = ipi_vlr_renda_principal;
               end
               else
               begin
                    ivlr_renda_principal = ivlr_renda_presumida;
               end
          end
     end
     else -- se nao for empregado
     begin
          if (ipi_cod_profissao = 33) then
          begin
               ivlr_renda_principal = ipi_vlr_renda_principal;
          end
          else
          begin
               if (ipi_vlr_renda_principal <  ivlr_renda_presumida)  then
               begin
                    ivlr_renda_principal = ipi_vlr_renda_principal;
               end
               else
               begin
                    ivlr_renda_principal = ivlr_renda_presumida;
               end
          end
     end

     ivlr_renda_liquida = ivlr_renda_principal + ivlr_calc_outra_renda;

     --calcula o aluguel  previsto
     if ((ipi_cod_tipo_residencia = 0) or (ipi_cod_tipo_residencia = 2)) then
     begin
          ivlr_aluguel = (ivlr_renda_liquida * 18) / 100;
     end
     else
     begin
          ivlr_aluguel = 0;
     end

     ivlr_renda_liquida = ivlr_renda_principal + ivlr_calc_outra_renda - ivlr_aluguel;
     iqtd_pontos_geral = iqtd_pontos_idade +
                         iqtd_pontos_estado_civil +
                         iqtd_pontos_profissao +
                         iqtd_pontos_tempo_servico +
                         iqtd_pontos_conceito_endereco +
                         iqtd_pontos_tempo_residencia +
                         iqtd_pontos_tipo_residencia +
                         iqtd_pontos_tipo_telefone +
                         iqtd_pontos_dependentes +
                         iqtd_pontos_telef_autorizado +
                         iqtd_pontos_cartao_credito +
                         iqtd_pontos_mda+
                         iqtd_pontos_perfil+
                         iqtd_pontos_conceito_gerente;

     -- % Do credit score para aplicar sobre a renda liquida - ok
     select qtd_pontos
     from cre_credit_score_calculo
     where cod_calculo = 17
     and :iqtd_pontos_geral between param_ini and param_fim
     into iperc_parametrizacao_cs;

     if (igravar_mvto = 1) then
     begin
          insert into cre_credit_score_mvto (cod_emp,
                                             cod_unidade,
                                             cod_cliente,
                                             dta_mvto,
                                             num_seq,
                                             cod_calculo,
                                             qtd_pontos,
                                             param_entrada)
          values (:ipi_cod_emp,
                  :ipi_cod_unidade,
                  :ipi_cpf_cnpj_cli,
                  current_timestamp ,
                  :inum_seq,
                  17,
                  :iperc_parametrizacao_cs,
                  :iqtd_pontos_geral);
     end

     -- Multiplicador do creditscore por perfil  - ok
     select fator_multiplicador
     from ger_perfil
     where cod_perfil = :iperfil
     into iqtd_prestacoes;
     select valor_multiplicador_cs
     from ger_perfil
     where cod_perfil = :iperfil
     into imultiplicador_limite;

     ilimite = (ivlr_renda_liquida * (iperc_parametrizacao_cs/100) * iqtd_prestacoes);

     if (iind_profissao_risco = 0) then
     begin
          ilimite = ilimite * imultiplicador_limite;
     end
     else
     begin
          ilimite = ilimite;
     end
     po_vlr_creditscore = ilimite;

     if (ilimite < 100) then
     begin
          if (imda <= 5) then
          begin
               select  max(vlr_limite)
               from cre_clientes_cr
               where cod_cliente = :ipi_cpf_cnpj_cli
               into ilimite_cliente;
          end
          else
          begin
               ilimite_cliente = 100;
          end
     end

     if (ilimite_cliente > 0 )then
     begin
          ilimite = ilimite_cliente;
     end

     --arredonda o valor  de 50 em 50 reais
     -- ilimite :=  (50 * (round(round(ilimite  ) / 50)));
     ilimite =  (10 * (round(round(ilimite) / 10)));
     if (ilimite > 3000) then
     begin
          ilimite = 3000;
     end

     po_vlr_limite = ilimite;
     po_qtd_pontos = iqtd_pontos_geral;
     po_perfil = iperfil ;
     po_mda = imda;
     po_iqtd_prestacoes = iqtd_prestacoes;

     suspend;
end ^

set term ; ^
commit work;
set autoddl on;
