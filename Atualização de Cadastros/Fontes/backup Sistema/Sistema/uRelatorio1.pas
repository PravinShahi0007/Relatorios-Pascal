unit uRelatorio1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ppParameter, Encryp, ppCtrls,
  ppBands, ppClass,ppViewr,
  ppVar, ppStrtch,
  Buttons, Mask, ppPrnabl, ppCache, ppProd, ppReport, ppDB,
  ppComm, ppRelatv, ppDBPipe, DBTables, DB, StdCtrls, jpeg,  OleCtrls,
  ppModule, daDataModule, ppMemo, raCodMod, ppDesignLayer;



type
  TForm2 = class(TForm)
    lblParametro: TLabel;
    lblIntervaloini: TLabel;
    lblIntervaloFim: TLabel;
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
    pshp3: TppShape;
    pshp4: TppShape;
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
    prmtrlst1: TppParameterList;
    prmtr1: TppParameter;
    pnlAtualizacoes: TPanel;
    ppLabel1: TppLabel;
    ppPageStyle1: TppPageStyle;
    pgrp1: TppGroup;
    pgrphdrbnd1: TppGroupHeaderBand;
    pgrpftrbnd1: TppGroupFooterBand;
    edt1: TEdit;
    ppLabel84: TppLabel;
    ppdbClicompras: TppDBCalc;
    pdbCadAtualizados: TppDBCalc;
    plbResultado: TppLabel;
    plbl4: TppLabel;
    pdbclcTOT_CLI_COMPRAS: TppDBCalc;
    pdbclcCAD_ATUALIZADOS: TppDBCalc;
    plbl5: TppLabel;
    pnlMsgAviso: TPanel;
    lblMensagem: TLabel;
    pmg1: TppImage;
    edt3: TEdit;
    edt2: TEdit;
    edt4: TEdit;
    ppLabel2: TppLabel;
    fltfldGeralCOD_GRUPO: TFloatField;
    fltfldGeralCOD_QUEBRA: TFloatField;
    fltfldGeralCOD_UNIDADE: TFloatField;
    strngfldGeralDES_FANTASIA: TStringField;
    fltfldGeralCOUNTDISTINCTCLI_COMPRAS: TFloatField;
    fltfldGeralSUMCAD_ATUALIZADOS: TFloatField;
    ppLabel3: TppLabel;
    pdbtxtCOD_QUEBRA: TppDBText;
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
    procedure psmrybnd1AfterPrint(Sender: TObject);
    procedure pgrpftrbnd1BeforeGenerate(Sender: TObject);
    procedure medtPeriodoIniExit(Sender: TObject);
    procedure medtPeriodoFimExit(Sender: TObject);
    procedure edtGrupoExit(Sender: TObject);
    procedure pdtlbnd1BeforeGenerate(Sender: TObject);
//    procedure pftrbnd1AfterPrint(Sender: TObject);
//    procedure ppPageStyle1AfterPrint(Sender: TObject);
//    procedure psmrybnd1AfterPrint(Sender: TObject);
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

uses uAtualizacoes, UFunc, uFuncoes;

{$R *.dfm}

procedure TForm2.btnFecharClick(Sender: TObject);
begin
Close;
end;

procedure TForm2.btnGerarClick(Sender: TObject);
var  sParametros, sUsuarioT,sEmpresa,sGrupo,sPerIni,sPerFim,sSelect: string;
      Size        : Cardinal;
 begin
 lblMensagem.Caption := '        Aguarde.....           '+#13+
                        '   Gerando Relat?rio.....      ';
 pnlMsgAviso.Visible := true;
 pnlMsgAviso.Update;

begin
     Size := 128;
     SetLength(sUsuarioT,Size);
     GetUserName(PChar(sUsuarioT), Size);
     edt1.Text := sUsuarioT;
     sUsuarioT :=  edt1.Text;

    sEmpresa:= edtEmpresa.Text;
   sGrupo:=edtGrupo.Text;
   sPerIni:= medtPeriodoIni.Text;
   sPerFim:= medtPeriodoFim.Text;

   strdprc_frete.close;
  sParametros := ''+sEmpresa+'#'+sGrupo+'#'+sPerIni+'#'+sPerFim+'#'+sUsuarioT+'#';
  strdprc_frete.Prepare;
     strdprc_frete.Params[0].Value := sParametros;
     strdprc_frete.ExecProc;

 Try
    qryGeral.Active:= False;
    qryGeral.ParamByName('DES_USUARIO').AsString :=sUsuarioT;
    qryGeral.Active := true;
      Except
          begin
               ShowMessage('N?o Conseguiu ler os dados!');
               Abort;
               Exit;
           end;
      end;

    if edtGrupo.Text = '910' then
         sRede := 'GRAZZIOTIN'
      else if edtGrupo.Text = '930' then
              sRede := 'POR MENOS'
           else if  edtGrupo.Text = '940' then
                   sRede := 'FRANCO GIORGI'
                else if edtGrupo.Text = '950' then
                   sRede := 'TOTTAL';

    pnlMsgAviso.Visible := False;
     pnlMsgAviso.Update;

   plblDta.Caption := 'Periodo Refer?ncia '+medtPeriodoIni.Text+' a '+medtPeriodoFiM.Text+'';

   plblRede.Caption := 'REDE '+sRede;
   ppRel_Retorno.PrintReport;

end;
end;
procedure TForm2.edtEmpresaExit(Sender: TObject);
begin
 if edtEmpresa.Text = '' then
         edtEmpresa.Text := '1';

      Try
      iNumero := StrToFloat(Trim(edtEmpresa.Text));
      Except on EConvertError do
          begin
               ShowMessage('Valor inv?lido!');
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
     ShowMessage('N?o foram encontrados dados neste per?odo!');
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


procedure TForm2.psmrybnd1AfterPrint(Sender: TObject);
begin
            try plbl5.Caption  := FormatFloat('#.##',((StrToCurrDef((pdbclcCAD_ATUALIZADOS.Text),0) * 100) / (StrToCurrDef((pdbclcTOT_CLI_COMPRAS.Text),0))));

  except
    plbl5.Caption := '0';
   end;
end;

procedure TForm2.pgrpftrbnd1BeforeGenerate(Sender: TObject);
begin
  try plbResultado.Caption  := FormatFloat('#.##',((StrToCurrDef((pdbCadAtualizados.Text),0) * 100) / (StrToCurrDef((ppdbClicompras.Text),0))));

  except
    plbResultado.Caption := '0';
   end;
end;

procedure TForm2.medtPeriodoIniExit(Sender: TObject);
begin
   if (AllTrim(medtPeriodoIni.Text) = '') then
   begin
      Informacao('Informe a Data Emiss?o Inicial!','Aten??o!!!');
      medtPeriodoIni.SetFocus;
      Abort;
      Exit;
   end;
   if (Length(AllTrim(medtPeriodoIni.Text)) < 10) then
   begin
      Informacao('Informe a Data Emiss?o Inicial!','Aten??o!!!');
      medtPeriodoIni.SetFocus;
      Abort;
      Exit;
   end;
   if ValidaData(medtPeriodoIni.Text) then
   begin
      Informacao('Data Inv?lida!','Aten??o!!!');
      medtPeriodoIni.SetFocus;
      Abort;
      Exit;
end;
end;

procedure TForm2.medtPeriodoFimExit(Sender: TObject);
begin
   medtPeriodoIniExit(Sender);
   if (AllTrim(medtPeriodoFim.Text) = '') then
   begin
      Informacao('Informe a Data Emiss?o Final!','Aten??o!!!');
      medtPeriodoFim.SetFocus;
      Abort;
      Exit;
   end;
   if (Length(AllTrim(medtPeriodoFim.Text)) < 10) then
   begin
      Informacao('Informe a Data Emiss?o Final!','Aten??o!!!');
      medtPeriodoFim.SetFocus;
      Abort;
      Exit;
   end;
   if ValidaData(medtPeriodoFim.Text) then
   begin
      Informacao('Data Inv?lida!','Aten??o!!!');
      medtPeriodoFim.SetFocus;
      Abort;
      Exit;
   end;
   if (StrtoDate(medtPeriodoFim.Text) < StrtoDate(medtPeriodoIni.Text)) then
   begin
      Informacao('Data Inicial n?o pode ser maior que Data Final!','Aten??o!!!');
      medtPeriodoIni.SetFocus;
      Abort;
      Exit;
   end;
end;

procedure TForm2.edtGrupoExit(Sender: TObject);
begin
if (AllTrim(edtGrupo.Text) = '') then
   begin
      Informacao('Valor Inv?lido!!!','Aten??o!!!');
      edtGrupo.SetFocus;
      Abort;
      Exit;
   end;
end;

procedure TForm2.pdtlbnd1BeforeGenerate(Sender: TObject);
begin
          try ppLabel2.Caption  := FormatFloat('#.#',((StrToCurrDef((pdbtxtDescontos.Text),0) * 100) / (StrToCurrDef((pdbtxtVnda_Liq_Loja.Text),0))));

  except
    ppLabel2.Caption := '0';
   end;
end;

end.

