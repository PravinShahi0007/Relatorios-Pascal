unit UConc_Oper_Financeira;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBTables, DB, StdCtrls, Buttons, Mask, ExtCtrls, ComCtrls, Registry,
  ppProd, ppClass, ppReport, ppComm, ppRelatv, ppDB, ppDBPipe, ppDBBDE,
  ppCtrls, ppStrtch, ppMemo, ppVar, ppPrnabl, ppBands, ppCache, ppParameter, ppViewr,
  Grids, DBGrids, Encryp, ppDesignLayer;

type
  TfrmConc_Oper_Financeira = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Panel3: TPanel;
    Label4: TLabel;
    edtGrupo: TMaskEdit;
    Panel4: TPanel;
    Label2: TLabel;
    Panel5: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    edtCodUnidadeFinal: TMaskEdit;
    edtCodUnidadeInic: TMaskEdit;
    Panel6: TPanel;
    Label8: TLabel;
    Panel7: TPanel;
    Label9: TLabel;
    Label10: TLabel;
    edtDataFinal: TMaskEdit;
    edtDataInicial: TMaskEdit;
    pnlbuttons: TPanel;
    btnOK: TBitBtn;
    btnCancelar: TBitBtn;
    Panel11: TPanel;
    Label14: TLabel;
    cbxProduto: TComboBox;
    Panel12: TPanel;
    Label13: TLabel;
    pnlDisplay: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Animate1: TAnimate;
    Database1: TDatabase;
    StpConciliacao: TStoredProc;
    qryRel: TQuery;
    DataSource1: TDataSource;
    pprRelatorio: TppReport;
    ppHeaderBand1: TppHeaderBand;
    ppDetailBand: TppDetailBand;
    ppFooterBand: TppFooterBand;
    ppDBText4: TppDBText;
    ppMemo2: TppMemo;
    ppShape2: TppShape;
    ppLabel16: TppLabel;
    ppLabel3: TppLabel;
    ppLabel1: TppLabel;
    ppLabel15: TppLabel;
    ppSystemVariable4: TppSystemVariable;
    ppSystemVariable3: TppSystemVariable;
    ppLabel9: TppLabel;
    ppLabel10: TppLabel;
    pplParametros: TppLabel;
    ppLabel17: TppLabel;
    ppLabel18: TppLabel;
    Session1: TSession;
    ppLabel2: TppLabel;
    qryConsulta: TQuery;
    ppParameterList1: TppParameterList;
    ppGroup4: TppGroup;
    ppGroupHeaderBand4: TppGroupHeaderBand;
    ppGroupFooterBandRede: TppGroupFooterBand;
    ppGroup5: TppGroup;
    ppGroupHeaderBand5: TppGroupHeaderBand;
    ppGroupFooterBandUni: TppGroupFooterBand;
    ppDBText13: TppDBText;
    ppLabel6: TppLabel;
    ppDBText9: TppDBText;
    ppLabel7: TppLabel;
    ppDBText1: TppDBText;
    ppDBText7: TppDBText;
    ppDBText2: TppDBText;
    ppDBDif_nf_tit: TppDBText;
    ppDBText5: TppDBText;
    ppDBDif_tit_ap: TppDBText;
    ppDBPipeline1: TppDBPipeline;
    ppDBCalc1: TppDBCalc;
    ppDBCalc2: TppDBCalc;
    ppLabel4: TppLabel;
    ppDBCalcUniDif_nf_tit: TppDBCalc;
    ppDBCalc3: TppDBCalc;
    ppDBCalcUniDif_tit_ap: TppDBCalc;
    ppLine1: TppLine;
    ppLabel8: TppLabel;
    ppDBCalc5: TppDBCalc;
    ppDBCalcRedeDif_tit_ap: TppDBCalc;
    ppDBCalc7: TppDBCalc;
    ppDBCalcRedeDif_nf_tit: TppDBCalc;
    ppDBCalc10: TppDBCalc;
    pplblcod_produto: TppLabel;
    qryRelDES_REDE: TStringField;
    qryRelCOD_UNIDADE: TFloatField;
    qryRelDES_UNIDADE: TStringField;
    qryRelDTA_MOVIMENTO: TDateTimeField;
    qryRelVALOR_NOTAS: TFloatField;
    qryRelVALOR_TITULOS: TFloatField;
    qryRelDIF_NF_TIT: TFloatField;
    qryRelVALOR_APRO: TFloatField;
    qryRelDIF_TIT_AP: TFloatField;
    cbxDiver: TComboBox;
    Label3: TLabel;
    Panel8: TPanel;
    Label5: TLabel;
    edtEmp: TMaskEdit;
    Panel9: TPanel;
    Label16: TLabel;
    Edit1: TEdit;
    ppLine3: TppLine;

    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtGrupoExit(Sender: TObject);
    Function RetornaDataServidor : tdate;
    Function LogUser : string;
    procedure edtCodUnidadeInicExit(Sender: TObject);
    procedure edtCodUnidadeFinalExit(Sender: TObject);
    procedure edtDataInicialExit(Sender: TObject);
    procedure edtDataFinalExit(Sender: TObject);
    procedure cbxProdutoEnter(Sender: TObject);
    procedure cbxProdutoExit(Sender: TObject);
    procedure cbxProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure pplParametrosPrint(Sender: TObject);
    procedure pprRelatorioPreviewFormCreate(Sender: TObject);
    procedure pplblcod_produtoPrint(Sender: TObject);
    procedure cbxDiverEnter(Sender: TObject);
    procedure cbxDiverKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbxDiverExit(Sender: TObject);
    procedure CarregaParamsBanco;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConc_Oper_Financeira: TfrmConc_Oper_Financeira;
  sParamentro : string;
  sUsuarioT, sRede : string;
  sSelecionaRelatorio : string;
  dtServidor : tdate;
  sUsuario, sSenha, sBanco : String;


implementation

uses UFunc, UFuncoes, ppForms, uCarregaSenha;

{$R *.dfm}

Function TfrmConc_Oper_Financeira.RetornaDataServidor : tdate;
Begin
    qryConsulta.Active := false;
    qryConsulta.SQL.Clear;
    qryConsulta.SQL.Add('select sysdate from dual');
    try
      qryConsulta.Active := true;
      result := qryConsulta.fieldByName('sysdate').AsDateTime;
    except
      Result := date;
    end;
    if qryConsulta.Active then
       qryConsulta.close;
end;

function TfrmConc_Oper_Financeira.LogUser : String;
{Requer a unit Registry declarada na clausula Uses da Unit}
var
   Registro:TRegistry;
begin
   Registro := TRegistry.Create;
   Registro.RootKey := HKEY_LOCAL_MACHINE;
   if Registro.OpenKey('Network\Logon', false) then
    begin
     result := Registro.ReadString('username');
    end;
   Registro.Free;
end;


procedure TfrmConc_Oper_Financeira.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
     case Key of
          VK_RETURN, VK_DOWN: Perform(WM_NEXTDLGCTL,0,0);
          VK_UP : Perform(WM_NEXTDLGCTL,1,0);
     end;
end;

procedure TfrmConc_Oper_Financeira.edtGrupoExit(Sender: TObject);
begin
     if trim(edtGrupo.Text) = '' then
       Begin
           edtGrupo.Text := '910';
           exit;
       end;
     try
       StrToFloat(edtGrupo.Text);
     except
       Informacao('Digita??o inv?lida!!!', 'Aviso...');
       edtGrupo.Clear;
       edtGrupo.SetFocus;
       exit;
     end;
     if (StrToFloat(edtGrupo.Text) <> 910) and
        (StrToFloat(edtGrupo.Text) <> 930) and
        (StrToFloat(edtGrupo.Text) <> 940) and
        (StrToFloat(edtGrupo.Text) <> 950) and
        (StrToFloat(edtGrupo.Text) <> 970) then
       begin
          Informacao('C?digo grupo deve ser igual:'+#13+
                     '  910 = Grazziotin'+#13+
                     '  930 = PorMenos'+#13+
                     '  940 = Franco Giorgi'+#13+
                     '  950 = Tottal'+#13+#13+
                     '  970 = GZT Store '+#13+#13+
                     '  Informe!!!', 'Aviso...');
          edtGrupo.Clear;
          edtGrupo.SetFocus;
          exit;
       end;
end;

procedure TfrmConc_Oper_Financeira.edtCodUnidadeInicExit(Sender: TObject);
begin
     if trim(edtCodUnidadeInic.Text) = '' then
       Begin
           edtCodUnidadeInic.Text := '0';
           exit;
       end;
     try
       strtofloat(edtCodUnidadeInic.Text);
     except
       Informacao('Digita??o inv?lida!!!', 'Aviso...');
       edtCodUnidadeInic.Clear;
       edtCodUnidadeInic.SetFocus;
       exit;
     end;
     if strtofloat(edtCodUnidadeInic.Text) < 0 then
       Begin
          Informacao('Unidade Inicial deve ser maior que 0', 'Aviso...');
          edtCodUnidadeInic.Clear;
          edtCodUnidadeInic.SetFocus;
          exit;
       end;
end;

procedure TfrmConc_Oper_Financeira.edtCodUnidadeFinalExit(Sender: TObject);
begin
     if trim(edtCodUnidadeFinal.Text) = '' then
        Begin
           edtCodUnidadeFinal.Text := '999999';
           exit;
        end;
     try
       strtofloat(edtCodUnidadeFinal.Text);
     except
       Informacao('Digita??o inv?lida!!!', 'Aviso...');
       edtCodUnidadeFinal.Clear;
       edtCodUnidadeFinal.SetFocus;
       exit;
     end;
     if (strtofloat(edtCodUnidadeFinal.Text) < strtofloat(edtCodUnidadeInic.Text)) then
       Begin
          Informacao('Unidade Final deve ser maior que Unidade Inicial', 'Aviso...');
          edtCodUnidadeFinal.Clear;
          edtCodUnidadeFinal.SetFocus;
          exit;
       end;
end;

procedure TfrmConc_Oper_Financeira.edtDataInicialExit(Sender: TObject);
var
  x: string;
  aux: integer;
begin
     if alltrim(edtDataInicial.Text) = '//' then
       Begin
          edtDataInicial.Text := FormatDateTime('dd/mm/yyyy',dtServidor);
          exit;
       end;
     try
       strtoDate(edtDataInicial.Text);
       x:= edtDataInicial.Text;
       aux := StrToInt(x[7]+x[8]+x[9]+x[10]+x[4]+x[5]+x[1]+x[2]);
       if (aux <= 19500101) then
        begin
         Informacao('Data inv?lida!!!', 'Aviso...');
         edtDataInicial.Clear;
         edtDataInicial.SetFocus;
         exit;
        end else if (aux >= 21000101) then
        begin
         Informacao('Data inv?lida!!!', 'Aviso...');
         edtDataInicial.Clear;
         edtDataInicial.SetFocus;
         exit;
        end;
     except
       Informacao('Data inv?lida!!!', 'Aviso...');
       edtDataInicial.Clear;
       edtDataInicial.SetFocus;
       exit;
     end;

end;

procedure TfrmConc_Oper_Financeira.edtDataFinalExit(Sender: TObject);
var
  x: string;
  aux: Integer;
begin
     if AllTrim(edtDataFinal.Text) = '//' then
        Begin
            edtDataFinal.Text := FormatDateTime('dd/mm/yyyy',dtServidor);
            cbxProduto.SetFocus;
            exit;
        end;
     try
       strtoDate(edtDataFinal.Text);
       x:= edtDataFinal.Text;
       aux := StrToInt(x[7]+x[8]+x[9]+x[10]+x[4]+x[5]+x[1]+x[2]);
       if (aux <= 19500101) then
        begin
         Informacao('Data inv?lida!!!', 'Aviso...');
         edtDataFinal.Clear;
         edtDataFinal.SetFocus;
         exit;
        end else if (aux >= 21000101) then
        begin
         Informacao('Data inv?lida!!!', 'Aviso...');
        edtDataFinal.Clear;
        edtDataFinal.SetFocus;
        exit;
        end;
     except
       Informacao('Data inv?lida!!!', 'Aviso...');
       edtDataFinal.Clear;
       edtDataFinal.SetFocus;
       exit;
     end;
     if (strtodate(edtDataFinal.Text) < strtoDate(edtDataInicial.Text)) then
       Begin
          Informacao('Data final deve ser maior que a data inicial', 'Aviso...');
          edtDataFinal.Clear;
          edtDataFinal.SetFocus;
          exit;
       end;
     cbxProduto.SetFocus;
end;

procedure TfrmConc_Oper_Financeira.cbxProdutoEnter(Sender: TObject);
begin
    KeyPreview := False;
    cbxProduto.DroppedDown := True;
end;

procedure TfrmConc_Oper_Financeira.cbxProdutoExit(Sender: TObject);
begin
    if (Trim(cbxProduto.Text) = '') then
    Begin
          Informacao('Escolha um t?tulo!!', 'Aviso...');
          cbxProduto.SetFocus;
          exit;
    end;
    if (cbxProduto.text <> 'EMPR?STIMO') and (cbxProduto.Text <> 'FINANCIAMENTO') then
    begin
          Informacao('Voc? deve escolher um t?tulo!!', 'Aviso...');
          cbxProduto.SetFocus;
          exit;
    end;
    KeyPreview := True;
end;

procedure TfrmConc_Oper_Financeira.cbxProdutoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
    case Key of
          VK_RETURN : cbxDiver.SetFocus;
          VK_F12 : edtDataFinal.SetFocus;

     end;
end;

procedure TfrmConc_Oper_Financeira.btnCancelarClick(Sender: TObject);
begin
   Close;
end;

procedure TfrmConc_Oper_Financeira.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   try
      if qryRel.Active then
         qryRel.Active := False;
      if Session1.Active then
         Session1.Active := False;
      if Database1.Connected then
         Database1.Connected := False;
      Action := caFree;
   except
      Informacao('N?o foi poss?vel se Desconectar do Banco!!! Tente Novamente!!!', 'Aten??o');
      Abort;
   end;
end;

procedure TfrmConc_Oper_Financeira.FormShow(Sender: TObject);
begin
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
      Informacao('Erro!!!'+#13+'N?o pode se conectar ao banco!!!','Aviso!!!');
      frmConc_Oper_Financeira.Close;
   end;
end;

procedure TfrmConc_Oper_Financeira.btnOKClick(Sender: TObject);
Var
   Size        : Cardinal;
   sCod_Produto: string;
begin
   edtGrupoExit(Sender);
   edtCodUnidadeInicExit(Sender);
   edtCodUnidadeFinalExit(Sender);
   edtDataInicialExit(Sender);
   edtDataFinalExit(Sender);
   cbxProdutoExit(Sender);
   cbxDiverExit(Sender);

   if btnCancelar.CanFocus then
        btnCancelar.SetFocus;
  try
    if cbxProduto.ItemIndex = 0 then begin
      sCod_Produto:= 'EMPRESTIMO';
    end else begin
      sCod_Produto:= 'FINANCIAMENTO';
    end;
    if cbxDiver.ItemIndex = 1 then begin
       sSelecionaRelatorio:= 'select des_rede, cod_unidade, des_unidade,dta_movimento'+
                             ', sum(vlr_ns) as valor_notas'+
                             ', sum(vlr_cr) as valor_titulos'+
                             ',(sum(vlr_ns) - sum(vlr_cr)) as dif_nf_tit'+
                             ', sum(vlr_cdc_apro) as valor_apro'+
                             ',(sum(vlr_cr) - sum(vlr_cdc_apro)) as dif_tit_ap'+
                             ' from GRZ_REL_OPER_FINANC'+
                             ' where des_usuario = :DES_USUARIO'+
                             ' having (sum(vlr_ns) - sum(vlr_cr)) <> 0 or (sum(vlr_cr) - sum(vlr_cdc_apro)) <> 0'+
                             ' group by des_rede, cod_unidade, des_unidade, dta_movimento'+
                             ' order by des_rede, cod_unidade, des_unidade, dta_movimento';
       end else begin
       sSelecionaRelatorio:= 'select des_rede, cod_unidade, des_unidade,dta_movimento'+
                             ', sum(vlr_ns) as valor_notas'+
                             ', sum(vlr_cr) as valor_titulos'+
                             ',(sum(vlr_ns) - sum(vlr_cr)) as dif_nf_tit'+
                             ', sum(vlr_cdc_apro) as valor_apro'+
                             ',(sum(vlr_cr) - sum(vlr_cdc_apro)) as dif_tit_ap'+
                             ' from GRZ_REL_OPER_FINANC'+
                             ' where des_usuario = :DES_USUARIO'+
                             ' group by des_rede, cod_unidade, des_unidade, dta_movimento'+
                             ' order by des_rede, cod_unidade, des_unidade, dta_movimento';
       end;

   Size := 128;
   SetLength(sUsuarioT,Size);
   GetUserName(PChar(sUsuarioT), Size);
   Edit1.Text := sUsuarioT;
   sUsuarioT := Trim(Edit1.Text);
   pnlDisplay.Visible := true;
   frmConc_Oper_Financeira.Repaint;
   pnlbuttons.Enabled:= False;
   StpConciliacao.Close;
   sParamentro := trim(edtEmp.Text)+'#'+trim(edtGrupo.Text)+'#'+
                  trim(edtCodUnidadeInic.Text)+'#'+trim(edtCodUnidadeFinal.Text)+'#'+
                  trim(edtDataInicial.Text)+'#'+trim(edtDataFinal.Text)+'#'+
                  sCod_Produto+'#'+sUsuarioT+'#';
   StpConciliacao.Params[0].Value := sParamentro;
   StpConciliacao.ExecProc;
   qryRel.Active := false;
   qryRel.SQL.Clear;
   qryRel.SQL.Add(sSelecionaRelatorio);
   qryRel.ParamByName('des_usuario').AsString := sUsuarioT;
   qryRel.Active := true;

   if qryRel.RecordCount <= 0 then
     Begin
         Informacao('N?o encontrou registros!!!','Aviso...');
         edtGrupo.SetFocus;
         pnlbuttons.Enabled:= True;
         pnlDisplay.Visible := false;
         frmConc_Oper_Financeira.Repaint;
         exit;
     end;

   pprRelatorio.Print;
   pnlbuttons.Enabled:= True;
   pnlDisplay.Visible := false;
   frmConc_Oper_Financeira.Repaint;
   except
         on e:exception do
      Begin
        informacao('Erro!!! N?o gerou relat?rio...'+chr(13)+
                   e.ClassName + ' - '+e.Message,'Aviso...');
        pnlbuttons.Enabled:= True;
        pnlDisplay.Visible := false;
        frmConc_Oper_Financeira.Repaint;
        exit;
      end;
   end;

end;


procedure TfrmConc_Oper_Financeira.pplParametrosPrint(Sender: TObject);
begin
     pplParametros.Caption := 'Concilia??o de Opera??es Financeiras - Grupo '+trim(edtGrupo.Text)+
                              ' - Unidade '+trim(edtCodUnidadeInic.Text)+
                              ' at? ' + trim(edtCodUnidadeFinal.Text) + ' - Per?odo ' + trim(edtDataInicial.Text) +
                              ' at? ' + trim(edtDataFinal.Text);
end;

procedure TfrmConc_Oper_Financeira.pprRelatorioPreviewFormCreate(
  Sender: TObject);
begin
     pprRelatorio.PreviewForm.WindowState := wsMaximized;
     TppViewer(pprRelatorio.PreviewForm.Viewer).ZoomPercentage := 100;
end;

procedure TfrmConc_Oper_Financeira.pplblcod_produtoPrint(Sender: TObject);
begin
      pplblcod_produto.Caption:= cbxProduto.Text;
end;

procedure TfrmConc_Oper_Financeira.cbxDiverEnter(Sender: TObject);
begin
    KeyPreview := False;
    cbxDiver.DroppedDown := True;
end;

procedure TfrmConc_Oper_Financeira.cbxDiverKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
    case Key of
          VK_RETURN : btnOK.SetFocus;
          VK_F12 : cbxProduto.SetFocus;

     end;
end;

procedure TfrmConc_Oper_Financeira.cbxDiverExit(Sender: TObject);
begin
    if (Trim(cbxProduto.Text) = '') then
    Begin
          Informacao('Escolha um t?tulo!!', 'Aviso...');
          cbxDiver.SetFocus;
          exit;
    end;
    if (cbxDiver.text <> 'TODOS') and (cbxDiver.Text <> 'SOMENTE DIVERG?NCIA') then
    begin
          Informacao('Voc? deve escolher um t?tulo!!', 'Aviso...');
          cbxDiver.SetFocus;
          exit;
    end;
    KeyPreview := True;
end;

procedure TfrmConc_Oper_Financeira.CarregaParamsBanco;
var TomEncryption1: TTomEncryption;
begin
    TomEncryption1 := TTomEncryption.Create(Self);
    CarregaSenhasBancoOra('GRZPNL',TomEncryption1,sUsuario,sSenha,sBanco);
end;

end.
