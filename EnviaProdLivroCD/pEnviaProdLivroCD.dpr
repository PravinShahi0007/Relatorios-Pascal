program pEnviaProdLivroCD;

uses
  Vcl.Forms,
  uEnviaProLivroCD in 'uEnviaProLivroCD.pas' {frmEnviaProdLivroCD},
  uFunc in 'uFunc.pas',
  ufuncoes in 'ufuncoes.pas',
  Encryp in 'Encryp.pas',
  uCarregaSenha in 'uCarregaSenha.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.ShowMainForm := False;
  Application.CreateForm(TfrmEnviaProdLivroCD, frmEnviaProdLivroCD);
  // Application.Run;
  Application.Terminate;
end.
