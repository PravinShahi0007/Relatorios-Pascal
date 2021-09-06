commit work;
set autoddl off;
set term ^ ;

create or alter procedure rel_aniversariantes_sp
(
 cod_emp        numeric(3,0),
 cod_unidade    numeric(4,0),
 mes            numeric(2,0),
 dia_ini        numeric(2,0),
 dia_fim        numeric(2,0),
 situ           numeric(1,0),
 dta_compra_ini date,
 dta_compra_fim date,
 perfil_ini     numeric(2,0),
 perfil_fim     numeric(2,0),
 tip_cli        numeric(1,0)
)
returns
(
 cod_cliente       numeric(14,0),
 des_cliente       varchar(60),
 des_endereco      varchar(60),
 des_bairro        varchar(60),
 des_cidade        varchar(60),
 des_telefone      varchar(20),
 des_fone_celular  varchar(20),
 des_fone_celular2 varchar(20),
 des_fone_comerc   varchar(20),
 des_obs           varchar(100),
 des_sexo          varchar(15),
 des_profissao     varchar(40),
 dta_compra        date,
 cod_perfil        numeric(4,0),
 dta_nascto        date,
 dia_nascto        numeric(4,0),
 idade             numeric(5,0),
 tip_des_cliente   varchar(3),
 tip_pessoa        numeric(1,0),
 cpf_escondido     varchar(20)
)
as
  declare variable cod_cidade    numeric(10,0);
  declare variable sexo          numeric(1,0);
  declare variable cod_profissao numeric(4,0);
  declare variable retorno       numeric(1,0);
  declare variable tip_cliente   numeric(1,0);
  declare variable mes_nascto    numeric(2,0);
  declare variable ano_nascto    numeric(4,0);
  declare variable dia_atual     numeric(2,0);
  declare variable mes_atual     numeric(2,0);
  declare variable ano_atual     numeric(4,0);
begin
     for select cod_cliente
                ,des_cliente
                ,tip_sexo
                ,des_endereco
                ,des_bairro
                ,cod_cidade
                ,dta_nascto
                ,cod_profissao
                ,des_telefone
                ,des_fone_celular
                ,tip_cliente
                ,tip_pessoa,
                case when tip_pessoa = 1 then
                          substring((lpad(num_cpf_cnpj,11,'0')) from 1 for 3)||'.***.***-'||
                          substring((lpad(num_cpf_cnpj,11,'0')) from 10 for 11)
                     when tip_pessoa = 2 then
                          substring((lpad(num_cpf_cnpj,14,'0')) from 1 for 2)||
                          '.***.***/****-'||
                          substring((lpad(num_cpf_cnpj,14,'0')) from 13 for 14)
                     else
                         num_cpf_cnpj
                end as cpf_escondido
         from cre_clientes
         where cod_emp = :cod_emp
         and cod_unidade = :cod_unidade
         and (extract(month from dta_nascto) = :mes)
         and (extract(day from dta_nascto) between :dia_ini and :dia_fim)
         and not (lpad(coalesce(des_telefone,'0'),15,'0') <= '000000000000000'
         and lpad(coalesce(des_fone_celular,'0'),15,'0') <= '000000000000000')
         order by extract(day from dta_nascto)
                  ,des_cliente
        into cod_cliente,des_cliente,sexo,des_endereco,des_bairro,cod_cidade
             ,dta_nascto,cod_profissao,des_telefone,des_fone_celular,tip_cliente,
             tip_pessoa,cpf_escondido
     do
     begin
          select des_cidade
          from ger_cidades
          where cod_cidade = :cod_cidade
          into des_cidade;

          select des_profissao
          from ger_profissoes
          where cod_profissao = :cod_profissao
          into des_profissao;

          des_fone_celular2 = '';
          des_fone_comerc = '';
          cod_perfil = 0;
          dta_compra = null;
          des_obs = null;

          if (tip_cliente = 1) then
          begin
               tip_des_cliente = 'VV';
          end
          else
              if (tip_cliente = 2) then
              begin
                   tip_des_cliente = 'VP';
                   select des_fone_celular2
                          ,des_fone_comerc
                   from cre_clientes_cr
                   where cod_emp = :cod_emp
                   and cod_cliente = :cod_cliente
                   into des_fone_celular2
                        ,des_fone_comerc;

                   select des_comentario
                   from cre_comentarios_cli
                   where cod_emp = :cod_emp
                   and cod_cliente = :cod_cliente
                   and num_seq = 10
                   into des_obs;

                   select cod_perfil_cli,
                         case when coalesce(dta_ult_compra_vv,'0') > coalesce(dta_ult_compra_vp,'0') then
                                   dta_ult_compra_vv
                              else
                                  dta_ult_compra_vp
                         end as dta_compra
                   from cre_saldos_cli
                   where cod_emp = :cod_emp
                   and cod_cliente = :cod_cliente
                   and (dta_ult_compra_vv between :dta_compra_ini and :dta_compra_fim
                        or dta_ult_compra_vp between :dta_compra_ini and :dta_compra_fim)
                   into cod_perfil,dta_compra;

                  if (cod_perfil is null) then
                     cod_perfil = 0;
              end

          dia_atual = extract(day from current_date);
          mes_atual = extract(month from current_date);
          ano_atual = extract(year from current_date);
          dia_nascto = extract(day from dta_nascto);
          mes_nascto = extract(month from dta_nascto);
          ano_nascto = extract(year from dta_nascto);
          idade = ano_atual - ano_nascto;
          if ((mes_atual < mes_nascto) or ((mes_atual = mes_nascto) and (dia_atual < dia_nascto))) then
          begin
               idade = idade - 1;
          end
          if (((dta_compra is null) and (tip_cliente = 1)) or (dta_compra is not null)) then
          begin
               if (sexo = 1) then
                  des_sexo = 'M';
               else
                   if (sexo = 2) then
                      des_sexo = 'F';
               if ((cod_perfil >= perfil_ini) and (cod_perfil <= perfil_fim)) then
               begin
                    retorno = 0;
                    execute procedure verifica_l_cliente_sp :cod_emp,:cod_unidade,cod_cliente returning_values :retorno;
                    if (retorno > 0) then
                    begin
                         if (tip_cli = 0) then
                         begin
                              if (situ = 0) then
                              begin
                                   suspend;
                              end
                              if (situ = 1) then
                              begin
                                   if (sexo = 1) then
                                   begin
                                        suspend;
                                   end
                              end
                              if (situ = 2) then
                              begin
                                   if (sexo = 2) then
                                   begin
                                        suspend;
                                   end
                              end
                         end
                         if (tip_cli = 1) then
                         begin
                              if (tip_cliente = 1) then
                              begin
                                   if (situ = 0) then
                                   begin
                                        suspend;
                                   end
                                   if (situ = 1) then
                                   begin
                                        if (sexo = 1) then
                                        begin
                                             suspend;
                                        end
                                   end
                                   if (situ = 2) then
                                   begin
                                        if (sexo = 2) then
                                        begin
                                             suspend;
                                        end
                                   end
                              end
                         end
                         if (tip_cli = 2) then
                         begin
                              if (tip_cliente = 2) then
                              begin
                                   if (situ = 0) then
                                   begin
                                        suspend;
                                   end
                                   if (situ = 1) then
                                   begin
                                        if (sexo = 1) then
                                        begin
                                             suspend;
                                        end
                                   end
                                   if (situ = 2) then
                                   begin
                                        if (sexo = 2) then
                                        begin
                                             suspend;
                                        end
                                   end
                              end
                         end
                    end
               end
          end
     end
end ^

set term ; ^
commit work;
set autoddl on;