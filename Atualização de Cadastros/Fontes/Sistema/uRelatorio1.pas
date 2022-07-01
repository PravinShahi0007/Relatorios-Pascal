unit uRelatorio1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, TXComp, TXRB, ppParameter, Encryp, ppCtrls,
  ppBands, ppClass,ppViewr,
  ppVar, ppStrtch,
  Buttons, Mask, ppPrnabl, ppCache, ppProd, ppReport, ppDB,
  ppComm, ppRelatv, ppDBPipe, DBTables, DB, StdCtrls, jpeg,  OleCtrls, Chartfx3,
  ppModule, daDataModule, ppMemo;



type
  TForm2 = class(TForm)
    lblParametro: TLabel;
    lblIntervaloini: TLabel;
    lblIntervaloFim: TLabel;
    lblEmpresa: TLabel;
    lblGrupo: TLabel;
    lblData: TLabel;
    lbl1: TLabel;
    imgGraz: TImage;
    edtEmpresa: TEdit;
    medtPeriodoIni: TMaskEdit;
    medtPeriodoFim: TMaskEdit;
    edtGrupo: TEdit;
    btnGerar: TBitBtn;
    btnFechar: TBitBtn;
    ssn1: TSession;
    dsManutencao: TDataSource;
    db1: TDatabase;
    qryGeral: TQuery;
    strdprc_frete: TStoredProc;
    pdbpln1: TppDBPipeline;
    ppRel_Retorno: TppReport;
    ppHeaderBand2: TppHeaderBand;
    pshp1: TppShape;
    pshp2: TppShape;
    pshp3: TppShape;
    pshp4: TppShape;
    pm1: TppMemo;
    plblDta: TppLabel;
    plbl1: TppLabel;
    plbl2: TppLabel;
    psystmvrbl1: TppSystemVariable;
    psystmvrbl2: TppSystemVariable;
    plbl3: TppLabel;
    plblRede: TppLabel;
    plbl8: TppLabel;
    plbl10: TppLabel;
    plbl13: TppLabel;
    plbl17: TppLabel;
    plbl22: TppLabel;
    plbl23: TppLabel;
    pdtlbnd1: TppDetailBand;
    pdbtxt1: TppDBText;
    pdbtxt2: TppDBText;
    pdbtxt3: TppDBText;
    pdbtxtVnda_Liq_Loja: TppDBText;
    pdbtxtDescontos: TppDBText;
    pftrbnd1: TppFooterBand;
    psmrybnd1: TppSummaryBand;
    pgrp1: TppGroup;
    pgrphdrbnd1: TppGroupHeaderBand;
    pgrpftrbnd1: TppGroupFooterBand;
    prmtrlst1: TppParameterList;
    prmtr1: TppParameter;
    extrptns1: TExtraOptions;
    pnlAtualizacoes: TPanel;
    ppLabel1: TppLabel;
    qryGeralDES_USUARIO: TStringField;
    fltfldGeralCOD_QUEBRA: TFloatField;
    fltfldGeralCOD_UNIDADE: TFloatField;
    qryGeralDES_FANTASIA: TStringField;
    fltfldGeralTOT_CLI_COMPRAS: TFloatField;
    fltfldGeralCAD_ATUALIZADOS: TFloatField;
    fltfldGeralPER_CADASTROS_AUAL: TFloatField;
    pdbtxtPER_CADASTROS_AUAL: TppDBText;
    daDataModule1: TdaDataModule;
    procedure btnFecharClick(Sender: TObject);
    procedure btnGerarClick(Sender: TObject);
    procedure edtEmpresaExit(Sender: TObject);
    procedure edtEmpresaKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure ppRel_RetornoNoData(Sender, aDialog: TObject;
      var aShowDialog: Boolean; aDrawCommand: TObject;
      var aAddDrawCommand: Boolean);
    procedure ppRel_RetornoPreviewFormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  iNumero : Double;
  Form2: TForm2;
  sCodIni, sCodFim, sDataIni, sDataFim, sVlr_Bonus, sVlr_Compra, sRede, sMax_Dta_Atualiz : String;

  implementation

{$R *.dfm}

procedure TForm2.btnFecharClick(Sender: TObject);
begin
Close;
end;

procedure TForm2.btnGerarClick(Sender: TObject);
var  sParametros, sUsuarioT, sAuxiliar: string;
      Size        : Cardinal;

begin
     Size := 128;
     SetLength(sUsuarioT,Size);
     GetUserName(PChar(sUsuarioT), Size);
     sAuxiliar := sUsuarioT;
     sUsuarioT :=  sAuxiliar;
 Try
     qryGeral.Active := false;
     qryGeral.ParamByName('DES_USUARIO').AsString := UpperCase(sUsuarioT);
     qryGeral.Active := true;
      Except
          begin
               ShowMessage('Não Conseguiu ler os dados!');
               Abort;
               Exit;
           end;
      end;

 ppRel_Retorno.PrintReport;

   qryGeral.Active := false;

end;

procedure TForm2.edtEmpresaExit(Sender: TObject);
begin
 if edtEmpresa.Text = '' then
         edtEmpresa.Text := '1';

      Try
      iNumero := StrToFloat(Trim(edtEmpresa.Text));
      Except on EConvertError do
          begin
               ShowMessage('Valor inválido!');
               edtEmpresa.SetFocus;
               Abort;
               Exit;
           end;
      end;
end;

procedure TForm2.edtEmpresaKeyPress(Sender: TObject; var Key: Char);
var
   codigo : boolean;
   begin
//codigo : boolean
begin
    case Key of
         '0' .. '9' : codigo := true;
     //    ',' : Codigo := True;
         chr(13) : Codigo  := True; //enter
         chr(9)  : Codigo  := True; //Tab
         chr(27) : Codigo  := True; //esc
         chr(8)  : Codigo  := True; //Backspace
    else
      Codigo := False;

  end;
  if Codigo = False then
    abort;
end;


end;

procedure TForm2.FormShow(Sender: TObject);
begin
 if qryGeral.Active then
         qryGeral.Active := False;
end;

procedure TForm2.ppRel_RetornoNoData(Sender, aDialog: TObject;
  var aShowDialog: Boolean; aDrawCommand: TObject;
  var aAddDrawCommand: Boolean);
begin
     ShowMessage('Não foram encontrados dados neste período!');
     Abort;
     Exit;
end;

procedure TForm2.ppRel_RetornoPreviewFormCreate(Sender: TObject);
begin
    ppRel_Retorno.PreviewForm.WindowState := wsMaximized;
    TppViewer(ppRel_Retorno.PreviewForm.Viewer).ZoomPercentage := 100;
end;

procedure TForm2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
          VK_RETURN: Perform(WM_NEXTDLGCTL,0,0);
        //  VK_UP : Perform(WM_NEXTDLGCTL,1,0);
         VK_ESCAPE : edtEmpresa.SetFocus;
     end;
end;

end.

