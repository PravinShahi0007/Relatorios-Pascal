program pConciliacaoCPPCaixas;

uses
  Forms,
  uConciliacaoCPPCaixas in 'uConciliacaoCPPCaixas.pas' {frmRelDivCPP_Caixa},
  uFuncoes in 'ufuncoes.pas',
  UFunc in 'uFunc.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmRelDivCPP_Caixa, frmRelDivCPP_Caixa);
  Application.Run;
end.
