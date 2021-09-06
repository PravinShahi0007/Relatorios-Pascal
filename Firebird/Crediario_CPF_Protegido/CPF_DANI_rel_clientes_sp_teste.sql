COMMIT WORK;
SET AUTODDL OFF;
SET TERM ^ ;

/* Stored procedures */

CREATE PROCEDURE "REL_CLIENTES_SP_teste" 
(
  "ICOD_EMP" NUMERIC(3, 0),
  "IDT_CADASTRO_INI" DATE,
  "IDT_CADASTRO_FIM" DATE,
  "IDT_ALTERA_INI" DATE,
  "IDT_ALTERA_FIM" DATE,
  "IFLAG" NUMERIC(1, 0),
  "IORDER" NUMERIC(1, 0),
  "ICOD_UNI_CLI" NUMERIC(3, 0)
)
RETURNS
(
  "ICOD_CLIENTE" NUMERIC(14, 0),
  "IDES_ENDERECO" VARCHAR(50),
  "IDES_BAIRRO" VARCHAR(20),
  "IDES_CIDADE" VARCHAR(50),
  "IVLR_LIMITE" NUMERIC(15, 2),
  "IDES_FONE_RESID" VARCHAR(15),
  "IDES_FONE_CELULAR" VARCHAR(15),
  "IDES_FONE_CELULAR2" VARCHAR(15),
  "IDES_FONE_COMERC" VARCHAR(15),
  "IND_SPC" VARCHAR(5),
  "IVLR_RENDA" NUMERIC(15, 2),
  "STATUSCLIENTE" VARCHAR(15),
  "DTA_CADASTRO" DATE,
  "DTA_ALTERACAO" DATE,
  "ICOD_UNIDADE" NUMERIC(4, 0),
  "IDES_CLIENTE" VARCHAR(40),
  "IVALOR_PRI_COMPRA" NUMERIC(18, 2),
  "DTA_PRI_COMPRA" DATE,
  "COD_PES_APROV_CAD" NUMERIC(10, 0),
  "COD_PES_DIGIT_CAD" NUMERIC(10, 0),
  "ICPF_ESCONDIDO" VARCHAR(14)
)
AS
BEGIN EXIT; END ^


ALTER PROCEDURE "REL_CLIENTES_SP_teste" 
(
  "ICOD_EMP" NUMERIC(3, 0),
  "IDT_CADASTRO_INI" DATE,
  "IDT_CADASTRO_FIM" DATE,
  "IDT_ALTERA_INI" DATE,
  "IDT_ALTERA_FIM" DATE,
  "IFLAG" NUMERIC(1, 0),
  "IORDER" NUMERIC(1, 0),
  "ICOD_UNI_CLI" NUMERIC(3, 0)
)
RETURNS
(
  "ICOD_CLIENTE" NUMERIC(14, 0),
  "IDES_ENDERECO" VARCHAR(50),
  "IDES_BAIRRO" VARCHAR(20),
  "IDES_CIDADE" VARCHAR(50),
  "IVLR_LIMITE" NUMERIC(15, 2),
  "IDES_FONE_RESID" VARCHAR(15),
  "IDES_FONE_CELULAR" VARCHAR(15),
  "IDES_FONE_CELULAR2" VARCHAR(15),
  "IDES_FONE_COMERC" VARCHAR(15),
  "IND_SPC" VARCHAR(5),
  "IVLR_RENDA" NUMERIC(15, 2),
  "STATUSCLIENTE" VARCHAR(15),
  "DTA_CADASTRO" DATE,
  "DTA_ALTERACAO" DATE,
  "ICOD_UNIDADE" NUMERIC(4, 0),
  "IDES_CLIENTE" VARCHAR(40),
  "IVALOR_PRI_COMPRA" NUMERIC(18, 2),
  "DTA_PRI_COMPRA" DATE,
  "COD_PES_APROV_CAD" NUMERIC(10, 0),
  "COD_PES_DIGIT_CAD" NUMERIC(10, 0),
  "ICPF_ESCONDIDO" VARCHAR(14)
)
AS
DECLARE VARIABLE IIND_SPC NUMERIC(1);
DECLARE VARIABLE ICOD_CIDADE NUMERIC(4);
BEGIN
     IF( IFLAG=1)THEN /* CADASTRO*/
     BEGIN
          /*'AMBOS','CADASTRADO','ALTERADO',NOVOS;*/
          /**/
        IF (IORDER > 1 )THEN/*NOME*/
        BEGIN
           STATUSCLIENTE='CADASTRADO';
           FOR SELECT CRE_CLIENTES.COD_CLIENTE,
                      CRE_CLIENTES.DES_CLIENTE,
                      CRE_CLIENTES.DES_ENDERECO,
                      CRE_CLIENTES.DES_BAIRRO,
                      CRE_CLIENTES.COD_CIDADE,
                      CRE_CLIENTES.DES_TELEFONE,
                      CRE_CLIENTES.DES_FONE_CELULAR,
                      CRE_CLIENTES_CR.DES_FONE_CELULAR2,
                      CRE_CLIENTES_CR.DES_FONE_COMERC,
                      CRE_CLIENTES.DTA_CADASTRO,
                      CRE_CLIENTES.DTA_ALTERACAO,
                      CRE_CLIENTES.COD_UNIDADE,
                      CRE_CLIENTES_CR.VLR_LIMITE,
                      CRE_CLIENTES_CR.VLR_RENDA,
                      CRE_CLIENTES_CR.COD_PES_APROV_CAD,
                      CRE_CLIENTES_CR.COD_PES_DIGIT_CAD,
					  CASE WHEN TIP_PESSOA = 1  THEN
                 ''||substring((lpad(CRE_CLIENTES.COD_CLIENTE,11,'0')) from 1 for 5)||'******'
                  WHEN TIP_PESSOA = 2 THEN   '***********'||substring((lpad(CRE_CLIENTES.COD_CLIENTE,14,'0')) from 13 for 14)||''
                 ELSE CRE_CLIENTES.COD_CLIENTE
                 END AS ICPF_ESCONDIDO
                 FROM CRE_CLIENTES
                     ,CRE_CLIENTES_CR
                WHERE CRE_CLIENTES.COD_EMP = CRE_CLIENTES_CR.COD_EMP AND
                      CRE_CLIENTES.COD_CLIENTE  = CRE_CLIENTES_CR.COD_CLIENTE AND
                      CRE_CLIENTES.COD_EMP = :ICOD_EMP AND
                      CRE_CLIENTES.TIP_CLIENTE = 2 AND
                      CRE_CLIENTES.DTA_CADASTRO >= :IDT_CADASTRO_INI AND
                      CRE_CLIENTES.DTA_CADASTRO <= :IDT_CADASTRO_FIM
                ORDER BY CRE_CLIENTES.DTA_CADASTRO,CRE_CLIENTES.DES_CLIENTE
                 INTO :ICOD_CLIENTE,:IDES_CLIENTE,:IDES_ENDERECO,:IDES_BAIRRO,
                      :ICOD_CIDADE,:IDES_FONE_RESID,:IDES_FONE_CELULAR,:IDES_FONE_CELULAR2,
                      :IDES_FONE_COMERC,:DTA_CADASTRO,:DTA_ALTERACAO,:ICOD_UNIDADE,
                      :IVLR_LIMITE,:IVLR_RENDA,:COD_PES_APROV_CAD,:COD_PES_DIGIT_CAD, :ICPF_ESCONDIDO DO
           BEGIN
              IF((ICOD_UNI_CLI = 999)OR(ICOD_UNI_CLI = ICOD_UNIDADE))THEN
              BEGIN
                 SELECT IND_SPC
                   FROM CRE_SALDOS_CLI
                  WHERE COD_EMP = :ICOD_EMP AND
                        COD_CLIENTE = :ICOD_CLIENTE
                   INTO :IIND_SPC;
                 IF(IIND_SPC=1)THEN
                 BEGIN
                    IND_SPC='SIM';
                 END
                 ELSE
                 BEGIN
                    IND_SPC='NAO';
                 END
                 SELECT DES_CIDADE
                   FROM GER_CIDADES
                  WHERE COD_CIDADE=:ICOD_CIDADE
                   INTO IDES_CIDADE;
                 IF(IDES_ENDERECO IS NULL)THEN IDES_ENDERECO=' ';
                 IF(IDES_BAIRRO IS NULL)THEN IDES_BAIRRO=' ';
                 IF(IDES_CIDADE IS NULL)THEN IDES_CIDADE=' ';
                 IF(IVLR_LIMITE IS NULL)THEN IVLR_LIMITE=0;
                 IF(IDES_FONE_RESID IS NULL)THEN IDES_FONE_RESID=' ';
                 IF(IVLR_RENDA IS NULL)THEN IVLR_RENDA=0;
                 SUSPEND;
              END
           END
        END
        ELSE
        BEGIN
           STATUSCLIENTE='CADASTRADO';
           FOR SELECT CRE_CLIENTES.COD_CLIENTE,
                      CRE_CLIENTES.DES_CLIENTE,
                      CRE_CLIENTES.DES_ENDERECO,
                      CRE_CLIENTES.DES_BAIRRO,
                      CRE_CLIENTES.COD_CIDADE,
                      CRE_CLIENTES.DES_TELEFONE,
                      CRE_CLIENTES.DES_FONE_CELULAR,
                      CRE_CLIENTES_CR.DES_FONE_CELULAR2,
                      CRE_CLIENTES_CR.DES_FONE_COMERC,
                      CRE_CLIENTES.DTA_CADASTRO,
                      CRE_CLIENTES.DTA_ALTERACAO,
                      CRE_CLIENTES.COD_UNIDADE,
                      CRE_CLIENTES_CR.VLR_LIMITE,
                      CRE_CLIENTES_CR.VLR_RENDA,
                      CRE_CLIENTES_CR.COD_PES_APROV_CAD,
                      CRE_CLIENTES_CR.COD_PES_DIGIT_CAD,
					 CASE WHEN TIP_PESSOA = 1  THEN
                 ''||substring((lpad(CRE_CLIENTES.COD_CLIENTE,11,'0')) from 1 for 5)||'******'
                  WHEN TIP_PESSOA = 2 THEN   '***********'||substring((lpad(CRE_CLIENTES.COD_CLIENTE,14,'0')) from 13 for 14)||''
                 ELSE CRE_CLIENTES.COD_CLIENTE
                 END AS ICPF_ESCONDIDO
                 FROM CRE_CLIENTES
                     ,CRE_CLIENTES_CR
                WHERE CRE_CLIENTES.COD_EMP = CRE_CLIENTES_CR.COD_EMP AND
                      CRE_CLIENTES.COD_CLIENTE = CRE_CLIENTES_CR.COD_CLIENTE AND
                      CRE_CLIENTES.COD_EMP = :ICOD_EMP AND
                      CRE_CLIENTES.TIP_CLIENTE = 2 AND
                      CRE_CLIENTES.DTA_CADASTRO >= :IDT_CADASTRO_INI AND
                      CRE_CLIENTES.DTA_CADASTRO <= :IDT_CADASTRO_FIM
                ORDER BY CRE_CLIENTES.DTA_CADASTRO,CRE_CLIENTES.COD_CLIENTE
                 INTO :ICOD_CLIENTE,:IDES_CLIENTE,:IDES_ENDERECO,:IDES_BAIRRO,
                      :ICOD_CIDADE,:IDES_FONE_RESID,:IDES_FONE_CELULAR,:IDES_FONE_CELULAR2,
                      :IDES_FONE_COMERC,:DTA_CADASTRO,:DTA_ALTERACAO,:ICOD_UNIDADE,
                      :IVLR_LIMITE,:IVLR_RENDA,:COD_PES_APROV_CAD,:COD_PES_DIGIT_CAD, :ICPF_ESCONDIDO DO
           BEGIN
              IF((ICOD_UNI_CLI = 999)OR(ICOD_UNI_CLI = ICOD_UNIDADE))THEN
              BEGIN
                 SELECT IND_SPC
                   FROM CRE_SALDOS_CLI
                  WHERE COD_EMP=:ICOD_EMP AND
                        COD_CLIENTE =:ICOD_CLIENTE
                   INTO :IIND_SPC;
                 IF(IIND_SPC=1)THEN
                 BEGIN
                    IND_SPC='SIM';
                 END
                 ELSE
                 BEGIN
                    IND_SPC='NAO';
                 END
                 SELECT DES_CIDADE FROM GER_CIDADES WHERE COD_CIDADE=:ICOD_CIDADE INTO IDES_CIDADE;
                 IF(IDES_ENDERECO IS NULL)THEN IDES_ENDERECO=' ';
                 IF(IDES_BAIRRO IS NULL)THEN IDES_BAIRRO=' ';
                 IF(IDES_CIDADE IS NULL)THEN IDES_CIDADE=' ';
                 IF(IVLR_LIMITE IS NULL)THEN IVLR_LIMITE=0;
                 IF(IDES_FONE_RESID IS NULL)THEN IDES_FONE_RESID=' ';
                 IF(IVLR_RENDA IS NULL)THEN IVLR_RENDA=0;
                 SUSPEND;
              END
           END
        END
     END
     IF( IFLAG=2)THEN /* ALTERACAO*/
     BEGIN
          /*'AMBOS','CADASTRADO','ALTERADO',NOVOS;*/
          /**/
        IF( IORDER > 1)THEN
        BEGIN
           STATUSCLIENTE='ALTERADO';
           FOR SELECT CRE_CLIENTES.COD_CLIENTE,
                      CRE_CLIENTES.DES_CLIENTE,
                      CRE_CLIENTES.DES_ENDERECO,
                      CRE_CLIENTES.DES_BAIRRO,
                      CRE_CLIENTES.COD_CIDADE,
                      CRE_CLIENTES.DES_TELEFONE,
                      CRE_CLIENTES.DES_FONE_CELULAR,
                      CRE_CLIENTES_CR.DES_FONE_CELULAR2,
                      CRE_CLIENTES_CR.DES_FONE_COMERC,
                      CRE_CLIENTES.DTA_CADASTRO,
                      CRE_CLIENTES.DTA_ALTERACAO,
                      CRE_CLIENTES.COD_UNIDADE,
                      CRE_CLIENTES_CR.VLR_LIMITE,
                      CRE_CLIENTES_CR.VLR_RENDA,
                      CRE_CLIENTES_CR.COD_PES_APROV_CAD,
                      CRE_CLIENTES_CR.COD_PES_DIGIT_CAD,
					  CASE WHEN TIP_PESSOA = 1  THEN
                 ''||substring((lpad(CRE_CLIENTES.COD_CLIENTE,11,'0')) from 1 for 5)||'******'
                  WHEN TIP_PESSOA = 2 THEN   '***********'||substring((lpad(CRE_CLIENTES.COD_CLIENTE,14,'0')) from 13 for 14)||''
                 ELSE CRE_CLIENTES.COD_CLIENTE
                 END AS ICPF_ESCONDIDO
                 FROM CRE_CLIENTES
                     ,CRE_CLIENTES_CR
                WHERE CRE_CLIENTES.COD_EMP = CRE_CLIENTES_CR.COD_EMP AND
                      CRE_CLIENTES.COD_CLIENTE = CRE_CLIENTES_CR.COD_CLIENTE AND
                      CRE_CLIENTES.COD_EMP = :ICOD_EMP AND
                      CRE_CLIENTES.TIP_CLIENTE = 2 AND
                      CRE_CLIENTES.DTA_ALTERACAO >= :IDT_ALTERA_INI AND
                      CRE_CLIENTES.DTA_ALTERACAO <= :IDT_ALTERA_FIM
                ORDER BY CRE_CLIENTES.DTA_ALTERACAO,CRE_CLIENTES.DES_CLIENTE
                 INTO :ICOD_CLIENTE,:IDES_CLIENTE,:IDES_ENDERECO,:IDES_BAIRRO,
                      :ICOD_CIDADE,:IDES_FONE_RESID,:IDES_FONE_CELULAR,:IDES_FONE_CELULAR2,
                      :IDES_FONE_COMERC,:DTA_CADASTRO,:DTA_ALTERACAO,:ICOD_UNIDADE,
                      :IVLR_LIMITE,:IVLR_RENDA,:COD_PES_APROV_CAD,:COD_PES_DIGIT_CAD, :ICPF_ESCONDIDO DO
           BEGIN
              IF((ICOD_UNI_CLI = 999)OR(ICOD_UNI_CLI = ICOD_UNIDADE))THEN
              BEGIN
                 SELECT IND_SPC
                   FROM CRE_SALDOS_CLI
                  WHERE COD_EMP=:ICOD_EMP AND
                        COD_CLIENTE =:ICOD_CLIENTE
                   INTO :IIND_SPC;
                 IF(IIND_SPC=1)THEN
                 BEGIN
                    IND_SPC='SIM';
                 END
                 ELSE
                 BEGIN
                    IND_SPC='NAO';
                 END
                 SELECT DES_CIDADE FROM GER_CIDADES WHERE COD_CIDADE=:ICOD_CIDADE INTO IDES_CIDADE;
                 IF(IDES_ENDERECO IS NULL)THEN IDES_ENDERECO=' ';
                 IF(IDES_BAIRRO IS NULL)THEN IDES_BAIRRO=' ';
                 IF(IDES_CIDADE IS NULL)THEN IDES_CIDADE=' ';
                 IF(IVLR_LIMITE IS NULL)THEN IVLR_LIMITE=0;
                 IF(IDES_FONE_RESID IS NULL)THEN IDES_FONE_RESID=' ';
                 IF(IVLR_RENDA IS NULL)THEN IVLR_RENDA=0;
                 SUSPEND;
              END
           END
        END
        ELSE
        BEGIN
           STATUSCLIENTE='ALTERADO';
           FOR SELECT CRE_CLIENTES.COD_CLIENTE,
                      CRE_CLIENTES.DES_CLIENTE,
                      CRE_CLIENTES.DES_ENDERECO,
                      CRE_CLIENTES.DES_BAIRRO,
                      CRE_CLIENTES.COD_CIDADE,
                      CRE_CLIENTES.DES_TELEFONE,
                      CRE_CLIENTES.DES_FONE_CELULAR,
                      CRE_CLIENTES_CR.DES_FONE_CELULAR2,
                      CRE_CLIENTES_CR.DES_FONE_COMERC,
                      CRE_CLIENTES.DTA_CADASTRO,
                      CRE_CLIENTES.DTA_ALTERACAO,
                      CRE_CLIENTES.COD_UNIDADE,
                      CRE_CLIENTES_CR.VLR_LIMITE,
                      CRE_CLIENTES_CR.VLR_RENDA,
                      CRE_CLIENTES_CR.COD_PES_APROV_CAD,
                      CRE_CLIENTES_CR.COD_PES_DIGIT_CAD,
					  CASE WHEN TIP_PESSOA = 1  THEN
                 ''||substring((lpad(CRE_CLIENTES.COD_CLIENTE,11,'0')) from 1 for 5)||'******'
                  WHEN TIP_PESSOA = 2 THEN   '***********'||substring((lpad(CRE_CLIENTES.COD_CLIENTE,14,'0')) from 13 for 14)||''
                 ELSE CRE_CLIENTES.COD_CLIENTE
                 END AS ICPF_ESCONDIDO
                 FROM CRE_CLIENTES
                     ,CRE_CLIENTES_CR
                WHERE CRE_CLIENTES.COD_EMP = CRE_CLIENTES_CR.COD_EMP AND
                      CRE_CLIENTES.COD_CLIENTE = CRE_CLIENTES_CR.COD_CLIENTE AND
                      CRE_CLIENTES.COD_EMP =:ICOD_EMP AND
                      CRE_CLIENTES.TIP_CLIENTE = 2 AND
                      CRE_CLIENTES.DTA_ALTERACAO >=:IDT_ALTERA_INI AND
                      CRE_CLIENTES.DTA_ALTERACAO <=:IDT_ALTERA_FIM
                ORDER BY CRE_CLIENTES.DTA_ALTERACAO,CRE_CLIENTES.COD_CLIENTE
                 INTO :ICOD_CLIENTE,:IDES_CLIENTE,:IDES_ENDERECO,:IDES_BAIRRO,
                      :ICOD_CIDADE,:IDES_FONE_RESID,:IDES_FONE_CELULAR,:IDES_FONE_CELULAR2,
                      :IDES_FONE_COMERC,:DTA_CADASTRO,:DTA_ALTERACAO,:ICOD_UNIDADE,
                      :IVLR_LIMITE,:IVLR_RENDA,:COD_PES_APROV_CAD,:COD_PES_DIGIT_CAD, :ICPF_ESCONDIDO DO
           BEGIN
              IF((ICOD_UNI_CLI = 999)OR(ICOD_UNI_CLI = ICOD_UNIDADE))THEN
              BEGIN
                 SELECT IND_SPC
                   FROM CRE_SALDOS_CLI
                  WHERE COD_EMP=:ICOD_EMP AND
                        COD_CLIENTE =:ICOD_CLIENTE
                   INTO :IIND_SPC;
                 IF(IIND_SPC=1)THEN
                 BEGIN
                    IND_SPC='SIM';
                 END
                 ELSE
                 BEGIN
                   IND_SPC='NAO';
                 END
                 SELECT DES_CIDADE FROM GER_CIDADES WHERE COD_CIDADE=:ICOD_CIDADE INTO IDES_CIDADE;
                 IF(IDES_ENDERECO IS NULL)THEN IDES_ENDERECO=' ';
                 IF(IDES_BAIRRO IS NULL)THEN IDES_BAIRRO=' ';
                 IF(IDES_CIDADE IS NULL)THEN IDES_CIDADE=' ';
                 IF(IVLR_LIMITE IS NULL)THEN IVLR_LIMITE=0;
                 IF(IDES_FONE_RESID IS NULL)THEN IDES_FONE_RESID=' ';
                 IF(IVLR_RENDA IS NULL)THEN IVLR_RENDA=0;
                 SUSPEND;
              END
           END
        END
     END
     IF( IFLAG=3)THEN /* NOVOS*/
     BEGIN
          /*'AMBOS','CADASTRADO','ALTERADO',NOVOS;*/
          /**/
        IF( IORDER > 1)THEN
        BEGIN
           STATUSCLIENTE='NOVO';
           FOR SELECT CRE_CLIENTES.COD_CLIENTE,
                      CRE_CLIENTES.DES_CLIENTE,
                      CRE_CLIENTES.DES_ENDERECO,
                      CRE_CLIENTES.DES_BAIRRO,
                      CRE_CLIENTES.COD_CIDADE,
                      CRE_CLIENTES.DES_TELEFONE,
                      CRE_CLIENTES.DES_FONE_CELULAR,
                      CRE_CLIENTES_CR.DES_FONE_CELULAR2,
                      CRE_CLIENTES_CR.DES_FONE_COMERC,
                      CRE_CLIENTES.DTA_CADASTRO,
                      CRE_CLIENTES.DTA_ALTERACAO,
                      CRE_CLIENTES.COD_UNIDADE,
                      CRE_CLIENTES_CR.VLR_LIMITE,
                      CRE_CLIENTES_CR.VLR_RENDA,
                      CRE_SALDOS_CLI.DTA_PRI_COMPRA_VP,
                      CRE_CLIENTES_CR.COD_PES_APROV_CAD,
                      CRE_CLIENTES_CR.COD_PES_DIGIT_CAD,
					 CASE WHEN TIP_PESSOA = 1  THEN
                 ''||substring((lpad(CRE_CLIENTES.COD_CLIENTE,11,'0')) from 1 for 5)||'******'
                  WHEN TIP_PESSOA = 2 THEN   '***********'||substring((lpad(CRE_CLIENTES.COD_CLIENTE,14,'0')) from 13 for 14)||''
                 ELSE CRE_CLIENTES.COD_CLIENTE
                 END AS ICPF_ESCONDIDO
                 FROM CRE_CLIENTES
                     ,CRE_CLIENTES_CR
                     ,CRE_SALDOS_CLI
                WHERE CRE_CLIENTES.COD_EMP = CRE_CLIENTES_CR.COD_EMP AND
                      CRE_CLIENTES.COD_EMP = CRE_SALDOS_CLI.COD_EMP AND
                      CRE_CLIENTES.COD_CLIENTE = CRE_CLIENTES_CR.COD_CLIENTE AND
                      CRE_CLIENTES.COD_CLIENTE = CRE_SALDOS_CLI.COD_CLIENTE AND
                      CRE_CLIENTES.COD_EMP = :ICOD_EMP AND
                      CRE_CLIENTES.TIP_CLIENTE = 2 AND
                      CRE_SALDOS_CLI.DTA_PRI_COMPRA_VP >=:IDT_ALTERA_INI AND
                      CRE_SALDOS_CLI.DTA_PRI_COMPRA_VP <=:IDT_ALTERA_FIM
                ORDER BY CRE_SALDOS_CLI.DTA_PRI_COMPRA_VP,CRE_CLIENTES.DES_CLIENTE
                 INTO :ICOD_CLIENTE,:IDES_CLIENTE,:IDES_ENDERECO,:IDES_BAIRRO,
                      :ICOD_CIDADE,:IDES_FONE_RESID,:IDES_FONE_CELULAR,:IDES_FONE_CELULAR2,
                      :IDES_FONE_COMERC,:DTA_CADASTRO,:DTA_ALTERACAO,:ICOD_UNIDADE,
                      :IVLR_LIMITE,:IVLR_RENDA,:DTA_PRI_COMPRA,:COD_PES_APROV_CAD,:COD_PES_DIGIT_CAD, :ICPF_ESCONDIDO DO
           BEGIN
              IF((ICOD_UNI_CLI = 999)OR(ICOD_UNI_CLI = ICOD_UNIDADE))THEN
              BEGIN
                 FOR SELECT SUM(VLR_TOTAL)
                       FROM EST_CUPONS
                      WHERE COD_EMP = :ICOD_EMP AND
                      	    COD_UNIDADE = :ICOD_UNIDADE AND
                      	    COD_CLIENTE = :ICOD_CLIENTE AND
                      	    DTA_MOVIMENTO = :DTA_PRI_COMPRA AND
                      	    TIP_VENDA = 2
                       INTO IVALOR_PRI_COMPRA DO
                 BEGIN
                    SELECT IND_SPC
                      FROM CRE_SALDOS_CLI
                     WHERE COD_EMP=:ICOD_EMP AND
                           COD_CLIENTE =:ICOD_CLIENTE
                      INTO :IIND_SPC;
                    IF(IIND_SPC=1)THEN
                    BEGIN
                       IND_SPC='SIM';
                    END
                    ELSE
                    BEGIN
                       IND_SPC='NAO';
                    END
                    SELECT DES_CIDADE FROM GER_CIDADES WHERE COD_CIDADE=:ICOD_CIDADE INTO IDES_CIDADE;
                    IF(IDES_ENDERECO IS NULL)THEN IDES_ENDERECO=' ';
                    IF(IDES_BAIRRO IS NULL)THEN IDES_BAIRRO=' ';
                    IF(IDES_CIDADE IS NULL)THEN IDES_CIDADE=' ';
                    IF(IVLR_LIMITE IS NULL)THEN IVLR_LIMITE=0;
                    IF(IDES_FONE_RESID IS NULL)THEN IDES_FONE_RESID=' ';
                    IF(IVLR_RENDA IS NULL)THEN IVLR_RENDA=0;
                    SUSPEND;
                 END
              END
           END
        END
        ELSE
        BEGIN
           STATUSCLIENTE='NOVO';
           FOR SELECT CRE_CLIENTES.COD_CLIENTE,
                      CRE_CLIENTES.DES_CLIENTE,
                      CRE_CLIENTES.DES_ENDERECO,
                      CRE_CLIENTES.DES_BAIRRO,
                      CRE_CLIENTES.COD_CIDADE,
                      CRE_CLIENTES.DES_TELEFONE,
                      CRE_CLIENTES.DES_FONE_CELULAR,
                      CRE_CLIENTES_CR.DES_FONE_CELULAR2,
                      CRE_CLIENTES_CR.DES_FONE_COMERC,
                      CRE_CLIENTES.DTA_CADASTRO,
                      CRE_CLIENTES.DTA_ALTERACAO,
                      CRE_CLIENTES.COD_UNIDADE,
                      CRE_CLIENTES_CR.VLR_LIMITE,
                      CRE_CLIENTES_CR.VLR_RENDA,
                      CRE_SALDOS_CLI.DTA_PRI_COMPRA_VP,
                      CRE_CLIENTES_CR.COD_PES_APROV_CAD,
                      CRE_CLIENTES_CR.COD_PES_DIGIT_CAD,
					  CASE WHEN TIP_PESSOA = 1  THEN
                 ''||substring((lpad(CRE_CLIENTES.COD_CLIENTE,11,'0')) from 1 for 5)||'******'
                  WHEN TIP_PESSOA = 2 THEN   '***********'||substring((lpad(CRE_CLIENTES.COD_CLIENTE,14,'0')) from 13 for 14)||''
                 ELSE CRE_CLIENTES.COD_CLIENTE
                 END AS ICPF_ESCONDIDO
                 FROM CRE_CLIENTES
                     ,CRE_CLIENTES_CR
                     ,CRE_SALDOS_CLI
                WHERE CRE_CLIENTES.COD_EMP = CRE_CLIENTES_CR.COD_EMP AND
                      CRE_CLIENTES.COD_EMP = CRE_SALDOS_CLI.COD_EMP AND
                      CRE_CLIENTES.COD_CLIENTE = CRE_CLIENTES_CR.COD_CLIENTE AND
                      CRE_CLIENTES.COD_CLIENTE = CRE_SALDOS_CLI.COD_CLIENTE AND
                      CRE_CLIENTES.COD_EMP = :ICOD_EMP AND
                      CRE_CLIENTES.TIP_CLIENTE = 2 AND
                      CRE_SALDOS_CLI.DTA_PRI_COMPRA_VP >=:IDT_ALTERA_INI AND
                      CRE_SALDOS_CLI.DTA_PRI_COMPRA_VP <=:IDT_ALTERA_FIM
                ORDER BY CRE_SALDOS_CLI.DTA_PRI_COMPRA_VP,CRE_CLIENTES.COD_CLIENTE
                 INTO :ICOD_CLIENTE,:IDES_CLIENTE,:IDES_ENDERECO,:IDES_BAIRRO,
                      :ICOD_CIDADE,:IDES_FONE_RESID,:IDES_FONE_CELULAR,:IDES_FONE_CELULAR2,
                      :IDES_FONE_COMERC,:DTA_CADASTRO,:DTA_ALTERACAO,:ICOD_UNIDADE,
                      :IVLR_LIMITE,:IVLR_RENDA,:DTA_PRI_COMPRA,:COD_PES_APROV_CAD,:COD_PES_DIGIT_CAD, :ICPF_ESCONDIDO DO
           BEGIN
              IF((ICOD_UNI_CLI = 999)OR(ICOD_UNI_CLI = ICOD_UNIDADE))THEN
              BEGIN
                 FOR SELECT SUM(VLR_TOTAL)
                       FROM EST_CUPONS
                      WHERE COD_EMP = :ICOD_EMP AND
                      	    COD_UNIDADE = :ICOD_UNIDADE AND
                      	    COD_CLIENTE = :ICOD_CLIENTE AND
                      	    DTA_MOVIMENTO = :DTA_PRI_COMPRA AND
                      	    TIP_VENDA = 2
                       INTO IVALOR_PRI_COMPRA DO
                 BEGIN
                    SELECT IND_SPC
                      FROM CRE_SALDOS_CLI
                     WHERE COD_EMP=:ICOD_EMP AND
                           COD_CLIENTE =:ICOD_CLIENTE
                      INTO :IIND_SPC;
                    IF(IIND_SPC=1)THEN
                    BEGIN
                       IND_SPC='SIM';
                    END
                    ELSE
                    BEGIN
                       IND_SPC='NAO';
                    END
                    SELECT DES_CIDADE FROM GER_CIDADES WHERE COD_CIDADE=:ICOD_CIDADE INTO IDES_CIDADE;
                    IF(IDES_ENDERECO IS NULL)THEN IDES_ENDERECO=' ';
                    IF(IDES_BAIRRO IS NULL)THEN IDES_BAIRRO=' ';
                    IF(IDES_CIDADE IS NULL)THEN IDES_CIDADE=' ';
                    IF(IVLR_LIMITE IS NULL)THEN IVLR_LIMITE=0;
                    IF(IDES_FONE_RESID IS NULL)THEN IDES_FONE_RESID=' ';
                    IF(IVLR_RENDA IS NULL)THEN IVLR_RENDA=0;
                    SUSPEND;
                 END
              END
           END
        END
     END
     IF( IFLAG=4)THEN /* AMBOS*/
     BEGIN
          /*'AMBOS','CADASTRADO','ALTERADO',NOVOS;*/
          /**/
        IF(IORDER > 1 )THEN
        BEGIN
           STATUSCLIENTE='AMBOS';
           FOR SELECT CRE_CLIENTES.COD_CLIENTE,
                      CRE_CLIENTES.DES_CLIENTE,
                      CRE_CLIENTES.DES_ENDERECO,
                      CRE_CLIENTES.DES_BAIRRO,
                      CRE_CLIENTES.COD_CIDADE,
                      CRE_CLIENTES.DES_TELEFONE,
                      CRE_CLIENTES.DES_FONE_CELULAR,
                      CRE_CLIENTES_CR.DES_FONE_CELULAR2,
                      CRE_CLIENTES_CR.DES_FONE_COMERC,
                      CRE_CLIENTES.DTA_CADASTRO,
                      CRE_CLIENTES.DTA_ALTERACAO,
                      CRE_CLIENTES.COD_UNIDADE,
                      CRE_CLIENTES_CR.VLR_LIMITE,
                      CRE_CLIENTES_CR.VLR_RENDA,
                      CRE_CLIENTES_CR.COD_PES_APROV_CAD,
                      CRE_CLIENTES_CR.COD_PES_DIGIT_CAD,
					 CASE WHEN TIP_PESSOA = 1  THEN
                 ''||substring((lpad(CRE_CLIENTES.COD_CLIENTE,11,'0')) from 1 for 5)||'******'
                  WHEN TIP_PESSOA = 2 THEN   '***********'||substring((lpad(CRE_CLIENTES.COD_CLIENTE,14,'0')) from 13 for 14)||''
                 ELSE CRE_CLIENTES.COD_CLIENTE
                 END AS ICPF_ESCONDIDO
                 FROM CRE_CLIENTES
                     ,CRE_CLIENTES_CR
                WHERE CRE_CLIENTES.COD_EMP=CRE_CLIENTES_CR.COD_EMP AND
                      CRE_CLIENTES.COD_CLIENTE=CRE_CLIENTES_CR.COD_CLIENTE AND
                      CRE_CLIENTES.COD_EMP=:ICOD_EMP AND
                      CRE_CLIENTES.TIP_CLIENTE   = 2 AND
                      ((CRE_CLIENTES.DTA_ALTERACAO >=:IDT_ALTERA_INI AND
                        CRE_CLIENTES.DTA_ALTERACAO <=:IDT_ALTERA_FIM)OR
                       (CRE_CLIENTES.DTA_CADASTRO  >=:IDT_CADASTRO_INI AND
                        CRE_CLIENTES.DTA_CADASTRO  <=:IDT_CADASTRO_FIM))
                ORDER BY CRE_CLIENTES.DTA_CADASTRO,CRE_CLIENTES.DES_CLIENTE
                 INTO :ICOD_CLIENTE,:IDES_CLIENTE,:IDES_ENDERECO,:IDES_BAIRRO,
                      :ICOD_CIDADE,:IDES_FONE_RESID,:IDES_FONE_CELULAR,:IDES_FONE_CELULAR2,
                      :IDES_FONE_COMERC,:DTA_CADASTRO,:DTA_ALTERACAO,:ICOD_UNIDADE,
                      :IVLR_LIMITE,:IVLR_RENDA,:COD_PES_APROV_CAD,:COD_PES_DIGIT_CAD, :ICPF_ESCONDIDO DO
           BEGIN
              IF((ICOD_UNI_CLI = 999)OR(ICOD_UNI_CLI = ICOD_UNIDADE))THEN
              BEGIN
                 SELECT IND_SPC
                   FROM CRE_SALDOS_CLI
                  WHERE COD_EMP=:ICOD_EMP AND
                        COD_CLIENTE =:ICOD_CLIENTE
                   INTO :IIND_SPC;
                 IF(IIND_SPC=1)THEN
                 BEGIN
                    IND_SPC='SIM';
                 END
                 ELSE
                 BEGIN
                    IND_SPC='NAO';
                 END
                 SELECT DES_CIDADE FROM GER_CIDADES WHERE COD_CIDADE=:ICOD_CIDADE INTO IDES_CIDADE;
                 IF(IDES_ENDERECO IS NULL)THEN IDES_ENDERECO=' ';
                 IF(IDES_BAIRRO IS NULL)THEN IDES_BAIRRO=' ';
                 IF(IDES_CIDADE IS NULL)THEN IDES_CIDADE=' ';
                 IF(IVLR_LIMITE IS NULL)THEN IVLR_LIMITE=0;
                 IF(IDES_FONE_RESID IS NULL)THEN IDES_FONE_RESID=' ';
                 IF(IVLR_RENDA IS NULL)THEN IVLR_RENDA=0;
                 SUSPEND;
              END
           END
        END
        ELSE
        BEGIN
           STATUSCLIENTE='AMBOS';
           FOR SELECT CRE_CLIENTES.COD_CLIENTE,
                      CRE_CLIENTES.DES_CLIENTE,
                      CRE_CLIENTES.DES_ENDERECO,
                      CRE_CLIENTES.DES_BAIRRO,
                      CRE_CLIENTES.COD_CIDADE,
                      CRE_CLIENTES.DES_TELEFONE,
                      CRE_CLIENTES.DES_FONE_CELULAR,
                      CRE_CLIENTES_CR.DES_FONE_CELULAR2,
                      CRE_CLIENTES_CR.DES_FONE_COMERC,
                      CRE_CLIENTES.DTA_CADASTRO,
                      CRE_CLIENTES.DTA_ALTERACAO,
                      CRE_CLIENTES.COD_UNIDADE,
                      CRE_CLIENTES_CR.VLR_LIMITE,
                      CRE_CLIENTES_CR.VLR_RENDA,
                      CRE_CLIENTES_CR.COD_PES_APROV_CAD,
                      CRE_CLIENTES_CR.COD_PES_DIGIT_CAD,
					  CASE WHEN TIP_PESSOA = 1  THEN
                 ''||substring((lpad(CRE_CLIENTES.COD_CLIENTE,11,'0')) from 1 for 5)||'******'
                  WHEN TIP_PESSOA = 2 THEN   '***********'||substring((lpad(CRE_CLIENTES.COD_CLIENTE,14,'0')) from 13 for 14)||''
                 ELSE CRE_CLIENTES.COD_CLIENTE
                 END AS ICPF_ESCONDIDO
                 FROM CRE_CLIENTES
                     ,CRE_CLIENTES_CR
                WHERE CRE_CLIENTES.COD_EMP = CRE_CLIENTES_CR.COD_EMP AND
                      CRE_CLIENTES.COD_CLIENTE = CRE_CLIENTES_CR.COD_CLIENTE AND
                      CRE_CLIENTES.COD_EMP=:ICOD_EMP AND
                      CRE_CLIENTES.TIP_CLIENTE   = 2 AND
                      ((CRE_CLIENTES.DTA_ALTERACAO >=:IDT_ALTERA_INI AND
                        CRE_CLIENTES.DTA_ALTERACAO <=:IDT_ALTERA_FIM)OR
                       (CRE_CLIENTES.DTA_CADASTRO  >=:IDT_CADASTRO_INI AND
                        CRE_CLIENTES.DTA_CADASTRO  <=:IDT_CADASTRO_FIM))
                ORDER BY CRE_CLIENTES.DTA_CADASTRO,CRE_CLIENTES.COD_CLIENTE
                 INTO :ICOD_CLIENTE,:IDES_CLIENTE,:IDES_ENDERECO,:IDES_BAIRRO,
                      :ICOD_CIDADE,:IDES_FONE_RESID,:IDES_FONE_CELULAR,:IDES_FONE_CELULAR2,
                      :IDES_FONE_COMERC,:DTA_CADASTRO,:DTA_ALTERACAO,:ICOD_UNIDADE,
                      :IVLR_LIMITE,:IVLR_RENDA,:COD_PES_APROV_CAD,:COD_PES_DIGIT_CAD, :ICPF_ESCONDIDO DO
           BEGIN
              IF((ICOD_UNI_CLI = 999)OR(ICOD_UNI_CLI = ICOD_UNIDADE))THEN
              BEGIN
                 SELECT IND_SPC
                   FROM CRE_SALDOS_CLI
                  WHERE COD_EMP=:ICOD_EMP AND
                        COD_CLIENTE =:ICOD_CLIENTE
                   INTO :IIND_SPC;
                 IF(IIND_SPC=1)THEN
                 BEGIN
                    IND_SPC='SIM';
                 END
                 ELSE
                 BEGIN
                    IND_SPC='NAO';
                 END
                 SELECT DES_CIDADE FROM GER_CIDADES WHERE COD_CIDADE=:ICOD_CIDADE INTO IDES_CIDADE;
                 IF(IDES_ENDERECO IS NULL)THEN IDES_ENDERECO=' ';
                 IF(IDES_BAIRRO IS NULL)THEN IDES_BAIRRO=' ';
                 IF(IDES_CIDADE IS NULL)THEN IDES_CIDADE=' ';
                 IF(IVLR_LIMITE IS NULL)THEN IVLR_LIMITE=0;
                 IF(IDES_FONE_RESID IS NULL)THEN IDES_FONE_RESID=' ';
                 IF(IVLR_RENDA IS NULL)THEN IVLR_RENDA=0;
                 SUSPEND;
              END
           END
        END
     END
END
 ^

SET TERM ; ^
COMMIT WORK;
SET AUTODDL ON;