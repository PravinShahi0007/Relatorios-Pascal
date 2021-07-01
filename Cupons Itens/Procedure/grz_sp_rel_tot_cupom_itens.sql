CREATE OR REPLACE PROCEDURE Grz_sp_rel_tot_cupom_itens(pi_opcao IN VARCHAR2)
IS
BEGIN
    DECLARE
        /*** Parametros de entrada ***/
        pi_rede_ini            NUMBER;
        pi_rede_fim            NUMBER;
        pi_data_ini            VARCHAR2(10);
        pi_data_fim            VARCHAR2(10);
        pi_uni_ini             NUMBER;
        pi_uni_fim             NUMBER;
        pi_usuario             VARCHAR2(30);
        pi_cupom_ini           NUMBER;
        pi_cupom_fim           NUMBER;
        pi_equip_ini           NUMBER;
        pi_equip_fim           NUMBER;
        pi_ind_meio_venda      NUMBER;
		pi_cod_canc_ti         NUMBER;
		pi_setor_ini           NUMBER;
		pi_setor_Fim           NUMBER;
		pi_grupo_ini           NUMBER;
		pi_grupo_fim           NUMBER;
		pi_subGrupo_ini        NUMBER;
		pi_subGrupo_fim        NUMBER;
		pi_item_ini            NUMBER;
		pi_item_fim            NUMBER;
        wi                     NUMBER;
        wf                     NUMBER;
        wdes_unidade           VARCHAR2(50);
        wdes_rede              VARCHAR2(50);
        wvlr_produtos          NUMBER(18, 2);
        wtip_mvto              VARCHAR2(02);
        wdes_cancelado         VARCHAR2(20);
        wdes_cancelado_item    VARCHAR2(20);
        wdes_tipo_cancelamento VARCHAR2(20);
        wcount                 NUMBER;

        /*** Cursor para ler o valor das operacoes e liquido da reducao z ***/
        CURSOR c_cupom_operacoes IS
          SELECT num_rede,
                 cod_unidade,
                 dta_lancamento,
                 num_equipamento,
                 num_cupom,
                 cod_item,
                 0                           AS seq_chave_cupom,
                 qtd_lancamento,
                 vlr_total,
                 Nvl(vlr_desconto, 0)
                 + Nvl(vlr_desconto_item, 0) AS vlr_desconto,
                 vlr_acrescimo_item,
                 tip_mvto,
                 ind_cancelado,
                 ind_cancelado_item,
                 seq_item
            FROM   grz_lojas_cupom_itens
            WHERE  num_rede >= pi_rede_ini
                 AND num_rede <= pi_rede_fim
                 AND cod_unidade >= pi_uni_ini
                 AND cod_unidade <= pi_uni_fim
                 AND dta_lancamento >= To_date(pi_data_ini, 'dd/mm/yyyy')
                 AND dta_lancamento <= To_date(pi_data_fim, 'dd/mm/yyyy')
                 AND num_cupom >= pi_cupom_ini
                 AND num_cupom <= pi_cupom_fim
				 AND exists (select * from ie_mascaras ie
                              where ie.cod_mascara = 150 and ie.cod_item = cod_item and ie.cod_niv1 = num_rede
                                and ie.cod_niv2 >= pi_setor_ini
                                and ie.cod_niv2 <= pi_setor_fim
                                and ie.cod_niv3 >= pi_grupo_ini
				                and ie.cod_niv3 <= pi_grupo_fim
                                and ie.cod_niv4 >= pi_subGrupo_ini
				                and ie.cod_niv4 <= pi_subGrupo_fim
                                and ie.cod_niv5 >= pi_item_ini
                                and ie.cod_niv5 <= pi_item_fim)
                 AND num_equipamento >= pi_equip_ini
                 AND num_equipamento <= pi_equip_fim
				 AND nvl(cod_motivo_cancelamento,0) <>  pi_cod_canc_ti
		 UNION
        SELECT   cupons.cod_emp,
                 cupons.cod_unidade,
                 cupons.dta_movimento,
                 cupons.num_equipamento,
                 cupons.num_cupom,
                 itens.cod_estruturado           AS cod_item,
                 itens.seq_chave_cupom,
                 itens.qtd_movimento,
                 itens.vlr_total,
                 Nvl(itens.vlr_descto_cupom, 0)
                 + Nvl(itens.vlr_descto_item, 0) AS vlr_desconto,
                 itens.vlr_acrescimo,
                 '01'                            AS tip_mvto,
                 itens.ind_cancelado,
                 00                              AS ind_cancelado_item,
                 itens.num_seq_item
          FROM   grz_lojas_itens_cancelados itens,
                 grz_lojas_cupom_cancelados cupons
          WHERE  itens.cod_emp = cupons.cod_emp
                 AND itens.cod_unidade = cupons.cod_unidade
                 AND itens.num_equipamento = cupons.num_equipamento
                 AND itens.dta_movimento = cupons.dta_movimento
                 AND itens.num_cupom = cupons.num_cupom
                 AND itens.seq_chave_cupom = cupons.seq_chave_cupom
                 AND itens.cod_emp >= pi_rede_ini
                 AND itens.cod_emp <= pi_rede_fim
                 AND itens.cod_unidade >= pi_uni_ini
                 AND itens.cod_unidade <= pi_uni_fim
                 AND itens.num_equipamento >= pi_equip_ini
                 AND itens.num_equipamento <= pi_equip_fim
                 AND itens.dta_movimento >= To_date(pi_data_ini, 'dd/mm/yyyy')
                 AND itens.dta_movimento <= To_date(pi_data_fim, 'dd/mm/yyyy')
                 AND itens.num_cupom >= pi_cupom_ini
                 AND itens.num_cupom <= pi_cupom_fim
				 AND exists (select 1 from ie_mascaras ie
                              where ie.cod_mascara = 150
							    and ie.cod_item = cod_item and ie.cod_niv1 = itens.cod_emp
                                and ie.cod_niv2 >= pi_setor_ini
                                and ie.cod_niv2 <= pi_setor_fim
                                and ie.cod_niv3 >= pi_grupo_ini
				                and ie.cod_niv3 <= pi_grupo_fim
                                and ie.cod_niv4 >= pi_subGrupo_ini
				                and ie.cod_niv4 <= pi_subGrupo_fim
                                and ie.cod_niv5 >= pi_item_ini
                                and ie.cod_niv5 <= pi_item_fim)
                 AND nvl(cupons.cod_cancelamento,0) <>  pi_cod_canc_ti  ;

        r_cupom_operacoes      c_cupom_operacoes%ROWTYPE;

   /***   00#99#01/07/2019#22/07/2019#0000000#9999999#388720#000#999#000000#999999#0#8# Inicio da procedure principal ***/
    BEGIN
         /*** Desmembra a opcao recebida ***/
         wi := Instr(pi_opcao, '#', 1, 1);
         pi_rede_ini := To_number(Substr(pi_opcao, 1, ( wi - 1 )));
         wf := Instr(pi_opcao, '#', 1, 2);
         pi_rede_fim := To_number(Substr(pi_opcao, ( wi + 1 ), ( wf - wi - 1 )));
         wi := wf;
         wf := Instr(pi_opcao, '#', 1, 3);
         pi_data_ini := Substr(pi_opcao, ( wi + 1 ), ( wf - wi - 1 ));
         wi := wf;
         wf := Instr(pi_opcao, '#', 1, 4);
         pi_data_fim := Substr(pi_opcao, ( wi + 1 ), ( wf - wi - 1 ));
         wi := wf;
         wf := Instr(pi_opcao, '#', 1, 5);
         pi_uni_ini := To_number(Substr(pi_opcao, ( wi + 1 ), ( wf - wi - 1 )));
         wi := wf;
         wf := Instr(pi_opcao, '#', 1, 6);
         pi_uni_fim := To_number(Substr(pi_opcao, ( wi + 1 ), ( wf - wi - 1 )));
         wi := wf;
         wf := Instr(pi_opcao, '#', 1, 7);
         pi_usuario := Substr(pi_opcao, ( wi + 1 ), ( wf - wi - 1 ));
         wi := wf;
         wf := Instr(pi_opcao, '#', 1, 8);
         pi_equip_ini := To_number(Substr(pi_opcao, ( wi + 1 ), ( wf - wi - 1 ))) ;
         wi := wf;
         wf := Instr(pi_opcao, '#', 1, 9);
         pi_equip_fim := To_number(Substr(pi_opcao, ( wi + 1 ), ( wf - wi - 1 ))) ;
         wi := wf;
         wf := Instr(pi_opcao, '#', 1, 10);
         pi_cupom_ini := To_number(Substr(pi_opcao, ( wi + 1 ), ( wf - wi - 1 ))) ;
         wi := wf;
         wf := Instr(pi_opcao, '#', 1, 11);
         pi_cupom_fim := To_number(Substr(pi_opcao, ( wi + 1 ), ( wf - wi - 1 )))  ;
         wi := wf;
         wf := Instr(pi_opcao, '#', 1, 12);
		 pi_setor_ini := To_number(Substr(pi_opcao, ( wi + 1 ), ( wf - wi - 1 )))  ;
         wi := wf;
         wf := Instr(pi_opcao, '#', 1, 13);
		 pi_setor_fim:= To_number(Substr(pi_opcao, ( wi + 1 ), ( wf - wi - 1 )))  ;
         wi := wf;
         wf := Instr(pi_opcao, '#', 1, 14);
		 pi_grupo_ini := To_number(Substr(pi_opcao, ( wi + 1 ), ( wf - wi - 1 )))  ;
         wi := wf;
         wf := Instr(pi_opcao, '#', 1, 15);
         pi_grupo_fim := To_number(Substr(pi_opcao, ( wi + 1 ), ( wf - wi - 1 )))  ;
         wi := wf;
         wf := Instr(pi_opcao, '#', 1, 16);
		 pi_subGrupo_ini  := To_number(Substr(pi_opcao, ( wi + 1 ), ( wf - wi - 1 )))  ;
         wi := wf;
         wf := Instr(pi_opcao, '#', 1, 17);
         pi_subGrupo_fim  := To_number(Substr(pi_opcao, ( wi + 1 ), ( wf - wi - 1 )))  ;
         wi := wf;
         wf := Instr(pi_opcao, '#', 1, 18);
		 pi_item_ini := To_number(Substr(pi_opcao, ( wi + 1 ), ( wf - wi - 1 )))  ;
         wi := wf;
         wf := Instr(pi_opcao, '#', 1, 19);
		 pi_item_fim := To_number(Substr(pi_opcao, ( wi + 1 ), ( wf - wi - 1 )))  ;
         wi := wf;
         wf := Instr(pi_opcao, '#', 1, 20);
         pi_ind_meio_venda := To_number(Substr(pi_opcao, ( wi + 1 ), ( wf - wi - 1 )));
	     wi := wf;
         wf := Instr(pi_opcao, '#', 1, 21);
		 pi_cod_canc_ti := To_number(Substr(pi_opcao, ( wi + 1 ), ( wf - wi - 1 )));
		 wi := wf;
         wf := Instr (pi_opcao, '#', 1, 22);

        /*** Limpa a tabela temporaria ***/
        DELETE FROM grzw_rel_lojas_cupons
        WHERE  Upper(des_usuario) = Upper(pi_usuario);

        COMMIT;

        wcount := 0;

        /*** Abre o cursor de redes ***/
        OPEN c_cupom_operacoes;

        FETCH c_cupom_operacoes INTO r_cupom_operacoes;

        WHILE c_cupom_operacoes%FOUND LOOP
            BEGIN
                wcount := wcount + 1;
				wdes_cancelado_item := '';

                IF r_cupom_operacoes.num_rede =   10 THEN
                  wdes_rede := 'GRAZZIOTIN';
                ELSIF r_cupom_operacoes.num_rede = 20 THEN
                  wdes_rede := 'TECH BOX';
                ELSIF r_cupom_operacoes.num_rede = 30 THEN
                  wdes_rede := 'POR MENOS';
                ELSIF r_cupom_operacoes.num_rede = 40 THEN
                  wdes_rede := 'FRANCO GIORGI';
                ELSIF r_cupom_operacoes.num_rede = 50 THEN
                  wdes_rede := 'TOTTAL';
                ELSIF r_cupom_operacoes.num_rede = 55 THEN
                  wdes_rede := 'VIA RAQUELLE';
			    ELSIF r_cupom_operacoes.num_rede = 70 THEN
                  wdes_rede := 'CIA';
                ELSE
                  wdes_rede := 'SEM DESCRICAO';
                END IF;

                BEGIN
                    SELECT des_nome
                    INTO   wdes_unidade
                    FROM   ge_unidades
                    WHERE  cod_unidade = r_cupom_operacoes.cod_unidade;
                EXCEPTION
                    WHEN no_data_found THEN
                      wdes_unidade := 'SEM DESCRICAO';
                END;

                IF Rtrim(r_cupom_operacoes.tip_mvto) = '1011' THEN
                  wtip_mvto := 'VP';
                ELSIF Rtrim(r_cupom_operacoes.tip_mvto) = '1010' THEN
                  wtip_mvto := 'VV';
                ELSE
                  wtip_mvto := ' ';
                END IF;

                wvlr_produtos := ( Nvl(r_cupom_operacoes.vlr_total, 0.0)
                                   + Nvl(r_cupom_operacoes.vlr_desconto, 0.0) );

                IF r_cupom_operacoes.ind_cancelado = 1 THEN
				  IF r_cupom_operacoes.seq_chave_cupom > 0 THEN
				     wdes_cancelado := 'CANC MV';
                     wdes_cancelado_item := 'CANC MV';
				  ELSE
                     wdes_cancelado := 'CANCELADO';
                     wdes_cancelado_item := 'CANCELADO';
			      END IF;

                ELSE
                  wdes_cancelado := '';

                  IF r_cupom_operacoes.ind_cancelado_item = 1 THEN
                    wdes_cancelado_item := 'CANC';
                  ELSE
                    wdes_cancelado_item := '';
					 END IF;
                END IF;

				    /***INSIRA DENTRO ***/
						INSERT INTO grzw_rel_lojas_cupons
                            (des_usuario,
                             cod_unidade,
                             des_unidade,
                             num_rede,
                             des_rede,
                             dta_lancamento,
                             num_equipamento,
                             num_cupom,
                             cod_item,
                             qtd_lancamento,
                             vlr_produtos,
                             vlr_desconto,
                             vlr_acrescimo,
                             vlr_total,
                             tip_mvto,
                             ind_cancelado,
                             ind_cancelado_item,
                             seq_item,
                             des_cancelado,
                             des_cancelado_item)
                VALUES      (pi_usuario,
                             r_cupom_operacoes.cod_unidade,
                             wdes_unidade,
                             r_cupom_operacoes.num_rede,
                             wdes_rede,
                             r_cupom_operacoes.dta_lancamento,
                             r_cupom_operacoes.num_equipamento,
                             r_cupom_operacoes.num_cupom,
                             r_cupom_operacoes.cod_item,
                             r_cupom_operacoes.qtd_lancamento,
                             wvlr_produtos,
                             Nvl(r_cupom_operacoes.vlr_desconto, 0.0),
                             r_cupom_operacoes.vlr_acrescimo_item,
                             r_cupom_operacoes.vlr_total,
                             wtip_mvto,
                             Nvl(r_cupom_operacoes.ind_cancelado, 0),
                             Nvl(r_cupom_operacoes.ind_cancelado_item, 0),
                             r_cupom_operacoes.seq_item,
                             wdes_cancelado,
                             wdes_cancelado_item );
            END;
                /*** Busca em ***/
            FETCH c_cupom_operacoes INTO r_cupom_operacoes;
        END LOOP;

        CLOSE c_cupom_operacoes;

        COMMIT;
    END;
END grz_sp_rel_tot_cupom_itens;
