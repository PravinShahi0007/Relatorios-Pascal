 commit work;
set autoddl off;
set term ^ ;

create or alter procedure rel_cli_negativar_sp
(
 cod_emp     numeric(3,0),
 cod_unidade numeric(4,0),
 dta_neg_ini date,
 dta_neg_fim date
)
returns
(
 wcod_cliente      numeric(14,0),
 wdes_cliente      varchar(40),
 wcnpj_cpf         numeric(14,0),
 wtip_pessoa       numeric(1,0),
 wdta_cadastro     date,
 wcod_unidade      numeric(4,0),
 wcontrato         numeric(11,0),
 wdta_venda        date,
 wnum_parcela      numeric(3,0),
 wdta_vencimento   date,
 wval_prestacao    numeric(15,2),
 wtip_plano_vp     varchar(6),
 wcod_compl        varchar(3),
 wdes_fone         varchar(15),
 wvlr_limite       numeric(15,2),
 wqtd_compras      numeric(5,0),
 wsaldo            numeric(15,2),
 wdta_maior_atraso date,
 wind_spc          numeric(1,0)
)
as
  declare variable retorno numeric(3);
begin
     for select a.cod_cliente,
                a.des_cliente,
                a.num_cpf_cnpj,
                a.tip_pessoa,
                a.dta_cadastro,
                b.cod_unidade,
                b.cod_contrato,
                b.dta_venda,
                b.num_parcela,
                b.dta_vencimento,
                b.vlr_prestacao,
                b.tip_plano_vp,
                b.cod_compl
         from cre_clientes a,
              cre_contas_receber b
         where a.cod_emp = b.cod_emp
         and a.cod_cliente = b.cod_cliente
         and a.cod_unidade = :cod_unidade
         and b.ind_prestacao = 0
         and b.dta_vencimento >= :dta_neg_ini
         and b.dta_vencimento <= :dta_neg_fim
         order by a.des_cliente,b.cod_contrato,b.dta_vencimento,b.num_parcela
         into :wcod_cliente,:wdes_cliente,:wcnpj_cpf,
              :wtip_pessoa,:wdta_cadastro,:wcod_unidade,:wcontrato,
              :wdta_venda,:wnum_parcela,:wdta_vencimento,:wval_prestacao,:wtip_plano_vp,:wcod_compl do
     begin
          select a.des_fone_resid,
                 a.vlr_limite,
                 b.qtd_compras_vp,
                 b.vlr_saldo,
                 b.dta_maior_atraso,
                 b.ind_spc
          from cre_clientes_cr a,
               cre_saldos_cli b
          where a.cod_emp = b.cod_emp
          and a.cod_cliente = b.cod_cliente
          and a.cod_emp = :cod_emp
          and a.cod_cliente = :wcod_cliente
          into :wdes_fone, :wvlr_limite, :wqtd_compras, :wsaldo, :wdta_maior_atraso,:wind_spc;

          if (:wind_spc is null) then wind_spc = 0;
          if (:wind_spc = 0) then
          begin
               suspend;
          end
     end
end ^

set term ; ^
commit work;
set autoddl on;