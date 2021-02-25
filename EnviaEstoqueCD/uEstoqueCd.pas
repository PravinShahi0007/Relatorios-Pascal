unit uEstoqueCd;

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
  TfrmEstoqueCD = class(TForm)
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
  frmEstoqueCD: TfrmEstoqueCD;
  dDataIni, dDataFin       : TDateTime;
  iNumero : integer;
  sDataMax : string;
  iArqIni : tIniFile;
  sEmail,sAssunto,sEmailFrom,sUserName,sPassword,sNome,sCopia_oculta :STRING;

implementation

{$R *.dfm}

uses uFunc, ufuncoes;

procedure TfrmEstoqueCD.btnImprimirClick(Sender: TObject);
var
sCaminhoArquivo,sNomeArquivo,sCabecalho,sHtml,sPerUso,sNumSorteUsado,sNumSorteDisponivel : String;
sValor,sPecas,sCodigos :string;
begin
        sCaminhoArquivo := 'c:\EstoqueCD\';

    sCabecalho := '';
    sCabecalho := sCabecalho + '<tr>';
    sCabecalho := sCabecalho + '<th>Cod. Grupos</th>';
    sCabecalho := sCabecalho + '<th>Qtd. Codigos</th>';
    sCabecalho := sCabecalho + '<th>Qtd. Peças</th>';
    sCabecalho := sCabecalho + '<th>Valor</th>';
    sCabecalho := sCabecalho + '</tr>';

    qry.Active := false;
    qry.SQL.Clear;
    qry.sql.Add(' select est.cod_unidade                     '+
                ' ,count(distinct est.cod_item) nro_skus     '+
                ' ,sum(est.qtde) qtde                        '+
                ' ,sum(est.valor) valor                      '+
                ' from                                       '+
                ' (select a.cod_unidade                      '+
                ' ,a.cod_item                                '+
                ' ,(nvl(a.qtd_estoque,0)) qtde               '+
                ' ,(nvl(a.vlr_medio_total,0)) valor          '+
                ' from ce_estoques a                         '+
                ' ,ie_itens b                                '+
                ' ,ie_mascaras c                             '+
                ' where c.cod_item=a.cod_item                '+
                ' and c.cod_mascara=150                      '+
                ' and c.cod_niv0=1                           '+
                ' and b.cod_item=a.cod_item                  '+
                ' and b.ind_avulso=0                         '+
                ' and b.ind_inativo=0                        '+
                ' and a.cod_emp=1                            '+
                ' and nvl(a.qtd_estoque,0) > 0               '+
                ' and a.cod_unidade in (818,838,848,858)     '+
                '  ) est                                     '+
                ' where est.qtde > 0                         '+
                ' group by est.cod_unidade                   '+
                ' order by est.cod_unidade                   ');

    qry.Active := true;



       sHtml := '';
       sHtml := sHtml + '<html>';
       sHtml := sHtml + '<head>';
       sHtml := sHtml + '<title>Grupo Grazziotin</title>';
       sHtml := sHtml + '<h3>Grupo Grazziotin S/A.</h3>';
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

                sHtml := sHtml + '<tr>';
                sHtml := sHtml + '<td align="right" WIDTH=100>'+qry.FieldByName('cod_unidade').AsString+'</td>';
                sHtml := sHtml + '<td align="right" WIDTH=100>'+FormatFloat('#,###',qry.FieldByName('nro_skus').AsInteger)+'</td>';
                sHtml := sHtml + '<td align="right" WIDTH=100>'+FormatFloat('#,###',qry.FieldByName('qtde').AsInteger)+'</td>';
                sHtml := sHtml + '<td align="right" WIDTH=100>'+FormatFloat('#,0.00;-#,0.00',qry.FieldByName('valor').AsFloat)+'</td>';
                sHtml := sHtml + '</tr>';
                qry.Next;

            end;
           qry.Close;
           FDQuery1.Active := false;
           FDQuery1.SQL.Clear;
           FDQuery1.sql.Add('select                    '+
                        ' count(distinct est.cod_item) nro_skus     '+
                        ' ,sum(est.qtde) qtde                        '+
                        ' ,sum(est.valor) valor                      '+
                        ' from                                       '+
                        ' (select a.cod_unidade                      '+
                        ' ,a.cod_item                                '+
                        ' ,(nvl(a.qtd_estoque,0)) qtde               '+
                        ' ,(nvl(a.vlr_medio_total,0)) valor          '+
                        ' from ce_estoques a                         '+
                        ' ,ie_itens b                                '+
                        ' ,ie_mascaras c                             '+
                        ' where c.cod_item=a.cod_item                '+
                        ' and c.cod_mascara=150                      '+
                        ' and c.cod_niv0=1                        '+
                        ' and b.cod_item=a.cod_item                  '+
                        ' and b.ind_avulso=0                         '+
                        ' and b.ind_inativo=0                        '+
                        ' and a.cod_emp=1                            '+
                        ' and nvl(a.qtd_estoque,0) > 0               '+
                        ' and a.cod_unidade in (818,838,848,858)     '+
                        '  ) est                                     '+
                        ' where est.qtde > 0 ');

            FDQuery1.Active := true;
            sValor    := FormatFloat('#,0.00;-#,0.00',fDQuery1.FieldByName('valor').AsFloat);
            sPecas    := FormatFloat('#,###',  fDQuery1.FieldByName('qtde').AsInteger);
            sCodigos  := FormatFloat('#,###',  fDQuery1.FieldByName('nro_skus').AsInteger);
                sHtml := sHtml + '<tr>';
                sHtml := sHtml + '<td align="right" <th>TOTAL</th>';
                sHtml := sHtml + '<td align="right" WIDTH=100>'+sCodigos+'</td>';
                sHtml := sHtml + '<td align="right" WIDTH=100>'+sPecas+'</td>';
                sHtml := sHtml + '<td align="right" WIDTH=100>'+svalor+'</td>';
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

procedure TfrmEstoqueCD.FormCreate(Sender: TObject);
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

procedure TfrmEstoqueCD.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    case key of
          VK_RETURN : Perform(WM_NEXTDLGCTL,0,0);
     end;
end;



procedure TfrmEstoqueCD.CarregaParametros;
var
 sDiretorio: string;
begin
   try
  //sDiretorio := GetCurrentDir;
  sDiretorio :='c:\EnviaEstoqueCD\';
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
