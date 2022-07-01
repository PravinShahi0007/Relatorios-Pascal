unit UConc_Pag_Financeira;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBTables, DB, StdCtrls, Buttons, Mask, ExtCtrls, ComCtrls, Registry,
  ppProd, ppClass, ppReport, ppComm, ppRelatv, ppDB, ppDBPipe, ppDBBDE,
  ppCtrls, ppStrtch, ppMemo, ppVar, ppPrnabl, ppBands, ppCache, ppParameter, ppViewr,
  Grids, DBGrids, Encryp, ppDesignLayer;

type
  TfrmConc_Pag_Financeira = class(TForm)
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
    Label3: TLabel;
    cbxProduto: TComboBox;
    cbxDiver: TComboBox;
    Panel12: TPanel;
    Label13: TLabel;
    pnlDisplay: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Animate1: TAnimate;
    Panel8: TPanel;
    Label5: TLabel;
    edtEmp: TMaskEdit;
    Panel9: TPanel;
    Label16: TLabel;
    Edit1: TEdit;
    qryConsulta: TQuery;
    ppDBPipeline1: TppDBPipeline;
    pprRelatorio: TppReport;
    ppHeaderBand1: TppHeaderBand;
    ppDBText4: TppDBText;
    ppMemo2: TppMemo;
    ppShape2: TppShape;
    ppLabel16: TppLabel;
    ppLabel1: TppLabel;
    ppLabel15: TppLabel;
    ppSystemVariable4: TppSystemVariable;
    ppSystemVariable3: TppSystemVariable;
    ppLabel9: TppLabel;
    ppLabel10: TppLabel;
    pplParametros: TppLabel;
    ppLabel17: TppLabel;
    ppLabel18: TppLabel;
    pplblcod_produto: TppLabel;
    ppDetailBand: TppDetailBand;
    ppDBText1: TppDBText;
    ppDBText2: TppDBText;
    ppDBText5: TppDBText;
    ppDBDif_tit_ap: TppDBText;
    ppFooterBand: TppFooterBand;
    ppGroup4: TppGroup;
    ppGroupHeaderBand4: TppGroupHeaderBand;
    ppGroupFooterBandRede: TppGroupFooterBand;
    ppLabel8: TppLabel;
    ppDBCalcRedeDif_tit_ap: TppDBCalc;
    ppDBCalc7: TppDBCalc;
    ppDBCalc10: TppDBCalc;
    ppGroup5: TppGroup;
    ppGroupHeaderBand5: TppGroupHeaderBand;
    ppDBText13: TppDBText;
    ppLabel6: TppLabel;
    ppDBText9: TppDBText;
    ppLabel7: TppLabel;
    ppGroupFooterBandUni: TppGroupFooterBand;
    ppDBCalc2: TppDBCalc;
    ppLabel4: TppLabel;
    ppDBCalc3: TppDBCalc;
    ppDBCalcUniDif_tit_ap: TppDBCalc;
    ppLine1: TppLine;
    ppLine3: TppLine;
    ppParameterList1: TppParameterList;
    DataSource1: TDataSource;
    Database1: TDatabase;
    StpConciliacao: TStoredProc;
    Session1: TSession;
    qryRel: TQuery;
    qryRelDES_REDE: TStringField;
    qryRelCOD_UNIDADE: TFloatField;
    qryRelDES_UNIDADE: TStringField;
    qryRelDTA_CONTABIL: TDateTimeField;
    qryRelVALOR_TITULOS: TFloatField;
    qryRelVALOR_APRO: TFloatField;
    qryRelDIF_TIT_AP: TFloatField;
    qryRelVALOR_TITULOS_TOTAL: TFloatField;
    qryRelVALOR_APRO_TOTAL: TFloatField;
    qryRelDIF_TIT_AP_TOTAL: TFloatField;
    ppLabel2: TppLabel;
    ppDBCalc1: TppDBCalc;
    ppDBCalc4: TppDBCalc;
    ppDBCalc5: TppDBCalc;
    ppDBCalc6: TppDBCalc;
    ppDBCalc8: TppDBCalc;
    ppDBCalc9: TppDBCalc;
    ppDBText3: TppDBText;
    ppDBText6: TppDBText;
    ppDBText7: TppDBText;
    ppLabel11: TppLabel;
    ppLabel3: TppLabel;
    ppLabel12: TppLabel;
    ppLabel5: TppLabel;
    ppLabel13: TppLabel;
    Function RetornaDataServidor : tdate;
    Function LogUser : string;
    procedure edtGrupoExit(Sender: TObject);
    procedure edtCodUnidadeInicExit(Sender: TObject);
    procedure edtCodUnidadeFinalExit(Sender: TObject);
    procedure edtDataInicialExit(Sender: TObject);
    procedure edtDataFinalExit(Sender: TObject);
    procedure cbxProdutoEnter(Sender: TObject);
    procedure cbxProdutoExit(Sender: TObject);
    procedure cbxProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbxDiverKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbxDiverEnter(Sender: TObject);
    procedure cbxDiverExit(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pplParametrosPrint(Sender: TObject);
    procedure pprRelatorioPreviewFormCreate(Sender: TObject);
    procedure pplblcod_produtoPrint(Sender: TObject);
    procedure CarregaParamsBanco;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConc_Pag_Financeira: TfrmConc_Pag_Financeira;
  sParamentro : string;
  sUsuarioT, sRede : string;
  sSelecionaRelatorio : string;
  dtServidor : tdate;
  sUsuario, sSenha, sBanco : String;

implementation

uses UFunc, UFuncoes, uCarregaSenha;

{$R *.dfm}

Function TfrmConc_Pag_Financeira.RetornaDataServidor : tdate;
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

Function TfrmConc_Pag_Financeira.LogUser : String;
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

procedure TfrmConc_Pag_Financeira.edtGrupoExit(Sender: TObject);
begin
     if trim(edtGrupo.Text) = '' then
       Begin
           edtGrupo.Text := '910';
           exit;
       end;
     try
       StrToFloat(edtGrupo.Text);
     except
       Informacao('Digitação inválida!!!', 'Aviso...');
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
          Informacao('Código grupo deve ser igual:'+#13+
                     '  910 = Grazziotin'+#13+
                     '  930 = PorMenos'+#13+
                     '  940 = Franco Giorgi'+#13+
                     '  950 = Tottal'+#13+#13+
                     '  970 = GZT Store'+#13+#13+
                     '  Informe!!!', 'Aviso...');
          edtGrupo.Clear;
          edtGrupo.SetFocus;
          exit;
       end;
end;

procedure TfrmConc_Pag_Financeira.edtCodUnidadeInicExit(Sender: TObject);
begin
     if trim(edtCodUnidadeInic.Text) = '' then
       Begin
           edtCodUnidadeInic.Text := '0';
           exit;
       end;
     try
       strtofloat(edtCodUnidadeInic.Text);
     except
       Informacao('Digitação inválida!!!', 'Aviso...');
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

procedure TfrmConc_Pag_Financeira.edtCodUnidadeFinalExit(Sender: TObject);
begin
     if trim(edtCodUnidadeFinal.Text) = '' then
        Begin
           edtCodUnidadeFinal.Text := '999999';
           exit;
        end;
     try
       strtofloat(edtCodUnidadeFinal.Text);
     except
       Informacao('Digitação inválida!!!', 'Aviso...');
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

procedure TfrmConc_Pag_Financeira.edtDataInicialExit(Sender: TObject);
var
 x : String;
aux: Integer;
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
       if (aux <= 20000101) then begin
         Informacao('Data inválida!!!', 'Aviso...');
         edtDataInicial.Clear;
         edtDataInicial.SetFocus;
         exit;
        end else if (aux >= 20400101) then begin
         Informacao('Data inválida!!!', 'Aviso...');
         edtDataInicial.Clear;
         edtDataInicial.SetFocus;
         exit;
        end;
     except
       Informacao('Data inválida!!!', 'Aviso...');
       edtDataInicial.Clear;
       edtDataInicial.SetFocus;
       exit;
     end;
end;

procedure TfrmConc_Pag_Financeira.edtDataFinalExit(Sender: TObject);
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
       if (aux <= 20000101) then
        begin
         Informacao('Data inválida!!!', 'Aviso...');
         edtDataFinal.Clear;
         edtDataFinal.SetFocus;
         exit;
        end else if (aux >= 20400101) then
        begin
         Informacao('Data inválida!!!', 'Aviso...');
        edtDataFinal.Clear;
        edtDataFinal.SetFocus;
        exit;
        end;
     except
       Informacao('Data inválida!!!', 'Aviso...');
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

procedure TfrmConc_Pag_Financeira.cbxProdutoEnter(Sender: TObject);
begin
    KeyPreview := False;
    cbxProduto.DroppedDown := True;
end;

procedure TfrmConc_Pag_Financeira.cbxProdutoExit(Sender: TObject);
begin
    if (Trim(cbxProduto.Text) = '') then
    Begin
          Informacao('Escolha um título!!', 'Aviso...');
          cbxProduto.SetFocus;
          exit;
    end;
    if (cbxProduto.text <> 'EMPRÉSTIMO') and (cbxProduto.Text <> 'FINANCIAMENTO') then
    begin
          Informacao('Você deve escolher um título!!', 'Aviso...');
          cbxProduto.SetFocus;
          exit;
    end;
    KeyPreview := True;
end;

procedure TfrmConc_Pag_Financeira.cbxProdutoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
    case Key of
          VK_RETURN : cbxDiver.SetFocus;
          VK_F12 : edtDataFinal.SetFocus;

     end;
end;

procedure TfrmConc_Pag_Financeira.cbxDiverKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
    case Key of
          VK_RETURN : btnOK.SetFocus;
          VK_F12 : cbxProduto.SetFocus;

     end;
end;

procedure TfrmConc_Pag_Financeira.cbxDiverEnter(Sender: TObject);
begin
    KeyPreview := False;
    cbxDiver.DroppedDown := True;
end;

procedure TfrmConc_Pag_Financeira.cbxDiverExit(Sender: TObject);
begin
    if (Trim(cbxProduto.Text) = '') then
    Begin
          Informacao('Escolha um título!!', 'Aviso...');
          cbxDiver.SetFocus;
          exit;
    end;
    if (cbxDiver.text <> 'TODOS') and (cbxDiver.Text <> 'SOMENTE DIVERGÊNCIA') then
    begin
          Informacao('Você deve escolher um título!!', 'Aviso...');
          cbxDiver.SetFocus;
          exit;
    end;
    KeyPreview := True;
end;

procedure TfrmConc_Pag_Financeira.btnCancelarClick(Sender: TObject);
begin
    Close;
end;

procedure TfrmConc_Pag_Financeira.btnOKClick(Sender: TObject);
var
           Size: Cardinal;
   sCod_Produto: string;
      wDta_Vcto: String;
      wDia_Util: Integer;
      wDta_Util: TDate;
begin
   edtGrupoExit(Sender);
   edtCodUnidadeInicExit(Sender);
   edtCodUnidadeFinalExit(Sender);
   edtDataInicialExit(Sender);
   edtDataFinalExit(Sender);
   cbxProdutoExit(Sender);
   cbxDiverExit(Sender);
   pnlDisplay.Visible := true;
   if btnOK.CanFocus then
      btnOK.SetFocus;

{
// Verifica as datas, se são dias úteis ou não, se for, joga para a data anterior o inicial e
// joga para a data posterior o final
   wDia_Util := 0;
   wDta_Util := StrToDate(edtDataInicial.Text);
   wDta_Vcto := edtDataInicial.Text;
     while wDia_Util  = 0 do
     begin
         try
            qryConsulta.Active:= False;
            qryConsulta.SQL.Clear;
            qryConsulta.SQL.Add('select dta_calendario, per_util from ge_datas_calendario where cod_calendario = 10 and dta_calendario = '''+wDta_Vcto+'''');
            qryConsulta.Active := True;
            wDta_Util := qryConsulta.fieldbyname('dta_calendario').AsDateTime;
            wDia_Util := qryConsulta.fieldbyname('per_util').AsInteger;
         except
            wDta_Util := StrToDate(wDta_Vcto);
            wDia_Util := 1;
            Informacao('Data não pode ser verificada...','Atenção!!!');
            edtdatainicial.SetFocus;
         end;
         wDta_Vcto := DateToStr(StrToDate(wDta_Vcto) - 1);
     end;
   edtDataInicial.Text := FormatDateTime('dd/mm/yyyy',wDta_Util);

   wDia_Util := 0;
   wDta_Util := StrToDate(edtDataFinal.Text);
   wDta_Vcto := edtDataFinal.Text;
     while wDia_Util  = 0 do
     begin
         try
            qryConsulta.Active:= False;
            qryConsulta.SQL.Clear;
            qryConsulta.SQL.Add('select dta_calendario, per_util from ge_datas_calendario where cod_calendario = 10 and dta_calendario = '''+wDta_Vcto+'''');
            qryConsulta.Active := True;
            wDta_Util := qryConsulta.fieldbyname('dta_calendario').AsDateTime;
            wDia_Util := qryConsulta.fieldbyname('per_util').AsInteger;
         except
            wDta_Util := StrToDate(wDta_Vcto);
            wDia_Util := 1;
            Informacao('Data não pode ser verificada...','Atenção!!!');
            edtDataFinal.SetFocus;
         end;
         wDta_Vcto := DateToStr(StrToDate(wDta_Vcto) + 1);
     end;
   edtDataFinal.Text := FormatDateTime('dd/mm/yyyy',wDta_Util);

   if qryConsulta.Active then
      qryConsulta.Close;
}

  try
    if cbxProduto.ItemIndex = 0 then begin
      sCod_Produto:= 'EMPRESTIMO';
    end else begin
      sCod_Produto:= 'FINANCIAMENTO';
    end;
    if cbxDiver.ItemIndex = 1 then begin
       sSelecionaRelatorio:= 'select des_rede, cod_unidade, des_unidade, dta_contabil'+
                             ', sum(vlr_cr) as valor_titulos'+
                             ', sum(vlr_cdc_apro) as valor_apro'+
                             ', (sum(vlr_cr) - sum(vlr_cdc_apro)) as dif_tit_ap'+
                             ', sum(vlr_cr_total) as valor_titulos_total'+
                             ', sum(vlr_cdc_apro_total) as valor_apro_total'+
                             ', (sum(vlr_cr_total) - sum(vlr_cdc_apro_total)) as dif_tit_ap_total'+
                             ' from GRZ_REL_PAG_FINANC'+
                             ' where des_usuario = :DES_USUARIO'+
                             ' having (sum(vlr_cr) - sum(vlr_cdc_apro)) <> 0'+
                             ' group by des_rede, cod_unidade, des_unidade, dta_contabil'+
                             ' order by des_rede, cod_unidade, des_unidade, dta_contabil';
       end else begin
       sSelecionaRelatorio:= 'select des_rede, cod_unidade, des_unidade, dta_contabil'+
                             ', sum(vlr_cr) as valor_titulos'+
                             ', sum(vlr_cdc_apro) as valor_apro'+
                             ', (sum(vlr_cr) - sum(vlr_cdc_apro)) as dif_tit_ap'+
                             ', sum(vlr_cr_total) as valor_titulos_total'+
                             ', sum(vlr_cdc_apro_total) as valor_apro_total'+
                             ', (sum(vlr_cr_total) - sum(vlr_cdc_apro_total)) as dif_tit_ap_total'+
                             ' from GRZ_REL_PAG_FINANC'+
                             ' where des_usuario = :DES_USUARIO'+
                             ' group by des_rede, cod_unidade, des_unidade, dta_contabil'+
                             ' order by des_rede, cod_unidade, des_unidade, dta_contabil';
       end;

   Size := 128;
   SetLength(sUsuarioT,Size);
   GetUserName(PChar(sUsuarioT), Size);
   Edit1.Text := sUsuarioT;
   sUsuarioT := Trim(Edit1.Text);
   frmConc_Pag_Financeira.Repaint;
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
         Informacao('Não encontrou registros!!!','Aviso...');
         edtGrupo.SetFocus;
         pnlbuttons.Enabled:= True;
         pnlDisplay.Visible := false;
         frmConc_Pag_Financeira.Repaint;
         exit;
     end;

   pprRelatorio.Print;
   pnlbuttons.Enabled:= True;
   pnlDisplay.Visible := false;
   frmConc_Pag_Financeira.Repaint;
  except
         on e:exception do
      Begin
        informacao('Erro!!! Não gerou relatório...'+chr(13)+
                   e.ClassName + ' - '+e.Message,'Aviso...');
        pnlbuttons.Enabled:= True;
        pnlDisplay.Visible := false;
        frmConc_Pag_Financeira.Repaint;
        exit;
      end;

   end;

end;

procedure TfrmConc_Pag_Financeira.FormShow(Sender: TObject);
begin
   qryConsulta.Active := False;
   qryRel.Active := False;
   Session1.Active := False;
   Database1.Connected := False;

   CarregaParamsBanco;

   Database1.KeepConnection := False;
   Database1.LoginPrompt := False;

   Database1.Params.Values['SERVER NAME'] := sBanco;
   Database1.Params.Values['USER NAME']   := sUsuario;
   Database1.Params.Values['PASSWORD']    := sSenha;

   try
      Database1.Connected := True;
      Session1.Active := True;
      dtServidor := RetornaDataServidor;
   except
      on E: Exception do
      begin
      Informacao('Erro!!!'+#13+'Não pode se conectar ao banco!!!'+E.Message,'Aviso!!!');
      frmConc_Pag_Financeira.Close;


     end;


   end;
end;

procedure TfrmConc_Pag_Financeira.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
     case Key of
          VK_RETURN, VK_DOWN: Perform(WM_NEXTDLGCTL,0,0);
          VK_UP : Perform(WM_NEXTDLGCTL,1,0);
     end;
end;

procedure TfrmConc_Pag_Financeira.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   try
      if qryConsulta.Active then
         qryConsulta.Active := False;
      if qryRel.Active then
         qryRel.Active := False;
      if Session1.Active then
         Session1.Active := False;
      if Database1.Connected then
         Database1.Connected := False;
      Action := caFree;
   except
      Informacao('Não foi possível se Desconectar do Banco!!! Tente Novamente!!!', 'Atenção');
      Abort;
   end;
end;

procedure TfrmConc_Pag_Financeira.pplParametrosPrint(Sender: TObject);
begin
     pplParametros.Caption := 'Conciliação de Pagamentos Financeiros - Grupo '+trim(edtGrupo.Text)+
                              ' - Unidade '+trim(edtCodUnidadeInic.Text)+
                              ' até ' + trim(edtCodUnidadeFinal.Text) + ' - Período ' + trim(edtDataInicial.Text) +
                              ' até ' + trim(edtDataFinal.Text);
end;

procedure TfrmConc_Pag_Financeira.pprRelatorioPreviewFormCreate(
  Sender: TObject);
begin
     pprRelatorio.PreviewForm.WindowState := wsMaximized;
     TppViewer(pprRelatorio.PreviewForm.Viewer).ZoomPercentage := 100;
end;

procedure TfrmConc_Pag_Financeira.pplblcod_produtoPrint(Sender: TObject);
begin
      pplblcod_produto.Caption:= cbxProduto.Text;
end;

procedure TfrmConc_Pag_Financeira.CarregaParamsBanco;
var TomEncryption1: TTomEncryption;
begin
    TomEncryption1 := TTomEncryption.Create(Self);
    CarregaSenhasBancoOra('GRZPNL_BERLIN',TomEncryption1,sUsuario,sSenha,sBanco);
end;

end.
