commit work;
set autoddl off;
set term ^ ;

create or alter procedure rel_credito_dobro_sp
(
 cod_emp        numeric(3,0),
 cod_unidade    numeric(4,0),
 cod_perfil_ini numeric(3,0),
 cod_perfil_fim numeric(3,0),
 selecao        numeric(10,0),
 dta_ini        date,
 dta_fim        date,
 op_rel         numeric(1,0),
 limite         numeric(4,0)
)
returns
(
 cod_cliente      numeric(14,0),
 des_cliente      varchar(50),
 num_cpf_cnpj     numeric(14,0),
 des_fone_resid   varchar(15),
 des_fone_celular varchar(15),
 des_fone_comerc  varchar(15),
 cod_perfil_cli   numeric(3,0),
 vlr_limite       numeric(18,2),
 icomprou         numeric(3,0)
)
as
begin
     for select a.cod_cliente,
                a.des_cliente,
                a.num_cpf_cnpj,
                b.des_fone_resid,
                b.des_fone_celular,
                b.des_fone_comerc,
                c.cod_perfil_cli,
                b.vlr_limite
         from cre_clientes a
              ,cre_clientes_cr b
              ,cre_saldos_cli c
              ,cre_selecao_cli d
         where a.cod_emp=b.cod_emp
         and a.cod_emp = c.cod_emp
         and a.cod_emp = :cod_emp
         and a.cod_unidade = :cod_unidade
         and a.cod_cliente= b.cod_cliente
         and a.cod_cliente = c.cod_cliente
         and d.num_selecao = :selecao
         and a.cod_emp = d.cod_emp
         and a.cod_cliente = d.cod_cliente
         and c.cod_perfil_cli >= :cod_perfil_ini
         and c.cod_perfil_cli <= :cod_perfil_fim
         and b.vlr_limite > :limite
         into cod_cliente,
              des_cliente,
              num_cpf_cnpj,
              des_fone_resid,
              des_fone_celular,
              des_fone_comerc,
              cod_perfil_cli,
              vlr_limite do
     begin
          if (op_rel = 0) then
             suspend;
          else
              if (op_rel = 1) then
              begin
                   icomprou =0;
                   select coalesce(count(1),0)
                   from est_cupons e
                   where e.cod_emp = :cod_emp
                   and e.cod_unidade = :cod_unidade
                   and e.dta_movimento between :dta_ini and :dta_fim
                   and e.cod_cliente = :cod_cliente
                   into icomprou;

                   if (icomprou < 1) then
                      suspend;
              end
              else
                  if (op_rel = 2) then
                  begin
                      icomprou = 0;

                      select coalesce(count(1),0)
                      from est_cupons e
                      where e.cod_emp = :cod_emp
                      and e.cod_unidade = :cod_unidade
                      and e.dta_movimento between :dta_ini and :dta_fim
                      and e.cod_cliente = :cod_cliente
                      into icomprou;

                      if (icomprou > 0) then
                         suspend;
                  end
     end
end ^

set term ; ^
commit work;
set autoddl on;