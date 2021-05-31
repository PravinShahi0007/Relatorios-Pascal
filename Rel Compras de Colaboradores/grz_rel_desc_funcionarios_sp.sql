/*------------------------------------------------------------------------
  Procedure.: grz_rel_desc_funcionarios_sp
  Empresa...: Grazziotin S/A
  Finalidade: Gravar dados para relatorio de compras de funcionarios.

  Autor   Data     Operacao  Descricao
  Antonio MAI/2021 Alteracao Formatacao do codigo-fonte e inclusao do
                             funcionario autorizante da compra.

  Parametros
  pi_Opcao - Parametros da insercao de dados.
------------------------------------------------------------------------*/
create or replace procedure nl.grz_rel_desc_funcionarios_sp (pi_Opcao in varchar2)
is
begin
     declare
            /* Parametros de entrada */
            v_result             integer;
            v_cur                integer;

            pi_grupo             ge_grupos_unidades.cod_grupo%type;
            pi_data_ini          date;
            pi_data_fim          date;
            pi_unidade_ini       ge_grupos_unidades.cod_unidade%type;
            pi_unidade_fim       ge_grupos_unidades.cod_unidade%type;
            pi_codigo_ini        varchar2(15);
            pi_codigo_fim        varchar2(15);
            pi_valor_ini         number(18,2);
            pi_valor_fim         number(18,2);
            pi_usuario           varchar2(30);
            wi                   number;
            wf                   number;
            wdes_autorizante     varchar2(100);
            wcod_pessoa          varchar2(10);
            wcod_niv2            ps_mascaras.cod_niv2%type;
            wdes_grupo           ge_grupos.des_grupo%type;
            wdes_unidade         ge_unidades.des_nome%type;
            wdes_funcionario     ps_pessoas.des_pessoa%type;
            wdes_cliente         ps_pessoas.des_pessoa%type;
            wcod_pessoa_editado  ps_mascaras.cod_editado%type;
            wcod_cliente_editado ps_mascaras.cod_editado%type;
            wperc_desconto       number(5,2);
            wplano               grzw_rel_desc_funcionarios.tip_plano%type;

     cursor c_notas is
            select a.num_seq,
                   a.cod_maquina,
                   a.cod_unidade,
                   a.num_nota,
                   a.cod_serie,
                   a.dta_emissao,
                   a.cod_cliente,
                   a.cod_cliente_milhagem,
                   a.cod_cond_pgto,
                   to_char(a.dth_saida,'HH24:mi:ss') hora_venda,
                   c.cod_editado,
                   oper.vlr_produtos,
                   oper.vlr_operacao,
                   (oper.vlr_desconto - nvl(d.vlr_coluna,0)) vlr_desconto,
                   oper.vlr_acrescimo,
                   c.cod_completo,
                   c.cod_pessoa,
                   a.cod_atendente
            from ns_notas a,
                 (select b.num_seq,
                         b.cod_maquina,
                         sum(nvl(b.vlr_produtos,0)) vlr_produtos,
                         sum(nvl(b.vlr_operacao,0)) vlr_operacao,
                         sum(nvl(b.vlr_desconto1,0)+nvl(b.vlr_desconto2,0)) vlr_desconto,
                         sum(nvl(b.vlr_acrescimo,0)) vlr_acrescimo
                  from ns_notas_operacoes b
                  where cod_oper in (300,302,305,4300,4302,4305)
                  group by b.num_seq, b.cod_maquina) oper,
                  ps_mascaras c,ns_notas_colunas d
            where a.num_seq   = oper.num_seq
            and a.cod_maquina = oper.cod_maquina
            and d.num_seq(+) = a.num_seq
            and d.cod_maquina(+) = a.cod_maquina
            and d.seq_coluna(+) = 32
            and oper.vlr_produtos >= pi_valor_ini
            and oper.vlr_produtos <= pi_valor_fim
            and a.cod_cliente_milhagem = c.cod_pessoa
            and c.cod_mascara = 50
            and c.cod_completo >= pi_codigo_ini
            and c.cod_completo <= pi_codigo_fim
            and exists (select 1 from ge_grupos_unidades ge
                        where a.cod_unidade = ge.cod_unidade
                        and ge.cod_grupo = pi_grupo
                        and ge.cod_unidade >= pi_unidade_ini
                        and ge.cod_unidade <= pi_unidade_fim
                        and ge.cod_emp = 1)
            and to_date(a.dta_emissao,'dd/mm/yyyy') between to_date(pi_data_ini,'dd/mm/yyyy') and
                                                            to_date(pi_data_fim,'dd/mm/yyyy')
            and a.cod_cliente_milhagem is not null;
     r_notas c_notas%rowtype;

     cursor c_temp is
            select distinct(cod_cliente),
                   des_cliente,
                   des_funcionario,
                   cod_funcionario,
                   --des_unidade,
                   des_grupo
            from grzw_rel_desc_funcionarios
            where upper(des_usuario) = upper(pi_usuario);
     r_temp c_temp%rowtype;

     cursor c_devol is
            select a.cod_pessoa_forn,
                   a.num_seq,
                   a.cod_maquina,
                   a.cod_unidade,
                   a.num_nota,
                   a.cod_serie,
                   a.dta_emissao,
                   a.cod_cliente,
                   a.cod_cond_pgto,
                   b.vlr_produtos,
                   b.vlr_operacao,
                   b.vlr_descontos,
                   b.vlr_acre_tn
            from ne_notas a, ne_notas_operacoes b
            where a.num_seq = b.num_seq
            and trunc(a.dta_emissao) between pi_data_ini and pi_data_fim
            and b.cod_oper in (106, 107)
            and a.cod_pessoa_forn = r_temp.cod_cliente;
     r_devol c_devol%rowtype;

     begin
          v_cur := dbms_sql.open_cursor;
          dbms_sql.parse(v_cur,'alter session set nls_date_format= "dd/mm/rrrr"',dbms_sql.native);
          v_result := dbms_sql.execute(v_cur);
          dbms_sql.close_cursor(v_cur);

          v_cur := dbms_sql.open_cursor;
          dbms_sql.parse(v_cur,'alter session set NLS_NUMERIC_CHARACTERS = '',.''',dbms_sql.native);
          v_result := dbms_sql.execute(v_cur);
          dbms_sql.close_cursor(v_cur);

          wi := instr(pi_opcao, '#', 1, 1);
          pi_grupo := to_number(substr(pi_opcao, 1,(wi-1)));
          wf := instr(pi_opcao, '#', 1, 2);
          pi_data_ini := to_date(substr(pi_opcao,(wi+1),(wf-wi-1)));
          wi := wf;
          wf := instr(pi_opcao, '#', 1, 3);
          pi_data_fim := to_date(substr(pi_opcao,(wi+1),(wf-wi-1)));
          wi := wf;
          wf := instr(pi_opcao, '#', 1, 4);
          pi_unidade_ini := to_number(substr(pi_opcao,(wi+1),(wf-wi-1)));
          wi := wf;
          wf := instr(pi_opcao, '#', 1, 5);
          pi_unidade_fim := to_number(substr(pi_opcao,(wi+1),(wf-wi-1)));
          wi := wf;
          wf := instr(pi_opcao, '#', 1, 6);
          pi_codigo_ini := (substr(pi_opcao,(wi+1),(wf-wi-1)));
          wi := wf;
          wf := instr(pi_opcao, '#', 1, 7);
          pi_codigo_fim := (substr(pi_opcao,(wi+1),(wf-wi-1)));
          wi := wf;
          wf := instr(pi_opcao, '#', 1, 8);
          pi_valor_ini := to_number(substr(pi_opcao,(wi+1),(wf-wi-1)));
          wi := wf;
          wf := instr(pi_opcao, '#', 1, 9);
          pi_valor_fim := to_number(substr(pi_opcao,(wi+1),(wf-wi-1)));
          wi := wf;
          wf := instr(pi_opcao, '#', 1, 10);
          pi_usuario := substr(pi_opcao,(wi+1),(wf-wi-1));
          wi := wf;

          pi_Codigo_Ini := '01'||lpad(pi_codigo_ini,8,'0');
          pi_Codigo_Fim := '01'||lpad(pi_codigo_fim,8,'0');

          delete from grzw_rel_desc_funcionarios
          where upper(des_usuario) = upper(pi_usuario);
          commit;

          begin
               select distinct des_grupo
               into wdes_grupo
               from ge_grupos
               where cod_emp = 1
               and cod_grupo = pi_grupo;
               exception
                        when no_data_found then
                             wdes_grupo := 'GRUPO SEM DESCRICAO';
          end;

          open c_notas;
          fetch c_notas into r_notas;
          while c_notas%found loop
          begin
               begin
                    select distinct a.des_nome
                    into wDes_unidade
                    from ge_unidades a
                    where a.cod_emp = 1
                    and a.cod_unidade = r_notas.cod_unidade;
                    exception
                             when no_data_found then
                                  wDes_unidade := 'SEM DESCRICAO';
               end;

               begin
                    select distinct a.des_pessoa
                    into wDes_funcionario
                    from ps_pessoas a
                    where a.cod_pessoa  = r_notas.cod_cliente_milhagem;
                    exception
                             when no_data_found then
                                  wDes_funcionario := 'PESSOA SEM DESCRICAO';
               end;

               begin
                    select distinct a.des_pessoa
                    into wDes_Cliente
                    from ps_pessoas a
                    where a.cod_pessoa = r_notas.cod_cliente;
                    exception
                             when no_data_found then
                                  wDes_Cliente := 'CLIENTE SEM DESCRICAO';
               end;
               wcod_cliente_editado := to_char(r_notas.cod_cliente);
               wcod_pessoa_editado  := r_notas.cod_editado;

               if r_notas.cod_cond_pgto = 1 then
                  wPlano := 'VV';
               else
                   wPlano := 'VP';
               end if;

               -- Seleciona o nome do AUTORIZANTE
               begin
                    select p.des_pessoa, t.cod_niv2
                    into wdes_autorizante,wcod_niv2
                    from ps_mascaras t, ps_pessoas p
                    where t.cod_pessoa = p.cod_pessoa
                    and t.cod_mascara = 50
                    and t.cod_pessoa = r_notas.cod_atendente;
                    exception
                             when no_data_found then
                                  wdes_autorizante := 'AUTORIZANTE NAO ENCONTRADO';
               end;

               if r_notas.vlr_produtos > 0 then
                  wperc_desconto := r_notas.vlr_desconto / r_notas.vlr_produtos * 100;
               else
                   wperc_desconto := 0;
               end if;

               insert into grzw_rel_desc_funcionarios(des_usuario,cod_grupo,des_grupo,
                                                      cod_unidade,des_unidade,cod_funcionario,
                                                      des_funcionario,num_nota,cod_serie,
                                                      dta_emissao,vlr_produtos,vlr_operacao,
                                                      vlr_desconto,vlr_acrescimo,tip_plano,
                                                      cod_cliente,des_cliente,ind_devol,
                                                      hora_venda,des_autorizante,
                                                      perc_desconto)
               values (pi_usuario,pi_grupo,wDes_grupo,
                       r_notas.cod_unidade,wDes_unidade,wCod_pessoa_editado,
                       wDes_funcionario,r_notas.num_nota,r_notas.cod_serie,
                       r_notas.dta_emissao,r_notas.vlr_produtos,r_notas.vlr_operacao,
                       r_notas.vlr_desconto,r_notas.vlr_acrescimo,wPlano,
                       wCod_cliente_editado,wDes_cliente,0,
                       r_notas.hora_venda,wdes_autorizante,wperc_desconto);
          end;
          fetch c_notas into r_notas;
          end loop;
          close c_notas;

          open c_temp;
          loop
              fetch c_temp
              into r_temp;
              exit when c_temp%notfound;

              open c_devol;
              loop
                  fetch c_devol
                  into r_devol;
                  exit when c_devol%notfound;

                  begin
                       select distinct a.des_nome
                       into wdes_unidade
                       from ge_unidades a
                       where a.cod_emp = 1
                       and a.cod_unidade = r_devol.cod_unidade;
                       exception
                                when no_data_found then
                                     wDes_unidade := 'SEM DESCRICAO';
                  end;

                  insert into grzw_rel_desc_funcionarios(des_usuario,cod_grupo,des_grupo,
                                                         cod_unidade,des_unidade,cod_funcionario,
                                                         des_funcionario,num_nota,cod_serie,
                                                         dta_emissao,vlr_produtos,vlr_operacao,
                                                         vlr_desconto,vlr_acrescimo,tip_plano,
                                                         cod_cliente,des_cliente,ind_devol)
                  values (pi_usuario,pi_grupo,r_temp.des_grupo,
                          r_devol.cod_unidade,wdes_unidade,r_temp.cod_funcionario,
                          r_temp.des_funcionario,r_devol.num_nota,null,
                          r_devol.dta_emissao,(r_devol.vlr_produtos * -1),(r_devol.vlr_operacao * -1),
                          (r_devol.vlr_descontos * -1),(r_devol.vlr_acre_tn * -1),'DEV',
                          r_temp.cod_cliente,r_temp.des_cliente,1);
              end loop;
              close c_devol;
          end loop;
          close c_temp;

          commit;
     end;
end grz_rel_desc_funcionarios_sp;