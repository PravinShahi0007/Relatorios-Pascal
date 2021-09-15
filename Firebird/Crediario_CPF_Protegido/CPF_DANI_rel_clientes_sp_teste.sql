commit work;
set autoddl off;
set term ^ ;

create or alter procedure rel_clientes_sp_teste
(
 icod_emp         numeric(3,0),
 idt_cadastro_ini date,
 idt_cadastro_fim date,
 idt_altera_ini   date,
 idt_altera_fim   date,
 iflag            numeric(1,0),
 iorder           numeric(1,0),
 icod_uni_cli     numeric(3,0)
)
returns
(
 icod_cliente       numeric(14,0),
 ides_endereco      varchar(50),
 ides_bairro        varchar(20),
 ides_cidade        varchar(50),
 ivlr_limite        numeric(15,2),
 ides_fone_resid    varchar(15),
 ides_fone_celular  varchar(15),
 ides_fone_celular2 varchar(15),
 ides_fone_comerc   varchar(15),
 ind_spc            varchar(5),
 ivlr_renda         numeric(15,2),
 statuscliente      varchar(15),
 dta_cadastro       date,
 dta_alteracao      date,
 icod_unidade       numeric(4,0),
 ides_cliente       varchar(40),
 ivalor_pri_compra  numeric(18,2),
 dta_pri_compra     date,
 cod_pes_aprov_cad  numeric(10,0),
 cod_pes_digit_cad  numeric(10,0),
 icpf_escondido     varchar(14)
)
as
  declare variable iind_spc numeric(1);
  declare variable icod_cidade numeric(4);
begin
     if (iflag = 1) then /* cadastro */
     begin
          /* ambos,cadastrado,alterado,novos */
          if (iorder > 1) then /* nome */
          begin
               statuscliente = 'CADASTRADO';
               for select cre_clientes.cod_cliente,
                          cre_clientes.des_cliente,
                          cre_clientes.des_endereco,
                          cre_clientes.des_bairro,
                          cre_clientes.cod_cidade,
                          cre_clientes.des_telefone,
                          cre_clientes.des_fone_celular,
                          cre_clientes_cr.des_fone_celular2,
                          cre_clientes_cr.des_fone_comerc,
                          cre_clientes.dta_cadastro,
                          cre_clientes.dta_alteracao,
                          cre_clientes.cod_unidade,
                          cre_clientes_cr.vlr_limite,
                          cre_clientes_cr.vlr_renda,
                          cre_clientes_cr.cod_pes_aprov_cad,
                          cre_clientes_cr.cod_pes_digit_cad,
                          case
                              when tip_pessoa = 1 then
                                   ''||substring((lpad(cre_clientes.cod_cliente,11,'0')) from 1 for 5)||'******'
                              when tip_pessoa = 2 then
                                   '***********'||substring((lpad(cre_clientes.cod_cliente,14,'0')) from 13 for 14)||''
                              else
                                  cre_clientes.cod_cliente
                          end as icpf_escondido
                   from cre_clientes
                        ,cre_clientes_cr
                   where cre_clientes.cod_emp = cre_clientes_cr.cod_emp and
                         cre_clientes.cod_cliente = cre_clientes_cr.cod_cliente and
                         cre_clientes.cod_emp = :icod_emp and
                         cre_clientes.tip_cliente = 2 and
                         cre_clientes.dta_cadastro >= :idt_cadastro_ini and
                         cre_clientes.dta_cadastro <= :idt_cadastro_fim
                   order by cre_clientes.dta_cadastro,cre_clientes.des_cliente
                   into :icod_cliente,:ides_cliente,:ides_endereco,:ides_bairro,
                        :icod_cidade,:ides_fone_resid,:ides_fone_celular,:ides_fone_celular2,
                        :ides_fone_comerc,:dta_cadastro,:dta_alteracao,:icod_unidade,
                        :ivlr_limite,:ivlr_renda,:cod_pes_aprov_cad,:cod_pes_digit_cad,:icpf_escondido do
               begin
                    if ((icod_uni_cli = 999) or (icod_uni_cli = icod_unidade)) then
                    begin
                         select ind_spc
                         from cre_saldos_cli
                         where cod_emp = :icod_emp and
                               cod_cliente = :icod_cliente
                         into :iind_spc;

                         if (iind_spc = 1) then
                         begin
                              ind_spc = 'SIM';
                         end
                         else
                         begin
                              ind_spc = 'NAO';
                         end

                         select des_cidade
                         from ger_cidades
                         where cod_cidade = :icod_cidade
                         into ides_cidade;

                         if (ides_endereco is null) then ides_endereco = ' ';
                         if (ides_bairro is null) then ides_bairro = ' ';
                         if (ides_cidade is null) then ides_cidade = ' ';
                         if (ivlr_limite is null) then ivlr_limite = 0;
                         if (ides_fone_resid is null) then ides_fone_resid = ' ';
                         if (ivlr_renda is null) then ivlr_renda = 0;

                         suspend;
                    end
               end
          end
          else
          begin
               statuscliente = 'CADASTRADO';
               for select cre_clientes.cod_cliente,
                          cre_clientes.des_cliente,
                          cre_clientes.des_endereco,
                          cre_clientes.des_bairro,
                          cre_clientes.cod_cidade,
                          cre_clientes.des_telefone,
                          cre_clientes.des_fone_celular,
                          cre_clientes_cr.des_fone_celular2,
                          cre_clientes_cr.des_fone_comerc,
                          cre_clientes.dta_cadastro,
                          cre_clientes.dta_alteracao,
                          cre_clientes.cod_unidade,
                          cre_clientes_cr.vlr_limite,
                          cre_clientes_cr.vlr_renda,
                          cre_clientes_cr.cod_pes_aprov_cad,
                          cre_clientes_cr.cod_pes_digit_cad,
                          case
                              when tip_pessoa = 1 then
                                   ''||substring((lpad(cre_clientes.cod_cliente,11,'0')) from 1 for 5)||'******'
                              when tip_pessoa = 2 then
                                   '***********'||substring((lpad(cre_clientes.cod_cliente,14,'0')) from 13 for 14)||''
                              else
                                  cre_clientes.cod_cliente
                          end as icpf_escondido
                   from cre_clientes
                        ,cre_clientes_cr
                   where cre_clientes.cod_emp = cre_clientes_cr.cod_emp and
                         cre_clientes.cod_cliente = cre_clientes_cr.cod_cliente and
                         cre_clientes.cod_emp = :icod_emp and
                         cre_clientes.tip_cliente = 2 and
                         cre_clientes.dta_cadastro >= :idt_cadastro_ini and
                         cre_clientes.dta_cadastro <= :idt_cadastro_fim
                   order by cre_clientes.dta_cadastro,cre_clientes.cod_cliente
                   into :icod_cliente,:ides_cliente,:ides_endereco,:ides_bairro,
                        :icod_cidade,:ides_fone_resid,:ides_fone_celular,:ides_fone_celular2,
                        :ides_fone_comerc,:dta_cadastro,:dta_alteracao,:icod_unidade,
                        :ivlr_limite,:ivlr_renda,:cod_pes_aprov_cad,:cod_pes_digit_cad,:icpf_escondido do
               begin
                    if ((icod_uni_cli = 999) or (icod_uni_cli = icod_unidade)) then
                    begin
                         select ind_spc
                         from cre_saldos_cli
                         where cod_emp=:icod_emp
                         and cod_cliente =:icod_cliente
                         into :iind_spc;

                         if (iind_spc = 1) then
                         begin
                              ind_spc = 'SIM';
                         end
                         else
                         begin
                              ind_spc = 'NAO';
                         end

                         select des_cidade
                         from ger_cidades
                         where cod_cidade = :icod_cidade
                         into ides_cidade;

                         if (ides_endereco is null) then ides_endereco = ' ';
                         if (ides_bairro is null) then ides_bairro = ' ';
                         if (ides_cidade is null) then ides_cidade = ' ';
                         if (ivlr_limite is null) then ivlr_limite = 0;
                         if (ides_fone_resid is null)then ides_fone_resid = ' ';
                         if (ivlr_renda is null) then ivlr_renda = 0;

                         suspend;
                    end
               end
          end
     end /* if (iflag = 1) then */

     if (iflag = 2) then /* alteracao */
     begin
          /* ambos,cadastrado,alterado,novos */
          if (iorder > 1) then
          begin
               statuscliente = 'ALTERADO';
               for select cre_clientes.cod_cliente,
                          cre_clientes.des_cliente,
                          cre_clientes.des_endereco,
                          cre_clientes.des_bairro,
                          cre_clientes.cod_cidade,
                          cre_clientes.des_telefone,
                          cre_clientes.des_fone_celular,
                          cre_clientes_cr.des_fone_celular2,
                          cre_clientes_cr.des_fone_comerc,
                          cre_clientes.dta_cadastro,
                          cre_clientes.dta_alteracao,
                          cre_clientes.cod_unidade,
                          cre_clientes_cr.vlr_limite,
                          cre_clientes_cr.vlr_renda,
                          cre_clientes_cr.cod_pes_aprov_cad,
                          cre_clientes_cr.cod_pes_digit_cad,
                          case
                              when tip_pessoa = 1 then
                                   ''||substring((lpad(cre_clientes.cod_cliente,11,'0')) from 1 for 5)||'******'
                              when tip_pessoa = 2 then
                                   '***********'||substring((lpad(cre_clientes.cod_cliente,14,'0')) from 13 for 14)||''
                              else
                                  cre_clientes.cod_cliente
                          end as icpf_escondido
                          from cre_clientes
                               ,cre_clientes_cr
                          where cre_clientes.cod_emp = cre_clientes_cr.cod_emp and
                                cre_clientes.cod_cliente = cre_clientes_cr.cod_cliente and
                                cre_clientes.cod_emp = :icod_emp and
                                cre_clientes.tip_cliente = 2 and
                                cre_clientes.dta_alteracao >= :idt_altera_ini and
                                cre_clientes.dta_alteracao <= :idt_altera_fim
                          order by cre_clientes.dta_alteracao,cre_clientes.des_cliente
                          into :icod_cliente,:ides_cliente,:ides_endereco,:ides_bairro,
                               :icod_cidade,:ides_fone_resid,:ides_fone_celular,
                               :ides_fone_celular2,:ides_fone_comerc,:dta_cadastro,
                               :dta_alteracao,:icod_unidade,:ivlr_limite,:ivlr_renda,
                               :cod_pes_aprov_cad,:cod_pes_digit_cad,:icpf_escondido do
               begin
                    if ((icod_uni_cli = 999) or (icod_uni_cli = icod_unidade)) then
                    begin
                         select ind_spc
                         from cre_saldos_cli
                         where cod_emp = :icod_emp
                         and cod_cliente = :icod_cliente
                         into :iind_spc;

                         if (iind_spc = 1) then
                         begin
                              ind_spc = 'SIM';
                         end
                         else
                         begin
                              ind_spc = 'NAO';
                         end

                         select des_cidade
                         from ger_cidades
                         where cod_cidade = :icod_cidade
                         into ides_cidade;

                         if (ides_endereco is null) then ides_endereco = ' ';
                         if (ides_bairro is null) then ides_bairro = ' ';
                         if (ides_cidade is null) then ides_cidade = ' ';
                         if (ivlr_limite is null) then ivlr_limite = 0;
                         if (ides_fone_resid is null) then ides_fone_resid = ' ';
                         if (ivlr_renda is null) then ivlr_renda = 0;

                         suspend;
                    end
               end
          end
          else
          begin
               statuscliente = 'ALTERADO';
               for select cre_clientes.cod_cliente,
                          cre_clientes.des_cliente,
                          cre_clientes.des_endereco,
                          cre_clientes.des_bairro,
                          cre_clientes.cod_cidade,
                          cre_clientes.des_telefone,
                          cre_clientes.des_fone_celular,
                          cre_clientes_cr.des_fone_celular2,
                          cre_clientes_cr.des_fone_comerc,
                          cre_clientes.dta_cadastro,
                          cre_clientes.dta_alteracao,
                          cre_clientes.cod_unidade,
                          cre_clientes_cr.vlr_limite,
                          cre_clientes_cr.vlr_renda,
                          cre_clientes_cr.cod_pes_aprov_cad,
                          cre_clientes_cr.cod_pes_digit_cad,
                          case
                              when tip_pessoa = 1 then
                                   ''||substring((lpad(cre_clientes.cod_cliente,11,'0')) from 1 for 5)||'******'
                              when tip_pessoa = 2 then
                                   '***********'||substring((lpad(cre_clientes.cod_cliente,14,'0')) from 13 for 14)||''
                              else
                                  cre_clientes.cod_cliente
                          end as icpf_escondido
                   from cre_clientes
                        ,cre_clientes_cr
                   where cre_clientes.cod_emp = cre_clientes_cr.cod_emp and
                         cre_clientes.cod_cliente = cre_clientes_cr.cod_cliente and
                         cre_clientes.cod_emp =:icod_emp and
                         cre_clientes.tip_cliente = 2 and
                         cre_clientes.dta_alteracao >=:idt_altera_ini and
                         cre_clientes.dta_alteracao <=:idt_altera_fim
                   order by cre_clientes.dta_alteracao,cre_clientes.cod_cliente
                   into :icod_cliente,:ides_cliente,:ides_endereco,:ides_bairro,
                        :icod_cidade,:ides_fone_resid,:ides_fone_celular,:ides_fone_celular2,
                        :ides_fone_comerc,:dta_cadastro,:dta_alteracao,:icod_unidade,
                        :ivlr_limite,:ivlr_renda,:cod_pes_aprov_cad,:cod_pes_digit_cad,:icpf_escondido do
               begin
                    if ((icod_uni_cli = 999) or (icod_uni_cli = icod_unidade)) then
                    begin
                         select ind_spc
                         from cre_saldos_cli
                         where cod_emp=:icod_emp
                         and cod_cliente =:icod_cliente
                         into :iind_spc;

                         if (iind_spc = 1) then
                         begin
                              ind_spc = 'SIM';
                         end
                         else
                         begin
                              ind_spc = 'NAO';
                         end

                         select des_cidade
                         from ger_cidades
                         where cod_cidade = :icod_cidade
                         into ides_cidade;

                         if (ides_endereco is null) then ides_endereco = ' ';
                         if (ides_bairro is null) then ides_bairro = ' ';
                         if (ides_cidade is null) then ides_cidade = ' ';
                         if (ivlr_limite is null) then ivlr_limite = 0;
                         if (ides_fone_resid is null) then ides_fone_resid = ' ';
                         if (ivlr_renda is null) then ivlr_renda = 0;

                         suspend;
                    end
               end
          end
     end /* if (iflag = 2) then */

     if (iflag = 3) then /* novos */
     begin
          /* ambos,cadastrado,alterado,novos */
          if (iorder > 1) then
          begin
               statuscliente = 'NOVO';
               for select cre_clientes.cod_cliente,
                          cre_clientes.des_cliente,
                          cre_clientes.des_endereco,
                          cre_clientes.des_bairro,
                          cre_clientes.cod_cidade,
                          cre_clientes.des_telefone,
                          cre_clientes.des_fone_celular,
                          cre_clientes_cr.des_fone_celular2,
                          cre_clientes_cr.des_fone_comerc,
                          cre_clientes.dta_cadastro,
                          cre_clientes.dta_alteracao,
                          cre_clientes.cod_unidade,
                          cre_clientes_cr.vlr_limite,
                          cre_clientes_cr.vlr_renda,
                          cre_saldos_cli.dta_pri_compra_vp,
                          cre_clientes_cr.cod_pes_aprov_cad,
                          cre_clientes_cr.cod_pes_digit_cad,
                          case
                              when tip_pessoa = 1 then
                                   ''||substring((lpad(cre_clientes.cod_cliente,11,'0')) from 1 for 5)||'******'
                              when tip_pessoa = 2 then 
                                   '***********'||substring((lpad(cre_clientes.cod_cliente,14,'0')) from 13 for 14)||''
                              else
                                  cre_clientes.cod_cliente
                          end as icpf_escondido
                   from cre_clientes
                        ,cre_clientes_cr
                        ,cre_saldos_cli
                   where cre_clientes.cod_emp = cre_clientes_cr.cod_emp and
                         cre_clientes.cod_emp = cre_saldos_cli.cod_emp and
                         cre_clientes.cod_cliente = cre_clientes_cr.cod_cliente and
                         cre_clientes.cod_cliente = cre_saldos_cli.cod_cliente and
                         cre_clientes.cod_emp = :icod_emp and
                         cre_clientes.tip_cliente = 2 and
                         cre_saldos_cli.dta_pri_compra_vp >=:idt_altera_ini and
                         cre_saldos_cli.dta_pri_compra_vp <=:idt_altera_fim
                   order by cre_saldos_cli.dta_pri_compra_vp,cre_clientes.des_cliente
                   into :icod_cliente,:ides_cliente,:ides_endereco,:ides_bairro,
                        :icod_cidade,:ides_fone_resid,:ides_fone_celular,:ides_fone_celular2,
                        :ides_fone_comerc,:dta_cadastro,:dta_alteracao,:icod_unidade,
                        :ivlr_limite,:ivlr_renda,:dta_pri_compra,:cod_pes_aprov_cad,
                        :cod_pes_digit_cad,:icpf_escondido do
               begin
                    if ((icod_uni_cli = 999) or (icod_uni_cli = icod_unidade)) then
                    begin
                         for select sum(vlr_total)
                             from est_cupons
                             where cod_emp = :icod_emp
                             and cod_unidade = :icod_unidade
                             and cod_cliente = :icod_cliente
                             and dta_movimento = :dta_pri_compra
                             and tip_venda = 2
                             into ivalor_pri_compra do
                         begin
                              select ind_spc
                              from cre_saldos_cli
                              where cod_emp=:icod_emp
                              and cod_cliente =:icod_cliente
                              into :iind_spc;

                              if (iind_spc = 1) then
                              begin
                                   ind_spc = 'SIM';
                              end
                              else
                              begin
                                   ind_spc = 'NAO';
                              end

                              select des_cidade
                              from ger_cidades
                              where cod_cidade = :icod_cidade
                              into ides_cidade;

                              if (ides_endereco is null) then ides_endereco = ' ';
                              if (ides_bairro is null) then ides_bairro = ' ';
                              if (ides_cidade is null) then ides_cidade = ' ';
                              if (ivlr_limite is null) then ivlr_limite = 0;
                              if (ides_fone_resid is null) then ides_fone_resid = ' ';
                              if (ivlr_renda is null) then ivlr_renda = 0;

                              suspend;
                         end
                    end
               end
          end
          else
          begin
               statuscliente = 'NOVO';
               for select cre_clientes.cod_cliente,
                          cre_clientes.des_cliente,
                          cre_clientes.des_endereco,
                          cre_clientes.des_bairro,
                          cre_clientes.cod_cidade,
                          cre_clientes.des_telefone,
                          cre_clientes.des_fone_celular,
                          cre_clientes_cr.des_fone_celular2,
                          cre_clientes_cr.des_fone_comerc,
                          cre_clientes.dta_cadastro,
                          cre_clientes.dta_alteracao,
                          cre_clientes.cod_unidade,
                          cre_clientes_cr.vlr_limite,
                          cre_clientes_cr.vlr_renda,
                          cre_saldos_cli.dta_pri_compra_vp,
                          cre_clientes_cr.cod_pes_aprov_cad,
                          cre_clientes_cr.cod_pes_digit_cad,
                          case
                              when tip_pessoa = 1 then
                                   ''||substring((lpad(cre_clientes.cod_cliente,11,'0')) from 1 for 5)||'******'
                              when tip_pessoa = 2 then 
                                   '***********'||substring((lpad(cre_clientes.cod_cliente,14,'0')) from 13 for 14)||''
                              else
                                  cre_clientes.cod_cliente
                          end as icpf_escondido
                   from cre_clientes
                        ,cre_clientes_cr
                        ,cre_saldos_cli
                   where cre_clientes.cod_emp = cre_clientes_cr.cod_emp
                   and cre_clientes.cod_emp = cre_saldos_cli.cod_emp
                   and cre_clientes.cod_cliente = cre_clientes_cr.cod_cliente
                   and cre_clientes.cod_cliente = cre_saldos_cli.cod_cliente
                   and cre_clientes.cod_emp = :icod_emp
                   and cre_clientes.tip_cliente = 2
                   and cre_saldos_cli.dta_pri_compra_vp >=:idt_altera_ini
                   and cre_saldos_cli.dta_pri_compra_vp <=:idt_altera_fim
                   order by cre_saldos_cli.dta_pri_compra_vp,cre_clientes.cod_cliente
                   into :icod_cliente,:ides_cliente,:ides_endereco,:ides_bairro,
                        :icod_cidade,:ides_fone_resid,:ides_fone_celular,:ides_fone_celular2,
                        :ides_fone_comerc,:dta_cadastro,:dta_alteracao,:icod_unidade,
                        :ivlr_limite,:ivlr_renda,:dta_pri_compra,:cod_pes_aprov_cad,
                        :cod_pes_digit_cad, :icpf_escondido do
               begin
                    if ((icod_uni_cli = 999) or (icod_uni_cli = icod_unidade)) then
                    begin
                         for select sum(vlr_total)
                             from est_cupons
                             where cod_emp = :icod_emp
                             and cod_unidade = :icod_unidade
                             and cod_cliente = :icod_cliente
                             and dta_movimento = :dta_pri_compra
                             and tip_venda = 2
                             into ivalor_pri_compra do
                         begin
                              select ind_spc
                              from cre_saldos_cli
                              where cod_emp=:icod_emp
                              and cod_cliente =:icod_cliente
                              into :iind_spc;

                              if (iind_spc = 1) then
                              begin
                                   ind_spc = 'SIM';
                              end
                              else
                              begin
                                   ind_spc = 'NAO';
                              end

                              select des_cidade
                              from ger_cidades
                              where cod_cidade = :icod_cidade
                              into ides_cidade;

                              if (ides_endereco is null) then ides_endereco = ' ';
                              if (ides_bairro is null) then ides_bairro = ' ';
                              if (ides_cidade is null) then ides_cidade = ' ';
                              if (ivlr_limite is null) then ivlr_limite = 0;
                              if (ides_fone_resid is null) then ides_fone_resid = ' ';
                              if (ivlr_renda is null) then ivlr_renda = 0;

                              suspend;
                         end
                    end
               end
          end
     end /* if (iflag = 3) then */

     if (iflag = 4) then /* ambos*/
     begin
          /* ambos,cadastrado,alterado,novos */
          if (iorder > 1) then
          begin
               statuscliente = 'AMBOS';
               for select cre_clientes.cod_cliente,
                          cre_clientes.des_cliente,
                          cre_clientes.des_endereco,
                          cre_clientes.des_bairro,
                          cre_clientes.cod_cidade,
                          cre_clientes.des_telefone,
                          cre_clientes.des_fone_celular,
                          cre_clientes_cr.des_fone_celular2,
                          cre_clientes_cr.des_fone_comerc,
                          cre_clientes.dta_cadastro,
                          cre_clientes.dta_alteracao,
                          cre_clientes.cod_unidade,
                          cre_clientes_cr.vlr_limite,
                          cre_clientes_cr.vlr_renda,
                          cre_clientes_cr.cod_pes_aprov_cad,
                          cre_clientes_cr.cod_pes_digit_cad,
                          case
                              when tip_pessoa = 1 then
                                   ''||substring((lpad(cre_clientes.cod_cliente,11,'0')) from 1 for 5)||'******'
                              when tip_pessoa = 2 then
                                   '***********'||substring((lpad(cre_clientes.cod_cliente,14,'0')) from 13 for 14)||''
                              else
                                  cre_clientes.cod_cliente
                          end as icpf_escondido
                   from cre_clientes
                        ,cre_clientes_cr
                   where cre_clientes.cod_emp=cre_clientes_cr.cod_emp
                   and cre_clientes.cod_cliente=cre_clientes_cr.cod_cliente
                   and cre_clientes.cod_emp=:icod_emp
                   and cre_clientes.tip_cliente   = 2
                   and ((cre_clientes.dta_alteracao >=:idt_altera_ini
                   and cre_clientes.dta_alteracao <=:idt_altera_fim)
                   or (cre_clientes.dta_cadastro  >=:idt_cadastro_ini
                   and cre_clientes.dta_cadastro  <=:idt_cadastro_fim))
                   order by cre_clientes.dta_cadastro,cre_clientes.des_cliente
                   into :icod_cliente,:ides_cliente,:ides_endereco,:ides_bairro,
                        :icod_cidade,:ides_fone_resid,:ides_fone_celular,:ides_fone_celular2,
                        :ides_fone_comerc,:dta_cadastro,:dta_alteracao,:icod_unidade,
                        :ivlr_limite,:ivlr_renda,:cod_pes_aprov_cad,:cod_pes_digit_cad, :icpf_escondido do
               begin
                    if ((icod_uni_cli = 999) or (icod_uni_cli = icod_unidade)) then
                    begin
                         select ind_spc
                         from cre_saldos_cli
                         where cod_emp=:icod_emp
                         and cod_cliente =:icod_cliente
                         into :iind_spc;

                         if (iind_spc = 1) then
                         begin
                              ind_spc = 'SIM';
                         end
                         else
                         begin
                              ind_spc = 'NAO';
                         end

                         select des_cidade
                         from ger_cidades
                         where cod_cidade = :icod_cidade
                         into ides_cidade;

                         if (ides_endereco is null) then ides_endereco = ' ';
                         if (ides_bairro is null) then ides_bairro = ' ';
                         if (ides_cidade is null) then ides_cidade = ' ';
                         if (ivlr_limite is null) then ivlr_limite = 0;
                         if (ides_fone_resid is null) then ides_fone_resid = ' ';
                         if (ivlr_renda is null) then ivlr_renda = 0;

                         suspend;
                    end
               end
          end
          else
          begin
               statuscliente = 'AMBOS';
               for select cre_clientes.cod_cliente,
                          cre_clientes.des_cliente,
                          cre_clientes.des_endereco,
                          cre_clientes.des_bairro,
                          cre_clientes.cod_cidade,
                          cre_clientes.des_telefone,
                          cre_clientes.des_fone_celular,
                          cre_clientes_cr.des_fone_celular2,
                          cre_clientes_cr.des_fone_comerc,
                          cre_clientes.dta_cadastro,
                          cre_clientes.dta_alteracao,
                          cre_clientes.cod_unidade,
                          cre_clientes_cr.vlr_limite,
                          cre_clientes_cr.vlr_renda,
                          cre_clientes_cr.cod_pes_aprov_cad,
                          cre_clientes_cr.cod_pes_digit_cad,
                          case
                              when tip_pessoa = 1 then
                                   ''||substring((lpad(cre_clientes.cod_cliente,11,'0')) from 1 for 5)||'******'
                              when tip_pessoa = 2 then
                                   '***********'||substring((lpad(cre_clientes.cod_cliente,14,'0')) from 13 for 14)||''
                              else
                                  cre_clientes.cod_cliente
                          end as icpf_escondido
                   from cre_clientes
                        ,cre_clientes_cr
                   where cre_clientes.cod_emp = cre_clientes_cr.cod_emp
                   and cre_clientes.cod_cliente = cre_clientes_cr.cod_cliente
                   and cre_clientes.cod_emp=:icod_emp
                   and cre_clientes.tip_cliente = 2
                   and ((cre_clientes.dta_alteracao >=:idt_altera_ini
                   and cre_clientes.dta_alteracao <=:idt_altera_fim)
                   or (cre_clientes.dta_cadastro  >=:idt_cadastro_ini
                   and cre_clientes.dta_cadastro  <=:idt_cadastro_fim))
                   order by cre_clientes.dta_cadastro,cre_clientes.cod_cliente
                   into :icod_cliente,:ides_cliente,:ides_endereco,:ides_bairro,
                        :icod_cidade,:ides_fone_resid,:ides_fone_celular,:ides_fone_celular2,
                        :ides_fone_comerc,:dta_cadastro,:dta_alteracao,:icod_unidade,
                        :ivlr_limite,:ivlr_renda,:cod_pes_aprov_cad,:cod_pes_digit_cad, :icpf_escondido do
               begin
                    if ((icod_uni_cli = 999) or (icod_uni_cli = icod_unidade)) then
                    begin
                         select ind_spc
                         from cre_saldos_cli
                         where cod_emp=:icod_emp
                         and cod_cliente =:icod_cliente
                         into :iind_spc;

                         if (iind_spc = 1) then
                         begin
                              ind_spc = 'SIM';
                         end
                         else
                         begin
                              ind_spc = 'NAO';
                         end

                         select des_cidade
                         from ger_cidades
                         where cod_cidade = :icod_cidade
                         into ides_cidade;

                         if (ides_endereco is null) then ides_endereco = ' ';
                         if (ides_bairro is null) then ides_bairro = ' ';
                         if (ides_cidade is null) then ides_cidade = ' ';
                         if (ivlr_limite is null) then ivlr_limite = 0;
                         if (ides_fone_resid is null) then ides_fone_resid = ' ';
                         if (ivlr_renda is null) then ivlr_renda = 0;

                         suspend;
                    end
               end
          end
     end
end ^

set term ; ^
commit work;
set autoddl on;
