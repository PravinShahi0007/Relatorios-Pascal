unit uGeraArquivo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, Db, DBTables, StdCtrls, ExtCtrls, Buttons,uCarregaSenha,
  FileCtrl, IBDatabase, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Encryp,FireDAC.Phys.Oracle,
  FireDAC.Phys.OracleDef;

type
  TfrmGeraArquivo = class(TForm)
    Panel1: TPanel;
    edtCod_unidade: TEdit;
    Label1: TLabel;
    edtNum_Ordem: TEdit;
    Label2: TLabel;
    edtCod_Fornecedor: TEdit;
    Label3: TLabel;
    edtDta_emissao: TEdit;
    Label4: TLabel;
    dtsManutencao: TDataSource;
    Panel2: TPanel;
    Edit2: TEdit;
    edtArquivo: TEdit;
    Label5: TLabel;
    Panel3: TPanel;
    dirSaida: TDirectoryListBox;
    driveSaida: TDriveComboBox;
    cbxDes_fornecedor: TComboBox;
    btnFornecedor: TBitBtn;
    btnGerar: TBitBtn;
    btnFechar: TBitBtn;
    Label6: TLabel;
    Label7: TLabel;
    edtCodMascara: TEdit;
    grdGeral: TDBGrid;
    qryGeral: TFDQuery;
    Database1: TFDConnection;
    spGeracao: TFDStoredProc;
    lblMensagem: TLabel;
    procedure Geracao(Sender:TObject);
    procedure Gera_depois_do_fornec(Sender:TObject);
    procedure FormShow(Sender: TObject);
    procedure edtNum_OrdemExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnGerarClick(Sender: TObject);
    procedure grdGeralEnter(Sender: TObject);
    procedure grdGeralExit(Sender: TObject);
    procedure grdGeralKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dirSaidaChange(Sender: TObject);
    procedure driveSaidaChange(Sender: TObject);
    procedure edtArquivoKeyPress(Sender: TObject; var Key: Char);
    procedure driveSaidaEnter(Sender: TObject);
    procedure driveSaidaExit(Sender: TObject);
    procedure dirSaidaExit(Sender: TObject);
    procedure dirSaidaEnter(Sender: TObject);
    procedure edtCod_unidadeKeyPress(Sender: TObject; var Key: Char);
    procedure grdGeralKeyPress(Sender: TObject; var Key: Char);
    procedure btnFornecedorClick(Sender: TObject);
    procedure cbxDes_fornecedorEnter(Sender: TObject);
    procedure cbxDes_fornecedorExit(Sender: TObject);
    procedure cbxDes_fornecedorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbxDes_fornecedorChange(Sender: TObject);
    procedure CarregaParamsBanco;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGeraArquivo: TfrmGeraArquivo;
  sUsuario,sClaSelect,sClaWhere,sClaOrderBy,sBanco, sSenha : string;

implementation

uses uFuncoes;

{$R *.DFM}

procedure TfrmGeraArquivo.Geracao(Sender: TObject);
var
   i : Integer;
begin
     sClaSelect  := 'select a.cod_pessoa, b.des_pessoa '+
		    'from nl.ac_ordens_compra a, '+
                    'nl.ps_pessoas b '+
		    'where a.cod_pessoa = b.cod_pessoa'+
                    ' and a.cod_emp = 1 '+
		    ' and a.cod_unidade = '+edtCod_unidade.Text+
		    ' and a.num_ordem_compra = '+edtNum_Ordem.Text;
     qryGeral.Active := false;
     qryGeral.SQL.clear;
     qryGeral.sql.add(sClaSelect);
     qryGeral.Active := true;
     if qryGeral.RecordCount > 1 then
     begin
          cbxDes_fornecedor.Items.clear;
          i:=0;
          while i < qryGeral.RecordCount do
          begin
               cbxDes_fornecedor.Items.Add(padleft(qryGeral.FieldByName('cod_pessoa').asstring,7,'0')+' '+
                                           qryGeral.FieldByName('des_pessoa').asstring);
               qryGeral.Next;
               inc(i);
          end;
          cbxDes_fornecedor.ItemIndex := 0;
          cbxDes_fornecedor.Refresh;
          informacao('Foram encontrados '+IntToStr(qryGeral.RecordCount)+' ordens de compra com o mesmo n�mero,'+#13+
                     'verifique o nome do fornecedor e clique no bot�o de "Fornecedor OK".','Aviso');
          cbxDes_fornecedor.SetFocus;
          btnFornecedor.Enabled := true;
          btnGerar.Enabled := false;
          Abort;
          Exit;
     end
     else
     begin
          cbxDes_fornecedor.Items.clear;
          i:=0;
          while i < qryGeral.RecordCount do
          begin
               cbxDes_fornecedor.Items.Add(padleft(qryGeral.FieldByName('cod_pessoa').asstring,7,'0')+' '+
                                           qryGeral.FieldByName('des_pessoa').asstring);
               qryGeral.Next;
               inc(i);
          end;
          cbxDes_fornecedor.ItemIndex := 0;
          cbxDes_fornecedor.Refresh;
          edtCod_Fornecedor.Text := Copy(cbxDes_fornecedor.Text,1,7);
          Gera_depois_do_fornec(Sender);
     end;
end;

procedure TfrmGeraArquivo.Gera_depois_do_fornec(Sender: TObject);
var
      sParametros : string;
      iPosicao : integer;
      Size        : Cardinal;
      i : integer;
begin
     lblMensagem.Caption := 'Aguarde......Gerando dados para o arquivo texto....';
     lblMensagem.Visible  := true;
     lblMensagem.Update;
     Size := 128;
     SetLength(sUsuario,Size);
     GetUserName(PChar(sUsuario), Size);
     Edit2.Text := sUsuario;
     sUsuario := Trim(Edit2.Text);
     btnGerar.Enabled := true;
     btnFornecedor.Enabled := false;
     //edtCod_Fornecedor.Text := cbxDes_fornecedor.Text[cbxDes_fornecedor.ItemIndex]
     edtCod_Fornecedor.Text := Copy(cbxDes_fornecedor.Text,1,7);
     if (Trim(edtCod_Fornecedor.Text) = '') or
        (Trim(edtCod_Fornecedor.Text) = '0') then
     begin
          informacao('Fornecedor deve ser escolhido,'+#13+
                     'verifique o nome do fornecedor e clique no bot�o de "Fornecedor OK".','Aviso');
          edtNum_Ordem.SetFocus;
          Abort;
          Exit;
     end;
     //edtCod_Fornecedor.Text := qryPessoa.fieldByName('cod_pessoa').AsString;
     spGeracao.close;
     sParametros := ''+edtCod_unidade.text+'#'+edtNum_Ordem.text+'#'+edtCod_Fornecedor.Text+'#'+sUsuario+'#'+edtCodMascara.Text+'#';
      spGeracao.Close;
      spGeracao.StoredProcName := 'nl.grz_sp_ordens_fornec';
      // nome da rotina que vai executar
      spGeracao.Prepare; // prepara a conexao
      spGeracao.Params[0].Value := sParametros;
      // passa os parametros de entrada
      spGeracao.ExecProc; // executa a procedure, rotina
      spGeracao.Close;

     sClaSelect  := ' select * from nl.grzw_ordens_fornec ';
     sClaWhere   := ' where upper(des_usuario) = '''+upperCase(sUsuario)+'''';
     sClaOrderBy := ' order by num_pedido,COD_PRODUTO ';
     qryGeral.Active := false;
     qryGeral.SQL.clear;
     qryGeral.sql.add(sClaSelect+sClaWhere+sClaOrderBy);
     qryGeral.Active := true;
     if qryGeral.RecordCount = 0 then
     begin
          informacao('N�o foram encontrados registros para gera��o do arquivo texto.','Aviso');
          lblMensagem.Visible := false;
          qryGeral.Active := false;
          edtCod_unidade.Text    := '';
          edtNum_Ordem.Text      := '';
          edtCod_Fornecedor.Text := '';
          cbxDes_fornecedor.Text := '';
          edtArquivo.Text        := '';
          edtCod_unidade.SetFocus;
          abort;
          exit;
     end;
    { if not (TBDEDataSet(dtsManutencao.DataSet).State in [dsEdit]) then
          TBDEDataSet(dtsManutencao.DataSet).Edit;   }
     if alltrim(edtArquivo.Text) = '' then
          edtArquivo.Text := 'P'+PadLeft(edtCod_unidade.Text,3,'0')+PadLeft(edtNum_Ordem.Text,6,'0')+'.TXT';
     edtArquivo.Update;
     grdGeral.SetFocus;
     //iPosicao := pos('#',spGeracao.Params[1].Value);
     //edtCod_Fornecedor.Text := copy(spGeracao.Params[1].Value,iPosicao+1,7);
     //edtDes_Fornecedor.Text := copy(spGeracao.Params[1].Value,1,iPosicao-1);
     spGeracao.Close;
     lblMensagem.Caption := 'O Tamanho do produto e o Tipo de Etiqueta podem ser alterados no grid abaixo....'+#13+
                            '      Tipo de Etiqueta = 01-Colar Pequena    02-Pendurar    03-Colar Grande';
     lblMensagem.Update;
end;

procedure TfrmGeraArquivo.FormShow(Sender: TObject);
begin
     edtCod_unidade.SetFocus;
     edtDta_emissao.Text := DateToStr(date());
   //  if not Session1.Active then
   //     Session1.Active := true;
     if not Database1.Connected then
        Database1.Connected := true;
     if qryGeral.Active then
        qryGeral.Active := false;
    if not DirectoryExists('C:\etiquetas') then
       CreateDir('C:\etiquetas');
     dirSaida.Directory := 'C:\etiquetas';
end;

procedure TfrmGeraArquivo.edtNum_OrdemExit(Sender: TObject);
begin
     if alltrim(edtCod_unidade.text) = '' then
     begin
          informacao('O c�digo da unidade deve ser informado.','Aviso');
          edtCod_unidade.SetFocus;
          abort;
          exit;
     end;
     if  edtCodMascara.Text = '' then
     begin
          informacao('O c�digo da m�scara deve ser informado (150 ou 170).','Aviso');
          edtCodMascara.SetFocus;
          abort;
          exit;
     end;
     if alltrim(edtNum_Ordem.text) = '' then
     begin
          informacao('O n�mero da ordem deve ser informado.','Aviso');
          edtNum_Ordem.SetFocus;
          abort;
          exit;
     end;
     geracao(sender);
    // grdGeral.Row := qryGeral.RecordCount + 1;
end;

procedure TfrmGeraArquivo.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     case Key of
          VK_RETURN, VK_DOWN: Perform(WM_NEXTDLGCTL,0,0);
          VK_UP : Perform(WM_NEXTDLGCTL,1,0);
          VK_ESCAPE : if btnFechar.Enabled = True then
                         btnFechar.setfocus;
     end;
end;

procedure TfrmGeraArquivo.btnFecharClick(Sender: TObject);
begin
     close;
end;

procedure TfrmGeraArquivo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     //delete
     sClaSelect  := ' delete from nl.grzw_ordens_fornec ';
     sClaWhere   := ' where upper(des_usuario) = '''+upperCase(sUsuario)+'''';
     qryGeral.Active := false;
     qryGeral.SQL.clear;
     qryGeral.sql.add(sClaSelect+sClaWhere);
     qryGeral.ExecSQL;
     if qryGeral.Active then
        qryGeral.Active := false;
     if Database1.Connected then
        Database1.Connected := false;
    // if Session1.Active then
    //    Session1.Active := false;
end;

procedure TfrmGeraArquivo.FormCreate(Sender: TObject);
begin
    CarregaParamsBanco;
    try
     Database1.Params.Database := sBanco;
     Database1.Params.UserName := sUsuario;
     Database1.Params.Password := sSenha;
     Database1.Connected := True;
   except
       on E:EDatabaseError do
            begin
                 Informacao('Erro!!!'+#13+'N�o pode se conectar ao banco!!!','Aviso!!!');
                 Halt(0);
            end;
   end;
end;

procedure TfrmGeraArquivo.btnGerarClick(Sender: TObject);
var
   sDiretorio, sDes_Rede,sNum_Pedido,sCod_Produto,sDes_Produto,
   sPreco,sQuantidade,sTamanho,sTipo,sSemana,sData,sDesMarca,sDesEnderecoLoja: string;
   tfArquivo : TextFile;
   iLidos,iTamanho : integer;
begin
     lblMensagem.Caption := 'Aguarde....... Gerando Arquivo Texto....';
     lblMensagem.Update;
//     if TBDEDataSet(dtsManutencao.DataSet).State in [dsEdit] then
//     begin
          try
              TBDEDataSet(dtsManutencao.DataSet).Edit;
              TBDEDataSet(dtsManutencao.DataSet).Post;
              Database1.StartTransaction;
              TBDEDataSet(dtsManutencao.DataSet).ApplyUpdates;
              TBDEDataSet(dtsManutencao.DataSet).CommitUpdates;
              Database1.Commit;
          except
//              on E:Exception do
              on E:EDatabaseError do
                 begin
                      MessageDlg(E.Message,mtInformation,[mbOk], 0);
                      TBDEDataSet(dtsManutencao.DataSet).CommitUpdates;
                      Database1.Rollback;
                      Close;
                 end;
          end;
//     end;
     sClaSelect := ' select nvl(des_usuario,'' '')            des_usuario  '+
                   '       ,nvl(des_rede,'' '')               des_rede     '+
                   '       ,nvl(num_pedido,0)                 num_pedido   '+
                   '       ,nvl(cod_produto,''0'')            cod_produto  '+
                   '       ,nvl(des_produto,'' '')            des_produto  '+
                   '       ,nvl(vlr_produto,0)                vlr_produto  '+
                   '       ,nvl(qtd_etiqueta,0)               qtd_etiqueta '+
                   '       ,upper(nvl(vlr_tamanho,'' ''))     vlr_tamanho  '+
                   '       ,nvl(tip_etiqueta,1)               tip_etiqueta '+
                   '       ,nvl(num_semana,0)                 num_semana   '+
                   '       ,to_char(dta_sistema,''yyyymmdd'') dta_sistema  '+
                   '       ,nvl(des_marca,'' '')              des_marca    '+
                   '       ,nvl(des_endereco_loja,'' '')      des_endereco_loja  '+
                   '   from nl.grzw_ordens_fornec ';
     sClaWhere  := ' where upper(des_usuario) = '''+upperCase(sUsuario)+'''';
     qryGeral.Active := false;
     qryGeral.sql.clear;
     qryGeral.sql.add(sClaSelect+sClaWhere);
     qryGeral.Active := true;
     if qryGeral.RecordCount = 0 then
     begin
          informacao('N�o foram encontrados registros para gera��o do arquivo texto.','Aviso');
          lblMensagem.Visible := false;
          qryGeral.Active := false;
          edtCod_unidade.Text    := '';
          edtNum_Ordem.Text      := '';
          edtCod_Fornecedor.Text := '';
          cbxDes_fornecedor.Text := '';
          edtArquivo.Text        := '';
          edtCodMascara.Text     := '';
          edtCod_unidade.SetFocus;
          abort;
          exit;
     end;
     sDiretorio := trim(dirSaida.Directory);
     iTamanho   := Length(sDiretorio);
     if alltrim(edtArquivo.Text) = '' then
          edtArquivo.Text := 'P'+PadLeft(edtCod_unidade.Text,3,'0')+PadLeft(edtNum_Ordem.Text,6,'0')+'.TXT';
     edtArquivo.Update;
     if not (copy(sDiretorio,iTamanho,1) = '\') then
            sDiretorio := sDiretorio+'\';
     AssignFile(tfArquivo,sDiretorio+edtArquivo.Text);
     ReWrite(tfArquivo);
     qryGeral.First;
     iLidos := 0;
     while not qryGeral.eof do
     begin
        {  sDes_Rede    := PadRight(qryGeral.FieldByName('des_rede').AsString,20,' ');
          sNum_Pedido  := PadLeft(qryGeral.FieldByName('num_pedido').AsString,6,'0');
          sCod_Produto := PadLeft(qryGeral.FieldByName('cod_produto').AsString,9,'0');
          sDes_Produto := PadRight(qryGeral.FieldByName('des_produto').AsString,30,' ');
          sPreco       := PadLeft(qryGeral.FieldByName('vlr_produto').value*100,11,'0');
          sQuantidade  := PadLeft(qryGeral.FieldByName('qtd_etiqueta').AsString,4,'0');
          sTamanho     := PadRight(qryGeral.FieldByName('vlr_tamanho').AsString,3,' ');
          sTipo        := PadLeft(qryGeral.FieldByName('tip_etiqueta').AsString,2,'0');
          sSemana      := PadLeft(qryGeral.FieldByName('num_semana').AsString,3,'0');}
          sDes_Rede    := qryGeral.FieldByName('des_rede').AsString;
          sNum_Pedido  := PadLeft(qryGeral.FieldByName('num_pedido').AsString,6,'0');
          sCod_Produto := PadLeft(qryGeral.FieldByName('cod_produto').AsString,9,'0');
          sDes_Produto := qryGeral.FieldByName('des_produto').AsString;
          sPreco       := PadLeft(qryGeral.FieldByName('vlr_produto').value*100,11,'0');
          sQuantidade  := qryGeral.FieldByName('qtd_etiqueta').AsString;
          sTamanho     := qryGeral.FieldByName('vlr_tamanho').AsString;
          sTipo        := qryGeral.FieldByName('tip_etiqueta').AsString;
          sSemana      := qryGeral.FieldByName('num_semana').AsString;
          sData        := qryGeral.FieldByName('dta_sistema').value;
          sDesMarca    := qryGeral.FieldByName('des_marca').AsString;
          sDesEnderecoLoja    := qryGeral.FieldByName('des_endereco_loja').AsString;
          qryGeral.Next;
          Writeln(tfArquivo,sDes_Rede+'^'+sNum_Pedido+'^'+sCod_Produto+'^'+sDes_Produto+'^'+sPreco+'^'+sQuantidade+'^'+sTamanho+'^'+sTipo+'^'+sSemana+'^'+sData+'^'+sDesMarca+'^'+sDesEnderecoLoja+'^');
          iLidos := iLidos + 1;
     end;
     CloseFile(tfArquivo);
     if iLidos = qryGeral.RecordCount then
     begin
          MessageDlg('Arquivo gerado com sucesso!'+#13+
                     'Local: '+dirSaida.Directory+#13+
                     'Nome do arquivo: '+edtArquivo.text,mtInformation,[mbOk],0);
          qryGeral.Active := false;
          edtCod_unidade.Text    := '';
          edtNum_Ordem.Text      := '';
          edtCod_Fornecedor.Text := '';
          cbxDes_fornecedor.Text := '';
          edtArquivo.Text        := '';
          edtCodMascara.Text     := '';
          edtCod_unidade.SetFocus;
     end
     else
     begin
          MessageDlg('Arquivo gerado com problema.',mtError,[mbOK],0);
          edtCod_unidade.SetFocus;
          abort;
          exit;
     end;
     lblMensagem.Visible := false;
end;

procedure TfrmGeraArquivo.CarregaParamsBanco;
var TomEncryption1: TTomEncryption;
begin
    TomEncryption1 := TTomEncryption.Create(Self);
    CarregaSenhasBancoOra('GRZPNL_BERLIN',TomEncryption1,sUsuario,sSenha,sBanco);
end;

procedure TfrmGeraArquivo.grdGeralEnter(Sender: TObject);
begin
     KeyPreview := False;
end;

procedure TfrmGeraArquivo.grdGeralExit(Sender: TObject);
begin
     KeyPreview := True;
end;

procedure TfrmGeraArquivo.grdGeralKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     case Key of
          VK_RETURN: edtArquivo.SetFocus;
          VK_ESCAPE : btnFechar.SetFocus;
     end;
end;

procedure TfrmGeraArquivo.dirSaidaChange(Sender: TObject);
begin
     dirSaida.Drive := driveSaida.Drive;
end;

procedure TfrmGeraArquivo.driveSaidaChange(Sender: TObject);
begin
     dirSaida.Drive := driveSaida.Drive;
end;

procedure TfrmGeraArquivo.edtArquivoKeyPress(Sender: TObject; var Key: Char);
var  codigo : boolean;
begin
     case key of
        '0'..'9'           : codigo := true;
        'a'..'z'           : codigo := true;
        '.'                : codigo := true;
        Chr(13)            : codigo := true; //enter
        Chr(16)            : codigo := true; //delete
        Chr(8)             : codigo := true; //backspace
        Chr(9)             : codigo := true; //tab
        Chr(27)            : begin
                                  codigo := true; //ESC
                                  btnFechar.SetFocus;
                             end;
     else
         codigo := False;
     end;

     if codigo = False then
           Abort;
end;

procedure TfrmGeraArquivo.driveSaidaEnter(Sender: TObject);
begin
     KeyPreview := false;
end;

procedure TfrmGeraArquivo.driveSaidaExit(Sender: TObject);
begin
     KeyPreview := true;
end;

procedure TfrmGeraArquivo.dirSaidaExit(Sender: TObject);
begin
     KeyPreview := true;
end;

procedure TfrmGeraArquivo.dirSaidaEnter(Sender: TObject);
begin
     KeyPreview := false;
end;

procedure TfrmGeraArquivo.edtCod_unidadeKeyPress(Sender: TObject; var Key: Char);
var  codigo : boolean;
begin
     case key of
        '0'..'9' : codigo := true;
        Chr(13)  : codigo := true; //enter
        Chr(16)  : codigo := true; //delete
        Chr(8)   : codigo := true; //backspace
        Chr(9)   : codigo := true; //tab
        Chr(27)  : begin
                      codigo := true; //ESC
                      btnFechar.SetFocus;
                   end;
     else
         codigo := False;
     end;
     if codigo = False then
           Abort;
end;

procedure TfrmGeraArquivo.grdGeralKeyPress(Sender: TObject; var Key: Char);
begin
     if not (TBDEDataSet(dtsManutencao.DataSet).State in [dsEdit]) then
         TBDEDataSet(dtsManutencao.DataSet).Edit;
end;

procedure TfrmGeraArquivo.btnFornecedorClick(Sender: TObject);
begin
     Gera_depois_do_fornec(Sender);
end;

procedure TfrmGeraArquivo.cbxDes_fornecedorEnter(Sender: TObject);
begin
     KeyPreview := False;
     cbxDes_fornecedor.DroppedDown := True;
end;

procedure TfrmGeraArquivo.cbxDes_fornecedorExit(Sender: TObject);
begin
     KeyPreview := True;
end;

procedure TfrmGeraArquivo.cbxDes_fornecedorKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
     case Key of
          VK_RETURN : btnFornecedor.SetFocus;
          VK_ESCAPE : edtNum_Ordem.SetFocus;
          VK_F12 : Perform(WM_NEXTDLGCTL,1,0);
     end;
end;

procedure TfrmGeraArquivo.cbxDes_fornecedorChange(Sender: TObject);
begin
     edtCod_Fornecedor.Text := Copy(cbxDes_fornecedor.Text,1,7);
end;

end.
