create table grz_posicao_bonus
(
 cod_emp              number(4,0),
 dta_movimento        date,
 tip_bonus            number(2,0), -- 0-Loja,1-Aniversário,2-APP Clientes
 pos_validade         number(3,0), -- em dias: 60 para lojas e app clientes e 37 para aniversário
 qtd_bonus_disponivel number(10,0),
 vlr_bonus_disponivel number(18,2),
 dta_utilizados_ate   date,        -- gerada pela soma de pos_validade em dta_movimento
 qtd_bonus_utilizado  number(10,0),
 vlr_bonus_utilizado  number(18,2),
 perc_qtd_utilizado   number(5,2), -- (qtd_bonus_utilizado * 100) / qtd_bonus_disponivel 
 perc_vlr_utilizado   number(5,2), -- (vlr_bonus_utilizado * 100) / vlr_bonus_disponivel
 constraint grz_posicao_bonus_pk primary key (cod_emp,dta_movimento,tip_bonus));
)