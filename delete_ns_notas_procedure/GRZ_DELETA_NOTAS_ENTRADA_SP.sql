CREATE OR REPLACE PROCEDURE GRZ_DELETA_NOTAS_ENTRADA_SP(PI_OPCAO     IN VARCHAR2,
                                                        PO_RESULTADO OUT VARCHAR2) IS
BEGIN
     DECLARE
            wCod_Unidade    NUMBER;
            wNum_Nota_Atual NUMBER;
            wSerie          VARCHAR2(03);
            wDta_Emissao    DATE;
            wEquip          NUMBER;
            wSaida          VARCHAR2(128);
            wi              NUMBER;
            wf              NUMBER;

            BEGIN
                 PO_RESULTADO    := 'Deletados:' || CHR(10);
                 wi              := INSTR(pi_opcao, '#', 1, 1);
                 wCod_Unidade    := TO_NUMBER(SUBSTR(pi_opcao, 1, (wi - 1)));
                 wf              := INSTR(pi_opcao, '#', 1, 2);
                 wNum_Nota_Atual := TO_NUMBER(SUBSTR(pi_opcao, (wi + 1), (wf - wi - 1)));
                 wi              := wf;
                 wf              := INSTR(pi_opcao, '#', 1, 3);
                 wSerie          := SUBSTR(pi_opcao, (wi + 1), (wf - wi - 1));
                 wi              := wf;
                 wf              := INSTR(pi_opcao, '#', 1, 4);
                 wDta_Emissao    := TO_DATE(SUBSTR(pi_opcao, (wi + 1), (wf - wi - 1)),
                                            'dd/mm/yyyy');
                 wi              := wf;
                 wf              := INSTR(pi_opcao, '#', 1, 6);
                 wEquip          := SUBSTR(pi_opcao, (wi + 1), (wf - wi - 1));

                 BEGIN
                      DELETE FROM nl.ai_ne_notas_itens a
                       WHERE a.cod_unidade = wCod_Unidade
                         AND a.num_nota = wNum_Nota_Atual
                         AND a.cod_serie = wSerie
                      RETURNING count(a.num_nota) INTO wSaida;
                      po_resultado := po_resultado || wSaida || ' em ai_ne_notas_itens' ||
                              CHR(10);

                      DELETE FROM nl.ai_ne_notas_icms a
                       WHERE a.cod_unidade = wCod_Unidade
                         AND a.num_nota = wNum_Nota_Atual
                         AND a.cod_serie = wSerie
                      RETURNING count(a.num_nota) INTO wSaida;
                      po_resultado := po_resultado || wSaida || ' em ai_ne_notas_icms' ||
                              CHR(10);

                      DELETE FROM nl.ai_ne_notas_operacoes a
                       WHERE a.cod_unidade = wCod_Unidade
                         AND a.num_nota = wNum_Nota_Atual
                         AND a.cod_serie = wSerie
                      RETURNING count(a.num_nota) INTO wSaida;
                      po_resultado := po_resultado || wSaida || ' em ai_ne_notas_operacoes' ||
                              CHR(10);

                      DELETE FROM nl.ai_ne_observacoes a
                       WHERE a.cod_unidade = wCod_Unidade
                         AND a.num_nota = wNum_Nota_Atual
                         AND a.cod_serie = wSerie
                      RETURNING count(a.num_nota) INTO wSaida;
                      po_resultado := po_resultado || wSaida || ' em ai_ne_observacoes' ||
                              CHR(10);

                      DELETE FROM nl.ai_ne_notas a
                       WHERE a.cod_unidade = wCod_Unidade
                         AND a.num_nota = wNum_Nota_Atual
                         AND a.cod_serie = wSerie
                      RETURNING count(a.num_nota) INTO wSaida;
                      po_resultado := po_resultado || wSaida || ' em ai_ne_notas' ||
                              CHR(10);

                      DELETE FROM nl.ai_ne_controle a
                       WHERE a.cod_unidade = wCod_Unidade
                         AND a.num_nota = wNum_Nota_Atual
                         AND a.cod_serie = wSerie
                      RETURNING count(a.num_nota) INTO wSaida;
                      po_resultado := po_resultado || wSaida || ' em ai_ne_controle' ||
                              CHR(10);

                      DELETE FROM nl.ai_ne_divergencias a
                       WHERE a.cod_unidade = wCod_Unidade
                         AND a.num_nota = wNum_Nota_Atual
                         AND a.cod_serie = wSerie
                      RETURNING count(a.num_nota) INTO wSaida;
                      po_resultado := po_resultado || wSaida || ' em ai_ne_divergencias' ||
                              CHR(10);

                      IF wSerie <> '50' THEN
                         DELETE nl.grz_lojas_ne_controle a
                          WHERE a.cod_unidade = wCod_Unidade
                            AND a.num_nota = wNum_Nota_Atual
                            AND a.num_equipamento = wEquip
                            AND a.dta_emissao = trunc(wDta_Emissao)
                         RETURNING count(a.num_nota) INTO wSaida;
                         po_resultado := po_resultado || wSaida || ' em grz_lojas_ne_controle' ||
                                 CHR(10);  
                      END IF;
                 END;  

            EXCEPTION
            WHEN others THEN
                 po_resultado := 'Erro ao deletar os registros!';
                 ROLLBACK;
            END;
            COMMIT;
END GRZ_DELETA_NOTAS_ENTRADA_SP;