program pEnviaEmailsCupons;

uses
  Forms,
  uEnviaEmailCupons in 'uEnviaEmailCupons.pas' {frmPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
