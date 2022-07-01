unit uRelConsistCaixa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBTables, DB, StdCtrls, Buttons, Mask, ExtCtrls, ComCtrls, Registry,
  ppProd, ppClass, ppReport, ppComm, ppRelatv, ppDB, ppDBPipe, ppDBBDE,
  ppCtrls, ppStrtch, ppMemo, ppVar, ppPrnabl, ppBands, ppCache;

type
  TfrmRel_Consist_Caixa = class(TForm)
    qryRel: TQuery;
    Database1: TDatabase;
    StpConciliacao: TStoredProc;
    Session1: TSession;
    pprRelatorio: TppReport;
    DataSource1: TDataSource;
    ppHeaderBand1: TppHeaderBand;
    ppDetailBand1: TppDetailBand;
    ppFooterBand1: TppFooterBand;
    ppDBText4: TppDBText;
    ppMemo2: TppMemo;
    ppShape2: TppShape;
    ppLabel16: TppLabel;
    ppLabel20: TppLabel;
    ppLabel22: TppLabel;
    ppLabel27: TppLabel;
    ppDBText2: TppDBText;
    ppDBText3: TppDBText;
    ppDBText5: TppDBText;
    ppDBText6: TppDBText;
    ppDBPipeline1: TppDBPipeline;
    ppGroup1: TppGroup;
    ppGroupHeaderBand1: TppGroupHeaderBand;
    ppGroupFooterBand1: TppGroupFooterBand;
    ppDBText13: TppDBText;
    ppGroup3: TppGroup;
    ppGroupHeaderBand3: TppGroupHeaderBand;
    ppGroupFooterBand3: TppGroupFooterBand;
    ppLine1: TppLine;
    ppDBCalc1: TppDBCalc;
    ppDBCalc2: TppDBCalc;
    ppLabel2: TppLabel;
    ppLabel4: TppLabel;
    ppDBCalc8: TppDBCalc;
    ppLabel6: TppLabel;
    ppDBText9: TppDBText;
    ppLabel7: TppLabel;
    ppLabel15: TppLabel;
    ppSystemVariable4: TppSystemVariable;
    ppSystemVariable3: TppSystemVariable;
    ppLabel9: TppLabel;
    ppLabel10: TppLabel;
    pplParametros: TppLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
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
    pnlDisplay: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Animate1: TAnimate;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    btnOK: TBitBtn;
    btnCancelar: TBitBtn;
    ppLabel1: TppLabel;
    Panel11: TPanel;
    Label3: TLabel;
    edtRede: TMaskEdit;
    Panel12: TPanel;
    Label5: TLabel;
    ppDBCalc3: TppDBCalc;
    ppDBCalc4: TppDBCalc;
    ppDBCalc5: TppDBCalc;
    ppLine2: TppLine;
    ppLabel3: TppLabel;
    ppLabel5: TppLabel;
    ppDBCalc6: TppDBCalc;
    ppDBCalc7: TppDBCalc;
    ppDBCalc9: TppDBCalc;
    ppLine3: TppLine;
    ppLine4: TppLine;
    qryRelCOD_UNIDADE: TFloatField;
    qryRelDES_UNIDADE: TStringField;
    qryRelDTA_MOVIMENTO: TDateTimeField;
    qryRelNUM_EQUIPAMENTO: TFloatField;
    qryRelVLR_ADM: TFloatField;
    qryRelVLR_SERV: TFloatField;
    qryRelVLR_DIFERENCA: TFloatField;
    rdgListar: TRadioGroup;
    procedure btnOKClick(Sender: TObject);
    Function LogUser : string;
    procedure edtGrupoExit(Sender: TObject);
    procedure edtCodUnidadeInicExit(Sender: TObject);
    procedure edtCodUnidadeFinalExit(Sender: TObject);
    procedure edtDataInicialExit(Sender: TObject);
    procedure edtDataFinalExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnCancelarClick(Sender: TObject);
    Function RetornaDataServidor : tdate;
    procedure FormShow(Sender: TObject);
    procedure ppDBText14Print(Sender: TObject);
    procedure pplParametrosPrint(Sender: TObject);
    procedure ppLabel1Print(Sender: TObject);
    procedure edtRedeExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRel_Consist_Caixa: TfrmRel_Consist_Caixa;
  sParamentro, sListar : string;
  sUsuario, sRede : string;
  dtServidor : tdate;


implementation

uses UFunc, uFuncoes;

{$R *.dfm}

Function TfrmRel_Consist_Caixa.RetornaDataServidor : tdate;
Begin
    qryRel.Active := false;
    qryRel.SQL.Clear;
    qryRel.SQL.Add('select sysdate from dual');
    try
      qryRel.Active := true;
      result := qryRel.fieldByName('sysdate').AsDateTime;
    except
      Result := date;
    end;

end;

function TfrmRel_Consist_Caixa.LogUser : String;
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

procedure TfrmRel_Consist_Caixa.btnOKClick(Sender: TObject);
Var
   Size : Cardinal;
   sSelect, sListar : String;

begin
   if(rdgListar.ItemIndex = 0)then
      sListar := '1'
   else sListar := '0';
   try
   Size := 128;
   SetLength(sUsuario,Size);
   GetUserName(PChar(sUsuario), Size);
   Edit1.Text := sUsuario;
   sUsuario := Trim(Edit1.Text);
   pnlDisplay.Visible := true;
   //frmRelDivCPP_Caixa.Repaint;
   frmRel_Consist_Caixa.Repaint;
   //sUsuario := 'suplojas';//'Ismaile';//UpperCase(sUsuario);
   edtGrupoExit(Sender);
   edtCodUnidadeInicExit(Sender);
   edtCodUnidadeFinalExit(Sender);
   edtDataInicialExit(Sender);
   edtDataFinalExit(Sender);
   //edtContaInicialExit(Sender);

   StpConciliacao.Close;
   sParamentro := trim(edtRede.Text)+'#'+
                  trim(edtGrupo.Text)+'#'+
                  trim(edtCodUnidadeInic.Text)+'#'+
                  trim(edtCodUnidadeFinal.Text)+'#'+
                  trim(edtDataInicial.Text)+'#'+
                  trim(edtDataFinal.Text)+'#'+
                  sUsuario+'#';
   StpConciliacao.Params[0].Value := sParamentro;
   StpConciliacao.ExecProc;

   if sListar = '1' then
       sSelect :=  'SELECT COD_UNIDADE, '+
                     'des_unidade, '+
                     'DTA_MOVIMENTO, '+
                     'NUM_EQUIPAMENTO, '+
                     'sum(vlr_lcto) vlr_adm, '+
                     'sum(vlr_lcto_serv) as vlr_serv, '+
                     '(SUM(VLR_LCTO) - SUM(VLR_LCTO_SERV)) VLR_DIFERENCA '+
                     'FROM GRZ_TEF_TRANSACAO_DIVERGENCIAS '+
                     'WHERE DES_USUARIO =  :des_usuario '+
                     'GROUP BY COD_UNIDADE, des_unidade, DTA_MOVIMENTO, NUM_EQUIPAMENTO '+
                     'ORDER BY COD_UNIDADE, des_unidade, DTA_MOVIMENTO, NUM_EQUIPAMENTO '
   else
       sSelect :=  'SELECT COD_UNIDADE, '+
                     'des_unidade, '+
                     'DTA_MOVIMENTO, '+
                     'NUM_EQUIPAMENTO, '+
                     'sum(vlr_lcto) vlr_adm, '+
                     'sum(vlr_lcto_serv) as vlr_serv, '+
                     '(SUM(VLR_LCTO) - SUM(VLR_LCTO_SERV)) VLR_DIFERENCA '+
                     'FROM GRZ_TEF_TRANSACAO_DIVERGENCIAS '+
                     'WHERE DES_USUARIO =  :des_usuario '+
                     'HAVING (SUM(VLR_LCTO) - SUM(VLR_LCTO_SERV)) <> 0 '+
                     'GROUP BY COD_UNIDADE, des_unidade, DTA_MOVIMENTO, NUM_EQUIPAMENTO '+
                     'ORDER BY COD_UNIDADE, des_unidade, DTA_MOVIMENTO, NUM_EQUIPAMENTO ';

   qryRel.Active := false;
   qryRel.SQL.Clear;
   qryRel.SQL.Add(sSelect);
   qryRel.ParamByName('des_usuario').AsString := sUsuario;
   qryRel.Active := true;
   if qryRel.RecordCount <= 0 then
     Begin
         informacao('Não encontrou divergencias!!!','Aviso...');
         //edtGrupo.SetFocus;
         edtRede.SetFocus;
         pnlDisplay.Visible := false;
         //frmRelDivCPP_Caixa.Repaint;
         frmRel_Consist_Caixa.Repaint;
         exit;
     end;

   pprRelatorio.Print;
   pnlDisplay.Visible := false;
   //frmRelDivCPP_Caixa.Repaint;
   frmRel_Consist_Caixa.Repaint;
   except
      on e:Exception do
      begin
      informacao(e.ClassName +' - '+e.Message,'Aviso...');
      pnlDisplay.Visible := false;
      //frmRelDivCPP_Caixa.Repaint;
      frmRel_Consist_Caixa.Repaint;
      exit;
      end;
   end;

end;

procedure TfrmRel_Consist_Caixa.edtGrupoExit(Sender: TObject);
begin
     if trim(edtGrupo.Text) = '' then
       Begin
           edtGrupo.Text := '0000';
           exit;
       end;
     try
       strtofloat(edtGrupo.Text);
     except
       Informacao('Digitação inválida!!!', 'Aviso...');
       edtGrupo.Clear;
       edtGrupo.SetFocus;
       exit;
     end;
     if (strtofloat(edtGrupo.Text) <> 910) and
        (strtofloat(edtGrupo.Text) <> 920) and
        (strtofloat(edtGrupo.Text) <> 930) and
        (strtofloat(edtGrupo.Text) <> 940) and
        (strtofloat(edtGrupo.Text) <> 950) then
       Begin
          Informacao('Código grupo deve ser igual:'+#13+
                     '910=Grazziotin'+#13+
                     '920=Arrazzo'+#13+
                     '930=Por Menos'+#13+
                     '940=Franco Giorgi'+#13+
                     '950=Tottal'+#13+
                     'Informe', 'Aviso...');
          edtGrupo.Clear;
          edtGrupo.SetFocus;
          exit;
       end;

end;

procedure TfrmRel_Consist_Caixa.edtCodUnidadeInicExit(Sender: TObject);
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
          Informacao('Código deve ser maior que 0', 'Aviso...');
          edtCodUnidadeInic.Clear;
          edtCodUnidadeInic.SetFocus;
          exit;
       end;
end;

procedure TfrmRel_Consist_Caixa.edtCodUnidadeFinalExit(Sender: TObject);
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
          Informacao('Código final deve ser maior que o código inicial', 'Aviso...');
          edtCodUnidadeFinal.Clear;
          edtCodUnidadeFinal.SetFocus;
          exit;
       end;
end;

procedure TfrmRel_Consist_Caixa.edtDataInicialExit(Sender: TObject);
begin
     if alltrim(edtDataInicial.Text) = '//' then
       Begin
          edtDataInicial.Text := FormatDateTime('dd/mm/yyyy',dtServidor);
          exit;
       end;
     try
       strtoDate(edtDataInicial.Text);
     except
       Informacao('Data inválida!!!', 'Aviso...');
       edtDataInicial.Clear;
       edtDataInicial.SetFocus;
       exit;
     end;
end;

procedure TfrmRel_Consist_Caixa.edtDataFinalExit(Sender: TObject);
begin
     if AllTrim(edtDataFinal.Text) = '//' then
        Begin
            edtDataFinal.Text := FormatDateTime('dd/mm/yyyy',dtServidor);
            exit;
        end;
     try
       strtoDate(edtDataFinal.Text);
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
end;

procedure TfrmRel_Consist_Caixa.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     case Key of
          VK_RETURN, VK_DOWN: Perform(WM_NEXTDLGCTL,0,0);
          VK_UP : Perform(WM_NEXTDLGCTL,1,0);
     end;
end;

procedure TfrmRel_Consist_Caixa.btnCancelarClick(Sender: TObject);
begin
     if btnCancelar.CanFocus then
        btnCancelar.SetFocus;
     close;
end;


procedure TfrmRel_Consist_Caixa.FormShow(Sender: TObject);
begin
     dtServidor := RetornaDataServidor;
end;

procedure TfrmRel_Consist_Caixa.ppDBText14Print(Sender: TObject);
begin
   //ppDBText14.Caption := UpperCase(qryRel.fieldByName('DES_REDE').AsString);
end;

procedure TfrmRel_Consist_Caixa.pplParametrosPrint(Sender: TObject);
begin
     pplParametros.Caption := ' Caixas x NL - Grupo '+trim(edtGrupo.Text)+ ' - Unidade '+trim(edtCodUnidadeInic.Text)+
                              ' até ' + trim(edtCodUnidadeFinal.Text) + ' - Período ' + trim(edtDataInicial.Text) +
                              ' até ' + trim(edtDataFinal.Text);
end;


procedure TfrmRel_Consist_Caixa.ppLabel1Print(Sender: TObject);
begin
                                                                              
   ppLabel1.Text := ' ';
   case qryRel.FieldByName('NUM_EQUIPAMENTO').AsInteger of
     10 : ppLabel1.Text := '220 - VENDA AVISTA';
     20 : ppLabel1.Text := '221 - ENT. APRAZO';
     30 : ppLabel1.Text := '223 - VENDA CARTAO';
     40 : ppLabel1.Text := '469 - REC. CREDIARIO';
     50 : ppLabel1.Text := '325 - JUROS REC.';
     60 : ppLabel1.Text := '229 - NTF DEVOLUÇÃO';
     70 : ppLabel1.Text := '467,438,439,478,479 - TEF';
     80 : ppLabel1.Text := '430 - CREDITO PESSOAL';
   end;

end;

procedure TfrmRel_Consist_Caixa.edtRedeExit(Sender: TObject);
begin
  if trim(edtRede.Text) = '' then
       Begin
           edtRede.Text := '0000';
           exit;
       end;
     try
       strtofloat(edtRede.Text);
     except
       Informacao('Digitação inválida!!!', 'Aviso...');
       edtRede.Clear;
       edtRede.SetFocus;
       exit;
     end;
     if (strtofloat(edtRede.Text) <> 10) and
        (strtofloat(edtRede.Text) <> 20) and
        (strtofloat(edtRede.Text) <> 30) and
        (strtofloat(edtRede.Text) <> 40) and
        (strtofloat(edtRede.Text) <> 50) then
       Begin
          Informacao('Código grupo deve ser igual:'+#13+
                     '10=Grazziotin'+#13+
                     '20=Arrazzo'+#13+
                     '30=Por Menos'+#13+
                     '40=Franco Giorgi'+#13+
                     '50=Tottal'+#13+
                     'Informe', 'Aviso...');
          edtRede.Clear;
          edtRede.SetFocus;
          exit;
       end;


end;

procedure TfrmRel_Consist_Caixa.FormActivate(Sender: TObject);
begin
    edtRede.SetFocus;
end;

end.
