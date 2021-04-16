/*------------------------------------------------------------------------
  Procedure.: grz_gera_bonus_aniversario_sp
  Empresa...: Grazziotin S/A
  Finalidade: Gera e grava bonus do cliente
              APP Clientes)

  Responsavel Data     Operacao  Descricao
  Antonio     ABR/2021 Alteracao Gravacao da data de insercao
                                 (dta_insert)
------------------------------------------------------------------------*/
create or replace procedure grz_gera_bonus_aniversario_sp is
begin
     declare
            wCod_Emp          grz_controle_bonus.cod_emp%type;
            wCod_Bonus        grz_controle_bonus.cod_bonus%type;
            wInd_Status       grz_controle_bonus.ind_status%type;
            wCod_Lote         grz_controle_bonus.cod_lote%type;
            wCod_Cliente      grz_controle_bonus.cod_cliente%type;
            wNum_CPF_Cnpj     grz_controle_bonus.num_cpf_cnpj%type;
            wDta_Validade_Ret grz_controle_bonus.dta_validade_ret%type;
            wVlr_Bonus        grz_controle_bonus.vlr_bonus%type;
            wDta_Sistema      grz_controle_bonus.dta_sistema%type;
            -- variaveis para selecionar clientes
            wMDA                 Number;
            wQtdCompras          Number;
            wAtrasAtual          Number;
            wDataAniversario     Date;
            wQtdBonusParaCliente Number;
            wControle            Number;
            Saida                exception;

            -- declaracao de cursores
            cursor c_unidades is
                   select distinct (a.cod_grupo) cod_grupo
                   from ge_grupos_unidades a
                   where a.cod_emp = 1
                   and a.cod_grupo in (1912,1932,1942,1952)
                   order by a.cod_grupo;
            r_unidades c_unidades%rowtype;

            cursor c_pessoas is
                   select distinct psfis.dta_nasc, psfis.num_cpf
                   from ps_perfis psper, ps_mascaras psmas, ps_pessoas pspes,
                        ps_cartoes pscar, ps_clientes pscli, ps_fisicas psfis
                   where psmas.cod_pessoa = psper.cod_pessoa
                   and pspes.cod_pessoa = psper.cod_pessoa
                   and pscar.cod_pessoa = psper.cod_pessoa
                   and pscli.cod_pessoa = psper.cod_pessoa
                   and psfis.cod_pessoa = psper.cod_pessoa
                   and psper.cod_pessoa is not null
                   and psmas.cod_mascara = 50
                   and psmas.cod_niv1 = wCod_Emp
                   and pspes.ind_inativo = 0
                   and not exists(select 1
                                  from ps_fisicas a,ps_pessoas b
                                  where pspes.cod_pessoa = a.cod_pessoa
                                  and a.num_cpf = b.des_email_cel
                                  and b.cod_atividade = 99
                                  and b.dta_afastamento is null)
                   and not exists (select 1
                                   from v_dados_pessoa@grzfolha a
                                   where cpf = psfis.num_cpf
                                   and dta_demissao is null)
                   and nvl(pspes.cod_bloq,0) < 10
                   and pscar.cod_situacao < 4
                   and nvl(qtd_compras_prazo,0) >= wQtdCompras
                   and psper.dta_ult_compra >= to_date(add_months(sysdate,-12))
                   and exists(select 1
                              from ge_grupos_unidades ge
                              where pscli.cod_unidade=ge.cod_unidade
                              and ge.cod_emp=1
                              and ge.cod_grupo=r_unidades.cod_grupo)
                   and nvl(psper.vlr_pago_mda,0) > 0
                   and psper.vlr_pago_ref_mda/psper.vlr_pago_mda <= wMDA
                   and psper.qtd_maior_atraso_atual = wAtrasAtual
                   and to_char(psfis.dta_nasc,'DD') = to_number(to_char(wDataAniversario,'DD'))
                   and to_char(psfis.dta_nasc,'MM') = to_number(to_char(wDataAniversario,'MM'));
            r_pessoas c_pessoas%rowtype;

            cursor c_pessoas_cia is
                   select distinct psfis.dta_nasc, psfis.num_cpf
                   from ps_perfis psper, ps_pessoas pspes,
                        ps_cartoes pscar, ps_clientes pscli, ps_fisicas psfis
                   where pspes.cod_pessoa = psper.cod_pessoa
                   and pscar.cod_pessoa = psper.cod_pessoa
                   and pscli.cod_pessoa = psper.cod_pessoa
                   and psfis.cod_pessoa = psper.cod_pessoa
                   and psper.cod_pessoa is not null
                   and psper.dta_ult_compra >= to_date(add_months(sysdate,-12))
                   and pspes.ind_inativo = 0
                   and not exists(select 1
                                  from ps_fisicas a,ps_pessoas b
                                  where pspes.cod_pessoa = a.cod_pessoa
                                  and a.num_cpf = b.des_email_cel
                                  and b.cod_atividade = 99
                                  and b.dta_afastamento is null)
                   and not exists (select 1
                                   from v_dados_pessoa@grzfolha a
                                   where cpf = psfis.num_cpf
                                   and dta_demissao is null)
                   and nvl(pspes.cod_bloq,0) < 10
                   and pscar.cod_situacao < 4
                   and pscli.cod_classe_venda = 10
                   and nvl(qtd_compras_prazo,0) >= wQtdCompras
                   and exists(select 1
                              from ge_grupos_unidades ge
                              where pscli.cod_unidade=ge.cod_unidade
                              and ge.cod_emp=1
                              and ge.cod_grupo=970)
                   and nvl(psper.vlr_pago_mda,0) > 0
                   and psper.vlr_pago_ref_mda/psper.vlr_pago_mda <= wMDA
                   and psper.qtd_maior_atraso_atual = wAtrasAtual
                   and to_char(psfis.dta_nasc,'DD') = to_number(to_char(wDataAniversario,'DD'))
                   and to_char(psfis.dta_nasc,'MM') = to_number(to_char(wDataAniversario,'MM'));
            r_pessoas_cia c_pessoas_cia%rowtype;
     /*------------------------------------------------------------------------------------------*/ 
     /* Inicio da procedure principal                                                            */
     /*------------------------------------------------------------------------------------------*/
     begin
          -- variaveis para todas as redes
          wMDA             := 10;
          wQtdCompras      := 1;
          wAtrasAtual      := 0;
          wDataAniversario := trunc(sysdate + 7);

          open c_unidades;
          fetch c_unidades into r_unidades;
          while c_unidades%found loop
          begin
               wDta_Sistema := sysdate;
               wInd_Status  := 1;

               case r_unidades.cod_grupo
                   when 1912 then
                        wCod_Emp             := 10;
                        wCod_Lote            := 9910;
                        wVlr_Bonus           := 10;
                        wQtdBonusParaCliente := 1;
                   when 1932 then
                        wCod_Emp             := 30;
                        wCod_Lote            := 9930;
                        wVlr_Bonus           := 5;
                        wQtdBonusParaCliente := 2;
                   when 1942 then
                        wCod_Emp             := 40;
                        wCod_Lote            := 9940;
                        wVlr_Bonus           := 50;
                        wQtdBonusParaCliente := 1;
                   when 1952 then
                        wCod_Emp             := 50;
                        wCod_LOTE            := 9950;
                        wVlr_Bonus           := 10;
                        wQtdBonusParaCliente := 1;
               end case;

               /*if r_unidades.cod_grupo = 1912 then
                  -- variaveis por rede
                  wCOD_EMP     := 10;
                  wCOD_LOTE    := 9910;
                  wVLR_BONUS   := 10;
                  wQtdBonusParaCliente := 1;
               elsif r_unidades.cod_grupo = 1932 then
                     wCOD_EMP     := 30;
                     wCOD_LOTE    := 9930;
                     wVLR_BONUS   := 5;
                     wQtdBonusParaCliente := 2;
               elsif r_unidades.cod_grupo = 1942 then
                     wCOD_EMP     := 40;
                     wCOD_LOTE    := 9940;
                     wVLR_BONUS   := 50;
                     wQtdBonusParaCliente := 1;
               elsif r_unidades.cod_grupo = 1952 then
                     wCOD_EMP     := 50;
                     wCOD_LOTE    := 9950;
                     wVLR_BONUS   := 10;
                     wQtdBonusParaCliente := 1;
               end if;*/

               open c_pessoas;
               fetch c_pessoas into r_pessoas;
               while c_pessoas%found loop
               begin
                    wCod_Cliente := r_pessoas.num_cpf;
                    wNum_CPF_CNPJ := r_pessoas.num_cpf;
                    wDta_Validade_Ret := trunc(add_months(wDataAniversario,1));  -- um mês de validade
                    wControle := 1;

                    while wControle <= wQtdBonusParaCliente loop -- while pq a pormenos gera dois bônus por cliente
                    begin
                         begin
                              select nvl(max(cod_bonus),0) + 1
                                     into wcod_bonus
                                     from grz_controle_bonus
                                     where cod_emp  = wcod_emp
                                     and cod_lote = wcod_lote;
                               exception
                                        when no_data_found then
                                             wcod_bonus := 0;
                         end;

                         if wCod_Bonus > 0 then
                         begin
                              if wInd_Status = 1 then -- tipo movimento = 1, insere data insercao
                                 insert into grz_controle_bonus (cod_emp,cod_bonus,ind_status,
                                                                 cod_lote,cod_cliente,num_cpf_cnpj,
                                                                 dta_validade_ret,vlr_bonus,dta_sistema,
                                                                 dta_insert)
                                 values (wCod_Emp,wCod_Bonus,wInd_Status,
                                         wCod_Lote,wCod_Cliente,wNum_CPF_CNPJ,
                                         wDta_Validade_Ret,wVlr_Bonus,wDta_Sistema,
                                         wDta_Sistema);
                              else -- tipo movimento <> 1, data insercao fica nula
                                  insert into grz_controle_bonus (cod_emp,cod_bonus,ind_status,
                                                                  cod_lote,cod_cliente,num_cpf_cnpj,
                                                                  dta_validade_ret,vlr_bonus,dta_sistema)
                                  values (wCod_Emp,wCod_Bonus,wInd_Status,
                                          wCod_Lote,wCod_Cliente,wNum_CPF_CNPJ,
                                          wDta_Validade_Ret,wVlr_Bonus,wDta_Sistema);
                              end if; -- wInd_Status = 1
                         end;
                         end if;
                         wControle := wControle + 1;
                    end;
                    end loop; -- wControle <= wQtdBonusParaCliente
               end;
               fetch c_pessoas into r_pessoas;
               end loop; -- c_pessoas%found loop
               close c_pessoas;

               commit;
          end;
          fetch c_unidades into r_unidades;
          end loop; -- c_unidades%found loop
          close c_unidades;

          wCod_Emp   := 70;
          wCod_Lote  := 9970;
          wVlr_Bonus := 10;
          -- execução da cia separada pq o cliente ganha um bônus apenas
          open c_pessoas_cia;
          fetch c_pessoas_cia into r_pessoas_cia;
          while c_pessoas_cia%found loop
          begin
               wCod_Cliente      := r_pessoas_cia.num_cpf;
               wNum_CPF_CNPJ     := r_pessoas_cia.num_cpf;
               wDta_Validade_Ret := trunc(add_months(wDataAniversario,1));  -- um mês de validade
               begin
                    select nvl(max(cod_bonus),0) + 1
                           Into wCod_Bonus
                           from grz_controle_bonus
                           where cod_emp = wCod_Emp
                           and cod_lote = wCod_Lote;
                    exception
                             when no_data_found then
                                  wCod_Bonus := 0;
               end;

               if wCod_Bonus > 0 then
               begin
                    if wInd_Status = 1 then -- tipo movimento = 1, insere data insercao
                       insert into grz_controle_bonus (cod_emp,cod_bonus,ind_status,
                                                       cod_lote,cod_cliente,num_cpf_cnpj,
                                                       dta_validade_ret,vlr_bonus,dta_sistema,
                                                       dta_insert)
                       values (wCod_Emp,wCod_Bonus,wInd_Status,
                               wCod_Lote,wCod_Cliente,wNum_CPF_CNPJ,
                               wDta_Validade_Ret,wVlr_Bonus,wDta_Sistema,
                               wDta_Sistema);
                    else -- tipo movimento <> 1, data insercao fica nula
                        insert into grz_controle_bonus (cod_emp,cod_bonus,ind_status,
                                                        cod_lote,cod_cliente,num_cpf_cnpj,
                                                        dta_validade_ret,vlr_bonus,dta_sistema)
                        values (wCod_Emp,wCod_Bonus,wInd_Status,
                                wCod_Lote,wCod_Cliente,wNum_CPF_CNPJ,
                                wDta_Validade_Ret,wVlr_Bonus,wDta_Sistema);
                    end if; -- wInd_Status = 1
               end;
               end if;
          end;
          fetch c_pessoas_cia into r_pessoas_cia;
          end loop; -- c_pessoas_cia%found loop
          close c_pessoas_cia;

          commit;

          exception
                   when Saida then
                        null;
     end;
end grz_gera_bonus_aniversario_sp;
