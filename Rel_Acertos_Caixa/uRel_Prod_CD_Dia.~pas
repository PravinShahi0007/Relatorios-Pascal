unit uRel_Prod_CD_Dia;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, Mask, ExtCtrls, ppParameter,
  ppCtrls, ppBands, ppClass, jpeg, ppPrnabl, ppVar, ppCache, ppProd,
  ppReport, ppComm, ppRelatv, ppDB, ppDBPipe, DB, DBTables, ppViewr, Encryp,
  ppStrtch, ppRegion, TXComp, TXRB, Xpman, ppModule, raCodMod;

type
  TfrmRel_Prod_CD = class(TForm)
    Panel1: TPanel;
    Panel7: TPanel;
    Label9: TLabel;
    Label10: TLabel;
    edtDataFinal: TMaskEdit;
    edtDataInicial: TMaskEdit;
    pnlbuttons: TPanel;
    pnlDisplay: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Database1: TDatabase;
    StpRel_Prod_CD: TStoredProc;
    Session1: TSession;
    qryRel: TQuery;
    DataSource1: TDataSource;
    pprRelatorio: TppReport;
    ppParameterList1: TppParameterList;
    qryConsulta: TQuery;
    TomEncryption1: TTomEncryption;
    ExtraOptions1: TExtraOptions;
    pprRelatorio_1: TppReport;
    pplblTot_Qtd_M3_Env : TppLabel;
    ppParameterList2: TppParameterList;
    ppDBPipeline1: TppDBPipeline;
    ppCabecalho: TppHeaderBand;
    ppShape2: TppShape;
    ppShape1: TppShape;
    ppSystemVariable3: TppSystemVariable;
    ppLabel9: TppLabel;
    ppLabel10: TppLabel;
    ppLabel16: TppLabel;
    ppLabel4: TppLabel;
    ppLabel14: TppLabel;
    pplblDescricao: TppLabel;
    ppLabel26: TppLabel;
    ppSystemVariable1: TppSystemVariable;
    ppImage1: TppImage;
    ppLabel36: TppLabel;
    ppLabel1: TppLabel;
    ppLabel3: TppLabel;
    ppLabel41: TppLabel;
    ppLabel42: TppLabel;
    ppLabel43: TppLabel;
    ppLabel47: TppLabel;
    ppLabel48: TppLabel;
    ppLabel49: TppLabel;
    ppLabel22: TppLabel;
    ppLabel23: TppLabel;
    ppLabel11: TppLabel;
    ppLabel8: TppLabel;
    ppLabel12: TppLabel;
    ppLabel15: TppLabel;
    ppLabel27: TppLabel;
    ppLabel28: TppLabel;
    ppLabel29: TppLabel;
    ppLabel30: TppLabel;
    ppLabel31: TppLabel;
    ppLabel32: TppLabel;
    ppLabel33: TppLabel;
    ppLabel34: TppLabel;
    ppLabel35: TppLabel;
    ppLabel53: TppLabel;
    ppLabel54: TppLabel;
    ppLabel55: TppLabel;
    ppLabel59: TppLabel;
    ppLabel60: TppLabel;
    ppLabel61: TppLabel;
    ppLabel71: TppLabel;
    ppLabel72: TppLabel;
    ppLabel73: TppLabel;
    ppLabel77: TppLabel;
    ppLabel78: TppLabel;
    ppLabel79: TppLabel;
    ppLabel83: TppLabel;
    ppLabel84: TppLabel;
    ppLabel85: TppLabel;
    ppLabel89: TppLabel;
    ppLabel90: TppLabel;
    ppLabel91: TppLabel;
    ppLabel62: TppLabel;
    ppLabel63: TppLabel;
    ppLabel64: TppLabel;
    ppLabel166: TppLabel;
    ppLabel167: TppLabel;
    ppLabel168: TppLabel;
    ppLabel173: TppLabel;
    ppLabel174: TppLabel;
    ppLabel175: TppLabel;
    ppDetalhes: TppDetailBand;
    ppdbtxtUnidade_Quebra: TppDBText;
    pplblSinal_Unidade_Quebra: TppLabel;
    ppDBText2: TppDBText;
    ppDBText5: TppDBText;
    ppDBText7: TppDBText;
    ppDBText8: TppDBText;
    ppDBText11: TppDBText;
    ppDBText15: TppDBText;
    ppDBText17: TppDBText;
    ppDBText19: TppDBText;
    ppDBText20: TppDBText;
    ppDBText22: TppDBText;
    ppDBText23: TppDBText;
    ppDBText25: TppDBText;
    ppShape5: TppShape;
    ppDBText51: TppDBText;
    ppDBText53: TppDBText;
    ppFooterBand: TppFooterBand;
    ppGroup2: TppGroup;
    ppCabecalhoMesAno: TppGroupHeaderBand;
    ppdbtxtMes_Ano: TppDBText;
    pgrpftrbndRodapeMesAno: TppGroupFooterBand;
    ppLineTudoFooter: TppLine;
    ppLabel25: TppLabel;
    ppShape6: TppShape;
    ppGroup1: TppGroup;
    pgrphdrbndCabecalhoCodUnidade: TppGroupHeaderBand;
    ppdbtxtUnidade: TppDBText;
    ppdbtxtQtd_Nfe_Rec: TppDBText;
    ppdbtxtQtd_Vol_Rec: TppDBText;
    ppdbtxtQtd_Pecas_Rec: TppDBText;
    ppdbtxtMedia_Pecas_Vol_Rec: TppDBText;
    ppdbtxtMedia_Pecas_Nfe_Rec: TppDBText;
    ppdbtxtQtd_Nfe_Env: TppDBText;
    ppdbtxtQtd_M3_Env: TppDBText;
    ppdbtxtQtd_Pecas_Env: TppDBText;
    ppdbtxtMedia_Pecas_Nfe_Env: TppDBText;
    ppdbtxtQtd_Lotes_Env: TppDBText;
    ppdbtxtMedia_Lotes_Nfe_Env: TppDBText;
    ppdbtxtQtd_Linhas_Env: TppDBText;
    ppdbtxtMedia_Linhas_Nfe_Env: TppDBText;
    ppdbtxtQtd_Lojas_Env: TppDBText;
    ppLineHeader: TppLine;
    ppShape4: TppShape;
    ppdbtxtQtd_Vol_Env: TppDBText;
    ppdbtxtMedia_Pecas_Vol_Env: TppDBText;
    ppdbtxtMedia_Pecas_M3_Env: TppDBText;
    ppRodapeCodUnidade: TppGroupFooterBand;
    ppDBText4: TppDBText;
    pplblTot_Qtd_Nfe_Rec: TppLabel;
    pplblTot_Qtd_Vol_Rec: TppLabel;
    pplblTot_Qtd_Pecas_Rec: TppLabel;
    pplblTot_Media_Pecas_Vol_Rec: TppLabel;
    pplblTot_Media_Pecas_Nfe_Rec: TppLabel;
    pplblTot_Qtd_Nfe_Env: TppLabel;
    pplblTot_Qtd_Pecas_Env: TppLabel;
    pplblTot_Media_Pecas_M3_Env: TppLabel;
    pplblTot_Media_Pecas_Nfe_Env: TppLabel;
    pplblTot_Qtd_Lotes_Env: TppLabel;
    pplblTot_Media_Lotes_Nfe_Env: TppLabel;
    pplblTot_Qtd_Linhas_Env: TppLabel;
    pplblTot_Media_Linhas_Nfe_Env: TppLabel;
    pplblTot_Qtd_Lojas_Env: TppLabel;
    pplblTot_Qtd_Vol_Env: TppLabel;
    pplblTot_Media_Pecas_Vol_Env: TppLabel;
    ppCabecalhoBefore_1: TppHeaderBand;
    ppShape3: TppShape;
    ppShape7: TppShape;
    ppSystemVariable2: TppSystemVariable;
    ppLabel13: TppLabel;
    ppLabel65: TppLabel;
    ppLabel66: TppLabel;
    ppLabel67: TppLabel;
    ppLabel68: TppLabel;
    pplblDescricao_1: TppLabel;
    ppLabel70: TppLabel;
    ppSystemVariable4: TppSystemVariable;
    ppImage2: TppImage;
    ppLabel74: TppLabel;
    ppLabel75: TppLabel;
    ppLabel76: TppLabel;
    ppLabel99: TppLabel;
    ppLabel100: TppLabel;
    ppLabel101: TppLabel;
    ppLabel104: TppLabel;
    ppLabel105: TppLabel;
    ppLabel106: TppLabel;
    ppLabel107: TppLabel;
    ppLabel108: TppLabel;
    ppLabel109: TppLabel;
    ppLabel113: TppLabel;
    ppLabel114: TppLabel;
    ppLabel115: TppLabel;
    ppLabel121: TppLabel;
    ppLabel122: TppLabel;
    ppLabel123: TppLabel;
    ppLabel124: TppLabel;
    ppLabel125: TppLabel;
    ppLabel126: TppLabel;
    ppLabel127: TppLabel;
    ppLabel128: TppLabel;
    ppLabel129: TppLabel;
    ppLabel133: TppLabel;
    ppLabel134: TppLabel;
    ppLabel135: TppLabel;
    ppLabel139: TppLabel;
    ppLabel140: TppLabel;
    ppLabel141: TppLabel;
    ppLabel142: TppLabel;
    ppLabel143: TppLabel;
    ppLabel144: TppLabel;
    ppLabel145: TppLabel;
    ppLabel146: TppLabel;
    ppLabel147: TppLabel;
    ppLabel148: TppLabel;
    ppLabel149: TppLabel;
    ppLabel150: TppLabel;
    ppLabel154: TppLabel;
    ppLabel155: TppLabel;
    ppLabel156: TppLabel;
    ppLabel160: TppLabel;
    ppLabel161: TppLabel;
    ppLabel162: TppLabel;
    ppLabel172: TppLabel;
    ppLabel176: TppLabel;
    ppLabel177: TppLabel;
    ppLabel182: TppLabel;
    ppLabel183: TppLabel;
    ppLabel184: TppLabel;
    ppDetalhes_1: TppDetailBand;
    ppDBText13: TppDBText;
    ppLabel163: TppLabel;
    ppDBText16: TppDBText;
    ppDBText28: TppDBText;
    ppDBText30: TppDBText;
    ppDBText31: TppDBText;
    ppDBText32: TppDBText;
    ppDBText34: TppDBText;
    ppDBText36: TppDBText;
    ppDBText37: TppDBText;
    ppDBText39: TppDBText;
    ppDBText40: TppDBText;
    ppDBText42: TppDBText;
    ppDBText43: TppDBText;
    ppDBText45: TppDBText;
    ppShape8: TppShape;
    ppDBText48: TppDBText;
    ppDBText56: TppDBText;
    ppFooterBand1: TppFooterBand;
    ppGroup3: TppGroup;
    ppCabecalhoCodUnidade_1: TppGroupHeaderBand;
    ppDBText46: TppDBText;
    ppRodapeCodUnidade_1: TppGroupFooterBand;
    ppLine1: TppLine;
    ppLabel164: TppLabel;
    pplblTot_Qtd_Nfe_Rec_1: TppLabel;
    pplblTot_Qtd_Vol_Rec_1: TppLabel;
    pplblTot_Qtd_Pecas_Rec_1: TppLabel;
    pplblTot_Media_Pecas_Vol_Rec_1: TppLabel;
    pplblTot_Media_Pecas_Nfe_Rec_1: TppLabel;
    pplblTot_Qtd_Nfe_Env_1: TppLabel;
    pplblTot_Qtd_M3_Env_1: TppLabel;
    pplblTot_Qtd_Pecas_Env_1: TppLabel;
    pplblTot_Media_Pecas_M3_Env_1: TppLabel;
    pplblTot_Media_Pecas_Nfe_Env_1: TppLabel;
    pplblTot_Qtd_Lotes_Env_1: TppLabel;
    pplblTot_Media_Lotes_Nfe_Env_1: TppLabel;
    pplblTot_Qtd_Linhas_Env_1: TppLabel;
    pplblTot_Media_Linhas_Nfe_Env_1: TppLabel;
    pplblTot_Qtd_Lojas_Env_1: TppLabel;
    ppShape9: TppShape;
    pplblTot_Qtd_Vol_Env_1: TppLabel;
    pplblTot_Media_Pecas_Vol_Env_1: TppLabel;
    ppGroup4: TppGroup;
    ppCabecalhoMesAno_1: TppGroupHeaderBand;
    ppLineHeader_1: TppLine;
    ppDBText47: TppDBText;
    ppdbtxtQtd_Nfe_Rec_1: TppDBText;
    ppdbtxtQtd_Vol_Rec_1: TppDBText;
    ppdbtxtQtd_Pecas_Rec_1: TppDBText;
    ppdbtxtMedia_Pecas_Vol_Rec_1: TppDBText;
    ppdbtxtMedia_Pecas_Nfe_Rec_1: TppDBText;
    ppdbtxtQtd_Nfe_Env_1: TppDBText;
    ppdbtxtQtd_M3_Env_1: TppDBText;
    ppdbtxtQtd_Pecas_Env_1: TppDBText;
    ppdbtxtMedia_Pecas_Nfe_Env_1: TppDBText;
    ppdbtxtQtd_Lotes_Env_1: TppDBText;
    ppdbtxtMedia_Lotes_Nfe_Env_1: TppDBText;
    ppdbtxtQtd_Linhas_Env_1: TppDBText;
    ppdbtxtMedia_Linhas_Nfe_Env_1: TppDBText;
    ppdbtxtQtd_Lojas_Env_1: TppDBText;
    ppShape10: TppShape;
    ppdbtxtQtd_Vol_Env_1: TppDBText;
    ppdbtxtMedia_Pecas_Vol_Env_1: TppDBText;
    ppdbtxtMedia_Pecas_M3_Env_1: TppDBText;
    pgrpftrbnd1: TppGroupFooterBand;
    ppDBText69: TppDBText;
    ppDBText70: TppDBText;
    ppDBText1: TppDBText;
    ppDBText3: TppDBText;
    Label1: TLabel;
    EdtGrupo: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Function RetornaDataServidor : TDate;
    Function RetiraPonto(OQue : string) : String;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelarClick(Sender: TObject);
    procedure edtDataInicialExit(Sender: TObject);
    procedure edtDataFinalExit(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure pprRelatorioPreviewFormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ppCabecalhoBeforePrint(Sender: TObject);
    procedure ppDetalhesBeforePrint(Sender: TObject);
    procedure pgrphdrbndCabecalhoCodUnidadeBeforePrint(Sender: TObject);
    procedure pgrpftrbndRodapeMesAnoBeforePrint(Sender: TObject);
    procedure CarregaParamsBanco;
    procedure ppCabecalhoMesAnoBeforePrint(Sender: TObject);
    procedure rdbtnTodasClick(Sender: TObject);
    procedure pprRelatorio_1PreviewFormCreate(Sender: TObject);
    procedure ppCabecalhoBefore_1BeforePrint(Sender: TObject);
    procedure ppCabecalhoCodUnidade_1BeforePrint(Sender: TObject);
    procedure ppCabecalhoMesAno_1BeforePrint(Sender: TObject);
    procedure ppDetalhes_1BeforePrint(Sender: TObject);
    procedure ppRodapeCodUnidade_1BeforePrint(Sender: TObject);
    procedure pgrpftrbnd1BeforePrint(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRel_Prod_CD: TfrmRel_Prod_CD;
  sParametro, sSelecionaRelatorio, sMesRef, sAnoRef : string;
  sUsuarioM : string;
  dtServidor : tdate;
  iauxi, iauxf : Integer;
  iContHeader : Integer;
  rSoma_Qtd_Colab, rSoma_Qtd_Horas_Trab, rSoma_Qtd_Nfe_Rec, rSoma_Qtd_Vol_Rec,
  rSoma_Qtd_Pecas_Rec, rSoma_Qtd_Nfe_Env, rSoma_Qtd_Vol_Env, rSoma_Qtd_M3_Env,
  rSoma_Qtd_Pecas_Env, rSoma_Qtd_Lotes_Env, rSoma_Qtd_Linhas_Env, rSoma_Qtd_Lojas_Env : Real;
  sUsuario, sSenha, sBanco : String;
  sUni_Ini, sUni_Fim, sTitulo_Rel, sAcumulador,sUsuario_Rel : String;

implementation

uses uFunc, uFuncoes, ppForms, uCarregaSenha;

{$R *.dfm}

Function TfrmRel_Prod_CD.RetornaDataServidor : TDate;
begin
   qryConsulta.Active := false;
   qryConsulta.SQL.Clear;
   qryConsulta.SQL.Add('select sysdate from dual');
   try
      qryConsulta.Active := True;
      result := qryConsulta.fieldbyname('sysdate').AsDateTime;
   except
      result := Date;
   end;
   if qryConsulta.Active then
      qryConsulta.Close;
end;

Function TfrmRel_Prod_CD.RetiraPonto(OQue : string) : String;
var
   i : integer;
   aux : string;
begin
   aux := '';
   for i := 1 to Length(OQue) do
   begin
      if OQue[i] <> '.' then
      begin
         aux := aux+OQue[i];
      end;
   end;
   Result := aux;
end;

procedure TfrmRel_Prod_CD.FormShow(Sender: TObject);
begin
   qryConsulta.Active := False;
   qryRel.Active := False;
   Session1.Active := False;
   Database1.Connected := False;

   CarregaParamsBanco;

   Database1.KeepConnection := False;
   Database1.LoginPrompt := False;

   Database1.Params.Values['SERVER NAME'] := sBanco;
   Database1.Params.Values['USER NAME'] := sUsuario;
   Database1.Params.Values['PASSWORD'] := sSenha;

   try
      Database1.Connected := True;
      Session1.Active := True;
      dtServidor := RetornaDataServidor;
   except
      Informacao('Erro!!!'+#13+'Não pode se conectar ao banco!!!','Aviso!!!');
      frmRel_Prod_CD.Close;
   end;
   rdbtnTodasClick(Sender);
end;

procedure TfrmRel_Prod_CD.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   if qryRel.Active then
      qryRel.Close;
   if qryConsulta.Active then
      qryConsulta.Close;
   if StpRel_Prod_CD.Active then
      StpRel_Prod_CD.Close;
   if Session1.Active then
      Session1.Close;
   if Database1.Connected then
      Database1.Close;
   Action := caFree;
end;

procedure TfrmRel_Prod_CD.btnCancelarClick(Sender: TObject);
begin
   Close;
end;

procedure TfrmRel_Prod_CD.edtDataInicialExit(Sender: TObject);
begin
   if AllTrim(edtDataInicial.Text) = '//' then
      edtDataInicial.Text := FormatDateTime('dd/mm/yyyy', Date);

     if (AllTrim(edtDataInicial.Text) = '//') then
     begin
          Informacao('Data Inicial não informado !!!','Aviso...');
          edtDataInicial.SetFocus;
          Abort;
          Exit;
     end;

     if Length(AllTrim(edtDataInicial.Text)) < 10 then
     begin
          Informacao('Data Inicial não informado !!!','Aviso...');
          edtDataInicial.SetFocus;
          Abort;
          Exit;
     end;

     if ValidaData(edtDataInicial.Text) then
     begin
          edtDataInicial.SetFocus;
          Abort;
          Exit;
     end;

     if (StrToDate(edtDataInicial.Text) > StrtoDate(FormatDateTime('dd/mm/yyyy',Date))) then
     begin
          Informacao('Data Inicial não pode ser maior que a Data Atual!!!','Aviso...');
          edtDataInicial.SetFocus;
          Abort;
          Exit;
     end;
end;

procedure TfrmRel_Prod_CD.edtDataFinalExit(Sender: TObject);
begin
   edtDataInicialExit(Sender);

   if AllTrim(edtDataFinal.Text) = '//' then
      edtDataFinal.Text := FormatDateTime('dd/mm/yyyy', Date);

     if (AllTrim(edtDataInicial.Text) = '//') then
     begin
          Informacao('Data Final não informado !!!','Aviso...');
          edtDataFinal.SetFocus;
          Abort;
          Exit;
     end;

     if Length(AllTrim(edtDataFinal.Text)) < 10 then
     begin
          Informacao('Data Final não informado !!!','Aviso...');
          edtDataFinal.SetFocus;
          Abort;
          Exit;
     end;

     if ValidaData(edtDataFinal.Text) then
     begin
          edtDataFinal.SetFocus;
          Abort;
          Exit;
     end;

     if (StrToDate(edtDataFinal.Text) > StrtoDate(FormatDateTime('dd/mm/yyyy',Date))) then
     begin
          Informacao('Data Final não pode ser maior que a Data Atual!!!','Aviso...');
          edtDataFinal.SetFocus;
          Abort;
          Exit;
     end;
     if (StrToDate(edtDataInicial.Text) > StrToDate(edtDataFinal.Text)) then
     begin
          Informacao('Data Inicial não pode ser maior que a Data Final!!!','Aviso...');
          edtDataInicial.SetFocus;
          Abort;
          Exit;
     end;

end;

procedure TfrmRel_Prod_CD.btnOKClick(Sender: TObject);
var
   Size        : Cardinal;
begin
   if pnlDisplay.Visible then
      exit;
   edtDataInicialExit(Sender);
   edtDataFinalExit(Sender);


      try
                              

      Size := 128;
      SetLength(sUsuarioM,Size);
      GetUserName(PChar(sUsuarioM), Size);
      sUsuario_Rel := sUsuarioM;
      sUsuarioM := Trim(sUsuario_Rel);
      pnlDisplay.Visible := true;
      frmRel_Prod_CD.Repaint;
      Application.ProcessMessages;
      pnlbuttons.Enabled := False;
      StpRel_Prod_CD.Close;


   //   sParametro :=sUni_Ini+'#'+sUni_Fim+'#'+trim(edtDataInicial.Text)+'#'+trim(edtDataFinal.Text)+ '#'+InttoStr(cbxListarDiv.ItemIndex)+ '#' +sUsuarioM+'#';

      StpRel_Prod_CD.Params[0].Value := sParametro;
       StpRel_Prod_CD.ExecProc;
      qryRel.Active := false;
      qryRel.SQL.Clear;
      qryRel.SQL.Add(sSelecionaRelatorio);
      qryRel.ParamByName('des_usuario').AsString := sUsuarioM;
      qryRel.Active := true;


      if qryRel.RecordCount <= 0 then
      begin
         Informacao('Não encontrou registros!!!','Aviso...');
         edtDataInicial.SetFocus;
         pnlbuttons.Enabled := True;
         pnlDisplay.Visible := false;
         frmRel_Prod_CD.Repaint;
         Application.ProcessMessages;
         exit;
      end;



      pnlbuttons.Enabled:= True;
      pnlDisplay.Visible := False;
      frmRel_Prod_CD.Repaint;
      Application.ProcessMessages;
   except
      on e:exception do
      begin
         informacao('Erro!!! Não gerou relatório...'+chr(13)+
                     e.ClassName + ' - '+e.Message,'Aviso...');
         pnlbuttons.Enabled:= True;
         pnlDisplay.Visible := false;
         frmRel_Prod_CD.Repaint;
         Application.ProcessMessages;
         exit;
      end;
   end;
end;

procedure TfrmRel_Prod_CD.pprRelatorioPreviewFormCreate(Sender: TObject);
begin
     pprRelatorio.PreviewForm.WindowState := wsMaximized;
     TppViewer(pprRelatorio.PreviewForm.Viewer).ZoomPercentage := 100;
     rSoma_Qtd_Colab:=0;      rSoma_Qtd_Horas_Trab:=0; rSoma_Qtd_Nfe_Rec:=0;
     rSoma_Qtd_Vol_Rec:=0;    rSoma_Qtd_Pecas_Rec:=0;  rSoma_Qtd_Nfe_Env:=0;
     rSoma_Qtd_Vol_Env:=0;    rSoma_Qtd_Pecas_Env:=0;  rSoma_Qtd_Lotes_Env:=0;
     rSoma_Qtd_Linhas_Env:=0; rSoma_Qtd_Lojas_Env:=0;  rSoma_Qtd_M3_Env := 0;
end;

procedure TfrmRel_Prod_CD.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     case Key of
          VK_RETURN: Perform(WM_NEXTDLGCTL,0,0);
//          VK_UP  : Perform(WM_NEXTDLGCTL,1,0);
     end;
end;

procedure TfrmRel_Prod_CD.ppCabecalhoBeforePrint(Sender: TObject);
begin
   pplblDescricao.Caption := 'Movimentos do Período de '+edtDataInicial.Text+' até '+edtDataFinal.Text+'. '+sTitulo_Rel+'. ';
end;

procedure TfrmRel_Prod_CD.ppDetalhesBeforePrint(Sender: TObject);
begin
     if (qryRel.FieldByName('cod_deposito').AsInteger = 0) then
         ppDetalhes.Visible := False
      else
         ppDetalhes.Visible := True;


end;




procedure TfrmRel_Prod_CD.pgrphdrbndCabecalhoCodUnidadeBeforePrint(Sender: TObject);
begin

   if (iContHeader = 0) then
      ppLineHeader.Visible := False
   else
      ppLineHeader.Visible := True;
   iContHeader := iContHeader+1;




   try
      if (StrToCurrDef(RetiraPonto(ppdbtxtQtd_Nfe_Rec.Text),0) > 0) then
      begin
         rSoma_Qtd_Nfe_Rec := rSoma_Qtd_Nfe_Rec + StrToFloatDef(RetiraPonto(ppdbtxtQtd_Nfe_Rec.Text),0);       //aqui
      end;
   except
      rSoma_Qtd_Nfe_Rec := rSoma_Qtd_Nfe_Rec;
   end;

   try
      if (StrToCurrDef(RetiraPonto(ppdbtxtQtd_Vol_Rec.Text),0) > 0) then
      begin
         rSoma_Qtd_Vol_Rec := rSoma_Qtd_Vol_Rec + StrToFloatDef(RetiraPonto(ppdbtxtQtd_Vol_Rec.Text),0);
      end;
   except
      rSoma_Qtd_Vol_Rec := rSoma_Qtd_Vol_Rec;
   end;

   try
      if (StrToCurrDef(RetiraPonto(ppdbtxtQtd_Pecas_Rec.Text),0) > 0) then
      begin
         rSoma_Qtd_Pecas_Rec := rSoma_Qtd_Pecas_Rec + StrToFloatDef(RetiraPonto(ppdbtxtQtd_Pecas_Rec.Text),0);
      end;
   except
      rSoma_Qtd_Pecas_Rec := rSoma_Qtd_Pecas_Rec;
   end;

   try
      if (StrToCurrDef(RetiraPonto(ppdbtxtQtd_Nfe_Env.Text),0) > 0) then
      begin
         rSoma_Qtd_Nfe_Env := rSoma_Qtd_Nfe_Env + StrToFloatDef(RetiraPonto(ppdbtxtQtd_Nfe_Env.Text),0);
      end;
   except
      rSoma_Qtd_Nfe_Env := rSoma_Qtd_Nfe_Env;
   end;

   try
      if (StrToCurrDef(RetiraPonto(ppdbtxtQtd_Vol_Env.Text),0) > 0) then
      begin
         rSoma_Qtd_Vol_Env := rSoma_Qtd_Vol_Env + StrToFloatDef(RetiraPonto(ppdbtxtQtd_Vol_Env.Text),0);
      end;
   except
      rSoma_Qtd_Vol_Env := rSoma_Qtd_Vol_Env;
   end;

   try
      if (StrToCurrDef(RetiraPonto(ppdbtxtQtd_M3_Env.Text),0) > 0) then
      begin
         rSoma_Qtd_M3_Env := rSoma_Qtd_M3_Env + StrToFloatDef(RetiraPonto(ppdbtxtQtd_M3_Env.Text),0);
      end;
   except
      rSoma_Qtd_M3_Env := rSoma_Qtd_M3_Env;
   end;

   try
      if (StrToCurrDef(RetiraPonto(ppdbtxtQtd_Pecas_Env.Text),0) > 0) then
      begin
         rSoma_Qtd_Pecas_Env := rSoma_Qtd_Pecas_Env + StrToFloatDef(RetiraPonto(ppdbtxtQtd_Pecas_Env.Text),0);
      end;
   except
      rSoma_Qtd_Pecas_Env := rSoma_Qtd_Pecas_Env;
   end;

   try
      if (StrToCurrDef(RetiraPonto(ppdbtxtQtd_Lotes_Env.Text),0) > 0) then
      begin
         rSoma_Qtd_Lotes_Env := rSoma_Qtd_Lotes_Env + StrToFloatDef(RetiraPonto(ppdbtxtQtd_Lotes_Env.Text),0);
      end;
   except
      rSoma_Qtd_Lotes_Env := rSoma_Qtd_Lotes_Env;
   end;

   try
      if (StrToCurrDef(RetiraPonto(ppdbtxtQtd_Linhas_Env.Text),0) > 0) then
      begin
         rSoma_Qtd_Linhas_Env := rSoma_Qtd_Linhas_Env + StrToFloatDef(RetiraPonto(ppdbtxtQtd_Linhas_Env.Text),0);
      end;
   except
      rSoma_Qtd_Linhas_Env := rSoma_Qtd_Linhas_Env;
   end;

   try
      if (StrToCurrDef(RetiraPonto(ppdbtxtQtd_Lojas_Env.Text),0) > 0) then
      begin
         rSoma_Qtd_Lojas_Env := rSoma_Qtd_Lojas_Env + StrToFloatDef(RetiraPonto(ppdbtxtQtd_Lojas_Env.Text),0);
      end;
   except
      rSoma_Qtd_Lojas_Env := rSoma_Qtd_Lojas_Env;
   end;
end;

procedure TfrmRel_Prod_CD.pgrpftrbndRodapeMesAnoBeforePrint(Sender: TObject);
begin
      if (rSoma_Qtd_Pecas_Rec >0 )and    (rSoma_Qtd_Nfe_Rec >0)     then
       begin
          pplblTot_Media_Pecas_Nfe_Rec.Caption := FormatFloat('#,0.0;-#,0.0', rSoma_Qtd_Pecas_Rec / rSoma_Qtd_Nfe_Rec);
       end;

     if StrToCurrDef(RetiraPonto(pplblTot_Media_Pecas_Nfe_Rec.Caption),0) <= 0 then
      pplblTot_Media_Pecas_Nfe_Rec.Caption := '0';

 if((rSoma_Qtd_Pecas_Rec>0) and  (rSoma_Qtd_Vol_Rec >0))  then
         begin
           pplblTot_Media_Pecas_Vol_Rec.Caption := FormatFloat('#,0.0;-#,0.0', rSoma_Qtd_Pecas_Rec / rSoma_Qtd_Vol_Rec);


         end;

         if ((rSoma_Qtd_Pecas_Env  > 0) and (rSoma_Qtd_Vol_Env >0) ) then
      begin
            pplblTot_Media_Pecas_Vol_Env.Caption := FormatFloat('#,0.0;-#,0.0', rSoma_Qtd_Pecas_Env / rSoma_Qtd_Vol_Env);


      end;



   if rSoma_Qtd_Nfe_Rec <> 0 then
     pplblTot_Qtd_Nfe_Rec.Caption := FormatFloat('#,0;-#,0',rSoma_Qtd_Nfe_Rec)

   else
      pplblTot_Qtd_Nfe_Rec.Caption := '0';

   if rSoma_Qtd_Vol_Rec <> 0 then
      pplblTot_Qtd_Vol_Rec.Caption := FormatFloat('#,0;-#,0',rSoma_Qtd_Vol_Rec)
   else
      pplblTot_Qtd_Vol_Rec.Caption := '0';

   if rSoma_Qtd_Pecas_Rec <> 0 then
      pplblTot_Qtd_Pecas_Rec.Caption := FormatFloat('#,0;-#,0',rSoma_Qtd_Pecas_Rec)
   else
      pplblTot_Qtd_Pecas_Rec.Caption := '0';

   if rSoma_Qtd_Nfe_Env <> 0 then
      pplblTot_Qtd_Nfe_Env.Caption := FormatFloat('#,0;-#,0',rSoma_Qtd_Nfe_Env)
   else
      pplblTot_Qtd_Nfe_Env.Caption := '0';

   if rSoma_Qtd_Vol_Env <> 0 then
     pplblTot_Qtd_Vol_Env.Caption := FormatFloat('#,0;-#,0',rSoma_Qtd_Vol_Env)
   else
      pplblTot_Qtd_Vol_Env.Caption := '0';

   if rSoma_Qtd_M3_Env <> 0 then
    pplblTot_Qtd_M3_Env.Caption := FormatFloat('#,0;-#,0',rSoma_Qtd_M3_Env)
   else
      pplblTot_Qtd_M3_Env.Caption := '0';

   if rSoma_Qtd_Pecas_Env <> 0 then
      pplblTot_Qtd_Pecas_Env.Caption := FormatFloat('#,0;-#,0',rSoma_Qtd_Pecas_Env)
   else
      pplblTot_Qtd_Pecas_Env.Caption := '0';

   if rSoma_Qtd_Lotes_Env <> 0 then
      pplblTot_Qtd_Lotes_Env.Caption := FormatFloat('#,0;-#,0',rSoma_Qtd_Lotes_Env)
   else
   pplblTot_Qtd_Lotes_Env.Caption := '0';

   if rSoma_Qtd_Linhas_Env <> 0 then
      pplblTot_Qtd_Linhas_Env.Caption := FormatFloat('#,0;-#,0',rSoma_Qtd_Linhas_Env)
   else
     pplblTot_Qtd_Linhas_Env.Caption := '0';

   if rSoma_Qtd_Lojas_Env <> 0 then
     pplblTot_Qtd_Lojas_Env.Caption := FormatFloat('#,0;-#,0',rSoma_Qtd_Lojas_Env)
   else
       pplblTot_Qtd_Lojas_Env.Caption :='0';


   if StrToCurrDef(RetiraPonto(pplblTot_Media_Pecas_Vol_Env.Caption),0) <= 0 then
     pplblTot_Media_Pecas_Vol_Env.Caption := '0';


      if ((rSoma_Qtd_Pecas_Env  > 0 ) and (rSoma_Qtd_M3_Env >0) ) then
      begin
         pplblTot_Media_Pecas_M3_Env.Caption := FormatFloat('#,0.0;-#,0.0', rSoma_Qtd_Pecas_Env / rSoma_Qtd_M3_Env);

      end;

   


   if StrToCurrDef(RetiraPonto(pplblTot_Media_Pecas_M3_Env.Caption),0) <= 0 then
      pplblTot_Media_Pecas_M3_Env.Caption := '0';

        if ((rSoma_Qtd_Pecas_Env   > 0 ) and (rSoma_Qtd_Nfe_Env >0) ) then
      begin
           pplblTot_Media_Pecas_Nfe_Env.Caption := FormatFloat('#,0.0;-#,0.0', rSoma_Qtd_Pecas_Env / rSoma_Qtd_Nfe_Env);

      end;


   
   if StrToCurrDef(RetiraPonto(pplblTot_Media_Pecas_Nfe_Env.Caption),0) <= 0 then
      pplblTot_Media_Pecas_Nfe_Env.Caption := '0';


    if ((rSoma_Qtd_Lotes_Env  > 0) and (rSoma_Qtd_Nfe_Env >0) ) then
      begin

          pplblTot_Media_Lotes_Nfe_Env.Caption := FormatFloat('#,0.0;-#,0.0', rSoma_Qtd_Lotes_Env / rSoma_Qtd_Nfe_Env);
      end;




   if StrToCurrDef(RetiraPonto(pplblTot_Media_Lotes_Nfe_Env.Caption),0) <= 0 then
      pplblTot_Media_Lotes_Nfe_Env.Caption := '0';






       if ((rSoma_Qtd_Linhas_Env > 0) and (rSoma_Qtd_Nfe_Env >0) ) then
      begin

            pplblTot_Media_Linhas_Nfe_Env.Caption := FormatFloat('#,0.0;-#,0.0', rSoma_Qtd_Linhas_Env / rSoma_Qtd_Nfe_Env);

      end;


                                                 


   if StrToCurrDef(RetiraPonto(pplblTot_Media_Linhas_Nfe_Env.Caption),0) <= 0 then
     pplblTot_Media_Linhas_Nfe_Env.Caption := '0';


   rSoma_Qtd_Colab:=0;      rSoma_Qtd_Horas_Trab:=0; rSoma_Qtd_Nfe_Rec:=0;
   rSoma_Qtd_Vol_Rec:=0;    rSoma_Qtd_Pecas_Rec:=0;  rSoma_Qtd_Nfe_Env:=0;
   rSoma_Qtd_Vol_Env:=0;    rSoma_Qtd_Pecas_Env:=0;  rSoma_Qtd_Lotes_Env:=0;
   rSoma_Qtd_Linhas_Env:=0; rSoma_Qtd_Lojas_Env:=0;  rSoma_Qtd_M3_Env:=0;
   iContHeader := 0;

end;

procedure TfrmRel_Prod_CD.CarregaParamsBanco;
var TomEncryption1: TTomEncryption;
begin
    TomEncryption1 := TTomEncryption.Create(Self);
    CarregaSenhasBancoOra('GRZPNL',TomEncryption1,sUsuario,sSenha,sBanco);
end;

procedure TfrmRel_Prod_CD.ppCabecalhoMesAnoBeforePrint(Sender: TObject);
begin
   rSoma_Qtd_Colab:=0;      rSoma_Qtd_Horas_Trab:=0; rSoma_Qtd_Nfe_Rec:=0;
   rSoma_Qtd_Vol_Rec:=0;    rSoma_Qtd_Pecas_Rec:=0;  rSoma_Qtd_Nfe_Env:=0;
   rSoma_Qtd_Vol_Env:=0;    rSoma_Qtd_Pecas_Env:=0;  rSoma_Qtd_Lotes_Env:=0;
   rSoma_Qtd_Linhas_Env:=0; rSoma_Qtd_Lojas_Env:=0;  rSoma_Qtd_M3_Env:=0;
   iContHeader := 0;
end;

procedure TfrmRel_Prod_CD.rdbtnTodasClick(Sender: TObject);
begin

   sUni_Ini := '818';
   sUni_Fim := '858';
   sTitulo_Rel := 'Listado Todas as Centrais de Depósito';
end;








procedure TfrmRel_Prod_CD.pprRelatorio_1PreviewFormCreate(Sender: TObject);
begin
     pprRelatorio_1.PreviewForm.WindowState := wsMaximized;
     TppViewer(pprRelatorio_1.PreviewForm.Viewer).ZoomPercentage := 100;
     rSoma_Qtd_Colab:=0;      rSoma_Qtd_Horas_Trab:=0; rSoma_Qtd_Nfe_Rec:=0;
     rSoma_Qtd_Vol_Rec:=0;    rSoma_Qtd_Pecas_Rec:=0;  rSoma_Qtd_Nfe_Env:=0;
     rSoma_Qtd_Vol_Env:=0;    rSoma_Qtd_Pecas_Env:=0;  rSoma_Qtd_Lotes_Env:=0;
     rSoma_Qtd_Linhas_Env:=0; rSoma_Qtd_Lojas_Env:=0;  rSoma_Qtd_M3_Env:=0;
end;

procedure TfrmRel_Prod_CD.ppCabecalhoBefore_1BeforePrint(Sender: TObject);
begin
   pplblDescricao_1.Caption := 'Movimentos do Período de '+edtDataInicial.Text+' até '+edtDataFinal.Text+'. '+sTitulo_Rel+'. ';
end;

procedure TfrmRel_Prod_CD.ppCabecalhoCodUnidade_1BeforePrint(
  Sender: TObject);
begin
   rSoma_Qtd_Colab:=0;      rSoma_Qtd_Horas_Trab:=0; rSoma_Qtd_Nfe_Rec:=0;
   rSoma_Qtd_Vol_Rec:=0;    rSoma_Qtd_Pecas_Rec:=0;  rSoma_Qtd_Nfe_Env:=0;
   rSoma_Qtd_Vol_Env:=0;    rSoma_Qtd_Pecas_Env:=0;  rSoma_Qtd_Lotes_Env:=0;
   rSoma_Qtd_Linhas_Env:=0; rSoma_Qtd_Lojas_Env:=0;  rSoma_Qtd_M3_Env:=0;
   iContHeader:=0;
end;

procedure TfrmRel_Prod_CD.ppCabecalhoMesAno_1BeforePrint(Sender: TObject);
begin

 if (iContHeader = 0) then
      ppLineHeader_1.Visible := False
   else
      ppLineHeader_1.Visible := True;
   iContHeader := iContHeader+1;


   try
      if (StrToCurrDef(RetiraPonto(ppdbtxtQtd_Nfe_Rec_1.Text),0) > 0) then
      begin
         rSoma_Qtd_Nfe_Rec := rSoma_Qtd_Nfe_Rec + StrToFloatDef(RetiraPonto(ppdbtxtQtd_Nfe_Rec_1.Text),0);
      end;
     except
      rSoma_Qtd_Nfe_Rec := rSoma_Qtd_Nfe_Rec;
   end;

   if((rSoma_Qtd_Pecas_Rec>0) and  (rSoma_Qtd_Vol_Rec >0))  then
     begin
         pplblTot_Media_Pecas_Vol_Rec_1.Caption := FormatFloat('#,0.0;-#,0.0', rSoma_Qtd_Pecas_Rec / rSoma_Qtd_Vol_Rec);
     end;

   try
      if (StrToCurrDef(RetiraPonto(ppdbtxtQtd_Vol_Rec_1.Text),0) > 0) then    
      begin
         rSoma_Qtd_Vol_Rec := rSoma_Qtd_Vol_Rec + StrToFloatDef(RetiraPonto(ppdbtxtQtd_Vol_Rec_1.Text),0);
      end;
     except
      rSoma_Qtd_Vol_Rec := rSoma_Qtd_Vol_Rec;
   end;

   try
      if (StrToCurrDef(RetiraPonto(ppdbtxtQtd_Pecas_Rec_1.Text),0) > 0) then
      begin
         rSoma_Qtd_Pecas_Rec := rSoma_Qtd_Pecas_Rec + StrToFloatDef(RetiraPonto(ppdbtxtQtd_Pecas_Rec_1.Text),0);
      end;
     except
      rSoma_Qtd_Pecas_Rec := rSoma_Qtd_Pecas_Rec;
   end;

   try
      if (StrToCurrDef(RetiraPonto(ppdbtxtQtd_Nfe_Env_1.Text),0) > 0) then
      begin
         rSoma_Qtd_Nfe_Env := rSoma_Qtd_Nfe_Env + StrToFloatDef(RetiraPonto(ppdbtxtQtd_Nfe_Env_1.Text),0);
      end;
     except
      rSoma_Qtd_Nfe_Env := rSoma_Qtd_Nfe_Env;
   end;

   try
      if (StrToCurrDef(RetiraPonto(ppdbtxtQtd_Vol_Env_1.Text),0) > 0) then
      begin
         rSoma_Qtd_Vol_Env := rSoma_Qtd_Vol_Env + StrToFloatDef(RetiraPonto(ppdbtxtQtd_Vol_Env_1.Text),0);
      end;
     except
      rSoma_Qtd_Vol_Env := rSoma_Qtd_Vol_Env;
   end;

   try
      if (StrToCurrDef(RetiraPonto(ppdbtxtQtd_Pecas_Env_1.Text),0) > 0) then
      begin
         rSoma_Qtd_Pecas_Env := rSoma_Qtd_Pecas_Env + StrToFloatDef(RetiraPonto(ppdbtxtQtd_Pecas_Env_1.Text),0);
      end;                    
     except
      rSoma_Qtd_Pecas_Env := rSoma_Qtd_Pecas_Env;
   end;

   try
      if (StrToCurrDef(RetiraPonto(ppdbtxtQtd_Lotes_Env_1.Text),0) > 0) then
      begin
         rSoma_Qtd_Lotes_Env := rSoma_Qtd_Lotes_Env + StrToFloatDef(RetiraPonto(ppdbtxtQtd_Lotes_Env_1.Text),0);
      end;
    except
      rSoma_Qtd_Lotes_Env := rSoma_Qtd_Lotes_Env;
   end;

   try
      if (StrToCurrDef(RetiraPonto(ppdbtxtQtd_Linhas_Env_1.Text),0) > 0) then
      begin
         rSoma_Qtd_Linhas_Env := rSoma_Qtd_Linhas_Env + StrToFloatDef(RetiraPonto(ppdbtxtQtd_Linhas_Env_1.Text),0);
      end;
    except
      rSoma_Qtd_Linhas_Env := rSoma_Qtd_Linhas_Env;
   end;

   try
      if (StrToCurrDef(RetiraPonto(ppdbtxtQtd_Lojas_Env_1.Text),0) > 0) then
      begin
         rSoma_Qtd_Lojas_Env := rSoma_Qtd_Lojas_Env + StrToFloatDef(RetiraPonto(ppdbtxtQtd_Lojas_Env_1.Text),0);
      end;
    except

   end;

   try
      if (StrToCurrDef(RetiraPonto(ppdbtxtQtd_M3_Env.Text),0) > 0) then
      begin
         rSoma_Qtd_M3_Env := rSoma_Qtd_M3_Env + StrToFloatDef(RetiraPonto(ppdbtxtQtd_M3_Env.Text),0);
      end;
   except
      rSoma_Qtd_M3_Env := rSoma_Qtd_M3_Env;
   end;




end;

procedure TfrmRel_Prod_CD.ppDetalhes_1BeforePrint(Sender: TObject);
begin
      if (qryRel.FieldByName('cod_deposito').AsInteger = 0) then
         ppDetalhes_1.Visible := False
      else
         ppDetalhes_1.Visible := True;
end;

procedure TfrmRel_Prod_CD.ppRodapeCodUnidade_1BeforePrint(Sender: TObject);
begin

   rSoma_Qtd_Colab:=0;      rSoma_Qtd_Horas_Trab:=0; rSoma_Qtd_Nfe_Rec:=0;
   rSoma_Qtd_Vol_Rec:=0;    rSoma_Qtd_Pecas_Rec:=0;  rSoma_Qtd_Nfe_Env:=0;
   rSoma_Qtd_Vol_Env:=0;    rSoma_Qtd_Pecas_Env:=0;  rSoma_Qtd_Lotes_Env:=0;
   rSoma_Qtd_Linhas_Env:=0; rSoma_Qtd_Lojas_Env:=0;  rSoma_Qtd_M3_Env:=0;
   iContHeader := 0;
end;



procedure TfrmRel_Prod_CD.pgrpftrbnd1BeforePrint(Sender: TObject);
begin

    if (rSoma_Qtd_Pecas_Rec >0 )and    (rSoma_Qtd_Nfe_Rec >0)     then
     begin
          pplblTot_Media_Pecas_Nfe_Rec_1.Caption := FormatFloat('#,0.0;-#,0.0', rSoma_Qtd_Pecas_Rec / rSoma_Qtd_Nfe_Rec);
     end;

     if StrToCurrDef(RetiraPonto(pplblTot_Media_Pecas_Nfe_Rec_1.Caption),0) <= 0 then
      pplblTot_Media_Pecas_Nfe_Rec_1.Caption := '0';

 if((rSoma_Qtd_Pecas_Rec>0) and  (rSoma_Qtd_Vol_Rec >0))  then
       begin
           pplblTot_Media_Pecas_Vol_Rec_1.Caption := FormatFloat('#,0.0;-#,0.0', rSoma_Qtd_Pecas_Rec / rSoma_Qtd_Vol_Rec);


       end;

 if ((rSoma_Qtd_Pecas_Env  > 0) and (rSoma_Qtd_Vol_Env >0) ) then
      begin
            pplblTot_Media_Pecas_Vol_Env_1.Caption := FormatFloat('#,0.0;-#,0.0', rSoma_Qtd_Pecas_Env / rSoma_Qtd_Vol_Env);


      end;



   if rSoma_Qtd_Nfe_Rec <> 0 then
     pplblTot_Qtd_Nfe_Rec_1.Caption := FormatFloat('#,0;-#,0',rSoma_Qtd_Nfe_Rec)

   else
      pplblTot_Qtd_Nfe_Rec_1.Caption := '0';

   if rSoma_Qtd_Vol_Rec <> 0 then
      pplblTot_Qtd_Vol_Rec_1.Caption := FormatFloat('#,0;-#,0',rSoma_Qtd_Vol_Rec)
   else
      pplblTot_Qtd_Vol_Rec_1.Caption := '0';

   if rSoma_Qtd_Pecas_Rec <> 0 then
      pplblTot_Qtd_Pecas_Rec_1.Caption := FormatFloat('#,0;-#,0',rSoma_Qtd_Pecas_Rec)
   else
      pplblTot_Qtd_Pecas_Rec_1.Caption := '0';

   if rSoma_Qtd_Nfe_Env <> 0 then
      pplblTot_Qtd_Nfe_Env_1.Caption := FormatFloat('#,0;-#,0',rSoma_Qtd_Nfe_Env)
   else
      pplblTot_Qtd_Nfe_Env_1.Caption := '0';

   if rSoma_Qtd_Vol_Env <> 0 then
     pplblTot_Qtd_Vol_Env_1.Caption := FormatFloat('#,0;-#,0',rSoma_Qtd_Vol_Env)
   else
      pplblTot_Qtd_Vol_Env_1.Caption := '0';

   if rSoma_Qtd_M3_Env <> 0 then
    pplblTot_Qtd_M3_Env_1.Caption := FormatFloat('#,0;-#,0',rSoma_Qtd_M3_Env)
   else
      pplblTot_Qtd_M3_Env_1.Caption := '0';

   if rSoma_Qtd_Pecas_Env <> 0 then
      pplblTot_Qtd_Pecas_Env_1.Caption := FormatFloat('#,0;-#,0',rSoma_Qtd_Pecas_Env)
   else
      pplblTot_Qtd_Pecas_Env_1.Caption := '0';

   if rSoma_Qtd_Lotes_Env <> 0 then
      pplblTot_Qtd_Lotes_Env_1.Caption := FormatFloat('#,0;-#,0',rSoma_Qtd_Lotes_Env)
   else
   pplblTot_Qtd_Lotes_Env_1.Caption := '0';

   if rSoma_Qtd_Linhas_Env <> 0 then
      pplblTot_Qtd_Linhas_Env_1.Caption := FormatFloat('#,0;-#,0',rSoma_Qtd_Linhas_Env)
   else
     pplblTot_Qtd_Linhas_Env_1.Caption := '0';

   if rSoma_Qtd_Lojas_Env <> 0 then
     pplblTot_Qtd_Lojas_Env_1.Caption := FormatFloat('#,0;-#,0',rSoma_Qtd_Lojas_Env)
   else

   if StrToCurrDef(RetiraPonto(pplblTot_Media_Pecas_Vol_Env_1.Caption),0) <= 0 then
     pplblTot_Media_Pecas_Vol_Env_1.Caption := '0';


  if ((rSoma_Qtd_Pecas_Env  > 0 ) and (rSoma_Qtd_M3_Env >0) ) then
    begin
         pplblTot_Media_Pecas_M3_Env_1.Caption := FormatFloat('#,0.0;-#,0.0', rSoma_Qtd_Pecas_Env / rSoma_Qtd_M3_Env);

    end;

   


   if StrToCurrDef(RetiraPonto(pplblTot_Media_Pecas_M3_Env_1.Caption),0) <= 0 then
      pplblTot_Media_Pecas_M3_Env_1.Caption := '0';

   if ((rSoma_Qtd_Pecas_Env   > 0 ) and (rSoma_Qtd_Nfe_Env >0) ) then
      begin
           pplblTot_Media_Pecas_Nfe_Env_1.Caption := FormatFloat('#,0.0;-#,0.0', rSoma_Qtd_Pecas_Env / rSoma_Qtd_Nfe_Env);

      end;


   
   if StrToCurrDef(RetiraPonto(pplblTot_Media_Pecas_Nfe_Env_1.Caption),0) <= 0 then
      pplblTot_Media_Pecas_Nfe_Env_1.Caption := '0';


    if ((rSoma_Qtd_Lotes_Env  > 0) and (rSoma_Qtd_Nfe_Env >0) ) then
      begin

          pplblTot_Media_Lotes_Nfe_Env_1.Caption := FormatFloat('#,0.0;-#,0.0', rSoma_Qtd_Lotes_Env / rSoma_Qtd_Nfe_Env);
      end;

   if StrToCurrDef(RetiraPonto(pplblTot_Media_Lotes_Nfe_Env_1.Caption),0) <= 0 then
      pplblTot_Media_Lotes_Nfe_Env_1.Caption := '0';

       if ((rSoma_Qtd_Linhas_Env > 0) and (rSoma_Qtd_Nfe_Env >0) ) then
      begin

            pplblTot_Media_Linhas_Nfe_Env_1.Caption := FormatFloat('#,0.0;-#,0.0', rSoma_Qtd_Linhas_Env / rSoma_Qtd_Nfe_Env);

      end;


   if StrToCurrDef(RetiraPonto(pplblTot_Media_Linhas_Nfe_Env_1.Caption),0) <= 0 then
     pplblTot_Media_Linhas_Nfe_Env_1.Caption := '0';


   rSoma_Qtd_Colab:=0;      rSoma_Qtd_Horas_Trab:=0; rSoma_Qtd_Nfe_Rec:=0;
   rSoma_Qtd_Vol_Rec:=0;    rSoma_Qtd_Pecas_Rec:=0;  rSoma_Qtd_Nfe_Env:=0;
   rSoma_Qtd_Vol_Env:=0;    rSoma_Qtd_Pecas_Env:=0;  rSoma_Qtd_Lotes_Env:=0;
   rSoma_Qtd_Linhas_Env:=0; rSoma_Qtd_Lojas_Env:=0;  rSoma_Qtd_M3_Env:=0;
   iContHeader := 0;
        
end;

end.





