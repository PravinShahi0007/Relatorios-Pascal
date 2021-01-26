program pEstoqueCD;

uses
  Vcl.Forms,
  uEstoqueCd in 'uEstoqueCd.pas' {frmEstoqueCD},
  uFunc in 'uFunc.pas',
  ufuncoes in 'ufuncoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.ShowMainForm := False;
  Application.CreateForm(TfrmEstoqueCD, frmEstoqueCD);
  // Application.Run;
  Application.Terminate;
end.
