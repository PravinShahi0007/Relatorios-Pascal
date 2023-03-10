unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.Oracle,
  FireDAC.Phys.OracleDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, ACBrBase, ACBrMail, Data.DB, IniFiles,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Buttons, Encryp,
  uCarregaSenha;

type
  TfrmPrincipal = class(TForm)
    FDConnection1: TFDConnection;
    qry: TFDQuery;
    dtsCadastrosNovos: TDataSource;
    dtsItens: TDataSource;
    qryItens: TFDQuery;
    FDPhysOracleDriverLink1: TFDPhysOracleDriverLink;
    ACBrMail1: TACBrMail;
    btnImprimir: TBitBtn;
    procedure btnImprimirClick(Sender: TObject);
    procedure CarregaParametros;
    procedure FormCreate(Sender: TObject);
    procedure CarregaParamsBanco;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;
  dDataIni, dDataFin       : TDateTime;
  iNumero : integer;
  sDataMax : string;
  iArqIni : tIniFile;
  sEmail,sAssunto,sEmailFrom,sUserName,sPassword,sNome,sCopia_oculta :STRING;
  sUsuario, sBanco, sSenha : String;
implementation

{$R *.dfm}

procedure TfrmPrincipal.btnImprimirClick(Sender: TObject);
var
sCaminhoArquivo,sNomeArquivo,sCabecalho,sHtml: String;
sCodItem, sCodGrupo, sCodGrupoAtual, sCodGrupoAntigo,sCodGrupoTotal :string;
iCodUnidade, iNumNota, iTotalCaracteres  : integer;
dDataVenda : tdate;

begin
    sCaminhoArquivo := 'c:\EnviaTransferencia\';

    sCabecalho := '';
    sCabecalho := sCabecalho + '<tr>';
    sCabecalho := sCabecalho + '<th style="width:100px" >Loja Origem</th>';
    sCabecalho := sCabecalho + '<th style="width:500px" >Nome</th>';
    sCabecalho := sCabecalho + '<th style="width:100px" >Num. Nota</th>';
    sCabecalho := sCabecalho + '<th style="width:100px" >Emiss?o</th>';
    sCabecalho := sCabecalho + '<th style="width:100px" >Valor Total</th>';
    sCabecalho := sCabecalho + '<th style="width:100px" >Cliente</th>';
    sCabecalho := sCabecalho + '<th style="width:500px" >Nome</th>';
    sCabecalho := sCabecalho + '<th style="width:100px" >Loja Destino</th>';
    sCabecalho := sCabecalho + '<th style="width:500px" >Nome</th>';
    sCabecalho := sCabecalho + '<th style="width:100px" >Grupo de Itens</th>';

    sCabecalho := sCabecalho + '</tr>';

    qry.Active := false;
    qry.SQL.Clear;
    qry.sql.Add(' select  n.cod_unidade,   '+
                     //   '  b.des_nome_loja,'+
                        '  p.des_fantasia, '+
                        '  n.num_nota,     '+
                        '  n.dta_venda,    '+
                        '  n.cod_cliente,  '+
                        '  n.des_dest,      '+
                        '  n.des_ender_dest, '+
                        '  n.des_bairro_dest,'+
                        '  n.num_cep_dest,  '+
                        '  n.des_cidade_dest, '+
                        '  n.vlr_produtos,  '+
                        '  n.vlr_total,      '+
                        '  n.num_seq_nota,   '+
                        '  n.vlr_liquido,     '+
                        '  n.txt_observacao,  '+
                        '  n.loja_destino,    '+
                        '  s.des_fantasia,      '+
                        '  n.rde_item,         '+
                        '  s.des_fantasia as NomeLojaDes,'+
                        '  count(i.des_item)    '+
                  '  from nl.grz_lojas_ne_notas n,  '+
                  '       nl.grz_lojas_ne_notas_itens i,'+
                  '       nl.grz_lojas_tamanho_base b,  '+
                  '       nl.grz_lojas_tamanho_base c,  '+
                  '       nl.ps_pessoas p,              '+
                  '       nl.ps_pessoas s               '+
                  ' where n.cod_unidade = i.cod_unidade '+
                  '   and n.num_nota = i.num_nota       '+
                  '   and n.cod_filial = i.cod_filial    '+
                  '   and n.dta_emissao = i.dta_emissao  '+
                  '   and n.cod_unidade = b.cod_unidade   '+
                  '   and n.loja_destino = c.cod_unidade  '+
                  '   and n.loja_destino = s.cod_pessoa   '+
                  '   and p.cod_pessoa = b.cod_unidade    '+
                  '   and n.loja_destino > 0              '+
                 // '   and n.dta_emissao ='+ QuotedStr('01/04/2022') +
                  '   and n.dta_emissao >= '+ QuotedStr(DateToStr(Date - 7)) +
                  ' and n.ind_mot_transf in (7,3) '+ //Foi colocado para pegar apenas transferencia entre unidades e e excesso de estoque na loja
                  ' group by n.cod_unidade,p.des_fantasia, n.num_nota, n.dta_venda, n.cod_cliente, n.des_dest,  '+
                  '             n.des_ender_dest, n.des_bairro_dest, n.num_cep_dest, n.des_cidade_dest,   '+
                  '             n.vlr_produtos, n.loja_destino, n.vlr_total, n.num_seq_nota, n.vlr_liquido, n.txt_observacao,  '+
                  '             s.des_fantasia,  n.rde_item,  c.des_nome_loja' +
                  ' order by n.cod_unidade, n.num_nota '    );

   qry.Active := true;

       sHtml := '';
       sHtml := sHtml+ ' <!DOCTYPE html>'+
                      ' <html lang="en" >'+
                      ' <head>'+
                      ' <meta charset="UTF-8">'+
                      ' <style> '+
                      ' body {'+
                      '   line-height: 1.1;'+
                      ' }'+
                      'th, td {'+
                      '    border: 0.1em solid black;'+
                      '    padding: 0px;'+
                      '    border-spacing: 0px;'+
                      '    text-align: center;'+
                      '}'+
                      ' table {'+
                      ' vertical-align: center;'+
                      ' text-align: center;'+
                      ' border-collapse: collapse;'+
                      ' border: 0.1em solid black;'+
                      ' width: 1500px;'+
                      ' }'+
                      ' </style> ';

       sHtml := sHtml + '<html>';
       sHtml := sHtml + '<head>';
       sHtml := sHtml + '<title>Grupo Grazziotin</title>';
       sHtml := sHtml + '<h3>Lojas que realizaram Tranfer?ncia entre Unidades.</h3>';
       sHtml := sHtml + '</head>';
       sHtml := sHtml + '<body>';
       sHtml := sHtml + 'Data: '+FormatDateTime('dd/mm/yyyy',Date) + '  Hora: '+FormatDateTime('hh:mm', Time)+'</b></p>';
       sHtml := sHtml + 'Notas faturadas, por?m, podem n?o estar integradas ao NL..'+'</p>';
       sHtml := sHtml + '<table border="1" cellpadding="3" cellspacing="1">';

       sHtml := sHtml + sCabecalho;

       if qry.RecordCount > 0 then
       Begin
           qry.First;
           while not qry.Eof do
            Begin
                iCodUnidade :=  qry.FieldByName('cod_unidade').AsInteger;
                iNumNota :=  qry.FieldByName('num_nota').AsInteger;
                sCodGrupoTotal := '';
                sCodGrupoAtual := '';
                sCodGrupoAntigo := '';
                sCodGrupo := '';
                qryItens.Active := false;
                qryItens.SQL.Clear;
                qryItens.sql.Add('    select cod_item   '+
                                 '          ,LPAD (cod_item,10,0) as codEditado '+
                                 ' from grz_lojas_ne_notas_itens '+
                                ' where cod_unidade = '+IntToStr(iCodUnidade)+
                                  ' and num_nota = '+IntToStr(iNumNota));
                qryItens.Active := true;
                qryItens.First;
                while not qryItens.Eof do
                begin
                   sCodItem :=   qryItens.FieldByName('cod_item').AsString;
                   sCodGrupo :=  qryItens.FieldByName('codEditado').AsString;
                   sCodGrupoAtual := Copy(sCodGrupo,0,4);
                      if sCodGrupoAtual <> sCodGrupoAntigo then
                      begin
                        sCodGrupoTotal := Copy(sCodGrupo,0,4) +','+sCodGrupoAntigo;
                        sCodGrupoAntigo:= sCodGrupoAtual;
                      end;

                   qryItens.Next;
                end;

                iTotalCaracteres := length(sCodGrupoTotal);
                sCodGrupoTotal  := copy(sCodGrupoTotal,1,iTotalCaracteres-1);
                sCodGrupoTotal :=copy(sCodGrupoTotal,0,2) +'.'+copy(sCodGrupoTotal,3,4);

                sHtml := sHtml + '<tr>';
                sHtml := sHtml + '<td align="center" WIDTH=100>'+qry.FieldByName('cod_unidade').AsString+'</td>';
                //sHtml := sHtml + '<td align="center" WIDTH=500>'+qry.FieldByName('des_nome_loja').AsString+'</td>';
                sHtml := sHtml + '<td align="center" WIDTH=500>'+qry.FieldByName('des_fantasia').AsString+'</td>';
                sHtml := sHtml + '<td align="center" WIDTH=100>'+qry.FieldByName('num_nota').AsString+'</td>';
                sHtml := sHtml + '<td align="center" WIDTH=100>'+qry.FieldByName('dta_venda').AsString+'</td>';
                sHtml := sHtml + '<td align="center" WIDTH=100>'+FormatFloat('#,0.00;-#,0.00',qry.FieldByName('vlr_total').AsFloat)+'</td>';
                sHtml := sHtml + '<td align="center" WIDTH=100>'+qry.FieldByName('cod_cliente').AsString+'</td>';
                sHtml := sHtml + '<td align="center" WIDTH=500>'+qry.FieldByName('des_dest').AsString+'</td>';
                sHtml := sHtml + '<td align="center" WIDTH=100>'+qry.FieldByName('loja_destino').AsString+'</td>';
                sHtml := sHtml + '<td align="center" WIDTH=500>'+qry.FieldByName('NomeLojaDes').AsString+'</td>';
                sHtml := sHtml + '<td align="center" WIDTH=150>'+copy(sCodGrupoTotal,0,5) +'</td>';
                sHtml := sHtml + '</tr>';
                qry.Next;
            end;
       end
       else

       sHtml := sHtml + '</table>';
       sHtml := sHtml + '</body>';
       sHtml := sHtml + '</html>';
    if qry.RecordCount > 0 then
    begin
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
          AcbrMail1.SetSSL := False;
          ACBrMail1.Send;
    end;
end;

procedure TfrmPrincipal.CarregaParametros;
var
 sDiretorio: string;
begin
     try
        sDiretorio :='C:\EnviaTransferencia\';
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
        ShowMessage('Erro: N?o carregou arquivo de configura??o.'+chr(13)+
                   'Verifique!!!!'+chr(13)+
                   sDiretorio+'\config.ini');
        Application.Terminate;
        exit;
     end;
end;

procedure TfrmPrincipal.CarregaParamsBanco;
var TomEncryption1: TTomEncryption;
begin
    TomEncryption1 := TTomEncryption.Create(Self);
    CarregaSenhasBancoOra('GRZPNL_BERLIN',TomEncryption1,sUsuario,sSenha,sBanco);
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  CarregaParamsBanco;
  try
     FDConnection1.Params.Database := sBanco;
     FDConnection1.Params.UserName := sUsuario;
     FDConnection1.Params.Password := sSenha;
     FDConnection1.Connected := True;
   except
       on E:EDatabaseError do
            begin
                 MessageDlg('Falha ao conectar o banco '+#13+
                            'a aplica??o vai fechar!'+#13+
                            E.Message,mtInformation,[mbOk], 0);
                Application.Terminate;
            end;
   end;
    CarregaParametros;
    btnImprimirClick(Sender);
    Application.Terminate;
end;

end.
