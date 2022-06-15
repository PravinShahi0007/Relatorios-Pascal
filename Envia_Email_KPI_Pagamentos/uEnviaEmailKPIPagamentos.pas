{-------------------------------------------------------------------------------
 Programa..: uEnviaEmailKPIPagamentos
 Empresa...: Grazziotin S/A
 Finalidade: Enviar e-mails autom�tico do relat�rio de KPI Pagamentos

 Autor   Data     Opera��o  Descri��o
 Ant�nio MAR/2021 Cria��o
-------------------------------------------------------------------------------}
unit uEnviaEmailKPIPagamentos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
  Vcl.Samples.Gauges, Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.Oracle,
  FireDAC.Phys.OracleDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Vcl.Menus, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, ACBrBase, ACBrMail, Vcl.Buttons, IniFiles,
  FireDAC.Comp.UI, Vcl.Themes, Vcl.Styles,DateUtils ;

type
    RGRZW_REL_PGTOS_APPXLOJA = record
              // Campos vindos do SQL....
              DTA_MES                  : TDate;
              ANOMES                   : String;
              ANO                      : String;
              TOT_CLI_CADASTRADOS      : Double; //NUMBER(8)     -- TOTAL DE CLIENTES CADASTRADOS (Acumulado)
              QTD_TOT_CLI_APP          : Double; //NUMBER(8),    -- CADASTRADOS NA BASE
              QTD_NEW_CLI_APP          : Double; //NUMBER(8),    -- QUANTIDADE DE NOVOS CADASTROS
              QTD_CLI_GRAZZIOTIN       : Double; //NUMBER(8),    -- J� S�O CLIENTES
              PERC_CRESCIMENTO         : Double; //NUMBER(5,2),  -- PERCENTUAL DE CRESCIMENTO
              QTD_NEW_CLI_APP_APROV    : Double; //NUMBER(8),    -- NOVOS CLIENTES APROVADOS
              QTD_CLI_NOVOS_PENDENTES  : Double; //NUMBER(8),    -- CLIENTES NOVOS PENDENTES
              QTD_PARCELAS_ARECEBER    : Double; //NUMBER(8),    -- QUANTIDADE PARCELAS A RECEBER
              VLR_PARCELAS_ARECEBER    : Double; //NUMBER(18,2), -- VALOR PARCELAS A RECEBER
              TOT_CLI_PGTO_CIA         : Double; //NUMBER(18,2), -- TOTAL DE VALORES PAGOS NA CIA
              TOT_CLI_PGTO_APP         : Double; //NUMBER(8),    -- EFETUARAM PAGAMENTO PELO APP
              QTD_PARCELAS_PGTO_CIA    : Double; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS NA CIA
              QTD_PARCELAS_PGTO_APP    : Double; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS PELO APP
              VLR_PARCELAS_PGTO_CIA    : Double; //NUMBER(18,2), -- VALOR DE PARCELAS PAGAS NA CIA
              VLR_PARCELAS_PGTO_APP    : Double; //NUMBER(18,2), -- VALOR DE PARCELAS PAGAS PELO APP
              QTD_PARCELAS_PGTO_DECRE  : Double; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS - DECRE
              VLR_PARCELAS_PGTO_DECRE  : Double; //NUMBER(18,2), -- VALOR DAS PARCELAS PAGAS - DECRE
              QTD_PARCELAS_PGTO_0800   : Double; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS - 0800
              VLR_PARCELAS_PGTO_0800   : Double; //NUMBER(18,2), -- VALOR DAS PARCELAS PAGAS - 0800
              QTD_PGTO_BOLETO_APP      : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO BOLETO APP
              VLR_PGTO_BOLETO_APP      : Double; //NUMBER(18,2), -- VALOR DE PAGAMENTO BOLETO APP
              QTD_PGTO_DEBITO_APP      : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO DEBITO BOLETO APP
              VLR_PGTO_DEBITO_APP      : Double; //NUMBER(18,2), -- VALOR DE PAGAMENTO DEBITO BOLETO APP
              QTD_PGTO_CREDITO_APP     : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO CREDITO BOLETO APP
              VLR_PGTO_CREDITO_APP     : Double; //NUMBER(18,2), -- VALOR DE PAGAMENTO CREDITO BOLETO APP
              QTD_PGTO_PIX_APP         : Double; //NUMBER(8),
              VLR_PGTO_PIX_APP         : Double; //NUMBER(18,2),
              QTD_PGTO_BOLETO_DECRE    : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO BOLETO DECRE
              VLR_PGTO_BOLETO_DECRE    : Double; //NUMBER(18,2), -- VALOR DE PAGAMENTO CREDITO BOLETO DECRE
              QTD_PGTO_CARTAO_DECRE    : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO COM CARTAO DECRE - Campo n�o existe na tabela, ser� criado futuramente
              VLR_PGTO_CARTAO_DECRE    : Double; //NUMBER(18,2), -- VALOR DE PAGAMENTO COM CARTAO DECRE - Campo n�o existe na tabela, ser� criado futuramente
              QTD_PGTO_PIX_DECRE       : Double; //NUMBER(8),
              VLR_PGTO_PIX_DECRE       : Double; //NUMBER(18,2),
              QTD_PGTO_LOJA            : Double; //NUMBER(8),
              VLR_PGTO_LOJA            : Double; //NUMBER(18,2),
              QTD_PGTO_DEBITO_LOJA     : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO DEBITO LOJA
              VLR_PGTO_DEBITO_LOJA     : Double; //NUMBER(18,2), -- VALOR PAGAMENTO DEBITO LOJA
              QTD_PGTO_CREDITO_LOJA    : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO CREDITO LOJA
              VLR_PGTO_CREDITO_LOJA    : Double; //NUMBER(18,2), -- VALOR PAGAMENTO CREDITO LOJA
              QTD_PGTO_PIX_LOJA        : Double; //NUMBER(8),
              VLR_PGTO_PIX_LOJA        : Double; //NUMBER(18,2),
              QTD_PGTO_A_ATENDIMENTO   : Double; //NUMBER(8),
              VLR_PGTO_A_ATENDIMENTO   : Double; //NUMBER(18,2),
              // Campo de percentuais e totais....
              // �rea N� Pagamentos - APP...
              TOTAL_N_PAGAMENTOS       : Double;
              PERC_TOTAL_N_PAGAMENTOS  : Double;
              TOT_N_PGTO_APP           : Double;
              PERC_TOT_N_PGTO_APP      : Double;
              // �rea N� Pagamentos - Decre...
              TOT_N_PGTO_DECRE         : Double;
              // �rea N� Pagamentos - Loja...
              TOT_N_PGTO_LOJA          : Double;
              // �rea Pagamentos R$...
              TICKET_MEDIO_VLR_PARCELAS: Double;
              TOTAL_RS_PAGAMENTOS      : Double;
              TICKET_MEDIO_PAGAMENTOS  : Double;
              PERC_TOTAL_RS_PAGAMENTOS : Double;
              // �rea Pagamentos R$ - APP...
              TOT_RS_PGTO_APP          : Double;
              TICKET_MEDIO_PAG_APP     : Double;
              PERC_TOT_RS_PGTO_APP     : Double;
              PERC_RS_PGTO_APP_DEBITO  : Double;
              PERC_RS_PGTO_APP_CREDITO : Double;
              PERC_RS_PGTO_APP_PIX     : Double;
              PERC_RS_PGTO_APP_BOLETO  : Double;
              // �rea Pagamentos R$ - Decre...
              TOT_RS_PGTO_DECRE        : Double;
              TICKET_MEDIO_PAG_DECRE   : Double;
              PERC_TOT_RS_PGTO_DECRE   : Double;
              PERC_RS_PGTO_DECRE_BOLETO: Double;
              PERC_RS_PGTO_DECRE_PIX   : Double;
              PERC_RS_PGTO_DECRE_CARTAO: Double;
              // �rea Pagamentos R$ - Loja...
              TOT_RS_PGTO_LOJA         : Double;
              TICKET_MEDIO_PAG_LOJA    : Double;
              PERC_TOT_RS_PGTO_LOJA    : Double;
              PERC_RS_PGTO_LOJA_EFETIVO: Double;
              PERC_RS_PGTO_LOJA_DEBITO : Double;
              PERC_RS_PGTO_LOJA_PIX    : Double;
              PERC_QTD_A_ATENDIMENTO   : Double;
              PERC_VLR_A_ATENDIMENTO   : Double;
              // Campos formatados para montagem e visualiza��o no HTML...
              HTML_DTA_MES                  : String;
              HTML_ANOMES                   : String;
              HTML_ANO                      : String;
              HTML_TOT_CLI_CADASTRADOS      : String; //NUMBER(8)  -- TOTAL DE CLIENTES CADASTRADOS (Acumulado)
              HTML_QTD_TOT_CLI_APP          : String; //NUMBER(8), -- CADASTRADOS NA BASE
              HTML_QTD_NEW_CLI_APP          : String; //NUMBER(8), -- QUANTIDADE DE NOVOS CADASTROS
              HTML_QTD_CLI_GRAZZIOTIN       : String; //NUMBER(8), -- J� S�O CLIENTES
              HTML_PERC_CRESCIMENTO         : String; //NUMBER(5,2), -- PERCENTUAL DE CRESCIMENTO
              HTML_QTD_NEW_CLI_APP_APROV    : String; //NUMBER(8), -- NOVOS CLIENTES APROVADOS
              HTML_QTD_CLI_NOVOS_PENDENTES  : String; //NUMBER(8), -- CLIENTES NOVOS PENDENTES
              HTML_QTD_PARCELAS_ARECEBER    : String; //NUMBER(8),    -- QUANTIDADE PARCELAS A RECEBER
              HTML_VLR_PARCELAS_ARECEBER    : String; //NUMBER(18,2), -- VALOR PARCELAS A RECEBER
              HTML_TOT_CLI_PGTO_CIA         : String; //NUMBER(18,2), -- TOTAL DE VALORES PAGOS NA CIA
              HTML_TOT_CLI_PGTO_APP         : String; //NUMBER(8),    -- EFETUARAM PAGAMENTO PELO APP
              HTML_QTD_PARCELAS_PGTO_CIA    : String; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS NA CIA
              HTML_QTD_PARCELAS_PGTO_APP    : String; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS PELO APP
              HTML_VLR_PARCELAS_PGTO_CIA    : String; //NUMBER(18,2), -- VALOR DE PARCELAS PAGAS NA CIA
              HTML_VLR_PARCELAS_PGTO_APP    : String; //NUMBER(18,2), -- VALOR DE PARCELAS PAGAS PELO APP
              HTML_QTD_PARCELAS_PGTO_DECRE  : String; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS - DECRE
              HTML_VLR_PARCELAS_PGTO_DECRE  : String; //NUMBER(18,2), -- VALOR DAS PARCELAS PAGAS - DECRE
              HTML_QTD_PARCELAS_PGTO_0800   : String; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS - 0800
              HTML_VLR_PARCELAS_PGTO_0800   : String; //NUMBER(18,2), -- VALOR DAS PARCELAS PAGAS - 0800
              HTML_QTD_PGTO_BOLETO_APP      : String; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO BOLETO APP
              HTML_VLR_PGTO_BOLETO_APP      : String; //NUMBER(18,2), -- VALOR DE PAGAMENTO BOLETO APP
              HTML_QTD_PGTO_DEBITO_APP      : String; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO DEBITO BOLETO APP
              HTML_VLR_PGTO_DEBITO_APP      : String; //NUMBER(18,2), -- VALOR DE PAGAMENTO DEBITO BOLETO APP
              HTML_QTD_PGTO_CREDITO_APP     : String; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO CREDITO BOLETO APP
              HTML_VLR_PGTO_CREDITO_APP     : String; //NUMBER(18,2), -- VALOR DE PAGAMENTO CREDITO BOLETO APP
              HTML_QTD_PGTO_PIX_APP         : String; //NUMBER(8),
              HTML_VLR_PGTO_PIX_APP         : String; //NUMBER(18,2),
              HTML_QTD_PGTO_BOLETO_DECRE    : String; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO BOLETO DECRE
              HTML_VLR_PGTO_BOLETO_DECRE    : String; //NUMBER(18,2), -- VALOR DE PAGAMENTO CREDITO BOLETO APP
              HTML_QTD_PGTO_CARTAO_DECRE    : String; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO COM CARTAO DECRE - Campo n�o existe na tabela, ser� criado futuramente
              HTML_VLR_PGTO_CARTAO_DECRE    : String; //NUMBER(18,2), -- VALOR DE PAGAMENTO COM CARTAO DECRE - Campo n�o existe na tabela, ser� criado futuramente
              HTML_QTD_PGTO_PIX_DECRE       : String; //NUMBER(8),
              HTML_VLR_PGTO_PIX_DECRE       : String; //NUMBER(18,2),
              HTML_QTD_PGTO_LOJA            : String; //NUMBER(8),
              HTML_VLR_PGTO_LOJA            : String; //NUMBER(18,2),
              HTML_QTD_PGTO_DEBITO_LOJA     : String; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO DEBITO LOJA
              HTML_VLR_PGTO_DEBITO_LOJA     : String; //NUMBER(18,2), -- VALOR PAGAMENTO DEBITO LOJA
              HTML_QTD_PGTO_CREDITO_LOJA    : String; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO CREDITO LOJA
              HTML_VLR_PGTO_CREDITO_LOJA    : String; //NUMBER(18,2), -- VALOR PAGAMENTO CREDITO LOJA
              HTML_QTD_PGTO_PIX_LOJA        : String; //NUMBER(8),
              HTML_VLR_PGTO_PIX_LOJA        : String; //NUMBER(18,2),
              HTML_QTD_PGTO_A_ATENDIMENTO   : String;
              HTML_VLR_PGTO_A_ATENDIMENTO   : String;
              // Campo de percentuais e totais....
              // �rea N� Pagamentos - APP...
              HTML_TOTAL_N_PAGAMENTOS       : String;
              HTML_PERC_TOTAL_N_PAGAMENTOS  : String;
              HTML_TOT_N_PGTO_APP           : String;
              HTML_PERC_TOT_N_PGTO_APP      : String;
              // �rea Pagamentos R$....
              HTML_TICKET_MEDIO_VLR_PARCELAS: String;
              HTML_TOTAL_RS_PAGAMENTOS      : String;
              HTML_TICKET_MEDIO_PAGAMENTOS  : String;
              HTML_PERC_TOTAL_RS_PAGAMENTOS : String;
              // �rea Pagamentos R$ - APP...
              HTML_TOT_RS_PGTO_APP          : String;
              HTML_TICKET_MEDIO_PAG_APP     : String;
              HTML_PERC_TOT_RS_PGTO_APP     : String;
              HTML_PERC_RS_PGTO_APP_DEBITO  : String;
              HTML_PERC_RS_PGTO_APP_CREDITO : String;
              HTML_PERC_RS_PGTO_APP_PIX     : String;
              HTML_PERC_RS_PGTO_APP_BOLETO  : String;
              // �rea Pagamentos R$ - Decre...
              HTML_TOT_RS_PGTO_DECRE        : String;
              HTML_TICKET_MEDIO_PAG_DECRE   : String;
              HTML_PERC_TOT_RS_PGTO_DECRE   : String;
              HTML_PERC_RS_PGTO_DECRE_BOLETO: String;
              HTML_PERC_RS_PGTO_DECRE_PIX   : String;
              HTML_PERC_RS_PGTO_DECRE_CARTAO: String;
              // �rea Pagamentos R$ - Loja...
              HTML_TOT_RS_PGTO_LOJA         : String;
              HTML_TICKET_MEDIO_PAG_LOJA    : String;
              HTML_PERC_TOT_RS_PGTO_LOJA    : String;
              HTML_PERC_RS_PGTO_LOJA_EFETIVO: String;
              HTML_PERC_RS_PGTO_LOJA_DEBITO : String;
              HTML_PERC_RS_PGTO_LOJA_PIX    : String;
              HTML_PERC_VLR_A_ATENDIMENTO   : String;
              HTML_PERC_PGTO_A_ATENDIMENTO  : String;
              // Totais dos valores...
              TOTAL_TOT_CLI_CADASTRADOS      : Double; //NUMBER(8)     -- TOTAL DE CLIENTES CADASTRADOS (Acumulado)
              TOTAL_QTD_TOT_CLI_APP          : Double; //NUMBER(8),    -- CADASTRADOS NA BASE
              TOTAL_QTD_NEW_CLI_APP          : Double; //NUMBER(8),    -- QUANTIDADE DE NOVOS CADASTROS
              TOTAL_QTD_CLI_GRAZZIOTIN       : Double; //NUMBER(8),    -- J� S�O CLIENTES
              TOTAL_QTD_NEW_CLI_APP_APROV    : Double; //NUMBER(8),    -- NOVOS CLIENTES APROVADOS
              TOTAL_QTD_CLI_NOVOS_PENDENTES  : Double; //NUMBER(8),    -- NOVOS CLIENTES APROVADOS
              TOTAL_QTD_PARCELAS_ARECEBER    : Double; //NUMBER(8),    -- QUANTIDADE PARCELAS A RECEBER
              TOTAL_VLR_PARCELAS_ARECEBER    : Double; //NUMBER(18,2), -- VALOR PARCELAS A RECEBER
              TOTAL_TOT_CLI_PGTO_CIA         : Double; //NUMBER(18,2), -- TOTAL DE VALORES PAGOS NA CIA
              TOTAL_TOT_CLI_PGTO_APP         : Double; //NUMBER(8),    -- EFETUARAM PAGAMENTO PELO APP
              TOTAL_QTD_PARCELAS_PGTO_CIA    : Double; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS NA CIA
              TOTAL_QTD_PARCELAS_PGTO_APP    : Double; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS PELO APP
              TOTAL_VLR_PARCELAS_PGTO_CIA    : Double; //NUMBER(18,2), -- VALOR DE PARCELAS PAGAS NA CIA
              TOTAL_VLR_PARCELAS_PGTO_APP    : Double; //NUMBER(18,2), -- VALOR DE PARCELAS PAGAS PELO APP
              TOTAL_QTD_PARCELAS_PGTO_DECRE  : Double; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS - DECRE
              TOTAL_VLR_PARCELAS_PGTO_DECRE  : Double; //NUMBER(18,2), -- VALOR DAS PARCELAS PAGAS - DECRE
              TOTAL_QTD_PARCELAS_PGTO_0800   : Double; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS - 0800
              TOTAL_VLR_PARCELAS_PGTO_0800   : Double; //NUMBER(18,2), -- VALOR DAS PARCELAS PAGAS - 0800
              TOTAL_QTD_PGTO_BOLETO_APP      : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO BOLETO APP
              TOTAL_VLR_PGTO_BOLETO_APP      : Double; //NUMBER(18,2), -- VALOR DE PAGAMENTO BOLETO APP
              TOTAL_QTD_PGTO_DEBITO_APP      : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO DEBITO BOLETO APP
              TOTAL_VLR_PGTO_DEBITO_APP      : Double; //NUMBER(18,2), -- VALOR DE PAGAMENTO DEBITO BOLETO APP
              TOTAL_QTD_PGTO_CREDITO_APP     : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO CREDITO BOLETO APP
              TOTAL_VLR_PGTO_CREDITO_APP     : Double; //NUMBER(18,2), -- VALOR DE PAGAMENTO CREDITO BOLETO APP
              TOTAL_QTD_PGTO_PIX_APP         : Double; //NUMBER(8),
              TOTAL_VLR_PGTO_PIX_APP         : Double; //NUMBER(18,2),
              TOTAL_QTD_PGTO_BOLETO_DECRE    : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO BOLETO DECRE
              TOTAL_VLR_PGTO_BOLETO_DECRE    : Double; //NUMBER(18,2), -- VALOR DE PAGAMENTO CREDITO BOLETO APP
              TOTAL_QTD_PGTO_CARTAO_DECRE    : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO COM CARTAO DECRE - Campo n�o existe na tabela, ser� criado futuramente
              TOTAL_VLR_PGTO_CARTAO_DECRE    : Double; //NUMBER(18,2), -- VALOR DE PAGAMENTO COM CARTAO DECRE - Campo n�o existe na tabela, ser� criado futuramente
              TOTAL_QTD_PGTO_PIX_DECRE       : Double; //NUMBER(8),
              TOTAL_VLR_PGTO_PIX_DECRE       : Double; //NUMBER(18,2),
              TOTAL_QTD_PGTO_LOJA            : Double; //NUMBER(8),
              TOTAL_VLR_PGTO_LOJA            : Double; //NUMBER(18,2),
              TOTAL_QTD_PGTO_DEBITO_LOJA     : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO DEBITO LOJA
              TOTAL_VLR_PGTO_DEBITO_LOJA     : Double; //NUMBER(18,2), -- VALOR PAGAMENTO DEBITO LOJA
              TOTAL_QTD_PGTO_CREDITO_LOJA    : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO CREDITO LOJA
              TOTAL_VLR_PGTO_CREDITO_LOJA    : Double; //NUMBER(18,2), -- VALOR PAGAMENTO CREDITO LOJA
              TOTAL_QTD_PGTO_PIX_LOJA        : Double; //NUMBER(8),
              TOTAL_VLR_PGTO_PIX_LOJA        : Double; //NUMBER(18,2),
              TOTAL_QTD_PGTO_A_ATENDIMENTO   : Double;
              TOTAL_VLR_PGTO_A_ATENDIMENTO   : Double;
              // Campo de percentuais e totais....
              // �rea N� Pagamentos - APP...
              TOTAL_TOTAL_N_PAGAMENTOS       : Double;
              TOTAL_PERC_TOTAL_N_PAGAMENTOS  : Double;
              TOTAL_TOT_N_PGTO_APP           : Double;
              TOTAL_PERC_TOT_N_PGTO_APP      : Double;
              // �rea N� Pagamentos - Decre...
              TOTAL_TOT_N_PGTO_DECRE         : Double;
              // �rea N� Pagamentos - Loja...
              TOTAL_TOT_N_PGTO_LOJA          : Double;
              // �rea Pagamentos R$...
              TOTAL_TICKET_MEDIO_VLR_PARCELAS: Double;
              TOTAL_TOTAL_RS_PAGAMENTOS      : Double;
              TOTAL_TICKET_MEDIO_PAGAMENTOS  : Double;
              TOTAL_PERC_TOTAL_RS_PAGAMENTOS : Double;
              // �rea Pagamentos R$ - APP...
              TOTAL_TOT_RS_PGTO_APP          : Double;
              TOTAL_TICKET_MEDIO_PAG_APP     : Double;
              TOTAL_PERC_TOT_RS_PGTO_APP     : Double;
              TOTAL_PERC_RS_PGTO_APP_DEBITO  : Double;
              TOTAL_PERC_RS_PGTO_APP_CREDITO : Double;
              TOTAL_PERC_RS_PGTO_APP_PIX     : Double;
              TOTAL_PERC_RS_PGTO_APP_BOLETO  : Double;
              // �rea Pagamentos R$ - Decre...
              TOTAL_TOT_RS_PGTO_DECRE        : Double;
              TOTAL_TICKET_MEDIO_PAG_DECRE   : Double;
              TOTAL_PERC_TOT_RS_PGTO_DECRE   : Double;
              TOTAL_PERC_RS_PGTO_DECRE_BOLETO: Double;
              TOTAL_PERC_RS_PGTO_DECRE_PIX   : Double;
              TOTAL_PERC_RS_PGTO_DECRE_CARTAO: Double;
              // �rea Pagamentos R$ - Loja...
              TOTAL_TOT_RS_PGTO_LOJA         : Double;
              TOTAL_TICKET_MEDIO_PAG_LOJA    : Double;
              TOTAL_PERC_TOT_RS_PGTO_LOJA    : Double;
              TOTAL_PERC_RS_PGTO_LOJA_EFETIVO: Double;
              TOTAL_PERC_RS_PGTO_LOJA_DEBITO : Double;
              TOTAL_PERC_RS_PGTO_LOJA_PIX    : Double;
              TOTAL_PERC_QTD_A_ATENDIMENTO   : Double;
              TOTAL_PERC_VLR_A_ATENDIMENTO   : Double;
              // Campos formatados de TOTAIS para montagem e visualiza��o no HTML...
              HTML_TOTAL_DTA_MES                 : String;
              HTML_TOTAL_ANOMES                  : String;
              HTML_TOTAL_ANO                     : String;
              HTML_TOTAL_TOT_CLI_CADASTRADOS     : String; //NUMBER(8)     -- TOTAL DE CLIENTES CADASTRADOS (Acumulado)
              HTML_TOTAL_QTD_TOT_CLI_APP         : String; //NUMBER(8),     -- CADASTRADOS NA BASE
              HTML_TOTAL_QTD_NEW_CLI_APP         : String; //NUMBER(8),    -- QUANTIDADE DE NOVOS CADASTROS
              HTML_TOTAL_QTD_CLI_GRAZZIOTIN      : String; //NUMBER(8),    -- J� S�O CLIENTES
              HTML_TOTAL_QTD_NEW_CLI_APP_APROV   : String; //NUMBER(8),    -- NOVOS CLIENTES APROVADOS
              HTML_TOTAL_QTD_CLI_NOVOS_PENDENTES : String; //NUMBER(8),    -- NOVOS CLIENTES APROVADOS
              HTML_TOTAL_QTD_PARCELAS_ARECEBER   : String; //NUMBER(8),    -- QUANTIDADE PARCELAS A RECEBER
              HTML_TOTAL_VLR_PARCELAS_ARECEBER   : String; //NUMBER(18,2), -- VALOR PARCELAS A RECEBER
              HTML_TOTAL_TOT_CLI_PGTO_CIA        : String; //NUMBER(18,2), -- TOTAL DE VALORES PAGOS NA CIA
              HTML_TOTAL_TOT_CLI_PGTO_APP        : String; //NUMBER(8),    -- EFETUARAM PAGAMENTO PELO APP
              HTML_TOTAL_QTD_PARCELAS_PGTO_CIA   : String; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS NA CIA
              HTML_TOTAL_QTD_PARCELAS_PGTO_APP   : String; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS PELO APP
              HTML_TOTAL_VLR_PARCELAS_PGTO_CIA   : String; //NUMBER(18,2), -- VALOR DE PARCELAS PAGAS NA CIA
              HTML_TOTAL_VLR_PARCELAS_PGTO_APP   : String; //NUMBER(18,2), -- VALOR DE PARCELAS PAGAS PELO APP
              HTML_TOTAL_QTD_PARCELAS_PGTO_DECRE : String; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS - DECRE
              HTML_TOTAL_VLR_PARCELAS_PGTO_DECRE : String; //NUMBER(18,2), -- VALOR DAS PARCELAS PAGAS - DECRE
              HTML_TOTAL_QTD_PARCELAS_PGTO_0800  : String; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS - 0800
              HTML_TOTAL_VLR_PARCELAS_PGTO_0800  : String; //NUMBER(18,2), -- VALOR DAS PARCELAS PAGAS - 0800
              HTML_TOTAL_QTD_PGTO_BOLETO_APP     : String; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO BOLETO APP
              HTML_TOTAL_VLR_PGTO_BOLETO_APP     : String; //NUMBER(18,2), -- VALOR DE PAGAMENTO BOLETO APP
              HTML_TOTAL_QTD_PGTO_DEBITO_APP     : String; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO DEBITO BOLETO APP
              HTML_TOTAL_VLR_PGTO_DEBITO_APP     : String; //NUMBER(18,2), -- VALOR DE PAGAMENTO DEBITO BOLETO APP
              HTML_TOTAL_QTD_PGTO_CREDITO_APP    : String; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO CREDITO BOLETO APP
              HTML_TOTAL_VLR_PGTO_CREDITO_APP    : String; //NUMBER(18,2), -- VALOR DE PAGAMENTO CREDITO BOLETO APP
              HTML_TOTAL_QTD_PGTO_PIX_APP        : String; //NUMBER(8),
              HTML_TOTAL_VLR_PGTO_PIX_APP        : String; //NUMBER(18,2),
              HTML_TOTAL_QTD_PGTO_BOLETO_DECRE   : String; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO BOLETO DECRE
              HTML_TOTAL_VLR_PGTO_BOLETO_DECRE   : String; //NUMBER(18,2), -- VALOR DE PAGAMENTO CREDITO BOLETO APP
              HTML_TOTAL_QTD_PGTO_CARTAO_DECRE   : String; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO COM CARTAO DECRE - Campo n�o existe na tabela, ser� criado futuramente
              HTML_TOTAL_VLR_PGTO_CARTAO_DECRE   : String; //NUMBER(18,2), -- VALOR DE PAGAMENTO COM CARTAO DECRE - Campo n�o existe na tabela, ser� criado futuramente
              HTML_TOTAL_QTD_PGTO_PIX_DECRE      : String; //NUMBER(8),
              HTML_TOTAL_VLR_PGTO_PIX_DECRE      : String; //NUMBER(18,2),
              HTML_TOTAL_QTD_PGTO_LOJA           : String; //NUMBER(8),
              HTML_TOTAL_VLR_PGTO_LOJA           : String; //NUMBER(18,2),
              HTML_TOTAL_QTD_PGTO_DEBITO_LOJA    : String; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO DEBITO LOJA
              HTML_TOTAL_VLR_PGTO_DEBITO_LOJA    : String; //NUMBER(18,2), -- VALOR PAGAMENTO DEBITO LOJA
              HTML_TOTAL_QTD_PGTO_CREDITO_LOJA   : String; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO CREDITO LOJA
              HTML_TOTAL_VLR_PGTO_CREDITO_LOJA   : String; //NUMBER(18,2), -- VALOR PAGAMENTO CREDITO LOJA
              HTML_TOTAL_QTD_PGTO_PIX_LOJA       : String; //NUMBER(8),
              HTML_TOTAL_VLR_PGTO_PIX_LOJA       : String; //NUMBER(18,2),
              HTML_TOTAL_QTD_PGTO_A_ATENDIMENTO  : String;
              HTML_TOTAL_VLR_PGTO_A_ATENDIMENTO  : String;
              // Campo de percentuais e totais....
              // �rea N� Pagamentos - APP...
              HTML_TOTAL_TOTAL_N_PAGAMENTOS      : String;
              HTML_TOTAL_PERC_TOTAL_N_PAGAMENTOS : String;
              HTML_TOTAL_TOT_N_PGTO_APP          : String;
              HTML_TOTAL_PERC_TOT_N_PGTO_APP     : String;
              // �rea Pagamentos R$.....
              HTML_TOTAL_TICKET_MEDIO_VLR_PARCELAS: String;
              HTML_TOTAL_TOTAL_RS_PAGAMENTOS      : String;
              HTML_TOTAL_TICKET_MEDIO_PAGAMENTOS  : String;
              HTML_TOTAL_PERC_TOTAL_RS_PAGAMENTOS : String;
              // �rea Pagamentos R$ - APP...
              HTML_TOTAL_TOT_RS_PGTO_APP          : String;
              HTML_TOTAL_TICKET_MEDIO_PAG_APP     : String;
              HTML_TOTAL_PERC_TOT_RS_PGTO_APP     : String;
              HTML_TOTAL_PERC_RS_PGTO_APP_DEBITO  : String;
              HTML_TOTAL_PERC_RS_PGTO_APP_CREDITO : String;
              HTML_TOTAL_PERC_RS_PGTO_APP_PIX     : String;
              HTML_TOTAL_PERC_RS_PGTO_APP_BOLETO  : String;
              // �rea Pagamentos R$ - Decre...
              HTML_TOTAL_TOT_RS_PGTO_DECRE        : String;
              HTML_TOTAL_TICKET_MEDIO_PAG_DECRE   : String;
              HTML_TOTAL_PERC_TOT_RS_PGTO_DECRE   : String;
              HTML_TOTAL_PERC_RS_PGTO_DECRE_BOLETO: String;
              HTML_TOTAL_PERC_RS_PGTO_DECRE_PIX   : String;
              HTML_TOTAL_PERC_RS_PGTO_DECRE_CARTAO: String;
              // �rea Pagamentos R$ - Loja...
              HTML_TOTAL_TOT_RS_PGTO_LOJA         : String;
              HTML_TOTAL_TICKET_MEDIO_PAG_LOJA    : String;
              HTML_TOTAL_PERC_TOT_RS_PGTO_LOJA    : String;
              HTML_TOTAL_PERC_RS_PGTO_LOJA_EFETIVO: String;
              HTML_TOTAL_PERC_RS_PGTO_LOJA_DEBITO : String;
              HTML_TOTAL_PERC_RS_PGTO_LOJA_PIX    : String;
              HTML_TOTAL_PERC_VLR_A_ATENDIMENTO   : String;
              HTML_TOTAL_PERC_PGTO_A_ATENDIMENTO  : String;
    end;
    REMAIL = record
             ASSUNTO     : String;
             ENDERECO    : String;
             USUARIO     : String;
             SENHA       : String;
             NOME        : String;
             PORTA       : String;
             HOST        : String;
             DESTINATARIO: String;
             COPIAOCULTA : String;
             CORPO       : WideString;
    end;

type
  TfrmPrincipal = class(TForm)
    pnlFundo: TPanel;
    lblMensagem: TLabel;
    ggeKPIPagamentos: TGauge;
    pnlCabecalho: TPanel;
    grpIntervalo: TGroupBox;
    lblInicio: TLabel;
    lblFinal: TLabel;
    edtInicio: TMaskEdit;
    edtFinal: TMaskEdit;
    acbrEMail: TACBrMail;
    trsOracle: TFDTransaction;
    fdcOracle: TFDConnection;
    dtsRelatorioVendas: TDataSource;
    qryRelatorioVendas: TFDQuery;
    dtsTotais: TDataSource;
    qryTotais: TFDQuery;
    pumMenu: TPopupMenu;
    mniSair: TMenuItem;
    pnlRodape: TPanel;
    btnSair: TBitBtn;
    fspGRZ_Rel_Pgto_AppxLoja_SP: TFDStoredProc;
    qryGeralDados: TFDQuery;
    procedure PreencheEstilos(Sender: TObject);
    procedure Envia_Email(Sender: TObject);
    procedure Monta_HTML(Sender: TObject);
    procedure Seleciona_Valores(Sender: TObject);
    procedure Le_Configuracao_Email(Sender: TObject);
    procedure Log(Texto: String);
    procedure mniSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
        { Public declarations }
        GRZW_REL_PGTOS_APPXLOJA: RGRZW_REL_PGTOS_APPXLOJA;
        EMAIL: REMAIL;
        sHTMLEMail, sHTMLLinha: WideString;
        sDataAtual, sDataInicio, sDataFinal, sDataInicioAno,sAnoAtual: String;
        aEstilos: array of String;
        mmoEstilos: TMemo;
        iEstilos: Integer;
         dSomaTotalRecebidos, dTotalRecebidos, dSomaTotalDoApp, dTotalDoApp, dSomaTotalDecre, dTotalDecre, dSomaTotalLojas, dTotalLojas : double;
  end;

const
     sSQLSelectPagamentos =
                  'select dta_mes,'+
                  '       tot_cli_cadastrados,'+
                  '       qtd_tot_cli_app,'+
                  '       qtd_new_cli_app,'+
                  '       qtd_cli_grazziotin,'+
                  '       qtd_new_cli_app_aprov,'+
                  '       qtd_cli_novos_pendentes,'+

                  '       qtd_parcelas_areceber,'+
                  '       vlr_parcelas_areceber,'+

                  '       tot_cli_pgto_cia,'+
                  '       tot_cli_pgto_app,'+
                  '       qtd_parcelas_pgto_cia,'+
                  '       qtd_parcelas_pgto_app,'+
                  '       vlr_parcelas_pgto_cia,'+
                  '       vlr_parcelas_pgto_app,'+
                  '       qtd_parcelas_pgto_decre,'+
                  '       vlr_parcelas_pgto_decre,'+
                  '       qtd_parcelas_pgto_0800,'+
                  '       vlr_parcelas_pgto_0800,'+
                  '       qtd_pgto_boleto_app,'+
                  '       vlr_pgto_boleto_app,'+
                  '       qtd_pgto_debito_app,'+
                  '       vlr_pgto_debito_app,'+
                  '       qtd_pgto_credito_app,'+
                  '       vlr_pgto_credito_app,'+
                  '       qtd_pgto_pix_app,'+
                  '       vlr_pgto_pix_app,'+
                  '       qtd_pgto_boleto_decre,'+
                  '       vlr_pgto_boleto_decre,'+
                  '       qtd_pgto_pix_decre,'+
                  '       vlr_pgto_pix_decre,'+
                  '       qtd_pgto_loja,'+
                  '       vlr_pgto_loja,'+
                  '       qtd_pgto_debito_loja,'+
                  '       vlr_pgto_debito_loja,'+
                  '       qtd_pgto_credito_loja,'+
                  '       vlr_pgto_credito_loja,'+
                  '       qtd_pgto_pix_loja,'+
                  '       vlr_pgto_pix_loja, '+
                  '       QTD_PGTO_AUTOATEND,'+
                  '       VLR_PGTO_AUTOATEND '+
                  ' from grzw_rel_pgtos_appxloja '+
                  'where (dta_mes between to_date(:inicial,''dd/mm/yyyy'') and to_date(:final,''dd/mm/yyyy'')) '+
                  'order by dta_mes';
     sSQLTotaisPagamentos = 'select sum(qtd_tot_cli_app) as qtd_tot_cli_app,'+
                  '       sum(tot_cli_cadastrados) as tot_cli_cadastrados,'+
                  '       sum(qtd_new_cli_app) as qtd_new_cli_app,'+
                  '       sum(qtd_cli_grazziotin) as qtd_cli_grazziotin,'+
                  '       sum(qtd_new_cli_app_aprov) as qtd_new_cli_app_aprov,'+
                  '       sum(qtd_cli_novos_pendentes) as qtd_cli_novos_pendentes,'+

                  '       sum(qtd_parcelas_areceber) as qtd_parcelas_areceber,'+
                  '       sum(vlr_parcelas_areceber) as vlr_parcelas_areceber,'+

                  '       sum(tot_cli_pgto_cia) as tot_cli_pgto_cia,'+
                  '       sum(tot_cli_pgto_app) as tot_cli_pgto_app,'+
                  '       sum(qtd_parcelas_pgto_cia) as qtd_parcelas_pgto_cia,'+
                  '       sum(qtd_parcelas_pgto_app) as qtd_parcelas_pgto_app,'+
                  '       sum(vlr_parcelas_pgto_cia) as vlr_parcelas_pgto_cia,'+
                  '       sum(vlr_parcelas_pgto_app) as vlr_parcelas_pgto_app,'+
                  '       sum(qtd_parcelas_pgto_decre) as qtd_parcelas_pgto_decre,'+
                  '       sum(vlr_parcelas_pgto_decre) as vlr_parcelas_pgto_decre,'+
                  '       sum(qtd_parcelas_pgto_0800) as qtd_parcelas_pgto_0800,'+
                  '       sum(vlr_parcelas_pgto_0800) as vlr_parcelas_pgto_0800,'+
                  '       sum(qtd_pgto_boleto_app) as qtd_pgto_boleto_app,'+
                  '       sum(vlr_pgto_boleto_app) as vlr_pgto_boleto_app,'+
                  '       sum(qtd_pgto_debito_app) as qtd_pgto_debito_app,'+
                  '       sum(vlr_pgto_debito_app) as vlr_pgto_debito_app,'+
                  '       sum(qtd_pgto_credito_app) as qtd_pgto_credito_app,'+
                  '       sum(vlr_pgto_credito_app) as vlr_pgto_credito_app,'+
                  '       sum(qtd_pgto_pix_app) as qtd_pgto_pix_app,'+
                  '       sum(vlr_pgto_pix_app) as vlr_pgto_pix_app,'+
                  '       sum(qtd_pgto_boleto_decre) as qtd_pgto_boleto_decre,'+
                  '       sum(vlr_pgto_boleto_decre) as vlr_pgto_boleto_decre,'+
                  '       sum(qtd_pgto_pix_decre) as qtd_pgto_pix_decre,'+
                  '       sum(vlr_pgto_pix_decre) as vlr_pgto_pix_decre,'+
                  '       sum(qtd_pgto_loja) as qtd_pgto_loja,'+
                  '       sum(vlr_pgto_loja) as vlr_pgto_loja,'+
                  '       sum(qtd_pgto_debito_loja) as qtd_pgto_debito_loja,'+
                  '       sum(vlr_pgto_debito_loja) as vlr_pgto_debito_loja,'+
                  '       sum(qtd_pgto_credito_loja) as qtd_pgto_credito_loja,'+
                  '       sum(vlr_pgto_credito_loja) as vlr_pgto_credito_loja,'+
                  '       sum(qtd_pgto_pix_loja) as qtd_pgto_pix_loja,'+
                  '       sum(vlr_pgto_pix_loja) as vlr_pgto_pix_loja, '+
                  '       sum(QTD_PGTO_AUTOATEND) as QTD_PGTO_AUTOATEND,'+
                  '       sum(VLR_PGTO_AUTOATEND) as VLR_PGTO_AUTOATEND '+
                  'from grzw_rel_pgtos_appxloja '+
                  'where (dta_mes between to_date(:inicial,''dd/mm/yyyy'') and to_date(:final,''dd/mm/yyyy''))';

var
   frmPrincipal: TfrmPrincipal;
   sDiretorioAtual: String;
   ifArquivo: TIniFile;

implementation

{$R *.dfm}

uses Ufuncoes;

procedure TfrmPrincipal.PreencheEstilos(Sender: TObject);
var
   sEstilos: String;
   iInd: Integer;
begin
     mmoEstilos := TMemo.Create(Self);
     mmoEstilos.Parent := self;
     mmoEstilos.Name := 'mmoEstilos'; // Caso vc queira nome�-lo
     mmoEstilos.Visible := False;

     mmoEstilos.Lines.Clear;

     for sEstilos in TStyleManager.StyleNames do
         mmoEstilos.Lines.Add(sEstilos);

     iEstilos := mmoEstilos.Lines.Count;
     SetLength(aEstilos, iEstilos);

     for iInd := 0 to iEstilos do
         aEstilos[iInd] := mmoEstilos.Lines[iInd];

     Randomize;
     iEstilos := Random(40);

     TStyleManager.TrySetStyle(aEstilos[iEstilos]);
end;

procedure TfrmPrincipal.Log(Texto: String);
var
   sArquivo : String;
   tfArquivo: TextFile;
   fbArquivo: File of byte;
   iSize: Integer;
begin
     sArquivo := sDiretorioAtual + '\LOG.log';

     try
        try
           if not FileExists(sArquivo) then
           begin
                Rewrite(tfArquivo, sArquivo);
                CloseFile(tfArquivo);
           end;
           AssignFile (fbArquivo, sArquivo);
           Reset(fbArquivo);
           iSize := FileSize(fbArquivo);
           CloseFile(fbArquivo);
           if (iSize > 1048576) then
              DeleteFile(pChar(sArquivo));
           AssignFile(tfArquivo, sArquivo);
           if not FileExists(sArquivo) then
              Rewrite(tfArquivo, sArquivo);
           Append(tfArquivo);
           Writeln(tfArquivo, '->' + FormatDateTime('dd/mm/yyyy hh:nn:ss:zzz', now)+':'+Texto);
        finally
               CloseFile(tfArquivo);
        end;
     except
     end;
end;

procedure TfrmPrincipal.Seleciona_Valores(Sender: TObject);
begin
     if fdcOracle.InTransaction then
        fdcOracle.Commit;
     fdcOracle.StartTransaction;

     Log('Verificando exist�ncia de dados...');
     lblMensagem.Caption := 'Verificando exist�ncia de dados...';
     lblMensagem.Update;
     Delay(200);

     // Verifica se j� existe registro na tabela GRZW_REL_PGTOS_APPXLOJA,
     // Se existir, deleta...
     qryGeralDados.Active := False;
     qryGeralDados.SQL.Clear;
     qryGeralDados.SQL.Add(
              'select * from grzw_rel_pgtos_appxloja where (dta_mes = :dta_mes)');
     qryGeralDados.Params.ParamByName('dta_mes').AsDate := StrToDate(edtInicio.Text);
     qryGeralDados.Active := True;
     // Existe registro....
     if not (qryGeralDados.FieldByName('dta_mes').IsNull) then
     begin
          Log('Existe dados!!! Deleta-os...');
          lblMensagem.Caption := 'Existe dados!!! Deleta-os...';
          lblMensagem.Update;
          Delay(200);

          qryGeralDados.Active := False;
          qryGeralDados.SQL.Clear;
          qryGeralDados.SQL.Add(
                   'delete from grzw_rel_pgtos_appxloja where (dta_mes = :dta_mes)');
          qryGeralDados.Params.ParamByName('dta_mes').AsDate := StrToDate(edtInicio.Text);
          qryGeralDados.ExecSQL;
          trsOracle.CommitRetaining;
     end;

     Log('Executando PROCEDURE para atualizar valores....');
     lblMensagem.Caption := 'Executando PROCEDURE, atualizando valores...';
     lblMensagem.Update;
     ggeKPIPagamentos.Progress := 10;
     Delay(200);

     fspGRZ_Rel_Pgto_AppxLoja_SP.Active := False;
     fspGRZ_Rel_Pgto_AppxLoja_SP.Params.ParamByName('pdatainicial').AsString := edtInicio.Text;
     fspGRZ_Rel_Pgto_AppxLoja_SP.Params.ParamByName('pdatafinal').AsString := edtFinal.Text;
     fspGRZ_Rel_Pgto_AppxLoja_SP.Execute();

     Log('Valores atualizados....');
     lblMensagem.Caption := 'Valores atualizados....';
     lblMensagem.Update;
     Delay(200);

     Log('Seleciona valores para KPI Pagamentos....');
     // SQL dos VALORES.....
     qryRelatorioVendas.Active := False;
     qryRelatorioVendas.SQL.Clear;
     qryRelatorioVendas.SQL.Add(sSQLSelectPagamentos);
     //qryRelatorioVendas.Params.ParamByName('inicial').AsString := sDataInicioAno;
     qryRelatorioVendas.Params.ParamByName('inicial').AsString := sDataInicioAno;
     qryRelatorioVendas.Params.ParamByName('final').AsString := edtFinal.Text;
     qryRelatorioVendas.Active := True;

     Log('Seleciona totais para KPI Pagamentos....');
     // SQL dos TOTAIS...
     qryTotais.Active := False;
     qryTotais.SQL.Clear;
     qryTotais.SQL.Add(sSQLTotaisPagamentos);
     //qryTotais.Params.ParamByName('inicial').AsString := edtInicio.Text;
     qryTotais.Params.ParamByName('inicial').AsString := sDataInicioAno;
     qryTotais.Params.ParamByName('final').AsString := edtFinal.Text;
     qryTotais.Active := True;
end;

procedure TfrmPrincipal.Le_Configuracao_Email(Sender: TObject);
begin
     Log('L� dados do .INI..');
     try
        // Leitura do .INI...
        ifArquivo := TIniFile.Create(sDiretorioAtual+'\KPIPagamentos.ini');
        EMAIL.ENDERECO := ifArquivo.ReadString('EMAIL','ENDERECO','N�o encontrado');
        EMAIL.NOME := ifArquivo.ReadString('EMAIL','NOME','N�o encontrado');
        EMAIL.HOST := ifArquivo.ReadString('EMAIL','HOST','N�o encontrado');
        EMAIL.PORTA := ifArquivo.ReadString('EMAIL','PORTA','N�o encontrado');
        EMAIL.USUARIO := ifArquivo.ReadString('EMAIL','USUARIO','N�o encontrado');
        EMAIL.SENHA := ifArquivo.ReadString('EMAIL','SENHA','N�o encontrado');
        EMAIL.ASSUNTO := ifArquivo.ReadString('EMAIL','ASSUNTO','N�o encontrado');
        EMAIL.DESTINATARIO := ifArquivo.ReadString('EMAIL','DESTINATARIO','N�o encontrado');
        EMAIL.COPIAOCULTA := ifArquivo.ReadString('EMAIL','COPIAOCULTA','N�o encontrado');
        ifArquivo.Free;
        {Informacao('DADOS DO E-MAIL...'+#13+
                   'Diretorio: '+sDiretorioAtual+'\KPIPagamentos.ini'+#13+
                   'Endere�o: '+EMAIL.ENDERECO+#13+
                   'Nome: '+EMAIL.NOME+#13+
                   'Host: '+EMAIL.HOST+#13+
                   'Porta: '+EMAIL.PORTA+#13+
                   'Usu�rio: '+EMAIL.USUARIO+#13+
                   'Senha: '+EMAIL.SENHA+#13+
                   'Assunto: '+EMAIL.ASSUNTO+#13+
                   'Destinat�rio: '+EMAIL.DESTINATARIO+#13+
                   'C�pia Oculta: '+EMAIL.COPIAOCULTA,
                   'Aviso...');}
     except
           Informacao('Erro: N�o carregou arquivo de configura��o.'+#13+
                      'Verifique!!!!'+#13+
                      sDiretorioAtual+'\KPIPagamentos.ini','Aviso...');
           Log('Erro: N�o carregou arquivo de configura��o.'+sDiretorioAtual+'\KPIPagamentos.ini');
           Application.Terminate;
           Exit;
     end;
end;

procedure TfrmPrincipal.Envia_Email(Sender: TObject);
begin
       if (dayofweek(strtodate(sDataAtual))) = 2 then
       begin
           lblMensagem.Caption := 'Enviando e-mail..';
           lblMensagem.Update;
           Delay(200);

           Log('Envia e-mail...');
           // Configura e envia E-Mail...

           EMAIL.CORPO := sHTMLEMail;
           acbrEMail.From := EMAIL.ENDERECO;
           acbrEMail.FromName := EMAIL.NOME;
           acbrEMail.Username := EMAIL.USUARIO;
           acbrEMail.Password := EMAIL.SENHA;
           acbrEMail.Host := EMAIL.HOST;
           acbrEMail.Port := EMAIL.PORTA;
           acbrEMail.Subject := EMAIL.ASSUNTO;
           acbrEMail.AddAddress(EMAIL.DESTINATARIO,'');
           //acbrEMail.AddCC(EMAIL.DESTINATARIO); // E-mail em copia...
           acbrEMail.AddBCC(EMAIL.COPIAOCULTA); // E-mail em copia...
           acbrEMail.Body.Add(EMAIL.CORPO);
           acbrEMail.IsHTML := True;
           acbrEMail.SetTLS := True;
           acbrEMail.SetSSL := False;
           //try
              acbrEMail.Send;
           {except
                 Log('DADOS DO E-MAIL...'+#13+
                     'Diretorio: '+sDiretorioAtual+'\KPIPagamentos.ini'+#13+
                     'Endere�o: '+EMAIL.ENDERECO+#13+
                     'Nome: '+EMAIL.NOME+#13+
                     'Host: '+EMAIL.HOST+#13+
                     'Porta: '+EMAIL.PORTA+#13+
                     'Usu�rio: '+EMAIL.USUARIO+#13+
                     'Senha: '+EMAIL.SENHA+#13+
                     'Assunto: '+EMAIL.ASSUNTO+#13+
                     'Destinat�rio: '+EMAIL.DESTINATARIO+#13+
                     'C�pia Oculta: '+EMAIL.COPIAOCULTA);
           end;}

           lblMensagem.Caption := 'E-mail enviado...';
           lblMensagem.Update;
           Delay(400);
       end
     else
       exit;

end;

procedure TfrmPrincipal.Monta_HTML(Sender: TObject);
var
   tsArquivoHTML: TStringList;

begin
     frmPrincipal.Update;

     // Transfere valores do SQL de Totais para estrutura em mem�ria....
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_TOT_CLI_APP := qryTotais.FieldByName('qtd_tot_cli_app').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_CLI_CADASTRADOS := qryTotais.FieldByName('tot_cli_cadastrados').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_NEW_CLI_APP := qryTotais.FieldByName('qtd_new_cli_app').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_CLI_GRAZZIOTIN := qryTotais.FieldByName('qtd_cli_grazziotin').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_NEW_CLI_APP_APROV := qryTotais.FieldByName('qtd_new_cli_app_aprov').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_CLI_NOVOS_PENDENTES := qryTotais.FieldByName('qtd_cli_novos_pendentes').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_ARECEBER := qryTotais.FieldByName('qtd_parcelas_areceber').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_ARECEBER := qryTotais.FieldByName('vlr_parcelas_areceber').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_CLI_PGTO_APP := qryTotais.FieldByName('tot_cli_pgto_app').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_PGTO_CIA := qryTotais.FieldByName('qtd_parcelas_pgto_cia').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_PGTO_CIA := qryTotais.FieldByName('vlr_parcelas_pgto_cia').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_PGTO_APP := qryTotais.FieldByName('qtd_parcelas_pgto_app').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_PGTO_APP := qryTotais.FieldByName('vlr_parcelas_pgto_app').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_PGTO_DECRE := qryTotais.FieldByName('qtd_parcelas_pgto_decre').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_PGTO_DECRE := qryTotais.FieldByName('vlr_parcelas_pgto_decre').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_PGTO_0800 := qryTotais.FieldByName('qtd_parcelas_pgto_0800').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_PGTO_0800 := qryTotais.FieldByName('vlr_parcelas_pgto_0800').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_BOLETO_APP := qryTotais.FieldByName('qtd_pgto_boleto_app').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_BOLETO_APP := qryTotais.FieldByName('vlr_pgto_boleto_app').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_DEBITO_APP := qryTotais.FieldByName('qtd_pgto_debito_app').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_DEBITO_APP := qryTotais.FieldByName('vlr_pgto_debito_app').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_CREDITO_APP := qryTotais.FieldByName('qtd_pgto_credito_app').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_CREDITO_APP := qryTotais.FieldByName('vlr_pgto_credito_app').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_CLI_PGTO_CIA := qryTotais.FieldByName('tot_cli_pgto_cia').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_BOLETO_DECRE := qryTotais.FieldByName('qtd_pgto_boleto_decre').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_CARTAO_DECRE := 0; // QUANTIDADE DE PAGAMENTO COM CARTAO DECRE - Campo n�o existe na tabela, ser� criado futuramente
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_CARTAO_DECRE := 0; // VALOR DE PAGAMENTO COM CARTAO DECRE - Campo n�o existe na tabela, ser� criado futuramente
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_BOLETO_DECRE := qryTotais.FieldByName('vlr_pgto_boleto_decre').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_LOJA := qryTotais.FieldByName('qtd_pgto_loja').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_LOJA := qryTotais.FieldByName('vlr_pgto_loja').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_DEBITO_LOJA := qryTotais.FieldByName('qtd_pgto_debito_loja').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_DEBITO_LOJA := qryTotais.FieldByName('vlr_pgto_debito_loja').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_CREDITO_LOJA := qryTotais.FieldByName('qtd_pgto_credito_loja').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_CREDITO_LOJA := qryTotais.FieldByName('vlr_pgto_credito_loja').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_A_ATENDIMENTO := qryTotais.FieldByName('VLR_PGTO_AUTOATEND').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_A_ATENDIMENTO := qryTotais.FieldByName('QTD_PGTO_AUTOATEND').AsFloat;

     // Campos PIX...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_PIX_APP := qryTotais.FieldByName('qtd_pgto_pix_app').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_PIX_DECRE := qryTotais.FieldByName('qtd_pgto_pix_decre').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_PIX_LOJA := qryTotais.FieldByName('qtd_pgto_pix_loja').AsFloat;

     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_APP := qryTotais.FieldByName('vlr_pgto_pix_app').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_DECRE := qryTotais.FieldByName('vlr_pgto_pix_decre').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_LOJA := qryTotais.FieldByName('vlr_pgto_pix_loja').AsFloat;

     // Soma os valores de parcelas 0800, nos valores dos boletos DECRE...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_BOLETO_DECRE := GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_BOLETO_DECRE +
                                                            GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_PGTO_0800;
     // Soma as quantidades de parcelas 0800, nos valores dos boletos DECRE...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_BOLETO_DECRE := GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_BOLETO_DECRE +
                                                            GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_PGTO_0800;

     // Na �rea Pagamentros R$ - Loja, diminui o debito (GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_LOJA)
     // do Efetivo (GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA)...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_LOJA := GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_LOJA -
                                                    GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_DEBITO_LOJA -
                                                    GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_LOJA;
     // Na �rea N� Pagamentos - Loja, diminui o debito  (GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_DEBITO_LOJA)
     // do Efetivo (GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_LOJA)...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_LOJA := GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_LOJA -
                                                    GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_DEBITO_LOJA -
                                                    GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_PIX_LOJA;

     // Calcula percentuais e totais das �reas do relat�rio...
     // �rea N� Pagamentos - Total APP...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_N_PGTO_APP := GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_DEBITO_APP+
                                                     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_CREDITO_APP+
                                                     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_PIX_APP+
                                                     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_BOLETO_APP;
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TOT_N_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_N_PGTO_APP,ffNumber,10,0);
     // �rea N� Pagamentos - Total Decre...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_N_PGTO_DECRE := GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_BOLETO_DECRE+
                                                       GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_PIX_DECRE+
                                                       GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_CARTAO_DECRE;
     // �rea N� Pagamentos - Total Loja...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_N_PGTO_LOJA := GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_LOJA+
                                                      GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_DEBITO_LOJA+
                                                      GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_PIX_LOJA;
     // �rea N� Pagamentos - Total N� Pagamentos...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOTAL_N_PAGAMENTOS := GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_N_PGTO_APP +
                                                         GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_N_PGTO_DECRE +
                                                         GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_N_PGTO_LOJA;
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TOTAL_N_PAGAMENTOS := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOTAL_N_PAGAMENTOS,ffNumber,10,0);

     // Percentual de Recebidos (quantidade) sobre as parcelas a receber....
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOTAL_N_PAGAMENTOS := GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOTAL_N_PAGAMENTOS /
                                                              iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_ARECEBER = 0,1,
                                                                  GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_ARECEBER) * 100;
     if (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOTAL_N_PAGAMENTOS > 100) or (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOTAL_N_PAGAMENTOS < 0) then
        GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOTAL_N_PAGAMENTOS := 100;
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_TOTAL_N_PAGAMENTOS := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOTAL_N_PAGAMENTOS,ffNumber,5,2);

     // �rea N� Pagamentos - Calculo dos percentuais dos totais de APP, DECRE e LOJA, em cima do total geral do N� pagamentos....
     // % APP...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOT_N_PGTO_APP := GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_N_PGTO_APP /
                                                          iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOTAL_N_PAGAMENTOS = 0,1,
                                                              GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOTAL_N_PAGAMENTOS) * 100;
     if (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOT_N_PGTO_APP > 100) or (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOT_N_PGTO_APP < 0) then
        GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOT_N_PGTO_APP := 100;
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_TOT_N_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOT_N_PGTO_APP,ffNumber,5,1);
     // �rea Pagamentos R$ - Total APP...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_APP := GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_DEBITO_APP+
                                                      GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_CREDITO_APP+
                                                      GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_APP+
                                                      GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_BOLETO_APP;
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TOT_RS_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_APP,ffNumber,18,0);
     // Linha de Totais: Calculo do Ticket M�dio do total de pagamentos: Ticket m�dio = Valor recebido / n�mero de parcelas
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_TICKET_MEDIO_PAG_APP := GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_APP /
                                                           iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_N_PGTO_APP <= 0,1,
                                                               GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_N_PGTO_APP);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TICKET_MEDIO_PAG_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TICKET_MEDIO_PAG_APP,ffNumber,18,2);

     // �rea Pagamentos R$ - Percentuais APP - D�bito...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_APP_DEBITO := GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_DEBITO_APP /
                                                              iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_APP = 0,1,GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_APP) * 100;
     if (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_APP_DEBITO > 100) or (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_APP_DEBITO < 0) then
        GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_APP_DEBITO := 100;
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_RS_PGTO_APP_DEBITO := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_APP_DEBITO,ffNumber,5,1);
     // �rea Pagamentos R$ - Percentuais APP - Cr�dito...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_APP_CREDITO := GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_CREDITO_APP /
                                                               iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_APP = 0,1,GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_APP) * 100;
     if (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_APP_CREDITO > 100) or (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_APP_CREDITO < 0) then
        GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_APP_CREDITO := 100;
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_RS_PGTO_APP_CREDITO := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_APP_CREDITO,ffNumber,5,1);
     // �rea Pagamentos R$ - Percentuais APP - PIX...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_APP_PIX := GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_APP /
                                                           iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_APP = 0,1,GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_APP) * 100;
     if (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_APP_PIX > 100) or (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_APP_PIX < 0) then
        GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_APP_PIX := 100;
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_RS_PGTO_APP_PIX := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_APP_PIX,ffNumber,5,1);
     // �rea Pagamentos R$ - Percentuais APP - Boleto...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_APP_BOLETO := GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_BOLETO_APP /
                                                              iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_APP = 0,1,GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_APP) * 100;
     if (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_APP_BOLETO > 100) or (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_APP_BOLETO < 0) then
        GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_APP_BOLETO := 100;
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_RS_PGTO_APP_BOLETO := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_APP_BOLETO,ffNumber,5,1);

     // �rea Pagamentos R$ - Total Decre...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_DECRE := GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_BOLETO_DECRE+
                                                        GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_DECRE+
                                                        GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_CARTAO_DECRE;
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TOT_RS_PGTO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_DECRE,ffNumber,18,0);
     // Linha de Totais: Calculo do Ticket M�dio do total de pagamentos: Ticket m�dio = Valor recebido / n�mero de parcelas
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_TICKET_MEDIO_PAG_DECRE := GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_DECRE /
                                                             iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_N_PGTO_DECRE <= 0,1,
                                                                 GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_N_PGTO_DECRE);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TICKET_MEDIO_PAG_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TICKET_MEDIO_PAG_DECRE,ffNumber,18,2);

     // �rea Pagamentos R$ - Percentuais Decre - Boleto...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_DECRE_BOLETO := GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_BOLETO_DECRE /
                                                                iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_DECRE = 0,1,GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_DECRE) * 100;
     if (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_DECRE_BOLETO > 100) or (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_DECRE_BOLETO < 0) then
        GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_DECRE_BOLETO := 100;
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_RS_PGTO_DECRE_BOLETO := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_DECRE_BOLETO,ffNumber,5,1);
     // �rea Pagamentos R$ - Percentuais Decre - PIX...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_DECRE_PIX := GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_DECRE /
                                                             iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_DECRE = 0,1,GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_DECRE) * 100;
     if (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_DECRE_PIX > 100) or (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_DECRE_PIX < 0) then
        GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_DECRE_PIX := 100;
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_RS_PGTO_DECRE_PIX := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_DECRE_PIX,ffNumber,5,1);
     // �rea Pagamentos R$ - Percentuais Decre - Cart�o...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_DECRE_CARTAO := GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_CARTAO_DECRE /
                                                                iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_DECRE = 0,1,GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_DECRE) * 100;
     if (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_DECRE_CARTAO > 100) or (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_DECRE_CARTAO < 0) then
        GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_DECRE_CARTAO := 100;
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_RS_PGTO_DECRE_CARTAO := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_DECRE_CARTAO,ffNumber,5,1);

     // �rea Pagamentos R$ - Total Loja...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_LOJA := GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_LOJA+
                                                       GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_DEBITO_LOJA+
                                                       GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_LOJA;
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TOT_RS_PGTO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_LOJA,ffNumber,18,0);
     // Linha de Totais: Calculo do Ticket M�dio do total de pagamentos: Ticket m�dio = Valor recebido / n�mero de parcelas
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_TICKET_MEDIO_PAG_LOJA := GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_LOJA /
                                                            iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_N_PGTO_LOJA <= 0,1,
                                                                GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_N_PGTO_LOJA);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TICKET_MEDIO_PAG_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TICKET_MEDIO_PAG_LOJA,ffNumber,18,2);

     // �rea Pagamentos R$ - Percentuais Loja - Efetivo...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_LOJA_EFETIVO := GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_LOJA /
                                                                iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_LOJA = 0,1,GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_LOJA) * 100;
     if (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_LOJA_EFETIVO > 100) or (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_LOJA_EFETIVO < 0) then
        GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_LOJA_EFETIVO := 100;
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_RS_PGTO_LOJA_EFETIVO := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_LOJA_EFETIVO,ffNumber,5,1);
     // �rea Pagamentos R$ - Percentuais Loja - D�bito...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_LOJA_DEBITO := GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_DEBITO_LOJA /
                                                               iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_LOJA = 0,1,GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_LOJA) * 100;
     if (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_LOJA_DEBITO > 100) or (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_LOJA_DEBITO < 0) then
        GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_LOJA_DEBITO := 100;
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_RS_PGTO_LOJA_DEBITO := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_LOJA_DEBITO,ffNumber,5,1);
     // �rea Pagamentos R$ - Percentuais Loja - PIX...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_LOJA_PIX := GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_LOJA /
                                                            iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_LOJA = 0,1,GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_LOJA) * 100;
     if (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_LOJA_PIX > 100) or (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_LOJA_PIX < 0) then
        GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_LOJA_PIX := 100;
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_RS_PGTO_LOJA_PIX := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_RS_PGTO_LOJA_PIX,ffNumber,5,1);

      // �rea Pagamentos R$ - Percentuais Loja - Auto Atendimento...
   //  GRZW_REL_PGTOS_APPXLOJA.SOMA_VLR_PGTO_A_ATENDIMENTO := GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_A_ATENDIMENTO + GRZW_REL_PGTOS_APPXLOJA.SOMA_VLR_PGTO_A_ATENDIMENTO;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_VLR_A_ATENDIMENTO := GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_A_ATENDIMENTO /
                                                             iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_LOJA = 0,1,GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_LOJA) * 100;
    if (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_VLR_A_ATENDIMENTO > 100) or (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_VLR_A_ATENDIMENTO < 0) then
        GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_VLR_A_ATENDIMENTO := 100;
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_VLR_A_ATENDIMENTO  := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_VLR_A_ATENDIMENTO,ffNumber,5,1);


     // Linha de Totais: Calculo do Ticket M�dio do valor de parcelas a receber: Ticket m�dio = Valor recebido / n�mero de parcelas
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_TICKET_MEDIO_VLR_PARCELAS := GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_ARECEBER /
                                                                iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_ARECEBER <= 0,1,
                                                                    GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_ARECEBER);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TICKET_MEDIO_VLR_PARCELAS := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TICKET_MEDIO_VLR_PARCELAS,ffNumber,18,2);

     // �rea Pagamentos R$ - Total Pagamentos R$...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOTAL_RS_PAGAMENTOS := GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_APP +
                                                          GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_DECRE +
                                                          GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_LOJA;
      GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TOTAL_RS_PAGAMENTOS := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOTAL_RS_PAGAMENTOS,ffNumber,18,0);
     // Linha de Totais: Calculo do Ticket M�dio do total de pagamentos: Ticket m�dio = Valor recebido / n�mero de parcelas
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_TICKET_MEDIO_PAGAMENTOS := GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOTAL_RS_PAGAMENTOS /
                                                              iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOTAL_N_PAGAMENTOS <= 0,1,
                                                                  GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOTAL_N_PAGAMENTOS);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TICKET_MEDIO_PAGAMENTOS := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TICKET_MEDIO_PAGAMENTOS,ffNumber,18,2);

     // Percentual de Recebidos (valor) sobre as parcelas a receber....
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOTAL_RS_PAGAMENTOS := GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOTAL_RS_PAGAMENTOS /
                                                               iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_ARECEBER = 0,1,
                                                                   GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_ARECEBER) * 100;
     if (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOTAL_RS_PAGAMENTOS > 100) or (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOTAL_RS_PAGAMENTOS < 0) then
        GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOTAL_RS_PAGAMENTOS := 100;
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_TOTAL_RS_PAGAMENTOS := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOTAL_RS_PAGAMENTOS,ffNumber,5,1);

     // �rea N� Pagamentos - Calculo dos percentuais dos totais de APP, DECRE e LOJA, em cima do total geral do N� pagamentos....
     // % APP...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOT_RS_PGTO_APP := GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_APP /
                                                           iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOTAL_RS_PAGAMENTOS = 0,1,
                                                               GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOTAL_RS_PAGAMENTOS) * 100;
     if (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOT_RS_PGTO_APP > 100) or (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOT_RS_PGTO_APP < 0) then
        GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOT_RS_PGTO_APP := 100;
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_TOT_RS_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOT_RS_PGTO_APP,ffNumber,5,1);
     // % DECRE...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOT_RS_PGTO_DECRE := GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_DECRE /
                                                             iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOTAL_RS_PAGAMENTOS = 0,1,
                                                                 GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOTAL_RS_PAGAMENTOS) * 100;
     if (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOT_RS_PGTO_DECRE > 100) or (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOT_RS_PGTO_DECRE < 0) then
        GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOT_RS_PGTO_DECRE := 100;
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_TOT_RS_PGTO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOT_RS_PGTO_DECRE,ffNumber,5,1);
     // % Loja...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOT_RS_PGTO_LOJA := GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_RS_PGTO_LOJA /
                                                            iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOTAL_RS_PAGAMENTOS = 0,1,
                                                                GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOTAL_RS_PAGAMENTOS) * 100;
     if (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOT_RS_PGTO_LOJA > 100) or (GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOT_RS_PGTO_LOJA < 0) then
        GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOT_RS_PGTO_LOJA := 100;
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_TOT_RS_PGTO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_PERC_TOT_RS_PGTO_LOJA,ffNumber,5,1);

     // Formata os valores dos totais....
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_TOT_CLI_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_TOT_CLI_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TOT_CLI_CADASTRADOS := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_CLI_CADASTRADOS,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_NEW_CLI_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_NEW_CLI_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_CLI_GRAZZIOTIN := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_CLI_GRAZZIOTIN,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_NEW_CLI_APP_APROV := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_NEW_CLI_APP_APROV,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_CLI_NOVOS_PENDENTES := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_CLI_NOVOS_PENDENTES,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PARCELAS_ARECEBER := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_ARECEBER,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PARCELAS_ARECEBER := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_ARECEBER,ffNumber,18,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TOT_CLI_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_CLI_PGTO_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PARCELAS_PGTO_CIA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_PGTO_CIA,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PARCELAS_PGTO_CIA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_PGTO_CIA,ffNumber,18,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PARCELAS_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_PGTO_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PARCELAS_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_PGTO_APP,ffNumber,18,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PARCELAS_PGTO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_PGTO_DECRE,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PARCELAS_PGTO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_PGTO_DECRE,ffNumber,18,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PARCELAS_PGTO_0800 := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_PGTO_0800,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PARCELAS_PGTO_0800 := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_PGTO_0800,ffNumber,18,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_BOLETO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_BOLETO_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_BOLETO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_BOLETO_APP,ffNumber,18,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_DEBITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_DEBITO_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_DEBITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_DEBITO_APP,ffNumber,18,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_CREDITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_CREDITO_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_CREDITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_CREDITO_APP,ffNumber,18,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TOT_CLI_PGTO_CIA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_CLI_PGTO_CIA,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_BOLETO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_BOLETO_DECRE,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_BOLETO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_BOLETO_DECRE,ffNumber,18,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_CARTAO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_CARTAO_DECRE,ffNumber,8,0); // QUANTIDADE DE PAGAMENTO COM CARTAO DECRE - Campo n�o existe na tabela, ser� criado futuramente
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_CARTAO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_CARTAO_DECRE,ffNumber,18,0); // VALOR DE PAGAMENTO COM CARTAO DECRE - Campo n�o existe na tabela, ser� criado futuramente
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_LOJA,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_LOJA,ffNumber,18,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_DEBITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_DEBITO_LOJA,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_DEBITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_DEBITO_LOJA,ffNumber,18,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_CREDITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_CREDITO_LOJA,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_CREDITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_CREDITO_LOJA,ffNumber,18,0);
     // Campos PIX....
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_PIX_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_PIX_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_PIX_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_PIX_DECRE,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_PIX_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_PIX_LOJA,ffNumber,8,0);

     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_PIX_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_APP,ffNumber,18,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_PIX_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_DECRE,ffNumber,18,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_PIX_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_LOJA,ffNumber,18,0);
     //Auto ATENDIMENTO...
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_A_ATENDIMENTO := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_A_ATENDIMENTO,ffNumber,18,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_A_ATENDIMENTO := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_A_ATENDIMENTO,ffNumber,18,0);

     sHTMLEMail := ''; sHTMLLinha := '';
     ggeKPIPagamentos.Progress := 15;
     lblMensagem.Caption := 'Iniciando montagem HTML...';
     lblMensagem.Update;
     Delay(200);
     try
        lblMensagem.Caption := 'Cabe�alhos e CSS .... ';
        lblMensagem.Update;
        Delay(200);

        // Montagem do HTML enviado por e-mail...
        sHTMLEMail := ' <!DOCTYPE html>'+
                      ' <html lang="en" >'+

                      ' <head>'+
                      ' <meta charset="UTF-8">'+
                      ' <style> '+
                      ' body {'+
                      '   line-height: 1.1;'+
                      ' }'+
                      'th, td {'+
                      '    border: 0.1em solid black;'+
                      '    padding: 0px;'+
                      '    border-spacing: 0px;'+
                      '    text-align: center;'+
                      '}'+
                      ' table {'+
                      //' vertical-align: center;'+
                      ' text-align: center;'+
                      ' border-collapse: collapse;'+
                      ' border: 0.1em solid black;'+
                      //' width: 5000px;'+
                      ' }'+
                      ' </style> '+
                      ' </head> '+
                      ' <body> '+
                      ' <table> '+
                      ' <thead> '+
                      ' <h3>Relat�rio KPI Pagamentos</h3> '+
                      ' <p>Per�odo: '+edtInicio.Text+' a '+edtFinal.Text+'</p> '+
                      ' <tr>'+

                       ' <th col style="width:10px" rowspan="3" bgcolor="Silver">M�s/Ano</th> '+
                       ' <th style="width:50px" colspan="7" bgcolor="Silver">Clientes APP</th> '+ // colspan="7" quando tuiver a coluna de usuario s ativos ultimos 60 dias
                       ' <th colspan="25" bgcolor="LightGreen">Pagamentos R$</th> '+
                       ' </tr>'+
                       ' <tr> '+
                       ' <th col style="width:20px" rowspan="2" bgcolor="Silver">Acumulado</th> '+
                       ' <th style="width:50px" rowspan="2" bgcolor="Silver">Cadastrados</th> '+
                       ' <th style="width:50px" rowspan="2" bgcolor="Silver">%</th> '+
                       //' <th style="width:50px" rowspan="2" bgcolor="Silver">Ativos Ult 60 dias</th> '+
                       ' <th style="width:50px" rowspan="2" bgcolor="Silver">Novos</th> '+
                       ' <th style="width:50px" rowspan="2" bgcolor="Silver">Grazziotin</th> '+
                       ' <th style="width:50px" rowspan="2" bgcolor="Silver">Aprovados</th> '+
                       ' <th style="width:50px" rowspan="2" bgcolor="Silver">Pendentes</th> '+
                       // Cabe�alho - PAGAMENTOS R$...
                       ' <th style="width:90px" rowspan="2" bgcolor="LightGreen">Parc. A Receber</th> '+ // Total de Pagamentos R$
                       ' <th style="width:50px" rowspan="2" bgcolor="LightGreen">Ticket M�dio</th> '+ // Ticket M�dio
                       ' <th style="width:50px" rowspan="2" bgcolor="LightGreen">Recebidos</th> '+ // Total de Pagamentos R$
                       ' <th style="width:50px" rowspan="2" bgcolor="LightGreen">Ticket M�dio</th> '+ // Ticket M�dio
                       ' <th style="width:50px" rowspan="2" bgcolor="LightGreen">%</th> '+ // Percentual valor dos recebidos pelas Parcelas a receber
                       ' <th style="width:50px" colspan="7" bgcolor="LightGreen">% App</th> '+
                       ' <th style="width:50px" colspan="6" bgcolor="LightGreen">% Decre</th> '+
                       ' <th style="width:50px" colspan="7" bgcolor="LightGreen">% Loja</th> '+
                       ' </tr> '+
                       ' <tr> '+
                       // Cabe�alho PAGAMENTOS R$....
                       // Sub cabe�alho - APP...
                       ' <th style="width:50px" bgcolor="LightGreen">Total</th> '+ // Total APP...
                       ' <th style="width:50px" bgcolor="LightGreen">Ticket M�dio</th> '+ // Ticket M�dio
                       ' <th style="width:50px" bgcolor="LightGreen">%</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">% D�bito</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">% Cr�dito</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">% PIX</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">% Boleto</th> '+
                       // Sub cabe�alho DECRE
                       ' <th style="width:50px" bgcolor="LightGreen">Total</th> '+ // Total Decre...
                       ' <th style="width:50px" bgcolor="LightGreen">Ticket M�dio</th> '+ // Ticket M�dio
                       ' <th style="width:50px" bgcolor="LightGreen">%</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">% Boleto</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">% PIX</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">% Cart�o</th> '+
                       // Sub cabe�alho LOJA
                       ' <th style="width:50px" bgcolor="LightGreen">Total</th> '+ // Total Loja...
                       ' <th style="width:50px" bgcolor="LightGreen">Ticket M�dio</th> '+ // Ticket M�dio
                       ' <th style="width:50px" bgcolor="LightGreen">%</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">% Efetivo</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">% D�bito</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">% PIX</th> '+
                        ' <th style="width:50px" bgcolor="LightGreen">% AA</th> '+

                       ' </tr> '+
                       ' </thead> '+
                       ' <tbody> ';

        ggeKPIPagamentos.Progress := 30;
        lblMensagem.Caption := 'Lendo dados das tabelas...';
        lblMensagem.Update;
        Delay(200);

        // L� o SQL e transfere para a estrutura em mem�ria e formata os valores...
        qryRelatorioVendas.First;
        while not qryRelatorioVendas.Eof do
        begin
             // Dados do SQL...
             GRZW_REL_PGTOS_APPXLOJA.DTA_MES :=  qryRelatorioVendas.FieldByName('dta_mes').AsDateTime;
             GRZW_REL_PGTOS_APPXLOJA.ANOMES := Copy(DateToStr(GRZW_REL_PGTOS_APPXLOJA.DTA_MES),4,7);
             GRZW_REL_PGTOS_APPXLOJA.ANO := Copy(DateToStr(GRZW_REL_PGTOS_APPXLOJA.DTA_MES),7,4);
             GRZW_REL_PGTOS_APPXLOJA.TOT_CLI_CADASTRADOS := qryRelatorioVendas.FieldByName('tot_cli_cadastrados').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_TOT_CLI_APP := qryRelatorioVendas.FieldByName('qtd_tot_cli_app').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_NEW_CLI_APP := qryRelatorioVendas.FieldByName('qtd_new_cli_app').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_CLI_GRAZZIOTIN := qryRelatorioVendas.FieldByName('qtd_cli_grazziotin').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_NEW_CLI_APP_APROV := qryRelatorioVendas.FieldByName('qtd_new_cli_app_aprov').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_CLI_NOVOS_PENDENTES := qryRelatorioVendas.FieldByName('qtd_cli_novos_pendentes').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_ARECEBER := qryRelatorioVendas.FieldByName('qtd_parcelas_areceber').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_ARECEBER := qryRelatorioVendas.FieldByName('vlr_parcelas_areceber').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.TOT_CLI_PGTO_APP := qryRelatorioVendas.FieldByName('tot_cli_pgto_app').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_CIA := qryRelatorioVendas.FieldByName('qtd_parcelas_pgto_cia').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_CIA := qryRelatorioVendas.FieldByName('vlr_parcelas_pgto_cia').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_APP := qryRelatorioVendas.FieldByName('qtd_parcelas_pgto_app').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_APP := qryRelatorioVendas.FieldByName('vlr_parcelas_pgto_app').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_DECRE := qryRelatorioVendas.FieldByName('qtd_parcelas_pgto_decre').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_DECRE := qryRelatorioVendas.FieldByName('vlr_parcelas_pgto_decre').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_0800 := qryRelatorioVendas.FieldByName('qtd_parcelas_pgto_0800').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_0800 := qryRelatorioVendas.FieldByName('vlr_parcelas_pgto_0800').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_BOLETO_APP := qryRelatorioVendas.FieldByName('qtd_pgto_boleto_app').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_BOLETO_APP := qryRelatorioVendas.FieldByName('vlr_pgto_boleto_app').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_DEBITO_APP := qryRelatorioVendas.FieldByName('qtd_pgto_debito_app').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_APP := qryRelatorioVendas.FieldByName('vlr_pgto_debito_app').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_CREDITO_APP := qryRelatorioVendas.FieldByName('qtd_pgto_credito_app').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_CREDITO_APP := qryRelatorioVendas.FieldByName('vlr_pgto_credito_app').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.TOT_CLI_PGTO_CIA := qryRelatorioVendas.FieldByName('tot_cli_pgto_cia').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_BOLETO_DECRE := qryRelatorioVendas.FieldByName('qtd_pgto_boleto_decre').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_CARTAO_DECRE := 0; // Campo n�o existe na tabela, ser� criado futuramente....
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_CARTAO_DECRE := 0; // Campo n�o existe na tabela, ser� criado futuramente....
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_BOLETO_DECRE := qryRelatorioVendas.FieldByName('vlr_pgto_boleto_decre').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_LOJA := qryRelatorioVendas.FieldByName('qtd_pgto_loja').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA := qryRelatorioVendas.FieldByName('vlr_pgto_loja').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_DEBITO_LOJA := qryRelatorioVendas.FieldByName('qtd_pgto_debito_loja').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_LOJA := qryRelatorioVendas.FieldByName('vlr_pgto_debito_loja').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_CREDITO_LOJA := qryRelatorioVendas.FieldByName('qtd_pgto_credito_loja').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_CREDITO_LOJA := qryRelatorioVendas.FieldByName('vlr_pgto_credito_loja').AsFloat;

               // Campos PIX....
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_APP := qryRelatorioVendas.FieldByName('qtd_pgto_pix_app').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_DECRE := qryRelatorioVendas.FieldByName('qtd_pgto_pix_decre').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_LOJA := qryRelatorioVendas.FieldByName('qtd_pgto_pix_loja').AsFloat;

             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_APP := qryRelatorioVendas.FieldByName('vlr_pgto_pix_app').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_DECRE := qryRelatorioVendas.FieldByName('vlr_pgto_pix_decre').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_LOJA := qryRelatorioVendas.FieldByName('vlr_pgto_pix_loja').AsFloat;

             // Soma os valores de parcelas 0800, nos valores do s boletos DECRE...
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_BOLETO_DECRE := GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_BOLETO_DECRE +
                                                              GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_0800;
             // Soma as quantidades de parcelas 0800, nos valores dos boletos DECRE...
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_BOLETO_DECRE := GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_BOLETO_DECRE +
                                                              GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_0800;

             // Na �rea Pagamentros R$ - Loja, diminui o debito (GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_LOJA)
             // do Efetivo (GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA)...
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA := GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA -
                                                      GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_LOJA -
                                                        GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_LOJA;
             if (GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA < 0) then
                GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA := 0;
             // Na �rea N� Pagamentos - Loja, diminui o debito  (GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_DEBITO_LOJA)
             // do Efetivo (GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_LOJA)...
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_LOJA := GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_LOJA -
                                                      GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_DEBITO_LOJA -
                                                      GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_LOJA;
             if (GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_LOJA < 0) then
                GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_LOJA := 0;

             // Campos PIX....
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_APP := qryRelatorioVendas.FieldByName('qtd_pgto_pix_app').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_DECRE := qryRelatorioVendas.FieldByName('qtd_pgto_pix_decre').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_LOJA := qryRelatorioVendas.FieldByName('qtd_pgto_pix_loja').AsFloat;

             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_APP := qryRelatorioVendas.FieldByName('vlr_pgto_pix_app').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_DECRE := qryRelatorioVendas.FieldByName('vlr_pgto_pix_decre').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_LOJA := qryRelatorioVendas.FieldByName('vlr_pgto_pix_loja').AsFloat;

              // Campo Auto Atendimento....
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_A_ATENDIMENTO  := qryRelatorioVendas.FieldByName('VLR_PGTO_AUTOATEND').AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_A_ATENDIMENTO  := qryRelatorioVendas.FieldByName('QTD_PGTO_AUTOATEND').AsFloat;
             // Calcula percentuais e totais das �reas do relat�rio...
             // �rea N� Pagamentos - Total APP...
             GRZW_REL_PGTOS_APPXLOJA.TOT_N_PGTO_APP := GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_DEBITO_APP+
                                                       GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_CREDITO_APP+
                                                       GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_APP+
                                                       GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_BOLETO_APP;
             GRZW_REL_PGTOS_APPXLOJA.HTML_TOT_N_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOT_N_PGTO_APP,ffNumber,10,0);
             // �rea N� Pagamentos - Total Decre...
             GRZW_REL_PGTOS_APPXLOJA.TOT_N_PGTO_DECRE := GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_BOLETO_DECRE+
                                                         GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_DECRE+
                                                         GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_CARTAO_DECRE;
             // �rea N� Pagamentos - Total Loja...
             GRZW_REL_PGTOS_APPXLOJA.TOT_N_PGTO_LOJA := GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_LOJA+
                                                        GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_DEBITO_LOJA+
                                                        GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_LOJA;
             // �rea N� Pagamentos - Total N� Pagamentos...
             GRZW_REL_PGTOS_APPXLOJA.TOTAL_N_PAGAMENTOS := GRZW_REL_PGTOS_APPXLOJA.TOT_N_PGTO_APP +
                                                           GRZW_REL_PGTOS_APPXLOJA.TOT_N_PGTO_DECRE +
                                                           GRZW_REL_PGTOS_APPXLOJA.TOT_N_PGTO_LOJA;
             GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_N_PAGAMENTOS := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_N_PAGAMENTOS,ffNumber,10,0);

             // Percentual de recebidos (quantidade) sobre a quantidade de parcelas areceber...
             GRZW_REL_PGTOS_APPXLOJA.PERC_TOTAL_N_PAGAMENTOS := GRZW_REL_PGTOS_APPXLOJA.TOTAL_N_PAGAMENTOS /
                                                                iif(GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_ARECEBER = 0,1,
                                                                    GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_ARECEBER) * 100;
             if (GRZW_REL_PGTOS_APPXLOJA.PERC_TOTAL_N_PAGAMENTOS > 100) or (GRZW_REL_PGTOS_APPXLOJA.PERC_TOTAL_N_PAGAMENTOS < 0) then
                GRZW_REL_PGTOS_APPXLOJA.PERC_TOTAL_N_PAGAMENTOS := 100;
             GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_TOTAL_N_PAGAMENTOS := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.PERC_TOTAL_N_PAGAMENTOS,ffNumber,5,1);

             // �rea Pagamentos R$ - Total APP...
             GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_APP := GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_APP+
                                                        GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_CREDITO_APP+
                                                        GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_APP+
                                                        GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_BOLETO_APP;
             GRZW_REL_PGTOS_APPXLOJA.HTML_TOT_RS_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_APP,ffNumber,18,0);
             // Calculo do Ticket M�dio do total de pagamentos: Ticket m�dio = Valor recebido / n�mero de parcelas
             GRZW_REL_PGTOS_APPXLOJA.TICKET_MEDIO_PAG_APP := GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_APP /
                                                             iif(GRZW_REL_PGTOS_APPXLOJA.TOT_N_PGTO_APP <= 0,1,
                                                                 GRZW_REL_PGTOS_APPXLOJA.TOT_N_PGTO_APP);
             GRZW_REL_PGTOS_APPXLOJA.HTML_TICKET_MEDIO_PAG_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TICKET_MEDIO_PAG_APP,ffNumber,18,2);

             // �rea Pagamentos R$ - Percentuais APP - D�bito...
             GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_APP_DEBITO := GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_APP /
                                                                iif(GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_APP = 0,1,GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_APP) * 100;
             if (GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_APP_DEBITO > 100) or (GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_APP_DEBITO < 0) then
                GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_APP_DEBITO := 100;
             GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_RS_PGTO_APP_DEBITO := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_APP_DEBITO,ffNumber,18,1);
             // �rea Pagamentos R$ - Percentuais APP - Cr�dito...
             GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_APP_CREDITO := GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_CREDITO_APP /
                                                                 iif(GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_APP = 0,1,GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_APP) * 100;
             if (GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_APP_CREDITO > 100) or (GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_APP_CREDITO < 0) then
                GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_APP_CREDITO := 100;
             GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_RS_PGTO_APP_CREDITO := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_APP_CREDITO,ffNumber,18,1);
             // �rea Pagamentos R$ - Percentuais APP - PIX...
             GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_APP_PIX := GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_APP /
                                                             iif(GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_APP = 0,1,GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_APP) * 100;
             if (GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_APP_PIX > 100) or (GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_APP_PIX < 0) then
                GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_APP_PIX := 100;
             GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_RS_PGTO_APP_PIX := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_APP_PIX,ffNumber,18,1);
             // �rea Pagamentos R$ - Percentuais APP - Boleto...
             GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_APP_BOLETO := GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_BOLETO_APP /
                                                                iif(GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_APP = 0,1,GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_APP) * 100;
             if (GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_APP_BOLETO > 100) or (GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_APP_BOLETO < 0) then
                GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_APP_BOLETO := 100;
             GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_RS_PGTO_APP_BOLETO := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_APP_BOLETO,ffNumber,18,1);

             // �rea Pagamentos R$ - Total Decre...
             GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_DECRE := GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_BOLETO_DECRE+
                                                          GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_DECRE+
                                                          GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_CARTAO_DECRE;
             GRZW_REL_PGTOS_APPXLOJA.HTML_TOT_RS_PGTO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_DECRE,ffNumber,18,0);
             // Calculo do Ticket M�dio do total de pagamentos: Ticket m�dio = Valor recebido / n�mero de parcelas
             GRZW_REL_PGTOS_APPXLOJA.TICKET_MEDIO_PAG_DECRE := GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_DECRE /
                                                               iif(GRZW_REL_PGTOS_APPXLOJA.TOT_N_PGTO_DECRE <= 0,1,
                                                                   GRZW_REL_PGTOS_APPXLOJA.TOT_N_PGTO_DECRE);
             GRZW_REL_PGTOS_APPXLOJA.HTML_TICKET_MEDIO_PAG_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TICKET_MEDIO_PAG_DECRE,ffNumber,18,2);

             // �rea Pagamentos R$ - Percentuais Decre - Boleto...
             GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_DECRE_BOLETO := GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_BOLETO_DECRE /
                                                                  iif(GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_DECRE = 0,1,GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_DECRE) * 100;
             if (GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_DECRE_BOLETO > 100) or (GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_DECRE_BOLETO < 0) then
                GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_DECRE_BOLETO := 100;
             GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_RS_PGTO_DECRE_BOLETO := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_DECRE_BOLETO,ffNumber,18,1);
             // �rea Pagamentos R$ - Percentuais Decre - PIX...
             GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_DECRE_PIX := GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_DECRE /
                                                               iif(GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_DECRE = 0,1,GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_DECRE) * 100;
             if (GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_DECRE_PIX > 100) or (GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_DECRE_PIX < 0) then
                GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_DECRE_PIX := 100;
             GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_RS_PGTO_DECRE_PIX := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_DECRE_PIX,ffNumber,18,1);
             // �rea Pagamentos R$ - Percentuais Decre - Cart�o...
             GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_DECRE_CARTAO := GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_CARTAO_DECRE /
                                                                  iif(GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_DECRE = 0,1,GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_DECRE) * 100;
             if (GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_DECRE_CARTAO > 100) or (GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_DECRE_CARTAO < 0) then
                GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_DECRE_CARTAO := 100;
             GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_RS_PGTO_DECRE_CARTAO := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_DECRE_CARTAO,ffNumber,18,1);

             // �rea Pagamentos R$ - Total Loja...
             GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_LOJA := GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA+
                                                         GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_LOJA+
                                                         GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_LOJA;
             GRZW_REL_PGTOS_APPXLOJA.HTML_TOT_RS_PGTO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_LOJA,ffNumber,18,0);
             // Calculo do Ticket M�dio do total de pagamentos: Ticket m�dio = Valor recebido / n�mero de parcelas
             GRZW_REL_PGTOS_APPXLOJA.TICKET_MEDIO_PAG_LOJA := GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_LOJA /
                                                              iif(GRZW_REL_PGTOS_APPXLOJA.TOT_N_PGTO_LOJA <= 0,1,
                                                                  GRZW_REL_PGTOS_APPXLOJA.TOT_N_PGTO_LOJA);
             GRZW_REL_PGTOS_APPXLOJA.HTML_TICKET_MEDIO_PAG_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TICKET_MEDIO_PAG_LOJA,ffNumber,18,2);

             // �rea Pagamentos R$ - Percentuais Loja - Efetivo....
             GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_LOJA_EFETIVO := GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA /
                                                                  iif(GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_LOJA = 0,1,GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_LOJA) * 100;
             if (GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_LOJA_EFETIVO > 100) or (GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_LOJA_EFETIVO < 0) then
                GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_LOJA_EFETIVO := 100;
             GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_RS_PGTO_LOJA_EFETIVO := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_LOJA_EFETIVO,ffNumber,18,1);
             // �rea Pagamentos R$ - Percentuais Loja - D�bito....
             GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_LOJA_DEBITO := GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_LOJA /
                                                                 iif(GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_LOJA = 0,1,GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_LOJA) * 100;
             if (GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_LOJA_DEBITO > 100) or (GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_LOJA_DEBITO < 0) then
                GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_LOJA_DEBITO := 100;
             GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_RS_PGTO_LOJA_DEBITO := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_LOJA_DEBITO,ffNumber,18,1);
             // �rea Pagamentos R$ - Percentuais Loja - PIX....
             GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_LOJA_PIX := GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_LOJA /
                                                              iif(GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_LOJA = 0,1,GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_LOJA) * 100;
             if (GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_LOJA_PIX > 100) or (GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_LOJA_PIX < 0) then
                GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_LOJA_PIX := 100;
             GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_RS_PGTO_LOJA_PIX := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.PERC_RS_PGTO_LOJA_PIX,ffNumber,18,1);

             // �rea Pagamentos R$ - Percentuais Loja - Auto Atendimento....
             GRZW_REL_PGTOS_APPXLOJA.PERC_VLR_A_ATENDIMENTO := GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_A_ATENDIMENTO/
                                                               iif(GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_LOJA = 0,1,GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_LOJA) * 100;
             GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_VLR_A_ATENDIMENTO := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.PERC_VLR_A_ATENDIMENTO,ffNumber,18,1);

             // Calculo do Ticket M�dio do total de pagamentos: Ticket m�dio = Valor recebido / n�mero de parcelas
             GRZW_REL_PGTOS_APPXLOJA.TICKET_MEDIO_VLR_PARCELAS := GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_ARECEBER /
                                                                  iif(GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_ARECEBER <= 0,1,
                                                                      GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_ARECEBER);
             GRZW_REL_PGTOS_APPXLOJA.HTML_TICKET_MEDIO_VLR_PARCELAS := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TICKET_MEDIO_VLR_PARCELAS,ffNumber,18,2);

             // �rea Pagamentos R$ - Total Pagamentos R$...
             GRZW_REL_PGTOS_APPXLOJA.TOTAL_RS_PAGAMENTOS := GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_APP+
                                                            GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_DECRE+
                                                            GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_LOJA;
             GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_RS_PAGAMENTOS := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_RS_PAGAMENTOS,ffNumber,18,0);
             // Calculo do Ticket M�dio do total de pagamentos: Ticket m�dio = Valor recebido / n�mero de parcelas
             GRZW_REL_PGTOS_APPXLOJA.TICKET_MEDIO_PAGAMENTOS := GRZW_REL_PGTOS_APPXLOJA.TOTAL_RS_PAGAMENTOS /
                                                                iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_N_PAGAMENTOS <= 0,1,
                                                                    GRZW_REL_PGTOS_APPXLOJA.TOTAL_N_PAGAMENTOS);
             GRZW_REL_PGTOS_APPXLOJA.HTML_TICKET_MEDIO_PAGAMENTOS := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TICKET_MEDIO_PAGAMENTOS,ffNumber,18,2);

             // Percentual de recebidos (valor) sobre a quantidade de parcelas areceber...
             GRZW_REL_PGTOS_APPXLOJA.PERC_TOTAL_RS_PAGAMENTOS := GRZW_REL_PGTOS_APPXLOJA.TOTAL_RS_PAGAMENTOS /
                                                                iif(GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_ARECEBER = 0,1,
                                                                    GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_ARECEBER) * 100;
             if (GRZW_REL_PGTOS_APPXLOJA.PERC_TOTAL_RS_PAGAMENTOS > 100) or (GRZW_REL_PGTOS_APPXLOJA.PERC_TOTAL_RS_PAGAMENTOS < 0) then
                GRZW_REL_PGTOS_APPXLOJA.PERC_TOTAL_RS_PAGAMENTOS := 100;
             GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_TOTAL_RS_PAGAMENTOS := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.PERC_TOTAL_RS_PAGAMENTOS,ffNumber,5,1);

             // �rea N� Pagamentos - Calculo dos percentuais dos totais de APP, DECRE e LOJA, em cima do total geral do N� pagamentos....
             // % APP...
             GRZW_REL_PGTOS_APPXLOJA.PERC_TOT_N_PGTO_APP := GRZW_REL_PGTOS_APPXLOJA.TOT_N_PGTO_APP /
                                                            iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_N_PAGAMENTOS = 0,1,
                                                                GRZW_REL_PGTOS_APPXLOJA.TOTAL_N_PAGAMENTOS) * 100;
             if (GRZW_REL_PGTOS_APPXLOJA.PERC_TOT_N_PGTO_APP > 100) or (GRZW_REL_PGTOS_APPXLOJA.PERC_TOT_N_PGTO_APP < 0) then
                GRZW_REL_PGTOS_APPXLOJA.PERC_TOT_N_PGTO_APP := 100;
             GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_TOT_N_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.PERC_TOT_N_PGTO_APP,ffNumber,5,1);

             // Calcula percentual de crescimento.....
             if ((GRZW_REL_PGTOS_APPXLOJA.TOT_CLI_CADASTRADOS - GRZW_REL_PGTOS_APPXLOJA.QTD_TOT_CLI_APP) = 0) then // Divisor zerado....
                GRZW_REL_PGTOS_APPXLOJA.PERC_CRESCIMENTO := (GRZW_REL_PGTOS_APPXLOJA.QTD_TOT_CLI_APP * 100) / 1
             else
                 GRZW_REL_PGTOS_APPXLOJA.PERC_CRESCIMENTO := (GRZW_REL_PGTOS_APPXLOJA.QTD_TOT_CLI_APP * 100) /
                                                             (GRZW_REL_PGTOS_APPXLOJA.TOT_CLI_CADASTRADOS -
                                                              GRZW_REL_PGTOS_APPXLOJA.QTD_TOT_CLI_APP);
             if (GRZW_REL_PGTOS_APPXLOJA.PERC_CRESCIMENTO > 100) or (GRZW_REL_PGTOS_APPXLOJA.PERC_CRESCIMENTO < 0) then
                GRZW_REL_PGTOS_APPXLOJA.PERC_CRESCIMENTO := 100;

             // �rea R$ Pagamentos - Calculo dos percentuais dos totais de APP, DECRE e LOJA, em cima do total geral do N� pagamentos....
             // % APP...
             GRZW_REL_PGTOS_APPXLOJA.PERC_TOT_RS_PGTO_APP := GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_APP /
                                                             iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_RS_PAGAMENTOS = 0,1,
                                                                 GRZW_REL_PGTOS_APPXLOJA.TOTAL_RS_PAGAMENTOS) * 100;
             if (GRZW_REL_PGTOS_APPXLOJA.PERC_TOT_RS_PGTO_APP > 100) or (GRZW_REL_PGTOS_APPXLOJA.PERC_TOT_RS_PGTO_APP < 0) then
                GRZW_REL_PGTOS_APPXLOJA.PERC_TOT_RS_PGTO_APP := 100;
             GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_TOT_RS_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.PERC_TOT_RS_PGTO_APP,ffNumber,5,1);
             // % DECRE...
             GRZW_REL_PGTOS_APPXLOJA.PERC_TOT_RS_PGTO_DECRE := GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_DECRE /
                                                               iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_RS_PAGAMENTOS = 0,1,
                                                                   GRZW_REL_PGTOS_APPXLOJA.TOTAL_RS_PAGAMENTOS) * 100;
             if (GRZW_REL_PGTOS_APPXLOJA.PERC_TOT_RS_PGTO_DECRE > 100) or (GRZW_REL_PGTOS_APPXLOJA.PERC_TOT_RS_PGTO_DECRE < 0) then
                GRZW_REL_PGTOS_APPXLOJA.PERC_TOT_RS_PGTO_DECRE := 100;
             GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_TOT_RS_PGTO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.PERC_TOT_RS_PGTO_DECRE,ffNumber,5,1);
             // % LOJA...
             GRZW_REL_PGTOS_APPXLOJA.PERC_TOT_RS_PGTO_LOJA := GRZW_REL_PGTOS_APPXLOJA.TOT_RS_PGTO_LOJA /
                                                               iif(GRZW_REL_PGTOS_APPXLOJA.TOTAL_RS_PAGAMENTOS = 0,1,
                                                                   GRZW_REL_PGTOS_APPXLOJA.TOTAL_RS_PAGAMENTOS) * 100;
             if (GRZW_REL_PGTOS_APPXLOJA.PERC_TOT_RS_PGTO_LOJA > 100) or (GRZW_REL_PGTOS_APPXLOJA.PERC_TOT_RS_PGTO_LOJA < 0) then
                GRZW_REL_PGTOS_APPXLOJA.PERC_TOT_RS_PGTO_LOJA := 100;
             GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_TOT_RS_PGTO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.PERC_TOT_RS_PGTO_LOJA,ffNumber,5,1);

             // Dados formatados para o HTML...
             GRZW_REL_PGTOS_APPXLOJA.HTML_ANO := GRZW_REL_PGTOS_APPXLOJA.ANO;
             GRZW_REL_PGTOS_APPXLOJA.HTML_ANOMES := GRZW_REL_PGTOS_APPXLOJA.ANOMES;
             GRZW_REL_PGTOS_APPXLOJA.HTML_DTA_MES := qryRelatorioVendas.FieldByName('dta_mes').AsString;
             GRZW_REL_PGTOS_APPXLOJA.HTML_TOT_CLI_CADASTRADOS := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOT_CLI_CADASTRADOS,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_TOT_CLI_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_TOT_CLI_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_CRESCIMENTO := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.PERC_CRESCIMENTO,ffNumber,8,1);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_NEW_CLI_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_NEW_CLI_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_CLI_GRAZZIOTIN := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_CLI_GRAZZIOTIN,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_NEW_CLI_APP_APROV := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_NEW_CLI_APP_APROV,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_CLI_NOVOS_PENDENTES := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_CLI_NOVOS_PENDENTES,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PARCELAS_ARECEBER := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_ARECEBER,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PARCELAS_ARECEBER := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_ARECEBER,ffNumber,18,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_TOT_CLI_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOT_CLI_PGTO_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PARCELAS_PGTO_CIA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_CIA,ffNumber,8,0);

             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PARCELAS_PGTO_CIA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_CIA,ffNumber,18,0);
             //GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PARCELAS_PGTO_CIA := FloatToStrF(qryRelatorioVendas.FieldByName('vlr_parcelas_pgto_cia').AsFloat,ffNumber,18,0);

             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PARCELAS_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PARCELAS_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_APP,ffNumber,18,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PARCELAS_PGTO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_DECRE,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PARCELAS_PGTO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_DECRE,ffNumber,18,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PARCELAS_PGTO_0800 := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_0800,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PARCELAS_PGTO_0800 := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_0800,ffNumber,18,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_BOLETO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_BOLETO_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_BOLETO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_BOLETO_APP,ffNumber,18,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_DEBITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_DEBITO_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_DEBITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_APP,ffNumber,18,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_CREDITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_CREDITO_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_CREDITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_CREDITO_APP,ffNumber,18,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_TOT_CLI_PGTO_CIA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOT_CLI_PGTO_CIA,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_BOLETO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_BOLETO_DECRE,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_BOLETO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_BOLETO_DECRE,ffNumber,18,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_CARTAO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_CARTAO_DECRE,ffNumber,8,0); // Campo n�o existe na tabela, ser� criado futuramente....
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_CARTAO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_CARTAO_DECRE,ffNumber,18,0); // Campo n�o existe na tabela, ser� criado futuramente....
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_LOJA,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA,ffNumber,18,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_DEBITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_DEBITO_LOJA,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_DEBITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_LOJA,ffNumber,18,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_CREDITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_CREDITO_LOJA,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_CREDITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_CREDITO_LOJA,ffNumber,18,0);
             // Campos PIX...
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_PIX_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_PIX_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_DECRE,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_PIX_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_LOJA,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_PIX_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_APP,ffNumber,18,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_PIX_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_DECRE,ffNumber,18,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_PIX_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_LOJA,ffNumber,18,0);
              //Auto ATENDIMENTO...
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_A_ATENDIMENTO := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_A_ATENDIMENTO,ffNumber,18,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_A_ATENDIMENTO := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_A_ATENDIMENTO,ffNumber,18,0);

             ggeKPIPagamentos.Progress := 60;
             lblMensagem.Caption := 'Montagem HTML... Ano/M�s: '+GRZW_REL_PGTOS_APPXLOJA.HTML_ANOMES;
             lblMensagem.Update;
             Delay(200);

             //Soma Dos Totais
             dTotalRecebidos:=  qryRelatorioVendas.FieldByName('vlr_parcelas_pgto_cia').AsFloat;
             dSomaTotalRecebidos := dTotalRecebidos + dSomaTotalRecebidos ;
             dTotalDoApp :=qryRelatorioVendas.FieldByName('vlr_parcelas_pgto_app').AsFloat - qryRelatorioVendas.FieldByName('vlr_parcelas_pgto_decre').AsFloat ;
             dSomaTotalDoApp := dTotalDoApp + dSomaTotalDoApp;
             dTotalDecre := qryRelatorioVendas.FieldByName('vlr_parcelas_pgto_decre').AsFloat + qryTotais.FieldByName('vlr_parcelas_pgto_0800').AsFloat;
             dSomaTotalDecre := dTotalDecre + dSomaTotalDecre;
             dTotalLojas :=qryRelatorioVendas.FieldByName('vlr_pgto_loja').AsFloat;
             dSomaTotalLojas:= dTotalLojas +  dSomaTotalLojas;



             // Montagem da linha de valores do HTML...
             sHTMLLinha :=  ' <tr> '+
                            ' <th col style="width:10px" scope="row">'+GRZW_REL_PGTOS_APPXLOJA.HTML_ANOMES+'</th> '+
                            ' <th col style="width:20px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOT_CLI_CADASTRADOS+'</th> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_TOT_CLI_APP+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_CRESCIMENTO+'</td> '+
                            //' <td style="width:50px" >&nbsp;</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_NEW_CLI_APP+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_CLI_GRAZZIOTIN+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_NEW_CLI_APP_APROV+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_CLI_NOVOS_PENDENTES+'</td> '+
                            // Cabecalho PAGAMENTOS R$...
                            // Sub cabe�alho APP....
                            //' <td style="width:50px">&nbsp;</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PARCELAS_ARECEBER+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TICKET_MEDIO_VLR_PARCELAS+'</td> '+
                            //' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_RS_PAGAMENTOS+'</td> '+
                            ' <td style="width:50px">'+FloatToStrF(qryRelatorioVendas.FieldByName('vlr_parcelas_pgto_cia').AsFloat,ffNumber,18,0)+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TICKET_MEDIO_PAGAMENTOS+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_TOTAL_RS_PAGAMENTOS+'</td> '+
                            //' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOT_RS_PGTO_APP+'</td> '+
                            ' <td style="width:50px">'+FloatToStrF(dTotalDoApp ,ffNumber,18,0)+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TICKET_MEDIO_PAG_APP+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_TOT_RS_PGTO_APP+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_RS_PGTO_APP_DEBITO+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_RS_PGTO_APP_CREDITO+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_RS_PGTO_APP_PIX+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_RS_PGTO_APP_BOLETO+'</td> '+
                            // Sub cabe�alho DECRE....
                            //' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOT_RS_PGTO_DECRE+'</td> '+
                            ' <td style="width:50px">'+FloatToStrF(qryRelatorioVendas.FieldByName('vlr_parcelas_pgto_decre').AsFloat + qryTotais.FieldByName('vlr_parcelas_pgto_0800').AsFloat,ffNumber,18,0)+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TICKET_MEDIO_PAG_DECRE+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_TOT_RS_PGTO_DECRE+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_RS_PGTO_DECRE_BOLETO+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_RS_PGTO_DECRE_PIX+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_RS_PGTO_DECRE_CARTAO+'</td> '+
                            // Sub cabe�alho LOJA....
                            //' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOT_RS_PGTO_LOJA+'</td> '+
                            ' <td style="width:50px">'+FloatToStrF(qryRelatorioVendas.FieldByName('vlr_pgto_loja').AsFloat,ffNumber,18,0)+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TICKET_MEDIO_PAG_LOJA+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_TOT_RS_PGTO_LOJA+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_RS_PGTO_LOJA_EFETIVO+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_RS_PGTO_LOJA_DEBITO+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_RS_PGTO_LOJA_PIX+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_PERC_VLR_A_ATENDIMENTO+'</td> '+
                            ' </tr> ';
             sHTMLEMail := sHTMLEMail + sHTMLLinha;

             qryRelatorioVendas.Next;
        end;

        ggeKPIPagamentos.Progress := 80;
        lblMensagem.Caption := 'Formatando TOTAIS...';
        lblMensagem.Update;
        Delay(200);

        // Totais das colunas....
        sHTMLLinha := ' <tfoot> <tr> ' +
                       //' <th colspan="1" bgcolor="#C0C0C0">Total Geral</th> '+
                       ' <th col style="width:10px" bgcolor="Silver">Total Geral</th> '+
                       ' <th style="width:20px" bgcolor="Silver">&nbsp;</th> '+
                       //' <th style="width:50px" bgcolor="#C0C0C0">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TOT_CLI_CADASTRADOS+'</th> '+
                       ' <th style="width:50px" bgcolor="Silver">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_TOT_CLI_APP+'</th> '+
                       ' <th style="width:50px" bgcolor="Silver">&nbsp;</td> '+
                       ' <th style="width:50px" bgcolor="Silver">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_NEW_CLI_APP+'</th> '+
                       ' <th style="width:50px" bgcolor="Silver">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_CLI_GRAZZIOTIN+'</th> '+
                       ' <th style="width:50px" bgcolor="Silver">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_NEW_CLI_APP_APROV+'</th> '+
                       ' <th style="width:50px" bgcolor="Silver">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_CLI_NOVOS_PENDENTES+'</th> '+
                       // Cabe�alho PAGAMENTOS R$ - APP...
                       //' <th style="width:50px" bgcolor="LightGreen">&nbsp;</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PARCELAS_ARECEBER+'</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TICKET_MEDIO_VLR_PARCELAS+'</td> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+FloatToStrF(dSomaTotalRecebidos,ffNumber,18,0)+'</td> '+
                       //' <th style="width:50px" bgcolor="LightGreen">'+FloatToStrF(qryTotais.FieldByName('vlr_parcelas_pgto_app').AsFloat - qryTotais.FieldByName('vlr_parcelas_pgto_decre').AsFloat,ffNumber,18,0)+'</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TICKET_MEDIO_PAGAMENTOS+'</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_TOTAL_RS_PAGAMENTOS+'</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+FloatToStrF(dSomaTotalDoApp,ffNumber,19,0)+'</td> '+
                       //' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TOT_RS_PGTO_APP+'</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TICKET_MEDIO_PAG_APP+'</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_TOT_RS_PGTO_APP+'</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_RS_PGTO_APP_DEBITO+'</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_RS_PGTO_APP_CREDITO+'</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_RS_PGTO_APP_PIX+'</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_RS_PGTO_APP_BOLETO+'</th> '+
                       // Cabe�alho PAGAMENTOS R$ - DECRE...
                       //' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TOT_RS_PGTO_DECRE+'</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+FloatToStrF(dSomaTotalDecre,ffNumber,19,0)+'</td> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TICKET_MEDIO_PAG_DECRE+'</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_TOT_RS_PGTO_DECRE+'</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_RS_PGTO_DECRE_BOLETO+'</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_RS_PGTO_DECRE_PIX+'</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_RS_PGTO_DECRE_CARTAO+'</th> '+
                       // Cabe�alho PAGAMENTOS R$ - LOJA...
                       //' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TOT_RS_PGTO_LOJA+'</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+FloatToStrF(dSomaTotalLojas,ffNumber,19,0)+'</td> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TICKET_MEDIO_PAG_LOJA+'</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_TOT_RS_PGTO_LOJA+'</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_RS_PGTO_LOJA_EFETIVO+'</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_RS_PGTO_LOJA_DEBITO+'</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_RS_PGTO_LOJA_PIX+'</th> '+
                       ' <th style="width:50px" bgcolor="LightGreen">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_PERC_VLR_A_ATENDIMENTO+'</th> '+
                       ' </tr></tfoot> ';

        sHTMLEMail := sHTMLEMail + sHTMLLinha;
        sHTMLEMail := sHTMLEMail + ' </tbody> </table> </body> </html> ';

        ggeKPIPagamentos.Progress := 100;
        lblMensagem.Caption := 'Finalizando montagem HTML....';
        lblMensagem.Update;
        Delay(200);
     except
           Informacao('Erro! Poss�vel erro na montagem do E_MAIL!!!!','Aviso...');
     end;
 end;

procedure TfrmPrincipal.FormActivate(Sender: TObject);
begin
     Le_Configuracao_Email(Sender);
     Seleciona_Valores(Sender);

     Log('Vai para montagem do HTML...');
     Monta_HTML(Sender);
     Log('Vai para enviar e-mail...');
     Envia_Email(Sender);
     Close;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
     PreencheEstilos(Sender);
     try
        fdcOracle.Connected := True;
     except
           on E:EDatabaseError do
           begin
                Informacao('Falha ao conectar o banco....'+#13+
                           'A aplica��o vai fechar!',
                           'Aviso...');
               Application.Terminate;
           end;
     end;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
var
sDiaAtual,sMesAtual,sUltimoDiaMesAnterior,sMesAnterior : string;
begin
     dSomaTotalRecebidos := 0;
     dTotalRecebidos := 0;
     dSomaTotalDoApp := 0;
     dTotalDoApp := 0;
     dSomaTotalDecre := 0;
     dTotalDecre := 0;
     dSomaTotalLojas := 0;
     dTotalLojas := 0;

     sDiretorioAtual := ExtractFilePath(Application.ExeName);

     // Gera intervalo de datas...
     sDataAtual := DateToStr(Date);
     sDiaAtual := Copy(sDataAtual,0,2) ;
     sMesAtual := Copy(sDataAtual,4,2);
     sAnoAtual := Copy(sDataAtual,7,4);
     // Gera as datas do intervalo. Gera o primeiro dia do m�s corrente at�
     // o dia atual (dia de execu��o da rotina)...
     // Obs.: Execu��o semanal, toda segunda-feira, para envio semanal, por
     //       e-mail, do relat�rio de pagamentos

     sDataInicio := '01/'+Copy(sDataAtual,4,7);
     //sDataInicio := DateToStr(IncDay(StrToDate(sDataAtual), -1));
     sDataFinal := sDataAtual;
     sDataInicioAno := '01/01/'+Copy(sDataAtual,7,4);
     sDataInicioAno := DateToStr(IncMonth(StrToDate(sDataInicioAno),-12));

     case StrToInt(sMesAtual) of
         1 :begin
             sUltimoDiaMesAnterior := '31';
             sMesAnterior  := '12';
         end;
           2:begin
             sUltimoDiaMesAnterior := '31';
             sMesAnterior  := '01';
           end;
              3:begin
               sUltimoDiaMesAnterior := '28';
               sMesAnterior  := '02';
             end;
                 4:begin
                   sUltimoDiaMesAnterior := '31';
                   sMesAnterior  := '03';
                 end;
                   5:begin
                     sUltimoDiaMesAnterior := '30';
                     sMesAnterior  := '04';
                   end;
                     6:begin
                       sUltimoDiaMesAnterior := '31';
                       sMesAnterior  := '05';
                     end;
                       7:begin
                         sUltimoDiaMesAnterior := '30';
                         sMesAnterior  := '06';
                       end;
                         8:begin
                           sUltimoDiaMesAnterior := '31';
                           sMesAnterior  := '07';
                         end;
                           9:begin
                             sUltimoDiaMesAnterior := '31';
                             sMesAnterior  := '08';
                           end;
                             10:begin
                               sUltimoDiaMesAnterior := '31';
                               sMesAnterior  := '09';
                             end;
                               11:begin
                                 sUltimoDiaMesAnterior := '31';
                                 sMesAnterior  := '10';
                               end;
                                 12:begin
                                   sUltimoDiaMesAnterior := '30';
                                   sMesAnterior  := '11';
                                 end;
     end;

     if  StrToInt(sDiaAtual) <= 05 then
       begin
         //sDataFinal  := sUltimoDiaMesAnterior+'/'+sMesAnterior+'/'+Copy(sDataAtual,7,4);
         sDataInicio := '01'+'/'+sMesAnterior+'/'+Copy(sDataAtual,7,4);
         sDataFinal  := sDiaAtual+'/'+sMesAtual+'/'+Copy(sDataAtual,7,4);
       end;
    if (StrToInt(sDiaAtual) <= 05) and (sMesAtual = '01') then
       begin
         sAnoAtual := IntToStr(StrToInt(sAnoAtual) - 1);
         sDataInicio := '01/12'+'/'+sAnoAtual;
         //sDataFinal  := '31/12'+'/'+sAnoAtual;
         sDataFinal  := '05/01'+'/'+IntToStr(StrToInt(sAnoAtual) + 1);
       end;

     edtInicio.Text := sDataInicio;
     edtFinal.Text := sDataFinal;
end;

procedure TfrmPrincipal.mniSairClick(Sender: TObject);
begin
    Application.Terminate;
    Halt;
end;

end.

