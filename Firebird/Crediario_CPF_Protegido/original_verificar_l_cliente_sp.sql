commit work;
set autoddl off;
set term ^ ;

create or alter procedure verifica_l_cliente_sp
(
 icod_emp     numeric(3,0),
 icod_unidade numeric(4,0),
 icod_cliente numeric(14,0)
)
returns
(
 ireturn numeric(1,0)
)
as
  declare variable cre_susp   numeric(10,0);
  declare variable contr_susp numeric(10,0);
  declare variable ind_spc    numeric(1,0);
  declare variable saldo      numeric(10,0);
  declare variable spc_cli    numeric(10,0);
begin
     cre_susp = 0;
     select count(1)
     from cre_contas_receber
     where (cod_emp = :icod_emp)
     and (cod_unidade = :icod_unidade)
     and (cod_cliente = :icod_cliente)
     and ((tip_cobranca > 0 and ind_prestacao = 0))
     into cre_susp;

     select ind_spc,cod_bloqueio
     from cre_saldos_cli
     where cod_emp = :icod_emp
     and cod_cliente = :icod_cliente
     into ind_spc,saldo;

     contr_susp = 0;
     if (ind_spc is null) then
        ind_spc = 0;
     if (saldo is null) then
        saldo = 0;
     if ((ind_spc > 0) or (saldo >= 10 )) then
     begin
          contr_susp = 1;
     end
     ireturn = 0;
     if ((cre_susp = 0) or (contr_susp = 0))then
        ireturn = 1;
     suspend;
end ^

set term ; ^
commit work;
set autoddl on;
