commit work;
set autoddl off;
set term ^ ;

create or alter procedure rel_pgto_cli_sp
(
 icod_emp                 numeric(3,0),
 icod_unidade             numeric(4,0),
 icod_cliente_inicial     numeric(14,0),
 icod_cliente_final       numeric(14,0),
 idta_inicial             date,
 idta_final               date,
 inum_equipamento_inicial numeric(2,0),
 inum_equipamento_final   numeric(2,0),
 orderby                  numeric(1,0),
 icod_uni_cli             numeric(3,0),
 icod_func_ini            numeric(4,0),
 icod_func_fim            numeric(4,0)
)
returns
(
 ides_nome         varchar(50),
 icod_cliente      numeric(14, 0),
 idta_movimento    date,
 icod_contrato     numeric(11, 0),
 idta_vencimento   date,
 iatrazo           numeric(10, 0),
 ivlr_prestacao    numeric(15, 2),
 tc                numeric(8, 0),
 ifunc_recebimento numeric(4, 0),
 inum_parcela      numeric(3, 0),
 icod_uni_cad      numeric(4, 0),
 icod_emp_vda      numeric(3, 0),
 icod_uni_vda      numeric(4, 0),
 ivlr_juros        numeric(15, 2),
 ivlr_multa        numeric(15, 2),
 ivlr_taxa         numeric(15, 2),
 ivlr_desconto     numeric(15, 2),
 inum_cupom        numeric(11, 0),
 ival_total        numeric(15, 2),
 inum_cpfcnpj      varchar(15),
 icpf_escondido    varchar(20)
)
as
begin
     tc = orderby;
     if (orderby = 1) then /* des_nome */
     begin
          for select a.cod_cliente
                     ,a.dta_movimento
                     ,a.cod_contrato
                     ,a.dta_vencimento
                     ,a.vlr_prestacao
                     ,a.cod_tipo_recbto
                     ,a.num_parcela
                     ,b.des_cliente
                     ,b.cod_unidade
                     ,a.cod_emp_vda
                     ,a.cod_uni_vda
                     ,a.vlr_juros
                     ,a.vlr_multa
                     ,a.vlr_taxa
                     ,a.vlr_desconto
                     ,a.num_cupom
                     ,(a.vlr_prestacao + a.vlr_juros + a.vlr_multa + a.vlr_taxa - a.vlr_desconto) as val_total
                     ,a.num_cpfcnpj,
                     case 
                         when a.num_cpfcnpj >12 then
                              substring((lpad(a.num_cpfcnpj,11,'0')) from 1 for 3)||'.***.***-'||
                              substring((lpad(a.num_cpfcnpj,11,'0')) from 10 for 11)
                         when a.num_cpfcnpj <11 then
                              substring((lpad(a.num_cpfcnpj,14,'0')) from 1 for 2)||
                              '.***.***/****-'||
                              substring((lpad(a.num_cpfcnpj,14,'0')) from 13 for 14)
                         else 
                             a.num_cpfcnpj
                     end as icpf_escondido
              from (cre_recebimentos a left outer join cre_clientes b 
                                       on(a.cod_emp = b.cod_emp and a.cod_cliente = b.cod_cliente))
              where (a.cod_emp = :icod_emp)
              and (a.cod_unidade = :icod_unidade)
              and (a.cod_cliente between :icod_cliente_inicial and :icod_cliente_final)
              and (a.dta_movimento between :idta_inicial and :idta_final)
              and (a.num_equipamento between :inum_equipamento_inicial and :inum_equipamento_final)
              and (a.cod_tipo_recbto between :icod_func_ini and :icod_func_fim)
              order by b.des_cliente,a.cod_contrato,a.dta_vencimento,a.num_parcela
              into icod_cliente,idta_movimento,icod_contrato
                   ,idta_vencimento,ivlr_prestacao,ifunc_recebimento
                   ,inum_parcela,ides_nome,icod_uni_cad
                   ,icod_emp_vda,icod_uni_vda,ivlr_juros
                   ,ivlr_multa,ivlr_taxa,ivlr_desconto
                   ,inum_cupom,ival_total,inum_cpfcnpj
                   ,icpf_escondido do
          begin
               if (ides_nome is null) then
               begin
                    if (ifunc_recebimento = 509) then
                       ides_nome = 'RECEBIMENTOS DIVERSOS';
                    else
                        if (ifunc_recebimento = 505) then
                           ides_nome = 'CLIENTE DE OUTRA REDE';
                        else
                            ides_nome = 'CLIENTE DE OUTRA LOJA';
               end
               iatrazo = idta_movimento-idta_vencimento;
               if (iatrazo < 0) then
                  iatrazo = 0;
               if (icod_uni_cli = 9999) then
                  suspend;
               else
                   if ((icod_uni_cli = 0) and (icod_uni_cad is null)) then
                      suspend;
                   else
                       if (icod_uni_cli = icod_uni_cad) then
                          suspend;
                       else
                           iatrazo = 0;
          end
     end

     if (orderby = 2) then /* dta_movimento */
     begin
          for select a.cod_cliente
                     ,a.dta_movimento
                     ,a.cod_contrato
                     ,a.dta_vencimento
                     ,a.vlr_prestacao
                     ,a.cod_tipo_recbto
                     ,a.num_parcela
                     ,b.des_cliente
                     ,b.cod_unidade
                     ,a.cod_emp_vda
                     ,a.cod_uni_vda
                     ,a.vlr_juros
                     ,a.vlr_multa
                     ,a.vlr_taxa
                     ,a.vlr_desconto
                     ,a.num_cupom
                     ,(a.vlr_prestacao + a.vlr_juros + a.vlr_multa + a.vlr_taxa - a.vlr_desconto) as val_total
                     ,a.num_cpfcnpj,
                     case
                         when a.num_cpfcnpj >12 then
                              substring((lpad(a.num_cpfcnpj,11,'0')) from 1 for 3)||'.***.***-'||
                              substring((lpad(a.num_cpfcnpj,11,'0')) from 10 for 11)
                         when a.num_cpfcnpj <11 then
                              substring((lpad(a.num_cpfcnpj,14,'0')) from 1 for 2)||
                              '.***.***/****-'||
                              substring((lpad(a.num_cpfcnpj,14,'0')) from 13 for 14)
                         else
                             a.num_cpfcnpj
                     end as icpf_escondido
              from (cre_recebimentos a left outer join cre_clientes b
                                       on( a.cod_emp = b.cod_emp and a.cod_cliente = b.cod_cliente))
              where (a.cod_emp = :icod_emp)
              and (a.cod_unidade = :icod_unidade)
              and (a.cod_cliente between :icod_cliente_inicial and :icod_cliente_final)
              and (a.dta_movimento between :idta_inicial and :idta_final)
              and (a.num_equipamento between :inum_equipamento_inicial and :inum_equipamento_final)
              and (a.cod_tipo_recbto between :icod_func_ini and :icod_func_fim)
              order by a.dta_movimento,b.des_cliente,a.cod_contrato,a.dta_vencimento,a.num_parcela
              into icod_cliente,idta_movimento,icod_contrato
                   ,idta_vencimento,ivlr_prestacao,ifunc_recebimento
                   ,inum_parcela,ides_nome,icod_uni_cad
                   ,icod_emp_vda,icod_uni_vda,ivlr_juros
                   ,ivlr_multa,ivlr_taxa,ivlr_desconto
                   ,inum_cupom,ival_total,inum_cpfcnpj,icpf_escondido do
          begin
               if (ides_nome is null) then
               begin
                    if (ifunc_recebimento = 509) then
                       ides_nome = 'RECEBIMENTOS DIVERSOS';
                    else
                        if (ifunc_recebimento = 505) then
                           ides_nome = 'CLIENTE DE OUTRA REDE';
                        else
                            ides_nome = 'CLIENTE DE OUTRA LOJA';
               end
               iatrazo = idta_movimento - idta_vencimento;
               if (iatrazo < 0) then
                  iatrazo = 0;
               if (icod_uni_cli = 9999) then
                  suspend;
               else
                   if ((icod_uni_cli = 0) and (icod_uni_cad is null)) then
                      suspend;
                   else
                       if (icod_uni_cli = icod_uni_cad) then
                          suspend;
                       else
                           iatrazo = 0;
          end
     end

     if (orderby = 3) then
     begin
          for select a.cod_cliente
                     ,a.dta_movimento
                     ,a.cod_contrato
                     ,a.dta_vencimento
                     ,a.vlr_prestacao
                     ,a.cod_tipo_recbto
                     ,a.num_parcela
                     ,b.des_cliente
                     ,b.cod_unidade
                     ,a.cod_emp_vda
                     ,a.cod_uni_vda
                     ,a.vlr_juros
                     ,a.vlr_multa
                     ,a.vlr_taxa
                     ,a.vlr_desconto
                     ,a.num_cupom
                     ,(a.vlr_prestacao + a.vlr_juros + a.vlr_multa + a.vlr_taxa - a.vlr_desconto) as val_total
                     ,a.num_cpfcnpj,
                     case
                         when a.num_cpfcnpj > 12 then
                              substring((lpad(a.num_cpfcnpj,11,'0')) from 1 for 3)||'.***.***-'||
                              substring((lpad(a.num_cpfcnpj,11,'0')) from 10 for 11)
                         when a.num_cpfcnpj < 11 then
                              substring((lpad(a.num_cpfcnpj,14,'0')) from 1 for 2)||
                              '.***.***/****-'||
                              substring((lpad(a.num_cpfcnpj,14,'0')) from 13 for 14)
                         else
                             a.num_cpfcnpj
                     end as icpf_escondido
              from (cre_recebimentos a left outer join cre_clientes b 
                                       on( a.cod_emp = b.cod_emp and a.cod_cliente = b.cod_cliente))
              where (a.cod_emp=:icod_emp)
              and (a.cod_unidade=:icod_unidade)
              and (a.cod_cliente between :icod_cliente_inicial and :icod_cliente_final)
              and (a.dta_movimento between :idta_inicial and :idta_final)
              and (a.num_equipamento between :inum_equipamento_inicial and :inum_equipamento_final)
              and (a.cod_tipo_recbto between :icod_func_ini and :icod_func_fim)
              order by a.dta_vencimento,b.des_cliente,a.cod_contrato,a.num_parcela
              into icod_cliente,idta_movimento,icod_contrato
                   ,idta_vencimento,ivlr_prestacao,ifunc_recebimento
                   ,inum_parcela,ides_nome,icod_uni_cad
                   ,icod_emp_vda,icod_uni_vda,ivlr_juros
                   ,ivlr_multa,ivlr_taxa,ivlr_desconto
                   ,inum_cupom,ival_total,inum_cpfcnpj,icpf_escondido do
          begin
               if (ides_nome is null) then
               begin
                    if (ifunc_recebimento = 509) then
                       ides_nome = 'RECEBIMENTOS DIVERSOS';
                    else
                        if (ifunc_recebimento = 505) then
                           ides_nome = 'CLIENTE DE OUTRA REDE';
                        else
                            ides_nome = 'CLIENTE DE OUTRA LOJA';
               end
               iatrazo = idta_movimento-idta_vencimento;
               if (iatrazo < 0) then
                  iatrazo = 0;
               if (icod_uni_cli = 9999) then
                  suspend;
               else
                   if ((icod_uni_cli = 0) and (icod_uni_cad is null)) then
                      suspend;
                   else
                       if (icod_uni_cli = icod_uni_cad) then
                          suspend;
                       else
                           iatrazo = 0;
          end
     end
end ^

set term ; ^
commit work;
set autoddl on;
