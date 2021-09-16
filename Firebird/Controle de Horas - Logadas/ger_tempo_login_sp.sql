/*------------------------------------------------------------------------
 Procedure.: ger_tempo_login_sp
 Empresa...: Grazziotin S/A
 Finalidade: Manutencao da tabela GER_TEMPO_LOGIN. Tabela que contem dados
             do controle de horas logadas pelo(s) operador(es) do SISLOG.

 Autor   Data     Operacao  Descricao
 Antonio SET/2021 Criacao
------------------------------------------------------------------------*/
commit work;
set autoddl off;
set term ^ ;

create or alter procedure ger_tempo_login_sp
(
 pcod_emp         numeric(3,0),
 pcod_unidade     numeric(4,0),
 pnum_equipamento numeric(4,0),
 pcod_usuario     numeric(8,0),
 phora_inicial    timestamp,
 poperacao        varchar(10) /* INCLUIR, FECHAR, VERIFICAR */
)
returns
(
 pretorno varchar(10) /* pode ser: OK ou FALHA */
)
as
  declare variable vcod_emp         numeric(3,0);
  declare variable vcod_unidade     numeric(4,0);
  declare variable vnum_equipamento numeric(4,0);
  declare variable vcod_usuario     numeric(8,0);
  declare variable vhora_inicial    timestamp;
  declare variable vhora_final      timestamp;
  declare variable vtempo_login     numeric(15,0); /* em segundos */
  declare variable vtempo_formatado varchar(8);
begin
     pretorno = 'OK';
     if (poperacao = 'INCLUIR') then
     begin
          /* Verifica se tem registro ABERTO */
          select cod_emp,cod_unidade,num_equipamento,
                 cod_usuario,hora_inicial,hora_final,
                 tempo_login,tempo_formatado
          from ger_tempo_login
          where (cod_emp = :pcod_emp)
          and (cod_unidade = :pcod_unidade)
          and (num_equipamento = :pnum_equipamento)
          and (hora_final is null)
          into vcod_emp,vcod_unidade,vnum_equipamento,
               vcod_usuario,vhora_inicial,vhora_final,
               vtempo_login,vtempo_formatado;
          if (vcod_emp is not null) then
             if (vhora_final is null) then /* tem registro aberto */
             begin
                  update ger_tempo_login
                         set hora_final = current_timestamp,
                             tempo_login = datediff(minute from :vhora_inicial to current_timestamp),
                             tempo_formatado = 'XXX:XX:XX'
                         where (cod_emp = :pcod_emp)
                         and (cod_unidade = :pcod_unidade)
                         and (num_equipamento = :pnum_equipamento)
                         and (cod_usuario = :vcod_usuario)
                         and (hora_inicial = :vhora_inicial);
             end
          /* Inclui o registro */
          insert into ger_tempo_login (cod_emp,cod_unidade,num_equipamento,
                                       cod_usuario,hora_inicial)
          values (:pcod_emp,:pcod_unidade,:pnum_equipamento,:pcod_usuario,:phora_inicial);
     end

     if (poperacao = 'FECHAR') then
     begin
          /* Seleciona registro aberto do USUARIO */
          select cod_emp,cod_unidade,num_equipamento,
                 cod_usuario,hora_inicial,hora_final,
                 tempo_login,tempo_formatado
          from ger_tempo_login
          where (cod_emp = :pcod_emp)
          and (cod_unidade = :pcod_unidade)
          and (num_equipamento = :pnum_equipamento)
          and (cod_usuario = :pcod_usuario)
          and (hora_final is null)
          into vcod_emp,vcod_unidade,vnum_equipamento,
               vcod_usuario,vhora_inicial,vhora_final,
               vtempo_login,vtempo_formatado;

          if (vhora_final is null) then /* tem registro aberto para o USUARIO */
          begin
               update ger_tempo_login
                      set hora_final = current_timestamp,
                          tempo_login = datediff(minute from :vhora_inicial to current_timestamp),
                          tempo_formatado = 'XXX:XX:XX'
                      where (cod_emp = :pcod_emp)
                      and (cod_unidade = :pcod_unidade)
                      and (num_equipamento = :pnum_equipamento)
                      and (cod_usuario = :pcod_usuario)
                      and (hora_inicial = :vhora_inicial);
           end
     end

     suspend;
end ^

set term ; ^
commit work;
set autoddl on;
