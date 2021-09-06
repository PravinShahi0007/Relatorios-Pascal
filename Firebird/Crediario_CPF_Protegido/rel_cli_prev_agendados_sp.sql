commit work;
set autoddl off;
set term ^ ;

create or alter procedure rel_cli_prev_agendados_sp
(
 cod_emp             numeric(3,0),
 cod_unidade         numeric(4,0),
 dta_inicial         date,
 dta_final           date,
 nro_compra_ini      numeric(5,0),
 nro_compra_fim      numeric(5,0),
 vlr_prox_ini        numeric(15,2),
 vlr_prox_fim        numeric(15,2),
 iorder              numeric(1,0),
 mda_ini             numeric(5,0),
 mda_fim             numeric(5,0),
 perfil_ini          numeric(4,0),
 perfil_fim          numeric(4,0),
 dta_agendamento_ini date,
 dta_agendamento_fim date
)
returns
(
 cod_cliente       numeric(14,0),
 des_cliente       varchar(40),
 dta_cadastro      date,
 des_fone_resid    varchar(15),
 des_fone_comerc   varchar(15),
 qtd_compras_vp    numeric(5,0),
 des_fone_celular2 varchar(15),
 des_fone_aut      varchar(15),
 qtd_maior_atraso  numeric(5,0),
 dta_vencimento    date,
 qtd_parcelas      numeric(3,0),
 tip_plano_vp      varchar(6),
 num_parcela       numeric(3,0),
 vlr_prestacao     numeric(15,2),
 cod_contrato      numeric(11,0),
 dta_venda         date,
 des_fone_celular  varchar(15),
 num_mda           numeric(5,0),
 cod_perfil_cli    numeric(4,0),
 cod_compl         varchar(3),
 dta_venc_ordem    date,
 dta_agendamento   date,
 cpf_escondido     varchar(20)
)
as
  declare variable contador numeric(3);
  declare variable cod_cliente_ant numeric(8,0);
begin
     cod_cliente_ant = 0;
     if (iorder = 1) then /* nome */
     begin
          for select a.cod_cliente
                     ,a.dta_vencimento
                     ,a.qtd_parcelas
                     ,a.tip_plano_vp
                     ,a.num_parcela
                     ,a.vlr_prestacao
                     ,a.cod_contrato
                     ,a.dta_venda
                     ,a.cod_compl
                     ,c.dta_agendamento
              from cre_contas_receber a,cre_cli_agenda c
              where a.cod_emp = c.cod_emp
              and a.cod_unidade = c.cod_unidade
              and a.cod_cliente = c.cod_cliente
              and a.dta_vencimento < c.dta_agendamento
              and a.cod_emp = :cod_emp
              and a.cod_unidade = :cod_unidade
              and ind_prestacao = 0
              and vlr_prestacao >= :vlr_prox_ini
              and vlr_prestacao <= :vlr_prox_fim
              and c.dta_agendamento between :dta_agendamento_ini and :dta_agendamento_fim
              and extract (month from c.dta_mvto)= extract (month from c.dta_agendamento)
              and extract (year from c.dta_mvto)= extract (year from c.dta_agendamento)
              group by a.cod_cliente
                       ,a.dta_vencimento
                       ,a.qtd_parcelas
                       ,a.tip_plano_vp
                       ,a.num_parcela
                       ,a.vlr_prestacao
                       ,a.cod_contrato
                       ,a.dta_venda
                       ,a.cod_compl
                       ,c.dta_agendamento
              having min (extract(month from a.dta_vencimento)) = extract (month from c.dta_agendamento)
              into :cod_cliente,:dta_vencimento,:qtd_parcelas,:tip_plano_vp,
                   :num_parcela,:vlr_prestacao,:cod_contrato,:dta_venda,:cod_compl,:dta_agendamento do
          begin
               for select a.des_cliente
                          ,a.dta_cadastro
                          ,a.des_telefone
                          ,d.des_fone_comerc
                          ,d.des_fone_celular
                          ,d.des_fone_celular2
                          ,b.qtd_compras_vp
                          ,b.qtd_maior_atraso
                          ,b.num_mda
                          ,b.cod_perfil_cli,
                          case
                              when a.tip_pessoa = 1 then
                                   substring((lpad(a.cod_cliente,11,'0')) from 1 for 3)||'.***.***-'||
                                   substring((lpad(a.cod_cliente,11,'0')) from 10 for 11)
                              when a.tip_pessoa = 2 then
                                   substring((lpad(a.cod_cliente,14,'0')) from 1 for 2)||
                                   '.***.***/****-'||
                                   substring((lpad(a.cod_cliente,14,'0')) from 13 for 14)
                              else
                                  a.cod_cliente
                          end as cpf_escondido
                   from cre_clientes a
                        ,cre_clientes_cr d
                        ,cre_saldos_cli b
                   where a.cod_emp = d.cod_emp
                   and a.cod_cliente = d.cod_cliente
                   and a.cod_emp = b.cod_emp
                   and a.cod_cliente = b.cod_cliente
                   and b.qtd_compras_vp >= :nro_compra_ini
                   and b.qtd_compras_vp <= :nro_compra_fim
                   and a.cod_emp = :cod_emp
                   and a.cod_cliente = :cod_cliente
                   and b.num_mda >= :mda_ini
                   and b.num_mda <= :mda_fim
                   and b.cod_perfil_cli >= :perfil_ini
                   and b.cod_perfil_cli <= :perfil_fim
                   into :des_cliente,:dta_cadastro,:des_fone_resid,:des_fone_comerc,:des_fone_celular,:des_fone_celular2,
                        :qtd_compras_vp,:qtd_maior_atraso,:num_mda,:cod_perfil_cli,:cpf_escondido do
               begin
                    for select des_telefone
                        from cre_pessoa_autorizada
                        where cod_emp = :cod_emp
                        and cod_cliente = :cod_cliente
                        into :des_fone_aut do
                    begin
                         contador = 0;
                         begin
                              select count(1)
                              from cre_contas_receber
                              where cod_emp = :cod_emp
                              and cod_cliente = :cod_cliente
                              and cod_contrato = :cod_contrato
                              and dta_vencimento < :dta_agendamento
                              and ind_prestacao = 0
                              into :contador;
                              when sqlcode -104 do
                                   contador = 0;
                         end
                         if (contador = 1) then
                         begin
                              suspend;
                         end
                    end
               end
          end
     end
     else
         if (iorder = 2) then /* qtd compras */
         begin
              for select a.cod_cliente
                         ,a.dta_vencimento
                         ,a.qtd_parcelas
                         ,a.tip_plano_vp
                         ,a.num_parcela
                         ,a.vlr_prestacao
                         ,a.cod_contrato
                         ,a.dta_venda
                         ,a.cod_compl
                         ,c.dta_agendamento
                  from cre_contas_receber a,cre_cli_agenda c
                  where a.cod_emp = c.cod_emp
                  and a.cod_unidade = c.cod_unidade
                  and a.cod_cliente = c.cod_cliente
                  and a.dta_vencimento = c.dta_agendamento
                  and a.cod_emp = :cod_emp
                  and a.cod_unidade = :cod_unidade
                  and ind_prestacao = 0
                  and vlr_prestacao >= :vlr_prox_ini
                  and vlr_prestacao <= :vlr_prox_fim
                  and c.dta_agendamento between :dta_agendamento_ini and :dta_agendamento_fim
                  and extract (month from c.dta_mvto)= extract (month from c.dta_agendamento)
                  and extract (year from c.dta_mvto)= extract (year from c.dta_agendamento)
                  group by a.cod_cliente
                           ,a.dta_vencimento
                           ,a.qtd_parcelas
                           ,a.tip_plano_vp
                           ,a.num_parcela
                           ,a.vlr_prestacao
                           ,a.cod_contrato
                           ,a.dta_venda
                           ,a.cod_compl
                           ,c.dta_agendamento
                  having min (extract (month from a.dta_vencimento)) = extract (month from c.dta_agendamento)
                  into :cod_cliente,:dta_vencimento,:qtd_parcelas,:tip_plano_vp,
                       :num_parcela,:vlr_prestacao,:cod_contrato,:dta_venda,:cod_compl,:dta_agendamento do
              begin
                   for select a.des_cliente
                             ,a.dta_cadastro
                             ,a.des_telefone
                             ,d.des_fone_comerc
                             ,d.des_fone_celular
                             ,d.des_fone_celular2
                             ,b.qtd_compras_vp
                             ,b.qtd_maior_atraso
                             ,b.num_mda
                             ,b.cod_perfil_cli,
                             case
                                 when a.tip_pessoa = 1 then
                                      substring((lpad(a.cod_cliente,11,'0')) from 1 for 3)||'.***.***-'||
                                      substring((lpad(a.cod_cliente,11,'0')) from 10 for 11)
                                 when a.tip_pessoa = 2 then
                                      substring((lpad(a.cod_cliente,14,'0')) from 1 for 2)||
                                      '.***.***/****-'||
                                      substring((lpad(a.cod_cliente,14,'0')) from 13 for 14)
                                 else
                                     a.cod_cliente
                             end as cpf_escondido
                       from cre_clientes a
                            ,cre_clientes_cr d
                            ,cre_saldos_cli b
                       where a.cod_emp = d.cod_emp
                       and a.cod_cliente = d.cod_cliente
                       and a.cod_emp = b.cod_emp
                       and a.cod_cliente = b.cod_cliente
                       and b.qtd_compras_vp >= :nro_compra_ini
                       and b.qtd_compras_vp <= :nro_compra_fim
                       and a.cod_emp = :cod_emp
                       and a.cod_cliente = :cod_cliente
                       and b.num_mda >= :mda_ini
                       and b.num_mda <= :mda_fim
                       and b.cod_perfil_cli >= :perfil_ini
                       and b.cod_perfil_cli <= :perfil_fim
                       into :des_cliente,:dta_cadastro,:des_fone_resid,:des_fone_comerc,:des_fone_celular,:des_fone_celular2,
                            :qtd_compras_vp,:qtd_maior_atraso,:num_mda,:cod_perfil_cli,:cpf_escondido do
                   begin
                        for select des_telefone
                            from cre_pessoa_autorizada
                            where cod_emp = :cod_emp
                            and cod_cliente = :cod_cliente
                            into :des_fone_aut do
                        begin
                             contador = 0;
                             begin
                                  select count(1)
                                  from cre_contas_receber
                                  where cod_emp = :cod_emp
                                  and cod_cliente = :cod_cliente
                                  and cod_contrato = :cod_contrato
                                  and dta_vencimento < :dta_agendamento
                                  and ind_prestacao = 0
                                  into :contador;
                                  when sqlcode -104 do
                                       contador = 0;
                             end
                             if (contador = 1) then
                             begin
                                  suspend;
                             end
                        end
                   end
              end
         end
         else
             if (iorder = 3) then /* vencimento */
             begin
                  for select a.cod_cliente
                             ,a.dta_vencimento
                             ,a.qtd_parcelas
                             ,a.tip_plano_vp
                             ,a.num_parcela
                             ,a.vlr_prestacao
                             ,a.cod_contrato
                             ,a.dta_venda
                             ,a.cod_compl
                             ,c.dta_agendamento
                      from cre_contas_receber a,cre_cli_agenda c
                      where a.cod_emp = c.cod_emp
                      and a.cod_unidade = c.cod_unidade
                      and a.cod_cliente = c.cod_cliente
                      and a.dta_vencimento < c.dta_agendamento
                      and a.cod_emp = :cod_emp
                      and a.cod_unidade = :cod_unidade
                      and ind_prestacao = 0
                      and vlr_prestacao >= :vlr_prox_ini
                      and vlr_prestacao <= :vlr_prox_fim
                      and c.dta_agendamento between :dta_agendamento_ini and :dta_agendamento_fim
                      and extract (month from c.dta_mvto)= extract (month from c.dta_agendamento)
                      and extract (year from c.dta_mvto)= extract (year from c.dta_agendamento)
                      group by a.cod_cliente
                               ,a.dta_vencimento
                               ,a.qtd_parcelas
                               ,a.tip_plano_vp
                               ,a.num_parcela
                               ,a.vlr_prestacao
                               ,a.cod_contrato
                               ,a.dta_venda
                               ,a.cod_compl
                               ,c.dta_agendamento
                      having min (extract (month from a.dta_vencimento)) = extract (month from c.dta_agendamento)
                      into :cod_cliente,:dta_vencimento,:qtd_parcelas,:tip_plano_vp,
                           :num_parcela,:vlr_prestacao,:cod_contrato,:dta_venda,:cod_compl,:dta_agendamento do
                  begin
                       for select a.des_cliente
                                  ,a.dta_cadastro
                                  ,a.des_telefone
                                  ,d.des_fone_comerc
                                  ,d.des_fone_celular
                                  ,d.des_fone_celular2
                                  ,b.qtd_compras_vp
                                  ,b.qtd_maior_atraso
                                  ,b.num_mda
                                  ,b.cod_perfil_cli,
                                  case
                                      when a.tip_pessoa = 1 then
                                           substring((lpad(a.cod_cliente,11,'0')) from 1 for 3)||'.***.***-'||
                                           substring((lpad(a.cod_cliente,11,'0')) from 10 for 11)
                                      when a.tip_pessoa = 2 then
                                           substring((lpad(a.cod_cliente,14,'0')) from 1 for 2)||
                                           '.***.***/****-'||
                                           substring((lpad(a.cod_cliente,14,'0')) from 13 for 14)
                                      else
                                          a.cod_cliente
                                  end as cpf_escondido
                           from cre_clientes a
                                ,cre_clientes_cr d
                                ,cre_saldos_cli b
                           where a.cod_emp = d.cod_emp
                           and a.cod_cliente = d.cod_cliente
                           and a.cod_emp = b.cod_emp
                           and a.cod_cliente = b.cod_cliente
                           and b.qtd_compras_vp >= :nro_compra_ini
                           and b.qtd_compras_vp <= :nro_compra_fim
                           and a.cod_emp = :cod_emp
                           and a.cod_cliente = :cod_cliente
                           and b.num_mda >= :mda_ini
                           and b.num_mda <= :mda_fim
                           and b.cod_perfil_cli >= :perfil_ini
                           and b.cod_perfil_cli <= :perfil_fim
                           into :des_cliente,:dta_cadastro,:des_fone_resid,:des_fone_comerc,:des_fone_celular,:des_fone_celular2,
                                :qtd_compras_vp,:qtd_maior_atraso,:num_mda, :cod_perfil_cli,:cpf_escondido do
                       begin
                            for select des_telefone
                                from cre_pessoa_autorizada
                                where cod_emp = :cod_emp
                                and cod_cliente = :cod_cliente
                                into :des_fone_aut do
                            begin
                                 if (cod_cliente = cod_cliente_ant) then
                                 begin
                                      dta_venc_ordem = dta_venc_ordem;
                                 end
                                 else
                                 begin
                                      dta_venc_ordem = dta_vencimento;
                                      cod_cliente_ant = cod_cliente;
                                 end
                                 contador = 0;
                                 begin
                                      select count(1)
                                      from cre_contas_receber
                                      where cod_emp = :cod_emp
                                      and cod_cliente = :cod_cliente
                                      and cod_contrato = :cod_contrato
                                      and dta_vencimento < :dta_agendamento
                                      and ind_prestacao = 0
                                      into :contador;
                                      when sqlcode -104 do
                                           contador = 0;
                                 end
                                 if (contador = 1) then
                                 begin
                                      suspend;
                                 end
                                 else
                                 begin
                                      cod_cliente_ant = 0;
                                 end
                            end
                       end
                  end
             end
             else
                 if (iorder = 4) then /* mda */
                 begin
                      for select a.cod_cliente
                                 ,a.dta_vencimento
                                 ,a.qtd_parcelas
                                 ,a.tip_plano_vp
                                 ,a.num_parcela
                                 ,a.vlr_prestacao
                                 ,a.cod_contrato
                                 ,a.dta_venda
                                 ,a.cod_compl
                                 ,c.dta_agendamento
                          from cre_contas_receber a,cre_cli_agenda c
                          where a.cod_emp = c.cod_emp
                          and a.cod_unidade = c.cod_unidade
                          and a.cod_cliente = c.cod_cliente
                          and a.dta_vencimento < c.dta_agendamento
                          and a.cod_emp = :cod_emp
                          and a.cod_unidade = :cod_unidade
                          and ind_prestacao = 0
                          and vlr_prestacao >= :vlr_prox_ini
                          and vlr_prestacao <= :vlr_prox_fim
                          and c.dta_agendamento between :dta_agendamento_ini and :dta_agendamento_fim
                          and extract (month from c.dta_mvto)= extract (month from c.dta_agendamento)
                          and extract (year from c.dta_mvto)= extract (year from c.dta_agendamento)
                          group by a.cod_cliente
                                   ,a.dta_vencimento
                                   ,a.qtd_parcelas
                                   ,a.tip_plano_vp
                                   ,a.num_parcela
                                   ,a.vlr_prestacao
                                   ,a.cod_contrato
                                   ,a.dta_venda
                                   ,a.cod_compl
                                   ,c.dta_agendamento
                          having min (extract (month from a.dta_vencimento)) = extract (month from c.dta_agendamento)
                          into :cod_cliente,:dta_vencimento,:qtd_parcelas,:tip_plano_vp,
                               :num_parcela,:vlr_prestacao,:cod_contrato,:dta_venda,:cod_compl,:dta_agendamento do
                      begin
                           for select a.des_cliente
                                      ,a.dta_cadastro
                                      ,a.des_telefone
                                      ,d.des_fone_comerc
                                      ,d.des_fone_celular
                                      ,d.des_fone_celular2
                                      ,b.qtd_compras_vp
                                      ,b.qtd_maior_atraso
                                      ,b.num_mda
                                      ,b.cod_perfil_cli,
                                      case
                                          when a.tip_pessoa = 1 then
                                               substring((lpad(a.cod_cliente,11,'0')) from 1 for 3)||'.***.***-'||
                                               substring((lpad(a.cod_cliente,11,'0')) from 10 for 11)
                                          when a.tip_pessoa = 2 then
                                               substring((lpad(a.cod_cliente,14,'0')) from 1 for 2)||
                                               '.***.***/****-'||
                                               substring((lpad(a.cod_cliente,14,'0')) from 13 for 14)
                                          else
                                              a.cod_cliente
                                      end as cpf_escondido
                               from cre_clientes a
                                    ,cre_clientes_cr d
                                    ,cre_saldos_cli b
                               where a.cod_emp = d.cod_emp
                               and a.cod_cliente = d.cod_cliente
                               and a.cod_emp = b.cod_emp
                               and a.cod_cliente = b.cod_cliente
                               and b.qtd_compras_vp >= :nro_compra_ini
                               and b.qtd_compras_vp <= :nro_compra_fim
                               and a.cod_emp = :cod_emp
                               and a.cod_cliente = :cod_cliente
                               and b.num_mda >= :mda_ini
                               and b.num_mda <= :mda_fim
                               and b.cod_perfil_cli >= :perfil_ini
                               and b.cod_perfil_cli <= :perfil_fim
                               into :des_cliente,:dta_cadastro,:des_fone_resid,:des_fone_comerc,:des_fone_celular,:des_fone_celular2,
                                    :qtd_compras_vp,:qtd_maior_atraso,:num_mda,:cod_perfil_cli,:cpf_escondido do
                           begin
                                for select des_telefone
                                    from cre_pessoa_autorizada
                                    where cod_emp = :cod_emp
                                    and cod_cliente = :cod_cliente
                                    into :des_fone_aut do
                                begin
                                     contador = 0;
                                     begin
                                          select count(1)
                                          from cre_contas_receber
                                          where cod_emp = :cod_emp
                                          and cod_cliente = :cod_cliente
                                          and cod_contrato = :cod_contrato
                                          and dta_vencimento < :dta_agendamento
                                          and ind_prestacao = 0
                                          into :contador;
                                          when sqlcode -104 do
                                               contador = 0;
                                     end
                                     if (contador = 1) then
                                     begin
                                          suspend;
                                     end
                                end
                           end
                      end
                 end
end ^

set term ; ^
commit work;
set autoddl on;