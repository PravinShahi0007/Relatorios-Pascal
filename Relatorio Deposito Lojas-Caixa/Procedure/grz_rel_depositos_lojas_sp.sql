create or replace procedure grz_rel_depositos_lojas_sp (pi_opcao in varchar2)
is
begin
     declare
            /* Parametros de entrada */
            v_result         integer;
            v_cur            integer;
            /* Variaveis definidas pela "quebra" do parametro de entrada */
            pi_grupo_ini     number;
            pi_uni_ini       number;
            pi_uni_fim       number;
            pi_data_ini      date;
            pi_data_fim      date;
            pi_conta         varchar2(50);
            pi_agencia       varchar2(50);
            pi_minutos_dif   number;
            pi_usuario       varchar2(50);

            /* Variaveis de trabalho */
            wi               number;
            wf               number;
            wcod_grupo       number(5);
            wdes_grupo       varchar2(50);
            wcod_quebra      number(5);
            wdes_quebra      varchar2(50);
            wcod_unidade     number(5);
            wdes_unidade     varchar2(50);
            wdtahoraant      date;
            wdiferenca       number;
            wseqdeposito     number;
            wvlrsomadeposito number(18,2);
            wcod_unidade_ant number(5);

            saida            exception;

            cursor c_mvto is
                   select a.cod_caixa cod_unidade,
                          a.dta_mvto_caixa dta_caixa,
                          a.cod_operacao,
                          a.cod_conta_cb cod_conta,
                          b.des_conta des_conta,
                          c.num_agencia num_agencia,
                          a.num_doc_caixa num_doc_deposito,
                          a.dta_doc_origem dta_hora_deposito,
                          trunc(a.dta_doc_origem) dta_deposito,
                          to_char(a.dta_doc_origem,'hh24:mi:ss') hor_deposito,
                          nvl(a.vlr_saida,0) vlr_deposito,
                          d.vlr_deposito as vlr_dep_banco,
                          d.num_documento as num_documento_banco
                   from cx_movimentos a,
                        cb_contas b,
                        ps_contas_bancos c,
                        grz_conc_depbancarios d
                   where a.cod_conta_cb = b.cod_conta
                   and a.cod_caixa = c.cod_pessoa(+)
                   and a.cod_emp = 1
                   and a.cod_caixa >= pi_uni_ini
                   and a.cod_caixa <= pi_uni_fim
                   and a.dta_mvto_caixa >= pi_data_ini
                   and a.dta_mvto_caixa <= pi_data_fim

                   and a.cod_caixa = d.cod_unidade(+)
                   and a.dta_mvto_caixa = d.dta_caixa_loja(+)
                   and a.num_doc_caixa = d.num_documento_lj(+)
                   and a.num_lancamento = d.num_lancamento_lj(+)
                   --and a.cod_operacao = d.cod_operacao
                   --and a.dta_mvto_caixa = d.dta_caixa_loja
                   --and a.num_lancamento = d.num_lancamento_lj
                   --and a.cod_unidade = d.cod_unidade(+)
                   --and a.num_doc_caixa = d.num_documento_lj(+)

                   and (instr(','||pi_conta||',' , ','||a.cod_conta_cb||',') > 0)
                   and nvl(a.vlr_saida,0) > 0
                   and (0=pi_agencia or (instr(','||pi_agencia||',' , ','||c.num_agencia||',') > 0))
                   and exists (select 1
                               from ge_grupos_unidades ge
                               where ge.cod_emp = 1
                               and ge.cod_unidade = a.cod_caixa
                               and ge.cod_grupo = pi_grupo_ini)
                   order by a.cod_caixa,a.dta_doc_origem;
                   r_mvto c_mvto%rowtype;

     /* Inicio da procedure principal */
     begin
          v_cur := dbms_sql.open_cursor;
          dbms_sql.parse(v_cur,'alter session set nls_date_format= "dd/mm/rrrr"',dbms_sql.native);
          v_result := dbms_sql.execute(v_cur);
          dbms_sql.close_cursor(v_cur);

          /* Desmembra a opcao recebida */
          wi := instr(pi_opcao, '#', 1, 1);
          pi_grupo_ini := to_number(substr(pi_opcao, 1,(wi-1)));
          wf := instr(pi_opcao, '#', 1, 2);
          pi_uni_ini := to_number(substr(pi_opcao,(wi+1),(wf-wi-1)));
          wi := wf;
          wf := instr(pi_opcao, '#', 1, 3);
          pi_uni_fim := to_number(substr(pi_opcao,(wi+1),(wf-wi-1)));
          wi := wf;
          wf := instr(pi_opcao, '#', 1, 4);
          pi_data_ini := to_date(substr(pi_opcao,(wi+1),(wf-wi-1)));
          wi := wf;
          wf := instr(pi_opcao, '#', 1, 5);
          pi_data_fim := to_date(substr(pi_opcao,(wi+1),(wf-wi-1)));
          wi := wf;
          wf := instr(pi_opcao, '#', 1, 6);
          pi_conta := substr(pi_opcao,(wi+1),(wf-wi-1));
          wi := wf;
          wf := instr(pi_opcao, '#', 1, 7);
          pi_agencia := substr(pi_opcao,(wi+1),(wf-wi-1));
          wi := wf;
          wf := instr(pi_opcao, '#', 1, 8);
          pi_minutos_dif := to_number(substr(pi_opcao,(wi+1),(wf-wi-1)));
          wi := wf;
          wf := instr(pi_opcao, '#', 1, 9);
          pi_usuario := substr(pi_opcao,(wi+1),(wf-wi-1));

          delete from grzw_rel_depositos_lojas
          where upper(des_usuario) = upper(pi_usuario);
          commit;

          wdtahoraant := '01/01/1001';
          wseqdeposito := 0;
          wcod_unidade_ant := 0;
          wvlrsomadeposito:= 0;

          open c_mvto;
          fetch c_mvto into r_mvto;
          while c_mvto%found loop
          begin
               if wcod_unidade_ant <> r_mvto.cod_unidade then
                  begin
                       wvlrsomadeposito:= 0;
                       wseqdeposito := 0;
                  end;
               end if;

               begin
                    select gu.cod_grupo,
                           decode(gu.cod_grupo,910,'GRAZZIOTIN',
                                               920,'ARRAZO',
                                               930,'PORMENOS',
                                               940,'FRANCO GIORGI',
                                               950,'TOTTAL',
                                               960,'VIA RAQUELLE',
                                               970,'GZT STORE',
                                               7000,'ADM - COORPORACAO','') des_grupo,
                           gu.cod_quebra,
                           gq.des_grupo des_quebra,
                           gu.cod_unidade,
                           ps.des_fantasia des_unidade
                    into wcod_grupo,
                         wdes_grupo,
                         wcod_quebra,
                         wdes_quebra,
                         wcod_unidade,
                         wdes_unidade
                    from ge_grupos_unidades gu, ge_grupos gq, ps_pessoas ps
                    where gu.cod_emp = gq.cod_emp
                    and gu.cod_quebra = gq.cod_grupo
                    and gu.cod_unidade = ps.cod_pessoa
                    and gu.cod_unidade = r_mvto.cod_unidade
                    and gu.cod_grupo in (910,920,930,940,950,960,970,7000);
                    exception
                             when no_data_found then
                                  wcod_grupo   := 99999;
                                  wdes_grupo   := 'NAO ENCONTRADO';
                                  wcod_quebra  := 99999;
                                  wdes_quebra  := 'NAO ENCONTRADO';
                                  wcod_unidade := 99999;
                                  wdes_unidade := 'NAO ENCONTRADO';
               end;

               if pi_minutos_dif > 0 then
                  if wdtahoraant <> '01/01/1001' then
                     wdiferenca := (round(r_mvto.dta_hora_deposito - wdtahoraant,4) * 1440);
                  else
                      wdiferenca := 9999;
                  end if;

                  if wdiferenca > pi_minutos_dif then
                     wseqdeposito := wseqdeposito + 1;
                     wvlrsomadeposito := r_mvto.vlr_deposito;
                  else
                      wvlrsomadeposito := wvlrsomadeposito + r_mvto.vlr_deposito;
                  end if;
               end if;

               insert into grzw_rel_depositos_lojas
                           (des_usuario,cod_grupo,des_grupo,
                            cod_quebra,des_quebra,cod_unidade,
                            des_unidade,dta_caixa,cod_operacao,
                            cod_conta,des_conta,num_agencia,
                            num_doc_deposito,dta_deposito,hor_deposito,
                            vlr_deposito,ind_dif_hora,vlr_soma_deposito,
                            vlr_deposito_banco,num_doc_dep_banco)
                      values (pi_usuario,wcod_grupo,wdes_grupo,
                              wcod_quebra,wdes_quebra,r_mvto.cod_unidade,
                              wdes_unidade,r_mvto.dta_caixa,r_mvto.cod_operacao,
                              r_mvto.cod_conta,r_mvto.des_conta,r_mvto.num_agencia,
                              r_mvto.num_doc_deposito,r_mvto.dta_deposito,r_mvto.hor_deposito,
                              r_mvto.vlr_deposito,wseqdeposito,wvlrsomadeposito,
                              r_mvto.vlr_dep_banco,r_mvto.num_documento_banco);

               wDtaHoraAnt := r_mvto.dta_hora_deposito;
               wCod_Unidade_Ant := r_mvto.cod_unidade;
          end;
          fetch c_mvto into r_mvto;
          end loop;
          close c_mvto;
          commit;
     end;
end grz_rel_depositos_lojas_sp;