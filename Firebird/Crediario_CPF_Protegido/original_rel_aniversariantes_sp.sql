COMMIT WORK;
SET AUTODDL OFF;
SET TERM ^ ;

/* Stored procedures */

CREATE PROCEDURE "REL_ANIVERSARIANTES_SP" 
(
  "COD_EMP" NUMERIC(3, 0),
  "COD_UNIDADE" NUMERIC(4, 0),
  "MES" NUMERIC(2, 0),
  "DIA_INI" NUMERIC(2, 0),
  "DIA_FIM" NUMERIC(2, 0),
  "SITU" NUMERIC(1, 0),
  "DTA_COMPRA_INI" DATE,
  "DTA_COMPRA_FIM" DATE,
  "PERFIL_INI" NUMERIC(2, 0),
  "PERFIL_FIM" NUMERIC(2, 0),
  "TIP_CLI" NUMERIC(1, 0)
)
RETURNS
(
  "COD_CLIENTE" NUMERIC(14, 0),
  "DES_CLIENTE" VARCHAR(60),
  "DES_ENDERECO" VARCHAR(60),
  "DES_BAIRRO" VARCHAR(60),
  "DES_CIDADE" VARCHAR(60),
  "DES_TELEFONE" VARCHAR(20),
  "DES_FONE_CELULAR" VARCHAR(20),
  "DES_FONE_CELULAR2" VARCHAR(20),
  "DES_FONE_COMERC" VARCHAR(20),
  "DES_OBS" VARCHAR(100),
  "DES_SEXO" VARCHAR(15),
  "DES_PROFISSAO" VARCHAR(40),
  "DTA_COMPRA" DATE,
  "COD_PERFIL" NUMERIC(3, 0),
  "DTA_NASCTO" DATE,
  "DIA_NASCTO" NUMERIC(4, 0),
  "IDADE" NUMERIC(5, 0),
  "TIP_DES_CLIENTE" VARCHAR(3)
)
AS
BEGIN EXIT; END ^


ALTER PROCEDURE "REL_ANIVERSARIANTES_SP" 
(
  "COD_EMP" NUMERIC(3, 0),
  "COD_UNIDADE" NUMERIC(4, 0),
  "MES" NUMERIC(2, 0),
  "DIA_INI" NUMERIC(2, 0),
  "DIA_FIM" NUMERIC(2, 0),
  "SITU" NUMERIC(1, 0),
  "DTA_COMPRA_INI" DATE,
  "DTA_COMPRA_FIM" DATE,
  "PERFIL_INI" NUMERIC(2, 0),
  "PERFIL_FIM" NUMERIC(2, 0),
  "TIP_CLI" NUMERIC(1, 0)
)
RETURNS
(
  "COD_CLIENTE" NUMERIC(14, 0),
  "DES_CLIENTE" VARCHAR(60),
  "DES_ENDERECO" VARCHAR(60),
  "DES_BAIRRO" VARCHAR(60),
  "DES_CIDADE" VARCHAR(60),
  "DES_TELEFONE" VARCHAR(20),
  "DES_FONE_CELULAR" VARCHAR(20),
  "DES_FONE_CELULAR2" VARCHAR(20),
  "DES_FONE_COMERC" VARCHAR(20),
  "DES_OBS" VARCHAR(100),
  "DES_SEXO" VARCHAR(15),
  "DES_PROFISSAO" VARCHAR(40),
  "DTA_COMPRA" DATE,
  "COD_PERFIL" NUMERIC(3, 0),
  "DTA_NASCTO" DATE,
  "DIA_NASCTO" NUMERIC(4, 0),
  "IDADE" NUMERIC(5, 0),
  "TIP_DES_CLIENTE" VARCHAR(3)
)
AS
DECLARE VARIABLE COD_CIDADE NUMERIC(10,0);
  DECLARE VARIABLE SEXO NUMERIC(1);
  DECLARE VARIABLE COD_PROFISSAO NUMERIC(4,0);
  DECLARE VARIABLE RETORNO NUMERIC(1);
  DECLARE VARIABLE TIP_CLIENTE NUMERIC(1);
  DECLARE VARIABLE MES_NASCTO NUMERIC(2,0);
  DECLARE VARIABLE ANO_NASCTO NUMERIC(4,0);
  DECLARE VARIABLE DIA_ATUAL NUMERIC(2,0);
  DECLARE VARIABLE MES_ATUAL NUMERIC(2,0);
  DECLARE VARIABLE ANO_ATUAL NUMERIC(4,0);
BEGIN
   FOR SELECT COD_CLIENTE
             ,DES_CLIENTE
             ,TIP_SEXO
             ,DES_ENDERECO
             ,DES_BAIRRO
             ,COD_CIDADE
             ,DTA_NASCTO
             ,COD_PROFISSAO
             ,DES_TELEFONE
             ,DES_FONE_CELULAR
             ,TIP_CLIENTE
         FROM CRE_CLIENTES
        WHERE COD_EMP = :COD_EMP
          AND COD_UNIDADE = :COD_UNIDADE
          AND (EXTRACT(MONTH FROM DTA_NASCTO) = :MES)
          AND (EXTRACT(DAY FROM DTA_NASCTO) BETWEEN :DIA_INI AND :DIA_FIM)
          AND NOT (LPAD(COALESCE(DES_TELEFONE,'0'),15,'0') <= '000000000000000'
               AND LPAD(COALESCE(DES_FONE_CELULAR,'0'),15,'0') <= '000000000000000')
        ORDER BY EXTRACT(DAY FROM DTA_NASCTO)
                ,DES_CLIENTE
   INTO
       COD_CLIENTE,DES_CLIENTE,SEXO,DES_ENDERECO,DES_BAIRRO,COD_CIDADE
      ,DTA_NASCTO,COD_PROFISSAO,DES_TELEFONE,DES_FONE_CELULAR,TIP_CLIENTE
   DO BEGIN
      SELECT DES_CIDADE FROM GER_CIDADES WHERE COD_CIDADE = :COD_CIDADE INTO DES_CIDADE;
      SELECT DES_PROFISSAO FROM GER_PROFISSOES WHERE COD_PROFISSAO = :COD_PROFISSAO INTO DES_PROFISSAO;
      DES_FONE_CELULAR2 = '';
      DES_FONE_COMERC = '';
      COD_PERFIL = 0;
      DTA_COMPRA = null;
      DES_OBS = null;
      IF(TIP_CLIENTE = 1) THEN
      BEGIN
      	 TIP_DES_CLIENTE = 'VV';
      END
      ELSE IF(TIP_CLIENTE = 2)THEN
      BEGIN
      	 TIP_DES_CLIENTE = 'VP';
         SELECT DES_FONE_CELULAR2
               ,DES_FONE_COMERC
           FROM CRE_CLIENTES_CR
          WHERE COD_EMP = :COD_EMP
            AND COD_CLIENTE = :COD_CLIENTE
           INTO DES_FONE_CELULAR2
               ,DES_FONE_COMERC;
         SELECT DES_COMENTARIO
           FROM CRE_COMENTARIOS_CLI
          WHERE COD_EMP = :COD_EMP
            AND COD_CLIENTE = :COD_CLIENTE
            AND NUM_SEQ = 10
           INTO DES_OBS;
         SELECT COD_PERFIL_CLI
               ,CASE WHEN COALESCE(DTA_ULT_COMPRA_VV,'0') > COALESCE(DTA_ULT_COMPRA_VP,'0') THEN
             	        DTA_ULT_COMPRA_VV
                   ELSE DTA_ULT_COMPRA_VP END AS DTA_COMPRA
           FROM CRE_SALDOS_CLI
          WHERE COD_EMP = :COD_EMP
            AND COD_CLIENTE = :COD_CLIENTE
            AND (DTA_ULT_COMPRA_VV BETWEEN :DTA_COMPRA_INI AND :DTA_COMPRA_FIM
              OR DTA_ULT_COMPRA_VP BETWEEN :DTA_COMPRA_INI AND :DTA_COMPRA_FIM)
           INTO COD_PERFIL
               ,DTA_COMPRA;
         IF(COD_PERFIL is null)THEN COD_PERFIL = 0;
      END
      DIA_ATUAL = EXTRACT(DAY FROM CURRENT_DATE);
      MES_ATUAL = EXTRACT(MONTH FROM CURRENT_DATE);
      ANO_ATUAL = EXTRACT(YEAR FROM CURRENT_DATE);
      DIA_NASCTO = EXTRACT(DAY FROM DTA_NASCTO);
      MES_NASCTO = EXTRACT(MONTH FROM DTA_NASCTO);
      ANO_NASCTO = EXTRACT(YEAR FROM DTA_NASCTO);
      IDADE = ANO_ATUAL - ANO_NASCTO;
      IF ((MES_ATUAL < MES_NASCTO) OR ((MES_ATUAL = MES_NASCTO)AND(DIA_ATUAL < DIA_NASCTO))) THEN
      BEGIN
      	 IDADE = IDADE - 1;
      END
      IF (((DTA_COMPRA is null)AND(TIP_CLIENTE = 1)) OR (DTA_COMPRA is not null)) THEN
      BEGIN
	 IF(SEXO=1)THEN
	    DES_SEXO='M';
         ELSE IF(SEXO=2)THEN
      	    DES_SEXO='F';
      	 IF ((COD_PERFIL >= PERFIL_INI)AND(COD_PERFIL <= PERFIL_FIM))THEN
      	 BEGIN  
            RETORNO=0;
            EXECUTE PROCEDURE VERIFICA_L_CLIENTE_SP :COD_EMP,:COD_UNIDADE,COD_CLIENTE RETURNING_VALUES :RETORNO;
            IF(RETORNO > 0)THEN
            BEGIN
               IF (TIP_CLI = 0) THEN
               BEGIN
                  IF(SITU = 0)THEN
                  BEGIN
                     SUSPEND;
                  END
                  IF(SITU = 1)THEN
                  BEGIN
                     IF(SEXO=1)THEN
                     BEGIN
                        SUSPEND;
                     END
                  END
                  IF(SITU = 2)THEN
                  BEGIN
                     IF(SEXO=2)THEN
                     BEGIN
                        SUSPEND;
                     END
                  END
               END 
               IF (TIP_CLI = 1) THEN
               BEGIN
                  IF (TIP_CLIENTE = 1) THEN
                  BEGIN
                     IF(SITU = 0)THEN
                     BEGIN
                        SUSPEND;
                     END
                     IF(SITU = 1)THEN
                     BEGIN
                        IF(SEXO=1)THEN
                        BEGIN
                           SUSPEND;
                        END
                     END
                     IF(SITU = 2)THEN
                     BEGIN
                        IF(SEXO=2)THEN
                        BEGIN
                           SUSPEND;
                        END
                     END
                  END
               END
               IF (TIP_CLI = 2) THEN
               BEGIN
                  IF (TIP_CLIENTE = 2) THEN
                  BEGIN
                     IF(SITU = 0)THEN
                     BEGIN
                        SUSPEND;
                     END
                     IF(SITU = 1)THEN
                     BEGIN
                        IF(SEXO=1)THEN
                        BEGIN
                           SUSPEND;
                        END
                     END
                     IF(SITU = 2)THEN
                     BEGIN
                        IF(SEXO=2)THEN
                        BEGIN
                           SUSPEND;
                        END
                     END
                  END
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