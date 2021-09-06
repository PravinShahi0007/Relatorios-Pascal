COMMIT WORK;
SET AUTODDL OFF;
SET TERM ^ ;

/* Stored procedures */

CREATE PROCEDURE "REL_CLI_PREVENTIVA_SP" 
(
  "COD_EMP" NUMERIC(3, 0),
  "COD_UNIDADE" NUMERIC(4, 0),
  "DTA_INICIAL" DATE,
  "DTA_FINAL" DATE,
  "NRO_COMPRA_INI" NUMERIC(5, 0),
  "NRO_COMPRA_FIM" NUMERIC(5, 0),
  "VLR_PROX_INI" NUMERIC(15, 2),
  "VLR_PROX_FIM" NUMERIC(15, 2),
  "IORDER" NUMERIC(1, 0),
  "MDA_INI" NUMERIC(5, 0),
  "MDA_FIM" NUMERIC(5, 0),
  "PERFIL_INI" NUMERIC(4, 0),
  "PERFIL_FIM" NUMERIC(4, 0)
)
RETURNS
(
  "COD_CLIENTE" NUMERIC(14, 0),
  "DES_CLIENTE" VARCHAR(40),
  "DTA_CADASTRO" DATE,
  "DES_FONE_RESID" VARCHAR(15),
  "DES_FONE_COMERC" VARCHAR(15),
  "QTD_COMPRAS_VP" NUMERIC(5, 0),
  "DES_FONE_CELULAR2" VARCHAR(15),
  "DES_FONE_AUT" VARCHAR(15),
  "QTD_MAIOR_ATRASO" NUMERIC(5, 0),
  "DTA_VENCIMENTO" DATE,
  "QTD_PARCELAS" NUMERIC(3, 0),
  "TIP_PLANO_VP" VARCHAR(6),
  "NUM_PARCELA" NUMERIC(3, 0),
  "VLR_PRESTACAO" NUMERIC(15, 2),
  "COD_CONTRATO" NUMERIC(11, 0),
  "DTA_VENDA" DATE,
  "DES_FONE_CELULAR" VARCHAR(15),
  "NUM_MDA" NUMERIC(5, 0),
  "COD_PERFIL_CLI" NUMERIC(4, 0),
  "COD_COMPL" VARCHAR(3),
  "DTA_VENC_ORDEM" DATE,
  "DTA_AGENDAMENTO" DATE
)
AS
BEGIN EXIT; END ^


ALTER PROCEDURE "REL_CLI_PREVENTIVA_SP" 
(
  "COD_EMP" NUMERIC(3, 0),
  "COD_UNIDADE" NUMERIC(4, 0),
  "DTA_INICIAL" DATE,
  "DTA_FINAL" DATE,
  "NRO_COMPRA_INI" NUMERIC(5, 0),
  "NRO_COMPRA_FIM" NUMERIC(5, 0),
  "VLR_PROX_INI" NUMERIC(15, 2),
  "VLR_PROX_FIM" NUMERIC(15, 2),
  "IORDER" NUMERIC(1, 0),
  "MDA_INI" NUMERIC(5, 0),
  "MDA_FIM" NUMERIC(5, 0),
  "PERFIL_INI" NUMERIC(4, 0),
  "PERFIL_FIM" NUMERIC(4, 0)
)
RETURNS
(
  "COD_CLIENTE" NUMERIC(14, 0),
  "DES_CLIENTE" VARCHAR(40),
  "DTA_CADASTRO" DATE,
  "DES_FONE_RESID" VARCHAR(15),
  "DES_FONE_COMERC" VARCHAR(15),
  "QTD_COMPRAS_VP" NUMERIC(5, 0),
  "DES_FONE_CELULAR2" VARCHAR(15),
  "DES_FONE_AUT" VARCHAR(15),
  "QTD_MAIOR_ATRASO" NUMERIC(5, 0),
  "DTA_VENCIMENTO" DATE,
  "QTD_PARCELAS" NUMERIC(3, 0),
  "TIP_PLANO_VP" VARCHAR(6),
  "NUM_PARCELA" NUMERIC(3, 0),
  "VLR_PRESTACAO" NUMERIC(15, 2),
  "COD_CONTRATO" NUMERIC(11, 0),
  "DTA_VENDA" DATE,
  "DES_FONE_CELULAR" VARCHAR(15),
  "NUM_MDA" NUMERIC(5, 0),
  "COD_PERFIL_CLI" NUMERIC(4, 0),
  "COD_COMPL" VARCHAR(3),
  "DTA_VENC_ORDEM" DATE,
  "DTA_AGENDAMENTO" DATE
)
AS
DECLARE VARIABLE CONTADOR NUMERIC(3);
DECLARE VARIABLE COD_CLIENTE_ANT NUMERIC(8,0);
BEGIN
COD_CLIENTE_ANT = 0;
     IF (IORDER = 1 )THEN/*NOME*/
     BEGIN
       FOR SELECT COD_CLIENTE
                 ,DTA_VENCIMENTO
                 ,QTD_PARCELAS
                 ,TIP_PLANO_VP
                 ,NUM_PARCELA
                 ,VLR_PRESTACAO
                 ,COD_CONTRATO
                 ,DTA_VENDA
                 ,COD_COMPL
             FROM CRE_CONTAS_RECEBER
            WHERE COD_EMP = :COD_EMP
              AND COD_UNIDADE = :COD_UNIDADE
              AND DTA_VENCIMENTO >= :DTA_INICIAL
              AND DTA_VENCIMENTO <= :DTA_FINAL
              AND IND_PRESTACAO = 0
              AND VLR_PRESTACAO >= :VLR_PROX_INI
              AND VLR_PRESTACAO <= :VLR_PROX_FIM
              AND NOT EXISTS (SELECT 1 FROM CRE_CLI_AGENDA B
                                WHERE B.COD_EMP = CRE_CONTAS_RECEBER.COD_EMP
                                  AND B.COD_UNIDADE = CRE_CONTAS_RECEBER.COD_UNIDADE
                                  AND B.COD_CLIENTE = CRE_CONTAS_RECEBER.COD_CLIENTE
                                  AND B.DTA_AGENDAMENTO >= CURRENT_DATE)
             INTO :COD_CLIENTE,:DTA_VENCIMENTO,:QTD_PARCELAS,:TIP_PLANO_VP,
                  :NUM_PARCELA,:VLR_PRESTACAO,:COD_CONTRATO,:DTA_VENDA,:COD_COMPL
         DO BEGIN
               FOR SELECT A.DES_CLIENTE
                         ,A.DTA_CADASTRO
                         ,A.DES_TELEFONE
                         ,D.DES_FONE_COMERC
                         ,D.DES_FONE_CELULAR
                         ,D.DES_FONE_CELULAR2
                         ,B.QTD_COMPRAS_VP
                         ,B.QTD_MAIOR_ATRASO
                         ,B.NUM_MDA
                         ,B.COD_PERFIL_CLI
                     FROM CRE_CLIENTES A
                         ,CRE_CLIENTES_CR D
                         ,CRE_SALDOS_CLI B
                    WHERE A.COD_EMP = D.COD_EMP
                      AND A.COD_CLIENTE = D.COD_CLIENTE
                      AND A.COD_EMP = B.COD_EMP
                      AND A.COD_CLIENTE = B.COD_CLIENTE
                      AND B.QTD_COMPRAS_VP >= :NRO_COMPRA_INI
                      AND B.QTD_COMPRAS_VP <= :NRO_COMPRA_FIM
                      AND A.COD_EMP = :COD_EMP
                      AND A.COD_CLIENTE = :COD_CLIENTE
                      AND B.NUM_MDA >= :MDA_INI
                      AND B.NUM_MDA <= :MDA_FIM
                      AND B.COD_PERFIL_CLI >= :PERFIL_INI
                      AND B.COD_PERFIL_CLI <= :PERFIL_FIM
                      INTO :DES_CLIENTE,:DTA_CADASTRO,:DES_FONE_RESID,:DES_FONE_COMERC,:DES_FONE_CELULAR,:DES_FONE_CELULAR2,
                          :QTD_COMPRAS_VP,:QTD_MAIOR_ATRASO,:NUM_MDA,:COD_PERFIL_CLI
               DO BEGIN
                 FOR SELECT DES_TELEFONE FROM CRE_PESSOA_AUTORIZADA
                  WHERE COD_EMP = :COD_EMP
                    AND COD_CLIENTE = :COD_CLIENTE
                    INTO :DES_FONE_AUT
               DO BEGIN
                    CONTADOR = 0;
                    BEGIN
                       SELECT COUNT(1)
                         FROM CRE_CONTAS_RECEBER
                        WHERE COD_EMP = :COD_EMP
                          AND COD_CLIENTE = :COD_CLIENTE
                          AND COD_CONTRATO = :COD_CONTRATO
                          AND DTA_VENCIMENTO < :DTA_INICIAL
                          AND IND_PRESTACAO = 0
                         INTO :CONTADOR;
                       WHEN SQLCODE -104 DO
                           CONTADOR = 0;
                    END
                    IF (CONTADOR = 0) THEN
                    BEGIN
                       SUSPEND;
                    END
                  END
                  END
            END
     END ELSE
     IF (IORDER = 2 )THEN/*QTD COMPRAS*/
     BEGIN
       FOR SELECT COD_CLIENTE
                 ,DTA_VENCIMENTO
                 ,QTD_PARCELAS
                 ,TIP_PLANO_VP
                 ,NUM_PARCELA
                 ,VLR_PRESTACAO
                 ,COD_CONTRATO
                 ,DTA_VENDA
                 ,COD_COMPL
             FROM CRE_CONTAS_RECEBER
            WHERE COD_EMP = :COD_EMP
              AND COD_UNIDADE = :COD_UNIDADE
              AND DTA_VENCIMENTO >= :DTA_INICIAL
              AND DTA_VENCIMENTO <= :DTA_FINAL
              AND IND_PRESTACAO = 0
              AND VLR_PRESTACAO >= :VLR_PROX_INI
              AND VLR_PRESTACAO <= :VLR_PROX_FIM
              AND NOT EXISTS (SELECT 1 FROM CRE_CLI_AGENDA B
                                WHERE B.COD_EMP = CRE_CONTAS_RECEBER.COD_EMP
                                  AND B.COD_UNIDADE = CRE_CONTAS_RECEBER.COD_UNIDADE
                                  AND B.COD_CLIENTE = CRE_CONTAS_RECEBER.COD_CLIENTE
                                  AND B.DTA_AGENDAMENTO >= CURRENT_DATE)
             INTO :COD_CLIENTE,:DTA_VENCIMENTO,:QTD_PARCELAS,:TIP_PLANO_VP,
                  :NUM_PARCELA,:VLR_PRESTACAO,:COD_CONTRATO,:DTA_VENDA,:COD_COMPL
         DO BEGIN
               FOR SELECT A.DES_CLIENTE
                         ,A.DTA_CADASTRO
                         ,A.DES_TELEFONE
                         ,D.DES_FONE_COMERC
                         ,D.DES_FONE_CELULAR
                         ,D.DES_FONE_CELULAR2
                         ,B.QTD_COMPRAS_VP
                         ,B.QTD_MAIOR_ATRASO
                         ,B.NUM_MDA
                         ,B.COD_PERFIL_CLI
                     FROM CRE_CLIENTES A
                         ,CRE_CLIENTES_CR D
                         ,CRE_SALDOS_CLI B
                    WHERE A.COD_EMP = D.COD_EMP
                      AND A.COD_CLIENTE = D.COD_CLIENTE
                      AND A.COD_EMP = B.COD_EMP
                      AND A.COD_CLIENTE = B.COD_CLIENTE
                      AND B.QTD_COMPRAS_VP >= :NRO_COMPRA_INI
                      AND B.QTD_COMPRAS_VP <= :NRO_COMPRA_FIM
                      AND A.COD_EMP = :COD_EMP
                      AND A.COD_CLIENTE = :COD_CLIENTE
                      AND B.NUM_MDA >= :MDA_INI
                      AND B.NUM_MDA <= :MDA_FIM
                      AND B.COD_PERFIL_CLI >= :PERFIL_INI
                      AND B.COD_PERFIL_CLI <= :PERFIL_FIM
                     INTO :DES_CLIENTE,:DTA_CADASTRO,:DES_FONE_RESID,:DES_FONE_COMERC,:DES_FONE_CELULAR,:DES_FONE_CELULAR2,
                          :QTD_COMPRAS_VP,:QTD_MAIOR_ATRASO,:NUM_MDA,:COD_PERFIL_CLI
              DO BEGIN
                FOR  SELECT DES_TELEFONE FROM CRE_PESSOA_AUTORIZADA
                  WHERE COD_EMP = :COD_EMP
                    AND COD_CLIENTE = :COD_CLIENTE
                    INTO :DES_FONE_AUT
               DO BEGIN
                    CONTADOR = 0;
                    BEGIN
                       SELECT COUNT(1)
                         FROM CRE_CONTAS_RECEBER
                        WHERE COD_EMP = :COD_EMP
                          AND COD_CLIENTE = :COD_CLIENTE
                          AND COD_CONTRATO = :COD_CONTRATO
                          AND DTA_VENCIMENTO < :DTA_INICIAL
                          AND IND_PRESTACAO = 0
                         INTO :CONTADOR;
                       WHEN SQLCODE -104 DO
                           CONTADOR = 0;
                    END
                    IF (CONTADOR = 0) THEN
                    BEGIN
                       SUSPEND;
                    END
                  END
                 END
            END
     END ELSE
     IF (IORDER = 3 )THEN/*VENCIMENTO*/
     BEGIN
       FOR SELECT COD_CLIENTE
                 ,DTA_VENCIMENTO
                 ,QTD_PARCELAS
                 ,TIP_PLANO_VP
                 ,NUM_PARCELA
                 ,VLR_PRESTACAO
                 ,COD_CONTRATO
                 ,DTA_VENDA
                 ,COD_COMPL
             FROM CRE_CONTAS_RECEBER
            WHERE COD_EMP = :COD_EMP
              AND COD_UNIDADE = :COD_UNIDADE
              AND DTA_VENCIMENTO >= :DTA_INICIAL
              AND DTA_VENCIMENTO <= :DTA_FINAL
              AND IND_PRESTACAO = 0
              AND VLR_PRESTACAO >= :VLR_PROX_INI
              AND VLR_PRESTACAO <= :VLR_PROX_FIM
              AND NOT EXISTS (SELECT 1 FROM CRE_CLI_AGENDA B
                                WHERE B.COD_EMP = CRE_CONTAS_RECEBER.COD_EMP
                                  AND B.COD_UNIDADE = CRE_CONTAS_RECEBER.COD_UNIDADE
                                  AND B.COD_CLIENTE = CRE_CONTAS_RECEBER.COD_CLIENTE
                                  AND B.DTA_AGENDAMENTO >= CURRENT_DATE)
             INTO :COD_CLIENTE,:DTA_VENCIMENTO,:QTD_PARCELAS,:TIP_PLANO_VP,
                  :NUM_PARCELA,:VLR_PRESTACAO,:COD_CONTRATO,:DTA_VENDA,:COD_COMPL
         DO BEGIN
               FOR SELECT A.DES_CLIENTE
                         ,A.DTA_CADASTRO
                         ,A.DES_TELEFONE
                         ,D.DES_FONE_COMERC
                         ,D.DES_FONE_CELULAR
                         ,D.DES_FONE_CELULAR2
                         ,B.QTD_COMPRAS_VP
                         ,B.QTD_MAIOR_ATRASO
                         ,B.NUM_MDA
                         ,B.COD_PERFIL_CLI
                     FROM CRE_CLIENTES A
                         ,CRE_CLIENTES_CR D
                         ,CRE_SALDOS_CLI B
                    WHERE A.COD_EMP = D.COD_EMP
                      AND A.COD_CLIENTE = D.COD_CLIENTE
                      AND A.COD_EMP = B.COD_EMP
                      AND A.COD_CLIENTE = B.COD_CLIENTE
                      AND B.QTD_COMPRAS_VP >= :NRO_COMPRA_INI
                      AND B.QTD_COMPRAS_VP <= :NRO_COMPRA_FIM
                      AND A.COD_EMP = :COD_EMP
                      AND A.COD_CLIENTE = :COD_CLIENTE
                      AND B.NUM_MDA >= :MDA_INI
                      AND B.NUM_MDA <= :MDA_FIM
                      AND B.COD_PERFIL_CLI >= :PERFIL_INI
                      AND B.COD_PERFIL_CLI <= :PERFIL_FIM
                     INTO :DES_CLIENTE,:DTA_CADASTRO,:DES_FONE_RESID,:DES_FONE_COMERC,:DES_FONE_CELULAR,:DES_FONE_CELULAR2,
                          :QTD_COMPRAS_VP,:QTD_MAIOR_ATRASO,:NUM_MDA, :COD_PERFIL_CLI
                DO BEGIN
                FOR  SELECT DES_TELEFONE FROM CRE_PESSOA_AUTORIZADA
                      WHERE COD_EMP = :COD_EMP
                       AND COD_CLIENTE = :COD_CLIENTE
                       INTO :DES_FONE_AUT
               DO BEGIN
                IF (COD_CLIENTE = COD_CLIENTE_ANT) THEN
              		BEGIN
              		      DTA_VENC_ORDEM = DTA_VENC_ORDEM;
              		END
              	   ELSE
              	   	BEGIN
              	   		DTA_VENC_ORDEM = DTA_VENCIMENTO;
              	   		COD_CLIENTE_ANT = COD_CLIENTE;
              	   	END
                    CONTADOR = 0;
                    BEGIN
                       SELECT COUNT(1)
                         FROM CRE_CONTAS_RECEBER
                        WHERE COD_EMP = :COD_EMP
                          AND COD_CLIENTE = :COD_CLIENTE
                          AND COD_CONTRATO = :COD_CONTRATO
                          AND DTA_VENCIMENTO < :DTA_INICIAL
                          AND IND_PRESTACAO = 0
                         INTO :CONTADOR;
                       WHEN SQLCODE -104 DO
                           CONTADOR = 0;
                    END
                    IF (CONTADOR = 0) THEN
                    	BEGIN
                      		SUSPEND;
                    	END
                    ELSE
                    	BEGIN
                    		COD_CLIENTE_ANT = 0;
                    	END
                 END
                END
           END
     END ELSE
     IF (IORDER = 4 )THEN/*MDA*/
     BEGIN
       FOR SELECT COD_CLIENTE
                 ,DTA_VENCIMENTO
                 ,QTD_PARCELAS
                 ,TIP_PLANO_VP
                 ,NUM_PARCELA
                 ,VLR_PRESTACAO
                 ,COD_CONTRATO
                 ,DTA_VENDA
                 ,COD_COMPL
             FROM CRE_CONTAS_RECEBER
            WHERE COD_EMP = :COD_EMP
              AND COD_UNIDADE = :COD_UNIDADE
              AND DTA_VENCIMENTO >= :DTA_INICIAL
              AND DTA_VENCIMENTO <= :DTA_FINAL
              AND IND_PRESTACAO = 0
              AND VLR_PRESTACAO >= :VLR_PROX_INI
              AND VLR_PRESTACAO <= :VLR_PROX_FIM
              AND NOT EXISTS (SELECT 1 FROM CRE_CLI_AGENDA B
                                WHERE B.COD_EMP = CRE_CONTAS_RECEBER.COD_EMP
                                  AND B.COD_UNIDADE = CRE_CONTAS_RECEBER.COD_UNIDADE
                                  AND B.COD_CLIENTE = CRE_CONTAS_RECEBER.COD_CLIENTE
                                  AND B.DTA_AGENDAMENTO >= CURRENT_DATE)
             INTO :COD_CLIENTE,:DTA_VENCIMENTO,:QTD_PARCELAS,:TIP_PLANO_VP,
                  :NUM_PARCELA,:VLR_PRESTACAO,:COD_CONTRATO,:DTA_VENDA,:COD_COMPL
         DO BEGIN
               FOR SELECT A.DES_CLIENTE
                         ,A.DTA_CADASTRO
                         ,A.DES_TELEFONE
                         ,D.DES_FONE_COMERC
                         ,D.DES_FONE_CELULAR
                         ,D.DES_FONE_CELULAR2
                         ,B.QTD_COMPRAS_VP
                         ,B.QTD_MAIOR_ATRASO
                         ,B.NUM_MDA
                         ,B.COD_PERFIL_CLI
                     FROM CRE_CLIENTES A
                         ,CRE_CLIENTES_CR D
                         ,CRE_SALDOS_CLI B
                    WHERE A.COD_EMP = D.COD_EMP
                      AND A.COD_CLIENTE = D.COD_CLIENTE
                      AND A.COD_EMP = B.COD_EMP
                      AND A.COD_CLIENTE = B.COD_CLIENTE
                      AND B.QTD_COMPRAS_VP >= :NRO_COMPRA_INI
                      AND B.QTD_COMPRAS_VP <= :NRO_COMPRA_FIM
                      AND A.COD_EMP = :COD_EMP
                      AND A.COD_CLIENTE = :COD_CLIENTE
                      AND B.NUM_MDA >= :MDA_INI
                      AND B.NUM_MDA <= :MDA_FIM
                      AND B.COD_PERFIL_CLI >= :PERFIL_INI
                      AND B.COD_PERFIL_CLI <= :PERFIL_FIM
                     INTO :DES_CLIENTE,:DTA_CADASTRO,:DES_FONE_RESID,:DES_FONE_COMERC,:DES_FONE_CELULAR,:DES_FONE_CELULAR2,
                          :QTD_COMPRAS_VP,:QTD_MAIOR_ATRASO,:NUM_MDA,:COD_PERFIL_CLI
               DO BEGIN
                FOR SELECT DES_TELEFONE FROM CRE_PESSOA_AUTORIZADA
                  WHERE COD_EMP = :COD_EMP
                    AND COD_CLIENTE = :COD_CLIENTE
                    INTO :DES_FONE_AUT
               DO BEGIN
                    CONTADOR = 0;
                    BEGIN
                       SELECT COUNT(1)
                         FROM CRE_CONTAS_RECEBER
                        WHERE COD_EMP = :COD_EMP
                          AND COD_CLIENTE = :COD_CLIENTE
                          AND COD_CONTRATO = :COD_CONTRATO
                          AND DTA_VENCIMENTO < :DTA_INICIAL
                          AND IND_PRESTACAO = 0
                         INTO :CONTADOR;
                       WHEN SQLCODE -104 DO
                           CONTADOR = 0;
                    END
                    IF (CONTADOR = 0) THEN
                    BEGIN
                       SUSPEND;
                    END
                  END
                END
            END
     END
END
 ^

SET TERM ; ^
COMMIT WORK;
SET AUTODDL ON;