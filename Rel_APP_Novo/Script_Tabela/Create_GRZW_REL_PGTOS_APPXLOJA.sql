create table grzw_rel_pgtos_appxloja
(
  dta_mes                 date,
  qtd_tot_cli_app         number(8),    -- Cadastrados na base
  qtd_new_cli_app         number(8),    -- Quantidade de novos cadastros
  qtd_cli_grazziotin      number(8),    -- Já são clientes 
  qtd_new_cli_app_aprov   number(8),    -- Novos clientes aprovados
  tot_cli_pgto_cia        number(18,2), -- Total de valores pagos na CIA
  tot_cli_pgto_app        number(8),    -- Efetuaram pagamento pelo APP
  qtd_parcelas_pgto_cia   number(8),    -- Quantidade de parcelas pagas na CIA
  qtd_parcelas_pgto_app   number(8),    -- Quantidade de parcelas pagas pelo APP
  vlr_parcelas_pgto_cia   number(18,2), -- Valor de parcelas pagas na CIA
  vlr_parcelas_pgto_app   number(18,2), -- Valor de parcelas pagas pelo APP
  qtd_parcelas_pgto_decre number(8),    -- Quantidade de parcelas pagas - DECRE
  vlr_parcelas_pgto_decre number(18,2), -- Valor das parcelas pagas - DECRE
  qtd_parcelas_pgto_0800  number(8),    -- Quantidade de parcelas pagas - 0800
  vlr_parcelas_pgto_0800  number(18,2), -- Valor das parcelas pagas - 0800
  qtd_pgto_boleto_app     number(8),    -- Quantidade de pagamento boleto APP
  vlr_pgto_boleto_app     number(18,2), -- Valor de pagamento boleto APP
  qtd_pgto_debito_app     number(8),    -- Quantidade de pagamento debito boleto APP
  vlr_pgto_debito_app     number(18,2), -- Valor de pagamento debito boleto APP
  qtd_pgto_credito_app    number(8),    -- Quantidade de pagamento credito boleto APP
  vlr_pgto_credito_app    number(18,2), -- Valor de pagamento credito boleto APP
  qtd_pgto_pix_app        number(8),
  vlr_pgto_pix_app        number(18,2),
  qtd_pgto_boleto_decre   number(8),    -- Quantidade de pagamento boleto DECRE
  vlr_pgto_boleto_decre   number(18,2), -- Valor de pagamento credito boleto APP
  qtd_pgto_pix_decre      number(8),
  vlr_pgto_pix_decre      number(18,2),
  qtd_pgto_loja           number(8),
  vlr_pgto_loja           number(18,2),
  qtd_pgto_debito_loja    number(8),    -- Quantidade de pagamento debito LOJA
  vlr_pgto_debito_loja    number(18,2), -- Valor pagamento debito LOJA
  qtd_pgto_credito_loja   number(8),    -- Quantidade de pagamento credito LOJA
  vlr_pgto_credito_loja   number(18,2), -- Valor pagamento credito LOJA
  qtd_pgto_pix_loja       number(8),
  vlr_pgto_pix_loja       number(18,2),
  constraint "grzwrelpgtos_appxloja_pk" primary key (dta_mes));
  