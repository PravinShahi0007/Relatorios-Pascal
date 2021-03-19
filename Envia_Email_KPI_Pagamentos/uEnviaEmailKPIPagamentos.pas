{-------------------------------------------------------------------------------
 Programa..: uEnviaEmailKPIPagamentos
 Empresa...: Grazziotin S/A
 Finalidade: Enviar e-mails automático do relatório de KPI Pagamentos

 Autor   Data     Operação  Descrição
 Antônio MAR/2021 Criação
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
  FireDAC.Comp.Client, ACBrBase, ACBrMail, Vcl.Buttons, IniFiles;

type
    RGRZW_REL_PGTOS_APPXLOJA = record
              // Campos vindos do SQL....
              DTA_MES                 : TDate;
              ANOMES                  : String;
              ANO                     : String;
              TOT_CLI_CADASTRADOS     : Double; //NUMBER(8)     -- TOTAL DE CLIENTES CADASTRADOS (Acumulado)
              QTD_TOT_CLI_APP         : Double; //NUMBER(8),    -- CADASTRADOS NA BASE
              QTD_NEW_CLI_APP         : Double; //NUMBER(8),    -- QUANTIDADE DE NOVOS CADASTROS
              QTD_CLI_GRAZZIOTIN      : Double; //NUMBER(8),    -- JÁ SÃO CLIENTES
              QTD_NEW_CLI_APP_APROV   : Double; //NUMBER(8),    -- NOVOS CLIENTES APROVADOS
              QTD_CLI_NOVOS_PENDENTES : Double; //NUMBER(8),    -- CLIENTES NOVOS PENDENTES
              TOT_CLI_PGTO_CIA        : Double; //NUMBER(18,2), -- TOTAL DE VALORES PAGOS NA CIA
              TOT_CLI_PGTO_APP        : Double; //NUMBER(8),    -- EFETUARAM PAGAMENTO PELO APP
              QTD_PARCELAS_PGTO_CIA   : Double; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS NA CIA
              QTD_PARCELAS_PGTO_APP   : Double; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS PELO APP
              VLR_PARCELAS_PGTO_CIA   : Double; //NUMBER(18,2), -- VALOR DE PARCELAS PAGAS NA CIA
              VLR_PARCELAS_PGTO_APP   : Double; //NUMBER(18,2), -- VALOR DE PARCELAS PAGAS PELO APP
              QTD_PARCELAS_PGTO_DECRE : Double; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS - DECRE
              VLR_PARCELAS_PGTO_DECRE : Double; //NUMBER(18,2), -- VALOR DAS PARCELAS PAGAS - DECRE
              QTD_PARCELAS_PGTO_0800  : Double; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS - 0800
              VLR_PARCELAS_PGTO_0800  : Double; //NUMBER(18,2), -- VALOR DAS PARCELAS PAGAS - 0800
              QTD_PGTO_BOLETO_APP     : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO BOLETO APP
              VLR_PGTO_BOLETO_APP     : Double; //NUMBER(18,2), -- VALOR DE PAGAMENTO BOLETO APP
              QTD_PGTO_DEBITO_APP     : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO DEBITO BOLETO APP
              VLR_PGTO_DEBITO_APP     : Double; //NUMBER(18,2), -- VALOR DE PAGAMENTO DEBITO BOLETO APP
              QTD_PGTO_CREDITO_APP    : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO CREDITO BOLETO APP
              VLR_PGTO_CREDITO_APP    : Double; //NUMBER(18,2), -- VALOR DE PAGAMENTO CREDITO BOLETO APP
              QTD_PGTO_PIX_APP        : Double; //NUMBER(8),
              VLR_PGTO_PIX_APP        : Double; //NUMBER(18,2),
              QTD_PGTO_BOLETO_DECRE   : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO BOLETO DECRE
              VLR_PGTO_BOLETO_DECRE   : Double; //NUMBER(18,2), -- VALOR DE PAGAMENTO CREDITO BOLETO DECRE
              QTD_PGTO_CARTAO_DECRE   : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO COM CARTAO DECRE - Campo não existe na tabela, será criado futuramente
              VLR_PGTO_CARTAO_DECRE   : Double; //NUMBER(18,2), -- VALOR DE PAGAMENTO COM CARTAO DECRE - Campo não existe na tabela, será criado futuramente
              QTD_PGTO_PIX_DECRE      : Double; //NUMBER(8),
              VLR_PGTO_PIX_DECRE      : Double; //NUMBER(18,2),
              QTD_PGTO_LOJA           : Double; //NUMBER(8),
              VLR_PGTO_LOJA           : Double; //NUMBER(18,2),
              QTD_PGTO_DEBITO_LOJA    : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO DEBITO LOJA
              VLR_PGTO_DEBITO_LOJA    : Double; //NUMBER(18,2), -- VALOR PAGAMENTO DEBITO LOJA
              QTD_PGTO_CREDITO_LOJA   : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO CREDITO LOJA
              VLR_PGTO_CREDITO_LOJA   : Double; //NUMBER(18,2), -- VALOR PAGAMENTO CREDITO LOJA
              QTD_PGTO_PIX_LOJA       : Double; //NUMBER(8),
              VLR_PGTO_PIX_LOJA       : Double; //NUMBER(18,2),
              // Campos formatados para montagem e visualização no HTML...
              HTML_DTA_MES                 : String;
              HTML_ANOMES                  : String;
              HTML_ANO                     : String;
              HTML_TOT_CLI_CADASTRADOS     : String; //NUMBER(8)     -- TOTAL DE CLIENTES CADASTRADOS (Acumulado)
              HTML_QTD_TOT_CLI_APP         : String; //NUMBER(8),     -- CADASTRADOS NA BASE
              HTML_QTD_NEW_CLI_APP         : String; //NUMBER(8),    -- QUANTIDADE DE NOVOS CADASTROS
              HTML_QTD_CLI_GRAZZIOTIN      : String; //NUMBER(8),    -- JÁ SÃO CLIENTES
              HTML_QTD_NEW_CLI_APP_APROV   : String; //NUMBER(8),    -- NOVOS CLIENTES APROVADOS
              HTML_QTD_CLI_NOVOS_PENDENTES : String; //NUMBER(8),    -- CLIENTES NOVOS PENDENTES
              HTML_TOT_CLI_PGTO_CIA        : String; //NUMBER(18,2), -- TOTAL DE VALORES PAGOS NA CIA
              HTML_TOT_CLI_PGTO_APP        : String; //NUMBER(8),    -- EFETUARAM PAGAMENTO PELO APP
              HTML_QTD_PARCELAS_PGTO_CIA   : String; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS NA CIA
              HTML_QTD_PARCELAS_PGTO_APP   : String; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS PELO APP
              HTML_VLR_PARCELAS_PGTO_CIA   : String; //NUMBER(18,2), -- VALOR DE PARCELAS PAGAS NA CIA
              HTML_VLR_PARCELAS_PGTO_APP   : String; //NUMBER(18,2), -- VALOR DE PARCELAS PAGAS PELO APP
              HTML_QTD_PARCELAS_PGTO_DECRE : String; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS - DECRE
              HTML_VLR_PARCELAS_PGTO_DECRE : String; //NUMBER(18,2), -- VALOR DAS PARCELAS PAGAS - DECRE
              HTML_QTD_PARCELAS_PGTO_0800  : String; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS - 0800
              HTML_VLR_PARCELAS_PGTO_0800  : String; //NUMBER(18,2), -- VALOR DAS PARCELAS PAGAS - 0800
              HTML_QTD_PGTO_BOLETO_APP     : String; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO BOLETO APP
              HTML_VLR_PGTO_BOLETO_APP     : String; //NUMBER(18,2), -- VALOR DE PAGAMENTO BOLETO APP
              HTML_QTD_PGTO_DEBITO_APP     : String; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO DEBITO BOLETO APP
              HTML_VLR_PGTO_DEBITO_APP     : String; //NUMBER(18,2), -- VALOR DE PAGAMENTO DEBITO BOLETO APP
              HTML_QTD_PGTO_CREDITO_APP    : String; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO CREDITO BOLETO APP
              HTML_VLR_PGTO_CREDITO_APP    : String; //NUMBER(18,2), -- VALOR DE PAGAMENTO CREDITO BOLETO APP
              HTML_QTD_PGTO_PIX_APP        : String; //NUMBER(8),
              HTML_VLR_PGTO_PIX_APP        : String; //NUMBER(18,2),
              HTML_QTD_PGTO_BOLETO_DECRE   : String; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO BOLETO DECRE
              HTML_VLR_PGTO_BOLETO_DECRE   : String; //NUMBER(18,2), -- VALOR DE PAGAMENTO CREDITO BOLETO APP

              HTML_QTD_PGTO_CARTAO_DECRE   : String; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO COM CARTAO DECRE - Campo não existe na tabela, será criado futuramente
              HTML_VLR_PGTO_CARTAO_DECRE   : String; //NUMBER(18,2), -- VALOR DE PAGAMENTO COM CARTAO DECRE - Campo não existe na tabela, será criado futuramente

              HTML_QTD_PGTO_PIX_DECRE      : String; //NUMBER(8),
              HTML_VLR_PGTO_PIX_DECRE      : String; //NUMBER(18,2),
              HTML_QTD_PGTO_LOJA           : String; //NUMBER(8),
              HTML_VLR_PGTO_LOJA           : String; //NUMBER(18,2),
              HTML_QTD_PGTO_DEBITO_LOJA    : String; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO DEBITO LOJA
              HTML_VLR_PGTO_DEBITO_LOJA    : String; //NUMBER(18,2), -- VALOR PAGAMENTO DEBITO LOJA
              HTML_QTD_PGTO_CREDITO_LOJA   : String; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO CREDITO LOJA
              HTML_VLR_PGTO_CREDITO_LOJA   : String; //NUMBER(18,2), -- VALOR PAGAMENTO CREDITO LOJA
              HTML_QTD_PGTO_PIX_LOJA       : String; //NUMBER(8),
              HTML_VLR_PGTO_PIX_LOJA       : String; //NUMBER(18,2),
              // Totais dos valores...
              TOTAL_TOT_CLI_CADASTRADOS     : Double; //NUMBER(8)     -- TOTAL DE CLIENTES CADASTRADOS (Acumulado)
              TOTAL_QTD_TOT_CLI_APP         : Double; //NUMBER(8),    -- CADASTRADOS NA BASE
              TOTAL_QTD_NEW_CLI_APP         : Double; //NUMBER(8),    -- QUANTIDADE DE NOVOS CADASTROS
              TOTAL_QTD_CLI_GRAZZIOTIN      : Double; //NUMBER(8),    -- JÁ SÃO CLIENTES
              TOTAL_QTD_NEW_CLI_APP_APROV   : Double; //NUMBER(8),    -- NOVOS CLIENTES APROVADOS
              TOTAL_QTD_CLI_NOVOS_PENDENTES : Double; //NUMBER(8),    -- NOVOS CLIENTES APROVADOS
              TOTAL_TOT_CLI_PGTO_CIA        : Double; //NUMBER(18,2), -- TOTAL DE VALORES PAGOS NA CIA
              TOTAL_TOT_CLI_PGTO_APP        : Double; //NUMBER(8),    -- EFETUARAM PAGAMENTO PELO APP
              TOTAL_QTD_PARCELAS_PGTO_CIA   : Double; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS NA CIA
              TOTAL_QTD_PARCELAS_PGTO_APP   : Double; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS PELO APP
              TOTAL_VLR_PARCELAS_PGTO_CIA   : Double; //NUMBER(18,2), -- VALOR DE PARCELAS PAGAS NA CIA
              TOTAL_VLR_PARCELAS_PGTO_APP   : Double; //NUMBER(18,2), -- VALOR DE PARCELAS PAGAS PELO APP
              TOTAL_QTD_PARCELAS_PGTO_DECRE : Double; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS - DECRE
              TOTAL_VLR_PARCELAS_PGTO_DECRE : Double; //NUMBER(18,2), -- VALOR DAS PARCELAS PAGAS - DECRE
              TOTAL_QTD_PARCELAS_PGTO_0800  : Double; //NUMBER(8),    -- QUANTIDADE DE PARCELAS PAGAS - 0800
              TOTAL_VLR_PARCELAS_PGTO_0800  : Double; //NUMBER(18,2), -- VALOR DAS PARCELAS PAGAS - 0800
              TOTAL_QTD_PGTO_BOLETO_APP     : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO BOLETO APP
              TOTAL_VLR_PGTO_BOLETO_APP     : Double; //NUMBER(18,2), -- VALOR DE PAGAMENTO BOLETO APP
              TOTAL_QTD_PGTO_DEBITO_APP     : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO DEBITO BOLETO APP
              TOTAL_VLR_PGTO_DEBITO_APP     : Double; //NUMBER(18,2), -- VALOR DE PAGAMENTO DEBITO BOLETO APP
              TOTAL_QTD_PGTO_CREDITO_APP    : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO CREDITO BOLETO APP
              TOTAL_VLR_PGTO_CREDITO_APP    : Double; //NUMBER(18,2), -- VALOR DE PAGAMENTO CREDITO BOLETO APP
              TOTAL_QTD_PGTO_PIX_APP        : Double; //NUMBER(8),
              TOTAL_VLR_PGTO_PIX_APP        : Double; //NUMBER(18,2),
              TOTAL_QTD_PGTO_BOLETO_DECRE   : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO BOLETO DECRE
              TOTAL_VLR_PGTO_BOLETO_DECRE   : Double; //NUMBER(18,2), -- VALOR DE PAGAMENTO CREDITO BOLETO APP

              TOTAL_QTD_PGTO_CARTAO_DECRE   : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO COM CARTAO DECRE - Campo não existe na tabela, será criado futuramente
              TOTAL_VLR_PGTO_CARTAO_DECRE   : Double; //NUMBER(18,2), -- VALOR DE PAGAMENTO COM CARTAO DECRE - Campo não existe na tabela, será criado futuramente

              TOTAL_QTD_PGTO_PIX_DECRE      : Double; //NUMBER(8),
              TOTAL_VLR_PGTO_PIX_DECRE      : Double; //NUMBER(18,2),
              TOTAL_QTD_PGTO_LOJA           : Double; //NUMBER(8),
              TOTAL_VLR_PGTO_LOJA           : Double; //NUMBER(18,2),
              TOTAL_QTD_PGTO_DEBITO_LOJA    : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO DEBITO LOJA
              TOTAL_VLR_PGTO_DEBITO_LOJA    : Double; //NUMBER(18,2), -- VALOR PAGAMENTO DEBITO LOJA
              TOTAL_QTD_PGTO_CREDITO_LOJA   : Double; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO CREDITO LOJA
              TOTAL_VLR_PGTO_CREDITO_LOJA   : Double; //NUMBER(18,2), -- VALOR PAGAMENTO CREDITO LOJA
              TOTAL_QTD_PGTO_PIX_LOJA       : Double; //NUMBER(8),
              TOTAL_VLR_PGTO_PIX_LOJA       : Double; //NUMBER(18,2),

              // Campos formatados de TOTAIS para montagem e visualização no HTML...
              HTML_TOTAL_DTA_MES                 : String;
              HTML_TOTAL_ANOMES                  : String;
              HTML_TOTAL_ANO                     : String;
              HTML_TOTAL_TOT_CLI_CADASTRADOS     : String; //NUMBER(8)     -- TOTAL DE CLIENTES CADASTRADOS (Acumulado)
              HTML_TOTAL_QTD_TOT_CLI_APP         : String; //NUMBER(8),     -- CADASTRADOS NA BASE
              HTML_TOTAL_QTD_NEW_CLI_APP         : String; //NUMBER(8),    -- QUANTIDADE DE NOVOS CADASTROS
              HTML_TOTAL_QTD_CLI_GRAZZIOTIN      : String; //NUMBER(8),    -- JÁ SÃO CLIENTES
              HTML_TOTAL_QTD_NEW_CLI_APP_APROV   : String; //NUMBER(8),    -- NOVOS CLIENTES APROVADOS
              HTML_TOTAL_QTD_CLI_NOVOS_PENDENTES : String; //NUMBER(8),    -- NOVOS CLIENTES APROVADOS
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

              HTML_TOTAL_QTD_PGTO_CARTAO_DECRE   : String; //NUMBER(8),    -- QUANTIDADE DE PAGAMENTO COM CARTAO DECRE - Campo não existe na tabela, será criado futuramente
              HTML_TOTAL_VLR_PGTO_CARTAO_DECRE   : String; //NUMBER(18,2), -- VALOR DE PAGAMENTO COM CARTAO DECRE - Campo não existe na tabela, será criado futuramente

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
    BitBtn1: TBitBtn;
    fspGRZ_Rel_Pgto_AppxLoja_SP: TFDStoredProc;
    qryGeralDados: TFDQuery;
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
        sDataAtual, sDataInicio, sDataFinal, sDataInicioAno: String;
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
                  '       vlr_pgto_pix_loja '+
                  'from grzw_rel_pgtos_appxloja '+
                  'where (dta_mes between to_date(:inicial,''dd/mm/yyyy'') and to_date(:final,''dd/mm/yyyy'')) '+
                  'order by dta_mes';
     sSQLTotaisPagamentos = 'select sum(qtd_tot_cli_app) as qtd_tot_cli_app,'+
                  '       sum(tot_cli_cadastrados) as tot_cli_cadastrados,'+
                  '       sum(qtd_new_cli_app) as qtd_new_cli_app,'+
                  '       sum(qtd_cli_grazziotin) as qtd_cli_grazziotin,'+
                  '       sum(qtd_new_cli_app_aprov) as qtd_new_cli_app_aprov,'+
                  '       sum(qtd_cli_novos_pendentes) as qtd_cli_novos_pendentes,'+
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
                  '       sum(vlr_pgto_pix_loja) as vlr_pgto_pix_loja '+
                  'from grzw_rel_pgtos_appxloja '+
                  'where (dta_mes between to_date(:inicial,''dd/mm/yyyy'') and to_date(:final,''dd/mm/yyyy''))';

var
   frmPrincipal: TfrmPrincipal;
   sDiretorioAtual: String;
   ifArquivo: TIniFile;

implementation

{$R *.dfm}

uses Ufuncoes;

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

     Log('Verificando existência de dados...');
     lblMensagem.Caption := 'Verificando existência de dados...';
     lblMensagem.Update;
     Delay(200);

     // Verifica se já existe registro na tabela GRZW_REL_PGTOS_APPXLOJA,
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
     //qryRelatorioVendas.Params.ParamByName('inicial').AsString := edtInicio.Text;
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
     Log('Lê dados do .INI..');
     try
        // Leitura do .INI...
        ifArquivo := TIniFile.Create(sDiretorioAtual+'\KPIPagamentos.ini');
        EMAIL.ENDERECO := ifArquivo.ReadString('EMAIL','ENDERECO','Não encontrado');
        EMAIL.NOME := ifArquivo.ReadString('EMAIL','NOME','Não encontrado');
        EMAIL.HOST := ifArquivo.ReadString('EMAIL','HOST','Não encontrado');
        EMAIL.PORTA := ifArquivo.ReadString('EMAIL','PORTA','Não encontrado');
        EMAIL.USUARIO := ifArquivo.ReadString('EMAIL','USUARIO','Não encontrado');
        EMAIL.SENHA := ifArquivo.ReadString('EMAIL','SENHA','Não encontrado');
        EMAIL.ASSUNTO := ifArquivo.ReadString('EMAIL','ASSUNTO','Não encontrado');
        EMAIL.DESTINATARIO := ifArquivo.ReadString('EMAIL','DESTINATARIO','Não encontrado');
        EMAIL.COPIAOCULTA := ifArquivo.ReadString('EMAIL','COPIAOCULTA','Não encontrado');
        ifArquivo.Free;
     except
           Informacao('Erro: Não carregou arquivo de configuração.'+#13+
                      'Verifique!!!!'+#13+
                      sDiretorioAtual+'\KPIPagamentos.ini','Aviso...');
           Log('Erro: Não carregou arquivo de configuração.'+sDiretorioAtual+'\KPIPagamentos.ini');
           Application.Terminate;
           Exit;
     end;
end;

procedure TfrmPrincipal.Envia_Email(Sender: TObject);
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
     //acbrEMail.AddCC(EMAIL.COPIAOCULTA); // E-mail em copia...
     acbrEMail.AddBCC(EMAIL.COPIAOCULTA); // E-mail em copia...
     acbrEMail.Body.Add(EMAIL.CORPO);
     acbrEMail.IsHTML := True;
     acbrEMail.SetTLS := True;
     acbrEMail.Send;

     lblMensagem.Caption := 'E-mail enviado...';
     lblMensagem.Update;
     Delay(400);
end;

procedure TfrmPrincipal.Monta_HTML(Sender: TObject);
var
   tsArquivoHTML: TStringList;
begin
     frmPrincipal.Update;

     // Transfere valores do SQL de Totais para estrutura em memória....
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_TOT_CLI_APP := qryTotais.FieldByName('qtd_tot_cli_app').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_CLI_CADASTRADOS := qryTotais.FieldByName('tot_cli_cadastrados').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_NEW_CLI_APP := qryTotais.FieldByName('qtd_new_cli_app').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_CLI_GRAZZIOTIN := qryTotais.FieldByName('qtd_cli_grazziotin').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_NEW_CLI_APP_APROV := qryTotais.FieldByName('qtd_new_cli_app_aprov').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_CLI_NOVOS_PENDENTES := qryTotais.FieldByName('qtd_cli_novos_pendentes').AsFloat;
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

     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_CARTAO_DECRE := 0; // QUANTIDADE DE PAGAMENTO COM CARTAO DECRE - Campo não existe na tabela, será criado futuramente
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_CARTAO_DECRE := 0; // VALOR DE PAGAMENTO COM CARTAO DECRE - Campo não existe na tabela, será criado futuramente

     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_BOLETO_DECRE := qryTotais.FieldByName('vlr_pgto_boleto_decre').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_LOJA := qryTotais.FieldByName('qtd_pgto_loja').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_LOJA := qryTotais.FieldByName('vlr_pgto_loja').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_DEBITO_LOJA := qryTotais.FieldByName('qtd_pgto_debito_loja').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_DEBITO_LOJA := qryTotais.FieldByName('vlr_pgto_debito_loja').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_CREDITO_LOJA := qryTotais.FieldByName('qtd_pgto_credito_loja').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_CREDITO_LOJA := qryTotais.FieldByName('vlr_pgto_credito_loja').AsFloat;
     // Soma os valores de parcelas 0800, nos valores dos boletos DECRE...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_BOLETO_DECRE := GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_BOLETO_DECRE +
                                                            GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_PGTO_0800;
     // Soma as quantidades de parcelas 0800, nos valores dos boletos DECRE...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_BOLETO_DECRE := GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_BOLETO_DECRE +
                                                            GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_PGTO_0800;

     // Na área Pagamentros R$ - Loja, diminui o debito (GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_LOJA)
     // do Efetivo (GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA)...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_LOJA := GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_LOJA -
                                                    GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_DEBITO_LOJA;
     // Na área Nº Pagamentos - Loja, diminui o debito  (GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_DEBITO_LOJA)
     // do Efetivo (GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_LOJA)...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_LOJA := GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_LOJA -
                                                    GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_DEBITO_LOJA;

     // Campos PIX...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_PIX_APP := qryTotais.FieldByName('qtd_pgto_pix_app').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_PIX_DECRE := qryTotais.FieldByName('qtd_pgto_pix_decre').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_PIX_LOJA := qryTotais.FieldByName('qtd_pgto_pix_loja').AsFloat;

     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_APP := qryTotais.FieldByName('vlr_pgto_pix_app').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_DECRE := qryTotais.FieldByName('vlr_pgto_pix_decre').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_LOJA := qryTotais.FieldByName('vlr_pgto_pix_loja').AsFloat;

     // Formata os valores dos totais....
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_TOT_CLI_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_TOT_CLI_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TOT_CLI_CADASTRADOS := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_CLI_CADASTRADOS,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_NEW_CLI_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_NEW_CLI_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_CLI_GRAZZIOTIN := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_CLI_GRAZZIOTIN,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_NEW_CLI_APP_APROV := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_NEW_CLI_APP_APROV,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_CLI_NOVOS_PENDENTES := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_CLI_NOVOS_PENDENTES,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TOT_CLI_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_CLI_PGTO_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PARCELAS_PGTO_CIA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_PGTO_CIA,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PARCELAS_PGTO_CIA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_PGTO_CIA,ffNumber,18,2);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PARCELAS_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_PGTO_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PARCELAS_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_PGTO_APP,ffNumber,18,2);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PARCELAS_PGTO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_PGTO_DECRE,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PARCELAS_PGTO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_PGTO_DECRE,ffNumber,18,2);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PARCELAS_PGTO_0800 := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_PGTO_0800,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PARCELAS_PGTO_0800 := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_PGTO_0800,ffNumber,18,2);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_BOLETO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_BOLETO_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_BOLETO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_BOLETO_APP,ffNumber,18,2);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_DEBITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_DEBITO_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_DEBITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_DEBITO_APP,ffNumber,18,2);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_CREDITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_CREDITO_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_CREDITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_CREDITO_APP,ffNumber,18,2);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TOT_CLI_PGTO_CIA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_CLI_PGTO_CIA,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_BOLETO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_BOLETO_DECRE,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_BOLETO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_BOLETO_DECRE,ffNumber,18,2);

     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_CARTAO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_CARTAO_DECRE,ffNumber,8,0); // QUANTIDADE DE PAGAMENTO COM CARTAO DECRE - Campo não existe na tabela, será criado futuramente
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_CARTAO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_CARTAO_DECRE,ffNumber,18,2); // VALOR DE PAGAMENTO COM CARTAO DECRE - Campo não existe na tabela, será criado futuramente

     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_LOJA,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_LOJA,ffNumber,18,2);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_DEBITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_DEBITO_LOJA,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_DEBITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_DEBITO_LOJA,ffNumber,18,2);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_CREDITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_CREDITO_LOJA,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_CREDITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_CREDITO_LOJA,ffNumber,18,2);
     // Campos PIX....
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_PIX_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_PIX_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_PIX_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_PIX_DECRE,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_PIX_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_PIX_LOJA,ffNumber,8,0);

     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_PIX_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_APP,ffNumber,18,2);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_PIX_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_DECRE,ffNumber,18,2);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_PIX_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_LOJA,ffNumber,18,2);

     sHTMLEMail := ''; sHTMLLinha := '';
     ggeKPIPagamentos.Progress := 1;
     lblMensagem.Caption := 'Iniciando montagem HTML...';
     lblMensagem.Update;
     Delay(200);
     try
        lblMensagem.Caption := 'Cabeçalhos e CSS .... ';
        lblMensagem.Update;
        Delay(200);

        // Montagem do HTML enviado por e-mail...
        sHTMLEMail := ' <!DOCTYPE html>'+
                      ' <html lang="en" >'+

                      ' <head>'+
                      ' <meta charset="UTF-8">'+
                      ' <style> '+
                      '    table, th, td {'+
                      '    border: 1px solid black;'+
                      '    padding: 0px;'+
                      '    border-spacing: 0px;'+
                      '    text-align: center;}'+
                      ' </style> '+

                      ' </head> '+
                      ' <body> '+
                      ' <table> '+
                      ' <thead> '+
                      ' <h3>Relatório KPI Pagamentos</h3> '+
                      ' <p>Período: '+edtInicio.Text+' a '+edtFinal.Text+'</p> '+
                      ' <tr>'+
                      ' <th style="width:50px" rowspan="3" bgcolor="#C0C0C0">Mês/Ano</th> '+
                      ' <th style="width:50px" colspan="6" bgcolor="#C0C0C0">Clientes APP</th> '+
                      ' <th colspan="10" bgcolor="#F4A460">Nº Pagamentos</th> '+
                      ' <th colspan="10" bgcolor="#90EE90">Pagamentos R$</th> '+
                      ' </tr>'+
                      ' <tr> '+
                      ' <th style="width:50px" rowspan="2" bgcolor="#C0C0C0">Acumulado</th> '+
                      ' <th style="width:50px" rowspan="2" bgcolor="#C0C0C0">Cadastrados</th> '+
                      ' <th style="width:50px" rowspan="2" bgcolor="#C0C0C0">Novos</th> '+
                      ' <th style="width:50px" rowspan="2" bgcolor="#C0C0C0">Grazziotin</th> '+
                      ' <th style="width:50px" rowspan="2" bgcolor="#C0C0C0">Aprovados</th> '+
                      ' <th style="width:50px" rowspan="2" bgcolor="#C0C0C0">Pendentes</th> '+
                      // Cabeçalho - PAGAMENTOS...
                      ' <th style="width:50px" colspan="4" bgcolor="#F4A460">App</th> '+
                      ' <th style="width:50px" colspan="3" bgcolor="#F4A460">Decre</th> '+
                      ' <th style="width:50px" colspan="3" bgcolor="#F4A460">Loja</th> '+
                      // Cabeçalho - PAGAMENTOS R$...
                      ' <th style="width:50px" colspan="4" bgcolor="#90EE90">App</th> '+
                      ' <th style="width:50px" colspan="3" bgcolor="#90EE90">Decre</th> '+
                      ' <th style="width:50px" colspan="3" bgcolor="#90EE90">Loja</th> '+
                      ' </tr> '+
                      // Cabeçalho PAGAMENTOS....
                      ' <tr> '+
                      // Sub cabeçalho APP
                      ' <th style="width:50px" bgcolor="#F4A460">Débito</th> '+
                      ' <th style="width:50px" bgcolor="#F4A460">Crédito</th> '+
                      ' <th style="width:50px" bgcolor="#F4A460">PIX</th> '+
                      ' <th style="width:50px" bgcolor="#F4A460">Boleto</th> '+
                      // Sub cabeçalho DECRE
                      ' <th style="width:50px" bgcolor="#F4A460">Boleto</th> '+
                      ' <th style="width:50px" bgcolor="#F4A460">PIX</th> '+
                      ' <th style="width:50px" bgcolor="#F4A460">Cartão</th> '+
                      // Sub cabeçalho LOJA
                      ' <th style="width:50px" bgcolor="#F4A460">Efetivo</th> '+
                      ' <th style="width:50px" bgcolor="#F4A460">Débito</th> '+
                      ' <th style="width:50px" bgcolor="#F4A460">PIX</th> '+
                      // Cabeçalho PAGAMENTOS R$....
                      // Sub cabeçalho - APP...
                      ' <th style="width:50px" bgcolor="#90EE90">Débito</th> '+
                      ' <th style="width:50px" bgcolor="#90EE90">Crédito</th> '+
                      ' <th style="width:50px" bgcolor="#90EE90">PIX</th> '+
                      ' <th style="width:50px" bgcolor="#90EE90">Boleto</th> '+
                      // Sub cabeçalho DECRE
                      ' <th style="width:50px" bgcolor="#90EE90">Boleto</th> '+
                      ' <th style="width:50px" bgcolor="#90EE90">PIX</th> '+
                      ' <th style="width:50px" bgcolor="#90EE90">Cartão</th> '+
                      // Sub cabeçalho LOJA
                      ' <th style="width:50px" bgcolor="#90EE90">Efetivo</th> '+
                      ' <th style="width:50px" bgcolor="#90EE90">Débito</th> '+
                      ' <th style="width:50px" bgcolor="#90EE90">PIX</th> '+

                      ' </tr> '+
                      ' </thead> '+
                      ' <tbody> ';

        ggeKPIPagamentos.Progress := 30;
        lblMensagem.Caption := 'Lendo dados das tabelas...';
        lblMensagem.Update;
        Delay(200);

        // Lê o SQL e transfere para a estrutura em memória e formata os valores...
        qryRelatorioVendas.First;
        while not qryRelatorioVendas.Eof do
        begin
             // Dados do SQL...
             GRZW_REL_PGTOS_APPXLOJA.DTA_MES :=  qryRelatorioVendas.FieldByName('dta_mes').AsDateTime; // qryRelatorioVendasDTA_MES.AsDateTime;
             GRZW_REL_PGTOS_APPXLOJA.ANOMES := Copy(DateToStr(GRZW_REL_PGTOS_APPXLOJA.DTA_MES),4,7);
             GRZW_REL_PGTOS_APPXLOJA.ANO := Copy(DateToStr(GRZW_REL_PGTOS_APPXLOJA.DTA_MES),7,4);
             GRZW_REL_PGTOS_APPXLOJA.TOT_CLI_CADASTRADOS := qryRelatorioVendas.FieldByName('tot_cli_cadastrados').AsFloat; //qryRelatorioVendasTOT_CLI_CADASTRADOS.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_TOT_CLI_APP := qryRelatorioVendas.FieldByName('qtd_tot_cli_app').AsFloat; //qryRelatorioVendasQTD_TOT_CLI_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_NEW_CLI_APP := qryRelatorioVendas.FieldByName('qtd_new_cli_app').AsFloat; //qryRelatorioVendasQTD_NEW_CLI_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_CLI_GRAZZIOTIN := qryRelatorioVendas.FieldByName('qtd_cli_grazziotin').AsFloat; //qryRelatorioVendasQTD_CLI_GRAZZIOTIN.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_NEW_CLI_APP_APROV := qryRelatorioVendas.FieldByName('qtd_new_cli_app_aprov').AsFloat; //qryRelatorioVendasQTD_NEW_CLI_APP_APROV.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_CLI_NOVOS_PENDENTES := qryRelatorioVendas.FieldByName('qtd_cli_novos_pendentes').AsFloat; //qryRelatorioVendasQTD_CLI_NOVOS_PENDENTES.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.TOT_CLI_PGTO_APP := qryRelatorioVendas.FieldByName('tot_cli_pgto_app').AsFloat; //qryRelatorioVendasTOT_CLI_PGTO_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_CIA := qryRelatorioVendas.FieldByName('qtd_parcelas_pgto_cia').AsFloat; //qryRelatorioVendasQTD_PARCELAS_PGTO_CIA.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_CIA := qryRelatorioVendas.FieldByName('vlr_parcelas_pgto_cia').AsFloat; //qryRelatorioVendasVLR_PARCELAS_PGTO_CIA.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_APP := qryRelatorioVendas.FieldByName('qtd_parcelas_pgto_app').AsFloat; //qryRelatorioVendasQTD_PARCELAS_PGTO_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_APP := qryRelatorioVendas.FieldByName('vlr_parcelas_pgto_app').AsFloat; //qryRelatorioVendasVLR_PARCELAS_PGTO_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_DECRE := qryRelatorioVendas.FieldByName('qtd_parcelas_pgto_decre').AsFloat; //qryRelatorioVendasQTD_PARCELAS_PGTO_DECRE.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_DECRE := qryRelatorioVendas.FieldByName('vlr_parcelas_pgto_decre').AsFloat; //qryRelatorioVendasVLR_PARCELAS_PGTO_DECRE.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_0800 := qryRelatorioVendas.FieldByName('qtd_parcelas_pgto_0800').AsFloat; //qryRelatorioVendasQTD_PARCELAS_PGTO_0800.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_0800 := qryRelatorioVendas.FieldByName('vlr_parcelas_pgto_0800').AsFloat; //qryRelatorioVendasVLR_PARCELAS_PGTO_0800.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_BOLETO_APP := qryRelatorioVendas.FieldByName('qtd_pgto_boleto_app').AsFloat; //qryRelatorioVendasQTD_PGTO_BOLETO_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_BOLETO_APP := qryRelatorioVendas.FieldByName('vlr_pgto_boleto_app').AsFloat; //qryRelatorioVendasVLR_PGTO_BOLETO_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_DEBITO_APP := qryRelatorioVendas.FieldByName('qtd_pgto_debito_app').AsFloat; //qryRelatorioVendasQTD_PGTO_DEBITO_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_APP := qryRelatorioVendas.FieldByName('vlr_pgto_debito_app').AsFloat; //qryRelatorioVendasVLR_PGTO_DEBITO_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_CREDITO_APP := qryRelatorioVendas.FieldByName('qtd_pgto_credito_app').AsFloat; //qryRelatorioVendasQTD_PGTO_CREDITO_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_CREDITO_APP := qryRelatorioVendas.FieldByName('vlr_pgto_credito_app').AsFloat; //qryRelatorioVendasVLR_PGTO_CREDITO_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.TOT_CLI_PGTO_CIA := qryRelatorioVendas.FieldByName('tot_cli_pgto_cia').AsFloat; //qryRelatorioVendasTOT_CLI_PGTO_CIA.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_BOLETO_DECRE := qryRelatorioVendas.FieldByName('qtd_pgto_boleto_decre').AsFloat; //qryRelatorioVendasQTD_PGTO_BOLETO_DECRE.AsFloat;

             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_CARTAO_DECRE := 0; // Campo não existe na tabela, será criado futuramente....
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_CARTAO_DECRE := 0; // Campo não existe na tabela, será criado futuramente....

             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_BOLETO_DECRE := qryRelatorioVendas.FieldByName('vlr_pgto_boleto_decre').AsFloat; //qryRelatorioVendasVLR_PGTO_BOLETO_DECRE.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_LOJA := qryRelatorioVendas.FieldByName('qtd_pgto_loja').AsFloat; //qryRelatorioVendasQTD_PGTO_LOJA.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA := qryRelatorioVendas.FieldByName('vlr_pgto_loja').AsFloat; //qryRelatorioVendasVLR_PGTO_LOJA.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_DEBITO_LOJA := qryRelatorioVendas.FieldByName('qtd_pgto_debito_loja').AsFloat; //qryRelatorioVendasQTD_PGTO_DEBITO_LOJA.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_LOJA := qryRelatorioVendas.FieldByName('vlr_pgto_debito_loja').AsFloat; //qryRelatorioVendasVLR_PGTO_DEBITO_LOJA.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_CREDITO_LOJA := qryRelatorioVendas.FieldByName('qtd_pgto_credito_loja').AsFloat; //qryRelatorioVendasQTD_PGTO_CREDITO_LOJA.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_CREDITO_LOJA := qryRelatorioVendas.FieldByName('vlr_pgto_credito_loja').AsFloat; //qryRelatorioVendasVLR_PGTO_CREDITO_LOJA.AsFloat;
             // Soma os valores de parcelas 0800, nos valores do s boletos DECRE...
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_BOLETO_DECRE := GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_BOLETO_DECRE +
                                                              GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_0800;
             // Soma as quantidades de parcelas 0800, nos valores dos boletos DECRE...
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_BOLETO_DECRE := GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_BOLETO_DECRE +
                                                              GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_0800;

             // Na área Pagamentros R$ - Loja, diminui o debito (GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_LOJA)
             // do Efetivo (GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA)...
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA := GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA -
                                                      GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_LOJA;
             if (GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA < 0) then
                GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA := 0;
             // Na área Nº Pagamentos - Loja, diminui o debito  (GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_DEBITO_LOJA)
             // do Efetivo (GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_LOJA)...
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_LOJA := GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_LOJA -
                                                      GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_DEBITO_LOJA;
             if (GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_LOJA < 0) then
                GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_LOJA := 0;

             // Campos PIX....
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_APP := qryRelatorioVendas.FieldByName('qtd_pgto_pix_app').AsFloat; //qryRelatorioVendasQTD_PGTO_PIX_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_DECRE := qryRelatorioVendas.FieldByName('qtd_pgto_pix_decre').AsFloat; //qryRelatorioVendasQTD_PGTO_PIX_DECRE.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_LOJA := qryRelatorioVendas.FieldByName('qtd_pgto_pix_loja').AsFloat; //qryRelatorioVendasQTD_PGTO_PIX_LOJA.AsFloat;

             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_APP := qryRelatorioVendas.FieldByName('vlr_pgto_pix_app').AsFloat; //qryRelatorioVendasVLR_PGTO_PIX_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_DECRE := qryRelatorioVendas.FieldByName('vlr_pgto_pix_decre').AsFloat; //qryRelatorioVendasVLR_PGTO_PIX_DECRE.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_LOJA := qryRelatorioVendas.FieldByName('vlr_pgto_pix_loja').AsFloat; //qryRelatorioVendasVLR_PGTO_PIX_LOJA.AsFloat;

             // Dados formatados para o HTML...
             GRZW_REL_PGTOS_APPXLOJA.HTML_ANO := GRZW_REL_PGTOS_APPXLOJA.ANO; //qryRelatorioVendas.FieldByName('ano').AsString; //qryRelatorioVendasANO.AsString;
             GRZW_REL_PGTOS_APPXLOJA.HTML_ANOMES := GRZW_REL_PGTOS_APPXLOJA.ANOMES; //PadLeft(qryRelatorioVendas.FieldByName('anomes').AsString,7,'0'); //PadLeft(qryRelatorioVendasANOMES.AsString,7,'0');
             GRZW_REL_PGTOS_APPXLOJA.HTML_DTA_MES := qryRelatorioVendas.FieldByName('dta_mes').AsString; //qryRelatorioVendasDTA_MES.AsString;
             GRZW_REL_PGTOS_APPXLOJA.HTML_TOT_CLI_CADASTRADOS := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOT_CLI_CADASTRADOS,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_TOT_CLI_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_TOT_CLI_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_NEW_CLI_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_NEW_CLI_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_CLI_GRAZZIOTIN := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_CLI_GRAZZIOTIN,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_NEW_CLI_APP_APROV := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_NEW_CLI_APP_APROV,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_CLI_NOVOS_PENDENTES := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_CLI_NOVOS_PENDENTES,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_TOT_CLI_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOT_CLI_PGTO_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PARCELAS_PGTO_CIA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_CIA,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PARCELAS_PGTO_CIA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_CIA,ffNumber,18,2);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PARCELAS_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PARCELAS_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_APP,ffNumber,18,2);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PARCELAS_PGTO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_DECRE,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PARCELAS_PGTO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_DECRE,ffNumber,18,2);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PARCELAS_PGTO_0800 := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_0800,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PARCELAS_PGTO_0800 := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_0800,ffNumber,18,2);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_BOLETO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_BOLETO_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_BOLETO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_BOLETO_APP,ffNumber,18,2);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_DEBITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_DEBITO_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_DEBITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_APP,ffNumber,18,2);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_CREDITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_CREDITO_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_CREDITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_CREDITO_APP,ffNumber,18,2);
             GRZW_REL_PGTOS_APPXLOJA.HTML_TOT_CLI_PGTO_CIA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOT_CLI_PGTO_CIA,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_BOLETO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_BOLETO_DECRE,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_BOLETO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_BOLETO_DECRE,ffNumber,18,2);

             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_CARTAO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_CARTAO_DECRE,ffNumber,8,0); // Campo não existe na tabela, será criado futuramente....
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_CARTAO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_CARTAO_DECRE,ffNumber,18,2); // Campo não existe na tabela, será criado futuramente....

             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_LOJA,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA,ffNumber,18,2);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_DEBITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_DEBITO_LOJA,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_DEBITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_LOJA,ffNumber,18,2);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_CREDITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_CREDITO_LOJA,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_CREDITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_CREDITO_LOJA,ffNumber,18,2);
             // Campos PIX...
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_PIX_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_PIX_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_DECRE,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_PIX_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_LOJA,ffNumber,8,0);

             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_PIX_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_APP,ffNumber,18,2);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_PIX_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_DECRE,ffNumber,18,2);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_PIX_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_LOJA,ffNumber,18,2);

             ggeKPIPagamentos.Progress := 60;
             lblMensagem.Caption := 'Montagem HTML... Ano/Mês: '+GRZW_REL_PGTOS_APPXLOJA.HTML_ANOMES;
             lblMensagem.Update;
             Delay(200);

             // Montagem da linha de valores do HTML...
             sHTMLLinha :=  ' <tr> '+
                            ' <th style="width:50px" scope="row">'+GRZW_REL_PGTOS_APPXLOJA.HTML_ANOMES+'</th> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOT_CLI_CADASTRADOS+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_TOT_CLI_APP+'</td> '+
                            //' <td style="width:50px" >&nbsp;</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_NEW_CLI_APP+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_CLI_GRAZZIOTIN+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_NEW_CLI_APP_APROV+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_CLI_NOVOS_PENDENTES+'</td> '+
                            // Cabecalho PAGAMENTOS...
                            // Sub cabeçalho APP....
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_DEBITO_APP+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_CREDITO_APP+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_PIX_APP+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_BOLETO_APP+'</td> '+
                            // Sub cabeçalho DECRE....
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_BOLETO_DECRE+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_PIX_DECRE+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_CARTAO_DECRE+'</td> '+ // Campo Cartão DECRE, agora não existe, foi deixado em branco...
                            // Sub cabeçalho LOJA...
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_LOJA+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_DEBITO_LOJA+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_PIX_LOJA+'</td> '+
                            // Cabecalho PAGAMENTOS R$...
                            // Sub cabeçalho APP....
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_DEBITO_APP+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_CREDITO_APP+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_PIX_APP+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_BOLETO_APP+'</td> '+
                            // Sub cabeçalho DECRE....
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_BOLETO_DECRE+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_PIX_DECRE+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_CARTAO_DECRE+'</td> '+ // Campo Cartão DECRE, agora não existe, foi deixado em branco...
                            // Sub cabeçalho LOJA....
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_LOJA+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_DEBITO_LOJA+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_PIX_LOJA+'</td> '+
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
                       ' <th style="width:50px" bgcolor="#C0C0C0">Total Geral</th> '+

                       ' <th style="width:50px" bgcolor="#C0C0C0">&nbsp;</th> '+
                       //' <th style="width:50px" bgcolor="#C0C0C0">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TOT_CLI_CADASTRADOS+'</th> '+
                       ' <th style="width:50px" bgcolor="#C0C0C0">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_TOT_CLI_APP+'</th> '+
                       ' <th style="width:50px" bgcolor="#C0C0C0">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_NEW_CLI_APP+'</th> '+
                       ' <th style="width:50px" bgcolor="#C0C0C0">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_CLI_GRAZZIOTIN+'</th> '+
                       ' <th style="width:50px" bgcolor="#C0C0C0">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_NEW_CLI_APP_APROV+'</th> '+
                       ' <th style="width:50px" bgcolor="#C0C0C0">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_CLI_NOVOS_PENDENTES+'</th> '+
                       // Cabeçalho PAGAMENTOS - APP...
                       ' <th style="width:50px" bgcolor="#F4A460">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_DEBITO_APP+'</th> '+
                       ' <th style="width:50px" bgcolor="#F4A460">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_CREDITO_APP+'</th> '+
                       ' <th style="width:50px" bgcolor="#F4A460">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_PIX_APP+'</th> '+
                       ' <th style="width:50px" bgcolor="#F4A460">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_BOLETO_APP+'</th> '+
                       // Cabeçalho PAGAMENTOS - DECRE...
                       ' <th style="width:50px" bgcolor="#F4A460">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_BOLETO_DECRE+'</th> '+
                       ' <th style="width:50px" bgcolor="#F4A460">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_PIX_DECRE+'</th> '+
                       ' <th style="width:50px" bgcolor="#F4A460">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_CARTAO_DECRE+'</th> '+ // Campo Cartão DECRE, agora não existe, foi deixado em branco...
                       // Cabeçalho PAGAMENTOS - LOJA...
                       ' <th style="width:50px" bgcolor="#F4A460">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_LOJA+'</th> '+
                       ' <th style="width:50px" bgcolor="#F4A460">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_DEBITO_LOJA+'</th> '+
                       ' <th style="width:50px" bgcolor="#F4A460">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_PIX_LOJA+'</th> '+
                       // Cabeçalho PAGAMENTOS R$ - APP...
                       ' <th style="width:50px" bgcolor="#90EE90">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_DEBITO_APP+'</th> '+
                       ' <th style="width:50px" bgcolor="#90EE90">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_CREDITO_APP+'</th> '+
                       ' <th style="width:50px" bgcolor="#90EE90">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_PIX_APP+'</th> '+
                       ' <th style="width:50px" bgcolor="#90EE90">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_BOLETO_APP+'</th> '+
                       // Cabeçalho PAGAMENTOS R$ - DECRE...
                       ' <th style="width:50px" bgcolor="#90EE90">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_BOLETO_DECRE+'</th> '+
                       ' <th style="width:50px" bgcolor="#90EE90">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_PIX_DECRE+'</th> '+
                       ' <th style="width:50px" bgcolor="#90EE90">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_CARTAO_DECRE+'</th> '+ // Campo Cartão DECRE, agora não existe, foi deixado em branco...
                       // Cabeçalho PAGAMENTOS R$ - LOJA...
                       ' <th style="width:50px" bgcolor="#90EE90">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_LOJA+'</th> '+
                       ' <th style="width:50px" bgcolor="#90EE90">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_DEBITO_LOJA+'</th> '+
                       ' <th style="width:50px" bgcolor="#90EE90">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_PIX_LOJA+'</th> '+
                       ' </tr></tfoot> ';
        sHTMLEMail := sHTMLEMail + sHTMLLinha;

        sHTMLEMail := sHTMLEMail + ' </tbody> </table> </body> </html> ';
        ggeKPIPagamentos.Progress := 100;
        lblMensagem.Caption := 'Finalizando montagem HTML....';
        lblMensagem.Update;
        Delay(200);
     finally
     end;













     (*// Transfere valores do SQL de Totais para estrutura em memória....
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_TOT_CLI_APP := qryTotais.FieldByName('qtd_tot_cli_app').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_CLI_CADASTRADOS := qryTotais.FieldByName('tot_cli_cadastrados').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_NEW_CLI_APP := qryTotais.FieldByName('qtd_new_cli_app').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_CLI_GRAZZIOTIN := qryTotais.FieldByName('qtd_cli_grazziotin').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_NEW_CLI_APP_APROV := qryTotais.FieldByName('qtd_new_cli_app_aprov').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_CLI_NOVOS_PENDENTES := qryTotais.FieldByName('qtd_cli_novos_pendentes').AsFloat;
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
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_BOLETO_DECRE := qryTotais.FieldByName('vlr_pgto_boleto_decre').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_LOJA := qryTotais.FieldByName('qtd_pgto_loja').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_LOJA := qryTotais.FieldByName('vlr_pgto_loja').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_DEBITO_LOJA := qryTotais.FieldByName('qtd_pgto_debito_loja').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_DEBITO_LOJA := qryTotais.FieldByName('vlr_pgto_debito_loja').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_CREDITO_LOJA := qryTotais.FieldByName('qtd_pgto_credito_loja').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_CREDITO_LOJA := qryTotais.FieldByName('vlr_pgto_credito_loja').AsFloat;
     // Soma os valores de parcelas 0800, nos valores do s boletos DECRE...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_BOLETO_DECRE := GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_BOLETO_DECRE +
                                                            GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_PGTO_0800;
     // Soma as quantidades de parcelas 0800, nos valores dos boletos DECRE...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_BOLETO_DECRE := GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_BOLETO_DECRE +
                                                            GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_PGTO_0800;

     // Na área Pagamentros R$ - Loja, diminui o debito (GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_LOJA)
     // do Efetivo (GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA)...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_LOJA := GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_LOJA -
                                                    GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_DEBITO_LOJA;
     // Na área Nº Pagamentos - Loja, diminui o debito  (GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_DEBITO_LOJA)
     // do Efetivo (GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_LOJA)...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_LOJA := GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_LOJA -
                                                    GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_DEBITO_LOJA;

     // Campos PIX...
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_PIX_APP := qryTotais.FieldByName('qtd_pgto_pix_app').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_PIX_DECRE := qryTotais.FieldByName('qtd_pgto_pix_decre').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_PIX_LOJA := qryTotais.FieldByName('qtd_pgto_pix_loja').AsFloat;

     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_APP := qryTotais.FieldByName('vlr_pgto_pix_app').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_DECRE := qryTotais.FieldByName('vlr_pgto_pix_decre').AsFloat;
     GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_LOJA := qryTotais.FieldByName('vlr_pgto_pix_loja').AsFloat;

     // Formata os valores dos totais....
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_TOT_CLI_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_TOT_CLI_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TOT_CLI_CADASTRADOS := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_CLI_CADASTRADOS,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_NEW_CLI_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_NEW_CLI_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_CLI_GRAZZIOTIN := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_CLI_GRAZZIOTIN,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_NEW_CLI_APP_APROV := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_NEW_CLI_APP_APROV,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_CLI_NOVOS_PENDENTES := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_CLI_NOVOS_PENDENTES,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TOT_CLI_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_CLI_PGTO_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PARCELAS_PGTO_CIA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_PGTO_CIA,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PARCELAS_PGTO_CIA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_PGTO_CIA,ffNumber,18,2);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PARCELAS_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_PGTO_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PARCELAS_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_PGTO_APP,ffNumber,18,2);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PARCELAS_PGTO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_PGTO_DECRE,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PARCELAS_PGTO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_PGTO_DECRE,ffNumber,18,2);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PARCELAS_PGTO_0800 := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PARCELAS_PGTO_0800,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PARCELAS_PGTO_0800 := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PARCELAS_PGTO_0800,ffNumber,18,2);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_BOLETO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_BOLETO_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_BOLETO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_BOLETO_APP,ffNumber,18,2);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_DEBITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_DEBITO_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_DEBITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_DEBITO_APP,ffNumber,18,2);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_CREDITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_CREDITO_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_CREDITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_CREDITO_APP,ffNumber,18,2);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TOT_CLI_PGTO_CIA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_TOT_CLI_PGTO_CIA,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_BOLETO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_BOLETO_DECRE,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_BOLETO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_BOLETO_DECRE,ffNumber,18,2);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_LOJA,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_LOJA,ffNumber,18,2);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_DEBITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_DEBITO_LOJA,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_DEBITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_DEBITO_LOJA,ffNumber,18,2);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_CREDITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_CREDITO_LOJA,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_CREDITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_CREDITO_LOJA,ffNumber,18,2);
     // Campos PIX....
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_PIX_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_PIX_APP,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_PIX_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_PIX_DECRE,ffNumber,8,0);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_PIX_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_QTD_PGTO_PIX_LOJA,ffNumber,8,0);

     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_PIX_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_APP,ffNumber,18,2);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_PIX_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_DECRE,ffNumber,18,2);
     GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_PIX_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOTAL_VLR_PGTO_PIX_LOJA,ffNumber,18,2);

     sHTMLEMail := ''; sHTMLLinha := '';
     ggeKPIPagamentos.Progress := 1;
     lblMensagem.Caption := 'Iniciando montagem HTML...';
     lblMensagem.Update;
     Delay(200);
     try
        lblMensagem.Caption := 'Cabeçalhos e CSS .... ';
        lblMensagem.Update;
        Delay(200);

        // Montagem do HTML enviado por e-mail...
        sHTMLEMail := ' <!DOCTYPE html>'+
                      ' <html lang="en" >'+

                      ' <head>'+
                      ' <meta charset="UTF-8">'+
                      ' <style> '+
                      '    table, th, td {'+
                      '    border: 1px solid black;'+
                      '    padding: 0px;'+
                      '    border-spacing: 0px;'+
                      '    text-align: center;}'+
                      ' </style> '+

                      ' </head> '+
                      ' <body> '+
                      ' <table> '+
                      ' <thead> '+
                      ' <h3>Relatório KPI Pagamentos</h3> '+
                      ' <p>Período: '+edtInicio.Text+' a '+edtFinal.Text+'</p> '+
                      ' <tr>'+
                      ' <th style="width:50px" rowspan="3" bgcolor="#C0C0C0">Mês/Ano</th> '+
                      ' <th style="width:50px" colspan="6" bgcolor="#C0C0C0">Clientes APP</th> '+
                      ' <th colspan="10" bgcolor="#F4A460">Nº Pagamentos</th> '+
                      ' <th colspan="10" bgcolor="#90EE90">Pagamentos R$</th> '+
                      ' </tr>'+
                      ' <tr> '+
                      ' <th style="width:50px" rowspan="2" bgcolor="#C0C0C0">Acumulado</th> '+
                      ' <th style="width:50px" rowspan="2" bgcolor="#C0C0C0">Cadastrados</th> '+
                      ' <th style="width:50px" rowspan="2" bgcolor="#C0C0C0">Novos</th> '+
                      ' <th style="width:50px" rowspan="2" bgcolor="#C0C0C0">Grazziotin</th> '+
                      ' <th style="width:50px" rowspan="2" bgcolor="#C0C0C0">Aprovados</th> '+
                      ' <th style="width:50px" rowspan="2" bgcolor="#C0C0C0">Pendentes</th> '+
                      // Cabeçalho - PAGAMENTOS...
                      ' <th style="width:50px" colspan="4" bgcolor="#F4A460">App</th> '+
                      ' <th style="width:50px" colspan="3" bgcolor="#F4A460">Decre</th> '+
                      ' <th style="width:50px" colspan="3" bgcolor="#F4A460">Loja</th> '+
                      // Cabeçalho - PAGAMENTOS R$...
                      ' <th style="width:50px" colspan="4" bgcolor="#90EE90">App</th> '+
                      ' <th style="width:50px" colspan="3" bgcolor="#90EE90">Decre</th> '+
                      ' <th style="width:50px" colspan="3" bgcolor="#90EE90">Loja</th> '+
                      ' </tr> '+
                      // Cabeçalho PAGAMENTOS....
                      ' <tr> '+
                      // Sub cabeçalho APP
                      ' <th style="width:50px" bgcolor="#F4A460">Débito</th> '+
                      ' <th style="width:50px" bgcolor="#F4A460">Crédito</th> '+
                      ' <th style="width:50px" bgcolor="#F4A460">PIX</th> '+
                      ' <th style="width:50px" bgcolor="#F4A460">Boleto</th> '+
                      // Sub cabeçalho DECRE
                      ' <th style="width:50px" bgcolor="#F4A460">Boleto</th> '+
                      ' <th style="width:50px" bgcolor="#F4A460">PIX</th> '+
                      ' <th style="width:50px" bgcolor="#F4A460">Cartão</th> '+
                      // Sub cabeçalho LOJA
                      ' <th style="width:50px" bgcolor="#F4A460">Efetivo</th> '+
                      ' <th style="width:50px" bgcolor="#F4A460">Débito</th> '+
                      ' <th style="width:50px" bgcolor="#F4A460">PIX</th> '+
                      // Cabeçalho PAGAMENTOS R$....
                      // Sub cabeçalho - APP...
                      ' <th style="width:50px" bgcolor="#90EE90">Débito</th> '+
                      ' <th style="width:50px" bgcolor="#90EE90">Crédito</th> '+
                      ' <th style="width:50px" bgcolor="#90EE90">PIX</th> '+
                      ' <th style="width:50px" bgcolor="#90EE90">Boleto</th> '+
                      // Sub cabeçalho DECRE
                      ' <th style="width:50px" bgcolor="#90EE90">Boleto</th> '+
                      ' <th style="width:50px" bgcolor="#90EE90">PIX</th> '+
                      ' <th style="width:50px" bgcolor="#90EE90">Cartão</th> '+
                      // Sub cabeçalho LOJA
                      ' <th style="width:50px" bgcolor="#90EE90">Efetivo</th> '+
                      ' <th style="width:50px" bgcolor="#90EE90">Débito</th> '+
                      ' <th style="width:50px" bgcolor="#90EE90">PIX</th> '+

                      ' </tr> '+
                      ' </thead> '+
                      ' <tbody> ';


        ggeKPIPagamentos.Progress := 30;
        lblMensagem.Caption := 'Lendo dados das tabelas...';
        lblMensagem.Update;
        Delay(200);

        // Lê o SQL e transfere para a estrutura em memória e formata os valores...
        qryRelatorioVendas.First;
        while not qryRelatorioVendas.Eof do
        begin
             // Dados do SQL...
             GRZW_REL_PGTOS_APPXLOJA.DTA_MES := qryRelatorioVendasDTA_MES.AsDateTime;
             GRZW_REL_PGTOS_APPXLOJA.TOT_CLI_CADASTRADOS := qryRelatorioVendasTOT_CLI_CADASTRADOS.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_TOT_CLI_APP := qryRelatorioVendasQTD_TOT_CLI_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_NEW_CLI_APP := qryRelatorioVendasQTD_NEW_CLI_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_CLI_GRAZZIOTIN := qryRelatorioVendasQTD_CLI_GRAZZIOTIN.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_NEW_CLI_APP_APROV := qryRelatorioVendasQTD_NEW_CLI_APP_APROV.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_CLI_NOVOS_PENDENTES := qryRelatorioVendasQTD_CLI_NOVOS_PENDENTES.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.TOT_CLI_PGTO_APP := qryRelatorioVendasTOT_CLI_PGTO_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_CIA := qryRelatorioVendasQTD_PARCELAS_PGTO_CIA.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_CIA := qryRelatorioVendasVLR_PARCELAS_PGTO_CIA.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_APP := qryRelatorioVendasQTD_PARCELAS_PGTO_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_APP := qryRelatorioVendasVLR_PARCELAS_PGTO_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_DECRE := qryRelatorioVendasQTD_PARCELAS_PGTO_DECRE.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_DECRE := qryRelatorioVendasVLR_PARCELAS_PGTO_DECRE.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_0800 := qryRelatorioVendasQTD_PARCELAS_PGTO_0800.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_0800 := qryRelatorioVendasVLR_PARCELAS_PGTO_0800.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_BOLETO_APP := qryRelatorioVendasQTD_PGTO_BOLETO_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_BOLETO_APP := qryRelatorioVendasVLR_PGTO_BOLETO_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_DEBITO_APP := qryRelatorioVendasQTD_PGTO_DEBITO_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_APP := qryRelatorioVendasVLR_PGTO_DEBITO_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_CREDITO_APP := qryRelatorioVendasQTD_PGTO_CREDITO_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_CREDITO_APP := qryRelatorioVendasVLR_PGTO_CREDITO_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.TOT_CLI_PGTO_CIA := qryRelatorioVendasTOT_CLI_PGTO_CIA.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_BOLETO_DECRE := qryRelatorioVendasQTD_PGTO_BOLETO_DECRE.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_BOLETO_DECRE := qryRelatorioVendasVLR_PGTO_BOLETO_DECRE.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_LOJA := qryRelatorioVendasQTD_PGTO_LOJA.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA := qryRelatorioVendasVLR_PGTO_LOJA.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_DEBITO_LOJA := qryRelatorioVendasQTD_PGTO_DEBITO_LOJA.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_LOJA := qryRelatorioVendasVLR_PGTO_DEBITO_LOJA.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_CREDITO_LOJA := qryRelatorioVendasQTD_PGTO_CREDITO_LOJA.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_CREDITO_LOJA := qryRelatorioVendasVLR_PGTO_CREDITO_LOJA.AsFloat;
             // Soma os valores de parcelas 0800, nos valores dos boletos DECRE...
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_BOLETO_DECRE := GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_BOLETO_DECRE +
                                                              GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_0800;
             // Soma as quantidades de parcelas 0800, nos valores dos boletos DECRE...
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_BOLETO_DECRE := GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_BOLETO_DECRE +
                                                              GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_0800;

             // Na área Pagamentros R$ - Loja, diminui o debito (GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_LOJA)
             // do Efetivo (GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA)...
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA := GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA -
                                                      GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_LOJA;
             // Na área Nº Pagamentos - Loja, diminui o debito  (GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_DEBITO_LOJA)
             // do Efetivo (GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_LOJA)...
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_LOJA := GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_LOJA -
                                                      GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_DEBITO_LOJA;

             // Campos PIX....
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_APP := qryRelatorioVendasQTD_PGTO_PIX_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_DECRE := qryRelatorioVendasQTD_PGTO_PIX_DECRE.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_LOJA := qryRelatorioVendasQTD_PGTO_PIX_LOJA.AsFloat;

             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_APP := qryRelatorioVendasVLR_PGTO_PIX_APP.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_DECRE := qryRelatorioVendasVLR_PGTO_PIX_DECRE.AsFloat;
             GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_LOJA := qryRelatorioVendasVLR_PGTO_PIX_LOJA.AsFloat;

             // Dados formatados para o HTML...
             GRZW_REL_PGTOS_APPXLOJA.HTML_ANO := qryRelatorioVendasANO.AsString;
             GRZW_REL_PGTOS_APPXLOJA.HTML_ANOMES := PadLeft(qryRelatorioVendasANOMES.AsString,7,'0');
             GRZW_REL_PGTOS_APPXLOJA.HTML_DTA_MES := qryRelatorioVendasDTA_MES.AsString;
             GRZW_REL_PGTOS_APPXLOJA.HTML_TOT_CLI_CADASTRADOS := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOT_CLI_CADASTRADOS,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_TOT_CLI_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_TOT_CLI_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_NEW_CLI_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_NEW_CLI_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_CLI_GRAZZIOTIN := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_CLI_GRAZZIOTIN,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_NEW_CLI_APP_APROV := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_NEW_CLI_APP_APROV,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_CLI_NOVOS_PENDENTES := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_CLI_NOVOS_PENDENTES,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_TOT_CLI_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOT_CLI_PGTO_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PARCELAS_PGTO_CIA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_CIA,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PARCELAS_PGTO_CIA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_CIA,ffNumber,18,2);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PARCELAS_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PARCELAS_PGTO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_APP,ffNumber,18,2);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PARCELAS_PGTO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_DECRE,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PARCELAS_PGTO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_DECRE,ffNumber,18,2);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PARCELAS_PGTO_0800 := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PARCELAS_PGTO_0800,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PARCELAS_PGTO_0800 := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PARCELAS_PGTO_0800,ffNumber,18,2);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_BOLETO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_BOLETO_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_BOLETO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_BOLETO_APP,ffNumber,18,2);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_DEBITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_DEBITO_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_DEBITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_APP,ffNumber,18,2);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_CREDITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_CREDITO_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_CREDITO_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_CREDITO_APP,ffNumber,18,2);
             GRZW_REL_PGTOS_APPXLOJA.HTML_TOT_CLI_PGTO_CIA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.TOT_CLI_PGTO_CIA,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_BOLETO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_BOLETO_DECRE,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_BOLETO_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_BOLETO_DECRE,ffNumber,18,2);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_LOJA,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_LOJA,ffNumber,18,2);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_DEBITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_DEBITO_LOJA,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_DEBITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_DEBITO_LOJA,ffNumber,18,2);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_CREDITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_CREDITO_LOJA,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_CREDITO_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_CREDITO_LOJA,ffNumber,18,2);
             // Campos PIX...
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_PIX_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_APP,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_PIX_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_DECRE,ffNumber,8,0);
             GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_PIX_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.QTD_PGTO_PIX_LOJA,ffNumber,8,0);

             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_PIX_APP := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_APP,ffNumber,18,2);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_PIX_DECRE := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_DECRE,ffNumber,18,2);
             GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_PIX_LOJA := FloatToStrF(GRZW_REL_PGTOS_APPXLOJA.VLR_PGTO_PIX_LOJA,ffNumber,18,2);

             ggeKPIPagamentos.Progress := 60;
             lblMensagem.Caption := 'Montagem HTML... Ano/Mês: '+GRZW_REL_PGTOS_APPXLOJA.HTML_ANOMES;
             lblMensagem.Update;
             Delay(200);

             // Montagem da linha de valores do HTML...
             sHTMLLinha :=  ' <tr> '+
                            ' <th style="width:50px" scope="row">'+GRZW_REL_PGTOS_APPXLOJA.HTML_ANOMES+'</th> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOT_CLI_CADASTRADOS+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_TOT_CLI_APP+'</td> '+
                            //' <td style="width:50px" >&nbsp;</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_NEW_CLI_APP+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_CLI_GRAZZIOTIN+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_NEW_CLI_APP_APROV+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_CLI_NOVOS_PENDENTES+'</td> '+
                            // Cabecalho PAGAMENTOS...
                            // Sub cabeçalho APP....
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_DEBITO_APP+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_CREDITO_APP+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_PIX_APP+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_BOLETO_APP+'</td> '+
                            // Sub cabeçalho DECRE....
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_BOLETO_DECRE+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_PIX_DECRE+'</td> '+
                            ' <td style="width:50px">'+'0'+'</td> '+ // Campo Cartão DECRE, agora não existe, foi deixado em branco...
                            // Sub cabeçalho LOJA...
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_LOJA+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_DEBITO_LOJA+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_QTD_PGTO_PIX_LOJA+'</td> '+
                            // Cabecalho PAGAMENTOS R$...
                            // Sub cabeçalho APP....
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_DEBITO_APP+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_CREDITO_APP+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_PIX_APP+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_BOLETO_APP+'</td> '+
                            // Sub cabeçalho DECRE....
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_BOLETO_DECRE+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_PIX_DECRE+'</td> '+
                            ' <td style="width:50px">'+'0,00'+'</td> '+ // Campo Cartão DECRE, agora não existe, foi deixado em branco...
                            // Sub cabeçalho LOJA....
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_LOJA+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_DEBITO_LOJA+'</td> '+
                            ' <td style="width:50px">'+GRZW_REL_PGTOS_APPXLOJA.HTML_VLR_PGTO_PIX_LOJA+'</td> '+

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
                       ' <th style="width:50px" bgcolor="#C0C0C0">Total Geral</th> '+

                       ' <th style="width:50px" bgcolor="#C0C0C0">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_TOT_CLI_CADASTRADOS+'</th> '+
                       ' <th style="width:50px" bgcolor="#C0C0C0">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_TOT_CLI_APP+'</th> '+
                       ' <th style="width:50px" bgcolor="#C0C0C0">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_NEW_CLI_APP+'</th> '+
                       ' <th style="width:50px" bgcolor="#C0C0C0">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_CLI_GRAZZIOTIN+'</th> '+
                       ' <th style="width:50px" bgcolor="#C0C0C0">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_NEW_CLI_APP_APROV+'</th> '+
                       ' <th style="width:50px" bgcolor="#C0C0C0">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_CLI_NOVOS_PENDENTES+'</th> '+
                       // Cabeçalho PAGAMENTOS - APP...
                       ' <th style="width:50px" bgcolor="#F4A460">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_DEBITO_APP+'</th> '+
                       ' <th style="width:50px" bgcolor="#F4A460">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_CREDITO_APP+'</th> '+
                       ' <th style="width:50px" bgcolor="#F4A460">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_PIX_APP+'</th> '+
                       ' <th style="width:50px" bgcolor="#F4A460">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_BOLETO_APP+'</th> '+
                       // Cabeçalho PAGAMENTOS - DECRE...
                       ' <th style="width:50px" bgcolor="#F4A460">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_BOLETO_DECRE+'</th> '+
                       ' <th style="width:50px" bgcolor="#F4A460">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_PIX_DECRE+'</th> '+
                       ' <th style="width:50px" bgcolor="#F4A460">'+'0'+'</th> '+ // Campo Cartão DECRE, agora não existe, foi deixado em branco...
                       // Cabeçalho PAGAMENTOS - LOJA...
                       ' <th style="width:50px" bgcolor="#F4A460">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_LOJA+'</th> '+
                       ' <th style="width:50px" bgcolor="#F4A460">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_DEBITO_LOJA+'</th> '+
                       ' <th style="width:50px" bgcolor="#F4A460">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_QTD_PGTO_PIX_LOJA+'</th> '+
                       // Cabeçalho PAGAMENTOS R$ - APP...
                       ' <th style="width:50px" bgcolor="#90EE90">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_DEBITO_APP+'</th> '+
                       ' <th style="width:50px" bgcolor="#90EE90">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_CREDITO_APP+'</th> '+
                       ' <th style="width:50px" bgcolor="#90EE90">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_PIX_APP+'</th> '+
                       ' <th style="width:50px" bgcolor="#90EE90">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_BOLETO_APP+'</th> '+
                       // Cabeçalho PAGAMENTOS R$ - DECRE...
                       ' <th style="width:50px" bgcolor="#90EE90">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_BOLETO_DECRE+'</th> '+
                       ' <th style="width:50px" bgcolor="#90EE90">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_PIX_DECRE+'</th> '+
                       ' <th style="width:50px" bgcolor="#90EE90">'+'0,00'+'</th> '+ // Campo Cartão DECRE, agora não existe, foi deixado em branco...
                       // Cabeçalho PAGAMENTOS R$ - LOJA...
                       ' <th style="width:50px" bgcolor="#90EE90">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_LOJA+'</th> '+
                       ' <th style="width:50px" bgcolor="#90EE90">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_DEBITO_LOJA+'</th> '+
                       ' <th style="width:50px" bgcolor="#90EE90">'+GRZW_REL_PGTOS_APPXLOJA.HTML_TOTAL_VLR_PGTO_PIX_LOJA+'</th> '+

                       ' </tr></tfoot> ';
        sHTMLEMail := sHTMLEMail + sHTMLLinha;

        sHTMLEMail := sHTMLEMail + ' </tbody> </table> </body> </html> ';
        ggeKPIPagamentos.Progress := 100;
        lblMensagem.Caption := 'Finalizando montagem HTML....';
        lblMensagem.Update;
        Delay(200);
     finally
     end;*)
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
     try
        fdcOracle.Connected := True;
     except
           on E:EDatabaseError do
           begin
                Informacao('Falha ao conectar o banco....'+#13+
                           'A aplicação vai fechar!',
                           'Aviso...');
               Application.Terminate;
           end;
     end;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
     sDiretorioAtual := GetCurrentDir;

     // Gera intervalo de datas...
     sDataAtual := DateToStr(Date);
     //sDataInicio := '01/01/2020';
     //sDataFinal := '31/12/2020';

     //sDataInicio := '01/01/'+Copy(sDataAtual,7,4);
     //sDataFinal := '31/12/'+Copy(sDataAtual,7,4);

     // Gera as datas do intervalo. Gera o primeiro dia do mês corrente até
     // o dia atual (dia de execução da rotina)...
     // Obs.: Execução semanal, toda segunda-feira, para envio semanal, por
     //       e-mail, do relatório de pagamentos
     sDataInicio := '01/'+Copy(sDataAtual,4,7);
     sDataFinal := sDataAtual;
     sDataInicioAno := '01/01/'+Copy(sDataAtual,7,4);

     edtInicio.Text := sDataInicio;
     edtFinal.Text := sDataFinal;
end;

procedure TfrmPrincipal.mniSairClick(Sender: TObject);
begin
    Application.Terminate;
    Halt;
end;

end.

