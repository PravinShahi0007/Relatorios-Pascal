program pRel_Clientes_APP;

uses
  Vcl.Forms,
  uRel_Clientes_APP in 'uRel_Clientes_APP.pas' {frmRel_Clientes_APP},
  uFunc in 'uFunc.pas',
  ufuncoes in 'ufuncoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.ShowMainForm := False;
  Application.CreateForm(TfrmRel_Clientes_APP, frmRel_Clientes_APP);
  // Application.Run;
  Application.Terminate;
end.
