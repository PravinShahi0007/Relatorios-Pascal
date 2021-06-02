 /*------------------------------------------------------------------------
  Procedure.: grz_retorna_valor_limite_sp
  Empresa...: Grazziotin S/A
  Finalidade: Retornar valor do limite de credito do cliente, de acordo com 
              regras estabelecidas.

  Autor   Data     Operacao  Descricao
  Antonio MAI/2021 Criacao
  Jaisson MAI/2021 Criacao   SQL basico

  Parametros
  pi_tipo_pessoa: Tipo da pessoa em processamento: 1-Fisica, 2-Juridica.
  pi_codcompleto: Codigo completo do cliente.
  pi_cpf_cnpj: CPF/CNPJ da pessoa (Fisica/Juridica) para procura e 
               verificacao de enquadramento nas regras estabelecidas.
  pi_limite, pi_creditscoring: valores calculados pelo programa de
                               cadastro de clientes que serao verificados
                               de acordo com as regras estabelecidas, 
                               retornando um ou outro valor de limite de
                               credito.
  REGRAS
  Parametrizar no sistema, para quando o Credit Score gerar um valor
  INFERIOR ao limite atual do cliente o sistema nao assuma o valor gerado
  pelo Credit Score e mantenha o limite atual, para clientes dentro dos
  parametros abaixo.
  - Clientes de perfil 10, 20, 30 e 50 ou mais;
  - Atraso atual zero;
  - MDA negativo ou ate 10;
  - Com compras nos ultimos 12 meses;
  - Limitando o valor em R$ 3.000,00.
  Para CPFs que estiverem fora dos parametros acima, o sistema devera
  assumir como limite o valor gerado pelo Credit Score, sendo que para
  clientes antigos que nao atingirem a pontuacao minima para Calculo,
  o sistema devera assumir como limite o valor de R$ 100,00.
------------------------------------------------------------------------*/
create or replace function grz_retorna_valor_limite_sp
       (pi_tipo_pessoa in number, -- 1-Fisica, 2-Juridica
        pi_codcompleto in varchar2,
        pi_cpf_cnpj in number,
        pi_limite in number,
        pi_creditscoring in number)
        return number
is
begin
     declare
            /* Parametros de entrada */
            v_result        integer;
            v_cur           integer;
            v_num_cpf_cnpj  number(18,0);
            v_creditscoring number(18,0); -- Credit Scoring arredondado por 10

            type R_CONF_REGRA_LIMITE is record -- definicao do registro de dados para as REGRAS
                 (cod_regra           number(4,0),
                  ind_perfil          varchar2(50),
                  ind_perfil_juridica number(3,0),
                  num_atraso          number(3,0),
                  num_mda             number(8,0),
                  num_ult_compras     number(3,0),
                  vlr_limite_superior number(18,2),
                  vlr_limite_inferior number(18,2)); 
            CONF_REGRA_LIMITE R_CONF_REGRA_LIMITE;

     begin -- inicio da function
          v_cur := dbms_sql.open_cursor;
          dbms_sql.parse(v_cur,'alter session set nls_date_format= "dd/mm/rrrr"',dbms_sql.native);
          v_result := dbms_sql.execute(v_cur);
          dbms_sql.close_cursor(v_cur);

          v_cur := dbms_sql.open_cursor;
          dbms_sql.parse(v_cur,'alter session set NLS_NUMERIC_CHARACTERS = '',.''',dbms_sql.native);
          v_result := dbms_sql.execute(v_cur);
          dbms_sql.close_cursor(v_cur);

          -- Seleciona as regras definidas para alteracao do limite...
          -- No momento a tabela tera um registro apenas!!!!
          select cod_regra,ind_perfil,
                 ind_perfil_juridica,num_atraso,
                 num_mda,num_ult_compras,
                 vlr_limite_superior,vlr_limite_inferior
          into CONF_REGRA_LIMITE.cod_regra,CONF_REGRA_LIMITE.ind_perfil,
               CONF_REGRA_LIMITE.ind_perfil_juridica,CONF_REGRA_LIMITE.num_atraso,
               CONF_REGRA_LIMITE.num_mda,CONF_REGRA_LIMITE.num_ult_compras,
               CONF_REGRA_LIMITE.vlr_limite_superior,CONF_REGRA_LIMITE.vlr_limite_inferior
          from grz_config_regra_limite
          where (cod_regra = 1);

          -- Arredondamento do Credit Scoring
          v_creditscoring := (10 * (Round(Round(pi_creditscoring) / 10)));

          if (v_creditscoring < CONF_REGRA_LIMITE.vlr_limite_inferior) then
             v_creditscoring := CONF_REGRA_LIMITE.vlr_limite_inferior; -- valor limite inferior
          elsif (v_creditscoring > CONF_REGRA_LIMITE.vlr_limite_superior) then
                v_creditscoring := CONF_REGRA_LIMITE.vlr_limite_superior; -- valor limite superior
          end if;

          if (pi_tipo_pessoa = 1) then -- pessoa fisica
          begin
               select psfis.num_cpf
               into v_num_cpf_cnpj
               from ps_perfis psper, ps_mascaras psmas, ps_pessoas pspes,
                    ps_cartoes pscar, ps_clientes pscli, ps_fisicas psfis
               where psmas.cod_pessoa = psper.cod_pessoa
               and pspes.cod_pessoa = psper.cod_pessoa
               and pscar.cod_pessoa = psper.cod_pessoa
               and pscli.cod_pessoa = psper.cod_pessoa
               and psfis.cod_pessoa = psper.cod_pessoa
               and psper.cod_pessoa is not null
               and psmas.cod_mascara = 50
               and nvl(psper.vlr_pago_mda,0) > 0
               --and psmas.cod_niv1 = to_char(pi_rede) -- rede / unica diferenca e a rede 70
               and psmas.cod_completo = pi_codcompleto
               and psfis.num_cpf = pi_cpf_cnpj -- 03372233000 cpf teste IGOR
               and psper.dta_ult_compra >= to_date(add_months(sysdate,-CONF_REGRA_LIMITE.num_ult_compras)) -- ultima compra maior que 12 meses
               and psper.vlr_pago_ref_mda/psper.vlr_pago_mda <= CONF_REGRA_LIMITE.num_mda -- mda
               and psper.qtd_maior_atraso_atual = CONF_REGRA_LIMITE.num_atraso -- dias de atraso
               and to_char(psper.cod_classificacao_atu) in (CONF_REGRA_LIMITE.ind_perfil); -- < 99 -- perfil
               exception -- nao entrou nas regras...
                        when no_data_found then -- Nao entrou na REGRAS..
                             v_num_cpf_cnpj := 0;
          end;
          else -- pessoa juridica
          begin
               select psjur.num_cgc
               into v_num_cpf_cnpj
               from ps_clientes pscli,
                    ps_mascaras psmas,
                    ps_juridicas psjur,
                    ps_perfis psper
               where pscli.cod_pessoa = psmas.cod_pessoa
               and pscli.cod_pessoa = psjur.cod_pessoa
               and pscli.cod_pessoa = psper.cod_pessoa
               and psper.cod_pessoa is not null
               and psmas.cod_mascara = 50
               and nvl(psper.vlr_pago_mda,0) > 0
               --and psmas.cod_niv1 = to_char(pi_rede) -- rede / unica diferenca e a rede 70
               and psmas.cod_completo = pi_codcompleto
               and psjur.num_cgc = pi_cpf_cnpj
               and psper.dta_ult_compra >= to_date(add_months(sysdate,-CONF_REGRA_LIMITE.num_ult_compras)) -- ultima compra maior que 12 meses
               and psper.vlr_pago_ref_mda/psper.vlr_pago_mda <= CONF_REGRA_LIMITE.num_mda -- mda
               and psper.qtd_maior_atraso_atual = CONF_REGRA_LIMITE.num_atraso -- dias de atraso
               and psper.cod_classificacao_atu >= CONF_REGRA_LIMITE.ind_perfil_juridica;
               exception -- nao entrou nas regras...
                        when no_data_found then -- Nao entrou na REGRAS..
                             v_num_cpf_cnpj := 0;
          end;
          end if; -- end if do (pi_tipo_pessoa = 1)

          -- Nao entrou nas REGRAS...
          if (v_num_cpf_cnpj = 0) or (v_num_cpf_cnpj is NULL) then
             return v_creditscoring;
          else -- entrou nas REGRAS...
              return pi_limite;
          end if;
     end; -- inicio da function
end; -- retorna_valor_limite_func