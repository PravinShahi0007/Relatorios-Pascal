program pRel_Venda_Dia_Email_RegioesNovas;

uses
  Vcl.Forms,
  uFunc in 'uFunc.pas',
  ufuncoes in 'ufuncoes.pas',
  Vcl.Themes,
  Vcl.Styles,
  Encryp in 'Encryp.pas',
  uCarregaSenha in 'uCarregaSenha.pas',
  uRel_Venda_Dia_Email in 'uRel_Venda_Dia_Email.pas' {frmRel_Venda_dia_Email};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10');
  Application.CreateForm(TfrmRel_Venda_dia_Email, frmRel_Venda_dia_Email);
  Application.CreateForm(TfrmRel_Venda_dia_Email, frmRel_Venda_dia_Email);
  Application.Run;
end.

