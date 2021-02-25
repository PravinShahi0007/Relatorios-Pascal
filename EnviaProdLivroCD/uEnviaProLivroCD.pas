unit uEnviaProLivroCD;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.Oracle,
  FireDAC.Phys.OracleDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, ppDesignLayer, ppParameter, ppDB, ppDBPipe, ppModule,
  daDataModule, ppBands, ppClass, ppCtrls, ppStrtch, ppMemo, ppVar, ppPrnabl,
  ppCache, ppComm, ppRelatv, ppProd, ppReport, Vcl.StdCtrls, Vcl.Mask,
  Vcl.Buttons, ACBrBase, ACBrMail,System.DateUtils,System.IniFiles;

type
  TfrmEnviaProdLivroCD = class(TForm)
    FDConnection1: TFDConnection;
    FDPhysOracleDriverLink1: TFDPhysOracleDriverLink;
    dtsCadastrosNovos: TDataSource;
    qry: TFDQuery;
    btnImprimir: TBitBtn;
    FDQuery1: TFDQuery;
    dtsCadastros: TDataSource;
    ACBrMail1: TACBrMail;
    procedure FormCreate(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);


    procedure CarregaParametros;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEnviaProdLivroCD: TfrmEnviaProdLivroCD;
  dDataIni, dDataFin       : TDateTime;
  iNumero : integer;
  sDataMax : string;
  iArqIni : tIniFile;
  sEmail,sAssunto,sEmailFrom,sUserName,sPassword,sNome,sCopia_oculta :STRING;

implementation

{$R *.dfm}

uses uFunc, ufuncoes;

procedure TfrmEnviaProdLivroCD.btnImprimirClick(Sender: TObject);
var
sCaminhoArquivo,sNomeArquivo,sCabecalho,sHtml,sPerUso,sNumSorteUsado,sNumSorteDisponivel : String;
iSKU_S,iSKU_Sresult,iQT_FUNC_S,iQT_FUNC_Sresult,iQT_ENDERECO_S,iQT_ENDERECO_Sresult,iQT_PECAS_S,iQT_PECAS_Sresult,iQT_FUNC_P,iQT_FUNC_Presult,iSKU_P,iSKU_Presult,iQT_ENDERECO_P,iQT_ENDERECO_Presult,iQT_PECAS_P,iQT_PECAS_Presult : integer;
MedCodsor,MedEndSor,MedPecasSor,MedCodlivro,MedEndlivro,MedPecaslivro,MedCodsorTT,MedEndSorTT,MedPecasSorTT,MedCodlivroTT,MedEndlivroTT,MedPecaslivroTT   : integer;
begin
        sCaminhoArquivo := 'C:\EnviaProdLivroCD';

    sCabecalho := '';
    sCabecalho := sCabecalho + '<tr>';
    sCabecalho := sCabecalho + '<th>Data Operação</th>';
    sCabecalho := sCabecalho + '<th>Qtd. Func Sorter</th>';
    sCabecalho := sCabecalho + '<th>Qtd. Códigos Sorter</th>';
    sCabecalho := sCabecalho + '<th>Qtd. Endereço Sorter</th>';
    sCabecalho := sCabecalho + '<th>Qtd. Peças Sorter</th>';
    sCabecalho := sCabecalho + '<th> Média Codigos Sorter</th>';
    sCabecalho := sCabecalho + '<th> Média Endereços Sorter</th>';
    sCabecalho := sCabecalho + '<th> Média Peças Sorter</th>';
    sCabecalho := sCabecalho + '<th>Qtd. func Volumoso</th>';
    sCabecalho := sCabecalho + '<th>Qtd. Códigos Volumoso </th>';
    sCabecalho := sCabecalho + '<th>Qtd. Edereços Volumoso</th>';
    sCabecalho := sCabecalho + '<th>Qtd. Peças Volumoso</th>';
    sCabecalho := sCabecalho + '<th> Média Codigos Volumoso</th>';
    sCabecalho := sCabecalho + '<th> Média Endereços Volumoso</th>';
    sCabecalho := sCabecalho + '<th> Média Peças Volumoso</th>';
    sCabecalho := sCabecalho + '</tr>';

    qry.Active := false;
    qry.SQL.Clear;
    qry.sql.Add('select trunc(a.DT_SEPARACAO) dt_oper '+
                ',count(distinct(decode(a.tp_pedido,''SOR'',(to_char(a.dt_separacao,''yyyymmdd'')||a.CD_FUNC_SEPARACAO),null))) qt_func_s '+
                ' ,count(distinct(decode(a.tp_pedido,''SOR'',a.CD_PRODUTO,null))) sku_s '+
                ' ,count(distinct(decode(a.tp_pedido,''SOR'',a.CD_ENDERECO,null))) qt_endereco_s '+
                ' ,sum(decode(a.tp_pedido,''SOR'',nvl(a.QT_SEPARADO,0),0)) qt_pecas_s '+
                ' ,count(distinct(decode(a.tp_pedido,''LIV'',(to_char(a.dt_separacao,''yyyymmdd'')||a.CD_FUNC_SEPARACAO),null))) qt_func_p '+
                ' ,count(distinct(decode(a.tp_pedido,''LIV'',a.CD_PRODUTO,null))) sku_p '+
                ' ,count(distinct(decode(a.tp_pedido,''LIV'',a.CD_ENDERECO,null))) qt_endereco_p '+
                ' ,sum(decode(a.tp_pedido,''LIV'',nvl(a.QT_SEPARADO,0),0)) qt_pecas_p '+
                ' from wis50.v_monitor_separacao_expedicao a '+
                ' where a.CD_EMPRESA = 1001 '+
                ' and (a.TP_PEDIDO = ''SOR'' '+
                ' or a.TP_PEDIDO = ''LIV'') '+
                ' and trunc(a.DT_SEPARACAO) >= trunc(sysdate - 8) '+
                ' and trunc(a.DT_SEPARACAO) <= trunc(sysdate - 1) '+
                ' AND ID_SEPARADO = ''S''  '+
                ' AND ID_CANCELADO = ''N'' '+
                ' group by trunc(a.DT_SEPARACAO) '+
                ' order by 1');

    qry.Active := true;



       sHtml := '';
       sHtml := sHtml + '<html>';
       sHtml := sHtml + '<head>';
       sHtml := sHtml + '<title>Grupo Grazziotin</title>';
       sHtml := sHtml + '<h3>Grupo Grazziotin S/A.</h3>';
       sHtml := sHtml + '<h4> Relatório de produtividade do separo do livro de pedido no CD.</h4>';
       sHtml := sHtml + '</head>';
       sHtml := sHtml + '<body>';
       sHtml := sHtml + 'Data: '+FormatDateTime('dd/mm/yyyy',Date) + '  Hora: '+FormatDateTime('hh:mm', Time)+'</b></p>';
       sHtml := sHtml + '<table border="1" cellpadding="3" cellspacing="1">';

       sHtml := sHtml + sCabecalho;

       if qry.RecordCount > 0 then
       Begin
           qry.First;
           while not qry.Eof do
           Begin
                MedPecasSorTT   :=  0;
                MedCodlivroTT   :=  0;
                MedEndlivroTT   :=  0;
                MedPecaslivroTT :=  0;
                iSKU_Sresult     := 0;
                iQT_FUNC_Sresult := 0;
                iQT_ENDERECO_Sresult := 0;
                iQT_PECAS_Sresult := 0;
                iSKU_Presult      := 0;
                iQT_FUNC_Presult  := 0;
                iQT_ENDERECO_Presult := 0;
                iQT_PECAS_Presult := 0;
                MedCodsor      := 0;
                MedEndSor      := 0;
                MedPecasSor    := 0;
                MedCodlivro    := 0;
                MedEndlivro    := 0;
                MedPecaslivro  := 0;

                iSKU_S         := qry.FieldByName('SKU_S').AsInteger;
                iQT_FUNC_S     := qry.FieldByName('QT_FUNC_S').AsInteger;
                iQT_ENDERECO_S := qry.FieldByName('QT_ENDERECO_S').AsInteger;
                iQT_PECAS_S    := qry.FieldByName('QT_PECAS_S').AsInteger;
                iQT_FUNC_P     := qry.FieldByName('QT_FUNC_P').AsInteger;
                iSKU_P         := qry.FieldByName('SKU_P').AsInteger;
                iQT_ENDERECO_P := qry.FieldByName('QT_ENDERECO_P').AsInteger;
                iQT_PECAS_P    := qry.FieldByName('QT_PECAS_P').AsInteger;
                 begin
                    if ((iSKU_S >0) and (iQT_ENDERECO_S >0)  and (iQT_PECAS_S >0)) then
                    begin
                      MedCodsor      := iSKU_S div iQT_FUNC_S;
                      MedEndSor      := iQT_ENDERECO_S div iQT_FUNC_S;
                      MedPecasSor    := iQT_PECAS_S div iQT_FUNC_S;
                    end;
                     if (( iSKU_p >0) and (iQT_ENDERECO_p >0) and (iQT_PECAS_p >0)) then
                    begin
                         MedCodlivro    := iSKU_p div iQT_FUNC_p;
                         MedEndlivro    := iQT_ENDERECO_p div iQT_FUNC_p;
                         MedPecaslivro  := iQT_PECAS_p div iQT_FUNC_p;
                    end;

                 end;
                sHtml := sHtml + '<tr>';
                sHtml := sHtml + '<td align="right" WIDTH=100>'+qry.FieldByName('DT_OPER').AsString+'</td>';
                sHtml := sHtml + '<td align="right" WIDTH=100>'+qry.FieldByName('QT_FUNC_S').AsString+'</td>';
                sHtml := sHtml + '<td align="right" WIDTH=100>'+FormatFloat('#,###',qry.FieldByName('SKU_S').AsInteger)+'</td>';
                sHtml := sHtml + '<td align="right" WIDTH=100>'+FormatFloat('#,###',qry.FieldByName('QT_ENDERECO_S').AsInteger)+'</td>';
                sHtml := sHtml + '<td align="right" WIDTH=100>'+FormatFloat('#,###',qry.FieldByName('QT_PECAS_S').AsInteger)+'</td>';
                sHtml := sHtml + '<td align="right" WIDTH=100>'+ FormatFloat('#,###',MedCodsor);
                sHtml := sHtml + '<td align="right" WIDTH=100>'+ FormatFloat('#,###',MedEndSor);
                sHtml := sHtml + '<td align="right" WIDTH=100>'+ FormatFloat('#,###',MedPecasSor);
                sHtml := sHtml + '<td align="right" WIDTH=100>'+qry.FieldByName('QT_FUNC_P').AsString+'</td>';
                sHtml := sHtml + '<td align="right" WIDTH=100>'+FormatFloat('#,###',qry.FieldByName('SKU_P').AsInteger)+'</td>';
                sHtml := sHtml + '<td align="right" WIDTH=100>'+FormatFloat('#,###',qry.FieldByName('QT_ENDERECO_P').AsInteger)+'</td>';
                sHtml := sHtml + '<td align="right" WIDTH=100>'+FormatFloat('#,###',qry.FieldByName('QT_PECAS_P').AsInteger)+'</td>';
                sHtml := sHtml + '<td align="right" WIDTH=100>'+ FormatFloat('#,###',MedCodlivro);
                sHtml := sHtml + '<td align="right" WIDTH=100>'+ FormatFloat('#,###',MedEndlivro);
                sHtml := sHtml + '<td align="right" WIDTH=100>'+ FormatFloat('#,###',MedPecaslivro);
                iSKU_Sresult         := iSKU_S +  iSKU_Sresult;
                iQT_FUNC_Sresult     := iQT_FUNC_S + iQT_FUNC_Sresult;
                iQT_ENDERECO_Sresult := iQT_ENDERECO_S + iQT_ENDERECO_Sresult;
                iQT_PECAS_Sresult    := iQT_PECAS_S + iQT_PECAS_Sresult;
                iQT_FUNC_Presult     := iQT_FUNC_P + iQT_FUNC_Presult;
                iSKU_Presult         := iSKU_P + iSKU_Presult;
                iQT_ENDERECO_Presult := iQT_ENDERECO_P  +iQT_ENDERECO_Presult;
                iQT_PECAS_Presult    := iQT_PECAS_P + iQT_PECAS_Presult;
                MedCodsorTT    := MedCodsorTT + MedCodsor;
                MedEndSorTT    := MedEndSorTT + MedEndSor;
                MedPecasSorTT  := MedPecasSorTT + MedPecasSor;
                MedCodlivroTT  := MedCodlivroTT + MedCodlivro;
                MedEndlivroTT  := MedEndlivroTT + MedEndlivro;
                MedPecaslivroTT:= MedPecaslivroTT + MedPecaslivro;
                sHtml := sHtml + '</tr>';
                qry.Next;

            end;
           qry.Close;
                MedCodsorTT     :=  iSKU_Sresult div iQT_FUNC_Sresult;
                MedEndSorTT     :=  iQT_ENDERECO_Sresult div iQT_FUNC_Sresult;
                MedPecasSorTT   :=  iQT_PECAS_Sresult  div iQT_FUNC_Sresult;
                MedCodlivroTT   :=  iSKU_Presult div iQT_FUNC_Presult;
                MedEndlivroTT   :=  iQT_ENDERECO_Presult div iQT_FUNC_Presult;
                MedPecaslivroTT :=  iQT_PECAS_Presult  div iQT_FUNC_Presult;

                sHtml := sHtml + '<tr>';
                sHtml := sHtml + '<td align="right" <th>TOTAL</th>';
                sHtml := sHtml + '<td align="right" WIDTH=100>'+(FormatFloat('#,###',iQT_FUNC_Sresult)+'</td>');
                sHtml := sHtml + '<td align="right" WIDTH=100>'+(FormatFloat('#,###',iSKU_Sresult)+'</td>');
                sHtml := sHtml + '<td align="right" WIDTH=100>'+(FormatFloat('#,###',iQT_ENDERECO_Sresult)+'</td>');
                sHtml := sHtml + '<td align="right" WIDTH=100>'+(FormatFloat('#,###',iQT_PECAS_Sresult)+'</td>');
                sHtml := sHtml + '<td align="right" WIDTH=100>'+(FormatFloat('#,###',MedCodsorTT)+'</td>');
                sHtml := sHtml + '<td align="right" WIDTH=100>'+(FormatFloat('#,###',MedEndSorTT)+'</td>');
                sHtml := sHtml + '<td align="right" WIDTH=100>'+(FormatFloat('#,###',MedPecasSorTT)+'</td>');
                sHtml := sHtml + '<td align="right" WIDTH=100>'+(FormatFloat('#,###',iQT_FUNC_Presult)+'</td>');
                sHtml := sHtml + '<td align="right" WIDTH=100>'+(FormatFloat('#,###',iSKU_Presult)+'</td>');
                sHtml := sHtml + '<td align="right" WIDTH=100>'+(FormatFloat('#,###',iQT_ENDERECO_Presult)+'</td>');
                sHtml := sHtml + '<td align="right" WIDTH=100>'+(FormatFloat('#,###',iQT_PECAS_Presult)+'</td>');
                sHtml := sHtml + '<td align="right" WIDTH=100>'+(FormatFloat('#,###',MedCodlivroTT)+'</td>');
                sHtml := sHtml + '<td align="right" WIDTH=100>'+(FormatFloat('#,###',MedEndlivroTT)+'</td>');
                sHtml := sHtml + '<td align="right" WIDTH=100>'+(FormatFloat('#,###',MedPecaslivroTT)+'</td>');

                sHtml := sHtml + '</tr>';
       end

       else

       sHtml := sHtml + '</table>';
       sHtml := sHtml + '</body>';
       sHtml := sHtml + '</html>';

          ACBrMail1.From := sEmailFrom;
          ACBrMail1.FromName := sNome;
          ACBrMail1.Host := 'smtp.office365.com';
          ACBrMail1.Username := sUserName;
          ACBrMail1.Password := sPassword;
          ACBrMail1.Port := '587';
          ACBrMail1.AddAddress(sEmail,'');
          ACBrMail1.AddBCC(sCopia_oculta);
          ACBrMail1.Subject := sAssunto;
          ACBrMail1.IsHTML := True;
          ACBrMail1.Body.Text :=  sHtml;
          AcbrMail1.SetTLS := True;
          ACBrMail1.Send;
end;

procedure TfrmEnviaProdLivroCD.FormCreate(Sender: TObject);
begin
   try

     FDConnection1.Params.UserName := 'nl';
     FDConnection1.Params.Password := 'nl';
     FDConnection1.Connected := True;
   except
       on E:EDatabaseError do
            begin
                 MessageDlg('Falha ao conectar o banco '+#13+
                            'a aplicação vai fechar!'+#13+
                            E.Message,mtInformation,[mbOk], 0);
                Application.Terminate;
            end;
   end;

    CarregaParametros;
    btnImprimirClick(Sender);
end;

procedure TfrmEnviaProdLivroCD.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    case key of
          VK_RETURN : Perform(WM_NEXTDLGCTL,0,0);
     end;
end;



procedure TfrmEnviaProdLivroCD.CarregaParametros;
var
 sDiretorio: string;
begin
   try
  //sDiretorio := GetCurrentDir;
  sDiretorio :='C:\EnviaProdLivroCD';
  iArqIni := TIniFile.Create(sDiretorio+'\config.ini');
  sEmail := iArqIni.ReadString('EMAIL','EMAIL','');
  sAssunto := iArqIni.ReadString('EMAIL FROM','Assunto','');
  sEmailFrom := iArqIni.ReadString('EMAIL FROM','Endereco','');
  sUserName := iArqIni.ReadString('EMAIL FROM','UserName','');
  sPassword := iArqIni.ReadString('EMAIL FROM','Password','');
  sNome := iArqIni.ReadString('EMAIL FROM','Nome','');
  sCopia_oculta :=  iArqIni.ReadString('EMAIL FROM','copia_oculta','');


  iArqINI.Free;

 except
  ShowMessage('Erro: Não carregou arquivo de configuração.'+chr(13)+
             'Verifique!!!!'+chr(13)+
             sDiretorio+'\config.ini');
  Application.Terminate;
  exit;
 end;



end;


end.
