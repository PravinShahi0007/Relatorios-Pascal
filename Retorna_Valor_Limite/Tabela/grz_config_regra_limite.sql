create table grz_config_regra_limite
(
  cod_regra           number(4,0),
  ind_perfil          varchar2(50),
  ind_perfil_juridica number(3,0),
  num_atraso          number(3,0),
  num_mda             number(8,0),
  num_ult_compras     number(3,0),
  vlr_limite_superior number(18,2),
  vlr_limite_inferior number(18,2),
  constraint pk_grz_config_regra_limite primary key (cod_regra)
)