unit uRel_Clientes_APP;

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
  TfrmRel_Clientes_APP = class(TForm)
    FDConnection1: TFDConnection;
    FDPhysOracleDriverLink1: TFDPhysOracleDriverLink;
    dtsCadastrosNovos: TDataSource;
    qryCadastrosNovos: TFDQuery;
    btnImprimir: TBitBtn;

    qryCadastros: TFDQuery;
    dtsCadastros: TDataSource;
    qryClientes: TFDQuery;
    dtsClientes: TDataSource;
    qryCliAprovados: TFDQuery;
    dtsCliAprovados: TDataSource;
    dtsCliPendnetes: TDataSource;
    qryCliPendentes: TFDQuery;
    qryPgto_App: TFDQuery;
    dtsPgto_App: TDataSource;
    qryPgtoParcelas: TFDQuery;
    dtsPgtoParcelas: TDataSource;
    qryValorPgtoParcelas: TFDQuery;
    dtsValorPgtoParcelas: TDataSource;
    ACBrMail1: TACBrMail;
    dtsBoletosDecre: TDataSource;
    qryBoletosDecre: TFDQuery;
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
  frmRel_Clientes_APP: TfrmRel_Clientes_APP;
  dDataIni, dDataFin       : TDateTime;
  iNumero : integer;
  sDataMax : string;
  iArqIni : tIniFile;
  sEmail,sAssunto,sEmailFrom,sUserName,sPassword,sNome,sCopia_oculta :STRING;

implementation

{$R *.dfm}

uses uFunc, ufuncoes;

procedure TfrmRel_Clientes_APP.btnImprimirClick(Sender: TObject);
var
sMes, sAno, sParametros, sUsuario, sDia, sDt_Inicial, sDt_Final, sDataSelect,sSQL, sCodEmp,sDiaInicial,sDiaFinal,sMesInicial,sAnoInicial,
sCaminhoArquivo,sNomeArquivo,dataemail : String;
Size : Cardinal;
sHtml, sRede : String;
iContProdutos, iUnidade ,i : Integer;
sCabecalho : string;
sCadastrosNovos,sPgto_App,sVAlor_Pgto_App_Parcelas,sPgto_App_ParcelasAPP,sPgto_App_Parcelas0800,sValorPgto_App_Parcelas0800,sValorPgto_App_ParcelasAPP,sNumCadastro,
 sCli_Antigos,sCli_Aprovados,sCli_Pend_Aprov,sPgto_App_Parcelas, sdataCli, sQtdDecre, sValorDecre: String;

bContinuar : Boolean;
iDiasData, iLimiteLaco: Integer;
sDt_inical_temp,sDt_final_temp, sDt_final_tempTela : String;
dQtdFinal,dValorFinal : real;
begin
        sDia := copy(DateToStr(Date-1),0,2);
        sMes  := copy(DateToStr(Date-1),4,2);
        sAno  := copy(DateToStr(Date-1),7,4);

        sDt_final_temp  := PadLeft(sDia+'/'+sMes+'/'+sAno,8,'0');
        bContinuar := True; //inicia o laco como verdadeiro
        iDiasData := 0; // inicia com os dias que quer descontar da data fim
        iLimiteLaco := 7; // dias que quero ir diminuindo

        sCaminhoArquivo := 'C:\Rel_Clientes_APP\';

    try
         sCabecalho := '';
         sCabecalho := sCabecalho + '<tr>';
         sCabecalho := sCabecalho + '<th>Data</th>';
         sCabecalho := sCabecalho + '<th>Total de Clientes </th>';
         sCabecalho := sCabecalho + '<th>Clientes Novos</th>';
         sCabecalho := sCabecalho + '<th>Clientes Grazziotin </th>';
         sCabecalho := sCabecalho + '<th>Cadastro Novos Aprovados</th>';
         sCabecalho := sCabecalho + '<th>Cadastros novos pendentes de aprovação</th>';
         sCabecalho := sCabecalho + '<th>Qtd.Cli. Pagaram no APP</th>';
         sCabecalho := sCabecalho + '<th>Qtd.Parcelas Pagas APP</th>';
         sCabecalho := sCabecalho + '<th>Valor Parcelas Pagas APP</th>';
         sCabecalho := sCabecalho + '<th>Qtd.Parcelas Pagas APP DECRE </th>';
         sCabecalho := sCabecalho + '<th>Valor Parcelas Pagas APP DECRE</th>';
          sCabecalho := sCabecalho + '<th>Qtd.Parcelas Pagas 0800</th>';
         sCabecalho := sCabecalho + '<th>Valor Parcelas Pagas 0800</th>';
         sCabecalho := sCabecalho + '</tr>';


         sHtml := '';
         sHtml := sHtml + '<html>';
         sHtml := sHtml + '<head>';
         sHtml := sHtml + '<title>Grupo Grazziotin</title>';
         sHtml := sHtml + '<h3>Grupo Grazziotin S/A.</h3>';
         sHtml := sHtml + '</head>';
         sHtml := sHtml + '<body>';
         sHtml := sHtml + 'Data: '+FormatDateTime('dd/mm/yyyy',Date) + '  Hora: '+FormatDateTime('hh:mm', Time)+'</b></p> <p>Dados acumulados desde 01/03/2020</p>';
           //sHtml := sHtml + '<br></br>';
         sHtml := sHtml + '<table border="1" cellpadding="" cellspacing="1">';
         sHtml := sHtml + '<tr>';
         sHtml := sHtml + '<td align="center" colspan="13"><p><b><font face="arial" size="3" color="	#000000">Clientes APP</font></b></p></td>';
         sHtml := sHtml + '</tr>';
         sHtml := sHtml + sCabecalho;


       //Número de cadastros
       while bContinuar do
         begin

           //Número de cadastreos
           qryCadastros.SQL.Clear;
           qryCadastros.sql.Add(' select count(1) Cli_Cadastro FROM APPGRZ.Grz_Api_Ps_Pessoas a ,appgrz.grz_api_user b '+
                                        ' WHERE b."cpf" = a.num_cpf '+

                                        ' and trunc(b."created_at")  >= (TO_DATE( ''01/03/2020'') - 0)    '+
                                        ' and trunc(b."created_at") <= (TO_DATE( :DATA_FINAL) - :QTD_FINAL)  ' );

           qryCadastros.Params.ParamByName('DATA_FINAL').AsString := sDt_final_temp; // coloca a data que vc quer iniciar
           qryCadastros.Params.ParamByName('QTD_FINAL').AsInteger := iDiasData; // coloca os dias que quer diminuir da data final senao quiser diminuir vai 0

			     qryCadastros.Active := true;
           //sNumCadastro :=  qryCadastros.FieldByName('Cli_Cadastro').value;
            sNumCadastro:=  FormatFloat('#,###',  qryCadastros.FieldByName('Cli_Cadastro').AsInteger);

           if  qryCadastros.RecordCount = 0 then
              begin
              sNumCadastro:= '0';
            end;


            //Número de cadastros novos
            qryCadastrosNovos.Active := false;
            qryCadastrosNovos.SQL.Clear;
            qryCadastrosNovos.sql.Add(' select count(1) Cli_Novos FROM APPGRZ.Grz_Api_Ps_Pessoas a , appgrz.grz_api_user b '+
                                            ' WHERE b."cpf" = a.num_cpf '+

                                            ' and nvl(a.ind_cliente,0) = 0 '+
                                            ' and trunc(b."created_at")  >= (TO_DATE( ''01/03/2020'') - 0)    '+
                                            ' and trunc(b."created_at") <= (TO_DATE( :DATA_FINAL) - :QTD_FINAL)  ' );

            qryCadastrosNovos.Params.ParamByName('DATA_FINAL').AsString := sDt_final_temp; // coloca a data que vc quer iniciar
            qryCadastrosNovos.Params.ParamByName('QTD_FINAL').AsInteger := iDiasData; // coloca os dias que quer diminuir da data final senao quiser diminuir vai 0

            qryCadastrosNovos.Active := true;
            sCadastrosNovos := FormatFloat('#,###',  qryCadastrosNovos.FieldByName('Cli_Novos').AsInteger);
            if  qryCadastrosNovos.RecordCount = 0 then
             begin
              sCadastrosNovos:= '0';
             end;

            // A diferença será dos que já são clientes
            qryClientes.Active := false;
            qryClientes.SQL.Clear;
            qryClientes.sql.Add( ' select count(1)Cli_Antigos FROM APPGRZ.Grz_Api_Ps_Pessoas a ,appgrz.grz_api_user b '+
                                        ' WHERE b."cpf" = a.num_cpf  '+

                                        ' and nvl(a.ind_cliente,0) =1  '+
                                        ' and trunc(b."created_at")  >= (TO_DATE( ''01/03/2020'') - 0)    '+
                                        ' and trunc(b."created_at") <= (TO_DATE( :DATA_FINAL) - :QTD_FINAL)  ' );

            qryClientes.Params.ParamByName('DATA_FINAL').AsString := sDt_final_temp; // coloca a data que vc quer iniciar
            qryClientes.Params.ParamByName('QTD_FINAL').AsInteger := iDiasData; // coloca os dias que quer diminuir da data final senao quiser diminuir vai 0

            qryClientes.Active := true;
            sCli_Antigos := FormatFloat('#,###',  qryClientes.FieldByName('Cli_Antigos').AsInteger);

            if  qryCadastrosNovos.RecordCount = 0 then
              begin
                sCli_Antigos:= '0';
              end;

            //Número de cadastros novos aprovados
            qryCliAprovados.Active := false;
            qryCliAprovados.SQL.Clear;
            qryCliAprovados.sql.Add(' select count(1) as Cli_Aprovados from APPGRZ.Grz_Api_Ps_Pessoas a,appgrz.grz_api_user b '+
                                   ' WHERE b."cpf" = a.num_cpf '+

                                   ' and b."credit_status" = ''approve'' '+
                                   ' and nvl(a.ind_cliente,0) = 0  '+
                                   ' and trunc(b."created_at")  >= (TO_DATE( ''01/03/2020'') - 0)    '+
                                   ' and trunc(b."created_at") <= (TO_DATE( :DATA_FINAL) - :QTD_FINAL)  ' );

            qryCliAprovados.Params.ParamByName('DATA_FINAL').AsString := sDt_final_temp; // coloca a data que vc quer iniciar
            qryCliAprovados.Params.ParamByName('QTD_FINAL').AsInteger := iDiasData; // coloca os dias que quer diminuir da data final senao quiser diminuir vai 0

            qryCliAprovados.Active := true;
            sCli_Aprovados := FormatFloat('#,###',  qryCliAprovados.FieldByName('Cli_Aprovados').AsInteger);

            if  qryCliAprovados.RecordCount = 0 then
             begin
               sCli_Aprovados:= '0';
             end;

            //Número pendentes de aprovação
            qryCliPendentes.Active := false;
            qryCliPendentes.SQL.Clear;
            qryCliPendentes.sql.Add(' select count(1) as Cli_Pend_Aprov from APPGRZ.Grz_Api_Ps_Pessoas a,  appgrz.grz_api_user b '+
                                     ' WHERE b."cpf" = a.num_cpf ' +

                                     ' and b."credit_status" = ''analyze'' '  +
                                     ' and nvl(a.ind_cliente,0) = 0 ' +
                                     ' and trunc(b."created_at")  >= (TO_DATE( ''01/03/2020'') - 0)    '+
                                     ' and trunc(b."created_at") <= (TO_DATE( :DATA_FINAL) - :QTD_FINAL)  ' );

            qryCliPendentes.Params.ParamByName('DATA_FINAL').AsString := sDt_final_temp; // coloca a data que vc quer iniciar
            qryCliPendentes.Params.ParamByName('QTD_FINAL').AsInteger := iDiasData; // coloca os dias que quer diminuir da data final senao quiser diminuir vai 0

            qryCliPendentes.Active := true;
            sCli_Pend_Aprov := FormatFloat('#,###',  qryCliPendentes.FieldByName('Cli_Pend_Aprov').AsInteger);

            if  qryCliPendentes.RecordCount = 0 then
             begin
               sCli_Pend_Aprov:= '0';
             end;

            //   clientes que efetuaram pagamento pelo app
            qryPgto_App.Active := false;
            qryPgto_App.SQL.Clear;
            qryPgto_App.sql.Add('  select count(distinct a.num_cpf) as Pgto_App from APPGRZ.Grz_Api_Ps_Pessoas a, ps_fisicas p '+
                        ' where a.num_cpf = p.num_cpf '+
                        ' and exists (select 1 from cr_historicos cr   '  +
                        ' where p.cod_pessoa = cr.cod_pessoa  ' +
                        ' and cr.cod_unidade_pgto = 702    ' +
                        ' and cr.dta_pagamento >= (TO_DATE( ''01/03/2020'') - 0) '+
                        'and cr.dta_pagamento  <= (TO_DATE( :DATA_FINAL) - :QTD_FINAL) ) ' );

                qryPgto_App.Params.ParamByName('DATA_FINAL').AsString := sDt_final_temp; // coloca a data que vc quer iniciar
            qryPgto_App.Params.ParamByName('QTD_FINAL').AsInteger := iDiasData; // coloca os dias que quer diminuir da data final senao quiser diminuir vai 0

            
            qryPgto_App.Active := true;
            sPgto_App := FormatFloat('#,###',  qryPgto_App.FieldByName('Pgto_App').AsInteger);

            if  qryPgto_App.RecordCount = 0 then
              begin
                sPgto_App:= '0';
              end;

              // Pagamento parcelas Decre

            qryBoletosDecre.Active := false;
            qryBoletosDecre.SQL.Clear;
            qryBoletosDecre.SQL.Text := ' select count(1) as qtd_parcelas, ' +
                                      //  ' sum(nvl(w.vlr_pago,0) + nvl(w.vlr_multa,0) + nvl(w.vlr_juros,0)) as valor_pago ' +
                                         'sum(nvl(w.vlr_pago,0) + nvl(w.vlr_multa,0) + nvl(w.vlr_juros,0)- nvl(w.vlr_desconto_juros,0)- nvl(w.vlr_desconto_multa,0)) as valor_pago '+
                                        ' from appgrz.grz_api_orders a, ' +
                                        ' APPGRZ.grz_api_cr_historicos w '+
                                        ' where w.order_id = a."id"  '  +
                                        ' and trunc(a."captured_at")   >= (TO_DATE( ''01/03/2020'') - 0)    '+
                                        ' and trunc(a."captured_at")  <= (TO_DATE( :DATA_FINAL) - :QTD_FINAL)  ' +
                                        ' and a."user_id" is not null '+
                                        ' and a."status" = 2 '  +
                                        ' and w.canal in (1,2)';

                qryBoletosDecre.Params.ParamByName('DATA_FINAL').AsString := sDt_final_temp; // coloca a data que vc quer iniciar
            qryBoletosDecre.Params.ParamByName('QTD_FINAL').AsInteger := iDiasData; // coloca os dias que quer diminuir da data final senao quiser diminuir vai 0


             qryBoletosDecre.Active := true;


             sQtdDecre :=  qryBoletosDecre.FieldByName('qtd_parcelas').AsString;
             sValorDecre :=  qryBoletosDecre.FieldByName('valor_pago').AsString;

                   if  (sValorDecre = '')  or (sValorDecre = ',00') then
             begin
              // sQtdDecre := '0';
               sValorDecre  := '0';
             end;

             if  (sQtdDecre = '')  or (sQtdDecre = ',00')  then
             begin
              sQtdDecre := '0';

             end;

             // Pagamento parcelas

            qryPgtoParcelas.Active := false;
            qryPgtoParcelas.SQL.Clear;
            qryPgtoParcelas.SQL.Text :='select  sum(decode(b.cod_unidade_pgto,702,1,0)) qtd_app  '+
                                   ' ,sum(case when (b.cod_unidade_pgto = 701) or (b.cod_lancamento = 103) then 1 else 0 end) as qtd_0800   '+
                                  '  ,sum(decode(b.cod_unidade_pgto,702,(nvl(b.vlr_lancamento,0) + nvl(b.vlr_juro_cobr,0) + nvl(b.vlr_desp_cobr,0)),0)) vlr_app   '+
                                  '  ,sum(case when (b.cod_unidade_pgto = 701) or (b.cod_lancamento = 103) then    '+
                                  '   (nvl(b.vlr_lancamento,0) + nvl(b.vlr_juro_cobr,0) + nvl(b.vlr_desp_cobr,0)) else 0 end) as vlr_0800 '+
                                  '  from cr_titulos a '+
                                  '  ,cr_historicos b  '+
                                    'where b.cod_pessoa = a.cod_pessoa'+
                                    ' and b.cod_emp = a.cod_emp  '+
                                    ' and b.cod_unidade = a.cod_unidade'+
                                    ' and b.num_titulo = a.num_titulo    '+
                                    ' and b.cod_compl = a.cod_compl          '+
                                    ' and b.num_parcela = a.num_parcela     '+
                                     ' and b.dta_pagamento >= (TO_DATE( ''01/03/2020'') - 0)    '+
                           ' and b.dta_pagamento <= (TO_DATE( :DATA_FINAL) - :QTD_FINAL)  ' +
                                   ' and b.cod_lancamento in (100,101,20,65,103)';

           qryPgtoParcelas.Params.ParamByName('DATA_FINAL').AsString := sDt_final_temp; // coloca a data que vc quer iniciar
            qryPgtoParcelas.Params.ParamByName('QTD_FINAL').AsInteger := iDiasData; // coloca os dias que quer diminuir da data final senao quiser diminuir vai 0

             qryPgtoParcelas.Active := true;



           sPgto_App_ParcelasAPP := qryPgtoParcelas.FieldByName('qtd_app').AsString;
            sPgto_App_Parcelas0800 :=   qryPgtoParcelas.FieldByName('qtd_0800').AsString ;

             sValorPgto_App_ParcelasAPP :=  qryPgtoParcelas.FieldByName('vlr_app').AsString;
            sValorPgto_App_Parcelas0800 :=  qryPgtoParcelas.FieldByName('vlr_0800').AsString;

            if  qryPgtoParcelas.RecordCount = 0 then
             begin
               sPgto_App_Parcelas := '0';
               sPgto_App_ParcelasAPP := '0';
               sPgto_App_Parcelas0800  := '0';
               sValorPgto_App_ParcelasAPP := '0';
               sValorPgto_App_Parcelas0800  := '0';
             end;



              if sQtdDecre > '0' then
               begin

                  dQtdFinal :=  (StrToFloat(sPgto_App_ParcelasAPP) - StrToFloat(sQtdDecre));//FloatToStr(StrToFloat(sPgto_App_ParcelasAPP) - StrToFloat(sQtdDecre));


                       if dQtdFinal <0 then
                    begin
                       sPgto_App_ParcelasAPP:= '0';
                    end else
                     begin
                        sPgto_App_ParcelasAPP :=    FormatFloat('#,###', dQtdFinal);//sQtdFinal;
                         sQtdDecre := FormatFloat('#,###',  qryBoletosDecre.FieldByName('qtd_parcelas').AsInteger);
                     end;

               end;

               if sValorDecre > '0' then
               begin

                  dValorFinal :=  (StrToFloat(sValorPgto_App_ParcelasAPP) - StrToFloat(sValorDecre));

                  if dValorFinal <0 then
                    begin
                       sValorPgto_App_ParcelasAPP:= '0';
                    end else
                     begin
                        sValorPgto_App_ParcelasAPP :=  FormatFloat('#,0.00;-#,0.00',  dValorFinal);// svalorFinal;
                        sValorDecre := FormatFloat('#,###.00',  qryBoletosDecre.FieldByName('valor_pago').AsFloat);
                     end;

               end;

                sPgto_App_Parcelas0800 := FormatFloat('#,###',  qryPgtoParcelas.FieldByName('qtd_0800').AsInteger);
                sValorPgto_App_Parcelas0800 := FormatFloat('#,###.00',  qryPgtoParcelas.FieldByName('vlr_0800').AsFloat);

            sDt_final_tempTela := datetostr(strtodate( sDt_final_temp)-iDiasData);

             iDiasData := iDiasData + 1; // dias que vai descontar da data final

            if (iDiasData >= iLimiteLaco) then
              begin
                bContinuar := False; // setando pra falso vai sair do while
              end;


              sHtml := sHtml + '<tr>';
              sHtml := sHtml + '<td>'+sDt_final_tempTela+  '</td>';
              sHtml := sHtml + '<td align="right">'+sNumCadastro+'</td>';
              sHtml := sHtml + '<td align="right" WIDTH=100>'+sCadastrosNovos+'</td>';
              sHtml := sHtml + '<td align="right" WIDTH=100>'+sCli_Antigos+'</td>';
              sHtml := sHtml + '<td align="right" WIDTH=100>'+sCli_Aprovados+'</td>';
              sHtml := sHtml + '<td align="right" WIDTH=100>'+sCli_Pend_Aprov+'</td>';
              sHtml := sHtml + '<td align="right" WIDTH=100>'+sPgto_App+'</td>';
              sHtml := sHtml + '<td align="right">'+sPgto_App_ParcelasAPP+'</td>';
              sHtml := sHtml + '<td align="right">'+sValorPgto_App_ParcelasAPP+'</td>';
               sHtml := sHtml + '<td align="right">'+sQtdDecre+'</td>';
              sHtml := sHtml + '<td align="right">'+sValorDecre+'</td>';
              sHtml := sHtml + '<td align="right">'+sPgto_App_Parcelas0800+'</td>';
              sHtml := sHtml + '<td align="right">'+sValorPgto_App_Parcelas0800+'</td>';
              sHtml := sHtml + '</tr>';

         end;

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

    except
     //
    end;
end;


procedure TfrmRel_Clientes_APP.FormCreate(Sender: TObject);
begin
   try

     FDConnection1.Params.UserName := 'grazz';
     FDConnection1.Params.Password := 'grazz';
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

procedure TfrmRel_Clientes_APP.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    case key of
          VK_RETURN : Perform(WM_NEXTDLGCTL,0,0);
     end;
end;



procedure TfrmRel_Clientes_APP.CarregaParametros;
var
 sDiretorio: string;
begin
   try
  //sDiretorio := GetCurrentDir;
  sDiretorio :='C:\Rel_Clientes_APP';
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
