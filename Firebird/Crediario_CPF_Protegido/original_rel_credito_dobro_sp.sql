COMMIT WORK;
SET AUTODDL OFF;
SET TERM ^ ;

/* Stored procedures */

CREATE PROCEDURE "REL_CREDITO_DOBRO_SP" 
(
  "COD_EMP" NUMERIC(3, 0),
  "COD_UNIDADE" NUMERIC(4, 0),
  "COD_PERFIL_INI" NUMERIC(3, 0),
  "COD_PERFIL_FIM" NUMERIC(3, 0),
  "SELECAO" NUMERIC(10, 0),
  "DTA_INI" DATE,
  "DTA_FIM" DATE,
  "OP_REL" NUMERIC(1, 0),
  "LIMITE" NUMERIC(4, 0)
)
RETURNS
(
  "COD_CLIENTE" NUMERIC(14, 0),
  "DES_CLIENTE" VARCHAR(50),
  "NUM_CPF_CNPJ" NUMERIC(14, 0),
  "DES_FONE_RESID" VARCHAR(15),
  "DES_FONE_CELULAR" VARCHAR(15),
  "DES_FONE_COMERC" VARCHAR(15),
  "COD_PERFIL_CLI" NUMERIC(3, 0),
  "VLR_LIMITE" NUMERIC(18, 2),
  "ICOMPROU" NUMERIC(3, 0)
)
AS
BEGIN EXIT; END ^


ALTER PROCEDURE "rel_credito_dobro_sp" 
(
  "COD_EMP" NUMERIC(3, 0),
  "COD_UNIDADE" NUMERIC(4, 0),
  "COD_PERFIL_INI" NUMERIC(3, 0),
  "COD_PERFIL_FIM" NUMERIC(3, 0),
  "SELECAO" NUMERIC(10, 0),
  "DTA_INI" DATE,
  "DTA_FIM" DATE,
  "OP_REL" NUMERIC(1, 0),
  "LIMITE" NUMERIC(4, 0)
)
RETURNS
(
  "COD_CLIENTE" NUMERIC(14, 0),
  "DES_CLIENTE" VARCHAR(50),
  "NUM_CPF_CNPJ" NUMERIC(14, 0),
  "DES_FONE_RESID" VARCHAR(15),
  "DES_FONE_CELULAR" VARCHAR(15),
  "DES_FONE_COMERC" VARCHAR(15),
  "COD_PERFIL_CLI" NUMERIC(3, 0),
  "VLR_LIMITE" NUMERIC(18, 2),
  "ICOMPROU" NUMERIC(3, 0)
)
AS
--DECLARE VARIABLE ICOMPROU NUMERIC(1,0);
BEGIN
    FOR SELECT A.COD_CLIENTE,
               A.DES_CLIENTE,
               A.NUM_CPF_CNPJ,
               B.DES_FONE_RESID,
               B.DES_FONE_CELULAR,
               B.DES_FONE_COMERC,
               C.COD_PERFIL_CLI,
               B.VLR_LIMITE
          FROM CRE_CLIENTES A
              ,CRE_CLIENTES_CR B
              ,CRE_SALDOS_CLI C
              ,CRE_SELECAO_CLI D
         WHERE A.COD_EMP=B.COD_EMP
           AND A.COD_EMP = C.COD_EMP
           AND A.COD_EMP = :COD_EMP
           AND A.COD_UNIDADE = :COD_UNIDADE
           AND A.COD_CLIENTE= B.COD_CLIENTE
           AND A.COD_CLIENTE = C.COD_CLIENTE
           AND D.NUM_SELECAO = :SELECAO
           AND A.COD_EMP = D.COD_EMP
           AND A.COD_CLIENTE = D.COD_CLIENTE
           AND C.COD_PERFIL_CLI >= :COD_PERFIL_INI
           AND C.COD_PERFIL_CLI <= :COD_PERFIL_FIM
           AND B.VLR_LIMITE > :LIMITE
          INTO COD_CLIENTE,
               DES_CLIENTE,
               NUM_CPF_CNPJ,
               DES_FONE_RESID,
               DES_FONE_CELULAR,
               DES_FONE_COMERC,
               COD_PERFIL_CLI,
               VLR_LIMITE
    DO BEGIN
       IF (OP_REL = 0) THEN
       	   SUSPEND;
       ELSE
       IF (OP_REL = 1) THEN
        BEGIN
     	   ICOMPROU =0;
           SELECT coalesce(count(1),0)
             FROM EST_CUPONS E
            WHERE E.COD_EMP = :COD_EMP
              AND E.COD_UNIDADE = :COD_UNIDADE
              AND E.DTA_MOVIMENTO BETWEEN :DTA_INI AND :DTA_FIM
              AND E.COD_CLIENTE = :COD_CLIENTE
             INTO ICOMPROU;
           IF (ICOMPROU < 1) THEN
              SUSPEND;
       END ELSE IF (OP_REL = 2) THEN
       	        BEGIN
       	            ICOMPROU =0;
                    SELECT coalesce(count(1),0)
                      FROM EST_CUPONS E
                     WHERE E.COD_EMP = :COD_EMP
                       AND E.COD_UNIDADE = :COD_UNIDADE
                       AND E.DTA_MOVIMENTO BETWEEN :DTA_INI AND :DTA_FIM
                       AND E.COD_CLIENTE = :COD_CLIENTE
                      INTO ICOMPROU;
                    IF (ICOMPROU > 0) THEN
                        SUSPEND;
       	        END
     END
END
 ^

SET TERM ; ^
COMMIT WORK;
SET AUTODDL ON;