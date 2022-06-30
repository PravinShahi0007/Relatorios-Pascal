program pEnviaEmailsCupons;

uses
  Forms,
  uEnviaEmailCupons in 'uEnviaEmailCupons.pas' {frmPrincipal},
  Encryp in 'Encryp.pas',
  uCarregaSenha in 'uCarregaSenha.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
