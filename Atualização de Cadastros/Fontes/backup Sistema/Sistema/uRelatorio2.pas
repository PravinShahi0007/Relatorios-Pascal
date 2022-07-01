unit uRelatorio2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ppDB, ppDBPipe, ppParameter, ppBands, ppClass,
  ppCtrls, ppVar, ppStrtch, ppMemo, ppPrnabl, ppCache, ppComm, ppRelatv,
  ppProd, ppReport, DB, DBTables, TXComp, TXRB, StdCtrls, Buttons, Mask,
  jpeg;

type
  TForm3 = class(TForm)
    lblParametro: TLabel;
    lblIntervaloini: TLabel;
    lblIntervaloFim: TLabel;
    lblEmpresa: TLabel;
    lblGrupo: TLabel;
    lblUnidade: TLabel;
    lblData: TLabel;
    lblPerfil: TLabel;
    lblPerfil_de: TLabel;
    imgGraz: TImage;
    edtPerfilIni: TEdit;
    edtPerfil: TEdit;
    medtPeriodoIni: TMaskEdit;
    edtUnidade: TEdit;
    edtGrupo: TEdit;
    edtEmpresa: TEdit;
    edtPerfilFim: TEdit;
    medtPeriodoFim: TMaskEdit;
    btnGerar: TBitBtn;
    btnFechar: TBitBtn;
    ssn1: TSession;
    db1: TDatabase;
    extrptns1: TExtraOptions;
    strdprc_retorno: TStoredProc;
    qryQryConsulta: TQuery;
    qryQryConsultaDES_USUARIO: TStringField;
    fltfldQryConsultaTIP_MOVIMENTO: TFloatField;
    fltfldQryConsultaCOD_EMP: TFloatField;
    fltfldQryConsultaCOD_UNIDADE: TFloatField;
    qryQryConsultaDES_FANTASIA: TStringField;
    fltfldQryConsultaCOD_REGIAO: TFloatField;
    qryQryConsultaDES_REGIAO: TStringField;
    fltfldQryConsultaQTD_CUPONS: TFloatField;
    fltfldQryConsultaVLR_VENDA_LOJA: TFloatField;
    fltfldQryConsultaVLR_DESCONTOS: TFloatField;
    fltfldQryConsultaQTD_CLI_IDENTIFICADO: TFloatField;
    fltfldQryConsultaQTD_BONUS: TFloatField;
    fltfldQryConsultaVLR_BONUS: TFloatField;
    fltfldQryConsultaVLR_VENDA_BONUS: TFloatField;
    fltfldQryConsultaQTD_BONUS_VENDA: TFloatField;
    fltfldQryConsultaVLR_DESC_PROMO_QTD: TFloatField;
    fltfldQryConsultaVLR_DESC_FUNC: TFloatField;
    fltfldQryConsultaQTD_BONUS_VENC: TFloatField;
    fltfldQryConsultaQTD_BONUS_VENC_RET: TFloatField;
    fltfldQryConsultaVLR_CUSTO: TFloatField;
    fltfldQryConsultaVLR_IMPOSTOS: TFloatField;
    fltfldQryConsultaVLR_NORMAL: TFloatField;
    fltfldQryConsultaVLR_IMPRESSO: TFloatField;
    dsConsulta: TDataSource;
    prprtRelatorio: TppReport;
    ppHeaderBand1: TppHeaderBand;
    pshp1: TppShape;
    pshp2: TppShape;
    pshp3: TppShape;
    pshp4: TppShape;
    pm1: TppMemo;
    plblTitulo: TppLabel;
    plbl1: TppLabel;
    plbl2: TppLabel;
    psystmvrbl1: TppSystemVariable;
    psystmvrbl2: TppSystemVariable;
    plbl3: TppLabel;
    plblTitulo2: TppLabel;
    plbl4: TppLabel;
    plbl5: TppLabel;
    plbl6: TppLabel;
    plbl7: TppLabel;
    plbl8: TppLabel;
    plbl9: TppLabel;
    plbl10: TppLabel;
    plbl11: TppLabel;
    plbl12: TppLabel;
    plbl13: TppLabel;
    plbl14: TppLabel;
    plbl15: TppLabel;
    plbl16: TppLabel;
    plbl17: TppLabel;
    plbl18: TppLabel;
    plbl19: TppLabel;
    plbl20: TppLabel;
    plbl21: TppLabel;
    plbl22: TppLabel;
    plbl23: TppLabel;
    plbl24: TppLabel;
    plbl25: TppLabel;
    plbl26: TppLabel;
    plbl27: TppLabel;
    plbl28: TppLabel;
    plbl29: TppLabel;
    plblRel: TppLabel;
    plblVlrCompra: TppLabel;
    pdtlbnd1: TppDetailBand;
    pdbtxt1: TppDBText;
    pdbtxtItens: TppDBText;
    pdbtxtLivro: TppDBText;
    pdbtxtQtdBonusDev: TppDBText;
    pdbtxtVnda_Loja: TppDBText;
    pdbtxtCupons: TppDBText;
    pdbtxtCli_Ident: TppDBText;
    pdbtxtVndaCbonus: TppDBText;
    pdbtxtQtdBonus: TppDBText;
    pdbtxtVlr_Bonus: TppDBText;
    plblVendaMdiaCupom: TppLabel;
    plblPerc_vnda_Bonus: TppLabel;
    plblPercQtdBonus: TppLabel;
    plblVlrBonusP_Loja: TppLabel;
    plblPercVlrBonus: TppLabel;
    pftrbnd1: TppFooterBand;
    psmrybnd1: TppSummaryBand;
    plbl30: TppLabel;
    pdbclcCupons_Geral: TppDBCalc;
    pdbclcVnda_Loja_Geral: TppDBCalc;
    pdbclcCli_Ident_Geral: TppDBCalc;
    pdbclcQtdBonusDev_Geral: TppDBCalc;
    pdbclcVndaCbonus_geral: TppDBCalc;
    pdbclcQtdBonus_Geral: TppDBCalc;
    plblVendaMdiaCupom_Geral: TppLabel;
    plblPerc_vnda_Bonus_Geral: TppLabel;
    pdbclcVlr_Bonus_Geral: TppDBCalc;
    plblPercQtdBonus_Geral: TppLabel;
    plblVlrBonusP_Loja_Geral: TppLabel;
    plblPercVlrBonus_Geral: TppLabel;
    pgrp1: TppGroup;
    pgrphdrbnd1: TppGroupHeaderBand;
    pgrpftrbnd1: TppGroupFooterBand;
    pdbclcCupons_Reg: TppDBCalc;
    plbl31: TppLabel;
    pdbclcVnda_Loja_Reg: TppDBCalc;
    pdbclcCli_Ident_Reg: TppDBCalc;
    pdbclcQtdBonusDev_Reg: TppDBCalc;
    pdbclcVndaCbonus_reg: TppDBCalc;
    pdbclcQtdBonus_Reg: TppDBCalc;
    plblVendaMdiaCupom_Reg: TppLabel;
    plblPerc_vnda_Bonus_Reg: TppLabel;
    plblPercQtdBonus_Reg: TppLabel;
    pdbclcVlr_Bonus_reg: TppDBCalc;
    plblVlrBonusP_Loja_reg: TppLabel;
    plblPercVlrBonus_Reg: TppLabel;
    prmtrlst1: TppParameterList;
    prmtr1: TppParameter;
    pdbpln1: TppDBPipeline;
    ppDBPipeline1ppField1: TppField;
    ppDBPipeline1ppField2: TppField;
    ppDBPipeline1ppField3: TppField;
    ppDBPipeline1ppField4: TppField;
    ppDBPipeline1ppField5: TppField;
    ppDBPipeline1ppField6: TppField;
    ppDBPipeline1ppField7: TppField;
    ppDBPipeline1ppField8: TppField;
    ppDBPipeline1ppField9: TppField;
    ppDBPipeline1ppField10: TppField;
    ppDBPipeline1ppField11: TppField;
    ppDBPipeline1ppField12: TppField;
    ppDBPipeline1ppField13: TppField;
    ppDBPipeline1ppField14: TppField;
    ppDBPipeline1ppField15: TppField;
    ppDBPipeline1ppField16: TppField;
    ppDBPipeline1ppField17: TppField;
    ppDBPipeline1ppField18: TppField;
    ppDBPipeline1ppField19: TppField;
    ppDBPipeline1ppField20: TppField;
    ppDBPipeline1ppField21: TppField;
    ppDBPipeline1ppField22: TppField;
    ppDBPipeline1ppField23: TppField;
    qryDta: TQuery;
    pnl1: TPanel;
    procedure btnFecharClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.btnFecharClick(Sender: TObject);
begin
Close;
end;

end.
