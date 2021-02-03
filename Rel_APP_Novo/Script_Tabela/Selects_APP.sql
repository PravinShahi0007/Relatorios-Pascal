OK --Número de cadastros
select count(1) cli_cadastro 
       from appgrz.grz_api_ps_pessoas a ,appgrz.grz_api_user b 
       where b."cpf" = a.num_cpf 
       and trunc(b."created_at")  >= '01/03/2020'    
       and trunc(b."created_at") <= '31/03/2020';


select count(1) as cli_cadastro 
from appgrz.grz_api_ps_pessoas, appgrz.grz_api_user 
where to_number(appgrz.grz_api_user."cpf") = appgrz.grz_api_ps_pessoas.num_cpf 
      and (trunc(appgrz.grz_api_user."created_at") 
           between to_date(:inicial,'dd/mm/yyyy') and to_date(:final,'dd/mm/yyyy'))

------------------------------------------------------------------------------------------

OK --Número de cadastros novos
select count(1) cli_novos from appgrz.grz_api_ps_pessoas a , appgrz.grz_api_user b 
       where b."cpf" = a.num_cpf 
       and nvl(a.ind_cliente,0) = 0 
       and trunc(b."created_at")  >= '01/03/2020'    
       and trunc(b."created_at") <= '31/03/2020';


select count(1) as cli_novos from appgrz.grz_api_ps_pessoas, appgrz.grz_api_user
where appgrz.grz_api_user."cpf" = appgrz.grz_api_ps_pessoas.num_cpf and 
      nvl(appgrz.grz_api_ps_pessoas.ind_cliente,0) = 0 and 
      (trunc(appgrz.grz_api_user."created_at") between to_date(:inicial,'dd/mm/yyyy') and 
                                                       to_date(:final,'dd/mm/yyyy'))

------------------------------------------------------------------------------------------------

OK --Já são clientes
select count(1) as Cli_Antigos FROM APPGRZ.Grz_Api_Ps_Pessoas a ,appgrz.grz_api_user b 
         WHERE b."cpf" = a.num_cpf  
         and nvl(a.ind_cliente,0) = 1  
         and trunc(b."created_at")  >= '01/03/2020'
         and trunc(b."created_at") <= '31/03/2020';

select count(1) as cli_antigos from appgrz.grz_api_ps_pessoas, appgrz.grz_api_user
where appgrz.grz_api_user."cpf" = appgrz.grz_api_ps_pessoas.num_cpf and
      nvl(appgrz.grz_api_ps_pessoas.ind_cliente,0) = 1 and
      (trunc(appgrz.grz_api_user."created_at") between to_date(:inicial,'dd/mm/yyyy') and
                                                       to_date(:final,'dd/mm/yyyy'))

-----------------------------------------------------------------------------------------------------

OK --Número de cadastros novos aprovados
select count(1) as Cli_Aprovados 
       from APPGRZ.Grz_Api_Ps_Pessoas a,appgrz.grz_api_user b  
       WHERE b."cpf" = a.num_cpf 
	   and b."credit_status" = 'approve'
	   and nvl(a.ind_cliente,0) = 0 
	   and trunc(b."created_at")  >= '01/03/2020'   
	   and trunc(b."created_at") <= '31/03/2020';

select count(1) as cli_aprovados
from appgrz.grz_api_ps_pessoas,appgrz.grz_api_user  
where appgrz.grz_api_user."cpf" = appgrz.grz_api_ps_pessoas.num_cpf and 
      appgrz.grz_api_user."credit_status" = 'approve' and 
      nvl(appgrz.grz_api_ps_pessoas.ind_cliente,0) = 0 and 
      (trunc(appgrz.grz_api_user."created_at") between to_date(:inicial,'dd/mm/yyyy') and
                                                       to_date(:final,'dd/mm/yyyy'))

-------------------------------------------------------------------------------------------

OK -- clientes que efetuaram pagamento pelo app
select count(distinct a.num_cpf) as pgto_app 
       from appgrz.grz_api_ps_pessoas a, 
	        ps_fisicas p 
    	where a.num_cpf = p.num_cpf 
		and exists (select 1 from cr_historicos cr  
		              where p.cod_pessoa = cr.cod_pessoa 
					  and cr.cod_unidade_pgto = 702 
					  and cr.dta_pagamento >= '01/03/2020' 
					  and cr.dta_pagamento <= '31/03/2020';

select count(distinct appgrz.grz_api_ps_pessoas.num_cpf) as pgto_app 
from appgrz.grz_api_ps_pessoas, ps_fisicas
where appgrz.grz_api_ps_pessoas.num_cpf = ps_fisicas.num_cpf and 
      exists (select 1
              from cr_historicos
              where ps_fisicas.cod_pessoa = cr_historicos.cod_pessoa and 
                    cr_historicos.cod_unidade_pgto = 702 and 
                    (trunc(cr_historicos.dta_pagamento) between to_date(:inicial,'dd/mm/yyyy') and
                                                                to_date(:final,'dd/mm/yyyy')))

----------------------------------------------------------------------------------------------------

OK --Pagamento parcelas e valor Decre
select count(1) as qtd_parcelas,
       sum(nvl(w.vlr_pago,0) + nvl(w.vlr_multa,0) + nvl(w.vlr_juros,0)) as valor_pago 
	   from appgrz.grz_api_orders a, 
            appgrz.grz_api_cr_historicos w 
		where w.order_id = a."id"  
		and trunc(a."captured_at")   >= '01/03/2020'
		and trunc(a."captured_at")  <= '31/03/2020'
		and a."user_id" is not null 
		and a."status" = 2 
		and w.canal in (1,2);

select count(1) as qtd_parcelas,
       sum(nvl(appgrz.grz_api_cr_historicos.vlr_pago,0) + 
           nvl(appgrz.grz_api_cr_historicos.vlr_multa,0) + 
           nvl(appgrz.grz_api_cr_historicos.vlr_juros,0)) as valor_pago 
from appgrz.grz_api_orders, appgrz.grz_api_cr_historicos
where appgrz.grz_api_cr_historicos.order_id = appgrz.grz_api_orders."id" and 
      appgrz.grz_api_orders."user_id" is not null and 
      appgrz.grz_api_orders."status" = 2 and 
      appgrz.grz_api_cr_historicos.canal in (1,2) and
      (trunc(appgrz.grz_api_orders."captured_at") between to_date(:inicial,'dd/mm/yyyy') and 
                                                          to_date(:final,'dd/mm/yyyy'))

---------------------------------------------------------------------------------------------------

OK -- Quantidade e valor pagamento parcelas pelo APP e 0800
select  sum(decode(b.cod_unidade_pgto,702,1,0)) qtd_app  
       ,sum(case when (b.cod_unidade_pgto = 701) or (b.cod_lancamento = 103) then 1 else 0 end) as qtd_0800   
       ,sum(decode(b.cod_unidade_pgto,702,(nvl(b.vlr_lancamento,0) + nvl(b.vlr_juro_cobr,0) + nvl(b.vlr_desp_cobr,0)),0)) vlr_app   
       ,sum(case when (b.cod_unidade_pgto = 701) or (b.cod_lancamento = 103) then    
        (nvl(b.vlr_lancamento,0) + nvl(b.vlr_juro_cobr,0) + nvl(b.vlr_desp_cobr,0)) else 0 end) as vlr_0800 
  from cr_titulos a 
      ,cr_historicos b  
  where b.cod_pessoa = a.cod_pessoa
  and b.cod_emp = a.cod_emp
  and b.cod_unidade = a.cod_unidade 
  and b.num_titulo = a.num_titulo 
  and b.cod_compl = a.cod_compl 
  and b.num_parcela = a.num_parcela 
  and b.dta_pagamento >= '01/03/2020'
  and b.dta_pagamento <= '31/03/2020'
  and b.cod_lancamento in (100,101,20,65,103);


select sum(decode(cr_historicos.cod_unidade_pgto,702,1,0)) qtd_app,
       sum(case 
              when (cr_historicos.cod_unidade_pgto = 701) or (cr_historicos.cod_lancamento = 103) then 
                   1 
              else 0 
           end) as qtd_0800,
       sum(decode(cr_historicos.cod_unidade_pgto,702,(nvl(cr_historicos.vlr_lancamento,0) +
                  nvl(cr_historicos.vlr_juro_cobr,0) + nvl(cr_historicos.vlr_desp_cobr,0)),0)) vlr_app,
       sum(case 
              when (cr_historicos.cod_unidade_pgto = 701) or (cr_historicos.cod_lancamento = 103) then    
                    (nvl(cr_historicos.vlr_lancamento,0) + nvl(cr_historicos.vlr_juro_cobr,0) +
                     nvl(cr_historicos.vlr_desp_cobr,0)) 
                 else 0 
              end) as vlr_0800 
from cr_titulos,cr_historicos
where cr_historicos.cod_pessoa = cr_titulos.cod_pessoa and
      cr_historicos.cod_emp = cr_titulos.cod_emp and
      cr_historicos.cod_unidade = cr_titulos.cod_unidade and
      cr_historicos.num_titulo = cr_titulos.num_titulo and
      cr_historicos.cod_compl = cr_titulos.cod_compl and
      cr_historicos.num_parcela = cr_titulos.num_parcela and
      cr_historicos.cod_lancamento in (100,101,20,65,103) and 
      (cr_historicos.dta_pagamento between to_date(:inicial,'dd/mm/yyyy') and
                                           to_date(:final,'dd/mm/yyyy'))

---------------------------------------------------------------------------------------------

OK - /* Total de pagamento na CIA */

select count(1) qtd_pagamentos_cia,
      sum(nvl(cr_historicos.vlr_lancamento,0) +
          nvl(cr_historicos.vlr_juro_cobr,0) +
          nvl(cr_historicos.vlr_desp_cobr,0)) vlr_tot_cia
  from cr_titulos,
       cr_historicos, ge_grupos_unidades       
  where cr_historicos.cod_pessoa = cr_titulos.cod_pessoa and
        cr_historicos.cod_emp = cr_titulos.cod_emp and
        cr_historicos.cod_unidade = cr_titulos.cod_unidade and
        cr_historicos.num_titulo = cr_titulos.num_titulo and
        cr_historicos.cod_compl = cr_titulos.cod_compl and
        cr_historicos.num_parcela = cr_titulos.num_parcela and
        cr_titulos.ind_pago = 1 and
        cr_historicos.ind_dc = 2 and
        cr_historicos.cod_lancamento in (100,101,20,65,103) and
        cr_titulos.cod_unidade = ge_grupos_unidades.cod_unidade and
        ge_grupos_unidades.cod_grupo in (71010,71030,71040,71050,71070) and
        ge_grupos_unidades.cod_emp = 1 and
        (cr_historicos.dta_pagamento between 
                      to_date(:inicial,'dd/mm/yyyy') and
                      to_date(:final,'dd/mm/yyyy'));

-------------------------------------------------------------------------------------------------

OK - /* Quantidade e valor de boleto, credito e débito app */

select sum("amount") vlr_boleto_app, count(1) qtd_boleto_app from APPGRZ.grz_api_orders
       where trunc("captured_at") between '01/12/2020' and '31/12/2020'
         and "type" in ('Boleto')
         and "status" = 2
         and "user_id" is null;

select sum("amount") vlr_boleto_app, 
       count(1) qtd_boleto_app 
from appgrz.grz_api_orders
where "type" in ('Boleto') and 
      "status" = 2 and
      "user_id" is null and
      trunc("captured_at") between 
            to_date(:inicial,'dd/mm/yyyy') and
            to_date(:final,'dd/mm/yyyy');


select sum("amount") vlr_credito_app, count(1) qtd_credito_app from APPGRZ.grz_api_orders
       where trunc("captured_at") between '01/03/2020' and '31/03/2020'
         and "type" in ('CreditCard')
         and "status" = 2
         and "user_id" is null;

select sum("amount") vlr_credito_app,
       count(1) qtd_credito_app
from appgrz.grz_api_orders
where "type" in ('CreditCard') and
      "status" = 2 and
      "user_id" is null and
      trunc("captured_at") between 
            to_date(:inicial,'dd/mm/yyyy') and
            to_date(:final,'dd/mm/yyyy')



select sum("amount") vlr_debito_app, count(1) qtd_debito_app from APPGRZ.grz_api_orders
       where trunc("captured_at") between '01/03/2020' and '31/03/2020'
         and "type" in ('DebitCard')
         and "status" = 2
         and "user_id" is null;

select sum("amount") vlr_debito_app,
       count(1) qtd_debito_app
from appgrz.grz_api_orders
where "type" in ('DebitCard') and
      "status" = 2 and
      "user_id" is null and
      trunc("captured_at") between 
            to_date(:inicial,'dd/mm/yyyy') and
            to_date(:final,'dd/mm/yyyy'); 


-------------------------------------------------------------------------------------------------

OK - /* Valor e quantidade boleto DECRE */
select sum("amount") vlr_boleto_decre, count(1) qtd_boleto_decre from APPGRZ.grz_api_orders
       where trunc("captured_at") between '01/12/2020' and '31/12/2020'
         and "type" in ('Boleto')
         and "status" = 2
         and "user_id" is not null;

select nvl(sum("amount"),0) vlr_boleto_decre,
       count(1) qtd_boleto_decre
from appgrz.grz_api_orders
where "type" in ('Boleto') and 
      "status" = 2 and 
      "user_id" is not null and 
      trunc("captured_at") between 
            to_date(:inicial,'dd/mm/yyyy') and
            to_date(:final,'dd/mm/yyyy')


--------------------------------------------------------------------------------------------------

/* débito e crédito loja 
neste vai precisar de cursor... 
vai trazer valor em ind_deb_cred = 1 é debito
= 2 é credito... 
atualmente não tem na loja mas se tiver já estará pronto */


        select l.ind_deb_cred
              ,count(1) qtd_loja
              ,sum(nvl(a.vlr_lcto,0)) vlr_loja
          from grz_tef_transacao_servidor a
              ,grz_tef_transacao_lojas l
         where l.cod_emp        = a.cod_emp
           and l.cod_unidade    = a.cod_unidade
           and l.dta_movimento  = a.dta_movimento
           and to_number(a.num_nsusitef) = to_number(l.num_nsusitef)
           and l.ind_cancelado  = 0
           and l.tip_origem     = 4
           and a.dta_movimento  = l.dta_movimento
           and a.cod_resposta   = '00'
           and a.ind_cancelado  = 0
           and a.des_operacao not like '%CANC%'
           --and a.cod_unidade = 25
           and a.dta_movimento >= to_date(:inicial,'dd/mm/yyyy')
           and a.dta_movimento <= to_date(:final,'dd/mm/yyyy')
           -- and l.ind_deb_cred   is null  -- debito loja
           and not exists (select 1 from grz_tef_transacao_servidor c
                                   where a.cod_emp       = c.cod_emp
                                     and a.cod_unidade   = c.cod_unidade
                                     and a.dta_movimento = c.dta_movimento
                                     and to_number(a.num_nsuhost) = to_number(c.nsu_host_cancel)
                                     and a.des_rede      = c.des_rede
                                     and c.cod_resposta  = '00')
           and exists (select 1 from grz_lojas_recebimentos r
                        where l.cod_unidade     = r.cod_unidade
                          and l.num_equipamento = r.num_equipamento
                          and l.dta_movimento   = r.dta_mvto
                          and l.num_nsusitef    = r.num_nsusitef)
          group by l.ind_deb_cred

-------------------------------------------------------------------------------------






















































