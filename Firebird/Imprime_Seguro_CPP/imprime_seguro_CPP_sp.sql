commit work;
set autoddl off;
set term ^ ;

create or alter procedure imprime_seguro_cpp_sp
(
 cod_emp     numeric(4,0),
 cod_unidade numeric(5,0),
 dta_atual   date,
 num_cupom   numeric(8,0),
 equipamento numeric(3,0)
)
returns
(
 num_bilhete               varchar(50),
 num_sorte                 varchar(6),
 dta_emissao               date,
 hora_emissao              time,
 nome_cliente              varchar(50),
 cpf_cliente               varchar(14),
 rg_cliente                varchar(14),
 dta_nasc_cli              date,
 endereco_1                varchar(150),
 endereco_2                varchar(150),
 cep_cliente               varchar(14),
 des_fone                  varchar(20),
 dta_vi                    date,
 dta_vf                    date,
 l1                        numeric(15,2),
 l2                        numeric(15,2),
 l3                        numeric(15,2),
 l4                        numeric(15,2),
 vlr_premio                numeric(15,2),
 vlr_liquido               numeric(15,2),
 vlr_iof                   numeric(15,2),
 vlr_represen              numeric(15,2),
 vlr_corretor              numeric(15,5),
 dta_dia_contrato          date,
 dta_emit_seg              date,
 vlr_cancelamento          numeric(15,2),
 dta_cancelamento_seg_parc date,
 cancelamento_maior_q7     varchar(20),
 cancelamento_menor_q7     varchar(20),
 vlr_devolvido_parc        numeric(15,2),
 vlr_abatido_parc          numeric(15,2),
 vlr_representante_parc    numeric(15,2)
)
as
  declare variable iconta                        integer;
  declare variable inum_seq_lcto                 numeric(6,0);
  declare variable icpf_seguro                   numeric(14,0);
  declare variable icontrato                     numeric(10,0);
  declare variable inum_sorte_parc               numeric(7,0);
  declare variable icod_cidade                   numeric(7,0);
  declare variable inum_sorte_dih                numeric(7,0);
  declare variable snum_bilhete_parc             varchar(30);
  declare variable scidade_cli                   varchar(50);
  declare variable sdes_cliente                  varchar(50);
  declare variable sdes_cep                      varchar(20);
  declare variable sdes_fone                     varchar(20);
  declare variable sdes_bairro                   varchar(100);
  declare variable sdes_endereco                 varchar(100);
  declare variable srg_cliente                   varchar(50);
  declare variable ddta_mvto_desp                date;
  declare variable ddta_vi                       date;
  declare variable ddta_vf                       date;
  declare variable ddta_cancelamentoparc         date;
  declare variable ddta_emit_bilhete             date;
  declare variable rvalorseguro                  numeric(15,2);
  declare variable rpremioseguromorteaci         numeric(15,2);
  declare variable rpremioliquido                numeric(15,2);
  declare variable rpremioiof                    numeric(15,2);
  declare variable rdiascancelamento             numeric(5,0);
  declare variable rpremioseguroipta             numeric(15,2);
  declare variable rpremiosegurodi               numeric(15,2);
  declare variable rpremiocorretor               numeric(15,5);
  declare variable rvalorcancelamentoseguro      numeric(15,2);
  declare variable rpremiorepresentante          numeric(15,2);
  declare variable rvalordevolvidoseguroparc     numeric(15,2);
  declare variable rvalorabatidoseguroparc       numeric(15,2);
  declare variable rvalorrepresentanteseguroparc numeric(15,2);
  declare variable rpremioseguroiftta            numeric(15,2);
begin
     select cpf_cnpj,contrato,num_sorte_parc,num_sorte_dih,num_bilhete_parc,
            dta_ini_vigencia,dta_fim_vigencia,vlr_seguro_parc,dta_movimento,
            vlr_canc_parc, dta_cancelamento,vlr_devolvido_parc,vlr_abatido_parc,
            vlr_representante_parc,coalesce(dta_cancelamento - dta_movimento,0) as dif
     from est_mvto_seguro
     where cod_emp = :cod_emp
     and cod_unidade = :cod_unidade
     and num_equipamento = :equipamento
     and num_cupom = :num_cupom
     and id_seguro = 99
     and dta_movimento = :dta_atual
     into icpf_seguro,icontrato,inum_sorte_parc,inum_sorte_dih,snum_bilhete_parc,
          ddta_vi,ddta_vf,rvalorseguro,ddta_emit_bilhete,rvalorcancelamentoseguro,
          ddta_cancelamentoparc,rvalordevolvidoseguroparc,rvalorabatidoseguroparc,
          rvalorrepresentanteseguroparc,rdiascancelamento;

     select substring(des_cliente from 1 for 50),dta_nascto,cod_cidade,des_bairro,des_endereco,num_cep,
            '('||substring(des_fone_celular from 1 for 2)||') '||
                 substring(des_fone_celular from 3 for 50) as celular
     from cre_clientes
     where cod_emp = :cod_emp
     and cod_cliente = :icpf_seguro
     into sdes_cliente,ddta_mvto_desp,icod_cidade,sdes_bairro,sdes_endereco,sdes_cep,sdes_fone;

     select num_rg
     from cre_clientes_cr
     where cod_emp = :cod_emp
     and cod_cliente = :icpf_seguro
     into srg_cliente;

     select substring(des_cidade||' - '||cod_uf from 1 for 50)
     from ger_cidades
     where cod_cidade = :icod_cidade
     into scidade_cli;

     if (rdiascancelamento > 7 ) then
     begin
          cancelamento_maior_q7 = '( X )';
          cancelamento_menor_q7 = '(   )';
     end
     else
     begin
          cancelamento_maior_q7 = '(   )';
          cancelamento_menor_q7 = '( X )';
     end

     rpremioliquido            = cast((rvalorseguro /1.0038) as numeric(15,2));
     rpremioiof                = cast((rvalorseguro - rpremioliquido) as numeric(15,2));
     rpremioseguromorteaci     = cast(rpremioliquido * (1.3581/7.50) as numeric(15,2));
     rpremioseguroipta         = cast(rpremioliquido * (0.0709/7.50) as numeric(15,2));
     rpremiosegurodi           = cast(rpremioliquido * (3.6426/7.50) as numeric(15,2));
     rpremioseguroiftta        = cast(rpremioliquido * (2.4284/7.50) as numeric(15,2));
     rpremiocorretor           = cast(cast((rpremioliquido * 0.0001) as numeric(15,4)) as numeric(15,3));
     rpremiorepresentante      = cast((rpremioliquido * 0.5035) as numeric(15,3));
     num_bilhete               = snum_bilhete_parc;
     num_sorte                 = lpad (inum_sorte_parc, 5, '0') ;
     dta_emissao               = current_date;
     hora_emissao              = current_time;
     nome_cliente              = sdes_cliente;
     cpf_cliente               = icpf_seguro;
     rg_cliente                = srg_cliente;
     dta_nasc_cli              = ddta_mvto_desp;
     endereco_1                = sdes_bairro||' - '||sdes_endereco;
     endereco_2                = scidade_cli;
     cep_cliente               = sdes_cep;
     des_fone                  = sdes_fone;
     dta_vi                    = ddta_vi;
     dta_vf                    = ddta_vf;
     l1                        = rpremioseguromorteaci;
     l2                        = rpremioseguroipta;
     l3                        = rpremiosegurodi;
     l4                        = rpremioseguroiftta;
     vlr_premio                = rvalorseguro;
     vlr_liquido               = rpremioliquido;
     vlr_iof                   = rpremioiof;
     vlr_corretor              = rpremiocorretor;
     vlr_represen              = rpremiorepresentante;
     dta_dia_contrato          = dta_atual;
     dta_emit_seg              = ddta_emit_bilhete;
     vlr_cancelamento          = rvalorcancelamentoseguro;
     dta_cancelamento_seg_parc = ddta_cancelamentoparc;
     vlr_devolvido_parc        = rvalordevolvidoseguroparc;
     vlr_abatido_parc          = rvalorabatidoseguroparc;
     vlr_representante_parc    = rvalorrepresentanteseguroparc;

     suspend;
end ^

set term ; ^
commit work;
set autoddl on;
