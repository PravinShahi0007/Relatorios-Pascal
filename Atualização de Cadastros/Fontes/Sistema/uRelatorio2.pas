unit uRelatorio2;

interface

uses
  raCodMod,  ppSubRpt,xpman, Encryp, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ppDB, ppDBPipe, ppParameter, ppBands,ppViewr, ppClass,
  ppCtrls, ppVar, ppStrtch, ppMemo, ppPrnabl, ppCache, ppComm, ppRelatv,
  ppProd, ppReport, DB, DBTables, StdCtrls, Buttons, Mask,
  jpeg, ppModule, daDataModule, ppDesignLayer;

type

  TForm3 = class(TForm)
    lblParametro: TLabel;
    lblIntervaloini: TLabel;
    lblIntervaloFim: TLabel;
    imgGraz: TImage;
    edtPIni: TEdit;
    medtPIni: TMaskEdit;
    edtUIni: TEdit;
    edtG: TEdit;
    edtEmp: TEdit;
    edtPFim: TEdit;
    medtPFim: TMaskEdit;
    btnGerar: TBitBtn;
    btnFechar: TBitBtn;
    ssn2: TSession;
    db1: TDatabase;
    strdprc_retorno: TStoredProc;
    qryQryConsulta: TQuery;
    dsConsulta: TDataSource;
    pdbpln2: TppDBPipeline;
    pnl1: TPanel;
    prprtRel_Retorno: TppReport;
    ppHeaderBand2: TppHeaderBand;
    pshp3: TppShape;
    plblDtaII: TppLabel;
    plbl1: TppLabel;
    plbl2: TppLabel;
    psystmvrbl1: TppSystemVariable;
    psystmvrbl2: TppSystemVariable;
    plblRedeII: TppLabel;
    plbl17: TppLabel;
    plbl4: TppLabel;
    pdtlbnd1: TppDetailBand;
    pftrbnd1: TppFooterBand;
    psmrybnd1: TppSummaryBand;
    pgstyl1: TppPageStyle;
    pgrp1: TppGroup;
    pgrphdrbnd1: TppGroupHeaderBand;
    pgrpftrbnd1: TppGroupFooterBand;
    prmtrlst1: TppParameterList;
    prmtr1: TppParameter;
    pdbtxtNUM_PERFIL: TppDBText;
    edtUFim: TEdit;
    edtUsuario: TEdit;
    pnlMsgAviso: TPanel;
    lblMensagem: TLabel;
    pshp1: TppShape;
    plbl3: TppLabel;
    plbl5: TppLabel;
    pmg1: TppImage;
    plbl7: TppLabel;
    plbl9: TppLabel;
    plbl11: TppLabel;
    plbl13: TppLabel;
    plbl15: TppLabel;
    pln3: TppLine;
    pln4: TppLine;
    pln5: TppLine;
    pln6: TppLine;
    pln7: TppLine;
    plbl18: TppLabel;
    plbl19: TppLabel;
    plbl20: TppLabel;
    plbl21: TppLabel;
    plbl22: TppLabel;
    plbl23: TppLabel;
    plbl24: TppLabel;
    plbl25: TppLabel;
    pln8: TppLine;
    plbl27: TppLabel;
    plbl29: TppLabel;
    plbl31: TppLabel;
    plbl33: TppLabel;
    plbl35: TppLabel;
    plbl37: TppLabel;
    plbl40: TppLabel;
    plbl6: TppLabel;
    pdbPERFIL_5: TppDBText;
    pln1: TppLine;
    pln2: TppLine;
    pdbPERFIL_10: TppDBText;
    pdbPERFIL_20: TppDBText;
    pdbPERFIL_30: TppDBText;
    pdbPERFIL_50: TppDBText;
    plbl8: TppLabel;
    plbl10: TppLabel;
    pln9: TppLine;
    pdbtxtQTD_2: TppDBText;
    pdbtxtQTD_3: TppDBText;
    pdbPERFIL_0: TppDBText;
    edt1: TEdit;
    edt2: TEdit;
    edt3: TEdit;
    edt4: TEdit;
    edt5: TEdit;
    lbl1: TLabel;
    plbl12: TppLabel;
    plbPercPerf_0: TppLabel;
    plbPercPerf_5: TppLabel;
    plbPercPerf_10: TppLabel;
    plbPercPerf_20: TppLabel;
    plbPercPerf_30: TppLabel;
    plbPercPerf_50: TppLabel;
    plbl32: TppLabel;
    plbl34: TppLabel;
    plbl14: TppLabel;
    plbl16: TppLabel;
    plbl26: TppLabel;
    plbl28: TppLabel;
    pdbCresMes: TppDBText;
    pdbCresAno: TppDBText;
    ppLabel84: TppLabel;
    pdbclc1: TppDBCalc;
    ppDBCalc1: TppDBCalc;
    ppLabel1: TppLabel;
    ppDcalcPer0: TppDBCalc;
    ppDcalcPer5: TppDBCalc;
    ppDcalcPer10: TppDBCalc;
    ppDcalcPer20: TppDBCalc;
    ppDcalcPer30: TppDBCalc;
    ppDcalcPer50: TppDBCalc;
    ppDBCalc8: TppDBCalc;
    ppDBCalc9: TppDBCalc;
    plbPercQuebraPerf_0: TppLabel;
    plbPercQuebraPerf_5: TppLabel;
    plbPercQuebraPerf_10: TppLabel;
    plbPercQuebraPerf_20: TppLabel;
    plbPercQuebraPerf_30: TppLabel;
    plbPercQuebraPerf_50: TppLabel;
    ppLabel8: TppLabel;
    ppLabel9: TppLabel;
    ppLabel2: TppLabel;
    ppDTotCli: TppDBCalc;
    ppDTotAtu: TppDBCalc;
    ppLabel3: TppLabel;
    ppDTotPer0: TppDBCalc;
    ppDTotPer5: TppDBCalc;
    ppDTotPer10: TppDBCalc;
    ppDTotPer20: TppDBCalc;
    ppDTotPer30: TppDBCalc;
    ppDTotPer50: TppDBCalc;
    ppDBCalc18: TppDBCalc;
    ppDBCalc19: TppDBCalc;
    ppLPerTotPer0: TppLabel;
    ppLPerTotPer5: TppLabel;
    ppLPerTotPer10: TppLabel;
    ppLPerTotPer20: TppLabel;
    ppLPerTotPer30: TppLabel;
    ppLPerTotPer50: TppLabel;
    ppLabel12: TppLabel;
    ppLabel13: TppLabel;
    strngfldQryConsultaDES_USUARIO: TStringField;
    fltfldQryConsultaCOD_UNIDADE: TFloatField;
    fltfldQryConsultaCOD_QUEBRA: TFloatField;
    fltfldQryConsultaCLI_COMPRAS: TFloatField;
    fltfldQryConsultaCLI_ATUALIZADOS: TFloatField;
    fltfldQryConsultaPERFIL_0: TFloatField;
    fltfldQryConsultaPERFIL_5: TFloatField;
    fltfldQryConsultaPERFIL_10: TFloatField;
    fltfldQryConsultaPERFIL_20: TFloatField;
    fltfldQryConsultaPERFIL_30: TFloatField;
    fltfldQryConsultaPERFIL_50: TFloatField;
    fltfldQryConsultaSELECTNVLSUMNVLA1CAD_ATUA: TFloatField;
    fltfldQryConsultaSELECTNVLSUMNVLA2CAD_ATUA: TFloatField;
    procedure btnFecharClick(Sender: TObject);
    procedure prprtRel_RetornoNoData(Sender, aDialog: TObject;
      var aShowDialog: Boolean; aDrawCommand: TObject;
      var aAddDrawCommand: Boolean);
    procedure prprtRel_RetornoPreviewFormCreate(Sender: TObject);
    procedure btnGerarClick(Sender: TObject);
    procedure edtEmpExit(Sender: TObject);
    procedure edtEmpKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure edtUIniExit(Sender: TObject);
    procedure edtUFimExit(Sender: TObject);
    procedure edtPIniExit(Sender: TObject);
    procedure edtPFimExit(Sender: TObject);
    procedure edtGExit(Sender: TObject);
    procedure medtPIniExit(Sender: TObject);
    procedure medtPFimExit(Sender: TObject);
    procedure pgrpftrbnd1BeforeGenerate(Sender: TObject);
    procedure psmrybnd1BeforeGenerate(Sender: TObject);
    procedure pdtlbnd1AfterGenerate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
   iNumero : Double;
  Form3: TForm3;
  sEmpresaII,sGrupoII,dRede, sUnidadeIniII, sUnidadeFimII, sPerIniII, sPerFimII, sMax_Dta_AtualizII,sPerfI,sPerfF : String;
implementation

uses uAtualizacoes, uFuncoes, UFunc;

{$R *.dfm}

procedure TForm3.btnFecharClick(Sender: TObject);
begin
Close;
end;

procedure TForm3.prprtRel_RetornoNoData(Sender, aDialog: TObject;
  var aShowDialog: Boolean; aDrawCommand: TObject;
  var aAddDrawCommand: Boolean);
begin
 ShowMessage('N�o foram encontrados dados neste per�odo!');
     Abort;
     Exit;
end;

procedure TForm3.prprtRel_RetornoPreviewFormCreate(Sender: TObject);
begin
  prprtRel_Retorno.PreviewForm.WindowState := wsMaximized;
    TppViewer(prprtRel_Retorno.PreviewForm.Viewer).ZoomPercentage := 100;
end;

procedure TForm3.btnGerarClick(Sender: TObject);
var  dParametros, sUsuarioII : string;
      Size        : Cardinal;
begin
  lblMensagem.Caption := '          Aguarde.....           '+#13+
                         '     Gerando Relat�rio.....      ';
 pnlMsgAviso.Visible := true;
 pnlMsgAviso.Update;

begin
    Size := 128;
     SetLength(sUsuarioII,Size);
     GetUserName(PChar(sUsuarioII), Size);
     edtUsuario.Text := sUsuarioII;
     sUsuarioII :=  edtUsuario.Text;

    sEmpresaII:= edtEmp.Text;
   sGrupoII:=edtG.Text;
   sUnidadeIniII := edtUIni.Text;
   sUnidadeFimII := edtUFim.Text;
   sPerIniII:= medtPIni.Text;
   sPerFimII:= medtPFim.Text;
   sPerfI:= edtPIni.Text;
   sPerfF:= edtPFim.Text;

    strdprc_retorno.close;
  dParametros := ''+sEmpresaII+'#'+sGrupoII+'#'+sUnidadeIniII+'#'+sUnidadeFimII+'#'+sPerIniII+'#'+sPerFimII+'#'+sPerfI+'#'+sPerfF+'#'+sUsuarioII+'#';
  strdprc_retorno.Prepare;
     strdprc_retorno.Params[0].Value := dParametros;
     strdprc_retorno.ExecProc;
 Try
     qryQryConsulta.Active := false;
     qryQryConsulta.ParamByName('DES_USUARIO').AsString := UpperCase(sUsuarioII);
     qryQryConsulta.Active := true;
      Except
          begin
               ShowMessage('N�o Conseguiu ler os dados!');
               Abort;
               Exit;
           end;
      end;
   if edtG.Text = '910' then
         dRede := 'GRAZZIOTIN'
      else if edtG.Text = '930' then
              dRede := 'POR MENOS'
           else if  edtG.Text = '940' then
                   dRede := 'FRANCO GIORGI'
                else if edtG.Text = '950' then
                   dRede := 'TOTTAL';
       pnlMsgAviso.Visible := False;
     pnlMsgAviso.Update;
   plblDtaII.Caption := 'Periodo Refer�ncia '+medtPIni.Text+' a '+medtPFiM.Text+'';
   plblRedeII.Caption := 'REDE '+dRede;
 prprtRel_Retorno.PrintReport;

  qryQryConsulta.Active := false;
end;

end;
procedure TForm3.edtEmpExit(Sender: TObject);
begin
if edtEmp.Text = '' then
         edtEmp.Text := '1';

      Try
      iNumero := StrToFloat(Trim(edtEmp.Text));
      Except on EConvertError do
          begin
               ShowMessage('Valor inv�lido!');
               edtEmp.SetFocus;
               Abort;
               Exit;
           end;
      end;
end;




procedure TForm3.edtEmpKeyPress(Sender: TObject; var Key: Char);
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
procedure TForm3.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 case Key of
          VK_RETURN: Perform(WM_NEXTDLGCTL,0,0);
        //  VK_UP : Perform(WM_NEXTDLGCTL,1,0);
         VK_ESCAPE : edtEmp.SetFocus;
     end;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
 if qryQryConsulta.Active then
         qryQryConsulta.Active := False;
end;

procedure TForm3.edtUIniExit(Sender: TObject);
begin
     if (AllTrim(edtUIni.Text) = '') then
          edtUIni.Text := '000';
      if ValidaNum(edtUIni.Text) then
   begin
      Informacao('Valor Inv�lido!!!','Aten��o!!!');
      edtUIni.SetFocus;
      Abort;
      Exit;
   end;
end;

procedure TForm3.edtUFimExit(Sender: TObject);
begin
edtUIniExit(Sender);
   if (AllTrim(edtUFim.Text) = '') then
      edtUFim.Text := '999';
   if ValidaNum(edtUFim.Text) then
   begin
      Informacao('Valor Inv�lido!!!','Aten��o!!!');
      edtUFim.SetFocus;
      Abort;
      Exit;
   end;
   if (StrToInt(edtUFim.Text) < StrToInt(edtUIni.Text)) then
   begin
      Informacao('Unidade Inicial n�o pode ser Maior que Unidade Final','Aten��o!!!');
      edtUIni.SetFocus;
      Abort;
      Exit;
   end;
end;

procedure TForm3.edtPIniExit(Sender: TObject);
begin
  if (AllTrim(edtPIni.Text) = '') then
      edtPIni.Text := '0';
   if ValidaNum(edtPIni.Text) then
   begin
      Informacao('Valor Inv�lido!!!','Aten��o!!!');
      edtPIni.SetFocus;
      Abort;
      Exit;
   end;
end;

procedure TForm3.edtPFimExit(Sender: TObject);
begin
  edtPIniExit(Sender);
   if (AllTrim(edtPFim.Text) = '') then
      edtPFim.Text := '99';
   if ValidaNum(edtPFim.Text) then
   begin
      Informacao('Valor Inv�lido!!!','Aten��o!!!');
      edtPFim.SetFocus;
      Abort;
      Exit;
   end;
   if (StrToInt(edtPIni.Text) > StrToInt(edtUFim.Text)) then
   begin
      Informacao('Perfil Inicial n�o pode ser Maior que Perfil Final','Aten��o!!!');
      edtUIni.SetFocus;
      Abort;
      Exit;
   end;
end;

procedure TForm3.edtGExit(Sender: TObject);
begin
   if (AllTrim(edtG.Text) = '') then
   begin
      Informacao('Valor Inv�lido!!!','Aten��o!!!');
      edtG.SetFocus;
      Abort;
      Exit;
   end;
end;

procedure TForm3.medtPIniExit(Sender: TObject);
begin
   if (AllTrim(medtPIni.Text) = '') then
   begin
      Informacao('Informe a Data Emiss�o Inicial!','Aten��o!!!');
      medtPIni.SetFocus;
      Abort;
      Exit;
   end;
   if (Length(AllTrim(medtPIni.Text)) < 10) then
   begin
      Informacao('Informe a Data Emiss�o Inicial!','Aten��o!!!');
      medtPIni.SetFocus;
      Abort;
      Exit;
   end;
   if ValidaData(medtPIni.Text) then
   begin
      Informacao('Data Inv�lida!','Aten��o!!!');
      medtPIni.SetFocus;
      Abort;
      Exit;
end;
    end;
procedure TForm3.medtPFimExit(Sender: TObject);
begin
   medtPIniExit(Sender);
   if (AllTrim(medtPFim.Text) = '') then
   begin
      Informacao('Informe a Data Emiss�o Final!','Aten��o!!!');
      medtPFim.SetFocus;
      Abort;
      Exit;
   end;
   if (Length(AllTrim(medtPFim.Text)) < 10) then
   begin
      Informacao('Informe a Data Emiss�o Final!','Aten��o!!!');
      medtPFim.SetFocus;
      Abort;
      Exit;
   end;
   if ValidaData(medtPFim.Text) then
   begin
      Informacao('Data Inv�lida!','Aten��o!!!');
      medtPFim.SetFocus;
      Abort;
      Exit;
   end;
   if (StrtoDate(medtPFim.Text) < StrtoDate(medtPIni.Text)) then
   begin
      Informacao('Data Inicial n�o pode ser maior que Data Final!','Aten��o!!!');
      medtPIni.SetFocus;
      Abort;
      Exit;
   end;
end;

procedure TForm3.pgrpftrbnd1BeforeGenerate(Sender: TObject);
begin

   try
     IF( Trim(ppDBCalc1.Text) ='0' ) THEN
     BEGIN
      ppLabel1.Caption  := '0' ;
     END ELSE
     begin
     ppLabel1.Caption  := FormatFloat('#.#',((StrToCurrDef(fRetiraPonto(ppDBCalc1.Text),0) * 100) / (StrToCurrDef(fRetiraPonto(pdbclc1.Text),0))));
     end;
      except
       ppLabel1.Caption := '0';
       end;
   try
      IF( Trim(ppDcalcPer0.Text) ='0' ) THEN
     BEGIN
      plbPercQuebraPerf_0.Caption  := '0' ;
     END ELSE
   begin
    plbPercQuebraPerf_0.Caption  := FormatFloat('#.#',((StrToCurrDef(fRetiraPonto(ppDcalcPer0.Text),0) * 100) / (StrToCurrDef(fRetiraPonto(ppDBCalc1.Text),0))));
    end;
  except
    plbPercQuebraPerf_0.Caption := '0';
   end;
     try
        IF( Trim(ppDcalcPer5.Text) ='0' ) THEN
     BEGIN
      plbPercQuebraPerf_5.Caption  := '0' ;
     END ELSE
        begin
      plbPercQuebraPerf_5.Caption  := FormatFloat('#.#',((StrToCurrDef(fRetiraPonto(ppDcalcPer5.Text),0) * 100) / (StrToCurrDef(fRetiraPonto(ppDBCalc1.Text),0))));
       end;
  except
    plbPercQuebraPerf_5.Caption := '0';
   end;
    try
      IF( Trim(ppDcalcPer10.Text) ='0' ) THEN
     BEGIN
      plbPercQuebraPerf_10.Caption  := '0' ;
     END ELSE
    begin
     plbPercQuebraPerf_10.Caption  := FormatFloat('#.#',((StrToCurrDef(fRetiraPonto(ppDcalcPer10.Text),0) * 100) / (StrToCurrDef(fRetiraPonto(ppDBCalc1.Text),0))));
     end;
  except
    plbPercQuebraPerf_10.Caption := '0';
   end;
     try
          IF( Trim(ppDcalcPer20.Text) ='0' ) THEN
     BEGIN
      plbPercQuebraPerf_20.Caption  := '0' ;
     END ELSE
       begin
      plbPercQuebraPerf_20.Caption  := FormatFloat('#.#',((StrToCurrDef(fRetiraPonto(ppDcalcPer20.Text),0) * 100) / (StrToCurrDef(fRetiraPonto(ppDBCalc1.Text),0))));
      end;
  except
    plbPercQuebraPerf_20.Caption := '0';
   end;
      try
        IF( Trim(ppDcalcPer30.Text) ='0' ) THEN
     BEGIN
      plbPercQuebraPerf_30.Caption  := '0' ;
     END ELSE
       begin
       plbPercQuebraPerf_30.Caption  := FormatFloat('#.#',((StrToCurrDef(fRetiraPonto(ppDcalcPer30.Text),0) * 100) / (StrToCurrDef(fRetiraPonto(ppDBCalc1.Text),0))));
     end;
  except
    plbPercQuebraPerf_30.Caption := '0';
   end;
   try
          IF( Trim(ppDcalcPer50.Text) ='0' ) THEN
     BEGIN
      plbPercQuebraPerf_50.Caption  := '0' ;
     END ELSE
     begin
   plbPercQuebraPerf_50.Caption  := FormatFloat('#.#',((StrToCurrDef(fRetiraPonto(ppDcalcPer50.Text),0) * 100) / (StrToCurrDef(fRetiraPonto(ppDBCalc1.Text),0))));
    end;
  except
    plbPercQuebraPerf_50.Caption := '0';
   end;
    try
     IF( Trim(ppDBCalc18.Text) ='0' ) THEN
     BEGIN
      ppLabel8.Caption  := '0' ;
     END ELSE
      IF ( Trim(ppDBCalc18.Text) = (ppDBCalc1.Text)) THEN
     BEGIN
      ppLabel8.Caption  := '0' ;
     END ELSE
     BEGIN
          ppLabel8.Caption  := FormatFloat('#.#',((((StrToCurrDef(fRetiraPonto(ppDBCalc1.Text),0) ) - (StrToCurrDef(fRetiraPonto(ppDBCalc8.Text),0))) /(StrToCurrDef(fRetiraPonto(ppDBCalc8.Text),0))) * 100 ));

     end;
  except
    ppLabel8.Caption := '0';
   end;

   try
     IF( Trim(ppDBCalc9.Text) ='0' ) THEN
     BEGIN
      ppLabel9.Caption  := '0' ;
     END ELSE
     IF ( Trim(ppDBCalc9.Text) = (ppDBCalc1.Text)) THEN
     BEGIN
      ppLabel9.Caption  := '0' ;
     END ELSE
     BEGIN
         ppLabel9.Caption  := FormatFloat('#.#',((((StrToCurrDef(fRetiraPonto(ppDBCalc1.Text),0) ) - (StrToCurrDef(fRetiraPonto(ppDBCalc9.Text),0))) /(StrToCurrDef(fRetiraPonto(ppDBCalc9.Text),0))) * 100 ));


     end;
  except
    ppLabel9.Caption := '0';
   end;

end;

procedure TForm3.psmrybnd1BeforeGenerate(Sender: TObject);
begin
 try
     IF( Trim(ppDTotAtu.Text) ='0' ) THEN
     BEGIN
      ppLabel3.Caption  := '0' ;
     END ELSE
   begin
     ppLabel3.Caption  := FormatFloat('#.#',((StrToCurrDef(fRetiraPonto(ppDTotAtu.Text),0) * 100) / (StrToCurrDef(fRetiraPonto(ppDTotCli.Text),0))));
    end;
  except
    ppLabel3.Caption := '0';
   end;
   try
     IF( Trim(ppDTotPer0.Text) ='0' ) THEN
     BEGIN
      ppLPerTotPer0.Caption  := '0' ;
     END ELSE
    begin
    ppLPerTotPer0.Caption  := FormatFloat('#.#',((StrToCurrDef(fRetiraPonto(ppDTotPer0.Text),0) * 100) / (StrToCurrDef(fRetiraPonto(ppDTotAtu.Text),0))));
    end;
  except
    ppLPerTotPer0.Caption := '0';
   end;
     try
       IF( Trim(ppDTotPer5.Text) ='0' ) THEN
     BEGIN
      ppLPerTotPer5.Caption  := '0' ;
     END ELSE
      begin
      ppLPerTotPer5.Caption  := FormatFloat('#.#',((StrToCurrDef(fRetiraPonto(ppDTotPer5.Text),0) * 100) / (StrToCurrDef(fRetiraPonto(ppDTotAtu.Text),0))));
      end;
  except
    ppLPerTotPer5.Caption := '0';
   end;
    try
      IF( Trim(ppDTotPer10.Text) ='0' ) THEN
     BEGIN
      ppLPerTotPer10.Caption  := '0' ;
     END ELSE
      begin
     ppLPerTotPer10.Caption  := FormatFloat('#.#',((StrToCurrDef(fRetiraPonto(ppDTotPer10.Text),0) * 100) / (StrToCurrDef(fRetiraPonto(ppDTotAtu.Text),0))));
     end;
  except
    ppLPerTotPer10.Caption := '0';
   end;
     try
       IF( Trim(ppDTotPer20.Text) ='0' ) THEN
     BEGIN
      ppLPerTotPer20.Caption  := '0' ;
     END ELSE
     begin
      ppLPerTotPer20.Caption  := FormatFloat('#.#',((StrToCurrDef(fRetiraPonto(ppDTotPer20.Text),0) * 100) / (StrToCurrDef(fRetiraPonto(ppDTotAtu.Text),0))));
      end;
  except
    ppLPerTotPer20.Caption := '0';
   end;
      try
        IF( Trim(ppDTotPer30.Text) ='0' ) THEN
     BEGIN
      ppLPerTotPer30.Caption  := '0' ;
     END ELSE
      begin
       ppLPerTotPer30.Caption  := FormatFloat('#.#',((StrToCurrDef(fRetiraPonto(ppDTotPer30.Text),0) * 100) / (StrToCurrDef(fRetiraPonto(ppDTotAtu.Text),0))));
       end;
  except
    ppLPerTotPer30.Caption := '0';
   end;
     try
       IF( Trim(ppDTotPer50.Text) ='0' ) THEN
     BEGIN
      ppLPerTotPer50.Caption  := '0' ;
     END ELSE
     begin
     ppLPerTotPer50.Caption  := FormatFloat('#.#',((StrToCurrDef(fRetiraPonto(ppDTotPer50.Text),0) * 100) / (StrToCurrDef(fRetiraPonto(ppDTotAtu.Text),0))));
    end;
  except
    ppLPerTotPer50.Caption := '0';
   end;

      try
     IF( Trim(ppDBCalc18.Text) ='0' ) THEN
     BEGIN
      ppLabel12.Caption  := '0' ;
     END ELSE
      IF ( Trim(ppDBCalc18.Text) = (ppDTotAtu.Text)) THEN
     BEGIN
      ppLabel12.Caption  := '0' ;
     END ELSE
     BEGIN
          ppLabel12.Caption  := FormatFloat('#.#',((((StrToCurrDef(fRetiraPonto(ppDTotAtu.Text),0) ) - (StrToCurrDef(fRetiraPonto(ppDBCalc18.Text),0))) /(StrToCurrDef(fRetiraPonto(ppDBCalc18.Text),0))) * 100 ));

     end;
  except
    ppLabel12.Caption := '0';
   end;

   try
     IF( Trim(ppDBCalc19.Text) ='0' ) THEN
     BEGIN
      ppLabel13.Caption  := '0' ;
     END ELSE
      IF ( Trim(ppDBCalc19.Text) = (ppDTotAtu.Text)) THEN
     BEGIN
      ppLabel13.Caption  := '0' ;
     END ELSE
     BEGIN
         ppLabel13.Caption  := FormatFloat('#.#',((((StrToCurrDef(fRetiraPonto(ppDTotAtu.Text),0) ) - (StrToCurrDef(fRetiraPonto(ppDBCalc19.Text),0))) /(StrToCurrDef(fRetiraPonto(ppDBCalc19.Text),0))) * 100 ));


     end;
  except
    ppLabel13.Caption := '0';
   end;
end;

procedure TForm3.pdtlbnd1AfterGenerate(Sender: TObject);
begin
       try
         IF( Trim(pdbtxtQTD_2.Text) ='0' ) THEN
     BEGIN
      plbl12.Caption  := '0' ;
     END ELSE
       begin
       plbl12.Caption  := FormatFloat('#.#',((StrToCurrDef(fRetiraPonto(pdbtxtQTD_2.Text),0) * 100) / (StrToCurrDef(fRetiraPonto(pdbtxtQTD_3.Text),0))));
        end;
  except
    plbl12.Caption := '0';
   end;

   try
    IF( Trim(pdbPERFIL_0.Text) ='0' ) THEN
     BEGIN
      plbPercPerf_0.Caption  := '0' ;
     END ELSE
   begin
   plbPercPerf_0.Caption  := FormatFloat('#.#',((StrToCurrDef(fRetiraPonto(pdbPERFIL_0.Text),0) * 100) / (StrToCurrDef(fRetiraPonto(pdbtxtQTD_2.Text),0))));
   end;
  except
    plbPercPerf_0.Caption := '0';
   end;

     try
      IF( Trim(pdbPERFIL_5.Text) ='0' ) THEN
     BEGIN
      plbPercPerf_5.Caption  := '0' ;
     END ELSE
      begin
      plbPercPerf_5.Caption  := FormatFloat('#.#',((StrToCurrDef(fRetiraPonto(pdbPERFIL_5.Text),0) * 100) / (StrToCurrDef(fRetiraPonto(pdbtxtQTD_2.Text),0))));
      end;
  except
    plbPercPerf_5.Caption := '0';
   end;
      try
        IF( Trim(pdbPERFIL_10.Text) ='0' ) THEN
     BEGIN
      plbPercPerf_10.Caption  := '0' ;
     END ELSE
      begin
       plbPercPerf_10.Caption  := FormatFloat('#.#',((StrToCurrDef(fRetiraPonto(pdbPERFIL_10.Text),0) * 100) / (StrToCurrDef(fRetiraPonto(pdbtxtQTD_2.Text),0))));
      end;
  except
    plbPercPerf_10.Caption := '0';
   end;
     try
       IF( Trim(pdbPERFIL_20.Text) ='0' ) THEN
     BEGIN
      plbPercPerf_20.Caption  := '0' ;
     END ELSE
     begin
      plbPercPerf_20.Caption  := FormatFloat('#.#',((StrToCurrDef(fRetiraPonto(pdbPERFIL_20.Text),0) * 100) / (StrToCurrDef(fRetiraPonto(pdbtxtQTD_2.Text),0))));
     end;
  except
    plbPercPerf_20.Caption := '0';
   end;
         try
           IF( Trim(pdbPERFIL_30.Text) ='0' ) THEN
     BEGIN
      plbPercPerf_30.Caption  := '0' ;
     END ELSE
         begin
         plbPercPerf_30.Caption  := FormatFloat('#.#',((StrToCurrDef(fRetiraPonto(pdbPERFIL_30.Text),0) * 100) / (StrToCurrDef(fRetiraPonto(pdbtxtQTD_2.Text),0))));
         end;
  except
    plbPercPerf_30.Caption := '0';
   end;
     try
       IF( Trim(pdbPERFIL_50.Text) ='0' ) THEN
     BEGIN
      plbPercPerf_50.Caption  := '0' ;
     END ELSE
     begin
      plbPercPerf_50.Caption  := FormatFloat('#.#',((StrToCurrDef(fRetiraPonto(pdbPERFIL_50.Text),0) * 100) / (StrToCurrDef(fRetiraPonto(pdbtxtQTD_2.Text),0))));
     end;
  except
    plbPercPerf_50.Caption := '0';
   end;

    try
     IF( Trim(pdbCresMes.Text) ='0' ) THEN
     BEGIN
      plbl32.Caption  := '0' ;
     END ELSE
       IF ( Trim(pdbCresMes.Text) = (pdbtxtQTD_2.Text)) THEN
     BEGIN
      plbl32.Caption  := '0' ;
     END ELSE
     BEGIN
          plbl32.Caption  := FormatFloat('#.#',((((StrToCurrDef(fRetiraPonto(pdbtxtQTD_2.Text),0) ) - (StrToCurrDef(fRetiraPonto(pdbCresMes.Text),0))) /(StrToCurrDef(fRetiraPonto(pdbCresMes.Text),0))) * 100 ));

     end;
  except
    plbl32.Caption := '0';
   end;

   try
     IF( Trim(pdbCresAno.Text) ='0' ) THEN
     BEGIN
      plbl34.Caption  := '0' ;
     END ELSE
       IF ( Trim(pdbCresAno.Text) = (pdbtxtQTD_2.Text)) THEN
     BEGIN
      plbl34.Caption  := '0' ;
     END ELSE
     BEGIN
          plbl34.Caption  := FormatFloat('#.#',((((StrToCurrDef(fRetiraPonto(pdbtxtQTD_2.Text),0) ) - (StrToCurrDef(fRetiraPonto(pdbCresAno.Text),0))) /(StrToCurrDef(fRetiraPonto(pdbCresAno.Text),0))) * 100 ));


     end;
  except
    plbl34.Caption := '0';
   end;

end;

end.
