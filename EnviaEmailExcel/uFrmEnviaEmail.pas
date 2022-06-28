unit uFrmEnviaEmail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.Oracle,
  FireDAC.Phys.OracleDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, ACBrBase, ACBrMail, Vcl.StdCtrls, System.IniFiles,
  Vcl.Grids, Vcl.DBGrids, COMOBJ, IdMessageClient, IdAttachmentFile,
  IdBaseComponent, IdMessage, ShellApi, Tlhelp32,PsAPI,Registry,System.IOUtils;

type
  TForm1 = class(TForm)
    btnExecutar: TButton;
    ACBrMail1: TACBrMail;
    function GeraEmail(): Boolean;
    procedure AbreSistema;
    procedure btnExecutarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Log(texto: string);
    function KillTask(ExeFileName: string): Integer;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  sDiretorio, sEmailCC, sEmailGrz: String;
  Timer, Data: tDateTime;
  iIndGrz, iIndPrm, iIndArr, iIndFrg, iIndTot: Integer;
  sUsuario, sParametro, sData: String;
  iArqIni: tIniFile;
  sAssunto, sEmailFrom, sUserName, sPassword, sNome, sHost, sPort, sEmailLojas, sEmailRegioes,
  sExecutaRegioes, sExecutaLojas,
  FileLojasXLSX,FileRegioesXLSX,ExecutaLojasXLSX,ExecutaRegioesXLSX: String;

implementation

{$R *.dfm}

procedure TForm1.AbreSistema;
begin
  try
    // sDiretorio := GetCurrentDir;
    sDiretorio := 'C:\EnviaEmailExcel';
    iArqIni := tIniFile.Create(sDiretorio + '\config.ini');
    sHost := iArqIni.ReadString('EMAIL', 'Host', '');
    sPort := iArqIni.ReadString('EMAIL', 'Port', '');
    sEmailGrz := iArqIni.ReadString('EMAIL', 'Grz', '');
    sEmailLojas := iArqIni.ReadString('EMAIL', 'FileLojas', '');
    sEmailRegioes := iArqIni.ReadString('EMAIL', 'FileRegioes', '');
    sExecutaRegioes := iArqIni.ReadString('EMAIL', 'ExecutaRegioes', '');
    sExecutaLojas := iArqIni.ReadString('EMAIL', 'ExecutaLojas', '');
    FileLojasXLSX := iArqIni.ReadString('EMAIL', 'FileLojasXLSX', '');
    FileRegioesXLSX := iArqIni.ReadString('EMAIL', 'FileRegioesXLSX', '');
    ExecutaLojasXLSX := iArqIni.ReadString('EMAIL', 'ExecutaLojasXLSX', '');
    ExecutaRegioesXLSX := iArqIni.ReadString('EMAIL', 'ExecutaRegioesXLSX', '');

    sAssunto := iArqIni.ReadString('EMAIL FROM', 'Assunto', '');
    sEmailFrom := iArqIni.ReadString('EMAIL FROM', 'Endereco', '');
    sUserName := iArqIni.ReadString('EMAIL FROM', 'UserName', '');
    sPassword := iArqIni.ReadString('EMAIL FROM', 'Password', '');
    sNome := iArqIni.ReadString('EMAIL FROM', 'Nome', '');
    sEmailCC := iArqIni.ReadString('EMAIL_CC', 'Copia', '');
    iArqIni.Free;

  except
    ShowMessage('Erro: N�o carregou arquivo de configura��o.' + chr(13) +
      'Verifique!!!!' + chr(13) + sDiretorio + '\config.ini');
    Log('Erro: N�o carregou arquivo de configura��o.' + sDiretorio +
      '\config.ini');
    Application.Terminate;
    exit;
  end;
end;

procedure TForm1.btnExecutarClick(Sender: TObject);
begin
   GeraEmail;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  AbreSistema;
  ShellExecute(GetDesktopWindow,'open',PChar(sExecutaRegioes), '','',SW_SHOWNORMAL);
  Sleep(60000);
  ShellExecute(GetDesktopWindow,'open',PChar(sExecutaLojas), '','',SW_SHOWNORMAL);
  Sleep(60000);

  ShellExecute(GetDesktopWindow,'open',PChar(ExecutaRegioesXLSX), '','',SW_SHOWNORMAL);
  Sleep(60000);
  Sleep(60000);
  Sleep(60000);
  Sleep(60000);
  Sleep(60000);
  ShellExecute(GetDesktopWindow,'open',PChar(ExecutaLojasXLSX), '','',SW_SHOWNORMAL);
  Sleep(60000);
  Sleep(60000);
  Sleep(60000);
  Sleep(60000);
  Sleep(60000);
  Sleep(60000);
  DeleteFile(sEmailLojas);
  DeleteFile(sEmailRegioes);
  sEmailLojas := FileLojasXLSX;
  sEmailRegioes := FileRegioesXLSX;
  btnExecutarClick(Sender);
  DeleteFile(sEmailLojas);
  DeleteFile(sEmailRegioes);
   try
      KillTask('msedge.exe');
   except
         //segue a execu��o...
   end;
  Application.Terminate;
end;

function TForm1.GeraEmail: Boolean;
begin

  try
    ACBrMail1.From := sEmailFrom;
    ACBrMail1.FromName := sNome;
    ACBrMail1.Host := sHost;
    ACBrMail1.Username := sUserName;
    ACBrMail1.Password := sPassword;
    ACBrMail1.Port := sPort;
    ACBrMail1.AddAddress(sEmailGrz);
    ACBrMail1.AddCC(sEmailCC);
    ACBrMail1.Subject := sAssunto;
    ACBrMail1.IsHTML := True;
    ACBrMail1.Body.Text := '';
    ACBrMail1.SetTLS := True;
    ACBrMail1.AddAttachment(sEmailLojas);
    ACBrMail1.AddAttachment(sEmailRegioes);
    ACBrMail1.Send;


    Log('Enviando Email Para: ' + sEmailFrom);

  except
    on e: Exception do
    begin
      Log(e.ClassName + ' - ' + e.Message);
      exit;
    end;
  end;

end;

function TForm1.KillTask(ExeFileName: string): Integer;
const
     PROCESS_TERMINATE = $0001;
var
   ContinueLoop: BOOL;
   FSnapshotHandle: THandle;
   FProcessEntry32: TProcessEntry32;
begin
      Result := 0;
      FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
      FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
      ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
      while Integer(ContinueLoop) <> 0 do
      begin
        if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
          UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
          UpperCase(ExeFileName))) then
          Result := Integer(TerminateProcess(
                            OpenProcess(PROCESS_TERMINATE,
                                        BOOL(0),
                                        FProcessEntry32.th32ProcessID),
                                        0));
         ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
      end;
      CloseHandle(FSnapshotHandle);
end;

procedure TForm1.Log(texto: string);
Var
  sArq: string;
  f: TextFile;
  fb: file of byte;
  iSize: Integer;
begin
  sArq := sDiretorio + '\log.log';
  try
    try
      if not FileExists(sArq) then
      Begin
        Rewrite(f, sArq);
        CloseFile(f);
      end;
      AssignFile(fb, sArq);
      Reset(fb);
      iSize := FileSize(fb);
      CloseFile(fb);
      if iSize > 1048576 then
        DeleteFile(pChar(sArq));
      AssignFile(f, sArq);
      if not FileExists(sArq) then
        Rewrite(f, sArq);
      Append(f);
      Writeln(f, '---->' + FormatDateTime('dd/mm/yyyy hh:nn:ss:zzz', now) +
        ':' + texto);
    finally
      CloseFile(f);
    end;
  except
    exit;
  end;

end;

function KillTask(ExeFileName: string): Integer;
begin

end;
end.
