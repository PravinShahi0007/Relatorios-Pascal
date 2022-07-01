unit uGera_arquivo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Mask, Buttons, Grids, Encryp,
  DBGrids, Gauges, ppCache, ppDB, ppDBPipe, ppComm, ppRelatv,
  ppProd, ppClass, ppReport, Db, DBTables, ppBands, TeeProcs, TeEngine,
  ppPrnabl, ppCtrls, ppVar, ppModule, daDatMod, ppViewr, Printers, ComCtrls;

type
  TfrmGeracao = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    btnGerar: TBitBtn;
    btnFechar: TBitBtn;
    pnlMensAviso: TPanel;
    lblMensagem: TLabel;
    Edit10: TEdit;
    edtdta_ini: TMaskEdit;
    edtdta_fim: TMaskEdit;
    Database1: TDatabase;
    Session1: TSession;
    sp_Procedure: TStoredProc;
    Label2: TLabel;
    Edit2: TEdit;
    edtEmpresa: TEdit;
    edt_Uni_Ini: TMaskEdit;
    edt_Uni_Fim: TMaskEdit;
    Edit1: TEdit;
    Edit4: TEdit;
    edtCodGrupo: TMaskEdit;
    Edit5: TEdit;
    cbxProduto: TComboBox;
    sp_cre_analitico: TStoredProc;
    sp_cpp_analitico: TStoredProc;
    StoredProc1: TStoredProc;
    StoredProc3: TStoredProc;
    sp_cpp_sintetico: TStoredProc;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnGerarClick(Sender: TObject);
    procedure edtdta_iniExit(Sender: TObject);
    procedure edtdta_fimExit(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure Gera_Procedure(Sender: TObject);
    procedure edtEmpresaExit(Sender: TObject);
    procedure edtdta_iniEnter(Sender: TObject);
    procedure edtdta_fimEnter(Sender: TObject);
    procedure edt_Uni_IniExit(Sender: TObject);
    procedure edt_Uni_FimExit(Sender: TObject);
    procedure edtCodGrupoKeyPress(Sender: TObject; var Key: Char);
    procedure edtCodGrupoExit(Sender: TObject);
    procedure CarregaParamsBanco;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbxProdutoExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGeracao: TfrmGeracao;
  iNumero : integer;
  sUsuario, sSenha, sBanco : String;

implementation

uses uFuncoes, uCarregaSenha;

{$R *.DFM}

procedure TfrmGeracao.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     case Key of
          VK_RETURN, VK_DOWN: Perform(WM_NEXTDLGCTL,0,0);
          VK_UP : Perform(WM_NEXTDLGCTL,1,0);
          VK_ESCAPE : btnFechar.SetFocus;
     end;
end;

procedure TfrmGeracao.btnGerarClick(Sender: TObject);
begin
     edtEmpresaExit(Sender);
     edtCodGrupoExit(Sender);
     edt_Uni_IniExit(Sender);
     edt_Uni_FimExit(Sender);
     edtdta_iniExit(Sender);
     edtdta_fimExit(Sender);

     pnlMensAviso.Visible := true;
     Gera_Procedure(Sender);
     pnlMensAviso.Visible := false;
end;

procedure TfrmGeracao.edtdta_iniExit(Sender: TObject);
var
  sDia,sMes,sAno : string;
  iPos : integer;
begin
      if (alltrim(edtdta_ini.Text) = '') then
      begin
           Informacao('Data inicial é obrigatória!!!!','Aviso...');
           edtdta_ini.SetFocus;
           Abort;
           Exit;
      end;

      if (Length(AllTrim(edtdta_ini.Text)) < 8) then
      begin
           Informacao('Data no formato inválido.... Digite DDMMAAAA!!!!'+#13+
                      'Por exemplo no dia de hoje '+DateToStr(Date)+', digitar '+copy(DateToStr(Date),1,2)+copy(DateToStr(Date),4,2)+copy(DateToStr(Date),7,4),'Aviso...');
           edtdta_ini.SetFocus;
           Abort;
           Exit;
      end;

      if pos('/',edtdta_ini.Text) = 0 then
      begin
           sDia := Copy(Trim(edtdta_ini.Text),1,2);
           sMes := Copy(Trim(edtdta_ini.Text),3,2);
           sAno := Copy(Trim(edtdta_ini.Text),5,4);
           edtdta_ini.Text := sDia + '/' + sMes + '/' + sAno;
      end;

      if ValidaData(edtdta_ini.Text) then
      begin
           edtdta_ini.SetFocus;
           Abort;
           Exit;
      end;
end;

procedure TfrmGeracao.edtdta_fimExit(Sender: TObject);
var
  sDia,sMes,sAno : string;
  iPos : integer;
begin
      if (alltrim(edtdta_fim.Text) = '') then
      begin
           Informacao('Data final é obrigatória!!!!','Aviso...');
           edtdta_fim.SetFocus;
           Abort;
           Exit;
      end;

      if (Length(AllTrim(edtdta_fim.Text)) < 8) then
      begin
           Informacao('Data no formato inválido.... Digite DDMMAAAA!!!!'+#13+
                      'Por exemplo no dia de hoje '+DateToStr(Date)+', digitar '+copy(DateToStr(Date),1,2)+copy(DateToStr(Date),4,2)+copy(DateToStr(Date),7,4),'Aviso...');
           edtdta_fim.SetFocus;
           Abort;
           Exit;
      end;

      if pos('/',edtdta_fim.Text) = 0 then
      begin
           sDia := Copy(Trim(edtdta_fim.Text),1,2);
           sMes := Copy(Trim(edtdta_fim.Text),3,2);
           sAno := Copy(Trim(edtdta_fim.Text),5,4);
           edtdta_fim.Text := sDia + '/' + sMes + '/' + sAno;
      end;

      if ValidaData(edtdta_fim.Text) then
      begin
           edtdta_fim.SetFocus;
           Abort;
           Exit;
      end;
      if edtdta_ini.Text <> '' then
      begin
           if StrToDate(edtdta_ini.Text) > StrToDate(edtdta_fim.Text) then
           begin
                informacao('A data final não pode ser menor que a data inicial.','Aviso');
                edtdta_ini.SetFocus;
                abort;
                exit;
           end;
      end;
end;

procedure TfrmGeracao.btnFecharClick(Sender: TObject);
begin
     Close;
end;

procedure TfrmGeracao.Gera_Procedure(Sender: TObject);
var
   sArquivo, sOrigem, sDestino, sParametros, sAuxilia_rede : string;
begin
     lblMensagem.Caption := '          Aguarde.....           '+#13+
                            '       Gerando arquivo.....    ';
     pnlMensAviso.Visible := true;
     pnlMensAviso.Update;

     sp_Procedure.close;

     if cbxProduto.ItemIndex < 0 then
         cbxProduto.ItemIndex := 0;


        //         GRZ_CRE_ANALITICO_SP  CRE ANALITICO
     if(cbxProduto.ItemIndex = 3 )  then
     begin
         

            sParametros := ''+edtEmpresa.text+'#'+edtCodGrupo.text+'#'+edt_Uni_Ini.Text+'#'+edt_Uni_Fim.Text+'#'+
                       edtdta_ini.Text+'#'+edtdta_fim.Text+'#'+IntToStr(cbxProduto.ItemIndex)+'#';

       sp_cre_analitico.Params[0].Value := sParametros;

       sp_cre_analitico.ExecProc;

        pnlMensAviso.Visible := false;
        pnlMensAviso.Update;

       lblMensagem.Caption := '             Aguarde.....           '+#13+
                            '        Copiando o arquivo.....    ';
       pnlMensAviso.Visible := true;
       pnlMensAviso.Update;

        if(Trim(copy(edtCodGrupo.Text,2,2) ) = '10') then
        begin
              sAuxilia_rede := 'GRZ';
        
        end;

         if(Trim(copy(edtCodGrupo.Text,2,2) ) = '30') then
        begin
              sAuxilia_rede := 'PRM';
        
        end;

         if(Trim(copy(edtCodGrupo.Text,2,2) ) = '40') then
        begin
              sAuxilia_rede := 'FRG';
        
        end;

           if(Trim(copy(edtCodGrupo.Text,2,2) ) = '50') then
        begin
              sAuxilia_rede := 'TOT';
        
        end;

          if(Trim(edtCodGrupo.Text) = '') then
        begin
              sAuxilia_rede := edtCodGrupo.Text;
        
        end;


      // servidor producao
       sArquivo := 'RENDAS_CRE_ANALITICO_'+copy(edtdta_ini.Text,4,2)+'_'+sAuxilia_rede+'.txt';
      { sOrigem  := '\\GRANETF\SISGRAZ\TECHBOX\'+sArquivo;
       sDestino := '\\GRANETF\NLGESTAO\NLCOMUM\FINANCEIRA\'+sArquivo;

       CopyFile(Pchar(sOrigem),Pchar(sDestino),FALSE);

       if not (CopyFile(Pchar(sOrigem),Pchar(sDestino),FALSE)) then
         Informacao('Erro ao copiar o arquivo '''+sArquivo+'''.','Aviso')
       else   }
         Informacao('O arquivo '''+sArquivo+''' foi copiado com sucesso.','Aviso');

       pnlMensAviso.Visible := false;
      pnlMensAviso.Update;

                       
     end;
              // CPP  Analítico
       if(cbxProduto.ItemIndex = 4 )  then
     begin


            sParametros := ''+edtEmpresa.text+'#'+edtCodGrupo.text+'#'+edt_Uni_Ini.Text+'#'+edt_Uni_Fim.Text+'#'+
                       edtdta_ini.Text+'#'+edtdta_fim.Text+'#1#';

       sp_cpp_analitico.Params[0].Value := sParametros;

       sp_cpp_analitico.ExecProc;

        pnlMensAviso.Visible := false;
        pnlMensAviso.Update;

       lblMensagem.Caption := '             Aguarde.....           '+#13+
                            '        Copiando o arquivo.....    ';
       pnlMensAviso.Visible := true;
       pnlMensAviso.Update;


       if(Trim(copy(edtCodGrupo.Text,2,2) )= '10') then
        begin
              sAuxilia_rede := 'GRZ';
        
        end;

         if(Trim(copy(edtCodGrupo.Text,2,2) ) = '30') then
        begin
              sAuxilia_rede := 'PRM';
        
        end;

         if(Trim(copy(edtCodGrupo.Text,2,2) ) = '40') then
        begin
              sAuxilia_rede := 'FRG';
        
        end;

           if(Trim(copy(edtCodGrupo.Text,2,2) ) = '50') then
        begin
              sAuxilia_rede := 'TOT';
        
        end;

          if(Trim(edtCodGrupo.Text) = '') then
        begin
              sAuxilia_rede := edtCodGrupo.Text;
        
        end;


      // servidor producao
       sArquivo := 'RENDAS_CPP_ANALITICO_'+copy(edtdta_ini.Text,4,2)+'_'+sAuxilia_rede+'.txt';
      { sOrigem  := '\\GRANETF\SISGRAZ\TECHBOX\'+sArquivo;
       sDestino := '\\GRANETF\NLGESTAO\NLCOMUM\FINANCEIRA\'+sArquivo;


       CopyFile(Pchar(sOrigem),Pchar(sDestino),FALSE);

       if not (CopyFile(Pchar(sOrigem),Pchar(sDestino),FALSE)) then
         Informacao('Erro ao copiar o arquivo '''+sArquivo+'''.','Aviso')
       else                                    }
         Informacao('O arquivo '''+sArquivo+''' foi copiado com sucesso.','Aviso');

       pnlMensAviso.Visible := false;
      pnlMensAviso.Update;

                       
     end;


           // CRE Sintético
      if(cbxProduto.ItemIndex = 5 )  then
     begin
         

            sParametros := ''+edtEmpresa.text+'#'+edtCodGrupo.text+'#'+edt_Uni_Ini.Text+'#'+edt_Uni_Fim.Text+'#'+
                       edtdta_ini.Text+'#'+edtdta_fim.Text+'#1#';

       StoredProc1.Params[0].Value := sParametros;
       // sp_cre_sintetico.ExecProc;
       StoredProc1.ExecProc;

        pnlMensAviso.Visible := false;
        pnlMensAviso.Update;

       lblMensagem.Caption := '             Aguarde.....           '+#13+
                            '        Copiando o arquivo.....    ';
       pnlMensAviso.Visible := true;
       pnlMensAviso.Update;

       if(Trim(copy(edtCodGrupo.Text,2,2) ) = '10') then
        begin
              sAuxilia_rede := 'GRZ';
        
        end;

         if(Trim(copy(edtCodGrupo.Text,2,2) ) = '30') then
        begin
              sAuxilia_rede := 'PRM';
        
        end;

         if(Trim(copy(edtCodGrupo.Text,2,2) ) = '40') then
        begin
              sAuxilia_rede := 'FRG';
        
        end;

           if(Trim(copy(edtCodGrupo.Text,2,2) ) = '50') then
        begin
              sAuxilia_rede := 'TOT';
        
        end;

          if(Trim(copy(edtCodGrupo.Text,2,2) ) = '') then
        begin
              sAuxilia_rede := edtCodGrupo.Text;
        
        end;


      // servidor producao
       sArquivo := 'RENDAS_CRE_SINTETICO_'+copy(edtdta_ini.Text,4,2)+'_'+sAuxilia_rede+'.txt';
      { sOrigem  := '\\GRANETF\SISGRAZ\TECHBOX\'+sArquivo;
       sDestino := '\\GRANETF\NLGESTAO\NLCOMUM\FINANCEIRA\'+sArquivo;

       CopyFile(Pchar(sOrigem),Pchar(sDestino),FALSE);

       if not (CopyFile(Pchar(sOrigem),Pchar(sDestino),FALSE)) then
         Informacao('Erro ao copiar o arquivo '''+sArquivo+'''.','Aviso')
       else                               }
         Informacao('O arquivo '''+sArquivo+''' foi copiado com sucesso.','Aviso');

       pnlMensAviso.Visible := false;
      pnlMensAviso.Update;

                       
     end;




           // CPP  Sintético
      if(cbxProduto.ItemIndex = 6 )  then
     begin
         

            sParametros := ''+edtEmpresa.text+'#'+edtCodGrupo.text+'#'+edt_Uni_Ini.Text+'#'+edt_Uni_Fim.Text+'#'+
                       edtdta_ini.Text+'#'+edtdta_fim.Text+'#1#';

       sp_cpp_sintetico.Params[0].Value := sParametros;
       // sp_cre_sintetico.ExecProc;
       sp_cpp_sintetico.ExecProc;

        pnlMensAviso.Visible := false;
        pnlMensAviso.Update;

       lblMensagem.Caption := '             Aguarde.....           '+#13+
                            '        Copiando o arquivo.....    ';
       pnlMensAviso.Visible := true;
       pnlMensAviso.Update;

       if(Trim(copy(edtCodGrupo.Text,2,2) ) = '10') then
        begin
              sAuxilia_rede := 'GRZ';
        
        end;

         if(Trim(copy(edtCodGrupo.Text,2,2) ) = '30') then
        begin
              sAuxilia_rede := 'PRM';
        
        end;

         if(Trim(copy(edtCodGrupo.Text,2,2) ) = '40') then
        begin
              sAuxilia_rede := 'FRG';
        
        end;

           if(Trim(copy(edtCodGrupo.Text,2,2) ) = '50') then
        begin
              sAuxilia_rede := 'TOT';
        
        end;

          if(Trim(edtCodGrupo.Text) = '') then
        begin
              sAuxilia_rede := edtCodGrupo.Text;
        
        end;


      // servidor producao
       sArquivo := 'RENDAS_CPP_SINTETICO_'+copy(edtdta_ini.Text,4,2)+'_'+sAuxilia_rede+'.txt';
      { sOrigem  := '\\GRANETF\SISGRAZ\TECHBOX\'+sArquivo;
       sDestino := '\\GRANETF\NLGESTAO\NLCOMUM\FINANCEIRA\'+sArquivo;


       CopyFile(Pchar(sOrigem),Pchar(sDestino),FALSE);

       if not (CopyFile(Pchar(sOrigem),Pchar(sDestino),FALSE)) then
         Informacao('Erro ao copiar o arquivo '''+sArquivo+'''.','Aviso')
       else             }
         Informacao('O arquivo '''+sArquivo+''' foi copiado com sucesso.','Aviso');

       pnlMensAviso.Visible := false;
      pnlMensAviso.Update;

                       
     end;

           /// arquivo de apropriação
     if((cbxProduto.ItemIndex = 0) OR (cbxProduto.ItemIndex = 1) OR (cbxProduto.ItemIndex = 2) )  then
     begin

          sParametros := ''+edtEmpresa.text+'#'+edtCodGrupo.text+'#'+edt_Uni_Ini.Text+'#'+edt_Uni_Fim.Text+'#'+
                       edtdta_ini.Text+'#'+edtdta_fim.Text+'#'+IntToStr(cbxProduto.ItemIndex)+'#';

     sp_Procedure.Params[0].Value := sParametros;

     sp_Procedure.ExecProc;

     pnlMensAviso.Visible := false;
     pnlMensAviso.Update;

     lblMensagem.Caption := '             Aguarde.....           '+#13+
                            '        Copiando o arquivo.....    ';
     pnlMensAviso.Visible := true;
     pnlMensAviso.Update;

// servidor producao
      sArquivo := 'Apropriacao_'+edtCodGrupo.Text+'.txt';
    {  sOrigem  := '\\GRANETF\SISGRAZ\TECHBOX\'+sArquivo;
      sDestino := '\\GRANETF\NLGESTAO\NLCOMUM\FINANCEIRA\'+sArquivo;

     CopyFile(Pchar(sOrigem),Pchar(sDestino),FALSE);

     if not (CopyFile(Pchar(sOrigem),Pchar(sDestino),FALSE)) then
         Informacao('Erro ao copiar o arquivo '''+sArquivo+'''.','Aviso')
     else             }
         Informacao('O arquivo '''+sArquivo+''' foi copiado com sucesso.','Aviso');

     pnlMensAviso.Visible := false;
     pnlMensAviso.Update;




     end;

      

end;

procedure TfrmGeracao.edtEmpresaExit(Sender: TObject);
begin
     if alltrim(edtEmpresa.Text) = '' then
        edtEmpresa.Text := '1';

      Try
      iNumero := StrToInt(Trim(edtEmpresa.Text));
      Except on EConvertError do
          begin
               Informacao('Empresa inválida!','Aviso');
               edtEmpresa.SetFocus;
               Abort;
               Exit;
           end;
      end;
      if StrToInt(edtEmpresa.Text) <= 0 then
      begin
           Informacao('Empresa inválida!','Aviso');
           edtEmpresa.SetFocus;
           Abort;
           Exit;
      end;
end;

procedure TfrmGeracao.edtdta_iniEnter(Sender: TObject);
var
  iPos : integer;
begin
     iPos := pos('/',edtdta_ini.Text);
     if iPos <> 0 then
     begin
          edtdta_ini.Text := copy(edtdta_ini.Text,1,2) + copy(edtdta_ini.Text,4,2) + copy(edtdta_ini.Text,7,4);
          edtdta_ini.Setfocus;
     end;
end;

procedure TfrmGeracao.edtdta_fimEnter(Sender: TObject);
var
  iPos : integer;
begin
     iPos := pos('/',edtdta_fim.Text);
     if iPos <> 0 then
     begin
          edtdta_fim.Text := copy(edtdta_fim.Text,1,2) + copy(edtdta_fim.Text,4,2) + copy(edtdta_fim.Text,7,4);
          edtdta_fim.Setfocus;
     end;
end;

procedure TfrmGeracao.edt_Uni_IniExit(Sender: TObject);
begin
      if edt_Uni_Ini.Text = '' then
         edt_Uni_Ini.Text := '0000000';

      Try
      iNumero := StrToInt(Trim(edt_Uni_Ini.Text));
      Except on EConvertError do
          begin
               Informacao('Valor inválido!','Aviso');
               edt_Uni_Ini.SetFocus;
               Abort;
               Exit;
           end;
      end;
end;

procedure TfrmGeracao.edt_Uni_FimExit(Sender: TObject);
begin
      if (trim(edt_Uni_Fim.Text) = '') or (trim(edt_Uni_Fim.Text) = '0') then
         edt_Uni_Fim.Text := '9999999';

      Try
      iNumero := StrToInt(Trim(edt_Uni_Fim.Text));
      Except on EConvertError do
          begin
               Informacao('Valor inválido!','Aviso');
               edt_Uni_Fim.SetFocus;
               Abort;
               Exit;
           end;
      end;

      if (trim(edt_Uni_Ini.text)) = '' then
           edt_Uni_Ini.text := '0000000';

      if (trim(edt_Uni_Ini.text)) <> '' then
      begin
           if (StrToInt(edt_Uni_Ini.text)) > (StrToInt(edt_Uni_Fim.text)) then
           begin
                Informacao('Valor da Unidade Final não pode ser menor que o Unidade Inicial.'+#13+
                           'Digite novamente.','Aviso');
                edt_Uni_Ini.SetFocus;
                Abort;
                exit;
           end;
      end;
end;

procedure TfrmGeracao.edtCodGrupoKeyPress(Sender: TObject; var Key: Char);
var
  codigo : boolean;
begin
     case key of
        '0'..'9' : codigo := true;
        chr(8)   : codigo := true;
        chr(13)  : codigo := true;
     else
         codigo := false;
     end;

     if codigo = false then
        abort;
end;

procedure TfrmGeracao.edtCodGrupoExit(Sender: TObject);
begin
     if (trim(edtCodGrupo.Text) = '')  then
     begin
          Informacao('É necessário que se informe um grupo de unidades.','Aviso');
          edtCodGrupo.SetFocus;
          Abort;
          Exit;
     end;

     Try
     iNumero := StrToInt(Trim(edtCodGrupo.Text));
     Except on EConvertError do
         begin
              Informacao('Grupo inválido!','Aviso');
              edtCodGrupo.SetFocus;
              Abort;
              Exit;
          end;
     end;

     if StrToInt(trim(edtCodGrupo.Text)) <= 0  then
     begin
          Informacao('Grupo de Unidades é inválido','Aviso');
          edtCodGrupo.SetFocus;
          Abort;
          Exit;
     end;

    { if not ((trim(edtCodGrupo.Text) = '910') or (trim(edtCodGrupo.Text) = '920')
          or (trim(edtCodGrupo.Text) = '930') or (trim(edtCodGrupo.Text) = '940')
          or (trim(edtCodGrupo.Text) = '950') or (trim(edtCodGrupo.Text) = '960')) then
     begin
          Informacao('Grupo de Unidades inválido.','Aviso');
          edtCodGrupo.SetFocus;
          Abort;
          Exit;
     end; }
end;

procedure TfrmGeracao.CarregaParamsBanco;
var TomEncryption1: TTomEncryption;
begin
    TomEncryption1 := TTomEncryption.Create(Self);
    CarregaSenhasBancoOra('GRZPNL',TomEncryption1,sUsuario,sSenha,sBanco);
end;

procedure TfrmGeracao.FormShow(Sender: TObject);
begin
   Session1.Active := False;
   Database1.Connected := False;

   CarregaParamsBanco;

   Database1.KeepConnection := False;
   Database1.LoginPrompt := False;

   Database1.Params.Values['SERVER NAME'] := sBanco;
   Database1.Params.Values['USER NAME'] := sUsuario;
   Database1.Params.Values['PASSWORD'] := sSenha;

   try
      Database1.Connected := True;
      Session1.Active := True;
   except
      Informacao('Erro!!!'+#13+'Não pode se conectar ao banco!!!','Aviso!!!');
      frmGeracao.Close;
   end;
end;

procedure TfrmGeracao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   try
      if Session1.Active then
         Session1.Active := False;
      if Database1.Connected then
         Database1.Connected := False;
   except
      Informacao('Não foi possível se Desconectar do Banco!!! Tente Novamente!!!', 'Atenção');
      Abort;
   end;
end;

procedure TfrmGeracao.cbxProdutoExit(Sender: TObject);
begin
      btnGerar.SetFocus;
end;

end.
