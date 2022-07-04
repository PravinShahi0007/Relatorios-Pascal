unit uRel_Prod_Email;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.Oracle,
  FireDAC.Phys.OracleDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids,
  ACBrBase, ACBrMail,System.IniFiles;

type
  TfrmRel_Prod_Desc_Email = class(TForm)
    btnConsultar: TBitBtn;
    fdcConexao: TFDConnection;
    qryConsulta: TFDQuery;
    dtsqryConsulta: TDataSource;
    qryConsultaItem: TStringField;
    qryConsultaDescri��o: TStringField;
    qryConsultaLivro: TStringField;
    qryConsultaCD: TBCDField;
    qryConsultaRecebimento: TDateTimeField;
    qryConsultaEstCD: TFMTBCDField;
    qryConsultaPadr�o: TFMTBCDField;
    ACBrMail1: TACBrMail;
    qryConsultaComprador: TStringField;
    FDPhysOracleDriverLink1: TFDPhysOracleDriverLink;
    procedure btnConsultarClick(Sender: TObject);
    procedure CarregaParametros;
    Function HTML(sItem,sDescricao,sComprador,sLivro,sCD,sRecebimento,sEstoque,sPadrao : string): string;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    sUsuario, sBanco, sSenha : String;
  end;

var
  frmRel_Prod_Desc_Email: TfrmRel_Prod_Desc_Email;
  sEmail,sAssunto,sEmailFrom,sUserName,sPassword,sNome,sCopia_oculta :STRING;
    iArqIni : tIniFile;

implementation

{$R *.dfm}

uses Encryp, uCarregaSenha, ufuncoes;

procedure TfrmRel_Prod_Desc_Email.btnConsultarClick(Sender: TObject);
var
sCabecalho,sItem,sDescricao,sComprador,sLivro,sCD,sRecebimento,sEstoque,sPadrao,sHtml,sTabela, sCaminhoArquivo : string;
iRegistros: Integer;
sHtmlEX : TStrings;
begin

  //CAMINHO DO ARQUIVO
  sCaminhoArquivo := 'C:\Rel_Prod_Desc_Email';

  {como a m�quina � do IP 172, a conex�o remota com o 32 n�o da certo
   ent�o tem que mudar a conex�o para 192 para o execut�vel funcionar
   caso isso n�o aconte�a vai dar um erro de conex�o com o banco com
   a mensagem da linha 275 do c�digo}

  try
         //MONTANDO O CABE�ALHO TA TABELA HTLM
         sCabecalho := ''                       +
                       '<tr>'                   +
                       '<th>Comprador</th>'     +
                       '<th>Itens</th>'         +
                       '<th>Descri��o</th>'     +
                       '<th>Livro</th>'         +
                       '<th>CD</th>'            +
                       '<th>Recebimento</th>'   +
                       '<th>Estoque</th>'       +
                       '<th>Padr�o</th>'        +
                       '</tr>'                  ;

         //MONTANDO A PARTE INICIAL DO HTML COM OS T�TULOS
         sHtml := ''                                                                                                                                     +
                  '<html>'                                                                                                                               +
                  '<head>'                                                                                                                               +
                  '<title>Grupo Grazziotin</title>'                                                                                                      +
                  '<h3>Grupo Grazziotin S/A.</h3>'                                                                                                       +
                  '</head>'                                                                                                                              +
                  '<body>'                                                                                                                               +
                  '<table border="1" cellpadding="" cellspacing="1">'                                                                                    +
                  '<tr>'                                                                                                                                 +
                  '<td align="center" colspan="13"><p><b><font face="arial" size="3" color="	#000000">Relat�rio de Estoque CD</font></b></p></td>'      +
                  '</tr>'                                                                                                                                ;

         //JUNTANDO A PARTE INICIAL DO HTML COM O CABE�ALHO
         sHtml := sHtml + sCabecalho;


      frmRel_Prod_Desc_Email.qryConsulta.active := False;

  //PASSANDO A CONSULTA PARA DENTRO DA QUERY
  frmRel_Prod_Desc_Email.qryConsulta.SQL.Text :=  'select p.des_pessoa "Comprador"                                                '+
                                                  '    ,c.cod_editado "Item"                                                      '+
                                                  '    ,b.des_item "Descri��o"                                                    '+
                                                  '    ,b.des_geral "Livro"                                                       '+
                                                  '    ,a.cod_unidade "CD"                                                        '+
                                                  '    ,max(a.dta_recebimento) "Recebimento"                                      '+
                                                  '    ,sum(est_cd.qtd_est_cd) "Est CD"                                           '+
                                                  '    ,sum(est_pad.qtd_padrao) "Padr�o"                                          '+
                                                  'from nl.ne_ficha_compras a                                                        '+
                                                  '    ,nl.ie_itens b                                                                '+
                                                  '    ,nl.ie_mascaras c                                                             '+
                                                  '    ,nl.ac_ordens_compra oc                                                       '+
                                                  ',nl.ps_pessoas p                                                                  '+
                                                  '    ,(Select cod_item                                                          '+
                                                  '            ,sum(nvl(qtd_entrada,0) - nvl(qtd_saida,0)) qtd_est_cd             '+
                                                  '        from nl.ce_locais_entrada                                                 '+
                                                  '       where cod_emp = 1                                                       '+
                                                  '         and cod_unidade in (818,838,848,858)                                  '+
                                                  'and cod_local = ''101000''                                                     '+
                                                  '      having sum(nvl(qtd_entrada,0) - nvl(qtd_saida,0)) > 0                    '+
                                                  '       group by cod_item ) est_cd                                              '+
                                                  '    ,(select ce.cod_item,sum(nvl(ce.qtd_est_min_i,0)) qtd_padrao               '+
                                                  '        from nl.ce_pars_calculo ce                                                '+
                                                  '            ,nl.ie_mascaras iem                                                   '+
                                                  '            ,nl.ie_itens ie                                                       '+
                                                  '       where ie.cod_item = ce.cod_item                                         '+
                                                  '         and ie.ind_avulso = 0                                                 '+
                                                  '         and iem.cod_item = ce.cod_item                                        '+
                                                  '         and iem.cod_mascara = 170                                             '+
                                                  '         and iem.cod_niv0 =''1''                                               '+
                                                  '         and ce.cod_emp+0   = 1                                                '+
                                                  'and ce.cod_unidade not in (13,818,838,848,858,549,1549,3549,4549,5549)         '+
                                                  '         and nvl(ce.qtd_est_min_i,0) > 0                                       '+
                                                  '       group by ce.cod_item ) est_pad                                          '+
                                                  'where est_pad.cod_item(+)=a.cod_item                                           '+
                                                  ' and est_cd.cod_item(+)=a.cod_item                                             '+
                                                  ' and p.cod_pessoa    = oc.cod_comprador                                        '+
                                                  ' and oc.COD_EMP      = a.cod_emp                                               '+
                                                  ' and oc.COD_UNIDADE  = a.cod_unidade                                           '+
                                                  ' and oc.COD_PESSOA   = a.cod_pessoa                                            '+
                                                  ' and oc.NUM_ORDEM_COMPRA = a.num_oc                                            '+
                                                  ' and b.cod_item = a.cod_item                                                   '+
                                                  ' and b.ind_avulso=0                                                            '+
                                                  ' and b.ind_inativo=0                                                           '+
                                                  ' and upper(b.des_geral)=''L''                                                  '+
                                                  ' and c.cod_item = a.cod_item                                                   '+
                                                  ' and c.cod_mascara = 170                                                       '+
                                                  ' and c.cod_niv0 = ''1''                                                        '+
                                                  ' and not exists(select 1 from nl.grz_item_compras d                               '+
                                                  '                        where d.cod_item = a.cod_item)                         '+
                                                  ' and a.cod_emp=1                                                               '+
                                                  ' and a.dta_recebimento >= trunc(sysdate - 150)                                 '+
                                                  ' and a.cod_oper = 104                                                          '+
                                                  ' and a.cod_unidade in (818, 838, 848, 858)                                     '+
                                                  'having sum(est_cd.qtd_est_cd) > 10                                             '+
                                                  '  and sum(nvl(est_pad.qtd_padrao,0)) = 0                                       '+
                                                  'and max(a.dta_recebimento) <= trunc(sysdate - 3)                               '+
                                                  'group by p.des_pessoa,c.cod_editado,b.des_item,b.des_geral,a.cod_unidade       '+
                                                  ' order by 1,2                                                                  ';

    //ATIVANDO A QUERY
    try
      frmRel_Prod_Desc_Email.qryConsulta.active := True;
    //CASO ACONTE�A ALGUM ERRO VAI APARECER NA TELA
    except on E: Exception do
          begin
            ShowMessage(E.Message);
          end;

    end;

    //INICIA UM CONTADOR DE DADOS PROCURADOS NO BANCO DE DADOS
    iRegistros := frmRel_Prod_Desc_Email.qryConsulta.RecordCount;
         //CASO N�O HOUVER NENHUM REGISTRO ENCONTRADO
         if  frmRel_Prod_Desc_Email.qryConsulta.RecordCount = 0 then
              begin
                ShowMessage('Nenhum Registro Encontrado!');
                Abort;
              end;

             //APONTANDO PARA O PRIMEIRO REGISTRO ENCONTRADO NO BANCO DE DADOS E PASSANDO OS PAR�METROS
             frmRel_Prod_Desc_Email.qryConsulta.First;
             //FAZ PERCORRER A QUERY INTEIRA AT� A �LTIMA LINHA, PEGANDO PAR�METROS A CADA LINHA PASSADA
             while not frmRel_Prod_Desc_Email.qryConsulta.Eof  do
             begin
                 sComprador   := frmRel_Prod_Desc_Email.qryConsulta.FieldByName('Comprador').AsString;
                 sItem        := frmRel_Prod_Desc_Email.qryConsulta.FieldByName('Item').AsString;
                 sDescricao   := frmRel_Prod_Desc_Email.qryConsulta.FieldByName('Descri��o').AsString;
                 sLivro       := frmRel_Prod_Desc_Email.qryConsulta.FieldByName('Livro').AsString;
                 sCD          := frmRel_Prod_Desc_Email.qryConsulta.FieldByName('CD').AsString;
                 sRecebimento := frmRel_Prod_Desc_Email.qryConsulta.FieldByName('Recebimento').AsString;
                 sEstoque     := frmRel_Prod_Desc_Email.qryConsulta.FieldByName('Est CD').AsString;
                 sPadrao      := frmRel_Prod_Desc_Email.qryConsulta.FieldByName('Padr�o').AsString;

                 //PASSA OS PAR�METROS DA LINHA ENCONTRADA PRA VARI�VEL sTabela
                 sTabela := HTML(sItem,sDescricao,sComprador,sLivro,sCD,sRecebimento,sEstoque,sPadrao);



                                        //JUNTANDO OS DADOS ENCONTRADOS NO CONTADOR
                                                sHtml :=  sHtml +
                                        '            '+sTabela;
                 frmRel_Prod_Desc_Email.qryConsulta.Next;
             end;

             //JUNTANDO COM A PARTE FINAL DO HTML
             sHtml :=  sHtml +
                                        ' </table>                   '+
                                        '                            '+
                                        ' </body>                    '+
                                        ' </html>                    ';

      begin
        sHtmlEX := TStringList.Create;
        try
          sHtmlEX.text := sHtml;
          {frmTelaCPP.UniHTMLFrame1.HTML:= sHtmlEX;---caso tenha que chamar em outra tela---}
        finally
          sHtmlEX.Free;
        end;
     end;

       //PEGA OS PAR�METROS LISTADOS NA PASTA DO ARQUIVO CONFIG.INI E O CORPO DE TEXTO HTML
       ACBrMail1.From := sEmailFrom;
       ACBrMail1.FromName := sNome;
       ACBrMail1.Host := 'smtp.office365.com';
       ACBrMail1.Username := sUserName;
       ACBrMail1.Password := sPassword;
       ACBrMail1.Port := '587';
       ACBrMail1.AddAddress(sEmail,'');
       ACBrMail1.AddBCC(sCopia_oculta);
       ACBrMail1.Subject := UTF8Decode(sAssunto);
       ACBrMail1.IsHTML := True;
       ACBrMail1.Body.Text :=  sHtml;
       AcbrMail1.SetTLS := True;
       ACBrMail1.Send;


  //COMANDO PARA VER QUAL ERRO TA DANDO EM TELA
  except on E: Exception do
          begin
            ShowMessage(E.Message);
          end;

  end;


end;





//PEGA OS PAR�METROS LISTADOS NA PASTA DO ARQUIVO CONFIG.INI
procedure TfrmRel_Prod_Desc_Email.CarregaParametros;
var
 sDiretorio, sIp: string;
 TomEncryption1: TTomEncryption;
begin
   try
  TomEncryption1 := TTomEncryption.Create(Self);
  CarregaSenhasBancoOra('GRZPNL_BERLIN',TomEncryption1,sUsuario,sSenha,sBanco);
  //sDiretorio := GetCurrentDir;
  sDiretorio :='C:\Rel_Prod_Desc_Email';
  iArqIni := TIniFile.Create(sDiretorio+'\config.ini');
  sEmail := iArqIni.ReadString('EMAIL','EMAIL','');
  sAssunto := iArqIni.ReadString('EMAIL FROM','Assunto','');
  sEmailFrom := iArqIni.ReadString('EMAIL FROM','Endereco','');
  sUserName := iArqIni.ReadString('EMAIL FROM','UserName','');
  sPassword := iArqIni.ReadString('EMAIL FROM','Password','');
  sNome := iArqIni.ReadString('EMAIL FROM','Nome','');
  sCopia_oculta :=  iArqIni.ReadString('EMAIL FROM','copia_oculta','');


  iArqINI.Free;{tem que declarar na uses do projeto}

 except
  ShowMessage('Erro: N�o carregou arquivo de configura��o.'+chr(13)+
             'Verifique!!!!'+chr(13)+
             sDiretorio+'\config.ini');
  Application.Terminate;
  exit;
 end;



end;

procedure TfrmRel_Prod_Desc_Email.FormCreate(Sender: TObject);
//FAZ A CONEX�O COM O BANCO DE DADOS ('nl') POIS � ORACLE
begin
   CarregaParametros;
       try
     fdcConexao.Params.Database := sBanco;
     fdcConexao.Params.UserName := sUsuario;
     fdcConexao.Params.Password := sSenha;
     fdcConexao.Connected := True;
   except
       on E:EDatabaseError do
            begin
                 Informacao('Erro!!!'+#13+'N�o pode se conectar ao banco!!!','Aviso!!!');
                 Halt(0);
            end;
   end;

    //FAZ O PROGRAMA CLICAR DIRETO NO BOT�O PARA O ENVIO DO E-MAIL
   // CarregaParametros;
    btnConsultarClick(Sender);
    Application.Terminate;
end;

procedure TfrmRel_Prod_Desc_Email.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    case key of
          VK_RETURN : Perform(WM_NEXTDLGCTL,0,0);
    end;
end;

function TfrmRel_Prod_Desc_Email.HTML(sItem, sDescricao, sComprador, sLivro, sCD,
  sRecebimento, sEstoque, sPadrao: string): string;
//MONTA LINHA A LINHA OS DADOS ENCONTRADOS NO BANCO DE DADOS
  var
    sTabela : string;
  begin
    sTabela :=            ' <tr>                                                          '+
                          '   <td>'+sComprador+'</td>                                     '+
                          '   <td>'+sItem+'</td>                                          '+
                          '   <td>'+sDescricao+'</td>                                     '+
                          '   <td>'+sLivro+'</td>                                         '+
                          '   <td>'+sCD+ '</td>                                           '+
                          '   <td>'+sRecebimento+'</td>                                   '+
                          '   <td>'+sEstoque+'</td>                                       '+
                          '   <td>'+sPadrao+'</td>                                        '+
                          ' </tr>                                                         ';

    result := sTabela;
  end;


end.
