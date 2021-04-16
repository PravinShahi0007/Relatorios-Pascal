/*--------------------------------------------------------------------------------
  Trigger...: trigger grz_mvto_bonus_tg
  Empresa...: Grazziotin S/A
  Finalidade: Atualizar os valores na tabela controle bonus (grz_controle_bonus)
              por meio das operacoes na tabela movimento bonus (grz_mvto_bonus)

  Responsavel Data     Operacao  Descricao
  Antonio     ABR/2021 Alteracao Programacao da data de insercao dos valores
                                 (dta_insert) na tabela de controle bonus
                                 (grz_controle_bonus)
-----------------------------------------------------------------------------------*/
create or replace trigger grz_mvto_bonus_tg
after insert or update or delete
on grz_mvto_bonus for each row

begin
     declare
            wCod_Emp       Number;
            wCod_Emp_Orig  Number;
            wCod_Bonus     Number;
            wExiste        Number;
            wSQLCODE       Number;
            wSQLERRM       Varchar2(200);
            wTip_Movimento Number;

     begin
          if inserting then
          begin
               --------------------------------------
               -- Tabela grz_controle_bonus        --
               --------------------------------------
               wCod_Emp_Orig := :new.Cod_Emp_Orig;

               wExiste := 0; -- para execucao de insercao (1) ou update (0)
               begin
                    select cod_emp,cod_bonus,ind_status
                           into wCod_Emp,wCod_Bonus,wTip_Movimento
                           from grz_controle_bonus
                           where cod_emp = wCod_Emp_Orig
                           and cod_bonus = :new.cod_bonus
                           and cod_lote  = :new.cod_lote;
                    exception
                             when no_data_found then
                                  wCod_Emp       := 0;
                                  wCod_Bonus     := 0;
                                  wTip_Movimento := 0;
                                  wExiste        := 1;
               end;

               if wExiste = 1 then -- insercao
               begin
                    -- Se o tipo de movimento for 1, grava da data insert,
                    -- caso contrario, deixa a data nula
                    if :new.tip_movimento = 1 then
                    begin
                         insert into grz_controle_bonus 
                                (cod_emp,cod_bonus,ind_status,cod_lote,cod_cliente,
                                 num_cpf_cnpj,dta_validade_ret,vlr_bonus,dta_insert)
                         values (:new.cod_emp,:new.cod_bonus,:new.tip_movimento,:new.cod_lote,:new.cod_cliente,
                                 :new.num_cpf_cnpj,:new.dta_validade_bonus,:new.vlr_bonus,:new.dta_movimento);
                         exception
                                  when others then
                                       wSQLCODE := SQLCODE;
                                       wSQLERRM := SQLERRM;
                    end;
                    else
                    begin -- deixa data insert nula, movimento diferente de 1
                         insert into grz_controle_bonus 
                                (cod_emp,cod_bonus,ind_status,cod_lote,cod_cliente,
                                 num_cpf_cnpj,dta_validade_ret,vlr_bonus)
                         values (:new.cod_emp,:new.cod_bonus,:new.tip_movimento,:new.cod_lote,:new.cod_cliente,
                                 :new.num_cpf_cnpj,:new.dta_validade_bonus,:new.vlr_bonus);
                         exception
                                  when others then
                                       wSQLCODE := SQLCODE;
                                       wSQLERRM := SQLERRM;
                    end;
                    end if; -- :new.tip_movimento = 1
               end;
               else -- alteracao
                   if :new.tip_movimento <> 3 then -- cancelados na loja
                   begin
                        update grz_controle_bonus
                               set num_cpf_cnpj = :new.num_cpf_cnpj,
                                   dta_validade_ret = :new.dta_validade_bonus,
                                   vlr_bonus = :new.vlr_bonus
                               where cod_emp       = wCod_Emp_Orig
                                     and cod_bonus = :new.cod_bonus
                                     and cod_lote  = :new.cod_lote;
                        exception
                                 when others then
                                      wSQLCODE := SQLCODE;
                                      wSQLERRM := SQLERRM;
                   end;

                   begin -- Se tipo movimento 1, atualiza a data insert com a data movimento
                        if :new.tip_movimento = 1 then
                        begin
                             update grz_controle_bonus
                                    set ind_status  = :new.tip_movimento,
                                        dta_sistema = sysdate,
                                        dta_insert  = :new.dta_movimento
                                    where cod_emp   = wCod_Emp_Orig
                                    and cod_bonus   = :new.cod_bonus
                                    and cod_lote    = :new.cod_lote
                                    and ind_status <= :new.tip_movimento;
                             exception
                                      when others then
                                           wSQLCODE := SQLCODE;
                                           wSQLERRM := SQLERRM;
                        end;
                        else
                        begin -- nao atualiza data insert, movimento diferente de 1
                             update grz_controle_bonus
                                    set ind_status  = :new.tip_movimento,
                                        dta_sistema = sysdate
                                    where cod_emp   = wCod_Emp_Orig
                                    and cod_bonus   = :new.cod_bonus
                                    and cod_lote    = :new.cod_lote
                                    and ind_status <= :new.tip_movimento;
                             exception
                                      when others then
                                           wSQLCODE := SQLCODE;
                                           wSQLERRM := SQLERRM;
                        end;
                        end if; -- :new.tip_movimento = 1
                   end;
                   end if; -- :new.tip_movimento <> 3
               end if; -- wExiste = 1
          end;
          elsif updating then
          begin
               --------------------------------------
               -- Tabela grz_controle_bonus        --
               --------------------------------------
               wCod_Emp_Orig := :old.Cod_Emp_Orig;

               delete from grz_controle_bonus
                      where cod_emp  = wcod_emp_orig
                      and cod_bonus  = :old.cod_bonus
                      and cod_lote   = :old.cod_lote
                      and ind_status = :old.tip_movimento;
               exception
                        when others then
                             wSQLCODE := SQLCODE;
                             wSQLERRM := SQLERRM;

               --------------------------------------
               -- Tabela grz_controle_bonus        --
               --------------------------------------
               wCod_Emp_Orig := :new.Cod_Emp_Orig;

               wExiste := 0; --para execucao de insercao ou update
               begin
                    select cod_emp,cod_bonus,ind_status
                           into wCod_Emp,wCod_Bonus,wTip_Movimento
                           from grz_controle_bonus
                           where cod_emp = wCod_Emp_Orig
                           and cod_bonus = :new.cod_bonus
                           and cod_lote  = :new.cod_lote;
                    exception
                             when no_data_found then
                                  wCod_Emp   := 0;
                                  wCod_Bonus := 0;
                                  wTip_Movimento := 0;
                                  wExiste    := 1;
               end;

               if wExiste = 1 then -- insercao
               begin
                    -- Se o tipo de movimento for 1, grava da data insert,
                    -- caso contrario, deixa a data nula
                    if :new.tip_movimento = 1 then
                    begin
                         insert into grz_controle_bonus 
                                (cod_emp,cod_bonus,ind_status,cod_lote,cod_cliente,
                                 num_cpf_cnpj,dta_validade_ret,vlr_bonus,dta_insert)
                         values (:new.cod_emp,:new.cod_bonus,:new.tip_movimento,:new.cod_lote,:new.cod_cliente,
                                 :new.num_cpf_cnpj,:new.dta_validade_bonus,:new.vlr_bonus,:new.dta_movimento);
                         exception
                                  when others then
                                       wSQLCODE := SQLCODE;
                                       wSQLERRM := SQLERRM;
                    end;
                    else
                    begin -- deixa data insert nula, movimento diferente de 1
                         insert into grz_controle_bonus 
                                (cod_emp,cod_bonus,ind_status,cod_lote,cod_cliente,
                                 num_cpf_cnpj,dta_validade_ret,vlr_bonus)
                         values (:new.cod_emp,:new.cod_bonus,:new.tip_movimento,:new.cod_lote,:new.cod_cliente,
                                 :new.num_cpf_cnpj,:new.dta_validade_bonus,:new.vlr_bonus);
                         exception
                                  when others then
                                       wSQLCODE := SQLCODE;
                                       wSQLERRM := SQLERRM;
                    end;
                    end if; -- :new.tip_movimento = 1
               end;
               elsif :new.tip_movimento <> 3 then -- cancelados na loja
                   begin
                        update grz_controle_bonus
                               set cod_lote = :new.cod_bonus,
                                   num_cpf_cnpj = :new.num_cpf_cnpj,
                                   dta_validade_ret = :new.dta_validade_bonus,
                                   vlr_bonus = :new.vlr_bonus
                               where cod_emp = wCod_Emp_Orig
                               and cod_bonus = :new.cod_bonus
                               and cod_lote  = :new.cod_lote;
                        exception
                                 when others then
                                      wSQLCODE := SQLCODE;
                                      wSQLERRM := SQLERRM;
                       end;

                   begin -- Se tipo movimento 1, atualiza a data insert com a data movimento
                        if :new.tip_movimento = 1 then
                        begin
                             update grz_controle_bonus
                                    set ind_status  = :new.tip_movimento,
                                        dta_sistema = sysdate,
                                        dta_insert  = :new.dta_movimento
                                    where cod_emp   = wCod_Emp_Orig
                                    and cod_bonus   = :new.cod_bonus
                                    and cod_lote    = :new.cod_lote
                                    and ind_status <= :new.tip_movimento;
                             exception
                                      when others then
                                           wSQLCODE := SQLCODE;
                                           wSQLERRM := SQLERRM;
                        end;
                        else
                        begin -- nao atualiza data insert, movimento diferente de 1
                             update grz_controle_bonus
                                    set ind_status  = :new.tip_movimento,
                                        dta_sistema = sysdate
                                    where cod_emp   = wCod_Emp_Orig
                                    and cod_bonus   = :new.cod_bonus
                                    and cod_lote    = :new.cod_lote
                                    and ind_status <= :new.tip_movimento;
                             exception
                                      when others then
                                           wSQLCODE := SQLCODE;
                                           wSQLERRM := SQLERRM;
                        end;
                        end if; -- :new.tip_movimento = 1
                        /*update grz_controle_bonus 
                               set ind_status  = :new.tip_movimento,
                                   dta_sistema = sysdate
                               where cod_emp   = wCod_Emp_Orig
                               and cod_bonus   = :new.cod_bonus
                               and cod_lote    = :new.cod_lote
                               and ind_status <= :new.tip_movimento;
                        exception
                                 when others then
                                      wSQLCODE := SQLCODE;
                                      wSQLERRM := SQLERRM;*/
                   end;
               end if; -- wExiste = 1
          end; -- updating
          elsif deleting then
          begin
               wCod_Emp_Orig := :old.Cod_Emp_Orig;
               
               if :old.tip_movimento = 2 then
               begin
                    update grz_controle_bonus
                           set ind_status  = 1,
                               dta_sistema = sysdate
                           where cod_emp  = wCod_Emp_Orig
                           and cod_bonus  = :old.cod_bonus
                           and cod_lote   = :old.cod_lote
                           and ind_status = :old.tip_movimento;
                    exception
                             when others then
                                  wSQLCODE := SQLCODE;
                                  wSQLERRM := SQLERRM;
               end;
               elsif :old.tip_movimento <> 3 then -- cancelados na loja
               begin
                    delete from grz_controle_bonus
                           where cod_emp  = wCod_Emp_Orig
                           and cod_bonus  = :old.cod_bonus
                           and cod_lote   = :old.cod_lote
                           and ind_status = :old.tip_movimento;
                    exception
                             when others then
                                  wSQLCODE := SQLCODE;
                                  wSQLERRM := SQLERRM;
               end;
               end if; -- :old.tip_movimento <> 3
          end;
          end if; -- deleting
     end;
end grz_mvto_bonus_tg;
