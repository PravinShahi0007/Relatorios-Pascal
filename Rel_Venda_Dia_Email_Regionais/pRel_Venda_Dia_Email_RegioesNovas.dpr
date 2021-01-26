program pRel_Venda_Dia_Email_RegioesNovas;

uses
  Vcl.Forms,
  uRel_Venda_Dia_Email in 'uRel_Venda_Dia_Email.pas' {frmRel_Venda_dia_Email},
  uFunc in 'uFunc.pas',
  ufuncoes in 'ufuncoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.ShowMainForm := False;
  Application.CreateForm(TfrmRel_Venda_dia_Email, frmRel_Venda_dia_Email);
 // Application.Run;
  Application.Terminate;
end.
