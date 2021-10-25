unit uRel_Venda_Dia_Email;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.Oracle,
  FireDAC.Phys.OracleDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, ppDB, ppDBPipe, ppParameter, ppDesignLayer,
  ppModule, daDataModule, ppCtrls, ppBands, ppClass, ppStrtch, ppMemo, ppVar,
  ppPrnabl, ppCache, ppComm, ppRelatv, ppProd, ppReport, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, ACBrBase, ACBrMail, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, System.IniFiles, Vcl.Grids, Vcl.DBGrids, Vcl.Themes,
  Vcl.Styles;

type
  TfrmRel_Venda_dia_Email = class(TForm)
    fdcEmail: TFDConnection;
    FDPhysOracleDriverLink1: TFDPhysOracleDriverLink;
    ACBrMail1: TACBrMail;
    qryDta: TFDQuery;
    qryRelVenda: TFDQuery;
    dtsRelVenda: TDataSource;
    pprVda_Venda_Temp: TppReport;
    prbCab: TppHeaderBand;
    ppShape1: TppShape;
    ppShape4: TppShape;
    ppLabel1: TppLabel;
    prlMes: TppLabel;
    prlEmissao: TppLabel;
    ppLabel7: TppLabel;
    ppSystemVariable1: TppSystemVariable;
    ppLabel2: TppLabel;
    ppColumnHeaderBand1: TppColumnHeaderBand;
    prbDetalhe: TppDetailBand;
    ppMemo1: TppMemo;
    ppDBText4: TppDBText;
    prlValor: TppDBText;
    prlPercentual: TppDBText;
    ppLine1: TppLine;
    ppLine2: TppLine;
    ppdVlrAcum: TppDBText;
    ppdPerAcum: TppDBText;
    ppDBText5: TppDBText;
    ppDBText6: TppDBText;
    ppdPerMeta: TppDBText;
    ppDBText1: TppDBText;
    ppLine3: TppLine;
    ppdDiaImpresso: TppDBText;
    ppdDtaMovimento: TppDBText;
    ppMargem: TppDBText;
    ppDBText3: TppDBText;
    ppColumnFooterBand1: TppColumnFooterBand;
    ppGroup2: TppGroup;
    ppGroupHeaderBand2: TppGroupHeaderBand;
    ppGroupFooterBand2: TppGroupFooterBand;
    ppGroup1: TppGroup;
    prbCabecalho: TppGroupHeaderBand;
    mmoCabecalho: TppMemo;
    ppShape2: TppShape;
    prlCodLoja: TppDBText;
    prlDescricaoLoja: TppDBText;
    ppLabel13: TppLabel;
    ppdLoja: TppDBText;
    ppLabel3: TppLabel;
    ppLabel12: TppLabel;
    ppLabel14: TppLabel;
    ppLabel15: TppLabel;
    ppLabel16: TppLabel;
    ppLabel17: TppLabel;
    ppLabel18: TppLabel;
    ppLabel19: TppLabel;
    ppLabel8: TppLabel;
    ppLabel10: TppLabel;
    ppLabel11: TppLabel;
    prbRodape: TppGroupFooterBand;
    ppShape3: TppShape;
    mmoRodape: TppMemo;
    prlVlrAcumAno: TppDBText;
    pVlrOrcadoDia: TppDBText;
    ppLabel4: TppLabel;
    ppLabel5: TppLabel;
    ppDBText7: TppDBText;
    ppLabel6: TppLabel;
    ppLabel9: TppLabel;
    ppDBText2: TppDBText;
    ppLabel20: TppLabel;
    ppDBCalc1: TppDBCalc;
    ppLabel21: TppLabel;
    ppLabel22: TppLabel;
    ppLabel23: TppLabel;
    ppLabel24: TppLabel;
    ppDBText8: TppDBText;
    ppDBText9: TppDBText;
    ppDBText10: TppDBText;
    ppDBText11: TppDBText;
    daDataModule1: TdaDataModule;
    ppDesignLayers1: TppDesignLayers;
    ppDesignLayer1: TppDesignLayer;
    ppParameterList1: TppParameterList;
    pplVda_Venda_Temp: TppDBPipeline;
    dtsEmailRegional: TDataSource;
    qryEmailRegional: TFDQuery;
    pnlRodape: TPanel;
    btnGerar: TBitBtn;
    pnlFundo: TPanel;
    grdEmailRegional: TDBGrid;
    qryEmailRegionalCOD_REGIAO: TBCDField;
    qryEmailRegionalEMAIL_REGIONAL: TStringField;
    chbEMailTeste: TCheckBox;
    procedure PreencheEstilos(Sender: TObject);
    procedure LimpaPdf;
    procedure btnGerarClick(Sender: TObject);
    procedure prbDetalheBeforePrint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    mmoEstilos: TMemo;
    aEstilos: array of String;
  end;

var
  frmRel_Venda_dia_Email: TfrmRel_Venda_dia_Email;
  iArqIni: TIniFile;
  sEmail,sAssunto,sEmailFrom,sUserName,sPassword,sNome,sCopia_oculta,
      sDataMax: String;

implementation

{$R *.dfm}

uses ufuncoes, uFunc;

procedure TfrmRel_Venda_dia_Email.PreencheEstilos(Sender: TObject);
var
   sEstilos: String;
   iInd,iEstilos: Integer;
begin
     mmoEstilos := TMemo.Create(Self);
     mmoEstilos.Parent := self;
     mmoEstilos.Name := 'mmoEstilos'; // Caso vc queira nomeá-lo
     mmoEstilos.Visible := False;

     mmoEstilos.Lines.Clear;

     for sEstilos in TStyleManager.StyleNames do
         mmoEstilos.Lines.Add(sEstilos);

     iEstilos := mmoEstilos.Lines.Count;
     SetLength(aEstilos, iEstilos);

     for iInd := 0 to iEstilos do
         aEstilos[iInd] := mmoEstilos.Lines[iInd];

     Randomize;
     iEstilos := Random(40);

     TStyleManager.TrySetStyle(aEstilos[iEstilos]);
end;

procedure TfrmRel_Venda_dia_Email.btnGerarClick(Sender: TObject);
var
    sMes, sAno, sParametros, sUsuario,
    sDia, sDt_Inicial, sDt_Final, sSQL,sSQLEmail, sCodEmp,sCaminhoArquivo,sNomeArquivo,sCodRegiao,sDiretorio : String;
    Size : Cardinal;
begin
     LimpaPdf;

     sMes  := copy(DateToStr(Date-1),4,2);
     sAno  := copy(DateToStr(Date-1),7,4);

     qryEmailRegional.SQL.Text :=  '';
     qryEmailRegional.Active := False;
     qryEmailRegional.SQL.Text := ' select cod_regiao,email_regional '+
                                  ' from grz_email_regional '+
                                  ' where cod_regiao >= 8701 '+
                                  ' and cod_regiao <= 8725 '+
                                  ' order by email_regional';
     qryEmailRegional.Active := True;

     while not qryEmailRegional.Eof do  // faz o laço de repetição enquanto tiver registros
     begin
          sCaminhoArquivo := 'C:\Rel_Venda_Regiao_Email_Regionais\';
          sCodRegiao := qryEmailRegional.FieldByName('cod_regiao').value;

          sSQL := '';
          sSQL := ' select * from grazz.vda_venda_ano   ' +
                  ' where  ind_nivel in (1,2) '+
                  ' and cod_regiao =' +sCodRegiao+
                  ' and ano >= '+sAno+' - 2 '+
                  ' and mes = '+sMes+
                  ' order by ind_nivel desc, cod_emp, cod_unidade, ano, dta_movimento ';

          sDia := '01';
          sDt_Inicial  := PadLeft(sDia+'/'+sMes+'/'+sAno,8,'0');
          sDt_Final  := PadLeft(sDia+'/'+sMes+'/'+sAno,8,'0');
          prlMes.Caption := 'Mês/Ano - '+sMes+'/'+sAno;
          prlEmissao.Caption := 'Emissão - '+DateToStr(Date());

          if qryRelVenda.Active then
             qryRelVenda.Active := false;

          qryRelVenda.SQL.Clear;
          qryRelVenda.SQL.Add(sSQL);

          if not qryRelVenda.Active then
             qryRelVenda.open;

          sNomeArquivo := 'VendasPorRegião_'+sCodRegiao+'_'+Elimina_Caracteres(DateToStr(date),'/','')+'.pdf';
          pprVda_Venda_Temp.AllowPrintToFile := True;
          pprVda_Venda_Temp.DeviceType := 'PDF';
          pprVda_Venda_Temp.ShowPrintDialog := False;
          pprVda_Venda_Temp.TextFileName := sCaminhoArquivo+sNomeArquivo;
          pprVda_Venda_Temp.Print;

          try
             sDiretorio :='C:\Rel_Venda_Regiao_Email_Regionais\';
             iArqIni := TIniFile.Create(sDiretorio+'\config.ini');
             // Check BOX para testar o envio, se estiver marcado, envia para o e-mail do caption...
             // Modifique conforme seu e-mail para teste...
             if (chbEMailTeste.Checked) then
                sEmail := '390186@grazziotin.com.br'
             else
                 sEmail := qryEmailRegional.FieldByName('email_regional').AsString;
             sAssunto := iArqIni.ReadString('EMAIL FROM','Assunto','');
             sEmailFrom := iArqIni.ReadString('EMAIL FROM','Endereco','');
             sUserName := iArqIni.ReadString('EMAIL FROM','UserName','');
             sPassword := iArqIni.ReadString('EMAIL FROM','Password','');
             sNome := iArqIni.ReadString('EMAIL FROM','Nome','');
             sCopia_oculta :=  iArqIni.ReadString('EMAIL FROM','copia_oculta','');
             // ShowMessage(sEmailFrom);
             // ShowMessage(sEmail);
             // ShowMessage(sCopia_oculta);
             iArqINI.Free;
          except
                ShowMessage('Erro: Não carregou arquivo de configuração.'+chr(13)+
                            'Verifique!!!!'+chr(13)+
                sDiretorio+'\config.ini');
                Application.Terminate;
                Exit;
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
          ACBrMail1.Body.Text :=  '';
          AcbrMail1.SetTLS := True;
          ACBrMail1.AddAttachment(sCaminhoArquivo+sNomeArquivo);
          ACBrMail1.Send;
          Delay(100);

          qryEmailRegional.Next;// vai para a proxima linha
     end;
     Close;
end;

procedure TfrmRel_Venda_dia_Email.FormActivate(Sender: TObject);
begin
     btnGerarClick(Sender);
end;

procedure TfrmRel_Venda_dia_Email.FormCreate(Sender: TObject);
begin
     PreencheEstilos(Sender);

     try
        fdcEmail.Params.UserName := 'nl';
        fdcEmail.Params.Password := 'nl';
        fdcEmail.Connected := True;
     except
           on E:EDatabaseError do
           begin
                MessageDlg('Falha ao conectar o banco '+#13+
                           'a aplicação vai fechar!'+#13+
                           E.Message,mtInformation,[mbOk], 0);
                Application.Terminate;
           end;
     end;
     qryDta.Close;
     qryDta.Open;

     if qryDta.RecordCount > 0 then
        sDataMax := qryDta.FieldByName('dta_movimento').AsString
     else
         sDataMax := DateToStr(date - 1);
end;

procedure TfrmRel_Venda_dia_Email.LimpaPdf;
var
   sArq,TempNome: string;
   datacriacao: TDateTime;
   SR: TSearchRec;
   Ret: Integer;

   function FileTimeToDTime(FTime: TFileTime): TDateTime;
   var
      LocalFTime: TFileTime;
      STime: TSystemTime;
   begin
        FileTimeToLocalFileTime(FTime, LocalFTime);
        FileTimeToSystemTime(LocalFTime, STime);
        Result := SystemTimeToDateTime(STime);
   end;

begin
     sArq := 'C:\Rel_Venda_Dia_Email_Regionais\*.pdf';
     ret :=  FindFirst(sArq, faAnyFile, SR);

     try
        while Ret = 0 do
        begin
             datacriacao := FileTimeToDTime(SR.FindData.ftCreationTime);

             if Trunc(datacriacao) < Trunc(Date-1)  then
                DeleteFile(pChar('C:\Rel_Venda_Dia_Email_Regionais\'+SR.Name));

             Ret := FindNext(SR);
        end;
     finally
            FindClose(sr);
     end;
end;

procedure TfrmRel_Venda_dia_Email.prbDetalheBeforePrint(Sender: TObject);
begin
     if StrToFloatDef(fretiraPonto(ppDBText5.Text),0) = 0 then
     begin
          ppDBText5.Visible := False;
          ppDBText6.Visible := False;
     end
     else
     begin
          ppDBText5.Visible := True;
          ppDBText6.Visible := True;
     end;

     if (Trim(ppDBText1.Text) = 'Domingo') or (Trim(ppDBText1.Text) = 'Dom') then
     begin
          ppMemo1.Color := clSilver;
          ppMemo1.Visible := True;
          ppMargem.Left := 2.8400;;
     end
     else
     begin
          ppMemo1.Visible := false;
          ppMargem.Left := 2.3437;
     end;

     if (Trim(ppdDiaImpresso.Text) = 'FF') and (not(Trim(ppDBText1.Text) = 'Domingo') and not(Trim(ppDBText1.Text) = 'Dom')) then
     begin
          ppMemo1.Color := clBtnFace;
          ppMemo1.Visible := True;
          ppdPerMeta.Visible := False;
          ppdDiaImpresso.Visible := True;
     end
     else
     begin
          ppdPerMeta.Visible := True;
          ppdDiaImpresso.Visible := False;
     end;

     if StrToDate(ppdDtaMovimento.Text) > StrToDate(sDataMax) then
     begin
          ppdVlrAcum.Visible := False;
          ppdPerAcum.Visible := False;
          ppMargem.Visible := False;
          ppDBText3.Visible := False;
     end
     else
     begin
          ppdVlrAcum.Visible := True;
          ppdPerAcum.Visible := True;
          ppMargem.Visible := True;
          ppDBText3.Visible := True;
     end;
end;

end.

