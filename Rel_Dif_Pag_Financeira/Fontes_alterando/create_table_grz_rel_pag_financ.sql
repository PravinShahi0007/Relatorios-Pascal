create table GRZ_REL_PAG_FINANC
(
  DES_USUARIO         VARCHAR2(50) NOT NULL
 ,DES_REDE            VARCHAR2(20)
 ,COD_UNIDADE         NUMBER(7)
 ,DES_UNIDADE         VARCHAR2(50)
 ,DTA_CONTABIL        DATE
 ,VLR_CR              NUMBER(18,2)
 ,VLR_CDC_APRO        NUMBER(18,2)
);


alter table grz_rel_pag_financ add
(
  VLR_CR_TOTAL        NUMBER(18,2)
 ,VLR_CDC_APRO_TOTAL  NUMBER(18,2)
);