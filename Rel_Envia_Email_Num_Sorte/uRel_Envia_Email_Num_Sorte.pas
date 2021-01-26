unit uRel_Envia_Email_Num_Sorte;

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
  TfrmRel_Numero_Sorte = class(TForm)
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
  frmRel_Numero_Sorte: TfrmRel_Numero_Sorte;
  dDataIni, dDataFin       : TDateTime;
  iNumero : integer;
  sDataMax : string;
  iArqIni : tIniFile;
  sEmail,sAssunto,sEmailFrom,sUserName,sPassword,sNome,sCopia_oculta :STRING;

implementation

{$R *.dfm}

uses uFunc, ufuncoes;

procedure TfrmRel_Numero_Sorte.btnImprimirClick(Sender: TObject);
var
sCaminhoArquivo,sNomeArquivo,sCabecalho,sHtml,sPerUso,sNumSorteUsado,sNumSorteDisponivel : String;



begin
       sCaminhoArquivo := 'c:\Rel_Envial_Email_Numero_Sorte\';

         sCabecalho := '';
         sCabecalho := sCabecalho + '<tr>';
         sCabecalho := sCabecalho + '<th>Perc. Uso Numero da Sorte :  </th>';
         sCabecalho := sCabecalho + '</tr>';


         sHtml := '';
         sHtml := sHtml + '<html>';
         sHtml := sHtml + '<head>';
         sHtml := sHtml + 'Data: '+FormatDateTime('dd/mm/yyyy',Date) + '  Hora: '+FormatDateTime('hh:mm', Time)+'</b></p> ';
         sHtml := sHtml + '</head>';
         sHtml := sHtml + sCabecalho;


         //Número da sorte usados
           qry.SQL.Clear;
           qry.sql.Add(' select count(1) num_sorte_usado from ns_notas_certificados a, grz_lojas_seguro_numeracao t '+
                         ' where a.num_sorte = t.numero_da_sorte '+
                         ' and a.num_proposta_capital = t.num_apolice');
           qry.Active := true;


          //Número da sorte disponivel
           FDQuery1.SQL.Clear;
           FDQuery1.sql.Add(' select count(1) num_sorte_disponivel from grz_lojas_seguro_numeracao t');
           FDQuery1.Active := true;

sPerUso   := FormatFloat('0.00',((qry.FieldByName('num_sorte_usado').AsFloat * 100)/ FDQuery1.FieldByName('num_sorte_disponivel').AsFloat));

          sHtml := sHtml + '<tr>';
          sHtml := sHtml + '<td>'+sPerUso+ ' %'+ '</td>';
          sHtml := sHtml + '</tr>';

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


procedure TfrmRel_Numero_Sorte.FormCreate(Sender: TObject);
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

procedure TfrmRel_Numero_Sorte.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    case key of
          VK_RETURN : Perform(WM_NEXTDLGCTL,0,0);
     end;
end;



procedure TfrmRel_Numero_Sorte.CarregaParametros;
var
 sDiretorio: string;
begin
   try
  //sDiretorio := GetCurrentDir;
  sDiretorio :='C:\Rel_Envial_Email_Numero_Sorte';
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
