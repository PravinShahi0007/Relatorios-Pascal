create table ger_logs
(
 dta_data      date,
 hor_hora      time,
 ind_tipo      integer, -- 0-erro do delphi, 1-erro do sql ... pode ter mais
 des_rotina    varchar(50), -- pode ser o nome do programa (unit) ou o nome de uma procedure
 des_servico   varchar(80),
 des_link      varchar(80),
 des_descricao varchar(100),
 constraint ger_logs_pk primary key (dta_data,hor_hora)
)