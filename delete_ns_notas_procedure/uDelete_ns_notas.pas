unit uDelete_ns_notas;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ppParameter, ppBands, ppCtrls, jpeg, ppVar, ppPrnabl, ppClass,
    ppCache, ppProd, ppReport, ppDB, ppComm, ppRelatv, ppDBPipe, DB,
    DBTables, StdCtrls, Mask, Buttons, ExtCtrls, uFuncoes, FireDAC.Stan.Intf,
    FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
    FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
    FireDAC.Phys.Oracle, FireDAC.Phys.OracleDef, FireDAC.VCLUI.Wait,
    FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
    FireDAC.Comp.Client, FireDAC.Comp.DataSet;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Database1: TFDConnection;
    spRetorno: TFDStoredProc;
    qryGeral: TFDQuery;
    dtsGeral: TDataSource;
    Panel1: TPanel;
    Panel2: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    btnGerar: TBitBtn;
    btnFechar: TBitBtn;
    edtCodUni: TMaskEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    edtNota: TMaskEdit;
    Edit2: TEdit;
    edtDtaEmissao: TMaskEdit;
    chkCanc: TCheckBox;
    cbTipoNota: TComboBox;
    Edit3: TEdit;
    procedure btnGerarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure edtDtaEmissaoExit(Sender: TObject);
    procedure edtCodUniKeyPress(Sender: TObject; var Key: Char);
    procedure edtNotaKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbTipoNotaExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtCodUniExit(Sender: TObject);
    procedure edtNotaExit(Sender: TObject);
    procedure cbTipoNotaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CarregaParamsBanco;
  private
         { Private declarations }
  public
        { Public declarations }
  end;

var
   Form1: TForm1;
   sParametros, sData, sNota, sCodUni, sDtaEmissao, sSerie, sCanc, sEquipamento,
   sUsuario, sSenha, sBanco : String;

implementation

{$R *.dfm}

uses Encryp, uCarregaSenha;

procedure TForm1.btnGerarClick(Sender: TObject);
begin
     if (AllTrim(edtCodUni.Text) = '') or (AllTrim(edtNota.Text) = '')
        or (AllTrim(edtDtaEmissao.Text) = '//') or (cbTipoNota.ItemIndex = 0) then
     begin
          Informacao('Preencha todos os campos!','Aviso!');
          Abort;
          Exit;
     end;

     if (chkCanc.Checked) = True then
        sCanc := '1'
     else
         sCanc := '0';

     sNota := AllTrim(edtNota.Text);
     sCodUni := AllTrim(edtCodUni.Text);
     sDtaEmissao := AllTrim(edtDtaEmissao.Text);

     if not Database1.Connected then
        Database1.Connected := True;


     if cbTipoNota.ItemIndex = 1 then
     begin
          qryGeral.active := False;
          qryGeral.sql.Text := ' SELECT cod_unidade, num_nota, cod_serie, cod_serie as  num_equipamento   '+
                               ' from nl.ai_ne_notas                        '+
                               ' where num_nota = :num_nota                '+
                               ' and cod_unidade = :cod_unidade          '+
                               ' and dta_emissao = :dta_emissao       ';

     end;

     if cbTipoNota.ItemIndex = 2 then
     begin
          qryGeral.active := False;
          qryGeral.sql.Text := ' SELECT cod_unidade, num_nota, cod_serie, num_equipamento   '+
                               ' from nl.ai_ns_notas                        '+
                               ' where num_nota = :num_nota                '+
                               ' and cod_unidade = :cod_unidade          '+
                               ' and dta_emissao = :dta_emissao       ';
     end;

     qryGeral.ParamByName('num_nota').AsString := sNota;
     qryGeral.ParamByName('cod_unidade').AsString := sCodUni;
     qryGeral.ParamByName('dta_emissao').AsString := sDtaEmissao;

     if not(qryGeral.Active) then
        qryGeral.Active := True;

     sSerie := qryGeral.FieldByName('cod_serie').AsString;
     sEquipamento := qryGeral.FieldByName('num_equipamento').AsString;

     if (qryGeral.IsEmpty) then
     begin
          Informacao('Cupom n�o encontrado!','Aviso');
          qryGeral.Active := False;
          Abort;
          Exit;
     end;

     if not Pergunta('Tem certeza que deseja deletar os registros?','Aten��o!') then
     begin
          qryGeral.Active := False;
          Abort;
          Exit;
     end;

     if cbTipoNota.ItemIndex = 1 then
     begin
          qryGeral.Active := False;
          spRetorno.Prepare;
          sParametros := ''+Trim(edtCodUni.Text)+'#'+Trim(edtNota.Text)+'#'+Trim(sSerie)+'#'+sData+'#'+Trim(sEquipamento)+'#';
          spRetorno.Params[0].Value := sParametros;
          spRetorno.ExecProc;
          Informacao(spRetorno.Params[1].Text,'Informa��o');
          spRetorno.Close;
          qryGeral.Active := False;
     end
     else
         if cbTipoNota.ItemIndex = 2 then
         begin
              qryGeral.Active := False;
              spRetorno.Prepare;
              sParametros := ''+Trim(edtCodUni.Text)+'#'+Trim(edtNota.Text)+'#'+Trim(sSerie)+'#'+sData+'#'+sCanc+'#'+Trim(sEquipamento)+'#';
              spRetorno.Params[0].Value := sParametros;
              spRetorno.ExecProc;
              Informacao(spRetorno.Params[1].Text,'Informa��o');
              spRetorno.Close;
              qryGeral.Active := False;
         end;
end;

procedure TForm1.cbTipoNotaExit(Sender: TObject);
begin
     if cbTipoNota.ItemIndex = 0 then
     begin
          ShowMessage('Escolha o tipo da nota !!!');
          cbTipoNota.SetFocus;
          Abort;
     end
     else
         if cbTipoNota.ItemIndex = 1 then
         begin
              spRetorno.StoredProcName := 'NL.GRZ_DELETA_NOTAS_ENTRADA_SP';
              edtNota.SetFocus;
         end
         else
             if cbTipoNota.ItemIndex = 2 then
             begin
                  spRetorno.StoredProcName := 'NL.GRZ_DELETA_AI_NOTAS_SP';
                  edtNota.SetFocus;
             end;
end;

procedure TForm1.cbTipoNotaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if (key = VK_RETURN) then
     begin
          edtNota.SetFocus;
          key := 0;
     end;
end;

procedure TForm1.btnFecharClick(Sender: TObject);
begin
     Close;
end;

procedure TForm1.edtDtaEmissaoExit(Sender: TObject);
begin
     if (AllTrim(edtDtaEmissao.Text) = '//') then
     begin
          ShowMessage('Informe a data !!!');
          edtDtaEmissao.SetFocus;
          Abort;
          Exit;
     end
     else
         begin
              chkCanc.SetFocus;
         end;

     sData := edtDtaEmissao.Text;

     if ValidaData(sData) then
     begin
          ShowMessage('Data inv�lida !!!');
          edtDtaEmissao.SetFocus;
          Abort;
          Exit;
     end
     else
         begin
              chkCanc.SetFocus;
         end;

     sData := DateToStr(StrToDate(sData));
end;

procedure TForm1.edtCodUniExit(Sender: TObject);
begin
     if edtCodUni.Text = '' then
     begin
          ShowMessage('Informe a unidade !!!');
          edtCodUni.SetFocus;
          Abort;
     end
     else
         begin
              cbTipoNota.SetFocus
         end;
end;

procedure TForm1.edtCodUniKeyPress(Sender: TObject; var Key: Char);
begin
     if not (Key in [#8, '0'..'9']) then
     begin
          Key := #0;
     end;
end;

procedure TForm1.edtNotaExit(Sender: TObject);
begin
     if edtNota.Text = '' then
     begin
          ShowMessage('Informe a nota !!!');
          edtNota.SetFocus;
          Abort;
     end
     else
         begin
              edtDtaEmissao.SetFocus;
         end;
end;

procedure TForm1.edtNotaKeyPress(Sender: TObject; var Key: Char);
begin
     if not (Key in [#8, '0'..'9']) then
     begin
          Key := #0;
     end;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     case Key of
          VK_RETURN: Perform(WM_NEXTDLGCTL,0,0);
     end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
     qryGeral.Active := False;
     Database1.Connected := False;

     CarregaParamsBanco;
     Database1.LoginPrompt := False;

     Database1.Params.Values['SERVER NAME'] := sBanco;
     Database1.Params.Values['USER NAME'] := sUsuario;
     Database1.Params.Values['PASSWORD'] := sSenha;

     try
        Database1.Connected := True;
     except
           Informacao('Erro!!!'+#13+'N�o pode se conectar ao banco!!!','Aviso!!!');
           Form1.Close;
     end;

     edtCodUni.SetFocus;
end;

procedure TForm1.CarregaParamsBanco;
var TomEncryption1: TTomEncryption;
begin
     TomEncryption1 := TTomEncryption.Create(Self);
     CarregaSenhasBancoOra('GRZPNL_BERLIN',TomEncryption1,sUsuario,sSenha,sBanco);
end;

end.
