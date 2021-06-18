--create table nl.grz_kpi_vendas_teste
create table nl.grz_kpi_vendas
(
 dta_movimento      date not null,
 dia                varchar2(2) not null,
 mes                number(4,0),
 ano                number(4,0),
 cod_rede           number(7,0) not null,
 des_rede           varchar2(50) not null,
 cod_unidade        number(7,0) not null,
 cod_regiao         number(7,0) not null,
 des_regiao         varchar2(50) not null,
 des_cidade         varchar2(50) not null,
 des_uf             varchar2(3) not null,
 qtd_negocio        number(12,0),
 vlr_vd             number(18,2),
 ticket_medio       number(18,2),
 vlr_vd_whats       number(18,2),
 perc_whats         number(18,2),
 vlr_demost         number(18,2),
 perc_demost        number(18,2),
 vlr_vd_prazo       number(18,2),
 perc_vd_prazo      number(18,2),
 vlr_acresc         number(18,2),
 perc_acresc        number(18,2),
 vlr_seguro         number(18,2),
 perc_seguro        number(18,2),
 ind_nivel          number(1,0),
 cod_grupo_macro    number,
 des_grupo_macro    varchar2(50),
 qtd_cpp            number(12,0),
 vlr_cpp            number(18,2),
 qtd_vp_elegiveis   number(12,0),
 qtd_vp_seguro      number(12,0),
 perc_conversao     number(18,2),
 qtd_elegiveis_cpp  number(12,0),
 qtd_seguro_cpp     number(12,0),
 perc_conversao_cpp number(18,2) 
)