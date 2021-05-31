create table nl.grzw_rel_desc_funcionarios
(
   des_usuario          varchar2(30),
   cod_grupo            number(7,0),
   des_grupo            varchar2(50),
   cod_unidade          number(7,0),
   des_unidade          varchar2(50),
   cod_funcionario      varchar2(15),
   des_funcionario      varchar2(50),
   num_nota             number(6,0),
   cod_serie            varchar2(3),
   dta_emissao          date,
   vlr_produtos         number(18,2),
   vlr_operacao         number(18,2),
   vlr_desconto         number(18,2),
   vlr_acrescimo        number(18,2),
   perc_desconto        number(5,2),
   tip_plano            varchar2(3),
   cod_cliente          varchar2(15),
   des_cliente          varchar2(50),
   des_ponto_referencia varchar2(50),
   des_funcao           varchar2(50),
   des_local_trab       varchar2(50),
   ind_devol            number(1,0),
   hora_venda           varchar2(8)
   des_autorizante      varchar2(100)
)