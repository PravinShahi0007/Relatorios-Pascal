program pRelConsistCaixa;

uses
  Forms,
  uRelConsistCaixa in 'uRelConsistCaixa.pas' {frmRel_Consist_Caixa},
  uFuncoes in 'ufuncoes.pas',
  UFunc in 'uFunc.pas',
  uCarregaSenha in 'uCarregaSenha.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmRel_Consist_Caixa, frmRel_Consist_Caixa);
  Application.Run;
end.
