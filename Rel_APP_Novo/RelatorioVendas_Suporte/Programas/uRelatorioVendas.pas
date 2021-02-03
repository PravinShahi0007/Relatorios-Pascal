{-------------------------------------------------------------------------------
 Programa..: uRelatorioVendas
 Empresa...: Grazziotin S/A
 Finalidade: Gravação de dados para o relatório de vendas

 Autor    Data     Operação  Descrição
 Antonio  JAN/2021 Criação
-------------------------------------------------------------------------------}
unit uRelatorioVendas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Mask, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, System.ImageList, Vcl.ImgList,
  System.StrUtils, Rest.Json, VclTee.TeeGDIPlus, VCLTee.TeEngine,
  VCLTee.TeeProcs, VCLTee.Chart, VCLTee.Series, ppVar, ppPrnabl, ppClass,
  ppCtrls, ppBands, ppCache, ppDB, ppDesignLayer, ppParameter, ppDBPipe, ppComm,
  ppRelatv, ppProd, ppReport, ppChrt, Vcl.Imaging.jpeg;

type
  TfrmRelatorioVendas = class(TForm)
    pnlRodape: TPanel;
    pnlCabecalho: TPanel;
    pnlFundo: TPanel;
    btnSair: TBitBtn;
    grpDatas: TGroupBox;
    lblInicial: TLabel;
    edtInicial: TMaskEdit;
    lblFinal: TLabel;
    edtFinal: TMaskEdit;
    btnRelatorioVendas: TBitBtn;
    qryRelatorioVendas: TFDQuery;
    dtsAtualiza: TDataSource;
    pnlFundoClilentesAVista: TPanel;
    pnlCabRelatorioVendas: TPanel;
    grdRelatorioVendas: TDBGrid;
    qryRelatorioVendasANOMES: TStringField;
    qryRelatorioVendasQTD_TOT_CLI_APP: TBCDField;
    qryRelatorioVendasQTD_NEW_CLI_APP: TBCDField;
    qryRelatorioVendasQTD_CLI_GRAZZIOTIN: TBCDField;
    qryRelatorioVendasTOT_CLI_PGTO_APP: TBCDField;
    pnlCabOpcoesGrafico: TPanel;
    lblMostrarGrafico: TLabel;
    lblTipoGrafico: TLabel;
    lblTipoBarra: TLabel;
    chb3D: TCheckBox;
    cbxMostrarGrafico: TComboBox;
    cbxTipoGrafico: TComboBox;
    cbxTipoBarra: TComboBox;
    chtGrafico: TChart;
    srsBarra_Cadastrados_APP: TBarSeries;
    chbMarcas: TCheckBox;
    srsBarra_Novos_Cadastrados: TBarSeries;
    srsLinha_Cadastrados_APP: TLineSeries;
    srsLinha_Novos_Cadastrados: TLineSeries;
    srsArea_Cadastrados_APP: TAreaSeries;
    srsArea_Novos_Cadastrados: TAreaSeries;
    srsBarra_Clientes_Grazziotin: TBarSeries;
    srsLinha_Clientes_Grazziotin: TLineSeries;
    srsArea_Clientes_Grazziotin: TAreaSeries;
    qryRelatorioVendasQTD_NEW_CLI_APP_APROV: TBCDField;
    srsBarra_Novos_Clientes_Aprovados_APP: TBarSeries;
    srsLinha_Novos_Clientes_Aprovados_APP: TLineSeries;
    srsArea_Novos_Clientes_Aprovados_APP: TAreaSeries;
    srsBarra_Total_Pagamentos_APP: TBarSeries;
    srsLinha_Total_Pagamentos_APP: TLineSeries;
    srsArea_Total_Pagamentos_APP: TAreaSeries;
    qryRelatorioVendasQTD_PARCELAS_PGTO_CIA: TBCDField;
    qryRelatorioVendasVLR_PARCELAS_PGTO_CIA: TFMTBCDField;
    srsBarra_Parcelas_Pagas_CIA: TBarSeries;
    srsLinha_Parcelas_Pagas_CIA: TLineSeries;
    srsArea_Parcelas_Pagas_CIA: TAreaSeries;
    btnRelatorio: TBitBtn;
    rptRelatorio: TppReport;
    pplRelatorio: TppDBPipeline;
    ppParameterList1: TppParameterList;
    ppDesignLayers1: TppDesignLayers;
    ppDesignLayer1: TppDesignLayer;
    ppHeaderBand1: TppHeaderBand;
    ppDetailBand1: TppDetailBand;
    lblRelEmissao: TppLabel;
    lblRelPagina: TppLabel;
    stvRelNumeroPagina: TppSystemVariable;
    lblRelCabMesAno: TppLabel;
    lblRelCabNovosCadastros: TppLabel;
    lblRelCabCadastradosAPP: TppLabel;
    lblRelCabClientesGrazziotin: TppLabel;
    lblRelCabValorPagoCIA: TppLabel;
    lblRelCabClientesAprovados: TppLabel;
    lblRelCabParcelasPagasCIA: TppLabel;
    lblRelCabPagamentosPeloAPP: TppLabel;
    lblRelMesAno: TppDBText;
    lblRelCadastradosAPP: TppDBText;
    lblRelNovosCadastrados: TppDBText;
    lblRelClientesGrazziotin: TppDBText;
    ppPageSummaryBand1: TppPageSummaryBand;
    chtRelCadastradosAPP: TppTeeChart;
    chtRelNovosCadastros: TppTeeChart;
    lblRelClientesAprovados: TppDBText;
    lblRelPagamentosAPP: TppDBText;
    lblRelParcelasPagasCIA: TppDBText;
    lblRelValorPagoCIA: TppDBText;
    imgRelLogo: TppImage;
    procedure Mostra_Dados(Sender: TObject);
    procedure Preenche_Vetores_Grafico(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lblInicialClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnRelatorioVendasClick(Sender: TObject);
    procedure edtInicialKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtFinalKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbxMostrarGraficoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbxTipoGraficoChange(Sender: TObject);
    procedure cbxTipoGraficoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbxTipoBarraKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtInicialExit(Sender: TObject);
    procedure edtFinalExit(Sender: TObject);
    procedure chb3DClick(Sender: TObject);
    procedure chbMarcasClick(Sender: TObject);
    procedure cbxMostrarGraficoChange(Sender: TObject);
    procedure cbxTipoBarraChange(Sender: TObject);
    procedure lblMostrarGraficoClick(Sender: TObject);
    procedure grpDatasClick(Sender: TObject);
    procedure btnRelatorioClick(Sender: TObject);
  private
  protected
    { Private declarations }
  public
        { Public declarations }
        iRegistros: Integer;
        sWhereClientes, sOrderClientes: String;
        aQtd_Tot_Cli_APP, aQtd_New_Cli_APP, aQtd_Cli_Grazziotin,
           aQtd_New_Cli_APP_Aprov, aTot_Cli_Pgto_APP,
           aQtd_Parcelas_Pgto_CIA, aVlr_Parcelas_Pgto_CIA: array of Double;
        aLabels: array of String;
  end;

const
     sSQLRelatorioVendas = 'select extract(month from dta_mes)||''/''||extract(year from dta_mes) as anomes,'+
                           '       qtd_tot_cli_app,qtd_new_cli_app,qtd_cli_grazziotin,qtd_new_cli_app_aprov,'+
                           '       tot_cli_pgto_app,qtd_parcelas_pgto_cia,vlr_parcelas_pgto_cia '+
                           'from grzw_rel_pgtos_appxloja '+
                           'where (extract(year from dta_mes) = :ano) '+
                           'order by dta_mes';
     clLaranja = $004080FF;

var
  frmRelatorioVendas: TfrmRelatorioVendas;

implementation

{$R *.dfm}

uses uFuncoes, uDtmRelatorioVendas;

procedure TfrmRelatorioVendas.Preenche_Vetores_Grafico(Sender: TObject);
var
   iInd: Integer;
begin
     SetLength(aQtd_Tot_Cli_APP, iRegistros);
     SetLength(aQtd_New_Cli_APP, iRegistros);
     SetLength(aQtd_Cli_Grazziotin, iRegistros);
     SetLength(aQtd_New_Cli_APP_Aprov, iRegistros);
     SetLength(aTot_Cli_Pgto_APP, iRegistros);
     SetLength(aQtd_Parcelas_Pgto_CIA, iRegistros);
     SetLength(aVlr_Parcelas_Pgto_CIA, iRegistros);
     SetLength(aLabels, iRegistros);

     qryRelatorioVendas.First;
     iInd := -1;
     while not (qryRelatorioVendas.Eof) do
     begin
          Inc(iInd);
          aQtd_Tot_Cli_APP[iInd] := qryRelatorioVendasQTD_TOT_CLI_APP.AsFloat;
          aQtd_New_Cli_APP[iInd] := qryRelatorioVendasQTD_NEW_CLI_APP.AsFloat;
          aQtd_Cli_Grazziotin[iInd] := qryRelatorioVendasQTD_CLI_GRAZZIOTIN.AsFloat;
          aQtd_New_Cli_APP_Aprov[iInd] := qryRelatorioVendasQTD_NEW_CLI_APP_APROV.AsFloat;
          aTot_Cli_Pgto_APP[iInd] := qryRelatorioVendasTOT_CLI_PGTO_APP.AsFloat;
          aQtd_Parcelas_Pgto_CIA[iInd] := qryRelatorioVendasQTD_PARCELAS_PGTO_CIA.AsFloat;
          aVlr_Parcelas_Pgto_CIA[iInd] := qryRelatorioVendasVLR_PARCELAS_PGTO_CIA.AsFloat;

          aLabels[iInd] := qryRelatorioVendasANOMES.AsString;

          qryRelatorioVendas.Next;
     end;

     // Limpa Series...
     // Barra...
     srsBarra_Cadastrados_APP.Clear;
     srsBarra_Novos_Cadastrados.Clear;
     srsBarra_Clientes_Grazziotin.Clear;
     srsBarra_Novos_Clientes_Aprovados_APP.Clear;
     srsBarra_Total_Pagamentos_APP.Clear;
     srsBarra_Parcelas_Pagas_CIA.Clear;

     // Linha...
     srsLinha_Cadastrados_APP.Clear;
     srsLinha_Novos_Cadastrados.Clear;
     srsLinha_Clientes_Grazziotin.Clear;
     srsLinha_Novos_Clientes_Aprovados_APP.Clear;
     srsLinha_Total_Pagamentos_APP.Clear;
     srsLinha_Parcelas_Pagas_CIA.Clear;

     // Área...
     srsArea_Cadastrados_APP.Clear;
     srsArea_Novos_Cadastrados.Clear;
     srsArea_Clientes_Grazziotin.Clear;
     srsArea_Novos_Clientes_Aprovados_APP.Clear;
     srsArea_Total_Pagamentos_APP.Clear;
     srsArea_Parcelas_Pagas_CIA.Clear;

     for iInd := 0 to High(aQtd_Tot_Cli_APP) do
     begin
          // Barra...
          srsBarra_Cadastrados_APP.AddBar(aQtd_Tot_Cli_APP[iInd],aLabels[iInd],clRed);
          srsBarra_Novos_Cadastrados.AddBar(aQtd_New_Cli_APP[iInd],aLabels[iInd],clNavy);
          srsBarra_Clientes_Grazziotin.AddBar(aQtd_Cli_Grazziotin[iInd],aLabels[iInd],clYellow);
          srsBarra_Novos_Clientes_Aprovados_APP.AddBar(aQtd_New_Cli_APP_Aprov[iInd],aLabels[iInd],clGreen);
          srsBarra_Total_Pagamentos_APP.AddBar(aTot_Cli_Pgto_APP[iInd],aLabels[iInd],clLaranja);
          srsBarra_Parcelas_Pagas_CIA.AddBar(aQtd_Parcelas_Pgto_CIA[iInd],aLabels[iInd],clFuchsia);

          // Relatorio
          chtRelCadastradosAPP.Chart[0].Add(aQtd_Tot_Cli_APP[iInd],aLabels[iInd],clYellow); // Cadastrados APP
          chtRelNovosCadastros.Chart[0].Add(aQtd_New_Cli_APP[iInd],aLabels[iInd],clYellow); // Novos Cadastrados

          // Linha...
          srsLinha_Cadastrados_APP.Add(aQtd_Tot_Cli_APP[iInd],aLabels[iInd],clRed);
          srsLinha_Novos_Cadastrados.Add(aQtd_New_Cli_APP[iInd],aLabels[iInd],clNavy);
          srsLinha_Clientes_Grazziotin.Add(aQtd_Cli_Grazziotin[iInd],aLabels[iInd],clYellow);
          srsLinha_Novos_Clientes_Aprovados_APP.Add(aQtd_New_Cli_APP_Aprov[iInd],aLabels[iInd],clGreen);
          srsLinha_Total_Pagamentos_APP.Add(aTot_Cli_Pgto_APP[iInd],aLabels[iInd],clLaranja);
          srsLinha_Parcelas_Pagas_CIA.Add(aQtd_Parcelas_Pgto_CIA[iInd],aLabels[iInd],clFuchsia);

          // Área....
          srsArea_Cadastrados_APP.Add(aQtd_Tot_Cli_APP[iInd],aLabels[iInd],clRed);
          srsArea_Novos_Cadastrados.Add(aQtd_New_Cli_APP[iInd],aLabels[iInd],clNavy);
          srsArea_Clientes_Grazziotin.Add(aQtd_Cli_Grazziotin[iInd],aLabels[iInd],clYellow);
          srsArea_Novos_Clientes_Aprovados_APP.Add(aQtd_New_Cli_APP_Aprov[iInd],aLabels[iInd],clGreen);
          srsArea_Total_Pagamentos_APP.Add(aTot_Cli_Pgto_APP[iInd],aLabels[iInd],clLaranja);
          srsArea_Parcelas_Pagas_CIA.Add(aQtd_Parcelas_Pgto_CIA[iInd],aLabels[iInd],clFuchsia);

     end;

     // Seta valores iniciais...
     cbxMostrarGraficoChange(Sender);
end;

procedure TfrmRelatorioVendas.Mostra_Dados(Sender: TObject);
begin
     qryRelatorioVendas.Active := False;
     qryRelatorioVendas.SQL.Clear;
     qryRelatorioVendas.SQL.Add(sSQLRelatorioVendas);
     qryRelatorioVendas.Params.ParamByName('ano').AsFloat := StrToInt(Copy(edtInicial.Text,7,4));
     qryRelatorioVendas.Active := True;
     qryRelatorioVendas.FetchAll;
     iRegistros := qryRelatorioVendas.RecordCount;

     Preenche_Vetores_Grafico(Sender);

     qryRelatorioVendas.First;
     pnlFundo.Visible := True;
     btnRelatorio.Visible := True;
end;

procedure TfrmRelatorioVendas.btnRelatorioClick(Sender: TObject);
begin
     lblRelEmissao.Caption := 'Emissão: '+Copy(DateToStr(Date),1,2)+' de '+
                              MesExtenso(Date)+' de '+Copy(DateToStr(Date),7,4)+
                              ' as '+TimeToStr(Time);
     rptRelatorio.PrintReport;
end;

procedure TfrmRelatorioVendas.btnRelatorioVendasClick(Sender: TObject);
begin
     if (dtmRelatorioVendas.fdcRelatorioVendas.InTransaction) then
        dtmRelatorioVendas.trsRelatorioVendas.Commit;
     dtmRelatorioVendas.trsRelatorioVendas.StartTransaction;

     // Verifica se já existe registro na tabela GRZW_REL_PGTOS_APPXLOJA,
     // Se existir, deleta...
     dtmRelatorioVendas.qryGeralDados.Active := False;
     dtmRelatorioVendas.qryGeralDados.SQL.Clear;
     dtmRelatorioVendas.qryGeralDados.SQL.Add(
              'select * from grzw_rel_pgtos_appxloja where (dta_mes = :dta_mes)');
     dtmRelatorioVendas.qryGeralDados.Params.ParamByName('dta_mes').AsDate := StrToDate(edtInicial.Text);
     dtmRelatorioVendas.qryGeralDados.Active := True;
     // Existe registrio....
     if not (dtmRelatorioVendas.qryGeralDados.FieldByName('dta_mes').IsNull) then
     begin
          dtmRelatorioVendas.qryGeralDados.Active := False;
          dtmRelatorioVendas.qryGeralDados.SQL.Clear;
          dtmRelatorioVendas.qryGeralDados.SQL.Add(
                   'delete from grzw_rel_pgtos_appxloja where (dta_mes = :dta_mes)');
          dtmRelatorioVendas.qryGeralDados.Params.ParamByName('dta_mes').AsDate := StrToDate(edtInicial.Text);
          dtmRelatorioVendas.qryGeralDados.ExecSQL;
          dtmRelatorioVendas.trsRelatorioVendas.CommitRetaining;
     end;

     dtmRelatorioVendas.fspGRZ_Rel_Pgto_AppxLoja_SP.Active := False;
     dtmRelatorioVendas.fspGRZ_Rel_Pgto_AppxLoja_SP.Params.ParamByName('pdatainicial').AsString := edtInicial.Text;
     dtmRelatorioVendas.fspGRZ_Rel_Pgto_AppxLoja_SP.Params.ParamByName('pdatafinal').AsString := edtFinal.Text;
     dtmRelatorioVendas.fspGRZ_Rel_Pgto_AppxLoja_SP.Execute();

     Mostra_Dados(Sender);
end;

procedure TfrmRelatorioVendas.btnSairClick(Sender: TObject);
begin
     Close;
end;

procedure TfrmRelatorioVendas.cbxMostrarGraficoChange(Sender: TObject);
begin
     chtGrafico.View3DOptions.Orthogonal := True;
     // Barra
     srsBarra_Cadastrados_APP.Visible := (cbxMostrarGrafico.ItemIndex = 0);
     srsBarra_Novos_Cadastrados.Visible := (cbxMostrarGrafico.ItemIndex = 1);
     srsBarra_Clientes_Grazziotin.Visible := (cbxMostrarGrafico.ItemIndex = 2);
     srsBarra_Novos_Clientes_Aprovados_APP.Visible := (cbxMostrarGrafico.ItemIndex = 3);
     srsBarra_Total_Pagamentos_APP.Visible := (cbxMostrarGrafico.ItemIndex = 4);
     srsBarra_Parcelas_Pagas_CIA.Visible := (cbxMostrarGrafico.ItemIndex = 5);

     // Linha
     srsLinha_Cadastrados_APP.Visible := (cbxMostrarGrafico.ItemIndex = 0);
     srsLinha_Novos_Cadastrados.Visible := (cbxMostrarGrafico.ItemIndex = 1);
     srsLinha_Clientes_Grazziotin.Visible := (cbxMostrarGrafico.ItemIndex = 2);
     srsLinha_Novos_Clientes_Aprovados_APP.Visible := (cbxMostrarGrafico.ItemIndex = 3);
     srsLinha_Total_Pagamentos_APP.Visible := (cbxMostrarGrafico.ItemIndex = 4);
     srsLinha_Parcelas_Pagas_CIA.Visible := (cbxMostrarGrafico.ItemIndex = 5);

     // Área
     srsArea_Cadastrados_APP.Visible := (cbxMostrarGrafico.ItemIndex = 0);
     srsArea_Novos_Cadastrados.Visible := (cbxMostrarGrafico.ItemIndex = 1);
     srsArea_Clientes_Grazziotin.Visible := (cbxMostrarGrafico.ItemIndex = 2);
     srsArea_Novos_Clientes_Aprovados_APP.Visible := (cbxMostrarGrafico.ItemIndex = 3);
     srsArea_Total_Pagamentos_APP.Visible := (cbxMostrarGrafico.ItemIndex = 4);
     srsArea_Parcelas_Pagas_CIA.Visible := (cbxMostrarGrafico.ItemIndex = 5);

     chtGrafico.Title.Text.Clear;
     case cbxMostrarGrafico.ItemIndex of
          0: chtGrafico.Title.Text.Add('Cadastrados via APP');
          1: chtGrafico.Title.Text.Add('Novos clientes cadastrados');
          2: chtGrafico.Title.Text.Add('Clientes Grazziotin (Já cadastrados)');
          3: chtGrafico.Title.Text.Add('Novos clientes aprovados APP');
          4: chtGrafico.Title.Text.Add('Total de Pagamentos pelo APPP');
          5: chtGrafico.Title.Text.Add('Quantidade de Parcelas Pagas na CIA');
     end;

     cbxTipoGraficoChange(Sender);
end;

procedure TfrmRelatorioVendas.cbxMostrarGraficoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
     case Key of
          VK_RETURN: cbxTipoGrafico.SetFocus;
     end;
end;

procedure TfrmRelatorioVendas.cbxTipoBarraChange(Sender: TObject);
begin
     case (cbxTipoBarra.ItemIndex) of
           0: begin
                   srsBarra_Cadastrados_APP.BarStyle := bsArrow;
                   srsBarra_Novos_Cadastrados.BarStyle := bsArrow;
                   srsBarra_Clientes_Grazziotin.BarStyle := bsArrow;
                   srsBarra_Novos_Clientes_Aprovados_APP.BarStyle := bsArrow;
                   srsBarra_Total_Pagamentos_APP.BarStyle := bsArrow;
                   srsBarra_Parcelas_Pagas_CIA.BarStyle := bsArrow;
              end;
           1: begin
                   srsBarra_Cadastrados_APP.BarStyle := bsBevel;
                   srsBarra_Novos_Cadastrados.BarStyle := bsBevel;
                   srsBarra_Clientes_Grazziotin.BarStyle := bsBevel;
                   srsBarra_Novos_Clientes_Aprovados_APP.BarStyle := bsBevel;
                   srsBarra_Total_Pagamentos_APP.BarStyle := bsBevel;
                   srsBarra_Parcelas_Pagas_CIA.BarStyle := bsBevel;
              end;
           2: begin
                   srsBarra_Cadastrados_APP.BarStyle := bsCilinder;
                   srsBarra_Novos_Cadastrados.BarStyle := bsCilinder;
                   srsBarra_Clientes_Grazziotin.BarStyle := bsCilinder;
                   srsBarra_Novos_Clientes_Aprovados_APP.BarStyle := bsCilinder;
                   srsBarra_Total_Pagamentos_APP.BarStyle := bsCilinder;
                   srsBarra_Parcelas_Pagas_CIA.BarStyle := bsCilinder;
              end;
           3: begin
                   srsBarra_Cadastrados_APP.BarStyle := bsCone;
                   srsBarra_Novos_Cadastrados.BarStyle := bsCone;
                   srsBarra_Clientes_Grazziotin.BarStyle := bsCone;
                   srsBarra_Novos_Clientes_Aprovados_APP.BarStyle := bsCone;
                   srsBarra_Total_Pagamentos_APP.BarStyle := bsCone;
                   srsBarra_Parcelas_Pagas_CIA.BarStyle := bsCone;
              end;
           4: begin
                   srsBarra_Cadastrados_APP.BarStyle := bsDiamond;
                   srsBarra_Novos_Cadastrados.BarStyle := bsDiamond;
                   srsBarra_Clientes_Grazziotin.BarStyle := bsDiamond;
                   srsBarra_Novos_Clientes_Aprovados_APP.BarStyle := bsDiamond;
                   srsBarra_Total_Pagamentos_APP.BarStyle := bsDiamond;
                   srsBarra_Parcelas_Pagas_CIA.BarStyle := bsDiamond;
              end;
           5: begin
                   srsBarra_Cadastrados_APP.BarStyle := bsEllipse;
                   srsBarra_Novos_Cadastrados.BarStyle := bsEllipse;
                   srsBarra_Clientes_Grazziotin.BarStyle := bsEllipse;
                   srsBarra_Novos_Clientes_Aprovados_APP.BarStyle := bsEllipse;
                   srsBarra_Total_Pagamentos_APP.BarStyle := bsEllipse;
                   srsBarra_Parcelas_Pagas_CIA.BarStyle := bsEllipse;
              end;
           6: begin
                   srsBarra_Cadastrados_APP.BarStyle := bsInvArrow;
                   srsBarra_Novos_Cadastrados.BarStyle := bsInvArrow;
                   srsBarra_Clientes_Grazziotin.BarStyle := bsInvArrow;
                   srsBarra_Novos_Clientes_Aprovados_APP.BarStyle := bsInvArrow;
                   srsBarra_Total_Pagamentos_APP.BarStyle := bsInvArrow;
                   srsBarra_Parcelas_Pagas_CIA.BarStyle := bsInvArrow;
              end;
           7: begin
                   srsBarra_Cadastrados_APP.BarStyle := bsInvCone;
                   srsBarra_Novos_Cadastrados.BarStyle := bsInvCone;
                   srsBarra_Clientes_Grazziotin.BarStyle := bsInvCone;
                   srsBarra_Novos_Clientes_Aprovados_APP.BarStyle := bsInvCone;
                   srsBarra_Total_Pagamentos_APP.BarStyle := bsInvCone;
                   srsBarra_Parcelas_Pagas_CIA.BarStyle := bsInvCone;
              end;
           8: begin
                   srsBarra_Cadastrados_APP.BarStyle := bsInvPyramid;
                   srsBarra_Novos_Cadastrados.BarStyle := bsInvPyramid;
                   srsBarra_Clientes_Grazziotin.BarStyle := bsInvPyramid;
                   srsBarra_Novos_Clientes_Aprovados_APP.BarStyle := bsInvPyramid;
                   srsBarra_Total_Pagamentos_APP.BarStyle := bsInvPyramid;
                   srsBarra_Parcelas_Pagas_CIA.BarStyle := bsInvPyramid;
              end;
           9: begin
                   srsBarra_Cadastrados_APP.BarStyle := bsPyramid;
                   srsBarra_Novos_Cadastrados.BarStyle := bsPyramid;
                   srsBarra_Clientes_Grazziotin.BarStyle := bsPyramid;
                   srsBarra_Novos_Clientes_Aprovados_APP.BarStyle := bsPyramid;
                   srsBarra_Total_Pagamentos_APP.BarStyle := bsPyramid;
                   srsBarra_Parcelas_Pagas_CIA.BarStyle := bsPyramid;
              end;
          10: begin
                   srsBarra_Cadastrados_APP.BarStyle := bsRectangle;
                   srsBarra_Novos_Cadastrados.BarStyle := bsRectangle;
                   srsBarra_Clientes_Grazziotin.BarStyle := bsRectangle;
                   srsBarra_Novos_Clientes_Aprovados_APP.BarStyle := bsRectangle;
                   srsBarra_Total_Pagamentos_APP.BarStyle := bsRectangle;
                   srsBarra_Parcelas_Pagas_CIA.BarStyle := bsRectangle;
              end;
          11: begin
                   srsBarra_Cadastrados_APP.BarStyle := bsRectGradient;
                   srsBarra_Novos_Cadastrados.BarStyle := bsRectGradient;
                   srsBarra_Clientes_Grazziotin.BarStyle := bsRectGradient;
                   srsBarra_Novos_Clientes_Aprovados_APP.BarStyle := bsRectGradient;
                   srsBarra_Total_Pagamentos_APP.BarStyle := bsRectGradient;
                   srsBarra_Parcelas_Pagas_CIA.BarStyle := bsRectGradient;
              end;
          12: begin
                   srsBarra_Cadastrados_APP.BarStyle := bsRoundRectangle;
                   srsBarra_Novos_Cadastrados.BarStyle := bsRoundRectangle;
                   srsBarra_Clientes_Grazziotin.BarStyle := bsRoundRectangle;
                   srsBarra_Novos_Clientes_Aprovados_APP.BarStyle := bsRoundRectangle;
                   srsBarra_Total_Pagamentos_APP.BarStyle := bsRoundRectangle;
                   srsBarra_Parcelas_Pagas_CIA.BarStyle := bsRoundRectangle;
              end;
          13: begin
                   srsBarra_Cadastrados_APP.BarStyle := bsSlantCube;
                   srsBarra_Novos_Cadastrados.BarStyle := bsSlantCube;
                   srsBarra_Clientes_Grazziotin.BarStyle := bsSlantCube;
                   srsBarra_Novos_Clientes_Aprovados_APP.BarStyle := bsSlantCube;
                   srsBarra_Total_Pagamentos_APP.BarStyle := bsSlantCube;
                   srsBarra_Parcelas_Pagas_CIA.BarStyle := bsSlantCube;
              end;
     end;

     chb3DClick(Sender);
end;

procedure TfrmRelatorioVendas.cbxTipoBarraKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
     case Key of
          VK_RETURN: chb3D.SetFocus;
     end;
end;

procedure TfrmRelatorioVendas.cbxTipoGraficoChange(Sender: TObject);
begin
     // Tipo da barra só fica ativo, se o tipo de grafico for BARRA...
     cbxTipoBarra.Enabled := (cbxTipoGrafico.ItemIndex = 0);

     // Barra...
     srsBarra_Cadastrados_APP.Visible := (cbxMostrarGrafico.ItemIndex = 0) and (cbxTipoGrafico.ItemIndex = 0);
     srsBarra_Novos_Cadastrados.Visible := (cbxMostrarGrafico.ItemIndex = 1) and (cbxTipoGrafico.ItemIndex = 0);
     srsBarra_Clientes_Grazziotin.Visible := (cbxMostrarGrafico.ItemIndex = 2) and (cbxTipoGrafico.ItemIndex = 0);
     srsBarra_Novos_Clientes_Aprovados_APP.Visible := (cbxMostrarGrafico.ItemIndex = 3) and (cbxTipoGrafico.ItemIndex = 0);
     srsBarra_Total_Pagamentos_APP.Visible := (cbxMostrarGrafico.ItemIndex = 4) and (cbxTipoGrafico.ItemIndex = 0);
     srsBarra_Parcelas_Pagas_CIA.Visible := (cbxMostrarGrafico.ItemIndex = 5) and (cbxTipoGrafico.ItemIndex = 0);

     // Linha...
     srsLinha_Cadastrados_APP.Visible := (cbxMostrarGrafico.ItemIndex = 0) and (cbxTipoGrafico.ItemIndex = 1);
     srsLinha_Novos_Cadastrados.Visible := (cbxMostrarGrafico.ItemIndex = 1) and (cbxTipoGrafico.ItemIndex = 1);
     srsLinha_Clientes_Grazziotin.Visible := (cbxMostrarGrafico.ItemIndex = 2) and (cbxTipoGrafico.ItemIndex = 1);
     srsLinha_Novos_Clientes_Aprovados_APP.Visible := (cbxMostrarGrafico.ItemIndex = 3) and (cbxTipoGrafico.ItemIndex = 1);
     srsLinha_Total_Pagamentos_APP.Visible := (cbxMostrarGrafico.ItemIndex = 4) and (cbxTipoGrafico.ItemIndex = 1);
     srsLinha_Parcelas_Pagas_CIA.Visible := (cbxMostrarGrafico.ItemIndex = 5) and (cbxTipoGrafico.ItemIndex = 1);

     // Área....
     srsArea_Cadastrados_APP.Visible := (cbxMostrarGrafico.ItemIndex = 0) and (cbxTipoGrafico.ItemIndex = 2);
     srsArea_Novos_Cadastrados.Visible := (cbxMostrarGrafico.ItemIndex = 1) and (cbxTipoGrafico.ItemIndex = 2);
     srsArea_Clientes_Grazziotin.Visible := (cbxMostrarGrafico.ItemIndex = 2) and (cbxTipoGrafico.ItemIndex = 2);
     srsArea_Novos_Clientes_Aprovados_APP.Visible := (cbxMostrarGrafico.ItemIndex = 3) and (cbxTipoGrafico.ItemIndex = 2);
     srsArea_Total_Pagamentos_APP.Visible := (cbxMostrarGrafico.ItemIndex = 4) and (cbxTipoGrafico.ItemIndex = 2);
     srsArea_Parcelas_Pagas_CIA.Visible := (cbxMostrarGrafico.ItemIndex = 5) and (cbxTipoGrafico.ItemIndex = 2);

     cbxTipoBarraChange(Sender);
end;

procedure TfrmRelatorioVendas.cbxTipoGraficoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
     case Key of
          VK_RETURN: begin
                          if (cbxTipoBarra.Enabled) then
                             cbxTipoBarra.SetFocus
                          else
                              chb3D.SetFocus;
                     end;
     end;
end;

procedure TfrmRelatorioVendas.chb3DClick(Sender: TObject);
begin
     chtGrafico.View3D := chb3D.Checked;

     chbMarcasClick(Sender);
end;

procedure TfrmRelatorioVendas.chbMarcasClick(Sender: TObject);
begin
     // Barra
     srsBarra_Cadastrados_APP.Marks.Visible := (chbMarcas.Checked);
     srsBarra_Novos_Cadastrados.Marks.Visible := (chbMarcas.Checked);
     srsBarra_Clientes_Grazziotin.Marks.Visible := (chbMarcas.Checked);
     srsBarra_Novos_Clientes_Aprovados_APP.Marks.Visible := (chbMarcas.Checked);
     srsBarra_Total_Pagamentos_APP.Marks.Visible := (chbMarcas.Checked);
     srsBarra_Parcelas_Pagas_CIA.Marks.Visible := (chbMarcas.Checked);

     // Linha
     srsLinha_Cadastrados_APP.Marks.Visible := (chbMarcas.Checked);
     srsLinha_Novos_Cadastrados.Marks.Visible := (chbMarcas.Checked);
     srsLinha_Clientes_Grazziotin.Marks.Visible := (chbMarcas.Checked);
     srsLinha_Novos_Clientes_Aprovados_APP.Marks.Visible := (chbMarcas.Checked);
     srsLinha_Total_Pagamentos_APP.Marks.Visible := (chbMarcas.Checked);
     srsLinha_Parcelas_Pagas_CIA.Marks.Visible := (chbMarcas.Checked);

     // Area
     srsArea_Cadastrados_APP.Marks.Visible := (chbMarcas.Checked);
     srsArea_Novos_Cadastrados.Marks.Visible := (chbMarcas.Checked);
     srsArea_Clientes_Grazziotin.Marks.Visible := (chbMarcas.Checked);
     srsArea_Novos_Clientes_Aprovados_APP.Marks.Visible := (chbMarcas.Checked);
     srsArea_Total_Pagamentos_APP.Marks.Visible := (chbMarcas.Checked);
     srsArea_Parcelas_Pagas_CIA.Marks.Visible := (chbMarcas.Checked);

end;

procedure TfrmRelatorioVendas.edtFinalExit(Sender: TObject);
var
   iUltimoDia: Integer;
begin
     // A data final é o ultimo dia do mes...
     iUltimoDia := Ultimo_Dia(StrToInt(Copy(edtInicial.Text,4,2)),StrToInt(Copy(edtInicial.Text,7,4)));

     if (ValidaData(edtFinal.Text)) or (StrToInt(Copy(edtFinal.Text,1,2)) <> iUltimoDia) then
     begin
          Informacao('Data Inválida!!!','Aviso...');
          edtInicial.SetFocus;
          Exit;
     end;
end;

procedure TfrmRelatorioVendas.edtFinalKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     case Key of
          VK_RETURN: btnRelatorioVendas.SetFocus;
          VK_UP: edtInicial.SetFocus;
     end;
end;

procedure TfrmRelatorioVendas.edtInicialExit(Sender: TObject);
var
   iUltimoDia: Integer;
begin
     if (AllTrim(edtInicial.Text) = '//') then
     begin
          Close;
          Exit;
     end;
     if (ValidaData(edtInicial.Text)) then
     begin
          Informacao('Data Inválida!!!','Aviso...');
          edtInicial.SetFocus;
          Exit;
     end;
     // É sempre o primeiro dia do mês
     edtInicial.Text := '01'+Copy(edtInicial.Text,3,8);
     // A data final é o ultimo dia do mes...
     iUltimoDia := Ultimo_Dia(StrToInt(Copy(edtInicial.Text,4,2)),StrToInt(Copy(edtInicial.Text,7,4)));
     edtFinal.Text := PadLeft(IntToStr(iUltimoDia),2,'0')+Copy(edtInicial.Text,3,8);
end;

procedure TfrmRelatorioVendas.edtInicialKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     case Key of
          VK_RETURN: edtFinal.SetFocus;
          VK_UP: btnSair.SetFocus;
     end;
end;

procedure TfrmRelatorioVendas.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
     if (dtmRelatorioVendas.fdcRelatorioVendas.InTransaction) then
        dtmRelatorioVendas.trsRelatorioVendas.Commit;
end;

procedure TfrmRelatorioVendas.FormShow(Sender: TObject);
begin
     edtInicial.Text := '';
     edtFinal.Text := '';
     edtInicial.Text := DateToStr(Date);
end;

procedure TfrmRelatorioVendas.grpDatasClick(Sender: TObject);
begin
     Mostra_Dados(Sender);
end;

procedure TfrmRelatorioVendas.lblInicialClick(Sender: TObject);
begin
     edtInicial.Text := '01/01/2020';
     edtFinal.Text := '31/01/2020';
end;

procedure TfrmRelatorioVendas.lblMostrarGraficoClick(Sender: TObject);
begin
     // Barra...
     srsBarra_Cadastrados_APP.Visible := (cbxTipoGrafico.ItemIndex = 0);
     srsBarra_Novos_Cadastrados.Visible := (cbxTipoGrafico.ItemIndex = 0);
     srsBarra_Clientes_Grazziotin.Visible := (cbxTipoGrafico.ItemIndex = 0);
     srsBarra_Novos_Clientes_Aprovados_APP.Visible := (cbxTipoGrafico.ItemIndex = 0);
     srsBarra_Total_Pagamentos_APP.Visible := (cbxTipoGrafico.ItemIndex = 0);
     srsBarra_Parcelas_Pagas_CIA.Visible := (cbxTipoGrafico.ItemIndex = 0);

     // Linha...
     srsLinha_Cadastrados_APP.Visible := (cbxTipoGrafico.ItemIndex = 1);
     srsLinha_Novos_Cadastrados.Visible := (cbxTipoGrafico.ItemIndex = 1);
     srsLinha_Clientes_Grazziotin.Visible := (cbxTipoGrafico.ItemIndex = 1);
     srsLinha_Novos_Clientes_Aprovados_APP.Visible := (cbxTipoGrafico.ItemIndex = 1);
     srsLinha_Total_Pagamentos_APP.Visible := (cbxTipoGrafico.ItemIndex = 1);
     srsLinha_Parcelas_Pagas_CIA.Visible := (cbxTipoGrafico.ItemIndex = 1);

     // Área...
     srsArea_Cadastrados_APP.Visible := (cbxTipoGrafico.ItemIndex = 2);
     srsArea_Novos_Cadastrados.Visible := (cbxTipoGrafico.ItemIndex = 2);
     srsArea_Clientes_Grazziotin.Visible := (cbxTipoGrafico.ItemIndex = 2);
     srsArea_Novos_Clientes_Aprovados_APP.Visible := (cbxTipoGrafico.ItemIndex = 2);
     srsArea_Total_Pagamentos_APP.Visible := (cbxTipoGrafico.ItemIndex = 2);
     srsArea_Parcelas_Pagas_CIA.Visible := (cbxTipoGrafico.ItemIndex = 2);

end;

end.

