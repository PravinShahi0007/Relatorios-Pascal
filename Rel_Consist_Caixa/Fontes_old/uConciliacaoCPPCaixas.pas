unit uConciliacaoCPPCaixas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBTables, DB, StdCtrls, Buttons, Mask, ExtCtrls, ComCtrls, Registry,
  ppProd, ppClass, ppReport, ppComm, ppRelatv, ppDB, ppDBPipe, ppDBBDE,
  ppCtrls, ppStrtch, ppMemo, ppVar, ppPrnabl, ppBands, ppCache;

type
  TfrmRelDivCPP_Caixa = class(TForm)
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
    Label3: TLabel;
    Panel9: TPanel;
    Panel10: TPanel;
    btnOK: TBitBtn;
    btnCancelar: TBitBtn;
    edtContaInicial: TMaskEdit;
    Label16: TLabel;
    ppLabel1: TppLabel;
    ppDBText7: TppDBText;
    ppDBText1: TppDBText;
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
//    Procedure AtualizaCamposRede(rede : integer);
//    procedure chkTodosClick(Sender: TObject);
//    procedure chkBanrisulClick(Sender: TObject);
//    procedure chkVisaClick(Sender: TObject);
//    procedure chkRedeCardClick(Sender: TObject);
//    procedure chkRedeCardExit(Sender: TObject);
    Function RetornaDataServidor : tdate;
    procedure FormShow(Sender: TObject);
    procedure rdbRedecardEnter(Sender: TObject);
    procedure ppDBText14Print(Sender: TObject);
    procedure pplParametrosPrint(Sender: TObject);
    procedure pplRedeCartaoPrint(Sender: TObject);
    procedure edtContaInicialExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRelDivCPP_Caixa: TfrmRelDivCPP_Caixa;
  sParamentro, sListar : string;
  sUsuario, sRede : string;
  dtServidor : tdate;


implementation

uses UFunc, uFuncoes;

{$R *.dfm}

Function TfrmRelDivCPP_Caixa.RetornaDataServidor : tdate;
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

function TfrmRelDivCPP_Caixa.LogUser : String;
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

procedure TfrmRelDivCPP_Caixa.btnOKClick(Sender: TObject);
Var
   Size : Cardinal;
   sSelect : String;
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
   frmRelDivCPP_Caixa.Repaint;
   //sUsuario := 'Ismaile';//UpperCase(sUsuario);
   edtGrupoExit(Sender);
   edtCodUnidadeInicExit(Sender);
   edtCodUnidadeFinalExit(Sender);
   edtDataInicialExit(Sender);
   edtDataFinalExit(Sender);
   edtContaInicialExit(Sender);

   StpConciliacao.Close;
   sParamentro := trim(edtGrupo.Text)+'#'+
                  trim(edtCodUnidadeInic.Text)+'#'+
                  trim(edtCodUnidadeFinal.Text)+'#'+
                  trim(edtDataInicial.Text)+'#'+
                  trim(edtDataFinal.Text)+'#'+
                  trim(edtContaInicial.Text)+'#'+
                  sUsuario+'#';
   StpConciliacao.Params[0].Value := sParamentro;
   StpConciliacao.ExecProc;

   if sListar = '1' then
      sSelect := 'SELECT DES_USUARIO,DES_REDE,COD_AUTORIZACAO,DES_ORIGEM'+
                 ',COD_EMP,COD_UNIDADE,DTA_MOVIMENTO,DES_UNIDADE'+
                 ',SUM(VLR_LCTO) VLR_LCTO'+
                 ',SUM(VLR_LCTO_SERV) VLR_LCTO_SERV'+
                 ',(SUM(VLR_LCTO) - SUM(VLR_LCTO_SERV)) VLR_DIFERENCA '+
                 'FROM GRZ_TEF_TRANSACAO_DIVERGENCIAS '+
                 'WHERE DES_USUARIO = :DES_USUARIO '+
                 'GROUP BY DES_USUARIO,DES_REDE,COD_AUTORIZACAO,DES_ORIGEM'+
                 ',COD_EMP,COD_UNIDADE,DTA_MOVIMENTO,DES_UNIDADE '+
                 'ORDER BY DES_USUARIO,DES_REDE,COD_AUTORIZACAO'+
                 ',COD_EMP,COD_UNIDADE,DTA_MOVIMENTO'
   else
      sSelect := 'SELECT DES_USUARIO,DES_REDE,COD_AUTORIZACAO,DES_ORIGEM'+
                 ',COD_EMP,COD_UNIDADE,DTA_MOVIMENTO,DES_UNIDADE'+
                 ',SUM(VLR_LCTO) VLR_LCTO'+
                 ',SUM(VLR_LCTO_SERV) VLR_LCTO_SERV'+
                 ',(SUM(VLR_LCTO) - SUM(VLR_LCTO_SERV)) VLR_DIFERENCA '+
                 'FROM GRZ_TEF_TRANSACAO_DIVERGENCIAS '+
                 'WHERE DES_USUARIO = :DES_USUARIO '+
                 'HAVING (SUM(VLR_LCTO) - SUM(VLR_LCTO_SERV)) <> 0 '+
                 'GROUP BY DES_USUARIO,DES_REDE,COD_AUTORIZACAO,DES_ORIGEM'+
                 ',COD_EMP,COD_UNIDADE,DTA_MOVIMENTO,DES_UNIDADE '+
                 'ORDER BY DES_USUARIO,DES_REDE,COD_AUTORIZACAO'+
                 ',COD_EMP,COD_UNIDADE,DTA_MOVIMENTO';


   qryRel.Active := false;
   qryRel.SQL.Clear;
   qryRel.SQL.Add(sSelect);
   qryRel.ParamByName('des_usuario').AsString := sUsuario;
   qryRel.Active := true;
   if qryRel.RecordCount <= 0 then
     Begin
         informacao('Não encontrou divergencias!!!','Aviso...');
         edtGrupo.SetFocus;
         pnlDisplay.Visible := false;
         frmRelDivCPP_Caixa.Repaint;
         exit;
     end;

   pprRelatorio.Print;
   pnlDisplay.Visible := false;
   frmRelDivCPP_Caixa.Repaint;
   except
      informacao('Erro!!! Não gerou relatório...','Aviso...');
      pnlDisplay.Visible := false;
      frmRelDivCPP_Caixa.Repaint;
      exit;
   end;

end;

procedure TfrmRelDivCPP_Caixa.edtGrupoExit(Sender: TObject);
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
       if (strtofloat(edtGrupo.Text) = 910) then
            edtContaInicial.Text := '430'
       else
       if (strtofloat(edtGrupo.Text) = 920) then
            edtContaInicial.Text := '434'
       else
       if (strtofloat(edtGrupo.Text) = 930) then
            edtContaInicial.Text := '432'
       else
       if (strtofloat(edtGrupo.Text) = 940) then
            edtContaInicial.Text := '433'
       else
       if (strtofloat(edtGrupo.Text) = 950) then
            edtContaInicial.Text := '431'
       else
            edtContaInicial.Text := '430';
end;

procedure TfrmRelDivCPP_Caixa.edtCodUnidadeInicExit(Sender: TObject);
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

procedure TfrmRelDivCPP_Caixa.edtCodUnidadeFinalExit(Sender: TObject);
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

procedure TfrmRelDivCPP_Caixa.edtDataInicialExit(Sender: TObject);
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

procedure TfrmRelDivCPP_Caixa.edtDataFinalExit(Sender: TObject);
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

procedure TfrmRelDivCPP_Caixa.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     case Key of
          VK_RETURN, VK_DOWN: Perform(WM_NEXTDLGCTL,0,0);
          VK_UP : Perform(WM_NEXTDLGCTL,1,0);
     end;
end;

procedure TfrmRelDivCPP_Caixa.btnCancelarClick(Sender: TObject);
begin
     if btnCancelar.CanFocus then
        btnCancelar.SetFocus;
     close;
end;
{Procedure TfrmConcServLojas.AtualizaCamposRede(rede : integer);
Begin

    case rede of
    0 : Begin //todos
            chkTodos.Checked := true;
            chkBanrisul.Checked := false;
            chkVisa.Checked := false;
            chkRedeCard.Checked := False;
            sRede := '0';
        end;
    1 : Begin  //Banrisul
            chkTodos.Checked := false;
            chkBanrisul.Checked := true;
            chkVisa.Checked := false;
            chkRedeCard.Checked := false;
            sRede := '1';
        end;
    2 : Begin //Visa
            chkTodos.Checked := false;
            chkBanrisul.Checked := false;
            chkVisa.Checked := true;
            chkRedeCard.Checked := false;
            sRede := '2';
        end;
    3 : Begin  //RedeCard
            chkTodos.Checked := false;
            chkBanrisul.Checked := false;
            chkVisa.Checked := false;
            chkRedeCard.Checked := true;
            sRede := '3';
        end;
    end;

end; }

{procedure TfrmConcServLojas.chkTodosClick(Sender: TObject);
begin
     AtualizaCamposRede(0);
end;

procedure TfrmConcServLojas.chkBanrisulClick(Sender: TObject);
begin
     AtualizaCamposRede(1);
end;

procedure TfrmConcServLojas.chkVisaClick(Sender: TObject);
begin
     AtualizaCamposRede(2);
end;

procedure TfrmConcServLojas.chkRedeCardClick(Sender: TObject);
begin
     AtualizaCamposRede(3);
end;

procedure TfrmConcServLojas.chkRedeCardExit(Sender: TObject);
begin
     btnOK.SetFocus;
end;
     }
procedure TfrmRelDivCPP_Caixa.FormShow(Sender: TObject);
begin
     dtServidor := RetornaDataServidor;
end;

procedure TfrmRelDivCPP_Caixa.rdbRedecardEnter(Sender: TObject);
begin
     btnOK.SetFocus;
end;

procedure TfrmRelDivCPP_Caixa.ppDBText14Print(Sender: TObject);
begin
   //ppDBText14.Caption := UpperCase(qryRel.fieldByName('DES_REDE').AsString);
end;

procedure TfrmRelDivCPP_Caixa.pplParametrosPrint(Sender: TObject);
begin
     pplParametros.Caption := ' Crédito Pessoal x Caixas - Grupo '+trim(edtGrupo.Text)+ ' - Unidade '+trim(edtCodUnidadeInic.Text)+
                              ' até ' + trim(edtCodUnidadeFinal.Text) + ' - Período ' + trim(edtDataInicial.Text) +
                              ' até ' + trim(edtDataFinal.Text);
end;

procedure TfrmRelDivCPP_Caixa.pplRedeCartaoPrint(Sender: TObject);
begin
   //pplRedeCartao.Caption := UpperCase(qryRel.fieldByName('DES_REDE').AsString);
end;

procedure TfrmRelDivCPP_Caixa.edtContaInicialExit(Sender: TObject);
begin
     if (AllTrim(edtContaInicial.Text) <> '430') and
        (AllTrim(edtContaInicial.Text) <> '431') and
        (AllTrim(edtContaInicial.Text) <> '432') and
        (AllTrim(edtContaInicial.Text) <> '433') and
        (AllTrim(edtContaInicial.Text) <> '434') then
     begin
          Informacao('Conta deve ser igual:'+#13+
                     '430=Grazziotin'+#13+
                     '431=Tottal'+#13+
                     '432=Por Menos'+#13+
                     '433=Franco Giorgi'+#13+
                     '434=Arrazzo'+#13+
                     'Informe', 'Aviso...');
          edtContaInicial.Clear;
          edtContaInicial.SetFocus;
          exit;
     end;
end;

end.
