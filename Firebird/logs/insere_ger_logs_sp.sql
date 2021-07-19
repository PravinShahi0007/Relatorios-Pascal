commit work;
set autoddl off;
set term ^ ;

create or alter procedure insere_ger_logs_sp
(
 pi_ind_tipo      integer, -- 0-erro do delphi, 1-erro do sql ... pode ter mais...
 pi_des_rotina    varchar(50), -- pode ser o nome do programa (unit) ou o nome de uma procedure
 pi_des_servico   varchar(80),
 pi_des_link      varchar(80),
 pi_des_descricao varchar(100)
)
returns
(
 retorno varchar(10)
)
as
  declare variable dta_data date;
  declare variable hor_hora time;
  declare variable dta_inicial_limpa date;
  declare variable dta_final_limpa date;
begin
     retorno = 'OK';
     -- data e hora do sistema
     dta_data = current_date;
     hor_hora = current_time;
     -- variaveis para a "limpeza" da tabela....
     dta_inicial_limpa = current_date;
     dta_final_limpa = current_date - 180; -- seis meses...
     -- limpa tabela de logs...
     delete from ger_logs
     where dta_data between :dta_inicial_limpa and :dta_final_limpa;

     -- grava registro na tabela de LOG....
     insert into ger_logs(dta_data,hor_hora,ind_tipo,des_rotina,des_servico,des_link,des_descricao)
     values(:dta_data,:hor_hora,:pi_ind_tipo,:pi_des_rotina,:pi_des_servico,:pi_des_link,:pi_des_descricao);

     suspend;
end ^

set term ; ^
commit work;
set autoddl on;