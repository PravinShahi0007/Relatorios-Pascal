program pGera_Apropriacao_Financeira;

uses
  Forms,
  uGera_arquivo in 'uGera_arquivo.pas' {frmGeracao},
  uFuncoes in 'Ufuncoes.pas',
  uCarregaSenha in 'uCarregaSenha.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Interface Produtos';
  Application.CreateForm(TfrmGeracao, frmGeracao);
  Application.Run;
end.
