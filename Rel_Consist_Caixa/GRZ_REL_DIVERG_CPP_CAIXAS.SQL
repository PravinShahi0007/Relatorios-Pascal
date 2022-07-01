CREATE OR REPLACE PROCEDURE GRZ_REL_DIVERG_CPP_CAIXAS
  (PI_OPCAO IN VARCHAR2)
IS
BEGIN
  DECLARE
	/**** Parametros de entrada ****/
	pi_grupo_ini	     NUMBER;
	pi_uni_ini           NUMBER;
	pi_uni_fim           NUMBER;
	pi_data_ini          DATE;
	pi_data_fim	     DATE;
	pi_conta             NUMBER;
	pi_usuario           VARCHAR2(50);


       /**** Variaveis de trabalho ****/
       wi			           NUMBER;
       wf		             NUMBER;
       wCod_Rede         NUMBER;
       wDes_Rede         VARCHAR2(60);
       wDes_Conta        VARCHAR2(50);
       wDes_Unidade      VARCHAR2(50);
       wConta_Editado    VARCHAR2(10);
       wValor		 NUMBER(18,2);
       
       SAIDA             EXCEPTION;

       /* Cursor da tabela CX_MOVIMENTOS */
       CURSOR c_caixas_mvto IS
         select a.cod_emp
               ,a.cod_caixa
               ,a.dta_mvto_caixa
               ,nvl(a.vlr_saida,0) vlr_saida
               ,nvl(a.vlr_entrada,0) vlr_entrada
          from cx_movimentos a
         where a.cod_emp = 1
           and a.cod_caixa >= pi_uni_ini
           and a.cod_caixa <= pi_uni_fim   
           and a.dta_mvto_caixa >= pi_data_ini
           and a.dta_mvto_caixa <= pi_data_fim
           and a.cod_conta_cb = pi_conta           
           and exists (select 1 from ge_grupos_unidades ge
                        where a.cod_caixa = ge.cod_unidade
                          and ge.cod_grupo = pi_grupo_ini
                          and ge.cod_emp = 1
                          and ge.cod_unidade >= pi_uni_ini
                          and ge.cod_unidade <= pi_uni_fim);
       r_caixas_mvto c_caixas_mvto%ROWTYPE;


       /* Cursor da tabela NS_NOTAS */
       CURSOR c_notas_mvto IS
         select c.cod_emp
               ,c.cod_unidade
               ,c.dta_emissao
               ,sum(nvl(a.vlr_operacao,0)) vlr_operacao
               ,sum(nvl(a.vlr_acrescimo_cob,0)) vlr_acrescimo
               ,sum(nvl(a.vlr_desconto_cob,0)) vlr_desconto
               ,sum(to_number(nvl(d.vlr_coluna,'0'))) vlr_tac
               ,sum(to_number(nvl(e.vlr_coluna,'0'))) vlr_iof
          from ns_notas c
              ,ns_notas_operacoes a
              ,ns_notas_colunas d
              ,ns_notas_colunas e
         where c.num_seq=a.num_seq
           and c.cod_maquina=a.cod_maquina
           and a.cod_oper in (3000,3050)
           and c.num_seq=d.num_seq(+)
           and c.cod_maquina=d.cod_maquina(+)
           and d.seq_coluna(+)=6
           and c.num_seq=e.num_seq(+)
           and c.cod_maquina=e.cod_maquina(+)
           and e.seq_coluna(+)=5
           and c.cod_unidade >= pi_uni_ini
           and c.cod_unidade <= pi_uni_fim
           and c.dta_emissao >= pi_data_ini
           and c.dta_emissao <= pi_data_fim
           and exists (select 1 from ge_grupos_unidades ge
                        where c.cod_unidade = ge.cod_unidade
                          and ge.cod_grupo = pi_grupo_ini
                          and ge.cod_emp = 1
                          and ge.cod_unidade >= pi_uni_ini
                          and ge.cod_unidade <= pi_uni_fim)
        group by c.cod_emp,c.cod_unidade,c.dta_emissao;
       r_notas_mvto c_notas_mvto%ROWTYPE;


       /**** Inicio da procedure principal ****/
    BEGIN
          /**** Desmembra a opcao recebida ****/
	  wi := INSTR(pi_opcao, '#', 1, 1);
	  pi_grupo_ini := TO_NUMBER(SUBSTR(pi_opcao, 1,(wi-1)));
	  wf := INSTR(pi_opcao, '#', 1, 2);
	  pi_uni_ini := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	  wi := wf;
	  wf := INSTR(pi_opcao, '#', 1, 3);
	  pi_uni_fim := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	  wi := wf;
	  wf := INSTR(pi_opcao, '#', 1, 4);
	  pi_data_ini := TO_DATE(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	  wi := wf;
	  wf := INSTR(pi_opcao, '#', 1, 5);
	  pi_data_fim := TO_DATE(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	  wi := wf;
	  wf := INSTR(pi_opcao, '#', 1, 6);
	  pi_conta := TO_NUMBER(SUBSTR(pi_opcao,(wi+1),(wf-wi-1)));
	  wi := wf;
	  wf := INSTR(pi_opcao, '#', 1, 7);
          pi_usuario := SUBSTR(pi_opcao,(wi+1),(wf-wi-1));

          delete from GRZ_TEF_TRANSACAO_DIVERGENCIAS
          where upper(des_usuario) = upper(pi_usuario);
          commit;

          /* busca nome da conta */
          begin
             SELECT des_conta
               INTO wDes_Conta
               FROM CB_CONTAS
              WHERE COD_CONTA = pi_conta;
              EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                        wDes_Conta := 'Conta nao cadastrada';
          end;

          /* busca codigo editado da conta */
          begin
             SELECT cod_editado
               INTO wConta_Editado
               FROM CB_MASCARAS
              WHERE COD_MASCARA = 201
                AND COD_CONTA = pi_conta;
                EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                          wConta_Editado := '999999';
          end;


          /* busca nome do grupo de unidades */
          begin
               SELECT des_grupo
                 INTO wDes_Rede
                 FROM GE_GRUPOS
                WHERE COD_GRUPO = pi_grupo_ini;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                      wDes_Rede := 'GRUPO NAO CADASTRADO';
          end;
          wCod_Rede := pi_grupo_ini;


          /**** Abre o cursor dos caixas ****/
	  OPEN c_caixas_mvto;
	  FETCH c_caixas_mvto INTO r_caixas_mvto;
	  WHILE c_caixas_mvto%FOUND LOOP
	  BEGIN
             /* busca nome da unidade */
             begin
                SELECT des_nome
                      ,cod_nivel2
                  INTO wDes_Unidade
                      ,wCod_Rede
                  FROM GE_UNIDADES
                 WHERE COD_UNIDADE = r_caixas_mvto.cod_caixa;
                EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                          wDes_Unidade  := 'Unidade nao Cadastrada';
                          wCod_Rede    := 0;
             end;
	     
            wValor := nvl(r_caixas_mvto.vlr_saida,0) - nvl(r_caixas_mvto.vlr_entrada,0);
            insert into GRZ_TEF_TRANSACAO_DIVERGENCIAS(DES_USUARIO
       	       				   	      ,COD_EMP
                       	                	      ,COD_UNIDADE
       	                                              ,DTA_MOVIMENTO
                       	                              ,DES_REDE
                       	                              ,VLR_LCTO
                       	                              ,VLR_LCTO_SERV
                       	                              ,VLR_DIFERENCA
                       	                              ,DES_UNIDADE
                       	                              ,COD_AUTORIZACAO
                       	                              ,DES_ORIGEM)
       	                                        VALUES(pi_usuario
                       	                              ,r_caixas_mvto.cod_emp
                       	                              ,r_caixas_mvto.cod_caixa
                       	                              ,r_caixas_mvto.dta_mvto_caixa
                       	                              ,SUBSTR(wDes_Rede,1,20)
                       	                              ,wValor
                       	                              ,0
                       	                              ,0
                       	                              ,wDes_Unidade
                       	                              ,wConta_Editado
                       	                              ,SUBSTR(wDes_Conta,1,20));	     
          END;
          FETCH c_caixas_mvto INTO r_caixas_mvto;
          END LOOP;
          CLOSE c_caixas_mvto;


          /**** Abre o cursor das notas ****/
	  OPEN c_notas_mvto;
	  FETCH c_notas_mvto INTO r_notas_mvto;
	  WHILE c_notas_mvto%FOUND LOOP
	  BEGIN
             /* busca nome da unidade */
             begin
                SELECT des_nome
                      ,cod_nivel2
                  INTO wDes_Unidade
                      ,wCod_Rede
                  FROM GE_UNIDADES
                 WHERE COD_UNIDADE = r_notas_mvto.cod_unidade;
                EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                          wDes_Unidade  := 'Unidade nao Cadastrada';
                          wCod_Rede    := 0;
             end;
            if r_notas_mvto.dta_emissao > to_date('15/01/2008','dd/mm/yyyy') then
                wValor := nvl(r_notas_mvto.vlr_operacao,0) - nvl(r_notas_mvto.vlr_tac,0) - nvl(r_notas_mvto.vlr_iof,0);
            else
                wValor := nvl(r_notas_mvto.vlr_operacao,0) - nvl(r_notas_mvto.vlr_tac,0);
            end if;
            insert into GRZ_TEF_TRANSACAO_DIVERGENCIAS(DES_USUARIO
       	       				   	      ,COD_EMP
                       	                	      ,COD_UNIDADE
       	                                              ,DTA_MOVIMENTO
                       	                              ,DES_REDE
                       	                              ,VLR_LCTO
                       	                              ,VLR_LCTO_SERV
                       	                              ,VLR_DIFERENCA
                       	                              ,DES_UNIDADE
                       	                              ,COD_AUTORIZACAO
                       	                              ,DES_ORIGEM)
       	                                        VALUES(pi_usuario
                       	                              ,r_notas_mvto.cod_emp
                       	                              ,r_notas_mvto.cod_unidade
                       	                              ,r_notas_mvto.dta_emissao
                       	                              ,SUBSTR(wDes_Rede,1,20)
                       	                              ,0
                       	                              ,wValor
                       	                              ,0
                       	                              ,wDes_Unidade
                       	                              ,wConta_Editado
                       	                              ,SUBSTR(wDes_Conta,1,20));	     
          END;
          FETCH c_notas_mvto INTO r_notas_mvto;
          END LOOP;
          CLOSE c_notas_mvto;

          commit;
          
       EXCEPTION
            WHEN SAIDA THEN
                 NULL;
       END;
END GRZ_REL_DIVERG_CPP_CAIXAS;
