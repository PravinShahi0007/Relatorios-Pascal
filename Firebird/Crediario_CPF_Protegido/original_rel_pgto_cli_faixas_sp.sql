commit work;
set autoddl off;
set term ^ ;

create procedure rel_pgto_cli_faixas_sp
(
 icod_emp                 numeric(3,0),
 icod_unidade             numeric(4,0),
 icod_cliente_inicial     numeric(14,0),
 icod_cliente_final       numeric(14,0),
 idta_inicial             date,
 idta_final               date,
 inum_equipamento_inicial numeric(2,0),
 inum_equipamento_final   numeric(2,0),
 icod_uni_cli             numeric(3,0),
 icod_func_ini            numeric(4,0),
 icod_func_fim            numeric(4,0),
 ifaixa                   numeric(1,0),
 itipcontrato             numeric(1,0)
)
returns
(
 ides_nome         varchar(50),
 icod_cliente      numeric(14,0),
 idta_movimento    date,
 icod_contrato     numeric(11,0),
 idta_vencimendto   date,
 ivlr_prestacao    numeric(15,2),
 ifunc_recebimento numeric(4,0),
 inum_parcela      numeric(3,0),
 icod_uni_cad      numeric(4,0),
 inumfaixa         numeric(1,0),
 idesfaixa         varchar(50),
 icontrato         varchar(3)
)
as
begin exit; end ^


alter procedure rel_pgto_cli_faixas_sp
(
 icod_emp                 numeric(3,0),
 icod_unidade             numeric(4,0),
 icod_cliente_inicial     numeric(14,0),
 icod_cliente_final       numeric(14,0),
 idta_inicial             date,
 idta_final               date,
 inum_equipamento_inicial numeric(2,0),
 inum_equipamento_final   numeric(2,0),
 icod_uni_cli             numeric(3,0),
 icod_func_ini            numeric(4,0),
 icod_func_fim            numeric(4,0),
 ifaixa                   numeric(1,0),
 itipcontrato             numeric(1,0)
)
returns
(
 ides_nome         varchar(50),
 icod_cliente      numeric(14,0),
 idta_movimento    date,
 icod_contrato     numeric(11,0),
 idta_vencimento   date,
 ivlr_prestacao    numeric(15,2),
 ifunc_recebimento numeric(4,0),
 inum_parcela      numeric(3,0),
 icod_uni_cad      numeric(4,0),
 inumfaixa         numeric(1,0),
 idesfaixa         varchar(50),
 icontrato         varchar(3)
)
as
  declare variable contrato_cpp varchar(3);
  declare variable contrato_cre varchar(3);
begin
     /* 1= lp, 2=pré lp, 3=resíduo, 4=pa, 5=preventiva, 6=pagamento ant, 7=pag outras redes, 0=todas  */
     /* 1=cre, 2=cpp, 0=todos */
     if (itipcontrato = 0) then
     begin
          contrato_cre = 'CRE';
          contrato_cpp = 'CPP';
     end
     else
         if (itipcontrato = 1) then
         begin
              contrato_cre = 'CRE';
              contrato_cpp = 'CRE';
         end
         else
             if (itipcontrato = 2) then
             begin
                  contrato_cre = 'CPP';
                  contrato_cpp = 'CPP';
             end

         if ((ifaixa = 1) or (ifaixa = 0)) then
         begin
              for select a.cod_cliente,a.dta_movimento,a.cod_contrato,
                         a.dta_vencimento,a.vlr_prestacao,a.cod_tipo_recbto,
                         a.num_parcela,b.des_cliente,b.cod_unidade,'1' as numfaixa,
                         'LP - LUCROS E PERDAS' as desfaixa,a.cod_compl
                  from (cre_recebimentos a
                        left outer join cre_clientes b
                        on( a.cod_emp = b.cod_emp and a.cod_cliente = b.cod_cliente))
                  where (a.cod_emp = :icod_emp) and
                        (a.cod_unidade = :icod_unidade) and
                        (a.cod_cliente between :icod_cliente_inicial and :icod_cliente_final) and
                        (a.dta_movimento between :idta_inicial and :idta_final) and
                        (a.num_equipamento between :inum_equipamento_inicial and :inum_equipamento_final) and
                        (a.cod_tipo_recbto between :icod_func_ini and :icod_func_fim) and
                        ((a.dta_movimento - a.dta_vencimento) > 0) and
                        ((select sdif_mes from retorna_mes_sp(a.dta_vencimento,a.dta_movimento)) >= 7) and
                        (a.cod_compl = :contrato_cre or a.cod_compl = :contrato_cpp) and
                        (b.cod_unidade = :icod_unidade) and
                        (b.des_cliente is not null)
                  order by 10, 8, 4, 3
                  into icod_cliente,idta_movimento,icod_contrato,idta_vencimento,
                       ivlr_prestacao,ifunc_recebimento,inum_parcela,ides_nome,
                       icod_uni_cad,inumfaixa,idesfaixa,icontrato do
              begin
                   if (icod_uni_cli = 9999) then
                      suspend;
                   else
                       if ((icod_uni_cli = 0) and (icod_uni_cad is null)) then
                          suspend;
              end
         end

     if ((ifaixa = 2) or (ifaixa = 0)) then
     begin
          for select a.cod_cliente,a.dta_movimento,a.cod_contrato,a.dta_vencimento,
                     a.vlr_prestacao,a.cod_tipo_recbto,a.num_parcela,b.des_cliente,
                     b.cod_unidade,'2' as numfaixa,'PRE LP - PRE LUCROS E PERDAS' as desfaixa,
                     a.cod_compl
              from (cre_recebimentos a
                    left outer join cre_clientes b
                    on( a.cod_emp = b.cod_emp and a.cod_cliente = b.cod_cliente))
              where (a.cod_emp = :icod_emp) and
                    (a.cod_unidade = :icod_unidade) and
                    (a.cod_cliente between :icod_cliente_inicial and :icod_cliente_final) and
                    (a.dta_movimento between :idta_inicial and :idta_final) and
                    (a.num_equipamento between :inum_equipamento_inicial and :inum_equipamento_final) and
                    (a.cod_tipo_recbto between :icod_func_ini and :icod_func_fim) and
                    ((a.dta_movimento - a.dta_vencimento) > 0) and
                    ((select sdif_mes from retorna_mes_sp(a.dta_vencimento,a.dta_movimento)) = 6) and
                    (a.cod_compl = :contrato_cre or a.cod_compl = :contrato_cpp) and
                    (b.cod_unidade = :icod_unidade) and
                    (b.des_cliente is not null)
              order by 10, 8, 4, 3
              into icod_cliente,idta_movimento,icod_contrato,idta_vencimento,
                   ivlr_prestacao,ifunc_recebimento,inum_parcela,ides_nome,
                   icod_uni_cad,inumfaixa,idesfaixa,icontrato do
          begin
               if (icod_uni_cli = 9999) then
                   suspend;
               else
                   if ((icod_uni_cli = 0) and (icod_uni_cad is null)) then
                      suspend;
          end
     end

     if ((ifaixa = 3) or (ifaixa = 0)) then
     begin
          for select a.cod_cliente,a.dta_movimento,a.cod_contrato,a.dta_vencimento,
                     a.vlr_prestacao,a.cod_tipo_recbto,a.num_parcela,b.des_cliente,
                     b.cod_unidade,'3' as numfaixa,'RESIDUO' as desfaixa,a.cod_compl
              from (cre_recebimentos a
                    left outer join cre_clientes b
                    on (a.cod_emp = b.cod_emp and a.cod_cliente = b.cod_cliente))
              where (a.cod_emp = :icod_emp)
              and (a.cod_unidade = :icod_unidade)
              and (a.cod_cliente between :icod_cliente_inicial and :icod_cliente_final)
              and (a.dta_movimento between :idta_inicial and :idta_final)
              and (a.num_equipamento between :inum_equipamento_inicial and :inum_equipamento_final)
              and (a.cod_tipo_recbto between :icod_func_ini and :icod_func_fim)
              and ((a.dta_movimento - a.dta_vencimento) > 0)
              and ((select sdif_mes from retorna_mes_sp(a.dta_vencimento,a.dta_movimento)) <= 5)
              and ((select sdif_mes from retorna_mes_sp(a.dta_vencimento,a.dta_movimento)) >= 2)
              and (a.cod_compl = :contrato_cre or a.cod_compl = :contrato_cpp)
              and (b.cod_unidade = :icod_unidade)
              and (b.des_cliente is not null)
              order by 10, 8, 4, 3
              into icod_cliente,idta_movimento,icod_contrato,idta_vencimento,ivlr_prestacao,ifunc_recebimento,
                   inum_parcela,ides_nome,icod_uni_cad,inumfaixa,idesfaixa,icontrato do
          begin
               if (icod_uni_cli = 9999) then
                  suspend;
               else
                   if ((icod_uni_cli = 0) and (icod_uni_cad is null)) then
                      suspend;
          end
     end

     if ((ifaixa = 4) or (ifaixa = 0)) then
     begin
          for select a.cod_cliente,a.dta_movimento,a.cod_contrato,a.dta_vencimento,
                     a.vlr_prestacao,a.cod_tipo_recbto,a.num_parcela,
                     b.des_cliente,b.cod_unidade,'4' as numfaixa,
                     'PA - PERIODO DE ALERTA' as desfaixa,a.cod_compl
              from (cre_recebimentos a
                    left outer join cre_clientes b
                    on (a.cod_emp = b.cod_emp and a.cod_cliente = b.cod_cliente))
              where (a.cod_emp = :icod_emp)
              and (a.cod_unidade = :icod_unidade)
              and (a.cod_cliente between :icod_cliente_inicial and :icod_cliente_final)
              and (a.dta_movimento between :idta_inicial and :idta_final)
              and (a.num_equipamento between :inum_equipamento_inicial and :inum_equipamento_final)
              and (a.cod_tipo_recbto between :icod_func_ini and :icod_func_fim)
              and ((a.dta_movimento - a.dta_vencimento) > 0)
              and ((select sdif_mes from retorna_mes_sp(a.dta_vencimento,a.dta_movimento)) = 1)
              and (a.cod_compl = :contrato_cre or a.cod_compl = :contrato_cpp)
              and (b.cod_unidade = :icod_unidade)
              and (b.des_cliente is not null)
              order by 10, 8, 4, 3
              into icod_cliente,idta_movimento,icod_contrato,idta_vencimento,ivlr_prestacao,ifunc_recebimento,
                   inum_parcela,ides_nome,icod_uni_cad,inumfaixa,idesfaixa,icontrato do
          begin
               if (icod_uni_cli = 9999) then
                  suspend;
               else
                   if ((icod_uni_cli = 0) and (icod_uni_cad is null)) then
                      suspend;
          end
     end

     if ((ifaixa = 5) or (ifaixa = 0)) then
     begin
          for select a.cod_cliente,a.dta_movimento,a.cod_contrato,a.dta_vencimento,
                     a.vlr_prestacao,a.cod_tipo_recbto,a.num_parcela,
                     b.des_cliente,b.cod_unidade,'5' as numfaixa,
                     'PREVENTIVA' as desfaixa,a.cod_compl
              from (cre_recebimentos a
                    left outer join cre_clientes b
                    on (a.cod_emp = b.cod_emp and a.cod_cliente = b.cod_cliente))
              where (a.cod_emp = :icod_emp)
              and (a.cod_unidade = :icod_unidade)
              and (a.cod_cliente between :icod_cliente_inicial and :icod_cliente_final)
              and (a.dta_movimento between :idta_inicial and :idta_final)
              and (a.num_equipamento between :inum_equipamento_inicial and :inum_equipamento_final)
              and (a.cod_tipo_recbto between :icod_func_ini and :icod_func_fim)
              and ((select sdif_mes from retorna_mes_sp(a.dta_vencimento,a.dta_movimento)) = 0)
              and (a.cod_compl = :contrato_cre or a.cod_compl = :contrato_cpp)
              and (b.cod_unidade = :icod_unidade)
              and (b.des_cliente is not null)
              order by 10,8,4,3
              into icod_cliente,idta_movimento,icod_contrato,idta_vencimento,
                   ivlr_prestacao,ifunc_recebimento,inum_parcela,ides_nome,
                   icod_uni_cad,inumfaixa,idesfaixa,icontrato do
          begin
               if (icod_uni_cli = 9999) then
                  suspend;
               else
                   if ((icod_uni_cli = 0) and (icod_uni_cad is null)) then
                      suspend;
          end
     end

     if ((ifaixa = 6) or (ifaixa = 0)) then
     begin
          for select a.cod_cliente,a.dta_movimento,a.cod_contrato,a.dta_vencimento,
                     a.vlr_prestacao,a.cod_tipo_recbto,a.num_parcela,b.des_cliente,
                     b.cod_unidade,'6' as numfaixa,'PAGAMENTO ANTECIPADO' as desfaixa,a.cod_compl
              from (cre_recebimentos a
                    left outer join cre_clientes b
                    on (a.cod_emp = b.cod_emp and a.cod_cliente = b.cod_cliente))
              where (a.cod_emp = :icod_emp)
              and (a.cod_unidade = :icod_unidade)
              and (a.cod_cliente between :icod_cliente_inicial and :icod_cliente_final)
              and (a.dta_movimento between :idta_inicial and :idta_final)
              and (a.num_equipamento between :inum_equipamento_inicial and :inum_equipamento_final)
              and (a.cod_tipo_recbto between :icod_func_ini and :icod_func_fim)
              and ((a.dta_movimento - a.dta_vencimento) < 0)
              and ((select sdif_mes from retorna_mes_sp(a.dta_vencimento,a.dta_movimento)) >= 1)
              and (a.cod_compl = :contrato_cre or a.cod_compl = :contrato_cpp)
              and (b.cod_unidade = :icod_unidade)
              and (b.des_cliente is not null)
              order by 10,8,4,3
              into icod_cliente,idta_movimento,icod_contrato,idta_vencimento,
                   ivlr_prestacao,ifunc_recebimento,inum_parcela,ides_nome,
                   icod_uni_cad,inumfaixa,idesfaixa,icontrato do
          begin
               if (icod_uni_cli = 9999) then
                  suspend;
               else
                   if ((icod_uni_cli = 0) and (icod_uni_cad is null)) then
                      suspend;
          end
     end

     if ((ifaixa = 7) or (ifaixa = 0)) then
     begin
          for select a.cod_cliente,a.dta_movimento,a.cod_contrato,a.dta_vencimento,
                     a.vlr_prestacao,a.cod_tipo_recbto,a.num_parcela,
                     b.des_cliente,b.cod_unidade,'7' as numfaixa,
                     'PAGAMENTO DE OUTRAS REDES E LOJAS' as desfaixa,a.cod_compl
              from (cre_recebimentos a
                    left outer join cre_clientes b
                    on( a.cod_emp = b.cod_emp and a.cod_cliente = b.cod_cliente))
              where (a.cod_emp=:icod_emp)
              and (a.cod_unidade=:icod_unidade)
              and (a.cod_cliente between :icod_cliente_inicial and :icod_cliente_final)
              and (a.dta_movimento between :idta_inicial and :idta_final)
              and (a.num_equipamento between :inum_equipamento_inicial and :inum_equipamento_final)
              and (a.cod_tipo_recbto between :icod_func_ini and :icod_func_fim)
              and (b.des_cliente is null or b.cod_unidade <> :icod_unidade)
              and (a.cod_compl = :contrato_cre or a.cod_compl = :contrato_cpp)
              order by 10,8,4,3
              into icod_cliente,idta_movimento,icod_contrato,idta_vencimento,
                   ivlr_prestacao,ifunc_recebimento,inum_parcela,ides_nome,
                   icod_uni_cad,inumfaixa,idesfaixa,icontrato do
          begin
               if(ides_nome is null) then
               begin
                    if (ifunc_recebimento = 509) then
                       ides_nome = 'RECEBIMENTOS DIVERSOS';
                    else
                        if (ifunc_recebimento = 505) then
                           ides_nome = 'CLIENTE DE OUTRA REDE';
                        else
                            ides_nome = 'CLIENTE DE OUTRA LOJA';
               end
               if (icod_uni_cli = 9999) then
                  suspend;
               else
                   if ((icod_uni_cli = 0) and (icod_uni_cad is null)) then
                      suspend;
          end
     end
end ^

set term ; ^
commit work;
set autoddl on;