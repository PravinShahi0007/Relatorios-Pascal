program pGeraKPIeVenda;

uses
  Vcl.Forms,
  uGeraKPIeVenda in 'uGeraKPIeVenda.pas' {frmGeraKPI},
  Encryp in 'Encryp.pas',
  uCarregaSenha in 'uCarregaSenha.pas',
  UFuncoes in 'UFuncoes.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Amakrits');
  Application.CreateForm(TfrmGeraKPI, frmGeraKPI);
  Application.Run;
end.
